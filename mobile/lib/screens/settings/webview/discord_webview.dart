import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DiscordWebView extends StatelessWidget {
  final String url;

  DiscordWebView({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Discord'),
      ),
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
