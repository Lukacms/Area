import 'package:mobile/back/api.dart';
import 'package:mobile/components/loginTextField.dart';
import 'package:mobile/components/halfloginTextField.dart';
import 'package:mobile/main.dart';
import 'package:flutter/material.dart';
import 'package:mobile/components/backgroundCircles.dart';
import 'package:mobile/screens/login/login.dart';
import 'package:mobile/theme/style.dart';

// This is the RegisterScreen widget, which displays the registration screen
//  for a new user. It takes in several parameters including TextEditingController
//   objects for the user's email, password, name, surname, and username, as well 
//   as several Key objects for the various text fields and buttons.

// The widget has a Scaffold widget as its parent, which provides the basic structure 
// for the page. The Scaffold widget has a Stack widget as its child, which allows 
// for layering of widgets.

// The Stack widget contains a Column widget, which contains the main content of 
// the page. The Column widget has a Padding widget as its child, which adds some 
// padding to the content.

// The content of the page is divided into several sections, each containing a 
// LoginTextField or HalfLoginTextField widget for entering user information.
//  The LoginTextField and HalfLoginTextField widgets take in several parameters 
//  including a Key object, a String for the field's label, a String for the field's 
//  placeholder text, a bool indicating whether the field is a password field, a
//   TextEditingController object for the field's text, and a bool indicating whether
//    the field is an email field.

// The widget also has a "Sign Up" button, which registers the user when pressed. 
// When the button is pressed, the serverRegister function is called with the
//  user's email, password, name, surname, and username. If the registration is 
//  successful, the user is redirected to the login screen and a success message 
//  is displayed. If the registration fails, an error message is displayed.

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  Key usernameField = const Key('usernameField');
  Key passwordField = const Key('passwordField');
  Key registerButton = const Key('signupButton');
  Key nameField = const Key('nameField');
  Key surnameField = const Key('surnameField');
  Key emailField = const Key('emailField');

  @override
  Widget build(BuildContext context) {
    final safePadding = MediaQuery.of(context).padding.top;
    screenSize = MediaQuery.of(context).size;
    screenHeight = screenSize.height;
    screenWidth = screenSize.width;
    blockWidth = screenWidth / 5;
    blockHeight = screenHeight / 100;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.darkBlue,
      body: Stack(
        children: [
          const BackgroundCircles(),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: safePadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        print("Login");
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.chevron_left,
                        color: AppColors.lightBlue,
                        size: safePadding * 1.5,
                      ),
                      label: Text(
                        "Register",
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 24,
                          fontFamily: "Roboto-SemiBold",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: blockHeight * 5,
              ),
              Row(
                children: [
                  SizedBox(
                    width: blockWidth * 0.5,
                  ),
                  HalfLoginTextField(
                      key: nameField,
                      description: "Prénom",
                      placeholder: 'Votre Prénom',
                      isPassword: false,
                      controller: nameController),
                  SizedBox(
                    width: blockWidth * 0.4,
                  ),
                  HalfLoginTextField(
                      key: surnameField,
                      description: "Nom",
                      placeholder: 'Votre Nom',
                      isPassword: false,
                      controller: surnameController),
                ],
              ),
              SizedBox(
                height: blockHeight * 5,
              ),
              LoginTextField(
                  key: usernameField,
                  description: "Nom d'utilisateur",
                  placeholder: 'Votre Pseudonyme',
                  isPassword: false,
                  controller: usernameController),
              SizedBox(
                height: blockHeight * 5,
              ),
              LoginTextField(
                key: emailField,
                description: "Adresse E-Mail",
                placeholder: 'votreadresse@example.com',
                isPassword: false,
                controller: emailController,
                isEmail: true,
              ),
              SizedBox(
                height: blockHeight * 5,
              ),
              LoginTextField(
                key: passwordField,
                description: "Mot de passe",
                placeholder: '********',
                isPassword: true,
                controller: passwordController,
              ),
              Container(
                margin: EdgeInsets.only(top: blockHeight * 5),
                width: blockWidth * 3,
                height: blockHeight * 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.greyBlue,
                ),
                child: TextButton(
                  key: registerButton,
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () async {
                    bool res = false;
                    await serverRegister(
                      emailController.text,
                      passwordController.text,
                      nameController.text,
                      surnameController.text,
                      usernameController.text,
                    ).then((value) {
                      res = value;
                    });
                    if (res) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text("Successfully registered, please login."),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Register failed. Please try again."),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
