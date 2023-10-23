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
  final Map<String, dynamic> defaultConfiguration;
  final Map<String, dynamic> configuration;
  int timer;

  AreaAction({
    required this.serviceId,
    required this.id,
    required this.name,
    required this.endpoint,
    required this.defaultConfiguration,
    required this.configuration,
    required this.timer,
  });
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AreaAction &&
        other.id == id &&
        other.name == name &&
        other.endpoint == endpoint &&
        other.defaultConfiguration == defaultConfiguration &&
        other.serviceId == serviceId;
  }
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

  List<int> userServicesParse(List userServices) {
    List<int> tmp = [];
    print(userServices);
    for (var service in userServices) {
      tmp.add(service['serviceId']);
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
        defaultConfiguration: action['defaultConfiguration'] != null &&
                action['defaultConfiguration'].isNotEmpty
            ? jsonDecode(action['defaultConfiguration'])
            : {},
        configuration: action['configuration'] != null &&
                action['configuration'].isNotEmpty
            ? jsonDecode(action['configuration'])
            : {},
        timer: action['timer'] ?? 0,
      );
      tmp.add(actionTmp);
    }
    return tmp;
  }

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
