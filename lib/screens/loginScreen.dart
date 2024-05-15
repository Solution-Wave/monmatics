import 'package:flutter/material.dart';
import '../Functions/importFunctions.dart';
import 'bottomNavigationBarScreen.dart';
import '../controllers/authenticationControllers.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/customWidgets.dart';
import '../utils/messages.dart';

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
    var result = await loginController.login(emailController.text, passwordController.text);
    print(result);
    setState(() {
      loading = false;
    });
    int statusCode = result['status'];
    String message = result['message'];
    if (result["result"] == true) {
      emailController.clear();
      passwordController.clear();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext) => App()));
      importFunctions.fetchUsersFromApi();
      importFunctions.fetchTasksFromApi();
      importFunctions.fetchContactsFromApi();
      importFunctions.fetchCustomersFromApi();
      importFunctions.fetchLeadsFromApi();
      importFunctions.fetchNotesFromApi();
      importFunctions.fetchCallsFromApi();
      importFunctions.fetchOpportunitiesFromApi();
      showSnackMessage(context, message);
    } else if (result[0] == false) {
      showSnackMessage(context, result[1]);
    } else {
      if (statusCode == -1) {
        // Network error
        showSnackMessage(context, message);
      } else {
        // Login failed due to other reasons
        showSnackMessage(context, message);
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: const Text("Login"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/Logo2.png', width: MediaQuery.of(context).size.width * 0.6),
                  Image.asset('assets/_Logo.png', width: MediaQuery.of(context).size.width * 0.7),
                  const SizedBox(height: 40.0),
                  CustomTextFormField(
                    nameController: emailController,
                    hintText: "Email",
                    labelText: "Email",
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return validatorText;
                      } else if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(val)) {
                        return ("Please Enter a valid email");
                      } else {
                        return null;
                      }
                    },
                    prefixIcon: Icon(Icons.person, color: primaryColor),
                  ),
                  const SizedBox(height: 15.0),
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
                        icon: showPassword ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
                      ),
                      hintText: "Password",
                      labelText: "Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    validator: (value) {
                      RegExp regex = RegExp(r'^.{8,}$');
                      if (value!.isEmpty) {
                        return ("Password is required for login");
                      }
                      if (!regex.hasMatch(value)) {
                        return ("Enter Valid Password(Min. 8 Character)");
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15.0),
                  CustomButton(
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      if (_formKey.currentState!.validate()) {
                        DoLogin();
                      } else {
                        showSnackMessage(context, 'Fields should not be left empty');
                      }
                    },
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 50.0),
                    child: loading
                        ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                        : const Text(
                      "Login",
                      style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                    ),
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
