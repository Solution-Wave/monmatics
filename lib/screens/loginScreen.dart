import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/loginInputField.dart';
import '../components/passwordInputField.dart';
import '../controllers/authenticationControllers.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
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

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  AuthenticateController loginController = AuthenticateController();

  bool showPassword = false;
  bool loading = false;
  String? selectedUrl;
  void DoLogin() async {
    setState(() {
      loading = true;
    });
    var result = await  loginController.login(usernameController.text, passwordController.text);
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
      usernameController.clear();
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
    usernameController.text = 'hassaanahmad4321@gmail.com';
    passwordController .text = 'admin123';
  }

  @override
  void dispose() {
    // TODO: implement dispose
    usernameController.dispose();
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
                  key: formkey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DropdownButtonFormField<String>(
                        hint: const Text('Please Choose a Link'),
                        borderRadius: BorderRadius.circular(20.0),
                        decoration: InputDecoration(
                          labelText: "Link",
                          prefixIcon: const Icon(Icons.link),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(width: 1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.blue, width: 2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        value: selectedUrl,
                        items: <String>[
                          "https://dev.monmatics.com/api",
                          "https://monmatics.com/api"
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedUrl = newValue;
                            baseUrl = newValue ?? '';
                            updateUrls(baseUrl); // Call the function to update URLs
                          });
                        },

                      ),
                      inputCard(
                          'Email',
                          Icon(Icons.person, color: primaryColor,),
                              (val) {
                            if (val == null || val.isEmpty) {
                              return validatorText;
                            }
                            else {
                              return null;
                            }
                          },
                          usernameController
                      ),

                      passwordInputCard(
                          showPassword,
                          'Password',
                          //change
                              () {
                            setState(() {
                              changePassField();
                            });
                          },
                              (val) {
                            if (val == null || val.isEmpty) {
                              return validatorText;
                            }
                            else {
                              return null;
                            }
                          },
                          passwordController
                      ),
                      FilledButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith((states) => primaryColor)
                        ),
                        onPressed: () async{
                          FocusScope.of(context).unfocus();
                          if(formkey.currentState!.validate())
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
                        child: loading?
                        const SizedBox(
                          height: 18.0,
                          width: 18.0,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                            :
                        const Text('Login',),
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
