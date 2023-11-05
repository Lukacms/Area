import 'package:flutter/material.dart';
import 'package:mobile/back/local_storage.dart';
import 'package:mobile/ip_selector.dart';
import 'package:mobile/screens/home/home_page.dart';
import 'package:mobile/screens/login/login.dart';
import 'package:mobile/theme/style.dart';

//this is where the fun begins

void main() {
  runApp(const MyApp());
}

late Size screenSize;
late double screenHeight, screenWidth, blockWidth, blockHeight;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String userToken = "";
  Map<String, dynamic> user = {};
  @override
  void initState() {
    super.initState();
    retrieveToken().then((value) {
      setState(() {
        userToken = value;
        //userToken = "";
      });
    });
    retrieveUser().then((value) {
      setState(() {
        user = value;
      });
    });
  }

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
      routes: {
        '/': (context) => userToken.isEmpty
            ? const IPSelector(
                type: 0,
                userToken: "",
                user: {},
              ) /* const LoginScreen() */
            : IPSelector(
                type: 1,
                userToken: userToken,
                user: user,
              ) /* HomePage(token: userToken, user: user), */,
        '/login': (context) => const LoginScreen(),
        '/home': (context) => HomePage(token: userToken, user: user),
      },
    );
  }
}
