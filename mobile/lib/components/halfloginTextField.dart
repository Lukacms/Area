import 'package:flutter/material.dart';
import 'package:mobile/theme/style.dart';
import 'package:mobile/main.dart';

class HalfLoginTextField extends StatefulWidget {
  final String description;
  final String placeholder;
  final bool isPassword;
  final TextEditingController controller;
  const HalfLoginTextField({
    super.key,
    required this.description,
    required this.placeholder,
    required this.isPassword,
    required this.controller,
  });

  @override
  State<HalfLoginTextField> createState() => _HalfLoginTextFieldState();
}

class _HalfLoginTextFieldState extends State<HalfLoginTextField> {
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
          width: blockWidth * 1.8,
          child: Text(
            widget.description,
            style: TextStyle(color: AppColors.white, fontSize: 20),
          ),
        ),
        SizedBox(
          width: blockWidth * 1.8,
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
            ),
          ),
        ),
      ],
    );
  }
}
