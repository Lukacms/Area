import 'package:flutter/material.dart';
import 'package:mobile/main.dart';
import 'package:mobile/screens/area_group.dart';
import 'package:mobile/theme/style.dart';

class AreaLists extends StatelessWidget {
  final List areas;
  const AreaLists({super.key, required this.areas});

  @override
  Widget build(BuildContext context) {
    List favorites = [];
    for (var area in areas) {
      if (area['favorite']) {
        favorites.add(area);
      }
    }
    return Padding(
      padding: EdgeInsets.only(top: blockHeight * 5),
      child: Column(
        children: [
          AreaGroup(group: favorites, groupName: "Mes Favoris",),
          AreaGroup(group: areas, groupName: "Mes Areas",)
        ],
      ),
    );
  }
}
