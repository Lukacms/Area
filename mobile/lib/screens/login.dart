import 'package:mobile/components/loginTextField.dart';
import 'package:mobile/main.dart';
import 'package:flutter/material.dart';
import 'package:mobile/components/backgroundCircles.dart';
import 'package:mobile/theme/style.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    screenHeight = screenSize.height;
    screenWidth = screenSize.width;
    blockWidth = screenWidth / 5;
    blockHeight = screenHeight / 100;

    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return MaterialApp(
      title: 'Login',
      home: Scaffold(
          backgroundColor: AppColors.darkBlue,
          body: Stack(
            children: [
              const BackgroundCircles(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/logoFastR.png',
                        width: 300,
                      ),
                    ],
                  ),
                  LoginTextField(
                      description: "E-Mail",
                      placeholder: 'yourname@example.com',
                      isPassword: false,
                      controller: emailController),
                  SizedBox(
                    height: blockHeight * 5,
                  ),
                  LoginTextField(
                    description: "Password",
                    placeholder: '********',
                    isPassword: true,
                    controller: passwordController,
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
