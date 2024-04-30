import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../controllers/crmControllers.dart';
import '../../functions/otherFunctions.dart';
import '../../models/callItem.dart';
import '../../searchScreens/callsSearch.dart';
import '../../utils/colors.dart';
import '../../utils/themes.dart';
import 'callsScreen.dart';
import 'callsForm.dart';


List callsData= [];
class CallsScreen extends StatefulWidget {
  const CallsScreen({super.key});

  @override
  State<CallsScreen> createState() => _CallsScreenState();
}

class _CallsScreenState extends State<CallsScreen> {
   String? token;
   Box? call;
   CallsRecord controller = CallsRecord();

   bool loading = false;

   Future<bool> getCallsRecord() async {
     call = await Hive.openBox<CallHive>('calls');
     setState(() {
     });
     return Future.value(true);
   }
   Future<bool> getList(){
     callsData.clear();
     List tempList = call!.values.toList();
     setState(() {
       for(var i in tempList)
       {
         callsData.add(i);
       }
     });
  return Future.value(true);
   }

  void openSearch()async{
  await getList();
  showSearch(
    context: context,
    delegate: SearchCalls(),
  );
  }
   OtherFunctions otherFunctions = OtherFunctions();
   // Function to handle delete action
   void deleteCall(CallHive calls, int index) async {
     showDialog(
       context: context,
       builder: (BuildContext context) {
         return AlertDialog(
           title: const Text('Delete Call'),
           content: const Text('Are you sure you want to delete this Call?'),
           actions: <Widget>[
             TextButton(
               onPressed: () async {
                 // Delete the note from the database
                 try {
                   await otherFunctions.deleteCallFromDatabase(calls.id);
                 } catch (e) {
                   print('Error deleting Call from database: $e');
                   // Handle error if necessary
                 }

                 // Delete the note from the UI
                 setState(() {
                   call!.deleteAt(index);
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

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title:  Text('Calls', style: headerTextStyle,),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.search,
              ),
              onPressed: () {
                openSearch();
              },
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(right: 8.0, left: 8.0),
          child:
          FutureBuilder(
              future: getCallsRecord(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (call!.isNotEmpty) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: call!.length,
                      itemBuilder: (BuildContext, index) {
                        return CallsListTile(
                            obj:call!.get(index),
                          onDelete: (call) {
                            deleteCall(call, index);
                          },
                        );
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
              }),

          // loading ?
          //     Center(child: CircularProgressIndicator(color: primaryColor,))
          // :
          // ListView.builder(
          //     itemCount: callsData.length,
          //     itemBuilder: (BuildContext context, index){
          //      return CallsListTile(obj: callsData[index]);
          // }),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? popupmenuButtonCol
              : null,
          onPressed: () async{

            Navigator.push(context, MaterialPageRoute(builder: (context) => const AddCalls(
            )));
          },
          child: const Icon(Icons.add,
            size: 40.0,),
        ),
      ),
    );
  }
}

