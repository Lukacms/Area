import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveToken(String token) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("userToken", token);
}

Future<dynamic> retrieveToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  if (prefs.containsKey("userToken")) {
    return prefs.get("userToken");
  } else {
    throw Exception("Key not found");
  }
}

Future<void> saveUser(Map<String, dynamic> user) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("user", jsonEncode(user));
}

Future<dynamic> retrieveUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  if (prefs.containsKey("user")) {
    return jsonDecode(prefs.get("user") as String);
  } else {
    throw Exception("Key not found");
  }
}