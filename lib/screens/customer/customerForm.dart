import 'package:flutter/material.dart';
import 'package:monmatics/utils/messages.dart';
import '../../utils/customWidgets.dart';
import '../../utils/themes.dart';

class AddCustomer extends StatefulWidget {
  const AddCustomer({super.key});

  @override
  State<AddCustomer> createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {

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
  String? selectedAccount;
  String? selectedLimit;
  String? selectedStatus;
  String? selectedType;


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Customer', style: headerTextStyle),
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
                      const Text("Customer Details",
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
                        value: selectedAccount,
                        hintText: "Select Account",
                        labelText: "Main Account",
                        prefixIcon: const Icon(Icons.account_balance),
                        onChanged: (value) {
                          print('Selected Main Account: $value');
                          setState(() {
                            selectedAccount = value;
                          });
                        },
                        items: <String>[
                          "0205005052555",
                          "5550555588494",
                          "7348697356376",
                          "8947534579784",
                          "4587975848795",
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            alignment: AlignmentDirectional.center,
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Choose a Main Account';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10.0,),
                      CustomTextFormField(
                        keyboardType: TextInputType.text,
                        labelText: "Account Code",
                        hintText: "Account Code",
                        nameController: codeController,
                        validator: (value) {
                          if(value.isEmpty){
                            return "Please Enter Your Account Code";
                          }
                          else {
                            return null;
                          }
                        },
                        prefixIcon: const Icon(Icons.numbers),
                      ),
                      const SizedBox(height: 15.0,),
                      CustomDropdownButtonFormField(
                        value: selectedLimit,
                        hintText: "Select Credit Limit",
                        labelText: "Credit Limit",
                        prefixIcon: const Icon(Icons.account_balance_wallet),
                        onChanged: (value) {
                          print('Selected Credit Limit: $value');
                          setState(() {
                            selectedLimit = value;
                          });
                        },
                        items: <String>[
                          "Cash",
                          "Whole Sale"
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            alignment: AlignmentDirectional.center,
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Choose a Credit Limit';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10.0,),
                      CustomTextFormField(
                        keyboardType: TextInputType.text,
                        labelText: "Credit Amount",
                        hintText: "Credit Amount",
                        nameController: amountController,
                        validator: (value) {
                          if(value.isEmpty){
                            return "Please Enter Credit Amount";
                          }
                          else {
                            return null;
                          }
                        },
                        prefixIcon: const Icon(Icons.attach_money),
                      ),
                      const SizedBox(height: 10.0,),
                      CustomTextFormField(
                        keyboardType: TextInputType.text,
                        labelText: "Tax Number",
                        hintText: "Tax Number",
                        nameController: taxController,
                        validator: (value) {
                          if(value.isEmpty){
                            return "Please Enter Tax Number";
                          }
                          else {
                            return null;
                          }
                        },
                        prefixIcon: const Icon(Icons.confirmation_number),
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
                        labelText: "Margin %",
                        hintText: "Margin %",
                        nameController: marginController,
                        validator: (value) {
                          if(value.isEmpty){
                            return "Please Enter Margin %";
                          }
                          else {
                            return null;
                          }
                        },
                        prefixIcon: const Icon(Icons.percent),
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
                           if(selectedCategory != null && selectedAccount !=null
                               && selectedLimit !=null && selectedStatus != null
                              && selectedType != null){
                             print('Form is valid');
                             setState(() {
                               loading = true;
                             });
                             showSnackMessage(context, "Customer Added Successfully");
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
                       text: 'Add Customer',
                        padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 50.0)
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
