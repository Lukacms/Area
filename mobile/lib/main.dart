import 'package:flutter/material.dart';
import 'package:mobile/screens/login.dart';
import 'package:mobile/theme/style.dart';

void main() {
  runApp(const MyApp());
}

late Size screenSize;
late double screenHeight, screenWidth, blockWidth, blockHeight;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    screenHeight = screenSize.height;
    screenWidth = screenSize.width;
    blockWidth = screenWidth / 5;
    blockHeight = screenHeight / 100;
    return MaterialApp(
      title: 'FastR',
      theme: appTheme(),
      home: const LoginScreen(),
    );
  }
}
