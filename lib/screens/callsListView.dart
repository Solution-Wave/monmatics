// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:monmatics/models/callItem.dart';
// import 'package:monmatics/utils/colors.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:monmatics/utils/themes.dart';
// import '../controllers/crmControllers.dart';
// import '../utils/themes.dart';
// import 'calls/callsScreen.dart';
//
//
// List callsData= [];
// class CallsScreen extends StatefulWidget {
//   const CallsScreen({super.key});
//
//   @override
//   State<CallsScreen> createState() => _CallsScreenState();
// }
//
// class _CallsScreenState extends State<CallsScreen> {
//    String? token;
//    Box? call;
//    CallsRecord controller = CallsRecord();
//
//    bool loading = false;
//
//
//   Future getToken()async{
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     token = prefs.getString('token');
//   }
//    Future<bool> getCallsRecord() async {
//      call = await Hive.openBox<CallHive>('calls');
//      setState(() {
//      });
//      return Future.value(true);
//    }
//    Future<bool> getList(){
//      callsData.clear();
//      List tempList = call!.values.toList();
//      setState(() {
//        for(var i in tempList)
//        {
//          callsData.add(i);
//        }
//      });
//   return Future.value(true);
//    }
//
//   void openSearch()async{
//   await getList();
//   showSearch(
//     context: context,
//     delegate: SearchCalls(),
//   );
//   }
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           title:  Text('Calls', style: headerTextStyle,),
//           centerTitle: true,
//           actions: [
//             IconButton(
//               icon: const Icon(
//                 Icons.search,
//               ),
//               onPressed: () {
//                 openSearch();
//               },
//             )
//           ],
//         ),
//         body: Padding(
//           padding: const EdgeInsets.only(right: 8.0, left: 8.0),
//           child:
//           FutureBuilder(
//               future: getCallsRecord(),
//               builder: (context, snapshot) {
//                 if (snapshot.hasData) {
//                   if (call!.isNotEmpty) {
//                     return ListView.builder(
//                       shrinkWrap: true,
//                       itemCount: call!.length,
//                       itemBuilder: (BuildContext, index) {
//                         return CallsListTile(obj:call!.get(index));
//                       },
//                     );
//                   } else
//                     return Center(child: Text('No Data Found'));
//                 } else {
//                   return Center(
//                     child: CircularProgressIndicator(
//                       color: primaryColor,
//                     ),
//                   );
//                 }
//               })
//
//           // loading ?
//           //     Center(child: CircularProgressIndicator(color: primaryColor,))
//           // :
//           // ListView.builder(
//           //     itemCount: callsData.length,
//           //     itemBuilder: (BuildContext context, index){
//           //      return CallsListTile(obj: callsData[index]);
//           // }),
//         )
//       ),
//     );
//   }
// }
//
//
// class SearchCalls extends SearchDelegate{
//   @override
//   List<Widget>? buildActions(BuildContext context) => [
//     IconButton(
//       icon: Icon(Icons.clear),
//       onPressed: () {
//         query.isEmpty ? close(context, null) : query = '';
//       },
//     )
//   ];
//   @override
//   Widget? buildLeading(BuildContext context) => IconButton(
//       icon: Icon(Icons.arrow_back), onPressed: () => close(context, null));
//
//   List getResults(String query) {
//     List results = [];
//     int i = 0;
//     //List tempList = model.data!;
//     int len = callsData.length;
//
//     for (i; i < len; i++) {
//       if (callsData[i]['Subject'].toLowerCase().contains(query.toLowerCase())
//           || callsData[i]['Status'].toLowerCase().contains(query.toLowerCase())
//           || callsData[i]['Date'].contains(query)
//       ) {
//         results.add(callsData[i]);
//       }
//     }
//     return results;
//   }
//
//   List getSuggestions(String query) {
//     List suggestions = [];
//     int i = 0;
//     //List tempList = model.data!;
//     int len = callsData.length;
//
//     for (i; i < len; i++) {
//       if (callsData[i]['Subject'].toLowerCase().contains(query.toLowerCase())
//           || callsData[i]['Status'].toLowerCase().contains(query.toLowerCase())
//           || callsData[i]['Date'].contains(query)
//       ) {
//         suggestions.add(callsData[i]);
//       }
//     }
//     return suggestions;
//   }
//
//   @override
//   Widget buildResults(BuildContext context) {
//     List results = query.isEmpty ? [] : getSuggestions(query);
//     return ListView.builder(
//         itemCount: results.length,
//         itemBuilder:(context, index){
//           return CallsListTile(obj:results[index]);
//         }
//     );
//   }
//
//   @override
//   Widget buildSuggestions(BuildContext context) {
//
//     List suggestions = query.isEmpty ? [] : getSuggestions(query);
//     return ListView.builder(
//         itemCount: suggestions.length,
//         itemBuilder:(context, index){
//           return CallsListTile(obj:suggestions[index]);
//         }
//     );
//   }
//
// }
