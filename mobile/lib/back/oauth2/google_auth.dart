/* import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show jsonDecode;
 */
/* class GoogleAuth extends StatefulWidget {
  const GoogleAuth({super.key});

  @override
  State<GoogleAuth> createState() => _GoogleAuthState();
}

class _GoogleAuthState extends State<GoogleAuth> {
  Future login() async {
    const googleClientId =
        'client id';
    const callbackUrlScheme =
        'client secret';

    // Construct the url
    final url = Uri.https('accounts.google.com', '/o/oauth2/v2/auth', {
      'response_type': 'code',
      'client_id': googleClientId,
      'redirect_uri': '$callbackUrlScheme:/',
      'scope': 'email',
    });

    // Present the dialog to the user
    final result = await FlutterWebAuth.authenticate(
        url: url.toString(), callbackUrlScheme: callbackUrlScheme);

    // Extract code from resulting url
    final code = Uri.parse(result).queryParameters['code'];

    // Use this code to get an access token
    final response = await http
        .post(Uri.parse('https://www.googleapis.com/oauth2/v4/token'), body: {
      'client_id': googleClientId,
      'redirect_uri': '$callbackUrlScheme:/',
      'grant_type': 'authorization_code',
      'code': code,
    });

    // Get the access token from the response
    final accessToken = jsonDecode(response.body)['access_token'] as String;
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
 */