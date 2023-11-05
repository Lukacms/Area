import 'package:flutter/material.dart';
import 'package:mobile/components/backgroundCircles.dart';
import 'package:mobile/components/loginTextField.dart';
import 'package:mobile/main.dart';
import 'package:mobile/screens/login/sent_reset_password.dart';
import 'package:mobile/theme/style.dart';

// This is the ForgotPassword widget, which is a StatefulWidget that displays 
// the forgot password screen of the app. It has a Stack widget as its body,
//  which contains a BackgroundCircles widget and a RefreshIndicator widget.
//   The RefreshIndicator widget allows the user to refresh the list of areas
//    by pulling down on the screen.

// The ForgotPassword widget also has a Column widget as its child, which 
// contains a LoginTextField widget for entering the user's email address
//  and a TextButton widget for resetting the user's password. The LoginTextField 
//  widget takes in several parameters including a description, a placeholder, a 
//  isPassword flag, a isEmail flag, and a controller. The TextButton widget takes
//   in a child and an onPressed function that sends a reset password email to the user's email address.

// The ForgotPassword widget also has an isValidEmail function that checks if the 
// user's email address is valid using a regular expression.

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();
  Key emailField = const Key('emailField');
  Key resetPasswordButton = const Key('resetPasswordButton');

  bool isValidEmail(String email) {
    // Regular expression to match email addresses
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    // Check if the email matches the regular expression
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    final safePadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.darkBlue,
      body: Stack(
        children: [
          const BackgroundCircles(),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: safePadding + blockHeight * 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: AppColors.lightBlue,
                      ),
                    ),
                    Text(
                      "Mot de passe oublié",
                      style: TextStyle(
                          fontSize: 24,
                          color: AppColors.white,
                          fontFamily: 'Roboto-Bold'),
                    )
                  ],
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: LoginTextField(
                  key: emailField,
                  description: "E-Mail",
                  placeholder: 'yourname@example.com',
                  isPassword: false,
                  isEmail: true,
                  controller: emailController,
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: blockWidth),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: blockHeight * 5),
                      width: blockWidth * 3,
                      height: blockHeight * 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.greyBlue,
                      ),
                      child: TextButton(
                        key: resetPasswordButton,
                        child: Text(
                          "Reset Password",
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 20,
                          ),
                        ),
                        onPressed: () {
                          if (!isValidEmail(emailController.text)) {
                            return;
                          }
                          //sendResetPassword();
                          Navigator.of(context).pushReplacement(
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) {
                                return SentResetPassword(
                                  mail: emailController.text,
                                );
                              },
                              transitionDuration:
                                  const Duration(milliseconds: 200),
                              transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) =>
                                  SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(1, 0),
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
              ),
            ],
          )
        ],
      ),
    );
  }
}
