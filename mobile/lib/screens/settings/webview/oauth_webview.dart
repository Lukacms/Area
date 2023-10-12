import 'package:flutter/material.dart';
import 'package:mobile/back/api.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SpotifyAuthWebView extends StatelessWidget {
  final String authUrl;
  final String clientId;
  final String clientSecret;
  final Function serverOauth;
  final String url;

  const SpotifyAuthWebView({
    super.key,
    required this.authUrl,
    required this.clientId,
    required this.clientSecret,
    required this.serverOauth,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: WebView(
          initialUrl: authUrl,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {},
          navigationDelegate: (NavigationRequest request) async {
            if (request.url.startsWith("area://oauth2redirect")) {
              //final clientId = 'bdc8f3d5d4f14860927496bebf18936b';
              //final clientSecret = '9b762428f3a84fc682e5f62cc5ae8152';
              final credentials = base64.encode(
                utf8.encode('$clientId:$clientSecret'),
              );
              final uri = Uri.parse(request.url);
              final code = uri.queryParameters['code'];
              //final state = uri.queryParameters['state'];
              if (code == null) {
                Navigator.pop(context, null);
                return NavigationDecision.prevent;
              }
              //final response = await serverOauth(code);
              final response = await http.post(
                Uri.parse(url /* 'https://accounts.spotify.com/api/token' */),
                headers: {
                  'Content-Type': 'application/x-www-form-urlencoded',
                  'Authorization': 'Basic $credentials',
                },
                body: {
                  'grant_type': 'authorization_code',
                  'code': code,
                  'redirect_uri': 'area://oauth2redirect',
                },
              );
              print(response);
              final accessToken = jsonDecode(response.body)['access_token'];
              final refreshToken = jsonDecode(response.body)['refresh_token'];
              final expiresIn = jsonDecode(response.body)['expires_in'];
              print(accessToken);
              print(refreshToken);
              print(expiresIn);
              Navigator.pop(context,
                  {'access_token': accessToken, 'refresh_token': refreshToken});
              return NavigationDecision.prevent;
            } else if (request.url
                .startsWith('https://accounts.spotify.com/authorize')) {
              return NavigationDecision.navigate;
            }
            return NavigationDecision.prevent;
          },
        ),
      ),
    );
  }
}
