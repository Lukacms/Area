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
