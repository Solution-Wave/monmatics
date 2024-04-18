import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../../Functions/exportFunctions.dart';
import '../../functions/searchFunctions.dart';
import '../../models/contactItem.dart';
import '../../models/userItem.dart';
import '../../utils/customWidgets.dart';
import '../../utils/messages.dart';
import '../../utils/themes.dart';
import '../../utils/urls.dart';

class AddContact extends StatefulWidget {
  const AddContact({super.key});

  @override
  State<AddContact> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController assignController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController officePhoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  bool loading = false;
  String? selectedType;
  String? relatedTo;
  String? relatedId;
  String? assignId;
  var uuid = const Uuid();

  ExportFunctions exportFunctions = ExportFunctions();


  // Add Contact through Hive
  void addContact() async{
    exportFunctions.postContactsToApi();
    var uid = uuid.v1();
    Box? contact = await Hive.openBox("contacts");
    ContactHive newContact = ContactHive()
    ..id = uid
    ..type = selectedType!
    ..fName = firstnameController.text
    ..lName = lastnameController.text
    ..title = titleController.text
    ..relatedTo = relatedTo!
    ..search = searchController.text
    ..assignTo = assignController.text
    ..phone = phoneController.text
    ..email = emailController.text
    ..officePhone = officePhoneController.text
    ..address = addressController.text
    ..city = cityController.text
    ..state = stateController.text
    ..postalCode = postalCodeController.text
    ..country = countryController.text
    ..description = descriptionController.text;
    await contact.add(newContact);
    showSnackMessage(context, "Contact Added Successfully");

    setState(() {
      selectedType = null;
      firstnameController.clear();
      lastnameController.clear();
      titleController.clear();
      relatedTo = null;
      searchController.clear();
      assignController.clear();
      phoneController.clear();
      emailController.clear();
      officePhoneController.clear();
      addressController.clear();
      cityController.clear();
      stateController.clear();
      postalCodeController.clear();
      countryController.clear();
      descriptionController.clear();
    });
  }




  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Contact Details', style: headerTextStyle),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 25.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomDropdownButtonFormField(
                        value: selectedType,
                        hintText: "Select Type",
                        labelText: "Type",
                        prefixIcon: const Icon(Icons.type_specimen),
                        onChanged: (value) {
                          print('Selected Type: $value');
                          setState(() {
                            selectedType = value;
                          });
                        },
                        items: <String>[
                          "Mr.",
                          "Mrs.",
                          "Dr.",
                          "Eng.",
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            alignment: AlignmentDirectional.center,
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Choose Type';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10.0,),
                      CustomTextFormField(
                        labelText: "First Name",
                        hintText: "First Name",
                        keyboardType: TextInputType.text,
                        nameController: firstnameController,
                        prefixIcon: const Icon(Icons.person),
                        validator: (value) {
                          if(value.isEmpty){
                            return "Please Enter Your First Name";
                          }
                          else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 10.0,),
                      CustomTextFormField(
                        labelText: "Last Name",
                        hintText: "Last Name",
                        keyboardType: TextInputType.text,
                        nameController: lastnameController,
                        prefixIcon: const Icon(Icons.person),
                        validator: (value) {
                          if(value.isEmpty){
                            return "Please Enter Your Last Name";
                          }
                          else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 10.0,),
                      CustomTextFormField(
                        labelText: "Title",
                        hintText: "Title",
                        keyboardType: TextInputType.text,
                        nameController: titleController,
                        prefixIcon: const Icon(Icons.title),
                        validator: (value) {
                          if(value.isEmpty){
                            return "Please Enter Title";
                          }
                          else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 15.0,),
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
                          "Lead",
                          "Customer",
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
                      relatedTo == "Lead"
                          ? Column(
                        children: [
                          const SizedBox(height: 10.0,),
                          CustomTextFormField(
                            onTap: (){
                              searchLead(context, searchController);
                            },
                            labelText: "Lead Search",
                            hintText: "Lead Name",
                            keyboardType: TextInputType.none,
                            nameController: searchController,
                            prefixIcon: const Icon(Icons.search),
                            validator: (value) {
                              if(value.isEmpty){
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
                      relatedTo == "Customer"
                          ? Column(
                        children: [
                          const SizedBox(height: 10.0,),
                          CustomTextFormField(
                            onTap: (){
                              searchCustomer(context, searchController);
                            },
                            labelText: "Customer Search",
                            hintText: "Customer Name",
                            keyboardType: TextInputType.none,
                            nameController: searchController,
                            prefixIcon: const Icon(Icons.search),
                            validator: (value) {
                              if(value.isEmpty){
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
                      const SizedBox(height: 10.0,),
                      CustomTextFormField(
                        onTap: (){
                          searchUsers(context, assignController);
                        },
                        labelText: "Assigned To",
                        hintText: "Contact",
                        keyboardType: TextInputType.none,
                        nameController: assignController,
                        prefixIcon: const Icon(Icons.person_2),
                        validator: (value) {
                          if(value.isEmpty){
                            return "Please Enter a Value";
                          }
                          else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 10.0,),
                      CustomTextFormField(
                        labelText: "Phone Number",
                        hintText: "03*********",
                        keyboardType: TextInputType.phone,
                        nameController: phoneController,
                        prefixIcon: const Icon(Icons.phone),
                        validator: (value) {
                          if(value.isEmpty){
                            return "Please Enter Your Phone Number";
                          }
                          else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 10.0,),
                      CustomTextFormField(
                        labelText: "Email",
                        hintText: "example@example.com",
                        keyboardType: TextInputType.emailAddress,
                        nameController: emailController,
                        prefixIcon: const Icon(Icons.mail),
                        validator: (value) {
                          if(value.isEmpty){
                            return "Please Enter Your Email";
                          }
                          else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 10.0,),
                      CustomTextFormField(
                        labelText: "Office Phone",
                        hintText: "Office Phone",
                        keyboardType: TextInputType.phone,
                        nameController: officePhoneController,
                        prefixIcon: const Icon(Icons.phone_android),
                        validator: (value) {
                          if(value.isEmpty){
                            return "Please Enter Your Office Phone Number";
                          }
                          else {
                            return null;
                          }
                        },

                      ),
                      const SizedBox(height: 10.0,),
                      CustomTextFormField(
                        keyboardType: TextInputType.text,
                        labelText: "Address",
                        hintText: "Address",
                        minLines: 1,
                        maxLines: null,
                        nameController: addressController,
                        prefixIcon: const Icon(Icons.pin_drop),
                        validator: (value) {
                          if(value.isEmpty){
                            return "Please Enter Your Address";
                          }
                          else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 10.0,),
                      CustomTextFormField(
                        keyboardType: TextInputType.text,
                        labelText: "City",
                        hintText: "City",
                        nameController: cityController,
                        validator: (value) {
                          if(value.isEmpty){
                            return "Please Enter Your City Name";
                          }
                          else {
                            return null;
                          }
                        },
                        prefixIcon: const Icon(Icons.maps_home_work),
                      ),
                      const SizedBox(height: 10.0,),
                      CustomTextFormField(
                        keyboardType: TextInputType.text,
                        labelText: "State",
                        hintText: "State",
                        nameController: stateController,
                        validator: (value) {
                          if(value.isEmpty){
                            return "Please Enter Your State";
                          }
                          else {
                            return null;
                          }
                        },
                        prefixIcon: const Icon(Icons.location_city_sharp),
                      ),
                      const SizedBox(height: 10.0,),
                      CustomTextFormField(
                        keyboardType: TextInputType.number,
                        labelText: "Postal Code",
                        hintText: "Postal Code",
                        nameController: postalCodeController,
                        validator: (value) {
                          if(value.isEmpty){
                            return "Please Enter Your Postal Code";
                          }
                          else {
                            return null;
                          }
                        },
                        prefixIcon: const Icon(Icons.numbers),
                      ),
                      const SizedBox(height: 15.0,),
                      CustomTextFormField(
                        keyboardType: TextInputType.text,
                        labelText: "Country",
                        hintText: "Country",
                        nameController: countryController,
                        validator: (value) {
                          if(value.isEmpty){
                            return "Please Enter Your Country";
                          }
                          else {
                            return null;
                          }
                        },
                        prefixIcon: const Icon(Icons.map),
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
                      const SizedBox(height: 20.0,),
                      CustomButton(
                        onPressed: () {
                          if(_formKey.currentState!.validate()){
                            if(relatedTo != null && selectedType != null){
                              print('Form is valid');
                              setState(() {
                                loading = true;
                              });
                              addContact();
                              setState(() {
                                loading = false;
                              });
                            } else{
                              print('Select Dropdown Values');
                              setState(() {
                                loading = false;
                              });
                              showSnackMessage(context, "Please Choose all Values");
                            }
                          }
                          else {
                            print('Form is invalid');
                            setState(() {
                              loading = false;
                            });
                            showSnackMessage(context, "Please Fill All the Fields");
                          }
                        },
                        padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 50.0),
                        child: loading ?
                        const SizedBox(height: 18,width: 18,
                          child: CircularProgressIndicator(color: Colors.white,),):
                        const Text("Add Contact"),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void searchCustomer(BuildContext context, TextEditingController textFieldController) async {
    try {
      if (!Hive.isBoxOpen('customers')) {
        await Hive.openBox('customers');
      }
      Box contactBox = Hive.box('customers');
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
        await Hive.openBox('leads');
      }

      Box leadBox = Hive.box('leads');
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
        await Hive.openBox('contacts');
      }

      // Get the box
      Box contactBox = Hive.box('contacts');
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
