import 'package:flutter/material.dart';
import 'package:mobile/main.dart';
import 'package:mobile/screens/home/area_group.dart';

class AreaLists extends StatefulWidget {
  final List areas;
  final String searchText;
  const AreaLists({
    super.key,
    required this.areas,
    required this.searchText,
  });

  @override
  State<AreaLists> createState() => _AreaListsState();
}

class _AreaListsState extends State<AreaLists> {
  List searchAreas() {
    List searchAreas = [];
    for (var area in widget.areas) {
      if (area['name'].contains(widget.searchText)) {
        searchAreas.add(area);
      }
    }
    return searchAreas;
  }

  @override
  Widget build(BuildContext context) {
    List favorites = [];
    for (var area in widget.areas) {
      if (area['favorite']) {
        favorites.add(area);
      }
    }
    return Padding(
      padding: EdgeInsets.only(top: blockHeight * 5),
      child: widget.searchText.isEmpty
          ? Column(
              children: [
                AreaGroup(
                  group: favorites,
                  groupName: "Mes Favoris",
                ),
                AreaGroup(
                  group: widget.areas,
                  groupName: "Mes Areas",
                )
              ],
            )
          : Column(
              children: [
                AreaGroup(
                  group: searchAreas(),
                  groupName: "Recherche",
                ),
              ],
            ),
    );
  }
}
