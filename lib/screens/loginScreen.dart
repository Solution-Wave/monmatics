import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Functions/importFunctions.dart';
import 'bottomNavigationBarScreen.dart';
import '../controllers/authenticationControllers.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/customWidgets.dart';
import '../utils/messages.dart';
import '../utils/urlprovider.dart';
import '../utils/urls.dart';


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

  bool showPassword = true;
  bool loading = false;
  String? selectedUrl;

  ImportFunctions importFunctions = ImportFunctions();

  // Login Function
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
      // updateUrls(selectedUrl ?? '');
      // Provider.of<UrlProvider>(context, listen: false)
      //     .setSelectedUrl(loginUrl ?? '');
      emailController.clear();
      passwordController.clear();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext)=>  App()));
      importFunctions.fetchUsersFromApi();
      importFunctions.fetchTasksFromApi();
      importFunctions.fetchContactsFromApi();
      importFunctions.fetchCustomersFromApi();
      importFunctions.fetchLeadsFromApi();
      importFunctions.fetchNotesFromApi();
      importFunctions.fetchCallsFromApi();
      importFunctions.fetchOpportunitiesFromApi();
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
  }

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Future<void> saveSelectedUrl(String value) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     selectedUrl = value;
  //     baseUrl = value;
  //   });
  //   await prefs.setString('selectedUrl', value);
  //   updateUrls(baseUrl);
  // }

  @override
  Widget build(BuildContext context) {
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
                      // CustomDropdownButtonFormField(
                      //   value: selectedUrl,
                      //   hintText: 'Select Your Link',
                      //   labelText: 'Link',
                      //   prefixIcon: const Icon(Icons.link),
                      //   onChanged: (value) {
                      //     setState(() {
                      //       selectedUrl = value;
                      //       baseUrl = value ?? '';
                      //       updateUrls(baseUrl);
                      //       saveSelectedUrl(value!);
                      //     });
                      //   },
                      //   validator: (value) {
                      //     if (value == null || value.isEmpty) {
                      //       return 'Please select a value';
                      //     }
                      //     return null;
                      //   },
                      //   items: <String>[
                      //     "https://dev.monmatics.com/api",
                      //     "https://monmatics.com/api"
                      //   ].map((String value) {
                      //     return DropdownMenuItem<String>(
                      //       alignment: AlignmentDirectional.center,
                      //       value: value,
                      //       child: Text(value),
                      //     );
                      //   }).toList(),
                      // ),
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
                      TextFormField(
                        controller: passwordController,
                        keyboardType: TextInputType.text,
                        obscureText: showPassword,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock, color: primaryColor),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                showPassword = !showPassword;
                              });
                            },
                            icon: showPassword ? const Icon(Icons.visibility_off) :  const Icon(Icons.visibility),
                          ),
                          hintText: "Password",
                          labelText: "Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return validatorText;
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 15.0,),
                      CustomButton(
                          onPressed: () async{
                            FocusScope.of(context).unfocus();
                            if(_formKey.currentState!.validate())
                            {
                              print(loginUrl);
                              DoLogin();
                            }else{
                              showSnackMessage(context, 'Fields should not be left empty');
                            }
                          },
                          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 40.0),
                          child: loading ?
                          const SizedBox(height: 18,width: 18,
                          child: CircularProgressIndicator(color: Colors.white,),):
                              const Text("Login"),
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


