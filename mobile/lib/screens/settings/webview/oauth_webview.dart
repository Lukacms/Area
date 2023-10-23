import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';

class AuthWebView extends StatelessWidget {
  final String authUrl;
  final String clientId;
  final String clientSecret;
  final Function serverOauth;

  const AuthWebView({
    super.key,
    required this.authUrl,
    required this.clientId,
    required this.clientSecret,
    required this.serverOauth,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: WebView(
          debuggingEnabled: true,
          initialUrl: authUrl,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {},
          navigationDelegate: (NavigationRequest request) async {
            print("LE request");
            print(request.url);
            if (request.url.startsWith("area://oauth2redirect")) {
              final credentials = base64.encode(
                utf8.encode('$clientId:$clientSecret'),
              );
              final uri = Uri.parse(request.url);
              final code = uri.queryParameters['code'];
              print("LE code");
              print(code);
              await serverOauth(code);
              if (code == null) {
                Navigator.pop(context, null);
                return NavigationDecision.prevent;
              }
              Navigator.pop(
                context,
              );
              return NavigationDecision.prevent;
            } else if (request.url.contains('authorize') ||
                request.url.contains('recaptcha') || request.url.contains('challenge-completed')) {
              return NavigationDecision.navigate;
            }
            return NavigationDecision.prevent;
          },
        ),
      ),
    );
  }
}
