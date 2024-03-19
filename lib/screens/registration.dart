import 'package:flutter/material.dart';
import '../components/loginInputField.dart';
import '../components/passwordInputField.dart';
import '../controllers/authenticationControllers.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/messages.dart';
import 'loginScreen.dart';


class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  AuthenticateController registerationController = AuthenticateController();
  bool showPassword = false;

  void RegisterUser()async{
  var result  = await registerationController.register(emailController.text, nameController.text, passwordController.text);
  if(result[0]==true)
    {
     if(result[0]==true)
      {
        showSnackMessage(context, result[1]);
      Navigator.pushReplacement(context, MaterialPageRoute(builder
          : (BuildContext) => LoginScreen()));
    }
    else if(result[0]!=true)
      showSnackMessage(context, result[1]);

    }
  else
    print(result[1]);

  }
  @override
  Widget build(BuildContext context) {
    void changePassField() {
      showPassword ? showPassword=false : showPassword =true;
    }
    return SafeArea(
      child: Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: formkey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                inputCard(
                    'Name',
                    Icon(Icons.person, color: primaryColor,),
                        (val) {
                      if (val == null || val.isEmpty) {
                        return validatorText;
                      }
                      else {
                        return null;
                      }
                    },
                    nameController),
                inputCard(
                    'Username',
                    Icon(Icons.mail, color: primaryColor,),
                        (val) {
                      if (val == null || val.isEmpty) {
                        return validatorText;
                      }
                      else {
                        return null;
                      }
                    },
                    usernameController),
                inputCard(
                    'Email',
                    Icon(Icons.mail, color: primaryColor,),
                        (val) {
                      if (val == null || val.isEmpty) {
                        return validatorText;
                      }
                      else {
                        return null;
                      }
                    },
                    emailController),
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
                      backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.teal)
                  ),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    if(formkey.currentState!.validate())
                    {
                      RegisterUser();
                    }else{
                      showSnackMessage(context, 'Fields should not be left empty');
                    }

                  },

                  child: Text('SignUp',),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    );
  }
}
