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

/// Sends a login request to the server with the specified email and password.
///
/// Returns a list containing a boolean value indicating whether the login was successful,
/// and an access token string if the login was successful, or an empty string if the login failed.
///
///Throws an exception if there was an error sending the login request.
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

Future serverGoogleAuth(
    String token, String code,) async {
  var url =
      Uri(scheme: 'http', host: CURRENT_IP, port: 8080, path: '/oauth/Google/mobile');
  var headers = {
    'Content-Type': 'application/json',
    'accept': '*/*',
    'Authorization': 'Bearer $token',
  };
  var body =
      jsonEncode({'code': code});
  var response =
      await http.post(url, headers: headers, body: body).then((value) {
    print('reponse serveur${value.statusCode}');
    print(value.body);
    return value.body;
  });
  return null;
}

Future serverSpotifyAuth(String code, String token) async {
  print("Spotify server oauth");
  var url =
      Uri(scheme: 'http', host: CURRENT_IP, port: 8080, path: '/oauth/Spotify');
  var headers = {
    'Content-Type': 'application/json',
    'accept': '*/*',
    'Authorization': 'Bearer $token',
  };
  var body = jsonEncode({"code": code});
  await http.post(url, headers: headers, body: body).then((value) {
    print('reponse serveur${value.statusCode}');
    print(value.body);
    return value.body;
  });
  return null;
}

Future serverGithubAuth(String code, String token) async {
  var url =
      Uri(scheme: 'http', host: CURRENT_IP, port: 8080, path: '/oauth/Github');
  print("CHUI DEDANS");
  print('le code cote serveur $code');
  var headers = {
    'Content-Type': 'application/json',
    'accept': '*/*',
    'Authorization': 'Bearer $token',
  };
  var body = jsonEncode({"code": code, 'scope': null});
  var response =
      await http.post(url, headers: headers, body: body).then((value) {
    print('reponse serveur${value.statusCode}');
    print(value.body);
    return value.body;
  });
  return null;
}

/// Sends a GET request to the server to retrieve information about the area with the specified `id`.
///
/// Returns a JSON-encoded object containing information about the area with the specified `id`,
/// or an empty list if there was an error.
///
/// Throws an exception if there was an error sending the request.
Future<List> serverGetAreas(int id, String token) async {
  var url = Uri(
    scheme: 'http',
    host: CURRENT_IP,
    port: 8080,
    path: '/api/Areas/$id/full',
  );
  var headers = {
    'accept': '*/*',
    'Authorization': 'Bearer $token',
  };
  var response = await http.get(url, headers: headers);
  print("Get areas status code ${response.statusCode}");
  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse);
    return jsonResponse;
  }
  return [];
}

/// Sends a GET request to the server to retrieve information about the area with the specified `id`.
///
/// Returns a JSON-encoded object containing information about the area with the specified `id`,
/// or an empty list if there was an error.
///
/// Throws an exception if there was an error sending the request.
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

Future<bool> serverAddFullArea(String token, int userId, int id, String name,
    AreaAction action, List<AreaAction> reactions, bool favorite) async {
  List<Map<String, dynamic>> bodyReactions = [];
  Map<String, dynamic> bodyAction = {
    'id': 0,
    'actionId': action.id,
    'areaId': id,
    'serviceId': action.serviceId,
    'configuration':
        action.configuration.isEmpty ? "{}" : jsonEncode(action.configuration),
    'timer': action.timer,
    'countdown': 1,
  };
  var i = 0;
  for (var reaction in reactions) {
    bodyReactions.add({
      'id': i,
      'reactionId': reaction.id,
      'serviceId': reaction.serviceId,
      'areaId': id,
      'configuration':
          reaction.configuration.isEmpty ? "{}" : reaction.configuration,
    });
    i++;
  }
  var url = Uri(
    scheme: 'http',
    host: CURRENT_IP,
    port: 8080,
    path: '/api/Areas/full',
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
    'favorite': favorite,
    'userAction': bodyAction,
    'userReactions': bodyReactions,
  });
  print(name);
  var response = await http.post(url, headers: headers, body: body);
  print("Add area status code ${response.statusCode}");
  if (response.statusCode == 201 || response.statusCode == 200) {
    return true;
  }
  return false;
}

Future<bool> serverEditArea(
    String token, int userId, int id, String name) async {
  return false;
}

Future<bool> serverDeleteArea(String token, int areaId) async {
  final uri = Uri(
    scheme: 'http',
    host: CURRENT_IP,
    port: 8080,
    path: '/api/Areas/$areaId',
  );
  final response = await http.delete(
    uri,
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    print('Delete request successful');
    return true;
  } else {
    print('Delete request failed with status: ${response.statusCode}');
    return false;
  }
}

Future serverGetActions(String token) async {
  var url = Uri(
    scheme: 'http',
    host: CURRENT_IP,
    port: 8080,
    path: '/api/Actions',
  );
  var headers = {
    'accept': '*/*',
    'Authorization': 'Bearer $token',
  };
  var response = await http.get(url, headers: headers);
  print("Get actions status code ${response.statusCode}");
  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    return jsonResponse;
  }
}

Future serverGetReactions(String token) async {
  var url = Uri(
    scheme: 'http',
    host: CURRENT_IP,
    port: 8080,
    path: '/api/Reactions',
  );
  var headers = {
    'accept': '*/*',
    'Authorization': 'Bearer $token',
  };
  var response = await http.get(url, headers: headers);
  print("Get reactions status code ${response.statusCode}");
  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    return jsonResponse;
  }
}

Future serverGetServices(String token) async {
  var url = Uri(
    scheme: 'http',
    host: CURRENT_IP,
    port: 8080,
    path: '/api/Services',
  );
  var headers = {
    'accept': '*/*',
    'Authorization': 'Bearer $token',
  };
  var response = await http.get(url, headers: headers);
  print("Get services status code ${response.statusCode}");
  if (response.statusCode == 200) {
    print('prout');
    var jsonResponse = jsonDecode(response.body);
    return jsonResponse;
  }
}

Future serverGetUserServices(String token, int userId) async {
  var url = Uri(
    scheme: 'http',
    host: CURRENT_IP,
    port: 8080,
    path: '/api/UserServices/$userId',
  );
  var headers = {
    'accept': '*/*',
    'Authorization': 'Bearer $token',
  };
  var response = await http.get(url, headers: headers);
  print("Get user services status code ${response.statusCode}");
  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    return jsonResponse;
  }
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
    favorite: true,
    areaId: 0,
  ),
  Area(
    userId: 1,
    action: null,
    reactions: [],
    name: "area 2 a pas afficher",
    areaId: 1,
  ),
  Area(
    userId: 1,
    action: null,
    reactions: [],
    name: "area 3 a pas afficher",
    areaId: 2,
  ),
  Area(
    userId: 1,
    action: null,
    reactions: [],
    name: "area 4 a afficher",
    favorite: true,
    areaId: 3,
  ),
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
