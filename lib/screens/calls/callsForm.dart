import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:monmatics/models/contactItem.dart';
import 'package:monmatics/models/customerItem.dart';
import 'package:monmatics/models/leadItem.dart';
import 'package:uuid/uuid.dart';
import '../../functions/searchFunctions.dart';
import '../../models/callItem.dart';
import '../../models/userItem.dart';
import '../../utils/customWidgets.dart';
import '../../utils/messages.dart';
import '../../utils/themes.dart';

class AddCalls extends StatefulWidget {
  const AddCalls({super.key});

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

  // Start Date Pick Function
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
        startDateController.text = "${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  // End Date Pick Function
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
        endDateController.text = "${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}/${picked.year}";
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


  // Add Call Through Hive
  void addCall() async{
    Box? call = await Hive.openBox<CallHive>("calls");
    var uid = uuid.v1();
    CallHive newCall = CallHive()
    ..id = uid
    ..subject = subjectController.text
    ..status = selectedStatus!
    ..relatedTo = relatedTo!
    ..relatedId = searchController.text
    ..contactName = contactNameController.text
    ..startDate = startDateController.text
    ..startTime = startTimeController.text
    ..endDate = endDateController.text
    ..endTime = endTimeController.text
    ..communicationType = selectedCommunication!
    ..assignTo = assignController.text
    ..description = descriptionController.text;

    await call.add(newCall);
    showSnackMessage(context, "Call Added Successfully");

    setState(() {
      subjectController.clear();
      selectedStatus = null;
      relatedTo = null;
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

  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Calls Details', style: headerTextStyle),
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
                            return 'Please Choose Status';
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
                          searchContacts(context, contactNameController);
                        },
                        labelText: "Contact Name",
                        hintText: "Contact",
                        keyboardType: TextInputType.none,
                        nameController: contactNameController,
                        prefixIcon: const Icon(Icons.person),
                        validator: (value) {
                          if(value.isEmpty){
                            return "Please Enter Your Contact Name";
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
                            return "Please Enter Start Date";
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
                            return "Please Enter Start Time";
                          }
                          else {
                            return null;
                          }
                        },
                      ),
                      // const SizedBox(height: 15.0,),
                      // CustomDropdownButtonFormField(
                      //   value: startHour,
                      //   hintText: "Select Hour",
                      //   labelText: "Hours",
                      //   prefixIcon: const Icon(CupertinoIcons.time),
                      //   onChanged: (value) {
                      //     setState(() {
                      //       startHour = value!;
                      //     });
                      //   },
                      //   items: List.generate(24, (index) {
                      //     return DropdownMenuItem<String>(
                      //       value: index.toString().padLeft(2, '0'),
                      //       child: Text(index.toString().padLeft(2, '0')),
                      //     );
                      //   }),
                      //   validator: (value) {
                      //     if (value == null || value.isEmpty) {
                      //       return 'Please Choose a Hour';
                      //     }
                      //     return null;
                      //   },
                      // ),
                      // const SizedBox(height: 15.0,),
                      // CustomDropdownButtonFormField(
                      //   value: startMinute,
                      //   hintText: "Select Minute",
                      //   labelText: "Minutes",
                      //   prefixIcon: const Icon(Icons.timelapse),
                      //   onChanged: (value) {
                      //     setState(() {
                      //       startMinute = value!;
                      //     });
                      //   },
                      //   items: List.generate(60, (index) {
                      //     return DropdownMenuItem<String>(
                      //       value: index.toString().padLeft(2, '0'),
                      //       child: Text(index.toString().padLeft(2, '0')),
                      //     );
                      //   }),
                      //   validator: (value) {
                      //     if (value == null || value.isEmpty) {
                      //       return 'Please Select Minutes';
                      //     }
                      //     return null;
                      //   },
                      // ),
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
                            return "Please Enter End Date";
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
                            return "Please Enter End Time";
                          }
                          else {
                            return null;
                          }
                        },
                      ),
                      // const SizedBox(height: 15.0,),
                      // CustomDropdownButtonFormField(
                      //   value: endHour,
                      //   hintText: "Select Hour",
                      //   labelText: "Hours",
                      //   prefixIcon: const Icon(CupertinoIcons.time),
                      //   onChanged: (value) {
                      //     setState(() {
                      //       endHour = value!;
                      //     });
                      //   },
                      //   items: List.generate(24, (index) {
                      //     return DropdownMenuItem<String>(
                      //       value: index.toString().padLeft(2, '0'),
                      //       child: Text(index.toString().padLeft(2, '0')),
                      //     );
                      //   }),
                      //   validator: (value) {
                      //     if (value == null || value.isEmpty) {
                      //       return 'Please Choose a Hour';
                      //     }
                      //     return null;
                      //   },
                      // ),
                      // const SizedBox(height: 15.0,),
                      // CustomDropdownButtonFormField(
                      //   value: endMinute,
                      //   hintText: "Select Minute",
                      //   labelText: "Minutes",
                      //   prefixIcon: const Icon(Icons.timelapse),
                      //   onChanged: (value) {
                      //     setState(() {
                      //       endMinute = value!;
                      //     });
                      //   },
                      //   items: List.generate(60, (index) {
                      //     return DropdownMenuItem<String>(
                      //       value: index.toString().padLeft(2, '0'),
                      //       child: Text(index.toString().padLeft(2, '0')),
                      //     );
                      //   }),
                      //   validator: (value) {
                      //     if (value == null || value.isEmpty) {
                      //       return 'Please Select Minutes';
                      //     }
                      //     return null;
                      //   },
                      // ),
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
                            return 'Please Choose Communication Type';
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
                            return "Please Enter Value";
                          }
                          else {
                            return null;
                          }
                        },
                        prefixIcon: const Icon(Icons.person_2),
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
                            if(selectedStatus != null && relatedTo != null && selectedCommunication != null){
                              print('Form is valid');
                              setState(() {
                                loading = true;
                              });
                              addCall();
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
                        const Text("Add Call"),
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
  void searchContacts(BuildContext context, TextEditingController textFieldController) async {
    try {
      // Open the Hive box if it's not already open
      if (!Hive.isBoxOpen('contacts')) {
        await Hive.openBox<ContactHive>('contacts');
      }

      // Get the box
      Box contactBox = Hive.box<ContactHive>('contacts');
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
