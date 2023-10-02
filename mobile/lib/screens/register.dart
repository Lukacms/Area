import 'package:mobile/components/loginTextField.dart';
import 'package:mobile/components/halfloginTextField.dart';
import 'package:mobile/main.dart';
import 'package:flutter/material.dart';
import 'package:mobile/components/backgroundCircles.dart';
import 'package:mobile/screens/login.dart';
import 'package:mobile/theme/style.dart';

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
  TextEditingController pseudoController = TextEditingController();

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
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ));
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
                      description: "Prénom",
                      placeholder: 'Votre Prénom',
                      isPassword: false,
                      controller: nameController),
                  SizedBox(
                    width: blockWidth * 0.4,
                  ),
                  HalfLoginTextField(
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
                  description: "Nom d'utilisateur",
                  placeholder: 'Votre Pseudonyme',
                  isPassword: false,
                  controller: pseudoController),
              SizedBox(
                height: blockHeight * 5,
              ),
              LoginTextField(
                description: "Adresse E-Mail",
                placeholder: 'votreadresse@example.com',
                isPassword: false,
                controller: emailController,
              ),
              SizedBox(
                height: blockHeight * 5,
              ),
              LoginTextField(
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
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
