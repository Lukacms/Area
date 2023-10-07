import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:mobile/back/services.dart';


class OauthWebView extends StatelessWidget {
  final String url;
  final int index;

  OauthWebView({Key? key, required this.url, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppServices().services[index].name),
      ),
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
