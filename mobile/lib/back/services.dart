import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:mobile/back/api.dart';
import 'package:mobile/screens/settings/webview/oauth_webview.dart';
import 'package:mobile/theme/style.dart';
import 'package:http/http.dart' as http;

class Service {
  final int id;
  final String name;
  final String connectionLink;
  final String endpoint;
  String svgIcon;
  Color iconColor;
  String category;

  Service({
    required this.name,
    required this.id,
    required this.connectionLink,
    required this.endpoint,
    this.svgIcon = '',
    this.iconColor = Colors.white,
    this.category = '',
  });
}

class AreaAction {
  final int serviceId;
  final int id;
  final String name;
  final String endpoint;
  final dynamic defaultConfiguration;

  AreaAction({
    required this.serviceId,
    required this.id,
    required this.name,
    required this.endpoint,
    required this.defaultConfiguration,
  });
}

class Area {
  int userId;
  int areaId;
  AreaAction? action;
  List<AreaAction> reactions;
  String name;
  bool favorite;

  Area({
    required this.userId,
    required this.areaId,
    required this.action,
    required this.reactions,
    required this.name,
    this.favorite = false,
  });
}

/* class Connectors {
  final String name;
  final IconData icon;
  final String category;

  Connectors({
    required this.name,
    this.icon = Icons.fiber_manual_record_outlined,
    this.category = 'connecteurs',
  });
}
 */

enum ServiceCategories {
  reseaux,
  messageries,
  connecteurs,
  lieu,
  medias,
}

class AppServices {
  List<Service> serviceParse(List services) {
    List<Service> tmp = [];
    for (var service in services) {
      Service serviceTmp;
      serviceTmp = Service(
          name: service['name'],
          id: service['id'],
          endpoint: service['endpoint'],
          connectionLink: service['connectionLink']);
      switch (service['name']) {
        case 'Google':
          serviceTmp.svgIcon = 'assets/serviceIcons/google.svg';
          serviceTmp.iconColor = Colors.white;
          serviceTmp.category = 'reseaux';
          break;
        case 'Spotify':
          serviceTmp.svgIcon = 'assets/serviceIcons/spotify.svg';
          serviceTmp.iconColor = Colors.green;
          serviceTmp.category = 'medias';
          break;
        case 'Github':
          serviceTmp.svgIcon = 'assets/serviceIcons/github.svg';
          serviceTmp.iconColor = Colors.grey;
          serviceTmp.category = 'Dev';
          break;
        case 'Discord':
          serviceTmp.svgIcon = 'assets/serviceIcons/discord.svg';
          serviceTmp.iconColor = Colors.purple;
          serviceTmp.category = 'messageries';
          break;
      }
      tmp.add(serviceTmp);
    }
    return tmp;
  }

  List<AreaAction> actionParse(List actions) {
    List<AreaAction> tmp = [];
    for (var action in actions) {
      AreaAction actionTmp;
      actionTmp = AreaAction(
        serviceId: action['serviceId'],
        id: action['id'],
        name: action['name'],
        endpoint: action['endpoint'],
        defaultConfiguration: action['defaultConfiguration'],
      );
      tmp.add(actionTmp);
    }
    return tmp;
  }

  /*List services = [
    Service(
      name: "Github",
      svgIcon: 'assets/serviceIcons/github.svg',
      iconColor: Colors.grey,
      category: 'Dev',
      actions: ['Commit', 'Push', 'Pull'],
      oAuth: "null",
    ),
    Service(
      name: "Discord",
      svgIcon: 'assets/serviceIcons/discord.svg',
      iconColor: Colors.purple,
      category: 'messageries',
      actions: ['Message', 'Call', 'Video'],
      oAuth:
          "https://discord.com/api/oauth2/authorize?client_id=1158738215704985681&permissions=8&redirect_uri=http%3A%2F%2Flocalhost%3A8081%2Fsettings%2Fservices&response_type=code&scope=bot",
    ),
    Service(
      name: "Google",
      svgIcon: 'assets/serviceIcons/google.svg',
      iconColor: Colors.white,
      category: 'reseaux',
      actions: ['Message', 'Call', 'Video'],
      oAuth:
          "https://accounts.google.com/o/oauth2/auth?scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fgmail.modify+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fcalendar&response_type=code&redirect_uri=http%3A%2F%2Flocalhost:8090%2Fsettings%2Fservices%2Fgoogle&client_id=315267877885-lkqq49r6v587fi9pduggbdh9dr1j69me.apps.googleusercontent.com",
    ),
    Service(
      name: "Instagram",
      svgIcon: 'assets/serviceIcons/instagram.svg',
      iconColor: Colors.pink,
      category: 'reseaux',
      actions: ['Message', 'Call', 'Video'],
      oAuth: "null",
    ),
    Service(
      name: "Spotify",
      svgIcon: 'assets/serviceIcons/linkedin.svg',
      iconColor: Colors.blue,
      category: "reseaux",
      actions: ['Message', 'Call', 'Video'],
      oAuth: "null",
    ),
    Service(
      name: "Conditions",
      svgIcon: 'assets/serviceIcons/connectors.svg',
      iconColor: AppColors.lightBlue,
      category: 'connecteurs',
      actions: ['If', 'Or', 'And', 'Not', 'Else'],
      oAuth: "null",
    )
  ]; */
  List categories = [
    [
      "Reseaux",
      Icon(
        Icons.group,
        color: AppColors.lightBlue,
      )
    ],
    [
      "Messageries",
      Icon(
        Icons.chat,
        color: AppColors.lightBlue,
      )
    ],
    [
      "Connecteurs",
      Icon(
        Icons.account_tree,
        color: AppColors.lightBlue,
      )
    ],
    [
      "Lieu",
      Icon(
        Icons.near_me,
        color: AppColors.lightBlue,
      )
    ],
    [
      "Medias",
      Icon(
        Icons.music_note,
        color: AppColors.lightBlue,
      )
    ],
  ];
  Map<String, dynamic> serviceLogInFunctions = {
    'Google': (BuildContext context, String token) async {
      const googleClientId =
          '315267877885-lkqq49r6v587fi9pduggbdh9dr1j69me.apps.googleusercontent.com';
      const callbackUrlScheme =
          'com.googleusercontent.apps.315267877885-lkqq49r6v587fi9pduggbdh9dr1j69me';

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
      final refreshToken = jsonDecode(response.body)['refresh_token'] as String;
      serverGoogleAuth(token, accessToken, refreshToken);
    },
    'Spotify': (BuildContext context, String token) async {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return AuthWebView(
              clientId: '834ee184a29945b2a2a3dc8108a5bbf4',
              clientSecret: 'b589f784bb3f4b3897337acbfdd80f0d',
              serverOauth: (code) {
                serverSpotifyAuth(code, token);
              },
              authUrl:
                  'https://accounts.spotify.com/authorize?client_id=834ee184a29945b2a2a3dc8108a5bbf4&response_type=code&redirect_uri=area://oauth2redirect&scope=user-read-private%20user-read-email',
            );
          },
        ),
      );
    },
    'Github': (BuildContext context, String token) async {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return AuthWebView(
              clientId: 'Iv1.f47bfd491f94b532',
              clientSecret: 'c8f7c650f3d4c47462ddbf0ca06b1113478c9f6e',
              serverOauth: (code) {
                serverGithubAuth(code, token);
              },
              authUrl:
                  ' https://github.com/login/oauth/authorize?client_id=Iv1.f47bfd491f94b532&redirect_uri=area://oauth2redirect',
            );
          },
        ),
      );
    }
  };
}
