import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:uuid/uuid.dart';
import '../functions/exportFunctions.dart';
import '../functions/importFunctions.dart';
import '../components/navDrawer.dart';
import '../controllers/crmControllers.dart';
import '../functions/otherFunctions.dart';
import '../models/contactItem.dart';
import '../models/customerItem.dart';
import '../models/leadItem.dart';
import '../models/taskItem.dart';
import '../models/userItem.dart';
import '../utils/colors.dart';
import '../utils/customWidgets.dart';
import '../utils/messages.dart';
import '../utils/themes.dart';
import 'tasks/tasksViewScreen.dart';


class CustomTableCalendar extends StatefulWidget {
  const CustomTableCalendar({Key? key}) : super(key: key);

  @override
  _CustomTableCalendarState createState() => _CustomTableCalendarState();
}

class _CustomTableCalendarState extends State<CustomTableCalendar> {
  final todaysDate = DateTime.now();
  var _focusedCalendarDate = DateTime.now();
  final _initialCalendarDate = DateTime(2000);
  final _lastCalendarDate = DateTime(2050);
  DateTime? selectedCalendarDate;
  CalendarFormat calendarFormatVal = CalendarFormat.month;
  Box? tasks;
  TasksCont tasksController = TasksCont();
  List TaskList = [];
  String? token;
  Map<DateTime, List<TaskHive>>? mySelectedEvents;
  final ValueNotifier<List<TaskHive>> _selectedEvents =  ValueNotifier<List<TaskHive>>([]);
  bool loading = false;
  String relatedId = "";
  String assignId = "";
  String? companyId;
  String assignName = "";
  String relatedName = "";

  late Future<List<String>> statusOptions;
  late Future<List<String>> priorityOptions;

