import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:icons_flutter/icons_flutter.dart';
import '../../Functions/exportFunctions.dart';
import '../../functions/otherFunctions.dart';
import '../../models/contactItem.dart';
import '../../models/customerItem.dart';
import '../../models/leadItem.dart';
import '../../models/opportunityItem.dart';
import '../../models/userItem.dart';
import '../../utils/customWidgets.dart';
import '../../utils/messages.dart';
import '../../utils/themes.dart';
import 'package:uuid/uuid.dart';


class AddOpportunity extends StatefulWidget {
  final OpportunityHive? existingOpportunity;

  const AddOpportunity({super.key, this.existingOpportunity});

  @override
  State<AddOpportunity> createState() => _AddOpportunityState();
}

class _AddOpportunityState extends State<AddOpportunity> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Initialize text controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController leadController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController nextStepController = TextEditingController();
  TextEditingController assignController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  // Initialize dropdown values
  String? selectedCurrency;
  String? selectedStage;
  String? selectedSource;
  String? selectedCampaign;
  String? selectedType;

  bool loading = false;
  String? assignId;
  String? leadId;

  // Initialize date
  DateTime date = DateTime.now();

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

      // Set the fetched name to the leadController
      relatedName = fetchedName ?? '';
      leadController.text = relatedName;
      print("Set leadController.text to: ${leadController.text}");

    } else {
      // Handle case where relatedId is null or empty
      print("relatedId is null or empty.");
      leadController.text = ''; // Set to an empty string
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

  void fetchNames() async{
    await fetchAssignNames(widget.existingOpportunity!.assignId);
    await fetchRelatedNames(widget.existingOpportunity!.leadId);
  }

  // Load existing data if provided
  @override
  void initState() {
    super.initState();
    if (widget.existingOpportunity != null) {
      OpportunityHive opportunity = widget.existingOpportunity!;
      fetchNames();
      // Pre-fill form fields with existing data
      nameController.text = opportunity.name;
      leadController.text = relatedName;
      amountController.text = opportunity.amount;
      dateController.text = opportunity.closeDate;
      nextStepController.text = opportunity.nextStep;
      assignController.text = assignName;
      descriptionController.text = opportunity.description;

      selectedCurrency = opportunity.currency;
      selectedStage = opportunity.stage;
      selectedSource = opportunity.source;
      selectedCampaign = opportunity.campaign;
      selectedType = opportunity.type;
      assignId = opportunity.assignId;

      // Parse date from the string format if available
      if (dateController.text.isNotEmpty) {
        List<String> dateParts = dateController.text.split('/');
        if (dateParts.length == 3) {
          date = DateTime(
            int.parse(dateParts[2]),
            int.parse(dateParts[0]),
            int.parse(dateParts[1]),
          );
        }
      }
    }
  }

  ExportFunctions exportFunctions = ExportFunctions();
  OtherFunctions otherFunctions = OtherFunctions();

  void saveOpportunity() async {
    // Open the Hive box
    Box<OpportunityHive> opportunityBox = await Hive.openBox<OpportunityHive>("opportunity");

    OpportunityHive newOpportunity;
    if (widget.existingOpportunity == null) {
      // Add new opportunity if existing opportunity is null
      String uid = Uuid().v1();
      newOpportunity = OpportunityHive()
        ..id = uid
    ..name = nameController.text
    ..leadName = leadController.text
    ..currency = selectedCurrency!
    ..amount = amountController.text
    ..closeDate = dateController.text
    ..type = selectedType!
    ..stage = selectedStage!
    ..source = selectedSource!
    ..campaign = selectedCampaign!
    ..nextStep = nextStepController.text
    ..assignTo = assignController.text
    ..description = descriptionController.text;

    // Add the new opportunity to the box
    await opportunityBox.add(newOpportunity);
    exportFunctions.postOpportunityToApi();
    showSnackMessage(context, "Opportunity Added Successfully");
    } else {
    // Update existing opportunity
    OpportunityHive existingOpportunity = widget.existingOpportunity!;
    existingOpportunity
    ..name = nameController.text
    ..leadName = leadController.text
      ..leadId = leadId!
    ..currency = selectedCurrency!
    ..amount = amountController.text
    ..closeDate = dateController.text
    ..type = selectedType!
    ..stage = selectedStage!
    ..source = selectedSource!
    ..campaign = selectedCampaign!
    ..nextStep = nextStepController.text
    ..assignTo = assignController.text
      ..assignId = assignId!
    ..description = descriptionController.text;

    // Save the updated opportunity to the box
    await existingOpportunity.save();
    otherFunctions.updateOpportunityInDatabase(existingOpportunity);
    showSnackMessage(context, "Opportunity Updated Successfully");
    }

    // Clear the form fields
    setState(() {
    nameController.clear();
    leadController.clear();
    selectedCurrency = null;
    amountController.clear();
    dateController.clear();
    selectedType = null;
    selectedStage = null;
    selectedSource = null;
    selectedCampaign = null;
    nextStepController.clear();
    assignController.clear();
    descriptionController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.existingOpportunity == null ?
          'Add Opportunity' : 'Edit Opportunity', style: headerTextStyle),
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
                        labelText: "Opportunity Name",
                        hintText: "Name",
                        keyboardType: TextInputType.text,
                        nameController: nameController,
                        prefixIcon: const Icon(Icons.account_circle),
                        validator: (value) {
                          if(value.isEmpty){
                            return "Please Enter Opportunity Name";
                          }
                          else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 10.0,),
                      CustomTextFormField(
                        onTap: (){
                          searchLead(context, leadController);
                        },
                        labelText: "Lead",
                        hintText: "Lead",
                        keyboardType: TextInputType.none,
                        nameController: leadController,
                        prefixIcon: const Icon(RpgAwesome.magnet),
                        validator: (value) {
                          if(value.isEmpty){
                            return "Please Enter Your Lead";
                          }
                          else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 15.0,),
                      CustomDropdownButtonFormField(
                        value: selectedCurrency,
                        hintText: "Select Currency",
                        labelText: "Currency",
                        prefixIcon: const Icon(Icons.attach_money),
                        onChanged: (value) {
                          print('Selected Currency: $value');
                          setState(() {
                            selectedCurrency = value;
                          });
                        },
                        items: <String>[
                          "SAR",
                          "PKR",
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            alignment: AlignmentDirectional.center,
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Choose a Currency';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10.0,),
                      CustomTextFormField(
                        labelText: "Opportunity Amount",
                        hintText: "1000",
                        keyboardType: TextInputType.number,
                        nameController: amountController,
                        prefixIcon: const Icon(Icons.money),
                        validator: (value) {
                          if(value.isEmpty){
                            return "Please Enter Your Amount";
                          }
                          else {
                            return null;
                          }
                        },

                      ),
                      const SizedBox(height: 10.0,),
                      CustomTextFormField(
                        labelText: "Expected Close Date",
                        hintText: "Date",
                        onTap: () => _selectDate(context),
                        keyboardType: TextInputType.none,
                        nameController: dateController,
                        prefixIcon: const Icon(Icons.calendar_month),
                        validator: (value) {
                          if(value.isEmpty){
                            return "Please Enter Date";
                          }
                          else {
                            return null;
                          }
                        },

                      ),
                      const SizedBox(height: 15.0,),
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
                          "AL-2",
                          "AL-3",
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
                      const SizedBox(height: 15.0,),
                      CustomDropdownButtonFormField(
                        value: selectedStage,
                        hintText: "Sale Stage",
                        labelText: "Select Sale Stage",
                        prefixIcon: const Icon(Icons.stacked_bar_chart),
                        onChanged: (value) {
                          print('Selected Stage: $value');
                          setState(() {
                            selectedStage = value;
                          });
                        },
                        items: <String>[
                          "In-Process",
                          "Win",
                          "Lose",
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            alignment: AlignmentDirectional.center,
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Choose a Stage';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15.0,),
                      CustomDropdownButtonFormField(
                        value: selectedSource,
                        hintText: "Lead Source",
                        labelText: "Source",
                        prefixIcon: const Icon(Icons.source),
                        onChanged: (value) {
                          print('Selected Source: $value');
                          setState(() {
                            selectedSource = value;
                          });
                        },
                        items: <String>[
                          "AL-2",
                          "AL-3",
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            alignment: AlignmentDirectional.center,
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Choose a Source';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15.0,),
                      CustomDropdownButtonFormField(
                        value: selectedCampaign,
                        hintText: "Select Campaign",
                        labelText: "Campaign",
                        prefixIcon: const Icon(Icons.campaign),
                        onChanged: (value) {
                          print('Selected Compaign: $value');
                          setState(() {
                            selectedCampaign = value;
                          });
                        },
                        items: <String>[
                          "Cash",
                          "Whole Sale",
                          ""
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            alignment: AlignmentDirectional.center,
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Choose a Campaign';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10.0,),
                      CustomTextFormField(
                        keyboardType: TextInputType.text,
                        labelText: "Next Step",
                        hintText: "Next Step",
                        nameController: nextStepController,
                        validator: (value) {
                          if(value.isEmpty){
                            return "Please Enter Next Step";
                          }
                          else {
                            return null;
                          }
                        },
                        prefixIcon: const Icon(Icons.auto_graph),
                      ),
                      const SizedBox(height: 10.0,),
                      CustomTextFormField(
                        onTap: (){
                          searchUsers(context, assignController);
                        },
                        keyboardType: TextInputType.none,
                        labelText: "Assign To",
                        hintText: "User",
                        nameController: assignController,
                        validator: (value) {
                          if(value.isEmpty){
                            return "Please Enter User";
                          }
                          else {
                            return null;
                          }
                        },
                        prefixIcon: const Icon(Icons.person),
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
                            if(selectedCurrency != null && selectedStage !=null
                                && selectedSource !=null && selectedCampaign != null
                                && selectedType != null){
                              print('Form is valid');
                              setState(() {
                                loading = true;
                              });
                              saveOpportunity();
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
                        Text(widget.existingOpportunity == null ?
                        'Add Opportunity' : 'Edit Opportunity',),
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

  // Date Pick Function
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(1900),
      lastDate: DateTime(2500),
    );
    if (picked != null && picked != date) {
      setState(() {
        date = picked;
        dateController.text = "${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}/${picked.year}";
      });
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
                    leadId = lead['id'];
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
