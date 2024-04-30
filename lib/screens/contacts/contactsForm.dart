import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:monmatics/functions/otherFunctions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../../functions/exportFunctions.dart';
import '../../models/contactItem.dart';
import '../../models/customerItem.dart';
import '../../models/leadItem.dart';
import '../../models/userItem.dart';
import '../../utils/customWidgets.dart';
import '../../utils/messages.dart';
import '../../utils/themes.dart';

class AddContact extends StatefulWidget {
  final ContactHive? existingContact;
  const AddContact({super.key, this.existingContact});

  @override
  State<AddContact> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? assignId;
  Future<void> getSharedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      assignId = prefs.getString('id');
    });
  }


  void functionCall()async{
    await getSharedData();
  }

  @override
  void initState() {
    super.initState();
    functionCall();

    if(widget.existingContact != null){
      firstnameController.text = widget.existingContact!.fName;
      lastnameController.text = widget.existingContact!.lName;
      titleController.text = widget.existingContact!.title;
      selectedType = widget.existingContact!.type;
      relatedTo = widget.existingContact!.relatedTo;
      relatedId = widget.existingContact!.search;
      searchController.text = widget.existingContact!.search ?? '';
      assignController.text = widget.existingContact!.assignTo ?? '';
      assignId = widget.existingContact!.assignId ?? '';
      phoneController.text = widget.existingContact!.phone;
      emailController.text = widget.existingContact!.email;
      officePhoneController.text = widget.existingContact!.officePhone;
      addressController.text = widget.existingContact!.address;
      cityController.text = widget.existingContact!.city;
      stateController.text = widget.existingContact!.state;
      postalCodeController.text = widget.existingContact!.postalCode;
      countryController.text = widget.existingContact!.country;
      descriptionController.text = widget.existingContact!.description;
    }
  }

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
  var uuid = const Uuid();

  ExportFunctions exportFunctions = ExportFunctions();
  OtherFunctions otherFunctions = OtherFunctions();



  // Add Contact through Hive
  // void addContact() async {
  //   try {
  //     // Generate a new unique ID for the contact
  //     var uid = uuid.v1();
  //
  //     // Open the Hive box for storing contacts
  //     Box<ContactHive> contactBox = await Hive.openBox<ContactHive>("contacts");
  //
  //     // Create a new ContactHive object with the provided data
  //     ContactHive newContact = ContactHive()
  //       ..id = uid
  //       ..type = selectedType ?? '' // Ensure selectedType is not null
  //       ..fName = firstnameController.text.trim()
  //       ..lName = lastnameController.text.trim()
  //       ..title = titleController.text.trim()
  //       ..relatedTo = relatedTo ?? '' // Ensure relatedTo is not null
  //       ..search = relatedId ?? '' // Ensure relatedId is not null
  //       ..assignTo = assignId ?? '' // Ensure assignId is not null
  //       ..phone = phoneController.text.trim()
  //       ..email = emailController.text.trim()
  //       ..officePhone = officePhoneController.text.trim()
  //       ..address = addressController.text.trim()
  //       ..city = cityController.text.trim()
  //       ..state = stateController.text.trim()
  //       ..postalCode = postalCodeController.text.trim()
  //       ..country = countryController.text.trim()
  //       ..description = descriptionController.text.trim()
  //       ..addedAt = DateTime.now();
  //
  //     // Add the new contact to the Hive database
  //     await contactBox.add(newContact);
  //
  //     // Post the new contact data to the API
  //     await exportFunctions.postContactsToApi();
  //
  //     // Show a success message
  //     showSnackMessage(context, "Contact Added Successfully");
  //
  //     // Clear the form fields after successful addition
  //     setState(() {
  //       selectedType = null;
  //       firstnameController.clear();
  //       lastnameController.clear();
  //       titleController.clear();
  //       relatedTo = null;
  //       relatedId = null;
  //       assignId = null;
  //       searchController.clear();
  //       assignController.clear();
  //       phoneController.clear();
  //       emailController.clear();
  //       officePhoneController.clear();
  //       addressController.clear();
  //       cityController.clear();
  //       stateController.clear();
  //       postalCodeController.clear();
  //       countryController.clear();
  //       descriptionController.clear();
  //     });
  //   } catch (e) {
  //     // Handle any errors that occur during the process
  //     showSnackMessage(context, "Failed to add contact: $e");
  //   }
  // }

  void saveContact() async {
    try {
      // Open the Hive box
      Box<ContactHive> contactBox = await Hive.openBox<ContactHive>('contacts');
      if (widget.existingContact != null) {
        // Update existing call
        ContactHive updatedContact = widget.existingContact!;
        // Update existing contact
        updatedContact.fName = firstnameController.text;
        updatedContact.lName = lastnameController.text;
        updatedContact.title = titleController.text;
        updatedContact.type = selectedType ?? updatedContact.type;
        updatedContact.relatedTo = searchController.text;
        updatedContact.search = relatedId ?? updatedContact.search;
        updatedContact.assignTo = assignController.text;
        updatedContact.assignId = assignId ?? updatedContact.assignId;
        updatedContact.phone = phoneController.text;
        updatedContact.email = emailController.text;
        updatedContact.officePhone = officePhoneController.text;
        updatedContact.address = addressController.text;
        updatedContact.city = cityController.text;
        updatedContact.state = stateController.text;
        updatedContact.postalCode = postalCodeController.text;
        updatedContact.country = countryController.text;
        updatedContact.description = descriptionController.text;

        await contactBox.put(updatedContact.key, updatedContact);
        otherFunctions.updateContactInDatabase(updatedContact);
        showSnackMessage(context, 'Contact updated successfully');
      } else {
        // Add new contact
        var newContactId = uuid.v1();
        ContactHive newContact = ContactHive()
          ..id = newContactId
          ..fName = firstnameController.text
          ..lName = lastnameController.text
          ..title = titleController.text
          ..type = selectedType!
          ..relatedTo = searchController.text
          ..search = relatedId!
          ..assignTo = assignController.text
          ..assignId = assignId!
          ..phone = phoneController.text
          ..email = emailController.text
          ..officePhone = officePhoneController.text
          ..address = addressController.text
          ..city = cityController.text
          ..state = stateController.text
          ..postalCode = postalCodeController.text
          ..country = countryController.text
          ..description = descriptionController.text;

        await contactBox.add(newContact);
        exportFunctions.postContactsToApi();
        showSnackMessage(context, 'Contact added successfully');
      }

      // Reset form fields
      setState(() {
        firstnameController.clear();
        lastnameController.clear();
        titleController.clear();
        selectedType = null;
        relatedTo = null;
        searchController.clear();
        relatedId = null;
        assignController.clear();
        assignId = null;
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

    } catch (e) {
      // Handle any errors that may occur during saving/updating contacts
      showSnackMessage(context, 'Error: $e');
    }
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
                            return null;
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
                            return null;
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
                            return null;
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
                            return null;
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
                                return null;
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
                            return null;
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
                            return null;
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
                            return null;
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
                            return null;
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
                            return null;
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
                            return null;
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
                            return null;
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
                            return null;
                          }
                          else {
                            return null;
                          }
                        },
                        prefixIcon: const Icon(Icons.map),
                      ),
                      const SizedBox(height: 10.0,),
                      CustomTextFormField(
                        keyboardType: TextInputType.multiline,
                        labelText: "Description",
                        hintText: "Description",
                        minLines: 1,
                        maxLines: null,
                        nameController: descriptionController,
                        validator: (value) {
                          if(value.isEmpty){
                            return null;
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
                              print('Form is valid');
                              setState(() {
                                loading = true;
                              });
                              saveContact();
                              setState(() {
                                loading = false;
                              });
                          }
                          else {
                            print('Form is invalid');
                            setState(() {
                              loading = false;
                            });
                            showSnackMessage(context, "Please Fill Required Fields");
                          }
                        },
                        padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 50.0),
                        child: loading ?
                        const SizedBox(height: 18,width: 18,
                          child: CircularProgressIndicator(color: Colors.white,),):
                        Text(widget.existingContact != null ? 'Update Contact' : 'Add Contact'),
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
        await Hive.openBox<CustomerHive>('customers');
      }
      Box contactBox = Hive.box<CustomerHive>('customers');
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
        await Hive.openBox<LeadHive>('leads');
      }

      Box leadBox = Hive.box<LeadHive>('leads');
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
