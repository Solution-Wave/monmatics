import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../../Functions/exportFunctions.dart';
import '../../functions/otherFunctions.dart';
import '../../models/leadItem.dart';
import '../../utils/customWidgets.dart';
import '../../utils/messages.dart';
import '../../utils/themes.dart';

class AddLead extends StatefulWidget {
  final LeadHive? existingLead;
  const AddLead({super.key, this.existingLead});

  @override
  State<AddLead> createState() => _AddLeadState();
}

class _AddLeadState extends State<AddLead> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  bool loading = false;
  String selectedCategory  = "";
  String selectedSource  = "";
  String selectedStatus  = "";
  String selectedType  = "";
  var uuid = const Uuid();

  ExportFunctions exportFunctions = ExportFunctions();
  OtherFunctions otherFunctions = OtherFunctions();

  late Future<List<String>> leadSourceList;
  late Future<List<String>> leadCategoryList;
  late Future<List<String>> leadStatusList;
  late Future<List<String>> leadTypeList;

  @override
  void initState() {
    // TODO: implement initState
    leadSourceList = otherFunctions.fetchDropdownOptions("opportunities_lead_source");
    leadStatusList = otherFunctions.fetchDropdownOptions("lead_status");
    leadTypeList = otherFunctions.fetchDropdownOptions("customer_type");
    leadCategoryList = otherFunctions.fetchAndSaveCustomerAndLeadCategories();
    super.initState();
    if(widget.existingLead != null){
      nameController.text = widget.existingLead!.name;
      emailController.text = widget.existingLead!.email;
      phoneController.text = widget.existingLead!.phone;
      addressController.text = widget.existingLead!.address;
      noteController.text = widget.existingLead!.note;
      selectedCategory = widget.existingLead!.category;
      selectedSource = widget.existingLead!.leadSource;
      selectedStatus = widget.existingLead!.status;
      selectedType = widget.existingLead!.type;
    }
  }

  // Add Lead Through Hive
  void saveLead() async{
    try{
      Box<LeadHive> leadBox = await Hive.openBox<LeadHive>("leads");
      if(widget.existingLead != null){
        LeadHive updateLead = widget.existingLead!;
        updateLead.name = nameController.text;
        updateLead.email = emailController.text;
        updateLead.phone = phoneController.text;
        updateLead.category = selectedCategory!;
        updateLead.leadSource = selectedSource!;
        updateLead.status = selectedStatus!;
        updateLead.type = selectedType!;
        updateLead.note = noteController.text;
        updateLead.address = addressController.text;

        await leadBox.put(updateLead.key, updateLead);
        otherFunctions.updateLeadInDatabase(updateLead);
        showSnackMessage(context, "Lead Updated Successfully");

      } else {
        var uid = uuid.v1();
        LeadHive newLead = LeadHive()
          ..id = uid
          ..name = nameController.text
          ..email = emailController.text
          ..phone = phoneController.text
          ..category = selectedCategory!
          ..leadSource = selectedSource!
          ..status = selectedStatus!
          ..type = selectedType!
          ..note = noteController.text
          ..address = addressController.text;

        await leadBox.add(newLead);
        exportFunctions.postLeadToApi();
        showSnackMessage(context, "Lead Added Successfully");
      }
      setState(() {
        nameController.clear();
        emailController.clear();
        phoneController.clear();
        selectedCategory = "";
        selectedSource = "";
        selectedStatus = "";
        selectedType = "";
        noteController.clear();
        addressController.clear();
      });
    } catch (e){
      print("Error: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Lead Details', style: headerTextStyle),
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
                        labelText: "Name",
                        hintText: "Name",
                        keyboardType: TextInputType.text,
                        nameController: nameController,
                        prefixIcon: const Icon(Icons.account_circle),
                        validator: (value) {
                          if(value.isEmpty){
                            return "Please Enter Your Name";
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
                        labelText: "Phone Number",
                        hintText: "03*********",
                        keyboardType: TextInputType.phone,
                        nameController: phoneController,
                        prefixIcon: const Icon(Icons.phone),
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
                      AsyncDropdownButton(
                        futureItems: leadCategoryList,
                        selectedValue: selectedCategory,
                        onChanged: (value) {
                          print('Selected Category: $value');
                          setState(() {
                            selectedCategory = value!;
                          });
                        },
                        hintText: "Select a Category",
                        labelText: "Category",
                        prefixIcon: const Icon(Icons.category),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return null;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15.0,),
                      AsyncDropdownButton(
                        futureItems: leadSourceList,
                        selectedValue: selectedSource,
                        onChanged: (value) {
                          print('Selected Lead Source: $value');
                          setState(() {
                            selectedSource = value!;
                          });
                        },
                        hintText: "Select Lead Source",
                        labelText: "Lead Source",
                        prefixIcon: const Icon(Icons.source),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return null;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15.0,),
                      AsyncDropdownButton(
                        futureItems: leadStatusList,
                        selectedValue: selectedStatus,
                        onChanged: (value) {
                          print('Selected Lead Status: $value');
                          setState(() {
                            selectedStatus = value!;
                          });
                        },
                        hintText: "Select Lead Status",
                        labelText: "Lead Status",
                        prefixIcon: const Icon(Icons.access_time),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return null;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15.0,),
                      AsyncDropdownButton(
                        futureItems: leadTypeList,
                        selectedValue: selectedType,
                        onChanged: (value) {
                          print('Selected Lead Type: $value');
                          setState(() {
                            selectedType = value!;
                          });
                        },
                        hintText: "Select Lead Type",
                        labelText: "Lead Type",
                        prefixIcon: const Icon(Icons.type_specimen),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return null;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10.0,),
                      CustomTextFormField(
                        keyboardType: TextInputType.multiline,
                        labelText: "Note",
                        hintText: "Note",
                        minLines: 1,
                        maxLines: null,
                        nameController: noteController,
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
                      const SizedBox(height: 10.0,),
                      CustomTextFormField(
                        keyboardType: TextInputType.text,
                        labelText: "Address",
                        hintText: "Address",
                        minLines: 1,
                        maxLines: null,
                        nameController: addressController,
                        prefixIcon: const Icon(Icons.map),
                        validator: (value) {
                          if(value.isEmpty){
                            return null;
                          }
                          else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 20.0,),
                      CustomButton(
                        onPressed: () {
                          if(_formKey.currentState!.validate()){
                              print('Form is valid');
                              setState(() {
                                loading = true;
                              });
                              saveLead();
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
                        Text(widget.existingLead != null ? "Update Lead" : "Add Lead"),
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
}
