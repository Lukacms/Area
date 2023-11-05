import 'package:flutter/material.dart';
import 'package:mobile/back/services.dart';
import 'package:mobile/main.dart';
import 'package:mobile/screens/home/area_card.dart';
import 'package:mobile/theme/style.dart';

class AreaGroup extends StatelessWidget {
  final List<Area> group;
  final String groupName;
  final Function editAreaCallback;
  final String token;
  final int userId;
  final int areasLength;
  final List<Service> services;
  final List<int> userServices;
  final List<AreaAction> actions;
  final List<AreaAction> reactions;
  const AreaGroup({
    super.key,
    required this.group,
    this.groupName = "",
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
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.folder_outlined, color: AppColors.lightBlue),
            Text(
              groupName,
              style: TextStyle(color: AppColors.white),
            )
          ],
        ),
        GridView.count(
          padding: EdgeInsets.symmetric(vertical: blockHeight * 2),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 2,
          childAspectRatio: blockWidth / (blockHeight * 5.5),
          mainAxisSpacing: blockHeight,
          crossAxisSpacing: blockHeight,
          children: List.generate(
            group.length,
            (index) {
              return SizedBox(
                height: 50,
                child: AreaCard(
                  actions: actions,
                  reactions: reactions,
                  services: services,
                  userServices: userServices,
                  area: group[index],
                  editAreaCallback: (value) {
                    editAreaCallback(value);
                  },
                  token: token,
                  userId: userId,
                  areasLength: areasLength,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
