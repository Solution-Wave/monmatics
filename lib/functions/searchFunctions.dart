// import 'package:hive/hive.dart';
// import 'package:flutter/material.dart';
// import '../models/customerItem.dart';
// import '../models/userItem.dart';
//
//
// class SearchFunctions{
//
//   String? assignId;
//   String? relatedId;
//
//   void searchCustomer(BuildContext context, TextEditingController textFieldController) async {
//     try {
//       if (!Hive.isBoxOpen('customers')) {
//         await Hive.openBox<CustomerHive>('customers');
//       }
//       Box contactBox = Hive.box<CustomerHive>('customers');
//       List<Map<String, dynamic>> customers = [];
//       for (var customer in contactBox.values) {
//         customers.add({
//           'id': customer.id,
//           'name': customer.name,
//         });
//       }
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: const Center(child: Text('Customers List')),
//             content: SingleChildScrollView(
//               child: Column(
//                 children: customers.map((customer) => ListTile(
//                   title: Text('${customer['name']}'),
//                   onTap: () {
//                     relatedId = customer['id'];
//                     textFieldController.text = customer['name'];
//                     Navigator.pop(context);
//                   },
//                 )).toList(),
//               ),
//             ),
//           );
//         },
//       );
//     } catch (e) {
//       print('Error fetching customer names: $e');
//       // Handle error appropriately
//     }
//   }
//   void searchLead(BuildContext context, TextEditingController textFieldController) async {
//     try {
//       if (!Hive.isBoxOpen('leads')) {
//         await Hive.openBox<CustomerHive>('leads');
//       }
//
//       Box leadBox = Hive.box<CustomerHive>('leads');
//       List<Map<String, dynamic>> leads = [];
//       for (var lead in leadBox.values) {
//         leads.add({
//           'id': lead.id,
//           'name': lead.name,
//         });
//       }
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: const Center(child: Text('Leads List')),
//             content: SingleChildScrollView(
//               child: Column(
//                 children: leads.map((lead) => ListTile(
//                   title: Text('${lead['name']}'),
//                   onTap: () {
//                     relatedId = lead['id'];
//                     textFieldController.text = lead['name'];
//                     Navigator.pop(context);
//                   },
//                 )).toList(),
//               ),
//             ),
//           );
//         },
//       );
//     } catch (e) {
//       print('Error fetching lead names: $e');
//       // Handle error appropriately
//     }
//   }
//   void searchContacts(BuildContext context, TextEditingController textFieldController) async {
//     try {
//       // Open the Hive box if it's not already open
//       if (!Hive.isBoxOpen('contacts')) {
//         await Hive.openBox<CustomerHive>('contacts');
//       }
//
//       // Get the box
//       Box contactBox = Hive.box<CustomerHive>('contacts');
//       List<String> customerNames = [];
//       for (var contact in contactBox.values) {
//         customerNames.add(
//             '${contact.fName} ''${contact.lName}');
//       }
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: const Center(child: Text('Contacts List')),
//             content: SingleChildScrollView(
//               child: Column(
//                 children: customerNames.map((id) => ListTile(
//                   title: Text(id),
//                   onTap: () {
//                     textFieldController.text = id;
//                     Navigator.pop(context);
//                   },
//                 )).toList(),
//               ),
//             ),
//           );
//         },
//       );
//     } catch (e) {
//       print('Error fetching customer names: $e');
//       // Handle error appropriately
//     }
//   }
//   void searchUsers(BuildContext context, TextEditingController textFieldController,) async {
//     try {
//       // Open the Hive box if it's not already open
//       if (!Hive.isBoxOpen('users')) {
//         await Hive.openBox<UsersHive>('users');
//       }
//
//       // Get the box
//       Box<UsersHive> userBox = Hive.box<UsersHive>('users');
//
//       // Convert users to a list of maps containing required data
//       List<Map<String, dynamic>> userNames = userBox.values.map((user) {
//         return {
//           'id': user.id,
//           'firstName': user.fName,
//           'lastName': user.lName,
//         };
//       }).toList();
//
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: const Center(child: Text('Users List')),
//             content: SingleChildScrollView(
//               child: Column(
//                 children: userNames.map((user) {
//                   String displayName = '${user['firstName']} ${user['lastName']}';
//                   return ListTile(
//                     title: Text(displayName),
//                     onTap: () {
//                       assignId = user['id'];
//                       textFieldController.text = displayName;
//                       Navigator.pop(context);
//                     },
//                   );
//                 }).toList(),
//               ),
//             ),
//           );
//         },
//       );
//     } catch (e) {
//       print('Error fetching User names: $e');
//       // Handle error appropriately
//     }
//   }
// }