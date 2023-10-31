import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:mobile/back/api.dart';
import 'package:mobile/screens/settings/webview/oauth_webview.dart';
import 'package:mobile/theme/style.dart';

class Service {
  final int id;
  final String name;
  final String connectionLink;
  final String endpoint;
  String svgIcon;
  Color iconColor;
  String category;
  final bool isOauth;

  Service({
    required this.name,
    required this.id,
    required this.connectionLink,
    required this.endpoint,
    required this.isOauth,
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
        isOauth: service['isConnectionNeeded'],
        name: service['name'],
        id: service['id'],
        endpoint: service['endpoint'],
        connectionLink: service['connectionLinkMobile'],
      );
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
        case 'Microsoft':
          serviceTmp.svgIcon = 'assets/serviceIcons/microsoft.svg';
          serviceTmp.iconColor = Colors.lightBlue;
          serviceTmp.category = 'messageries';
          break;
        case 'Weather':
          serviceTmp.svgIcon = 'assets/serviceIcons/weather.svg';
          serviceTmp.iconColor = Colors.grey;
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
  Map<String, Function> serviceLogInFunctions = {
    'Google': (BuildContext context, String token) async {
      const googleClientId =
          '315267877885-lkqq49r6v587fi9pduggbdh9dr1j69me.apps.googleusercontent.com';
      const callbackUrlScheme =
          'com.googleusercontent.apps.315267877885-lkqq49r6v587fi9pduggbdh9dr1j69me';
      final url = Uri.https('accounts.google.com', '/o/oauth2/v2/auth', {
        'response_type': 'code',
        'client_id': googleClientId,
        'redirect_uri': '$callbackUrlScheme:/',
        'scope':
            'email https://www.googleapis.com/auth/calendar https://www.googleapis.com/auth/gmail.modify',
      });
      final result = await FlutterWebAuth.authenticate(
          url: url.toString(), callbackUrlScheme: callbackUrlScheme);
      final code = Uri.parse(result).queryParameters['code'];
      serverGoogleAuth(token, code!, "");
    },
    'GoogleLogin': (BuildContext context) async {
      const googleClientId =
          '315267877885-lkqq49r6v587fi9pduggbdh9dr1j69me.apps.googleusercontent.com';
      const callbackUrlScheme =
          'com.googleusercontent.apps.315267877885-lkqq49r6v587fi9pduggbdh9dr1j69me';
      final url = Uri.https('accounts.google.com', '/o/oauth2/v2/auth', {
        'response_type': 'code',
        'client_id': googleClientId,
        'redirect_uri': '$callbackUrlScheme:/',
        'scope':
            'email https://www.googleapis.com/auth/calendar https://www.googleapis.com/auth/gmail.modify',
      });
      final result = await FlutterWebAuth.authenticate(
          url: url.toString(), callbackUrlScheme: callbackUrlScheme);
      final code = Uri.parse(result).queryParameters['code'];
      var value = await serverGoogleAuth("", code!, "$callbackUrlScheme:/");
      return value;
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
                  'https://github.com/login/oauth/authorize?client_id=Iv1.f47bfd491f94b532&redirect_uri=area://oauth2redirect',
            );
          },
        ),
      );
    },
    'Microsoft': (BuildContext context, String token) async {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return AuthWebView(
              clientId: '5731d8cc-7d4b-47dc-812f-f4615f65b38d',
              clientSecret: 'eHV8Q~MgohheH_~OxgTyRgbht8RvdEIZ5MkWQc50',
              serverOauth: (code) {
                serverMicrosoftAuth(code, token);
              },
              authUrl:
                  'https://login.microsoftonline.com/common/oauth2/v2.0/authorize?client_id=5731d8cc-7d4b-47dc-812f-f4615f65b38d&response_type=code&redirect_uri=area://oauth2redirect&response_mode=query&scope=https%3A%2F%2Fgraph.microsoft.com%2FMail.Read%20https%3A%2F%2Fgraph.microsoft.com%2FMail.Read.Shared%20https%3A%2F%2Fgraph.microsoft.com%2FMail.Send%20https%3A%2F%2Fgraph.microsoft.com%2FMail.Send.Shared%20https%3A%2F%2Fgraph.microsoft.com%2FChatMessage.Send%20https%3A%2F%2Fgraph.microsoft.com%2FChatMessage.Read%20https%3A%2F%2Fgraph.microsoft.com%2FUser.Read%20https%3A%2F%2Fgraph.microsoft.com%2FNotes.ReadWrite.All%20https%3A%2F%2Fgraph.microsoft.com%2FMailboxSettings.ReadWrite%20https%3A%2F%2Fgraph.microsoft.com%2FMail.ReadWrite%20offline_access',
            );
          },
        ),
      );
    }
  };
}
