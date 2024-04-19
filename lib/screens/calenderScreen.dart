
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:monmatics/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import '../Functions/exportFunctions.dart';
import '../Functions/importFunctions.dart';
import '../Functions/searchFunctions.dart';
import '../components/navDrawer.dart';
import '../controllers/crmControllers.dart';
import '../models/taskItem.dart';
import '../models/userItem.dart';
import '../utils/customWidgets.dart';
import '../utils/messages.dart';
import '../utils/themes.dart';
import '../utils/urls.dart';
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
  Box? task;
  TasksCont tasksController = TasksCont();
  List TaskList = [];
  String? token;
  Map<DateTime, List<Tasks>>? mySelectedEvents;
    ValueNotifier<List<Tasks>>? _selectedEvents;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    selectedCalendarDate = _focusedCalendarDate;
    mySelectedEvents = {};
    getTasksFromBox();

  }

  List<Tasks> _listOfDayEvents(DateTime dateTime) {
    DateTime formattedDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    return mySelectedEvents?[formattedDate] ?? [];
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
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(selectedCalendarDate, selectedDay)) {
                    setState(() {
                      selectedCalendarDate = selectedDay.toLocal();
                      _selectedEvents = ValueNotifier(_listOfDayEvents(selectedCalendarDate!));
                      _focusedCalendarDate = focusedDay;
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
    if (task == null) {
      return const Center(
          child: CircularProgressIndicator());
    } else if (task!.isEmpty) {
      return const Center(
          child: Text('No Tasks Found'));
    } else {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: task!.length,
        itemBuilder: (context, index) {
          return taskListTile(task!.getAt(index)!);
        },
      );
    }
  }

  String? role;
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

  SearchFunctions searFunctions = SearchFunctions();
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
        startDateController.text =
        "${picked.month.toString().padLeft(2, '0')}/${picked.day.toString()
            .padLeft(2, '0')}/${picked.year}";
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
        dueDateController.text = "${picked.month.toString()
            .padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }


  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // Add Tasks Form
  Future<void> showTaskDialog() async {
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
                  title: const Center(child: Text('Add Task')),
                  content: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        // mainAxisSize: MainAxisSize.min,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                          CustomDropdownButtonFormField(
                            value: status,
                            hintText: "Select Status",
                            labelText: "Status",
                            prefixIcon: const Icon(Icons.person_3),
                            onChanged: (value) {
                              print('Status: $value');
                              setState(() {
                                status = value;
                              });
                            },
                            items: <String>[
                              "Close",
                              "Open",
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                alignment: AlignmentDirectional.center,
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Choose an Option';
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
                                return 'Please Choose an Option';
                              }
                              return null;
                            },
                          ),
                          relatedTo == "Lead" ? Column(
                            children: [
                              const SizedBox(height: 10.0,),
                              CustomTextFormField(
                                  onTap: (){
                                    searFunctions.searchLead(context, contactController);
                                  },
                                  nameController: contactController,
                                  hintText: "Search",
                                  labelText: "Search Name",
                                  keyboardType: TextInputType.none,
                                  validator: (value){
                                    if(value.isEmpty){
                                      return "Please Enter a Value";
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
                                    searFunctions.searchCustomer(context, contactController);
                                  },
                                  nameController: contactController,
                                  hintText: "Search",
                                  labelText: "Search Name",
                                  keyboardType: TextInputType.none,
                                  validator: (value){
                                    if(value.isEmpty){
                                      return "Please Enter a Value";
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
                                    searFunctions.searchContacts(context, contactController);
                                  },
                                  nameController: contactController,
                                  hintText: "Search",
                                  labelText: "Search Name",
                                  keyboardType: TextInputType.none,
                                  validator: (value){
                                    if(value.isEmpty){
                                      return "Please Enter a Value";
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
                          CustomDropdownButtonFormField(
                            value: priority,
                            hintText: "Select Priority",
                            labelText: "Priority",
                            prefixIcon: const Icon(Icons.person_3),
                            onChanged: (value) {
                              print('Priority: $value');
                              setState(() {
                                priority = value;
                              });
                            },
                            items: <String>[
                              "New",
                              "Old",
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                alignment: AlignmentDirectional.center,
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Choose an Option';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10.0,),
                          CustomTextFormField(
                              onTap: (){
                                searFunctions.searchUsers(context, assignController);
                              },
                              nameController: assignController,
                              hintText: "Contact",
                              labelText: "Assign To",
                              keyboardType: TextInputType.none,
                              validator: (value){
                                if(value.isEmpty){
                                  return "Please Enter a Value";
                                }
                                return null;
                              },
                              prefixIcon: const Icon(Icons.person)
                          ),
                          const SizedBox(height: 10.0,),
                          CustomTextFormField(
                            keyboardType: TextInputType.text,
                            labelText: "Description",
                            hintText: "Description",
                            minLines: 1,
                            maxLines: null,
                            nameController: descriptionController,
                            validator: (value) {
                              if(value.isEmpty){
                                return "Please Enter Description";
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
                      onPressed: (){
                        addTask();
                        Navigator.pop(context);
                      },
                      child: const Text('Add'),
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

  // Add Task Through Hive
  void addTask() async{
    if(formKey.currentState!.validate()){
      var uid = uuid.v1();
      TaskHive newTask = TaskHive()
        ..id = uid
        ..subject = subjectController.text
        ..status = status!
        ..type = relatedTo!
        ..contact = contactController.text
        ..startDate = startDateController.text
        ..dueDate = dueDateController.text
        ..priority = priority!
        ..assignTo = assignController.text
        ..description = descriptionController.text;

      await task!.add(newTask);
      showSnackMessage(context, "Task Added Successfully");

      clearFields();
    }
    else {
      showSnackMessage(context, "Please Fill All Fields");
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

  Future<void> getTasksFromBox() async {
    task = await Hive.openBox<TaskHive>('tasks');
    setState(() {});
  }

}