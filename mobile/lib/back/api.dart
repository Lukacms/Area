// ignore_for_file: avoid_print, non_constant_identifier_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/back/services.dart';

String CURRENT_IP = '';
int CURRENT_PORT = -1;

void setCurrentIp(String ip) {
  CURRENT_IP = ip;
}

void setCurrentPort(int port) {
  CURRENT_PORT = port;
}

//
// USERS
//

/// Sends a login request to the server with the specified email and password.
///
/// Returns a list containing a boolean value indicating whether the login was successful,
/// and an access token string if the login was successful, or an empty string if the login failed.
///
/// Throws an exception if there was an error sending the login request.
Future<List> serverLogin(String mail, String password) async {
  var url = Uri(
      scheme: 'http',
      host: CURRENT_IP,
      port: CURRENT_PORT,
      path: '/api/Users/login');
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
      port: CURRENT_PORT,
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

Future serverVerifyEmail(String mail) async {
  var url = Uri(
      scheme: 'http',
      host: CURRENT_IP,
      port: CURRENT_PORT,
      path: '/api/Users/verifyMail');
  var headers = {
    'Content-Type': 'application/json',
    'accept': '*/*',
  };
  var body = jsonEncode({
    'email': mail,
  });
  var response = await http.post(url, headers: headers, body: body);
  print("Verify email status code: ${response.statusCode}");
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
  var url = Uri(
      scheme: 'http',
      host: CURRENT_IP,
      port: CURRENT_PORT,
      path: '/api/Users/me');
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

/// Sends a PUT request to the server to edit user information.
///
/// The [token] parameter is the authentication token for the user.
/// The [selfInfos] parameter is a map containing the user information to be updated.
///
/// This function constructs a URL using the current IP, port, and path.
/// It sets the request headers to accept any response, use JSON content, and include the authorization token.
/// It then encodes the [selfInfos] map to a JSON string for the request body.
///
/// The function sends the PUT request and waits for a response.
/// It prints the status code of the response.
///
/// If the status code is 200 (indicating success), it decodes the response body from JSON to a map and returns it.
/// If the status code is not 200, the function does not return a value.
///
/// This function is asynchronous and returns a `Future`.
Future serverEditSelfInfos(String token, Map selfInfos) async {
  var url = Uri(
    scheme: 'http',
    host: CURRENT_IP,
    port: CURRENT_PORT,
    path: '/api/Users/partialModif',
  );
  var headers = {
    'accept': '*/*',
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };
  var body = jsonEncode(selfInfos);
  var response = await http.put(url, body: body, headers: headers);
  print("Edit self infos status code ${response.statusCode}");
  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    return jsonResponse;
  }
}

//
// SERVICES
//

/// Sends a POST request to the server for Google authentication.
///
/// The [token] parameter is the authentication token for the user.
/// The [code] parameter is the authorization code received from Google.
/// The [redirectUrl] parameter is the URL where the user should be redirected after authentication.
///
/// This function constructs a URL using the current IP, port, and path.
/// The path depends on whether [redirectUrl] is empty.
///
/// It sets the request headers to accept any response, use JSON content, and include the authorization token if [redirectUrl] is empty.
///
/// It then encodes a map containing the [code] and possibly the [redirectUrl] to a JSON string for the request body.
///
/// The function sends the POST request and waits for a response.
/// It prints the status code and body of the response.
///
/// If [redirectUrl] is empty, it returns the response body as a string.
/// Otherwise, it decodes the response body from JSON to a map and returns the 'access_token' field.
///
/// This function is asynchronous and returns a `Future`.
Future serverGoogleAuth(
  String token,
  String code,
  String redirectUrl,
) async {
  var url = Uri(
    scheme: 'http',
    host: CURRENT_IP,
    port: CURRENT_PORT,
    path: redirectUrl.isEmpty
        ? '/oauth/Google/mobile'
        : '/api/Users/googleLoginMobile',
  );
  var headers = redirectUrl.isEmpty
      ? {
          'Content-Type': 'application/json',
          'accept': '*/*',
          'Authorization': 'Bearer $token',
        }
      : {
          'Content-Type': 'application/json',
          'accept': '*/*',
        };
  print('le code cote serveur $code');
  print('le redirectUrl cote serveur $redirectUrl');
  var body = jsonEncode(redirectUrl.isEmpty
      ? {'code': code}
      : {'code': code, 'callbackUri': redirectUrl});

  var res = await http.post(url, headers: headers, body: body);
  print('reponse serveur${res.statusCode}');
  print(res.body);
  return redirectUrl.isEmpty ? res.body : jsonDecode(res.body)['access_token'];
}

/// Sends a POST request to the server for service authentication.
///
/// The [code] parameter is the authorization code received from the service.
/// The [token] parameter is the authentication token for the user.
/// The [service] parameter is the name of the service for which authentication is being performed.
///
/// This function constructs a URL using the current IP, port, and path.
/// The path includes the [service] name.
///
/// It sets the request headers to accept any response, use JSON content, and include the authorization token.
///
/// It then encodes a map containing the [code] to a JSON string for the request body.
///
/// The function sends the POST request and waits for a response.
/// It prints the status code and body of the response.
///
/// If the request is successful, it returns the response body as a string.
/// Otherwise, it returns null.
///
/// This function is asynchronous and returns a `Future`.
Future serverServiceAuth(String code, String token, String service) async {
  var url = Uri(
      scheme: 'http',
      host: CURRENT_IP,
      port: CURRENT_PORT,
      path: '/oauth/$service/mobile');
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

//
// AREAS, ACTIONS AND REACTIONS
//

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
    port: CURRENT_PORT,
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
    port: CURRENT_PORT,
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

/// Sends a POST request to the server to add a new area with the given parameters.
/// Returns a boolean indicating whether the request was successful or not.
///
/// The [token] parameter is the authentication token for the user.
/// The [userId] parameter is the ID of the user adding the area.
/// The [id] parameter is the ID of the area being added.
/// The [name] parameter is the name of the area being added.
/// The [action] parameter is an instance of the [AreaAction] class representing the user's action in the area.
/// The [reactions] parameter is a list of instances of the [AreaAction] class representing the user's reactions in the area.
/// The [favorite] parameter is a boolean indicating whether the area is a favorite or not.
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
      'areaId': id,
      'configuration': reaction.configuration.isEmpty
          ? "{}"
          : jsonEncode(reaction.configuration),
    });
    i++;
  }
  var url = Uri(
    scheme: 'http',
    host: CURRENT_IP,
    port: CURRENT_PORT,
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
  var response = await http.post(url, headers: headers, body: body);
  print("Add area status code ${response.statusCode}");
  if (response.statusCode == 201 || response.statusCode == 200) {
    return true;
  }
  return false;
}

