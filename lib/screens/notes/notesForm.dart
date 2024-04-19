// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:monmatics/models/contactItem.dart';
// import 'package:monmatics/models/customerItem.dart';
// import 'package:monmatics/models/leadItem.dart';
// import 'package:uuid/uuid.dart';
//
// import '../../models/userItem.dart';
// import '../../utils/customWidgets.dart';
// import '../../utils/themes.dart';
//
// class NotesForm extends StatefulWidget {
//   const NotesForm({super.key});
//
//   @override
//   State<NotesForm> createState() => _NotesFormState();
// }
//
// class _NotesFormState extends State<NotesForm> {
//
//   Box? notes;
//   String? firstName;
//   String? lastName;
//   String? role;
//   String? relatedTo;
//   String? status;
//   String? priority;
//
//   TextEditingController subjectController = TextEditingController();
//   TextEditingController searchController = TextEditingController();
//   TextEditingController contactController = TextEditingController();
//   TextEditingController startDateController = TextEditingController();
//   TextEditingController dueDateController = TextEditingController();
//   TextEditingController assignController = TextEditingController();
//   TextEditingController descriptionController = TextEditingController();
//
//
//   var uuid = const Uuid();
//
//
//   GlobalKey<FormState> formKey = GlobalKey<FormState>();
//
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('Note Details', style: headerTextStyle),
//           centerTitle: true,
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Card(
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Form(
//                 key: formKey,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     CustomTextFormField(
//                         nameController: subjectController,
//                         hintText: "Subject",
//                         labelText: "Subject",
//                         keyboardType: TextInputType.text,
//                         validator: (value) {
//                           if (value.isEmpty) {
//                             return "Please Enter Subject";
//                           }
//                           return null;
//                         },
//                         prefixIcon: const Icon(Icons.subject)
//                     ),
//                     const SizedBox(height: 15.0,),
//                     CustomDropdownButtonFormField(
//                       value: relatedTo,
//                       hintText: "Select",
//                       labelText: "Related To",
//                       prefixIcon: const Icon(Icons.person_3),
//                       onChanged: (value) {
//                         print('Related To: $value');
//                         setState(() {
//                           relatedTo = value;
//                         });
//                       },
//                       items: <String>[
//                         "lead",
//                         "customer",
//                         "project",
//                         "",
//                       ].map((String value) {
//                         return DropdownMenuItem<String>(
//                           alignment: AlignmentDirectional.center,
//                           value: value,
//                           child: Text(value),
//                         );
//                       }).toList(),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please Choose an Option';
//                         }
//                         return null;
//                       },
//                     ),
//                     relatedTo == "lead"
//                         ? Column(
//                       children: [
//                         const SizedBox(height: 10.0,),
//                         CustomTextFormField(
//                           onTap: () {
//                             searchLead(context, searchController);
//                           },
//                           labelText: "Lead Search",
//                           hintText: "Lead Name",
//                           keyboardType: TextInputType.none,
//                           nameController: searchController,
//                           prefixIcon: const Icon(Icons.search),
//                           validator: (value) {
//                             if (value.isEmpty) {
//                               return "Please Enter a value";
//                             }
//                             else {
//                               return null;
//                             }
//                           },
//                         )
//                       ],
//                     )
//                         : Container(),
//                     relatedTo == "customer"
//                         ? Column(
//                       children: [
//                         const SizedBox(height: 10.0,),
//                         CustomTextFormField(
//                           onTap: () {
//                             searchCustomer(context, searchController);
//                           },
//                           labelText: "Customer Search",
//                           hintText: "Customer Name",
//                           keyboardType: TextInputType.none,
//                           nameController: searchController,
//                           prefixIcon: const Icon(Icons.search),
//                           validator: (value) {
//                             if (value.isEmpty) {
//                               return "Please Enter a value";
//                             }
//                             else {
//                               return null;
//                             }
//                           },
//                         )
//                       ],
//                     )
//                         : Container(),
//                     const SizedBox(height: 10.0,),
//                     CustomTextFormField(
//                         onTap: (){
//                           searchUsers(context, assignController);
//                         },
//                         nameController: assignController,
//                         hintText: "Contact",
//                         labelText: "Assign To",
//                         keyboardType: TextInputType.none,
//                         validator: (value) {
//                           if (value.isEmpty) {
//                             return "Please Enter a Value";
//                           }
//                           return null;
//                         },
//                         prefixIcon: const Icon(Icons.person)
//                     ),
//                     const SizedBox(height: 10.0,),
//                     CustomTextFormField(
//                       keyboardType: TextInputType.text,
//                       labelText: "Description",
//                       hintText: "Description",
//                       minLines: 1,
//                       maxLines: null,
//                       nameController: descriptionController,
//                       validator: (value) {
//                         if (value.isEmpty) {
//                           return "Please Enter Description";
//                         }
//                         else {
//                           return null;
//                         }
//                       },
//                       prefixIcon: const Icon(Icons.sticky_note_2),
//                     ),
//                     const SizedBox(height: 20.0,),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void searchCustomer(BuildContext context, TextEditingController textFieldController) async {
//     try {
//       if (!Hive.isBoxOpen('customers')) {
//         await Hive.openBox<CustomerHive>('customers');
//       }
//
//       Box contactBox = Hive.box('customers');
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
//                   title: Text('${customer['name']} (${customer['id']})'),
//                   onTap: () {
//                     // Set the selected customer id to the text field
//                     textFieldController.text = customer['id'];
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
//         await Hive.openBox<LeadHive>('leads');
//       }
//
//       Box leadBox = Hive.box('leads');
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
//             title: const Center(child: Text('Customers List')),
//             content: SingleChildScrollView(
//               child: Column(
//                 children: leads.map((lead) => ListTile(
//                   title: Text('${lead['name']} (${lead['id']})'),
//                   onTap: () {
//                     textFieldController.text = lead['id'];
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
//         await Hive.openBox<ContactHive>('contacts');
//       }
//
//       // Get the box
//       Box contactBox = Hive.box('contacts');
//       List<String> customerNames = [];
//       for (var contact in contactBox.values) {
//         customerNames.add('${contact.fName} ${contact.lName}');
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
//                     Navigator.pop(context); // Close the dialog
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
//   void searchUsers(BuildContext context, TextEditingController textFieldController) async {
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
//             title: const Center(child: Text('Customers List')),
//             content: SingleChildScrollView(
//               child: Column(
//                 children: userNames.map((user) {
//                   String displayName = '${user['firstName']} ${user['lastName']} (${user['id']})';
//                   return ListTile(
//                     title: Text(displayName),
//                     onTap: () {
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
//
// }
