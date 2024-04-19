import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:monmatics/models/leadItem.dart';
import '../../utils/customWidgets.dart';
import '../../utils/messages.dart';
import '../../utils/themes.dart';
import 'package:uuid/uuid.dart';


class AddOpportunity extends StatefulWidget {
  const AddOpportunity({super.key});

  @override
  State<AddOpportunity> createState() => _AddOpportunityState();
}

class _AddOpportunityState extends State<AddOpportunity> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController leadController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController taxController = TextEditingController();
  TextEditingController marginController = TextEditingController();

  bool loading = false;
  var uuid = const Uuid();
  String? selectedCurrency;
  String? selectedAccount;
  String? selectedLimit;
  String? selectedStatus;
  String? selectedType;
  String? relatedId;
  DateTime date = DateTime.now();

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



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Opportunity Details', style: headerTextStyle),
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
                            return "Please Enter Your Phone";
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
                        onTap: () => _selectDate(context),
                        keyboardType: TextInputType.none,
                        nameController: dateController,
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
                        onPressed: () {
                          if(_formKey.currentState!.validate()){
                            if(selectedCurrency != null && selectedAccount !=null
                                && selectedLimit !=null && selectedStatus != null
                                && selectedType != null){
                              print('Form is valid');
                              setState(() {
                                loading = true;
                              });
                              // addCustomer();
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
                        const Text("Add Opportunity"),
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

  void searchLead(BuildContext context, TextEditingController textFieldController) async {
    try {
      if (!Hive.isBoxOpen('leads')) {
        await Hive.openBox<LeadHive>('leads');
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
}