/// Sends a delete request to the server to delete an area with the given [areaId].
/// Returns a [Future] that completes with a [bool] value indicating whether the request was successful or not.
/// The [token] parameter is used for authentication and authorization purposes.
/// Throws an error if the request fails.
Future<bool> serverDeleteArea(String token, int areaId) async {
  final uri = Uri(
    scheme: 'http',
    host: CURRENT_IP,
    port: CURRENT_PORT,
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

/// Fetches actions from the server using the provided [token].
/// Returns a Future that completes with the decoded JSON response if the request is successful.
/// Otherwise, returns null.
Future serverGetActions(String token) async {
  var url = Uri(
    scheme: 'http',
    host: CURRENT_IP,
    port: CURRENT_PORT,
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

/// Fetches reactions from the server using the provided token.
/// Returns a Future that completes with the JSON response from the server.
/// If the response status code is not 200, returns null.
///
/// Example usage:
/// ```dart
/// var reactions = await serverGetReactions('myToken123');
/// if (reactions != null) {
///   // do something with the reactions
/// } else {
///   // handle error
/// }
/// ```
Future serverGetReactions(String token) async {
  var url = Uri(
    scheme: 'http',
    host: CURRENT_IP,
    port: CURRENT_PORT,
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

//
// SERVICES
//

/// Fetches services from the server using the provided [token].
/// Returns a Future that completes with the decoded JSON response if the request is successful.
/// Otherwise, returns null.
Future serverGetServices(String token) async {
  var url = Uri(
    scheme: 'http',
    host: CURRENT_IP,
    port: CURRENT_PORT,
    path: '/api/Services',
  );
  var headers = {
    'accept': '*/*',
    'Authorization': 'Bearer $token',
  };
  var response = await http.get(url, headers: headers);
  print("Get services status code ${response.statusCode}");
  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    return jsonResponse;
  }
}

/// Fetches the services of a user from the server using the provided token and user ID.
/// Returns the JSON response if the status code is 200, otherwise returns null.
Future serverGetUserServices(String token, int userId) async {
  var url = Uri(
    scheme: 'http',
    host: CURRENT_IP,
    port: CURRENT_PORT,
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
