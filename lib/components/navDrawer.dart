import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:monmatics/utils/messages.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Functions/importFunctions.dart';
import '../controllers/localdbController.dart';
import '../functions/exportFunctions.dart';
import '../models/noteItem.dart';
import '../models/taskItem.dart';
import '../screens/calenderScreen.dart';
import '../screens/calls/callsListView.dart';
import '../screens/customer/customerListView.dart';
import '../screens/leadsView/leadListView.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import 'logout.dart';
import 'package:icons_flutter/icons_flutter.dart';


class navigationdrawer extends StatefulWidget {
    navigationdrawer({Key? key}) : super(key: key);

  @override
  State<navigationdrawer> createState() => _navigationdrawerState();
}

class _navigationdrawerState extends State<navigationdrawer> {
    String? firstName;
    String? lastName;
    String? role;

    Future GetSharedData() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        firstName = prefs.getString('firstName') ?? "";
        lastName = prefs.getString('lastName') ?? "";
        role= prefs.getString('role');
      });
      return true;
    }
    void FunctionCall()async{
      await GetSharedData();
    }
   final GlobalKey<State> _keyLoader = GlobalKey<State>();

   Future<void> showProgressDialog(BuildContext context, GlobalKey key) async {
     return showDialog<void>(
       context: context,
       barrierDismissible: false, // Prevent dismissing the dialog by tapping outside
       builder: (BuildContext context) {
         return SimpleDialog(
           key: key,
           children: const [
             Column(
               mainAxisSize: MainAxisSize.min,
               children: [
                 CircularProgressIndicator(), // Display a CircularProgressIndicator
                 SizedBox(height: 16.0), // Optional spacing
                 Text('Please wait...'), // Optional text message
               ],
             ),
           ]
         );
       },
     );
   }

   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FunctionCall();
  }

  ExportFunctions exportFunctions = ExportFunctions();
   ImportFunctions importFunctions = ImportFunctions();

   String? assignId;
   String? relatedId;

   @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.55,
      child: Container(
        color: Theme.of(context).brightness == Brightness.dark
            ? darkThemeDrawerColor
            : primaryColor,
        child: Column(
          children: <Widget>[
            DrawerHeader(context,"$firstName $lastName" ??'User Name', role??'Role'),
            Column(
              children: <Widget>[
                ListTile(
                  visualDensity: VisualDensity(vertical: drawerTileHeight),
                  leading: Icon(Icons.calendar_month_outlined, color: drawerTextCol,),
                  title: Text(
                    'Calendar',
                    style: TextStyle(color: drawerTextCol),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context, rootNavigator: true)
                        .push(MaterialPageRoute(builder: (context) => const CustomTableCalendar())) ;

                  },
                ),
                ListTile(
                  visualDensity: VisualDensity(vertical: drawerTileHeight),
                  leading: Icon(Icons.people, color: drawerTextCol,),
                  title: Text('Customers',style: TextStyle(color: drawerTextCol),),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context, rootNavigator: true)
                        .push(MaterialPageRoute(builder: (context) => const CustomerScreen())) ;
                  },
                ),
                // ListTile(
                //   visualDensity: VisualDensity(vertical: drawerTileHeight),
                //   leading: Icon(Icons.event_note_rounded, color: drawerTextCol,),
                //   title: Text('Notes',style: TextStyle(color: drawerTextCol),),
                //   onTap: () {},
                // ),
                ListTile(
                  visualDensity: VisualDensity(vertical: drawerTileHeight),
                  leading: Icon(Icons.phone, color: drawerTextCol,),
                  title: Text('Calls', style: TextStyle(color: drawerTextCol),),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => CallsScreen())) ;

                  },
                ),
                // ListTile(
                //   visualDensity: VisualDensity(vertical: drawerTileHeight),
                //   leading: Icon(RpgAwesome.supersonic_arrow, color: drawerTextCol,),
                //   title: Text('Opportunities',style: TextStyle(color: drawerTextCol),),
                //   onTap: () {
                //     // Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => OpportunityScreen())) ;
                //   },
                // ),
                ListTile(
                  visualDensity: VisualDensity(vertical: drawerTileHeight),
                  leading: Icon(RpgAwesome.magnet, color: drawerTextCol,),
                  title: Text('Leads', style: TextStyle(color: drawerTextCol),),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => leadsScreen())) ;
                  },
                ),
                ListTile(
                  visualDensity: VisualDensity(vertical: drawerTileHeight),
                  leading: Icon(Icons.file_upload, color: drawerTextCol,),
                  title: Text('Upload Data', style: TextStyle(color: drawerTextCol),),
                  onTap: () async {
                    try {
                      exportFunctions.postCustomerToApi();
                      exportFunctions.postContactsToApi();
                      Hive.openBox<TaskHive>("tasks").then((tasksBox) {
                        exportFunctions.postTasksToApi(tasksBox, Ids(assignId!, relatedId!));
                      });
                      Hive.openBox<NoteHive>("notes").then((notesBox) {
                        exportFunctions.postNotesToApi(notesBox, Ids(assignId!, relatedId!));
                      });
                      exportFunctions.postLeadToApi();
                      showSnackMessage(context, "Data Uploaded Successfully.");
                      print('Data Uploaded successfully.');
                    } catch (e) {
                      print('Error Uploading Data: $e');
                    }

                  },
                ),
                ListTile(
                  visualDensity: VisualDensity(vertical: drawerTileHeight),
                  leading: Icon(Icons.file_download, color: drawerTextCol,),
                  title: Text('Download Data', style: TextStyle(color: drawerTextCol),),
                  onTap: () async{
                    try {
                      importFunctions.fetchUsersFromApi();
                      importFunctions.fetchTasksFromApi();
                      importFunctions.fetchContactsFromApi();
                      importFunctions.fetchCustomersFromApi();
                      importFunctions.fetchLeadsFromApi();
                      importFunctions.fetchNotesFromApi();
                      print('Data Fetched successfully.');
                    } catch (e) {
                      print('Error Fetching Data: $e');
                    }
                    // Navigator.pop(context);
                    // StorageController cont = StorageController();
                    //   showProgressDialog(context,_keyLoader);
                    //   await cont.GetAllData();
                    //   print('data loaded');
                    // Navigator.of(_keyLoader.currentContext!,rootNavigator: true).pop();
                  },
                ),
                ListTile(
                  visualDensity: VisualDensity(vertical: drawerTileHeight),
                  leading: Icon(Icons.logout, color: drawerTextCol,),
                  title: Text('Logout', style: TextStyle(color: drawerTextCol),),
                  onTap: () {
                    logOut(context);
                    // Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => leadsScreen())) ;
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

Widget DrawerHeader(BuildContext context, String name , String role) {
  return Container(
    color: Theme.of(context).brightness == Brightness.dark
        ? darkThemeDrawerHeaderColor
        : lightThemeDrawerHeaderColor,
    height: MediaQuery.of(context).size.height * 0.15,
    width: MediaQuery.of(context).size.width * 0.6,
    child: FittedBox(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              maxRadius: MediaQuery.of(context).size.width * 0.04,
              backgroundImage: const AssetImage('assets/accountImgPlaceholder.jpeg', ),
            ),
            const SizedBox(height: 10.0,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle( fontSize: 12.0, fontWeight: FontWeight.bold, color:Theme.of(context).brightness == Brightness.light? drawerTextCol: null),),
                Text(role, style: TextStyle( fontSize: 10.0, fontWeight: FontWeight.w200,  color: Theme.of(context).brightness == Brightness.light? drawerTextCol: null),),
                //Text('user_email@gmail.com', style: TextStyle( fontSize: 10.0, fontWeight: FontWeight.w200,  color: Theme.of(context).brightness == Brightness.light? drawerTextCol: null),),
              ],
            )
          ],
        ),
      ),
    ),
  );
}
