import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Functions/importFunctions.dart';
import '../functions/exportFunctions.dart';
import '../models/callItem.dart';
import '../models/contactItem.dart';
import '../models/customerItem.dart';
import '../models/leadItem.dart';
import '../models/noteItem.dart';
import '../models/opportunityItem.dart';
import '../models/taskItem.dart';
import '../models/userItem.dart';
import '../screens/calenderScreen.dart';
import '../screens/calls/callsListView.dart';
import '../screens/customer/customerListView.dart';
import '../screens/leadsView/leadListView.dart';
import '../screens/opportunitiesView/opportunitysListView.dart';
import '../splashScreen.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/messages.dart';
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
    bool loading = false;

    Future getSharedData() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        firstName = prefs.getString('firstName') ?? "";
        lastName = prefs.getString('lastName') ?? "";
        role= prefs.getString('role');
      });
      return true;
    }
    void functionCall()async{
      await getSharedData();
    }

   Future<void> showProgressDialog(BuildContext context, GlobalKey key) async {
     return showDialog<void>(
       context: context,
       barrierDismissible: false,
       builder: (BuildContext context) {
         return SimpleDialog(
           key: key,
           children: const [
             Column(
               mainAxisSize: MainAxisSize.min,
               children: [
                 CircularProgressIndicator(),
                 SizedBox(height: 16.0),
                 Text('Please wait...'),
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
    functionCall();
  }

    void clearHomeHiveData()async{
      final tasksBox = await Hive.openBox<TaskHive>('tasks');
      final notesBox = await Hive.openBox<NoteHive>('notes');

      await tasksBox.clear();
      await notesBox.clear();
    }

  void clearHiveData()async{
      clearHomeHiveData();
    final customersBox = await Hive.openBox<CustomerHive>('customers');
    final leadsBox = await Hive.openBox<LeadHive>('leads');
    final contactsBox = await Hive.openBox<ContactHive>('contacts');
    final usersBox = await Hive.openBox<UsersHive>('users');
    final opportunityBox = await Hive.openBox<OpportunityHive>('opportunity');
    final callBox = await Hive.openBox<CallHive>('calls');
    final dropdownOptionsBox = await Hive.openBox<String>("dropdownOptions");

    await customersBox.clear();
    await leadsBox.clear();
    await contactsBox.clear();
    await usersBox.clear();
    await opportunityBox.clear();
    await callBox.clear();
    await dropdownOptionsBox.clear();
  }

  ExportFunctions exportFunctions = ExportFunctions();
   ImportFunctions importFunctions = ImportFunctions();

   String? assignId;
   String? relatedId;

    Future<bool> isConnected() async {
      var connectivityResult = await Connectivity().checkConnectivity();
      return connectivityResult != ConnectivityResult.none;
    }


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
                        .push(MaterialPageRoute(builder: (context) =>
                    const CustomTableCalendar())) ;

                  },
                ),
                ListTile(
                  visualDensity: VisualDensity(vertical: drawerTileHeight),
                  leading: Icon(Icons.people, color: drawerTextCol,),
                  title: Text('Customers',style: TextStyle(color: drawerTextCol),),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context, rootNavigator: true)
                        .push(MaterialPageRoute(builder: (context) =>
                    const CustomerScreen())) ;
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
                    Navigator.of(context, rootNavigator: true)
                        .push(MaterialPageRoute(builder: (context) =>
                    const CallsScreen())) ;

                  },
                ),
                ListTile(
                  visualDensity: VisualDensity(vertical: drawerTileHeight),
                  leading: Icon(RpgAwesome.supersonic_arrow, color: drawerTextCol,),
                  title: Text('Opportunities',style: TextStyle(color: drawerTextCol),),
                  onTap: () {
                    Navigator.of(context, rootNavigator: true)
                    .push(MaterialPageRoute(builder: (context) =>
                        const opporScreen())) ;
                  },
                ),
                ListTile(
                  visualDensity: VisualDensity(vertical: drawerTileHeight),
                  leading: Icon(RpgAwesome.magnet, color: drawerTextCol,),
                  title: Text('Leads', style: TextStyle(color: drawerTextCol),),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context, rootNavigator: true)
                        .push(MaterialPageRoute(builder: (context) =>
                    const leadsScreen())) ;
                  },
                ),
                ListTile(
                  visualDensity: VisualDensity(vertical: drawerTileHeight),
                  leading: Icon(Icons.file_upload, color: drawerTextCol,),
                  title: Text('Upload Data', style: TextStyle(color: drawerTextCol),),
                    onTap: () async {
                      if (await isConnected()) {
                        try {
                          exportFunctions.postCustomerToApi();
                          exportFunctions.postContactsToApi();
                          Hive.openBox<TaskHive>("tasks").then((tasksBox) {
                            exportFunctions.postTasksToApi(tasksBox);
                          });
                          Hive.openBox<NoteHive>("notes").then((notesBox) {
                            exportFunctions.postNotesToApi(notesBox);
                          });
                          exportFunctions.postLeadToApi();
                          exportFunctions.postCallsToApi();
                          exportFunctions.postOpportunityToApi();
                          showSnackMessage(context, "Data Uploaded Successfully.");
                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(builder: (context) =>
                              const splashScreen()), (route) => false);
                          print('Data Uploaded successfully.');
                        } catch (e) {
                          showSnackMessage(context, "Error Uploading Data");
                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(builder: (context) =>
                              const splashScreen()), (route) => false);
                          print('Error Uploading Data: $e');
                        }
                      } else {
                        showSnackMessage(
                            context, "No Internet Connection. Please check your connection and try again.");
                      }
                    }
                ),
                ListTile(
                  visualDensity: VisualDensity(vertical: drawerTileHeight),
                  leading: Icon(Icons.file_download, color: drawerTextCol,),
                  title: Text('Download Data',
                    style: TextStyle(color: drawerTextCol),),
                  onTap: () async{
                    if (await isConnected()) {
                      try {
                        importFunctions.fetchUsersFromApi();
                        importFunctions.fetchTasksFromApi();
                        importFunctions.fetchContactsFromApi();
                        importFunctions.fetchCustomersFromApi();
                        importFunctions.fetchLeadsFromApi();
                        importFunctions.fetchNotesFromApi();
                        importFunctions.fetchCallsFromApi();
                        importFunctions.fetchOpportunitiesFromApi();
                        print('Data Fetched successfully.');
                        Navigator.pushAndRemoveUntil(context,
                            MaterialPageRoute(builder: (
                                context) => const splashScreen()), (
                                route) => false);
                        showSnackMessage(
                            context, "Data Downloaded Successfully.");
                      } catch (e) {
                        print('Error Fetching Data: $e');
                        Navigator.pushAndRemoveUntil(context,
                            MaterialPageRoute(builder: (
                                context) => const splashScreen()), (
                                route) => false);
                        showSnackMessage(context, "Error Fetching Data.");
                      }
                    } else {
                      showSnackMessage(
                          context, "No Internet Connection. Please check your connection and try again.");
                    }
                    // Navigator.pop(context);
                    // StorageController cont = StorageController();
                    //   showProgressDialog(context,_keyLoader);
                    //   await cont.GetAllData();
                    //   print('data loaded');
                    // Navigator.of(_keyLoader.currentContext!,
                    // rootNavigator: true).pop();
                  },
                ),
                ListTile(
                  visualDensity: VisualDensity(vertical: drawerTileHeight),
                  leading: Icon(Icons.close, color: drawerTextCol,),
                  title: Text('Clear Data', style: TextStyle(color: drawerTextCol),),
                  onTap: () {
                    try{
                      clearHiveData();
                      Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (context) => const splashScreen()), (route) => false);
                      showSnackMessage(context, "Data Cleared Successfully.");
                    } catch(e){
                      print("Error: $e");
                      showSnackMessage(context, "Error In Clearing Data.");
                    }
                  },
                ),
                ListTile(
                  visualDensity: VisualDensity(vertical: drawerTileHeight),
                  leading: Icon(Icons.logout, color: drawerTextCol,),
                  title: Text('Logout', style: TextStyle(color: drawerTextCol),),
                  onTap: () async{
                    if(await isConnected()){
                      logOut(context);
                    } else {
                      showSnackMessage(
                          context, "No Internet Connection. Please check your connection and try again.");
                    }
                    // Navigator.of(context, rootNavigator: true)
                    // .push(MaterialPageRoute(builder: (context) =>
                    // leadsScreen())) ;
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
                Text(name, style: TextStyle(fontSize: 12.0,
                    fontWeight: FontWeight.bold, color:Theme
                        .of(context).brightness == Brightness.light? drawerTextCol: null),
                ),
                Text(role, style: TextStyle(fontSize: 10.0,
                    fontWeight: FontWeight.w200,  color: Theme
                        .of(context).brightness == Brightness.light? drawerTextCol: null),
                ),
              ],
            )
          ],
        ),
      ),
    ),
  );
}