  Future<void> getSharedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      assignId = prefs.getString('id')!;
    });
  }

  void functionCall() async {
    await getSharedData();
    Map<String, dynamic>? databaseInfo = await importFunctions.getDatabaseInfo();
    companyId = databaseInfo!['company_id'] ?? '';
  }

  @override
  void initState() {
    super.initState();
    selectedCalendarDate = _focusedCalendarDate;
    mySelectedEvents = {};
    getTasksFromBox();
    functionCall();
    statusOptions = otherFunctions.fetchDropdownOptions("task_status");
    priorityOptions = otherFunctions.fetchDropdownOptions("task_priority");
  }

  Future<void> fetchRelatedNames(String? relatedId) async {
    print("Fetching name for relatedId: $relatedId");
    if (relatedId != null && relatedId.isNotEmpty) {
      String? fetchedName;

      try {
        // Initialize variables for the Hive boxes
        var leadBox = await Hive.openBox<LeadHive>('leads');
        var customerBox = await Hive.openBox<CustomerHive>('customers');
        var contactsBox = await Hive.openBox<ContactHive>('contacts');

        // Check for a match in each box
        bool matchFound = false;

        // Check the Lead box
        for (var lead in leadBox.values) {
          if (lead.id == relatedId) {
            fetchedName = lead.name;
            matchFound = true;
            print("Found lead with name: $fetchedName");
            break;
          }
        }

        // If no match was found in the Lead box, check the Customer box
        if (!matchFound) {
          for (var customer in customerBox.values) {
            if (customer.id == relatedId) {
              fetchedName = customer.name;
              matchFound = true;
              print("Found customer with name: $fetchedName");
              break;
            }
          }
        }

        // If no match was found in the Lead or Customer box, check the Contacts box
        if (!matchFound) {
          for (var contact in contactsBox.values) {
            if (contact.id == relatedId) {
              String fullName = "${contact.fName} ${contact.lName}";
              fetchedName = fullName;
              matchFound = true;
              print("Found contact with name: $fetchedName");
              break;
            }
          }
        }
      } catch (e) {
        print("Error fetching name: $e");
        fetchedName = 'Error';
      }

      // Set the fetched name to the searchController
      relatedName = fetchedName ?? '';
      print("Set searchController.text to: ${searchController.text}");

    } else {
      // Handle case where relatedId is null or empty
      print("relatedId is null or empty.");
      searchController.text = ''; // Set to an empty string
    }
  }
  Future<void> fetchAssignNames(String? assignId) async {
    print("Fetching name for assignId: $assignId");
    if (assignId != null && assignId.isNotEmpty) {
      String? fetchedName;
      try {
        // Initialize variables for the Hive boxes
        var userBox = await Hive.openBox<UsersHive>('users');
        bool matchFound = false;

        // Check the Name box
        for (var name in userBox.values) {
          if (name.id == assignId) {
            String fullName = "${name.fName} ${name.lName}";
            fetchedName = fullName;
            matchFound = true;
            print("Found User with name: $fetchedName");
            break;
          }
        }
      } catch (e) {
        print("Error fetching name: $e");
        fetchedName = 'Error';
      }

      // Set the fetched name to the searchController
      assignName = fetchedName ?? '';
      print("Set searchController.text to: ${assignController.text}");

    } else {
      // Handle case where relatedId is null or empty
      print("assignId is null or empty.");
      assignController.text = ''; // Set to an empty string
    }
  }

  List<TaskHive> _listOfDayEvents(DateTime dateTime) {
    // Convert the selected date to DateTime format (year, month, day)
    DateTime formattedDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    // Initialize an empty list to store tasks for the selected date
    List<TaskHive> dayEvents = [];

    // Check if tasks are not null before accessing them
    if (tasks != null) {
      // Loop through the tasks in the box
      for (int i = 0; i < tasks!.length; i++) {
        TaskHive? task = tasks!.getAt(i);

        // Check if the task is not null
        if (task != null) {
          // Convert task start date to DateTime format
          DateTime? taskStartDate;
          if (task.startDate.isNotEmpty) {
            taskStartDate = DateTime.parse(task.startDate);
          }

          // Compare the task start date with the selected date
          if (taskStartDate != null &&
              taskStartDate.year == formattedDate.year &&
              taskStartDate.month == formattedDate.month &&
              taskStartDate.day == formattedDate.day) {

            // Add the task to the list if it matches the selected date
            dayEvents.add(task);
          }
        }
      }
    }

    // Return the list of tasks for the selected date
    return dayEvents;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: navigationdrawer(),
      appBar: AppBar(
        title: Text('Calendar', style: headerTextStyle),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showTaskDialog(),
        label: const Text('Add Task'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              margin: const EdgeInsets.all(8.0),
              elevation: 5.0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                side: BorderSide(color: Colors.black, width: 2.0),
              ),
              child: TableCalendar(
                onFormatChanged: (newFormat) {
                  setState(() {
                    calendarFormatVal = newFormat;
                    print(calendarFormatVal);
                  });
                },
                availableCalendarFormats: const {
                  CalendarFormat.month: 'Month',
                  CalendarFormat.week: 'Week',
                },
                focusedDay: _focusedCalendarDate,
                firstDay: _initialCalendarDate,
                lastDay: _lastCalendarDate,
                calendarFormat: calendarFormatVal,
                weekendDays: const [DateTime.sunday, 6],
                startingDayOfWeek: StartingDayOfWeek.monday,
                daysOfWeekHeight: 40.0,
                rowHeight: 60.0,
                eventLoader: _listOfDayEvents,
                headerStyle: HeaderStyle(
                  titleTextStyle: TextStyle(
                    color: calendarHeaderTextColor,
                    fontSize: 20.0,
                  ),
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  formatButtonTextStyle:
                  TextStyle(color: calendarHeaderTextColor, fontSize: 16.0),
                  formatButtonDecoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: calendarHeaderIconColor,
                    size: 28,
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: calendarHeaderIconColor,
                    size: 28,
                  ),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekendStyle: TextStyle(color: calendarWeekendDays),
                ),
                calendarStyle: CalendarStyle(
                  weekendTextStyle: TextStyle(color: calendarWeekendDays),
                  todayDecoration: BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: selectedDayColor,
                    shape: BoxShape.circle,
                  ),
                  markerDecoration: BoxDecoration(
                      color: primaryColor, shape: BoxShape.circle),
                ),
                selectedDayPredicate: (currentSelectedDate) {
                  return (isSameDay(
                      selectedCalendarDate!, currentSelectedDate));
                },
                onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
                  if (!isSameDay(selectedCalendarDate, selectedDay)) {
                    setState(() {
                      selectedCalendarDate = selectedDay;
                      _focusedCalendarDate = focusedDay;
                      _selectedEvents.value = _listOfDayEvents(selectedCalendarDate!);
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 20.0,),
            loading ?
            Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            ) :
            _buildTasksWidget(),
          ],
        ),
      ),
    );
  }


  Widget _buildTasksWidget() {
    return ValueListenableBuilder<List<TaskHive>>(
      valueListenable: _selectedEvents,
      builder: (context, tasksForSelectedDate, child) {
        if (tasksForSelectedDate.isEmpty) {
          return const Center(
            child: Text('No Tasks Found'),
          );
        } else {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tasksForSelectedDate.length,
            itemBuilder: (context, index) {
              TaskHive task = tasksForSelectedDate[index];
              return TaskListTile(
                obj: task,
                onEdit: (task) {
                  showTaskDialog(task: task);
                },
                onDelete: (task) {
                  deleteTask(task, index);
                },
              );
            },
          );
        }
      },
    );
  }

  String? relatedTo;
  String? status;
  String? priority;

  TextEditingController subjectController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController dueDateController = TextEditingController();
  TextEditingController assignController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  ExportFunctions exportFunctions = ExportFunctions();
  ImportFunctions importFunctions = ImportFunctions();


  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  var uuid = const Uuid();

  // Date Pick Function
  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2500),
    );
    if (picked != null && picked != startDate) {
      setState(() {
        startDate = picked;
        startDateController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2500),
    );
    if (picked != null && picked != endDate) {
      setState(() {
        endDate = picked;
        dueDateController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }


  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Add Tasks Form
  Future<void> showTaskDialog({TaskHive? task}) async {
    if(task != null ){
      await fetchRelatedNames(task.relatedId);
      await fetchAssignNames(task.assignId);
      print(relatedName);
      subjectController.text = task.subject ?? "";
      status = task.status ?? "";
      relatedTo = task.type ?? "";
      searchController.text = relatedName ?? "";
      relatedId = task.relatedId ?? "";
      startDateController.text = task.startDate ?? "";
      dueDateController.text = task.dueDate ?? "";
      priority = task.priority ?? "";
      assignController.text = assignName ?? "";
      descriptionController.text = task.description ?? "";
    }
    bool isEditMode = task != null;
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Dialog(
                insetPadding: EdgeInsets.zero,
                // backgroundColor: Colors.transparent,
                child: AlertDialog(
                  contentPadding: const EdgeInsets.symmetric(vertical: 20.0),
                  title: isEditMode
                      ? const Center(child: Text('Edit Task'))
                      : const Center(child: Text('Add Task')),
                  content: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        // mainAxisSize: MainAxisSize.min,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10.0,),
                          CustomTextFormField(
                              nameController: subjectController,
                              hintText: "Subject",
                              labelText: "Subject",
                              keyboardType: TextInputType.text,
                              validator: (value){
                                if(value.isEmpty){
                                  return "Please Enter Subject";
                                }
                                return null;
                              },
                              prefixIcon: const Icon(Icons.subject)
                          ),
                          const SizedBox(height: 15.0,),
                          AsyncDropdownButton(
                            futureItems: statusOptions,
                            selectedValue: status,
                            onChanged: (value) {
                              print('Selected Status: $value');
                              setState(() {
                                status = value;
                              });
                            },
                            hintText: "Select Status",
                            labelText: "Status",
                            prefixIcon: const Icon(Icons.person_3),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return null;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15.0,),
                          CustomDropdownButtonFormField(
                            value: relatedTo,
                            hintText: "Select Type",
                            labelText: "Related To",
                            prefixIcon: const Icon(Icons.person_3),
                            onChanged: (value) {
                              print('Related To: $value');
                              setState(() {
                                relatedTo = value;
                              });
                            },
                            items: <String>[
                              "Lead",
                              "Customer",
                              "Contacts",
                              // "Project",
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                alignment: AlignmentDirectional.center,
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return null;
                              }
                              return null;
                            },
                          ),
                          relatedTo == "Lead" ? Column(
                            children: [
                              const SizedBox(height: 10.0,),
                              CustomTextFormField(
                                  onTap: (){
                                    searchLead(context, searchController);
                                  },
                                  nameController: searchController,
                                  hintText: "Search",
                                  labelText: "Search Name",
                                  keyboardType: TextInputType.none,
                                  validator: (value){
                                    if(value.isEmpty){
                                      return null;
                                    }
                                    return null;
                                  },
                                  prefixIcon: const Icon(Icons.search)
                              ),
                            ],
                          ) : Container(),
                          relatedTo == "Customer" ? Column(
                            children: [
                              const SizedBox(height: 10.0,),
                              CustomTextFormField(
                                  onTap: (){
                                    searchCustomer(context, searchController);
                                  },
                                  nameController: searchController,
                                  hintText: "Search",
                                  labelText: "Search Name",
                                  keyboardType: TextInputType.none,
                                  validator: (value){
                                    if(value.isEmpty){
                                      return null;
                                    }
                                    return null;
                                  },
                                  prefixIcon: const Icon(Icons.search)
                              ),
                            ],
                          ) : Container(),
                          relatedTo == "Contacts" ? Column(
                            children: [
                              const SizedBox(height: 10.0,),
                              CustomTextFormField(
                                  onTap: (){
                                    searchContacts(context, searchController);
                                  },
                                  nameController: searchController,
                                  hintText: "Search",
                                  labelText: "Search Name",
                                  keyboardType: TextInputType.none,
                                  validator: (value){
                                    if(value.isEmpty){
                                      return null;
                                    }
                                    return null;
                                  },
                                  prefixIcon: const Icon(Icons.search)
                              ),
                            ],
                          ) : Container(),
                          const SizedBox(height: 10.0,),
                          CustomTextFormField(
                            labelText: "Start Date",
                            hintText: "Date",
                            onTap: () => _selectStartDate(context),
                            keyboardType: TextInputType.none,
                            nameController: startDateController,
                            prefixIcon: const Icon(Icons.calendar_month),
                            validator: (value) {
                              if(value.isEmpty){
                                return "Please Enter Start Date";
                              }
                              else {
                                return null;
                              }
                            },

                          ),
                          const SizedBox(height: 10.0,),
                          CustomTextFormField(
                            labelText: "Due Date",
                            hintText: "Date",
                            onTap: () => _selectDueDate(context),
                            keyboardType: TextInputType.none,
                            nameController: dueDateController,
                            prefixIcon: const Icon(Icons.calendar_month),
                            validator: (value) {
                              if(value.isEmpty){
                                return "Please Enter Due Date";
                              }
                              else {
                                return null;
                              }
                            },

                          ),
                          const SizedBox(height: 15.0,),
                          AsyncDropdownButton(
                            futureItems: priorityOptions,
                            selectedValue: priority,
                            onChanged: (value) {
                              print('Selected Priority: $value');
                              setState(() {
                                priority = value;
                              });
                            },
                            hintText: "Select Priority",
                            labelText: "Priority",
                            prefixIcon: const Icon(Icons.auto_graph),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return null;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10.0,),
                          CustomTextFormField(
                              onTap: (){
                                searchUsers(context, assignController);
                              },
                              nameController: assignController,
                              hintText: "Contact",
                              labelText: "Assign To",
                              keyboardType: TextInputType.none,
                              validator: (value){
                                if(value.isEmpty){
                                  return null;
                                }
                                return null;
                              },
                              prefixIcon: const Icon(Icons.person)
                          ),
                          const SizedBox(height: 10.0,),
                          CustomTextFormField(
                            keyboardType: TextInputType.multiline,
                            labelText: "Description",
                            hintText: "Description",
                            minLines: 1,
                            maxLines: null,
                            nameController: descriptionController,
                            validator: (value) {
                              if(value.isEmpty){
                                return null;
                              }
                              else {
                                return null;
                              }
                            },
                            prefixIcon: const Icon(Icons.sticky_note_2),
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        if(formKey.currentState!.validate()){
                          if (isEditMode) {
                            updateTask(task);
                          } else {
                            addTask();
                          }
                        }
                      },
                      child: Text(isEditMode
                          ? 'Update'
                          : 'Add',
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        clearFields();
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              );
            }
        );
      },
    );
  }

  // Function to handle delete action
  void deleteTask(TaskHive task, int index) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Task'),
          content: const Text('Are you sure you want to delete this Task?'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                // Delete the Task from the database
                try {
                  await otherFunctions.deleteTaskFromDatabase(task.id);
                } catch (e) {
                  print('Error deleting note from database: $e');
                  // Handle error if necessary
                }

                setState(() {
                  tasks!.deleteAt(index);
                });
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  // Add Task Through Hive
  void addTask() async{
    Hive.openBox<TaskHive>("tasks").then((tasksBox) {
      exportFunctions.postTasksToApi(tasksBox);
    });
    print(assignId);
    if(formKey.currentState!.validate()){
      var uid = uuid.v1();
      TaskHive newTask = TaskHive()
        ..id = uid
        ..subject = subjectController.text
        ..status = status!
        ..type = relatedTo!
        ..relatedTo = searchController.text
        ..relatedId = relatedId
        ..contact = assignId
        ..startDate = startDateController.text
        ..dueDate = dueDateController.text
        ..priority = priority!
        ..assignTo = assignController.text
        ..assignId = assignId
        ..companyId = companyId!
        ..description = descriptionController.text
        ..addedAt = DateTime.now();
      await tasks!.add(newTask);
      showSnackMessage(context, "Task Added Successfully");
      clearFields();
    }
    else {
      showSnackMessage(context, "Please Fill Required Fields");
    }
  }

  void clearFields(){
    setState(() {
      subjectController.clear();
      contactController.clear();
      startDateController.clear();
      dueDateController.clear();
      assignController.clear();
      descriptionController.clear();
      relatedTo = null;
      status = null;
      priority = null;
    });
  }

  OtherFunctions otherFunctions = OtherFunctions();

  // Function to update an existing note
  void updateTask(TaskHive task) async {
    print(task.id);
    otherFunctions.updateTaskInDatabase(task);
    task.subject = subjectController.text;
    task.status = status!;
    task.type = relatedTo!;
    task.contact = assignId;
    task.startDate = startDateController.text;
    task.dueDate = dueDateController.text;
    task.relatedTo = searchController.text;
    task.relatedId = relatedId;
    task.assignTo =assignController.text;
    task.assignId = assignId;
    task.description = descriptionController.text;
    task.addedAt = DateTime.now();
    await tasks!.put(task.key, task);
    showSnackMessage(context, "Task Updated Successfully");
    Navigator.pop(context);
    clearFields();
  }

  Future<void> getTasksFromBox() async {
    tasks = await Hive.openBox<TaskHive>('tasks');
    setState(() {});
  }

  void searchCustomer(BuildContext context, TextEditingController textFieldController) async {
    try {
      if (!Hive.isBoxOpen('customers')) {
        await Hive.openBox<CustomerHive>('customers');
      }
      Box contactBox = Hive.box<CustomerHive>('customers');
      List<Map<String, dynamic>> customers = [];
      for (var customer in contactBox.values) {
        customers.add({
          'id': customer.id,
          'name': customer.name,
        });
      }
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Center(child: Text('Customers List')),
            content: SingleChildScrollView(
              child: Column(
                children: customers.map((customer) => ListTile(
                  title: Text('${customer['name']}'),
                  onTap: () {
                    relatedId = customer['id'];
                    textFieldController.text = customer['name'];
                    Navigator.pop(context);
                  },
                )).toList(),
              ),
            ),
          );
        },
      );
    } catch (e) {
      print('Error fetching customer names: $e');
      // Handle error appropriately
    }
  }
  void searchLead(BuildContext context, TextEditingController textFieldController) async {
    try {
      if (!Hive.isBoxOpen('leads')) {
        await Hive.openBox<LeadHive>('leads');
      }

      Box leadBox = Hive.box<LeadHive>('leads');
      List<Map<String, dynamic>> leads = [];
      for (var lead in leadBox.values) {
        leads.add({
          'id': lead.id,
          'name': lead.name,
        });
      }
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Center(child: Text('Leads List')),
            content: SingleChildScrollView(
              child: Column(
                children: leads.map((lead) => ListTile(
                  title: Text('${lead['name']}'),
                  onTap: () {
                    relatedId = lead['id'];
                    textFieldController.text = lead['name'];
                    Navigator.pop(context);
                  },
                )).toList(),
              ),
            ),
          );
        },
      );
    } catch (e) {
      print('Error fetching lead names: $e');
      // Handle error appropriately
    }
  }
  void searchContacts(BuildContext context, TextEditingController textFieldController) async {
    try {
      // Open the Hive box if it's not already open
      if (!Hive.isBoxOpen('contacts')) {
        await Hive.openBox<ContactHive>('contacts');
      }

      // Get the box
      Box contactBox = Hive.box<ContactHive>('contacts');
      List<String> customerNames = [];
      for (var contact in contactBox.values) {
        customerNames.add(
            '${contact.fName} ''${contact.lName}');
      }
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Center(child: Text('Contacts List')),
            content: SingleChildScrollView(
              child: Column(
                children: customerNames.map((id) => ListTile(
                  title: Text(id),
                  onTap: () {
                    textFieldController.text = id;
                    Navigator.pop(context);
                  },
                )).toList(),
              ),
            ),
          );
        },
      );
    } catch (e) {
      print('Error fetching customer names: $e');
      // Handle error appropriately
    }
  }
  void searchUsers(BuildContext context, TextEditingController textFieldController,) async {
    try {
      // Open the Hive box if it's not already open
      if (!Hive.isBoxOpen('users')) {
        await Hive.openBox<UsersHive>('users');
      }

      // Get the box
      Box<UsersHive> userBox = Hive.box<UsersHive>('users');

      // Convert users to a list of maps containing required data
      List<Map<String, dynamic>> userNames = userBox.values.map((user) {
        return {
          'id': user.id,
          'firstName': user.fName,
          'lastName': user.lName,
        };
      }).toList();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Center(child: Text('Users List')),
            content: SingleChildScrollView(
              child: Column(
                children: userNames.map((user) {
                  String displayName = '${user['firstName']} ${user['lastName']}';
                  return ListTile(
                    title: Text(displayName),
                    onTap: () {
                      assignId = user['id'];
                      textFieldController.text = displayName;
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
            ),
          );
        },
      );
    } catch (e) {
      print('Error fetching User names: $e');
      // Handle error appropriately
    }
  }

}