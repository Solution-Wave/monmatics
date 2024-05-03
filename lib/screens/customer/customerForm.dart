import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../Functions/exportFunctions.dart';
import '../../functions/otherFunctions.dart';
import '../../models/customerItem.dart';
import '../../utils/customWidgets.dart';
import '../../utils/messages.dart';
import '../../utils/themes.dart';
import 'package:uuid/uuid.dart';


class AddCustomer extends StatefulWidget {
  final CustomerHive? existingCustomer;
  const AddCustomer({super.key, this.existingCustomer});

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
  var uuid = const Uuid();
  String? selectedCategory;
  String? selectedAccount;
  String? selectedLimit;
  String? selectedStatus;
  String? selectedType;

  ExportFunctions exportFunctions = ExportFunctions();
  OtherFunctions otherFunctions = OtherFunctions();

  late Future<List<String>> creditLimitList;
  late Future<List<String>> customerTypeList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    creditLimitList = otherFunctions.fetchDropdownOptions("customer_credit_limit");
    customerTypeList = otherFunctions.fetchDropdownOptions("customer_type");
    if(widget.existingCustomer != null){
      nameController.text = widget.existingCustomer!.name;
      phoneController.text = widget.existingCustomer!.phone;
      emailController.text = widget.existingCustomer!.email;
      addressController.text = widget.existingCustomer!.address;
      noteController.text= widget.existingCustomer!.note;
      codeController.text = widget.existingCustomer!.accountCode;
      amountController.text = widget.existingCustomer!.amount;
      taxController.text = widget.existingCustomer!.taxNumber;
      marginController.text = widget.existingCustomer!.margin;
      selectedCategory = widget.existingCustomer!.category;
      selectedAccount = widget.existingCustomer!.account;
      selectedLimit = widget.existingCustomer!.limit;
      selectedStatus = widget.existingCustomer!.status;
      selectedType = widget.existingCustomer!.type;
    }
  }

  // Add Customer Through Hive
  void saveCustomer()async{
    try{
      Box<CustomerHive> customerBox = await Hive.openBox<CustomerHive>("customers");
      if(widget.existingCustomer != null){
        CustomerHive updateCustomer = widget.existingCustomer!;
        updateCustomer.name = nameController.text;
        updateCustomer.email = emailController.text;
        updateCustomer.phone = phoneController.text;
        updateCustomer.category = selectedCategory!;
        updateCustomer.account = selectedAccount!;
        updateCustomer.accountCode = codeController.text;
        updateCustomer.limit = selectedLimit!;
        updateCustomer.amount = amountController.text;
        updateCustomer.taxNumber = taxController.text;
        updateCustomer.status = selectedStatus!;
        updateCustomer.type = selectedType!;
        updateCustomer.margin = marginController.text;
        updateCustomer.note = noteController.text;
        updateCustomer.address = addressController.text;

        await customerBox.put(updateCustomer.key, updateCustomer);
        otherFunctions.updateCustomerInDatabase(updateCustomer);
        showSnackMessage(context, "Customer Updated Successfully");
      } else {
      var uid = uuid.v1();
      // Box? customer = await Hive.openBox<CustomerHive>('customers');
      CustomerHive newCustomer = CustomerHive()
      ..id = uid
      ..name = nameController.text
      ..email = emailController.text
      ..phone = phoneController.text
      ..category = selectedCategory!
      ..account = selectedAccount!
      ..accountCode = codeController.text
      ..limit = selectedLimit!
      ..amount = amountController.text
      ..taxNumber = taxController.text
      ..status = selectedStatus!
      ..type = selectedType!
      ..margin = marginController.text
      ..note = noteController.text
      ..address = addressController.text;

      await customerBox.add(newCustomer);
      showSnackMessage(context, "Customer Added Successfully");
      exportFunctions.postCustomerToApi();
      }
      setState(() {
      nameController.clear();
      emailController.clear();
      phoneController.clear();
      codeController.clear();
      amountController.clear();
      taxController.clear();
      marginController.clear();
      noteController.clear();
      addressController.clear();
      selectedType = null;
      selectedStatus = null;
      selectedLimit = null;
      selectedAccount = null;
      selectedCategory = null;
      });
    } catch (e) {
      print("Error: $e");
    }

  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Customer Details', style: headerTextStyle),
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
                            return null;
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
                            return null;
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
                            return null;
                          }
                          else {
                            return null;
                          }
                        },
                        prefixIcon: const Icon(Icons.numbers),
                      ),
                      const SizedBox(height: 15.0,),
                      AsyncDropdownButton(
                        futureItems: creditLimitList,
                        selectedValue: selectedLimit,
                        onChanged: (value) {
                          print('Selected Credit Limit: $value');
                          setState(() {
                            selectedLimit = value;
                          });
                        },
                        hintText: "Select Credit Limit",
                        labelText: "Credit Limit",
                        prefixIcon: const Icon(Icons.account_balance_wallet),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return null;
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
                            return null;
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
                            return null;
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
                            return null;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15.0,),
                      AsyncDropdownButton(
                        futureItems: customerTypeList,
                        selectedValue: selectedType,
                        onChanged: (value) {
                          print('Selected Type: $value');
                          setState(() {
                            selectedType = value;
                          });
                        },
                        hintText: "Select Type",
                        labelText: "Type",
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
                        keyboardType: TextInputType.number,
                        labelText: "Margin %",
                        hintText: "Margin %",
                        nameController: marginController,
                        validator: (value) {
                          if(value.isEmpty){
                            return null;
                          }
                          else {
                            return null;
                          }
                        },
                        prefixIcon: const Icon(Icons.percent),
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
                             saveCustomer();
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
                         Text(widget.existingCustomer != null ? "Update Customer" : "Add Customer"),
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
