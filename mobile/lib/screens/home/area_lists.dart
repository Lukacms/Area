import 'package:flutter/material.dart';
import 'package:mobile/back/services.dart';
import 'package:mobile/main.dart';
import 'package:mobile/screens/home/area_group.dart';

class AreaLists extends StatefulWidget {
  final List<Area> areas;
  final Function editAreaCallback;
  final String searchText;
  final String token;
  final int userId;
  final int areasLength;
  final List<Service> services;
  final List<int> userServices;
  final List<AreaAction> actions;
  final List<AreaAction> reactions;
  const AreaLists({
    super.key,
    required this.areas,
    required this.searchText,
    required this.editAreaCallback,
    required this.token,
    required this.userId,
    required this.areasLength,
    required this.services,
    required this.userServices,
    required this.actions,
    required this.reactions,
  });

  @override
  State<AreaLists> createState() => _AreaListsState();
}

class _AreaListsState extends State<AreaLists> {
  List<Area> searchAreas() {
    List<Area> searchAreas = [];
    for (var area in widget.areas) {
      String lowercaseName = area.name.toLowerCase();
      String lowercaseSearchText = widget.searchText.toLowerCase();
      if (lowercaseName.contains(lowercaseSearchText)) {
        searchAreas.add(area);
      }
    }
    return searchAreas;
  }

  @override
  Widget build(BuildContext context) {
    List<Area> favorites = [];
    for (var area in widget.areas) {
      if (area.favorite) {
        favorites.add(area);
      }
    }
    return Padding(
      padding: EdgeInsets.only(top: blockHeight * 5),
      child: widget.searchText.isEmpty
          ? Column(
              children: [
                AreaGroup(
                  actions: widget.actions,
                  reactions: widget.reactions,
                  services: widget.services,
                  userServices: widget.userServices,
                  token: widget.token,
                  userId: widget.userId,
                  areasLength: widget.areasLength,
                  group: favorites,
                  groupName: "Mes Favoris",
                  editAreaCallback: widget.editAreaCallback,
                ),
                AreaGroup(
                  actions: widget.actions,
                  reactions: widget.reactions,
                  services: widget.services,
                  userServices: widget.userServices,
                  token: widget.token,
                  userId: widget.userId,
                  areasLength: widget.areasLength,
                  group: widget.areas,
                  groupName: "Mes Areas",
                  editAreaCallback: widget.editAreaCallback,
                )
              ],
            )
          : Column(
              children: [
                AreaGroup(
                  actions: widget.actions,
                  reactions: widget.reactions,
                  services: widget.services,
                  userServices: widget.userServices,
                  token: widget.token,
                  userId: widget.userId,
                  areasLength: widget.areasLength,
                  group: searchAreas(),
                  groupName: "Recherche",
                  editAreaCallback: widget.editAreaCallback,
                ),
              ],
            ),
    );
  }
}
