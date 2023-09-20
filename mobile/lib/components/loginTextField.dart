import 'package:flutter/material.dart';
import 'package:mobile/theme/style.dart';
import 'package:mobile/main.dart';

class LoginTextField extends StatefulWidget {
  final String description;
  final String placeholder;
  final bool isPassword;
  final TextEditingController controller;
  const LoginTextField({
    super.key,
    required this.description,
    required this.placeholder,
    required this.isPassword,
    required this.controller,
  });

  @override
  State<LoginTextField> createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<LoginTextField> {
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
            decoration: InputDecoration(
              labelText: widget.placeholder,
              labelStyle: TextStyle(color: AppColors.white.withOpacity(0.5)),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.white.withOpacity(0.5)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
