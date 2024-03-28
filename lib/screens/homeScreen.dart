import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/navDrawer.dart';
import '../components/segmentedBar.dart';
import '../utils/colors.dart';
import 'NotesViewScreen.dart';
import 'tasksViewScreen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currIndex = 0;
  int index = 1;
  Box? notes;
  Box? task;
  String? name;
  String? role;

  Future GetSharedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    name = prefs.getString('name');
    role= prefs.getString('role');
  }

  void FunctionCall()async{
    await GetSharedData();
  }

  Future<bool> GetNotesFromBox() async {
    notes = await Hive.openBox('notes');
    setState(() {

    });
    return Future.value(true);
  }

  // void GetNotes()async {
  //   loading = true;
  //   NotesList.clear();
  //   await GetToken();
  //   var result = await notesController.getNotes(token!);
  //   // print('Notes result: $result');
  //   setState(() {
  //     if (result == 'Some error occured') {
  //       showSnackMessage(context, result);
  //     } else {
  //       for (int i = 0; i < result.length; i++) {
  //         // Map<String, dynamic> obj = result[i];
  //         Note item = Note();
  //         item = Note.fromJson(result[i]);
  //         NotesList.add(item);
  //       }
  //       loading = false;
  //     }
  //   });
  // }
  Future<bool> GetTasksFromBox() async {
    task = await Hive.openBox('tasks');
    setState(() {

    });
    return Future.value(true);
  }

  // void GetTasks() async {
  //   loading = true;
  //   TaskList.clear();
  //   await GetToken();
  //   var result = await tasksController.getTasks(token!);
  //   setState(() {
  //     if (result == 'Some error occured') {
  //       showSnackMessage(context, result);
  //     } else {
  //       for (int i = 0; i < result.length; i++) {
  //         Map<String, dynamic> obj = result[i];
  //         Tasks item = Tasks();
  //         item = Tasks.fromJson(obj);
  //         TaskList.add(item);
  //       }
  //       loading = false;
  //     }
  //   });
  // }

  Future showNotesDialog() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add Notes'),
            content: const Column(
              children: [
                Text('assign to'),
              ],
            ),
            actions: [
              TextButton(onPressed: () {}, child: const Text('Add')),
              TextButton(onPressed: () {Navigator.pop(context);}, child: const Text('Cancel')),
            ],
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: navigationdrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
            Theme.of(context).brightness == Brightness.dark?'assets/White.jpeg':'assets/_Logo.png',
          height: MediaQuery.of(context).size.height*0.05,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
                    Text('Events'),
                  ]),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: index == 0
                    ? FutureBuilder(
                  future: GetNotesFromBox(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else {
                      if (notes != null && notes!.isNotEmpty) {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: notes!.length,
                          itemBuilder: (BuildContext, index) {
                            return NotesTile(obj: notes!.get(index));
                          },
                        );
                      } else {
                        return const Center(child: Text('No Data Found'));
                      }
                    }
                  },
                )
                // loading ==true ?
                    //     CircularProgressIndicator( color: primaryColor,)
                    // :
                    // ListView.builder(
                    //         shrinkWrap: true,
                    //         itemCount: NotesList.length,
                    //         itemBuilder: (context, index) {
                    //           return NotesListTile(NotesList[index]);
                    //         })
                    : index == 1
                        ? FutureBuilder(
                            future: GetTasksFromBox(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                if (task!.isNotEmpty) {
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: task?.length,
                                    itemBuilder: (BuildContext context, index) {
                                      return taskListTile(task?.get(index));
                                    },
                                  );
                                } else {
                                  return const Center(child: Text('No Data Found'));
                                }
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: primaryColor,
                                  ),
                                );
                              }
                            }
                            )
                        // ? loading == true
                        //     ? CircularProgressIndicator(
                        //         color: primaryColor,
                        //       )
                        //     :
                        //     // Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>TaskExpandedView()))
                        //     ListView.builder(
                        //         shrinkWrap: true,
                        //         itemCount: TaskList.length,
                        //         itemBuilder: (context, index) {
                        //           return taskListTile(TaskList[index]);
                        //         })
                        : const Center(
                            child: Text('Events View'),
                          ),
              )
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
                onTap: () {},
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
}
