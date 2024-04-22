import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:monmatics/models/contactItem.dart';
import 'package:monmatics/models/customerItem.dart';
import 'package:monmatics/models/leadItem.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../Functions/importFunctions.dart';
import '../components/navDrawer.dart';
import '../components/segmentedBar.dart';
import '../functions/exportFunctions.dart';
import '../functions/otherFunctions.dart';
import '../models/noteItem.dart';
import '../models/taskItem.dart';
import '../models/userItem.dart';
import '../utils/colors.dart';
import '../utils/customWidgets.dart';
import '../utils/messages.dart';
import 'notes/NotesViewScreen.dart';
import 'tasks/tasksViewScreen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currIndex = 0;
  int index = 0;
  Box? notes;
  Box? tasks;
  String? firstName;
  String? lastName;
  String? role;
  String? relatedTo;
  String? status;
  String? priority;
  String? relatedId;
  String? assignId;
  String? companyId;

  TextEditingController subjectController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController dueDateController = TextEditingController();
  TextEditingController assignController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();


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

  Future<void> getSharedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      firstName = prefs.getString('firstName');
      lastName = prefs.getString('lastName');
      role= prefs.getString('role');
      assignId = prefs.getString('id');
    });
  }

  Future<void> functionCall() async {
    await getSharedData();
    Map<String, dynamic>? databaseInfo = await importFunctions.getDatabaseInfo();
    companyId = databaseInfo!['company_id'] ?? '';
  }

  ImportFunctions importFunctions = ImportFunctions();
  ExportFunctions exportFunctions = ExportFunctions();
  OtherFunctions otherFunctions = OtherFunctions();


  @override
  void initState() {
    functionCall();
    formKey = GlobalKey<FormState>();
    super.initState();
    // importFunctions.fetchNotesFromApi();
    // importFunctions.fetchTasksFromApi();
    Hive.openBox<NoteHive>("notes").then((notesBox) {
      exportFunctions.postNotesToApi(notesBox, Ids(assignId!, relatedId!));
    });
    Hive.openBox<TaskHive>("tasks").then((tasksBox) {
      exportFunctions.postTasksToApi(tasksBox, Ids(assignId!, relatedId!));
    });
    getNotesFromBox();
    getTasksFromBox();
  }


  Future<void> getNotesFromBox() async {
    notes = await Hive.openBox<NoteHive>('notes');
    setState(() {});
  }

  Future<void> getTasksFromBox() async {
    tasks = await Hive.openBox<TaskHive>('tasks');
    setState(() {});
  }


  void addNote() async {
    print(assignId);
    print(relatedId);
    Hive.openBox<NoteHive>("notes").then((notesBox) {
      exportFunctions.postNotesToApi(notesBox, Ids(assignId!, relatedId!));
    });
    // importFunctions.fetchNotesFromApi();
    if (formKey.currentState!.validate()) {
      var uid = uuid.v1();
      NoteHive newNote = NoteHive()
        ..id = uid
        ..subject = subjectController.text
        ..relatedTo = relatedTo!
        ..search = searchController.text
        ..relatedId = relatedId!
        ..assignTo = assignController.text
        ..assignId = assignId!
        ..description = descriptionController.text;

      await notes!.add(newNote);
      showSnackMessage(context, "Note Added Successfully");
      Navigator.pop(context);
      clearFields();
    } else {
      showSnackMessage(context, "Please Fill All Fields");
    }
  }

  // Add Task Through Hive
  void addTask() async{
    Hive.openBox<TaskHive>("tasks").then((tasksBox) {
      exportFunctions.postTasksToApi(tasksBox, Ids(assignId!, relatedId!));
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
          ..relatedId = relatedId!
          ..contact = assignId!
          ..startDate = startDateController.text
          ..dueDate = dueDateController.text
          ..priority = priority!
          ..assignTo = assignController.text
          ..assignId = assignId!
          ..companyId = companyId!
          ..description = descriptionController.text;
      await tasks!.add(newTask);
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
      startDateController.clear();
      dueDateController.clear();
      assignController.clear();
      descriptionController.clear();
      searchController.clear();
      relatedTo = null;
      status = null;
      priority = null;
      relatedId = null;
      assignId = null;
    });
  }

  // Function to update an existing note
  void updateNote(NoteHive note) async {
    print(note.id);
    otherFunctions.updateNoteInDatabase(note);
    note.subject = subjectController.text;
    note.relatedTo = relatedTo!;
    note.search = searchController.text;
    note.relatedId = relatedId!;
    note.assignId = assignId!;
    note.assignTo = assignController.text;
    note.description = descriptionController.text;
    await notes!.put(note.key, note);
    showSnackMessage(context, "Note Updated Successfully");
    Navigator.pop(context);
    clearFields();
  }

  // Function to update an existing note
  void updateTask(TaskHive task) async {
    print(task.id);
    otherFunctions.updateTaskInDatabase(task, Ids(assignId!, relatedId!));
    task.subject = subjectController.text;
    task.status = status!;
    task.type = relatedTo!;
    task.contact = assignId!;
    task.startDate = startDateController.text;
    task.dueDate = dueDateController.text;
    task.relatedTo = searchController.text;
    task.relatedId = relatedId!;
    task.assignTo =assignController.text;
    task.assignId = assignController.text;
    task.description = descriptionController.text;

    await tasks!.put(task.key, task);
    showSnackMessage(context, "Task Updated Successfully");
    Navigator.pop(context);
    clearFields();
  }

  // Add Notes Form
  Future<void> showNotesDialog({NoteHive? note}) async {
    if (note != null) {
      subjectController.text = note.subject ?? '';
      relatedTo = note.relatedTo ?? '';
      searchController.text = note.search ?? '';
      relatedId = note.relatedId ?? "";
      assignId = note.assignId ?? "";
      assignController.text = note.assignTo ?? '';
      descriptionController.text = note.description ?? '';
    }
    bool isEditMode = note != null;
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Dialog(
                insetPadding: EdgeInsets.zero,
                child: AlertDialog(
                  contentPadding: const EdgeInsets.symmetric(vertical: 20.0),
                  title: isEditMode
                      ? const Center(child: Text('Edit Note'))
                      : const Center(child: Text('Add Notes')),
                  content: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          CustomTextFormField(
                              nameController: subjectController,
                              hintText: "Subject",
                              labelText: "Subject",
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Please Enter Subject";
                                }
                                return null;
                              },
                              prefixIcon: const Icon(Icons.subject)
                          ),
                          const SizedBox(height: 20.0,),
                          CustomDropdownButtonFormField(
                            value: relatedTo,
                            hintText: "Select",
                            labelText: "Related To",
                            prefixIcon: const Icon(Icons.person_3),
                            onChanged: (value) {
                              print('Related To: $value');
                              setState(() {
                                relatedTo = value;
                              });
                            },
                            items: <String>[
                              "lead",
                              "customer",
                              "project",
                              "",
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
                          relatedTo == "lead"
                              ? Column(
                            children: [
                              const SizedBox(height: 20.0,),
                              CustomTextFormField(
                                onTap: () {
                                  searchLead(context, searchController);
                                },
                                labelText: "Lead Search",
                                hintText: "Lead Name",
                                keyboardType: TextInputType.none,
                                nameController: searchController,
                                prefixIcon: const Icon(Icons.search),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Please Enter a value";
                                  }
                                  else {
                                    return null;
                                  }
                                },
                              )
                            ],
                          )
                              : Container(),
                          relatedTo == "customer"
                              ? Column(
                            children: [
                              const SizedBox(height: 20.0,),
                              CustomTextFormField(
                                onTap: () {
                                  searchCustomer(context, searchController);
                                },
                                labelText: "Customer Search",
                                hintText: "Customer Name",
                                keyboardType: TextInputType.none,
                                nameController: searchController,
                                prefixIcon: const Icon(Icons.search),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Please Enter a value";
                                  }
                                  else {
                                    return null;
                                  }
                                },
                              )
                            ],
                          )
                              : Container(),
                          const SizedBox(height: 20.0,),
                          CustomTextFormField(
                              onTap: (){
                                searchUsers(context, assignController);
                              },
                              nameController: assignController,
                              hintText: "User",
                              labelText: "Assign To",
                              keyboardType: TextInputType.none,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return null;
                                }
                                return null;
                              },
                              prefixIcon: const Icon(Icons.person)
                          ),
                          const SizedBox(height: 20.0,),
                          CustomTextFormField(
                            keyboardType: TextInputType.text,
                            labelText: "Description",
                            hintText: "Description",
                            minLines: 1,
                            maxLines: null,
                            nameController: descriptionController,
                            validator: (value) {
                              if (value.isEmpty) {
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
                      onPressed: () {
                        if (isEditMode) {
                          updateNote(note);
                        } else {
                          addNote();
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

  // Add Tasks Form
  Future<void> showTaskDialog({TaskHive? task}) async {
    if(task != null ){
      subjectController.text = task.subject ?? "";
      status = task.status ?? "";
      relatedTo = task.type ?? "";
      searchController.text = task.relatedTo ?? "";
      relatedId = task.relatedId ?? "";
      startDateController.text = task.startDate ?? "";
      dueDateController.text = task.dueDate ?? "";
      priority = task.priority ?? "";
      assignController.text = task.assignTo ?? "";
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
                              ""
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
                                    searchLead(context, searchController);
                                  },
                                  nameController: searchController,
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
                                    searchCustomer(context, searchController);
                                  },
                                  nameController: searchController,
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
                                    searchContacts(context, searchController);
                                  },
                                  nameController: searchController,
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
                      onPressed: () {
                        if (isEditMode) {
                          updateTask(task);
                        } else {
                          addTask();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: navigationdrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
            Theme.of(context).brightness ==
                Brightness.dark?'assets/White.jpeg':'assets/_Logo.png',
          height: MediaQuery.of(context).size.height*0.05,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Text("${firstName} ${lastName} ${role} ${assignId}"),
              SegmentedWidget(
                  onChanged: (val) {
                    setState(() {
                      index = val;
                    });
                  },
                  index: index,
                  children: const [
                    Text('Notes'),
                    Text('Tasks'),
                    // Text('Events'),
                  ]),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: index == 0
                    ? _buildNotesWidget()
                    : _buildTasksWidget(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? popupmenuButtonCol
            : null,
        onPressed: () {},
        child: PopupMenuButton(
          color: Theme.of(context).brightness == Brightness.light
              ? popupmenuButtonCol
              : null,
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animate) => RotationTransition(
              turns: child.key == const ValueKey('icon0')
                  ? Tween<double>(begin: 1, end: 0.75).animate(animate)
                  : Tween<double>(begin: 0.75, end: 1).animate(animate),
              child: FadeTransition(
                opacity: animate,
                child: child,
              ),
            ),
            child: _currIndex == 0
                ? Icon(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.white
                        : null,
                    Icons.add,
                    key: const ValueKey('icon0'),
                    size: MediaQuery.of(context).size.height * 0.05,
                  )
                : Icon(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.white
                        : null,
                    Icons.close,
                    key: const ValueKey('icon1'),
                    size: MediaQuery.of(context).size.height * 0.05,
                  ),
          ),
          onOpened: () {
            setState(() {
              //_currIndex == 1;
              _currIndex == 0 ? _currIndex = 1 : _currIndex = 0;
            });
          },
          onCanceled: () {
            setState(() {
              _currIndex == 0 ? _currIndex = 1 : _currIndex = 0;
            });
          },
          offset: const Offset(0, -120
              //MediaQuery.of(context).size.width * -0.3
              ),
          position: PopupMenuPosition.over,
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                onTap: () {
                  showNotesDialog();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.event_note_rounded,
                      color: popupmenuItemCol,
                    ),
                    Text(
                      'Notes',
                      style: TextStyle(
                        color: popupmenuItemCol,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                onTap: () {
                  showTaskDialog();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.task,
                      color: popupmenuItemCol,
                    ),
                    Text(
                      'Tasks',
                      style: TextStyle(
                        color: popupmenuItemCol,
                      ),
                    ),
                  ],
                ),
              ),
            ];
          },
        ),
      ),
    );
  }

  Widget _buildNotesWidget() {
    if (notes == null) {
      return const Center(child: CircularProgressIndicator());
    } else if (notes!.isEmpty) {
      return const Center(child: Text('No Notes Found'));
    } else {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: notes!.length,
        itemBuilder: (context, index) {
          return NotesTile(
            obj: notes!.getAt(index)!,
            onEdit: (notes) {
              showNotesDialog(note: notes);
            },
            onDelete: (notes) {
              deleteNote(notes, index);
            },
          );
        },
      );
    }
  }

  // Function to handle delete action
  void deleteNote(NoteHive note, int index) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Note'),
          content: const Text('Are you sure you want to delete this note?'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                // Delete the note from the database
                try {
                  await otherFunctions.deleteNoteFromDatabase(note.id);
                } catch (e) {
                  print('Error deleting note from database: $e');
                  // Handle error if necessary
                }

                // Delete the note from the UI
                setState(() {
                  notes!.deleteAt(index);
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

  Widget _buildTasksWidget() {
    if (tasks == null) {
      return const Center(
          child: CircularProgressIndicator());
    } else if (tasks!.isEmpty) {
      return const Center(
          child: Text('No Tasks Found'));
    } else {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: tasks!.length,
        itemBuilder: (context, index) {
          return TaskListTile(
            obj: tasks!.getAt(index)!,
            onEdit: (tasks) {
              showTaskDialog(task: tasks);
            },
            onDelete: (tasks) {
              deleteTask(tasks, index);
            },
          );
        },
      );
    }
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
