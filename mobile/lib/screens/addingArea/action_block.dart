import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile/back/services.dart';
import 'package:mobile/main.dart';
import 'package:mobile/theme/style.dart';

class ActionBlock extends StatelessWidget {
  final AreaAction action;
  final Service service;
  final Function deleteBlock;
  const ActionBlock({
    super.key,
    required this.action,
    required this.deleteBlock,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => deleteBlock(),
            backgroundColor: Colors.red,
            foregroundColor: AppColors.white,
            icon: Icons.delete,
            label: 'Supprimer',
          ),
        ],
      ),
      child: /* action.service.category == "connecteurs"
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
          : */
          Container(
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
                service.svgIcon,
                width: 24,
                height: 24,
                color: service.iconColor,
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
      ),
    );
  }
}
