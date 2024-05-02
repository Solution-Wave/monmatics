import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../../functions/exportFunctions.dart';
import '../../functions/otherFunctions.dart';
import '../../models/callItem.dart';
import '../../models/contactItem.dart';
import '../../models/customerItem.dart';
import '../../models/leadItem.dart';
import '../../models/userItem.dart';
import '../../utils/customWidgets.dart';
import '../../utils/messages.dart';
import '../../utils/themes.dart';

class AddCalls extends StatefulWidget {
  final CallHive? existingCall;
  const AddCalls({super.key, this.existingCall});

  @override
  State<AddCalls> createState() => _AddCallsState();
}

class _AddCallsState extends State<AddCalls> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController subjectController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController contactNameController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController assignController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  bool loading = false;
  String? selectedStatus;
  String? relatedTo;
  String? selectedCommunication;
  String? assignId;
  String? relatedId;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  var uuid = const Uuid();
  String? contactId;

  ExportFunctions exportFunctions = ExportFunctions();
  OtherFunctions otherFunctions = OtherFunctions();

  String relatedName = "";
  String assignName = "";
  String contactName = "";
  Future<void> fetchRelatedNames(String? relatedId) async {
    print("Fetching name for relatedId: $relatedId");
    if (relatedId != null && relatedId.isNotEmpty) {
      String? fetchedName;

      try {
        // Initialize variables for the Hive boxes
        var leadBox = await Hive.openBox<LeadHive>('leads');
        var customerBox = await Hive.openBox<CustomerHive>('customers');
        var contactsBox = await Hive.openBox<ContactHive>('contacts');

        // Check for a match in each box
        bool matchFound = false;

        // Check the Lead box
        for (var lead in leadBox.values) {
          if (lead.id == relatedId) {
            fetchedName = lead.name;
            matchFound = true;
            print("Found lead with name: $fetchedName");
            break;
          }
        }

        // If no match was found in the Lead box, check the Customer box
        if (!matchFound) {
          for (var customer in customerBox.values) {
            if (customer.id == relatedId) {
              fetchedName = customer.name;
              matchFound = true;
              print("Found customer with name: $fetchedName");
              break;
            }
          }
        }

        // If no match was found in the Lead or Customer box, check the Contacts box
        if (!matchFound) {
          for (var contact in contactsBox.values) {
            if (contact.id == relatedId) {
              String fullName = "${contact.fName} ${contact.lName}";
              fetchedName = fullName;
              matchFound = true;
              print("Found contact with name: $fetchedName");
              break;
            }
          }
        }
      } catch (e) {
        print("Error fetching name: $e");
        fetchedName = 'Error';
      }

      // Set the fetched name to the searchController
      relatedName = fetchedName ?? '';
      searchController.text = relatedName;
      print("Set searchController.text to: ${searchController.text}");

    } else {
      // Handle case where relatedId is null or empty
      print("relatedId is null or empty.");
      searchController.text = ''; // Set to an empty string
    }
  }
  Future<void> fetchAssignNames(String? assignId) async {
    print("Fetching name for assignId: $assignId");
    if (assignId != null && assignId.isNotEmpty) {
      String? fetchedName;
      try {
        // Initialize variables for the Hive boxes
        var userBox = await Hive.openBox<UsersHive>('users');
        bool matchFound = false;

        // Check the Name box
        for (var name in userBox.values) {
          if (name.id == assignId) {
            String fullName = "${name.fName} ${name.lName}";
            fetchedName = fullName;
            matchFound = true;
            print("Found User with name: $fetchedName");
            break;
          }
        }
      } catch (e) {
        print("Error fetching name: $e");
        fetchedName = 'Error';
      }
        assignName = fetchedName ?? '';
      assignController.text = assignName;
    } else {
      // Handle case where relatedId is null or empty
      print("assignId is null or empty.");
      assignController.text = ''; // Set to an empty string
    }
  }
  Future<void> fetchContactNames(String? contactId) async {
    print("Fetching name for contactId: $contactId");
    if (contactId != null && contactId.isNotEmpty) {
      String? fetchedName;
      try {
        // Initialize variables for the Hive boxes
        var contactBox = await Hive.openBox<ContactHive>('contacts');
        bool matchFound = false;

        // Check the Name box
        for (var contact in contactBox.values) {
          if (contact.id == contactId) {
            String fullName = "${contact.fName} ${contact.lName}";
            fetchedName = fullName;
            matchFound = true;
            print("Found contact with name: $fetchedName");
            break;
          }
        }
      } catch (e) {
        print("Error fetching name: $e");
        fetchedName = 'Error';
      }

      // Set the fetched name to the searchController
      contactName = fetchedName ?? '';
      contactNameController.text = contactName;
      print("Set contactNameController.text to: ${contactNameController.text}");

    } else {
      // Handle case where relatedId is null or empty
      print("contactId is null or empty.");
      contactNameController.text = ''; // Set to an empty string
    }
  }

  void fetchNames() async{
  await fetchAssignNames(widget.existingCall!.assignId);
  await fetchRelatedNames(relatedId);
  await fetchContactNames(widget.existingCall!.contactId);
}

  Future<void> getSharedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      assignId = prefs.getString('id');
    });
  }

  void functionCall() async {
    await getSharedData();
  }

  @override
  void initState() {
    super.initState();
    functionCall();
    // If an existing call is provided, initialize the form controllers with the existing call's data
    if (widget.existingCall != null) {
      fetchNames();
      contactId = widget.existingCall!.contactId;
      subjectController.text = widget.existingCall!.subject;
      selectedStatus = widget.existingCall!.status;
      relatedTo = widget.existingCall!.relatedType;
      relatedId = widget.existingCall!.relatedId;
      searchController.text = relatedName ?? widget.existingCall!.relatedTo ?? "";
      contactNameController.text = contactName ?? widget.existingCall!.contactName ?? "";
      startDateController.text = widget.existingCall!.startDate;
      startTimeController.text = widget.existingCall!.startTime;
      endDateController.text = widget.existingCall!.endDate;
      endTimeController.text = widget.existingCall!.endTime;
      selectedCommunication = widget.existingCall!.communicationType;
      assignController.text = assignName ?? widget.existingCall!.assignTo ?? "";
      descriptionController.text = widget.existingCall!.description;
    }
  }

  // Add or Update Call through Hive
  void saveCall() async {
    try {
      // Open the Hive box
      Box<CallHive> callBox = await Hive.openBox<CallHive>('calls');
      if (widget.existingCall != null) {
        // Update existing call
        CallHive updatedCall = widget.existingCall!;
        updatedCall.subject = subjectController.text;
        updatedCall.status = selectedStatus!;
        updatedCall.relatedType = relatedTo!;
        updatedCall.relatedTo = searchController.text;
        updatedCall.relatedId = relatedId!;
        updatedCall.contactName = contactNameController.text;
        updatedCall.contactId = contactId!;
        updatedCall.startDate = startDateController.text;
        updatedCall.startTime = startTimeController.text;
        updatedCall.endDate = endDateController.text;
        updatedCall.endTime = endTimeController.text;
        updatedCall.communicationType = selectedCommunication!;
        updatedCall.assignTo = assignController.text;
        updatedCall.assignId = assignId!;
        updatedCall.description = descriptionController.text;

        await callBox.put(updatedCall.key, updatedCall);
        otherFunctions.updateCallInDatabase(updatedCall);
        showSnackMessage(context, 'Call updated successfully');
      } else {
        // Add new call
        var newCallId = uuid.v1();
        CallHive newCall = CallHive()
          ..id = newCallId
          ..subject = subjectController.text
          ..status = selectedStatus!
          ..relatedTo = searchController.text
          ..relatedType = relatedTo!
          ..relatedId = relatedId!
          ..contactName = contactNameController.text
          ..contactId = contactId!
          ..startDate = startDateController.text
          ..startTime = startTimeController.text
          ..endDate = endDateController.text
          ..endTime = endTimeController.text
          ..communicationType = selectedCommunication!
          ..assignTo = assignController.text
          ..assignId = assignId!
          ..description = descriptionController.text;
        await callBox.add(newCall);
        exportFunctions.postCallsToApi();
        showSnackMessage(context, 'Call added successfully');
      }

      // Reset form
      setState(() {
        subjectController.clear();
        selectedStatus = null;
        relatedTo = null;
        relatedName = "";
        assignName = "";
        contactName = '';
        searchController.clear();
        contactNameController.clear();
        startDateController.clear();
        startTimeController.clear();
        endDateController.clear();
        endTimeController.clear();
        selectedCommunication = null;
        assignController.clear();
        descriptionController.clear();
      });

    } catch (e) {
      // Handle any errors that may occur during saving/updating calls
      showSnackMessage(context, 'Error: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Call Details', style: headerTextStyle),
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
                      CustomTextFormField(
                        labelText: "Subject",
                        hintText: "Subject",
                        keyboardType: TextInputType.text,
                        nameController: subjectController,
                        prefixIcon: const Icon(Icons.topic),
                        validator: (value) {
                          if(value.isEmpty){
                            return "Please Enter Your Subject";
                          }
                          else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 15.0,),
                      CustomDropdownButtonFormField(
                        value: selectedStatus,
                        hintText: "Select Status",
                        labelText: "Status",
                        prefixIcon: const Icon(Icons.access_time),
                        onChanged: (value) {
                          print('Selected Status: $value');
                          setState(() {
                            selectedStatus = value;
                          });
                        },
                        items: <String>[
                          "Open",
                          "Close",
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
                          "Contact",
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
                      relatedTo == "Contact"
                          ? Column(
                        children: [
                          const SizedBox(height: 10.0,),
                          CustomTextFormField(
                            onTap: (){
                              searchContacts(context, searchController);
                            },
                            labelText: "Contact Search",
                            hintText: "Contact Name",
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
                      const SizedBox(height: 10.0,),
                      CustomTextFormField(
                        onTap: (){
                          searchContacts(context, contactNameController);
                        },
                        labelText: "Contact Name",
                        hintText: "Contact",
                        keyboardType: TextInputType.none,
                        nameController: contactNameController,
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
                        labelText: "Start Date",
                        hintText: "Date",
                        onTap: () => _selectStartDate(context),
                        keyboardType: TextInputType.none,
                        nameController: startDateController,
                        prefixIcon: const Icon(Icons.calendar_month),
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
                        labelText: "Start Time",
                        hintText: "Time",
                        onTap: () => _selectStartTime(context),
                        keyboardType: TextInputType.none,
                        nameController: startTimeController,
                        prefixIcon: const Icon(Icons.access_time),
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
                        labelText: "End Date",
                        hintText: "Date",
                        onTap: () => _selectEndDate(context),
                        keyboardType: TextInputType.none,
                        nameController: endDateController,
                        prefixIcon: const Icon(Icons.calendar_month),
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
                        labelText: "End Time",
                        hintText: "Time",
                        onTap: () => _selectEndTime(context),
                        keyboardType: TextInputType.none,
                        nameController: endTimeController,
                        prefixIcon: const Icon(Icons.access_time),
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
                        value: selectedCommunication,
                        hintText: "Select Communication Type",
                        labelText: "Communication Type",
                        prefixIcon: const Icon(Icons.phone),
                        onChanged: (value) {
                          print('Selected Communication Type: $value');
                          setState(() {
                            selectedCommunication = value;
                          });
                        },
                        items: <String>[
                          "phone call",
                          "Close",
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
                        onTap: (){
                          searchUsers(context, assignController);
                        },
                        keyboardType: TextInputType.none,
                        labelText: "Assign To",
                        hintText: "Contact",
                        maxLines: null,
                        nameController: assignController,
                        validator: (value) {
                          if(value.isEmpty){
                            return null;
                          }
                          else {
                            return null;
                          }
                        },
                        prefixIcon: const Icon(Icons.person_2),
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
                              saveCall();
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
                        Text(widget.existingCall != null ? 'Update Call' : 'Add Call'),
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


  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2500),
    );
    if (picked != null && picked != startDate) {
      setState(() {
        startDate = picked;
        startDateController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2500),
    );
    if (picked != null && picked != endDate) {
      setState(() {
        endDate = picked;
        endDateController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  // Start Time Pick Function
  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        startTimeController.text = picked.format(context);
        print(startTimeController.text);
      });
    }
  }

  // Start Time Pick Function
  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        endTimeController.text = picked.format(context);
        print(endTimeController.text);
      });
    }
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
  void searchContacts(BuildContext context, TextEditingController textFieldController) async {
    try {
      // Open the Hive box if it's not already open
      if (!Hive.isBoxOpen('contacts')) {
        await Hive.openBox<ContactHive>('contacts');
      }

      // Get the box
      Box contactBox = Hive.box<ContactHive>('contacts');
      List<Map<String, dynamic>> contactNames = contactBox.values.map((contact) {
        return {
          'id': contact.id,
          'firstName': contact.fName,
          'lastName': contact.lName,
        };
      }).toList();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Center(child: Text('Contacts List')),
            content: SingleChildScrollView(
              child: Column(
                children: contactNames.map((contact) {
                  String displayName = '${contact['firstName']} ${contact['lastName']}';
                  return ListTile(
                    title: Text(displayName),
                    onTap: () {
                      contactId = contact['id'];
                      textFieldController.text = displayName;
                      Navigator.pop(context);
                      print(contactId);
                    },
                  );
                }).toList(),
              ),
            ),
          );
        },
      );
    } catch (e) {
      print('Error fetching Contact names: $e');
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
