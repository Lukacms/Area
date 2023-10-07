import 'package:flutter/material.dart';
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
  String user;
  List<AreaAction> actions;
  String name;
  bool favorite;

  Area({
    required this.user,
    required this.actions,
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
        oAuth: "https://discord.com/api/oauth2/authorize?client_id=1158738215704985681&permissions=8&redirect_uri=http%3A%2F%2Flocalhost%3A8081%2Fsettings%2Fservices&response_type=code&scope=bot",
    ),
    Service(
      name: "Google",
      svgIcon: 'assets/serviceIcons/google.svg',
      iconColor: Colors.white,
      category: 'reseaux',
      actions: ['Message', 'Call', 'Video'],
      oAuth: "https://accounts.google.com/o/oauth2/auth?scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fgmail.modify+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fcalendar&response_type=code&redirect_uri=http%3A%2F%2Flocalhost:8081%2Fsettings%2Fservices%2Fgoogle&client_id=315267877885-2np97bt3qq9s6er73549ldrfme2b67pi.apps.googleusercontent.com",
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
      name: "Linkedin",
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
}
