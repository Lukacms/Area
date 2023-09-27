import 'package:flutter/material.dart';
import 'package:mobile/components/backgroundCircles.dart';
import 'package:mobile/main.dart';
import 'package:mobile/theme/style.dart';

class SentResetPassword extends StatelessWidget {
  final String mail;
  const SentResetPassword({
    super.key,
    required this.mail,
  });

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
                        Navigator.popUntil(
                          context,
                          ModalRoute.withName('/'),
                        );
                      },
                      icon: Icon(
                        Icons.close,
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
              Padding(
                padding: EdgeInsets.only(top: blockHeight * 2),
                child: SizedBox(
                  width: screenWidth * 0.9,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "We just sent you an email at $mail with a link to reset your password if your Email address is linked to an existing account.",
                        style: TextStyle(
                          color: AppColors.white,
                        ),
                      ),
                      SizedBox(height: blockHeight * 2),
                      Text(
                        "Check your inbox, and don't forget your spam!",
                        style: TextStyle(
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: blockHeight * 8),
              SizedBox(
                width: screenWidth * 0.9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Didn't receive the link?",
                          style: TextStyle(color: AppColors.white),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            alignment: Alignment.topLeft,
                          ),
                          onPressed: () {},
                          child: Text(
                            "Resend mail",
                            style: TextStyle(color: AppColors.lightBlue),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
