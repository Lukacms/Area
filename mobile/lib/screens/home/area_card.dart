import 'package:flutter/material.dart';
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
              IconButton(
                icon: Icon(
                  Icons.pending,
                  color: AppColors.white,
                ),
                onPressed: () {
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
