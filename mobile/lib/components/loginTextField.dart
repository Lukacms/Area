import 'package:flutter/material.dart';
import 'package:mobile/theme/style.dart';
import 'package:mobile/main.dart';

class LoginTextField extends StatefulWidget {
  final String description;
  final String placeholder;
  final bool isPassword;
  final bool isEmail;
  final TextEditingController controller;
  const LoginTextField({
    super.key,
    required this.description,
    required this.placeholder,
    required this.isPassword,
    required this.controller,
    this.isEmail = false,
  });

  @override
  State<LoginTextField> createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<LoginTextField> {
  bool isEmailValid = true;
  bool isValidEmail(String email) {
    // Regular expression to match email addresses
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    // Check if the email matches the regular expression
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    screenHeight = screenSize.height;
    screenWidth = screenSize.width;
    blockWidth = screenWidth / 5;
    blockHeight = screenHeight / 100;
    return Column(
      children: [
        SizedBox(
          width: blockWidth * 4,
          child: Text(
            widget.description,
            style: TextStyle(color: AppColors.white, fontSize: 20),
          ),
        ),
        SizedBox(
          width: blockWidth * 4,
          child: TextField(
            style: TextStyle(color: AppColors.white),
            controller: widget.controller,
            obscureText: widget.isPassword,
            decoration: InputDecoration(
              hintText: widget.placeholder,
              hintStyle: TextStyle(color: AppColors.white.withOpacity(0.5)),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.white.withOpacity(0.5)),
              ),
              errorText: isEmailValid ? null : 'Invalid email address',
              errorStyle: const TextStyle(
                color: Colors.red,
                decoration: TextDecoration.underline,
              ),
            ),
            onChanged: (value) {
              print(value);
              if (value.isEmpty) {
                setState(() {
                  isEmailValid = true;
                });
              } else if (widget.isEmail) {
                setState(() {
                  isEmailValid = isValidEmail(value);
                });
              }
            },
          ),
        ),
      ],
    );
  }
}
