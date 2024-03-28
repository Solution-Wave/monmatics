import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/customWidgets.dart';
import '../../utils/messages.dart';
import '../../utils/themes.dart';

class AddCustomer extends StatefulWidget {
  const AddCustomer({super.key});

  @override
  State<AddCustomer> createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {

  final GlobalKey<FormState> formKey = GlobalKey();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Customer', style: headerTextStyle),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    CustomTextFormField(
                      labelText: "Name",
                      hintText: "Name",
                      keyboardType: TextInputType.text,
                      nameController: nameController,
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
                      nameController: phoneController,validator: (value) {
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
                      keyboardType: TextInputType.text,
                      labelText: "Address",
                      hintText: "Address",
                      nameController: addressController,
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
                      labelText: "Note",
                      hintText: "Note",
                      nameController: noteController,
                      validator: (value) {
                        if(value.isEmpty){
                          return "Please Enter A Note";
                        }
                        else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 20.0,),
                   ElevatedButton(
                      onPressed: (){
                        if(formKey.currentState!.validate()){
                          setState(() {
                            loading = true;
                          });
                        }
                        else {
                          setState(() {
                            loading = false;
                          });
                              showSnackMessage(context, "Please Fill All The Fields");
                            }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: popupmenuButtonCol,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 50.0)
                      ),
                        child: loading ? const SizedBox(
                          height: 18.0,
                            width: 18.0,
                            child: CircularProgressIndicator())
                            : const Text("Add Customer", style: TextStyle(fontSize: 18.0),)
                   )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
