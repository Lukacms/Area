import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobile/back/api.dart';
import 'package:mobile/screens/settings/webview/oauth_webview.dart';
import 'package:mobile/theme/style.dart';

class Service {
  final String name;
  final String svgIcon;
  final Color iconColor;
  final String category;
  final List actions;
  final String oAuth;

  Service(
      {required this.name,
      required this.svgIcon,
      required this.iconColor,
      required this.category,
      required this.actions,
      required this.oAuth});
}

class AreaAction {
  final Service service;
  final String name;

  AreaAction({
    required this.service,
    required this.name,
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
  List services = [
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
  ];
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
      final GoogleSignIn googleSignIn = GoogleSignIn();
      try {
        final googleUser = await googleSignIn.signIn();
        final googleAuth = await googleUser?.authentication;
        if (googleAuth != null) {
          final String? token = googleAuth.accessToken;
          final String? serverAuthCode =
              googleUser?.serverAuthCode; // Get the serverAuthCode

          if (kDebugMode) {
            print(googleAuth.accessToken);
            print(serverAuthCode);
          }
          return token;
        } else {
          if (kDebugMode) {
            print('User not signed in');
          }
          return null;
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
        return null;
      }
      /* Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return AuthWebView(
              clientId:
                  '315267877885-7b6hvo4ibh0ms9lmt4fe1dvp9asqchdj.apps.googleusercontent.com',
              clientSecret: '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',
              serverOauth: (code) {
                //serverSpotifyAuth(code, token);
              },
              authUrl:
                  'https://accounts.google.com/o/oauth2/auth?scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fgmail.modify+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fcalendar&response_type=code&redirect_uri=area://oauth2redirect&client_id=315267877885-7b6hvo4ibh0ms9lmt4fe1dvp9asqchdj.apps.googleusercontent.com&access_type=offline',
            );
          },
        ),
      ); */
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
