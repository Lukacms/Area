// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:mobile/back/api.dart';
import 'package:mobile/back/services.dart';
import 'package:mobile/main.dart';
import 'package:mobile/screens/addingArea/area_build.dart';
import 'package:mobile/theme/style.dart';

// The AreaCard widget displays an area with its name and favorite status. It has a
//  PopupMenuButton that allows the user to edit or delete the area. The widget takes 
//  several parameters including an Area object, a token, a user ID, the length of the areas list,
//   a function to edit an area, a list of services, a list of user services, a list of area actions, 
//   and a list of area reactions.

class AreaCard extends StatelessWidget {
  final Area area;
  final String token;
  final int userId;
  final int areasLength;
  final Function editAreaCallback;
  final List<Service> services;
  final List<int> userServices;
  final List<AreaAction> actions;
  final List<AreaAction> reactions;
  const AreaCard({
    super.key,
    required this.area,
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
  Widget build(BuildContext context) {
    const Key editKey = Key('edit');
    const Key cardKey = Key('card');
    return Container(
      key: cardKey,
      width: blockWidth,
      height: blockHeight * 0.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.white.withOpacity(0.1),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              area.favorite
                  ? Padding(
                      padding: EdgeInsets.only(left: blockHeight),
                      child: const Icon(Icons.star, color: Colors.yellow),
                    )
                  : Container(),
              PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AreaBuild(
                              actions: actions,
                              reactions: reactions,
                              services: services,
                              userServices: userServices,
                              token: token,
                              userId: userId,
                              areasLenght: areasLength,
                              isEdit: true,
                              areaAdd: (value) {
                                editAreaCallback(value);
                              },
                              area: area,
                            ),
                          ),
                        );
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Modifier",
                            style: TextStyle(color: Colors.black),
                          ),
                          Icon(
                            Icons.edit,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    key: editKey,
                    child: TextButton(
                      onPressed: () {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Êtes-vous sûr.e ?'),
                            content: const Text(
                                'Toutes les données de l\'area seront perdues.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Annuler'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await serverDeleteArea(token, area.areaId);
                                  editAreaCallback(area);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                child: const Text('Confirmer'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Supprimer",
                            style: TextStyle(color: Colors.red),
                          ),
                          Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                icon: Icon(
                  Icons.pending,
                  color: AppColors.white,
                ),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
              top: blockHeight * 2,
            ),
            child: Text(
              " ${area.name}",
              style: TextStyle(
                color: AppColors.white,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
