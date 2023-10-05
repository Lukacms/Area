import 'package:flutter/material.dart';
import 'package:mobile/theme/style.dart';

class Service {
  final String name;
  final String svgIcon;
  final Color iconColor;
  final String category;
  final List actions;

  Service({
    required this.name,
    required this.svgIcon,
    required this.iconColor,
    required this.category,
    required this.actions,
  });
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
        actions: ['Commit', 'Push', 'Pull']),
    Service(
        name: "Discord",
        svgIcon: 'assets/serviceIcons/discord.svg',
        iconColor: Colors.purple,
        category: 'messageries',
        actions: ['Message', 'Call', 'Video']),
    Service(
      name: "Instagram",
      svgIcon: 'assets/serviceIcons/instagram.svg',
      iconColor: Colors.pink,
      category: 'reseaux',
      actions: ['Message', 'Call', 'Video'],
    ),
    Service(
      name: "Linkedin",
      svgIcon: 'assets/serviceIcons/linkedin.svg',
      iconColor: Colors.blue,
      category: "reseaux",
      actions: ['Message', 'Call', 'Video'],
    ),
    Service(
      name: "Conditions",
      svgIcon: 'assets/serviceIcons/connectors.svg',
      iconColor: AppColors.lightBlue,
      category: 'connecteurs',
      actions: ['If', 'Or', 'And', 'Not', 'Else'],
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
