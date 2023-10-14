import 'package:flutter/material.dart';
import 'package:mobile/back/api.dart';
import 'package:mobile/back/services.dart';
import 'package:mobile/main.dart';
import 'package:mobile/screens/addingArea/area_build.dart';
import 'package:mobile/theme/style.dart';

class AreaCard extends StatelessWidget {
  final Area area;
  final String token;
  final int userId;
  final int areasLength;
  final Function editAreaCallback;
  const AreaCard({
    super.key,
    required this.area,
    required this.editAreaCallback,
    required this.token,
    required this.userId,
    required this.areasLength,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: blockWidth,
      height: blockHeight * 0.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.white.withOpacity(0.1),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AreaBuild(
                              token: token,
                              userId: userId,
                              areasLenght: areasLength,
                              isEdit: true,
                              areaAdd: editAreaCallback,
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
                                onPressed: () {
                                  serverDeleteArea(token, area.areaId);
                                  editAreaCallback();
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
