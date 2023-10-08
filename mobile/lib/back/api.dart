// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile/back/services.dart';

String CURRENT_IP = '192.168.122.1';
// ONLINE

/// Sends a login request to the server with the specified email and password.
///
/// Returns a list containing a boolean value indicating whether the login was successful,
/// and an access token string if the login was successful, or an empty string if the login failed.
///
/// Throws an exception if there was an error sending the login request.
Future<List> serverLogin(String mail, String password) async {
  var url = Uri(
      scheme: 'http', host: CURRENT_IP, port: 8080, path: '/api/Users/login');
  var headers = {
    'Content-Type': 'application/json',
    'accept': '*/*',
  };
  var body = jsonEncode({'email': mail, 'password': password});
  var response = await http.post(url, headers: headers, body: body);
  print("Login status code: ${response.statusCode}");
  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    var accessToken = jsonResponse['access_token'];
    print("User access token $accessToken");
    return [true, accessToken];
  }
  return [false, ''];
}

/// Sends a registration request to the server with the specified email, password, name, surname, and username.
///
/// Returns a boolean value indicating whether the registration was successful.
///
/// Throws an exception if there was an error sending the registration request.
Future<bool> serverRegister(
  String mail,
  String password,
  String name,
  String surname,
  String username,
) async {
  var url = Uri(
      scheme: 'http',
      host: CURRENT_IP,
      port: 8080,
      path: '/api/Users/register');
  var headers = {
    'Content-Type': 'application/json',
    'accept': '*/*',
  };
  var body = jsonEncode({
    'email': mail,
    'password': password,
    'username': username,
    'name': name,
    'surname': surname,
  });
  var response = await http.post(url, headers: headers, body: body);
  if (response.statusCode == 201) {
    return true;
  }
  return false;
}

Future serverGetSelfInfos(String token) async {
  var url =
      Uri(scheme: 'http', host: CURRENT_IP, port: 8080, path: '/api/Users/me');
  var headers = {
    'accept': '*/*',
    'Authorization': 'Bearer $token',
  };
  var response = await http.get(url, headers: headers);
  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    return jsonResponse;
  }
}

Future serverGoogleAuth(String token, String scope) async {
  var url =
      Uri(scheme: 'http', host: CURRENT_IP, port: 8080, path: '/oauth/Google');
  var headers = {
    'Content-Type': 'application/json',
    'accept': '*/*',
  };
  var body = jsonEncode({'code': token, 'scope': scope});
  var response = await http
      .post(url, headers: headers, body: body)
      .then((value) => print(value.body));
  return response;
}

Future<List> serverGetAreas(int id, String token) async {
  print("hey");
  print(id);
  print(token);
  var url = Uri(
    scheme: 'http',
    host: CURRENT_IP,
    port: 8080,
    path: '/api/Areas/$id',
  );
  var headers = {
    'accept': '*/*',
    'Authorization': 'Bearer $token',
  };
  var response = await http.get(url, headers: headers);
  print("AAAAAA");
  print(response.body);
  print("Get areas status code ${response.statusCode}");
  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    return jsonResponse;
  }
  return [];
}

Future<bool> serverAddArea(
    String token, int userId, int id, String name) async {
  var url = Uri(
    scheme: 'http',
    host: CURRENT_IP,
    port: 8080,
    path: '/api/Areas',
  );
  var headers = {
    'Content-Type': 'application/json',
    'accept': '*/*',
    'Authorization': 'Bearer $token',
  };
  var body = jsonEncode({
    'id': id,
    'name': name,
    'userId': userId,
    'favorite': false,
  });
  var response = await http.post(url, headers: headers, body: body);
  print("Add area status code ${response.statusCode}");
  if (response.statusCode == 201 || response.statusCode == 200) {
    return true;
  }
  return false;
}

// OFFLINE

class Automatisation {
  int id;
  String user;
  int actionId;
  String reaction;

  Automatisation({
    required this.id,
    required this.user,
    required this.actionId,
    required this.reaction,
  });
}

List<Area> automatisations = [
  Area(
      userId: 1,
      action: null,
      reactions: [],
      name: "area 1 a afficher",
      favorite: true),
  Area(userId: 1, action: null, reactions: [], name: "area 2 a pas afficher"),
  Area(userId: 1, action: null, reactions: [], name: "area 3 a pas afficher"),
  Area(
      userId: 1,
      action: null,
      reactions: [],
      name: "area 4 a afficher",
      favorite: true),
];

List login(String user, String password) {
  String token = "abc123";
  if (user == "user" && password == "password") {
    return [true, token];
  }
  return [false, ""];
}

List<Area> getAreas() {
  return automatisations;
}

void addArea(Area area, int user) {
  area.userId = user;
  automatisations.add(area);
}

void editArea(Area area, Area savedArea) {
  for (var automatisation in automatisations) {
    if (automatisation == savedArea) {
      automatisation = area;
    }
  }
}

void sendResetPassword() {}
