import 'package:mobile/back/local_storage.dart';
import 'package:mobile/components/loginTextField.dart';
import 'package:mobile/main.dart';
import 'package:flutter/material.dart';
import 'package:mobile/components/backgroundCircles.dart';
import 'package:mobile/screens/forgot_password.dart';
import 'package:mobile/screens/home/home_page.dart';
import 'package:mobile/theme/style.dart';
import 'package:mobile/back/api.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final safePadding = MediaQuery.of(context).padding.top;
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    screenSize = MediaQuery.of(context).size;
    screenHeight = screenSize.height;
    screenWidth = screenSize.width;
    blockWidth = screenWidth / 5;
    blockHeight = screenHeight / 100;

    return Scaffold(
      key: _scaffoldKey,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: blockWidth * 0.5),
                    child: TextButton(
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(color: AppColors.lightBlue),
                      ),
                      onPressed: () {
                        _scaffoldKey.currentState?.openEndDrawer();
                      },
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
                    List res =
                        login(emailController.text, passwordController.text);
                    if (res[0]) {
                      saveToken(res[1]);
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => HomePage(token: res[1]),
                      ));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Login failed. Please try again."),
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
      endDrawer: ForgotPassword(),
    );
  }
}
