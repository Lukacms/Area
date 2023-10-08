import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile/back/services.dart';

// ONLINE

Future<List> serverLogin(String mail, String password) async {
  var url = Uri(
      scheme: 'http',
      host: '192.168.122.1',
      port: 8090,
      path: '/api/Users/login');
  var headers = {
    'Content-Type': 'application/json',
    'accept': '*/*',
  };
  var body = jsonEncode({'email': mail, 'password': password});
  var response = await http.post(url, headers: headers, body: body);
  print("Login status code: " + response.statusCode.toString());
  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    var accessToken = jsonResponse['access_token'];
    return [true, accessToken];
  }
  return [false, ''];
}

Future<bool> serverRegister(
  String mail,
  String password,
  String name,
  String surname,
  String username,
) async {
  var url = Uri(
      scheme: 'http',
      host: '192.168.122.1',
      port: 8090,
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

Future serverGoogleAuth(String token, String scope) async {
  var url = Uri(
      scheme: 'http', host: '192.168.122.1', port: 8090, path: 'oauth/Google');
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

Future serverGetSelfInfos(String token) async {
  var url = Uri(
      scheme: 'http', host: '192.168.122.1', port: 8090, path: '/api/Users/me');
  var headers = {
    'Content-Type': 'application/json',
    'accept': '*/*',
  };
  var response = await http.get(url, headers: headers);
  print(response.body);
  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse);
    var user = jsonResponse['user'];
    return user;
  }
}

Future<List> serverGetAreas(dynamic id) async {
  var url = Uri(
      scheme: 'http',
      host: '192.168.122.1',
      port: 8090,
      path: '/api/Automatisations');
  var headers = {
    'Content-Type': 'application/json',
    'accept': '*/*',
  };
  var response = await http.get(url, headers: headers);
  print(response.body);
  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    var areas = jsonResponse['automatisations'];
    return areas;
  }
  return [];
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
  Area(user: "user", actions: [], name: "area 1 a afficher", favorite: true),
  Area(user: "user", actions: [], name: "area 2 a pas afficher"),
  Area(user: "user", actions: [], name: "area 3 a pas afficher"),
  Area(user: "user", actions: [], name: "area 4 a afficher", favorite: true),
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

void addArea(Area area, String user) {
  area.user = user;
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
