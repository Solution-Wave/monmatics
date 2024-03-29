import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/authenticationControllers.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/customWidgets.dart';
import '../utils/messages.dart';
import '../utils/urlprovider.dart';
import '../utils/urls.dart';
import 'firstScreen.dart';


class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  AuthenticateController loginController = AuthenticateController();

  bool showPassword = false;
  bool loading = false;
  String? selectedUrl;
  void DoLogin() async {
    setState(() {
      loading = true;
    });
    var result = await  loginController.login(emailController.text, passwordController.text);
    print(result);
    setState(() {
      loading = false;
    });
    int statusCode = result['status'];
    String message = result['message'];
    if( result["result"] == true)
    {
      updateUrls(selectedUrl ?? '');
      Provider.of<UrlProvider>(context, listen: false)
          .setSelectedUrl(selectedUrl ?? '');
      emailController.clear();
      passwordController.clear();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext)=>  App()));
      showSnackMessage(context, message);

    }
    else if (result[0]==false){
      showSnackMessage(context, result[1]);
    }
    else {
      if (statusCode == -1) {
        // Network error
        showSnackMessage(context, message);
      } else {
        // Login failed due to other reasons
        showSnackMessage(context, message);
      }
    }
    //Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext)=>  App()));
  }


  @override

  void initState() {
    // TODO: implement initState
    super.initState();
    emailController.text = 'hassaanahmad4321@gmail.com';
    passwordController .text = 'admin123';
  }

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void changePassField() {
      showPassword ? showPassword=false : showPassword =true;
    }
    return SafeArea(
      child:
      Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/_Logo.png', width: MediaQuery.of(context).size.width*0.75,),
              const SizedBox(height: 90.0,),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomDropdownButtonFormField(
                        value: selectedUrl,
                        hintText: 'Select Your Link',
                        labelText: 'Link',
                        prefixIcon: const Icon(Icons.link),
                        onChanged: (value) {
                          setState(() {
                            selectedUrl = value;
                            baseUrl = value ?? '';
                            updateUrls(baseUrl); // Call the function to update URLs
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a value';
                          }
                          return null;
                        },
                        items: <String>[
                          "https://dev.monmatics.com/api",
                          "https://monmatics.com/api"
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 15.0,),
                      CustomTextFormField(
                          nameController: emailController,
                          hintText: "Email",
                          labelText: "Email",
                          keyboardType: TextInputType.emailAddress,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return validatorText;
                            }
                            else {
                              return null;
                            }
                          },
                          prefixIcon: Icon(Icons.person, color: primaryColor,),
                      ),
                      const SizedBox(height: 15.0,),
                      CustomTextFormField(
                        nameController: passwordController,
                        hintText: "Password",
                        labelText: "Password",
                        keyboardType: TextInputType.text,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return validatorText;
                          }
                          else {
                            return null;
                          }
                        },
                        prefixIcon: Icon(Icons.password, color: primaryColor,),
                      ),
                      const SizedBox(height: 15.0,),
                      CustomButton(
                          loading: loading,
                          onPressed: () async{
                            FocusScope.of(context).unfocus();
                            if(_formKey.currentState!.validate())
                            {
                              if(selectedUrl != null) {
                                print(baseUrl);
                                DoLogin();
                              }
                              else{
                                print("Please Choose a Link");
                                showSnackMessage(context, 'Please Choose a Link');
                              }
                            }else{
                              showSnackMessage(context, 'Fields should not be left empty');
                            }
                          },
                          text: "Login",
                          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 40.0),
                      ),
                    ],
                  ),
                ),
              ),
              // InkWell(
              //   onTap: (){
              //     Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=> RegistrationScreen()));
              //   },
              //   child: Text('Signup', style: TextStyle(
              //       decoration: TextDecoration.underline,
              //       color: Colors.blue
              //   ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}


