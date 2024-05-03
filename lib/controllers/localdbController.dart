// import 'package:hive/hive.dart';
// import 'package:monmatics/models/callItem.dart';
// import 'package:monmatics/models/contactItem.dart';
// import 'package:monmatics/models/customerItem.dart';
// import 'package:monmatics/models/leadItem.dart';
// import 'package:monmatics/models/noteItem.dart';
// import 'package:monmatics/models/taskItem.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'crmControllers.dart';
//
// class StorageController {
//   var boxleads;
//   var boxNotes;
//   var boxTasks;
//   var boxContacts;
//   var boxCalls;
//   var boxCustomers;
//   var tempMap = {};
//   String? token;
//   LeadController controller = LeadController();
//   TasksCont tasksController = TasksCont();
//   Notes notesController = Notes();
//   ContactController contactController = ContactController();
//   CallsRecord callsController = CallsRecord();
//   Customer customerController = Customer();
//   List leadsList = [];
//
//   Future GetToken() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     token = prefs.getString('token');
//   }
//
//   Future openBox() async {
//     var dir = await getApplicationDocumentsDirectory();
//     Hive.init(dir.path);
//     boxleads = await Hive.openBox<LeadHive>('leads');
//     boxNotes = await Hive.openBox<NoteHive>('notes');
//     boxTasks = await Hive.openBox<TaskHive>('tasks');
//     boxContacts = await Hive.openBox<ContactHive>('contacts');
//     boxCalls= await Hive.openBox<CallHive>('calls');
//     boxCustomers = await Hive.openBox<CustomerHive>('customers');
//     return;
//   }
//
//   Future<bool> GetAllData() async {
//     await openBox();
//     await GetToken();
//     boxleads.clear();
//     boxNotes.clear();
//     boxTasks.clear();
//     boxContacts.clear();
//     boxCalls.clear();
//     boxCustomers.clear();
//     var result;
//     //Leads Data Get
//     print(token);
//     result = await controller.getLeadData(token!);
//     print(result);
//     if (result == 'Some error occured') {
//       print('error on getting leads');
//       // showSnackMessage(context, result);
//     } else {
//       for (int i = 0; i < result.length; i++) {
//         String temp = result[i]["name"];
//         int? ind;
//         for (int i = 0; i < temp.length; i++) {
//           if (temp[i] == '(') {
//             ind = i;
//           }
//         }
//         tempMap = {
//           'Name': result[i]["name"]??'',
//           'Category': result[i]["category"] ?? '',
//           'Note': result[i]["note"] ?? '',
//           'PhoneNo': result[i]["phone"] ?? '',
//           'Email': result[i]["email"] ?? '',
//           'Address': result[i]["address"] ?? '',
//           'location': result[i]["location"] ?? '',
//         };
//         await boxleads.add(tempMap);
//       }
//     }
//     //Notes Data Get
//     print(token);
//     result = await notesController.getNotes(token!);
//     print('Notes result: $result');
//     if (result == 'Some error occured') {
//       // showSnackMessage(context, result);
//     } else {
//       for (int i = 0; i < result.length; i++) {
//         tempMap = {
//           'Subject': result[i]["subject"] ?? '',
//           'Description': result[i]["description"] ?? '',
//           'RelatedTo': result[i]["related_to_type"] ?? '',
//         };
//         await boxNotes.add(tempMap);
//       }
//     }
//     //Tasks Data get
//     result = await tasksController.getTasks(token!);
//     print('tasks result= $result');
//     if (result == 'Some error occured') {
//       print('error on getting tasks');
//       // showSnackMessage(context, result);
//     } else {
//       for (int i = 0; i < result.length; i++) {
//         tempMap = {
//           'Subject': result[i]["subject"] ?? '',
//           'StDate': result[i]["start_date"] ??'',
//           'DueDate': result[i]["due_date"] ?? '',
//           'Status': result[i]["status"] ?? '',
//           'Priority': result[i]["priority"] ?? '',
//           'Description': result[i]["description"] ?? '',
//         };
//         await boxTasks.add(tempMap);
//       }
//     }
//     //Contacts Data Get
//     result = await contactController.getData(token!);
//     print('contacts result= $result');
//     if (result == 'Some error occured') {
//       print('Error getting Contacts data');
//       // showSnackMessage(context, result);
//     } else {
//       for (int i = 0; i < result.length; i++) {
//         tempMap = {
//           'Name': '${result[i]["first_name"]} ${result[i]["last_name"]}',
//           'phone': result[i]['mobile'] ??'',
//           'Email': result[i]["email"]??'',
//         };
//         await boxContacts.add(tempMap);
//       }
//     }
//     //Calls Data Fetching
//     result  = await callsController .getRecord(token!);
//     if(result == 'Some error occured')
//     {
//       //showSnackMessage(context, result);
//     }
//     else {
//         for(int i=0;i<result.length;i++)
//         {
//           String temp=  result[i]["start_date"];
//           int? stInd ;
//           for(int i=0; i<temp.length;i++){
//             if(temp[i]== ' ')
//             {
//               stInd = i;
//             }
//           }
//           tempMap={
//             'ContactName': result[i]["contact_name"] ??'',
//             'Subject':  result[i]["subject"]??'',
//             'Status':  result[i]["status"]??'',
//             'Date':temp.substring(0,stInd),
//             'Time': temp.substring(stInd!),
//             'RelatedTo':result[i]["related_to_type"]??'',
//             'Description':result[i]["description"]??'',
//           };
//           await boxCalls.add(tempMap);
//         }
//     }
//     //Customer Data Fetch
//     result = await customerController.getCustomer(token!);
//       if (result == 'Some error occured') {
//         print('Error getting customer data');
//         // showSnackMessage(context, result);
//       } else {
//         for (int i = 0; i < result.length; i++) {
//          tempMap= {
//            'Name': result[i]["name"] ,
//            'Category': result[i]["category"]??'' ,
//            'Phone': result[i]["phone"]??'' ,
//            'CompanyName': result[i]["company_name"]??'' ,
//            'Email': result[i]["email"] ??'',
//            'Location': result[i]["location"] ??'',
//            'Address': result[i]["address"] ??'' ,
//          };
//          await boxCustomers.add(tempMap);
//         }
//       }
//
//
//     return Future.value(true);
//   }
// }
//
// // for(int i=0;i<result.length;i++)
// // {
// //   Map<String, dynamic> obj = result[i];
// //   Lead item = Lead();
// //   item = Lead.fromJson(obj);
// //   leadsList.add(item);
// // }
// // boxleads!.put('leads', leadsList);
