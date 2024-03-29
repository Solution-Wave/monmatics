import 'package:flutter/material.dart';
import 'package:monmatics/utils/messages.dart';
import '../../utils/customWidgets.dart';
import '../../utils/themes.dart';

class AddLead extends StatefulWidget {
  const AddLead({super.key});

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
  TextEditingController codeController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController taxController = TextEditingController();
  TextEditingController marginController = TextEditingController();

  bool loading = false;
  String? selectedCategory;
  String? selectedSource;
  String? selectedLimit;
  String? selectedStatus;
  String? selectedType;


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Lead', style: headerTextStyle),
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
                      const Text("Lead Details",
                        style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),),
                      const SizedBox(height: 20.0,),
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
                            return "Please Enter Your Email";
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
                            return "Please Enter Your Phone";
                          }
                          else {
                            return null;
                          }
                        },

                      ),
                      const SizedBox(height: 15.0,),
                      CustomDropdownButtonFormField(
                        value: selectedCategory,
                        hintText: "Select a Category",
                        labelText: "Category",
                        prefixIcon: const Icon(Icons.category),
                        onChanged: (value) {
                          print('Selected Category: $value');
                          setState(() {
                            selectedCategory = value;
                          });
                        },
                        items: <String>[
                          "Developer",
                          "Front End",
                          "Full Stack",
                          "SQA",
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            alignment: AlignmentDirectional.center,
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Choose a Category';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15.0,),
                      CustomDropdownButtonFormField(
                        value: selectedSource,
                        hintText: "Select Source",
                        labelText: "Lead Source",
                        prefixIcon: const Icon(Icons.source),
                        onChanged: (value) {
                          print('Selected Lead Source: $value');
                          setState(() {
                            selectedSource = value;
                          });
                        },
                        items: <String>[
                          "AL1",
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            alignment: AlignmentDirectional.center,
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Choose Lead Source';
                          }
                          return null;
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
                          "Active",
                          "Suspended",
                          "Closed",
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
                      const SizedBox(height: 10.0,),
                      CustomTextFormField(
                        keyboardType: TextInputType.text,
                        labelText: "Note",
                        hintText: "Note",
                        minLines: 1,
                        maxLines: null,
                        nameController: noteController,
                        validator: (value) {
                          if(value.isEmpty){
                            return "Please Enter A Note";
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
                            return "Please Enter Your Address";
                          }
                          else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 20.0,),
                      CustomButton(
                        loading: loading,
                        onPressed: () {
                          if(_formKey.currentState!.validate()){
                            if(selectedCategory != null && selectedSource !=null
                                && selectedLimit !=null && selectedStatus != null
                                && selectedType != null){
                              print('Form is valid');
                              setState(() {
                                loading = true;
                              });
                              showSnackMessage(context, "Lead Added Successfully");
                              setState(() {
                                loading = false;
                              }
                              );
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
                        text: 'Add Lead',
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
