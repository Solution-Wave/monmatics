
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:monmatics/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:monmatics/models/taskItem.dart';
import '../controllers/crmControllers.dart';
import '../utils/messages.dart';
import '../utils/themes.dart';


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
  final titleController = TextEditingController();
  final descpController = TextEditingController();

  CalendarFormat calendarFormatVal = CalendarFormat.month;
  Box? task;
  TasksCont tasksController = TasksCont();
  List TaskList = [];
  String? token;
  Map<DateTime, List<Tasks>>? mySelectedEvents;
    ValueNotifier<List<Tasks>>? _selectedEvents;
  bool loading = false;
  Future GetToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
  }

  void AddData()async {
    loading= true;
    TaskList.clear();
    await GetToken();
    var result = await tasksController.getTasks(token!);
    setState(() {
      if (result == 'Some error occured') {
        showSnackMessage(context, result);
      } else {
        //print("result variable: $result");
        for (int i = 0; i < result.length; i++) {
          Map<String, dynamic> obj = result[i];
          Tasks item = Tasks();
          item = Tasks.fromJson(obj);
          if (mySelectedEvents?[DateTime.parse(item.DueDate!)] != null) {
            mySelectedEvents?[DateTime.parse(item.DueDate!)]?.add(item);
          } else {
            mySelectedEvents?[DateTime.parse(item.DueDate!)] = [
             item
            ];
          }
        }
      }
      loading = false;
      _selectedEvents = ValueNotifier(_listOfDayEvents(selectedCalendarDate!));
    });
  }

  void DataFromBox()async{
    loading= true;
    task = await Hive.openBox('tasks');
    setState(() {
      List<dynamic> list = task!.values.toList();
      for (int i = 0; i < list.length; i++) {
        Map obj = list[i];
        print(obj);
        Tasks item = Tasks();
        item = Tasks.fromJson(obj);
        if (mySelectedEvents?[DateTime.parse(item.DueDate!)] != null) {
          mySelectedEvents?[DateTime.parse(item.DueDate!)]?.add(item);
        } else {
          mySelectedEvents?[DateTime.parse(item.DueDate!)] = [
            item
          ];
        }
      }
      loading = false;
      _selectedEvents = ValueNotifier(_listOfDayEvents(selectedCalendarDate!));
    });
}

  @override
  void initState() {
    super.initState();
    selectedCalendarDate = _focusedCalendarDate;
    mySelectedEvents = {};
    DataFromBox();
    //AddData();

  }

  @override
  void dispose() {
    titleController.dispose();
    descpController.dispose();
    super.dispose();
  }

  List<Tasks> _listOfDayEvents(DateTime dateTime) {
    DateTime formattedDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    return mySelectedEvents?[formattedDate] ?? [];
  }

  _showAddEventDialog() async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? eventDialogDarkBgColor
                  : eventDialogLightBgColor,
              title: const Text('New Event'),
              titleTextStyle: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? null
                      : eventDialogTextColorLight),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildTextField(
                      controller: titleController, hint: 'Enter Title'),
                  const SizedBox(
                    height: 20.0,
                  ),
                  buildTextField(
                      controller: descpController, hint: 'Enter Description'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? null
                            : eventDialogTextColorLight),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // if (titleController.text.isEmpty &&
                    //     descpController.text.isEmpty) {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     const SnackBar(
                    //       content: Text(
                    //         'Please enter title & description',
                    //       ),
                    //       duration: Duration(seconds: 3),
                    //     ),
                    //   );
                    //   //Navigator.pop(context);
                    //   return;
                    // } else {
                    //   setState(() {
                    //     if (mySelectedEvents?[selectedCalendarDate] != null) {
                    //       mySelectedEvents?[selectedCalendarDate]?.add(MyEvents(
                    //           eventTitle: titleController.text,
                    //           eventDescp: descpController.text));
                    //     } else {
                    //       mySelectedEvents?[selectedCalendarDate!] = [
                    //         MyEvents(
                    //             eventTitle: titleController.text,
                    //             eventDescp: descpController.text)
                    //       ];
                    //     }
                    //   });
                    //   print(mySelectedEvents);
                    //   titleController.clear();
                    //   descpController.clear();
                    //
                    //   Navigator.pop(context);
                    //   return;
                    // }
                  },
                  child: Text(
                    'Add',
                    style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? null
                            : eventDialogTextColorLight),
                  ),
                ),
              ],
            ));
  }

  Widget buildTextField(
      {String? hint, required TextEditingController controller}) {
    return TextField(
      controller: controller,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: hint ?? '',
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor, width: 1.5),
          borderRadius: BorderRadius.circular(
            10.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black38, width: 1.5),
          borderRadius: BorderRadius.circular(
            10.0,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar', style: headerTextStyle),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEventDialog(),
        label: const Text('Add Event'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // loading ?
            //     Center(
            //       child: CircularProgressIndicator(
            //         color: primaryColor,
            //       ),
            //     ) :
            Card(
              margin: const EdgeInsets.all(8.0),
              elevation: 5.0,
              shape: RoundedRectangleBorder(
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
                // today's date
                firstDay: _initialCalendarDate,
                // earliest possible date
                lastDay: _lastCalendarDate,
                // latest allowed date
                calendarFormat: calendarFormatVal,
                // default view when displayed
                // default is Saturday & Sunday but can be set to any day.
                // instead of day number can be mentioned as well.
                weekendDays: const [DateTime.sunday, 6],
                // default is Sunday but can be changed according to locale
                startingDayOfWeek: StartingDayOfWeek.monday,
                // height between the day row and 1st date row, default is 16.0
                daysOfWeekHeight: 40.0,
                // height between the date rows, default is 52.0
                rowHeight: 60.0,
                // this property needs to be added if we want to show events
                eventLoader: _listOfDayEvents,
                // Calendar Header Styling
                headerStyle: HeaderStyle(
                  titleTextStyle: TextStyle(
                    color: calendarHeaderTextColor,
                    fontSize: 20.0,
                  ),
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  formatButtonTextStyle:
                      TextStyle(color: calendarHeaderTextColor, fontSize: 16.0),
                  formatButtonDecoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.all(
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
                // Calendar Days Styling
                daysOfWeekStyle: DaysOfWeekStyle(
                  // Weekend days color (Sat,Sun)
                  weekendStyle: TextStyle(color: calendarWeekendDays),
                ),
                // Calendar Dates styling
                calendarStyle: CalendarStyle(
                  // Weekend dates color (Sat & Sun Column)
                  weekendTextStyle: TextStyle(color: calendarWeekendDays),
                  // highlighted color for today
                  todayDecoration: BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                  ),
                  // highlighted color for selected day
                  selectedDecoration: BoxDecoration(
                    color: selectedDayColor,
                    shape: BoxShape.circle,
                  ),
                  markerDecoration: BoxDecoration(
                      color: primaryColor, shape: BoxShape.circle),
                ),
                selectedDayPredicate: (currentSelectedDate) {
                  // as per the documentation 'selectedDayPredicate' needs to determine
                  // current selected day
                  return (isSameDay(
                      selectedCalendarDate!, currentSelectedDate));
                },
                onDaySelected: (selectedDay, focusedDay) {
                  // as per the documentation
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
            loading ?
            Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            ) :
            ValueListenableBuilder<List<Tasks>>(
              valueListenable: _selectedEvents!,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        onTap: () => print('${value[index]}'),
                        title: Text('${value[index].Subject}'),
                      ),
                    );
                  },
                );
              },
            ),

          ],
        ),
      ),
    );
  }
}

