// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

// PAS UTILISE


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
            if (kDebugMode) {
              print(request.url);
            }
            if (request.url.startsWith("area://oauth2redirect")) {
              final uri = Uri.parse(request.url);
              final code = uri.queryParameters['code'];
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
                request.url.contains('recaptcha') || request.url.contains('challenge-completed') || request.url.contains('epitech') || request.url.contains('login')) {
              return NavigationDecision.navigate;
            }
            return NavigationDecision.prevent;
          },
        ),
      ),
    );
  }
}
