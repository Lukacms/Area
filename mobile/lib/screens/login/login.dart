import 'package:mobile/back/local_storage.dart';
import 'package:mobile/components/loginTextField.dart';
import 'package:mobile/main.dart';
import 'package:flutter/material.dart';
import 'package:mobile/components/backgroundCircles.dart';
import 'package:mobile/screens/home/home_page.dart';
import 'package:mobile/screens/login/forgot_password.dart';
import 'package:mobile/theme/style.dart';
import 'package:mobile/back/api.dart';
import 'package:mobile/screens/register.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void login() async {
    List res = [];
    await serverLogin(emailController.text, passwordController.text)
        .then((value) {
      res = value;
    });
    if (res[0]) {
      Map<String, dynamic> user = {};
      await saveToken(res[1]);
      await serverGetSelfInfos(res[1]).then((value) {
        saveUser(value);
        user = value;
      });
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => HomePage(
          user: user,
          token: res[1],
        ),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login failed. Please try again."),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/logoFastR.png',
                      width: 300,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: blockHeight * 5,
              ),
              LoginTextField(
                  description: "E-Mail",
                  placeholder: 'yourname@example.com',
                  isPassword: false,
                  isEmail: true,
                  controller: emailController),
              SizedBox(
                height: blockHeight * 5,
              ),
              LoginTextField(
                description: "Password",
                placeholder: '********',
                isPassword: true,
                controller: passwordController,
                onValidate: () {
                  login();
                },
              ),
              Padding(padding: EdgeInsets.only(top: blockHeight * 2)),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: blockWidth * 0.5),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(color: AppColors.lightBlue),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            opaque: false,
                            pageBuilder: (BuildContext context, _, __) =>
                                const ForgotPassword(),
                            transitionDuration:
                                const Duration(milliseconds: 200),
                            transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) =>
                                SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, 1),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(top: blockHeight * 2)),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: blockWidth * 0.5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(
                            color: AppColors.white,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: blockWidth * 1.5),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            child: Text(
                              "Register Now",
                              style: TextStyle(color: AppColors.lightBlue),
                            ),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const RegisterScreen(),
                              ));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
                    "Sign In",
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {
                    login();
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
