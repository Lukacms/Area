import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile/back/services.dart';
import 'package:mobile/main.dart';
import 'package:mobile/theme/style.dart';

class ActionBlock extends StatelessWidget {
  final AreaAction action;
  const ActionBlock({
    super.key,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return action.service.category == "connecteurs"
        ? Padding(
            padding: EdgeInsets.symmetric(horizontal: blockWidth),
            child: Container(
              height: blockHeight * 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.white.withOpacity(0.1),
              ),
              alignment: Alignment.center,
              child: Text(
                action.name,
                style: TextStyle(color: AppColors.lightBlue),
              ),
            ),
          )
        : Container(
            height: blockHeight * 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.white.withOpacity(0.1),
            ),
            child: Padding(
              padding: EdgeInsets.only(left: blockHeight * 2),
              child: Row(
                children: [
                  SvgPicture.asset(
                    action.service.svgIcon,
                    color: action.service.iconColor,
                  ),
                  SizedBox(
                    width: blockWidth / 4,
                  ),
                  Text(
                    action.name,
                    style: TextStyle(
                      color: AppColors.white,
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
