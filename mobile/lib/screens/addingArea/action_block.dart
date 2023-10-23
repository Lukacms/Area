import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile/back/services.dart';
import 'package:mobile/main.dart';
import 'package:mobile/screens/addingArea/action_parameter_field.dart';
import 'package:mobile/theme/style.dart';

class ActionBlock extends StatelessWidget {
  final AreaAction action;
  final Service service;
  final Function deleteBlock;
  final bool isAction;
  const ActionBlock({
    super.key,
    required this.action,
    required this.deleteBlock,
    required this.service,
    required this.isAction,
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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.white.withOpacity(0.1),
        ),
        padding: EdgeInsets.symmetric(vertical: blockHeight),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: blockHeight * 2),
          child: Column(
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    service.svgIcon,
                    width: 24,
                    height: 24,
                    // ignore: deprecated_member_use
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
              ListView.builder(
                shrinkWrap: true,
                itemCount: action.defaultConfiguration.length,
                itemBuilder: ((context, index) {
                  String key =
                      action.defaultConfiguration.keys.elementAt(index);
                  return ActionParameterField(
                    action: action,
                    fieldName: key,
                    onChanged: (value) {
                      action.configuration[key] = value;
                    },
                  );
                }),
              ),
              isAction
                  ? ActionParameterField(
                      action: action,
                      fieldName: "Timer",
                      onChanged: (value) {
                        action.timer = int.parse(value);
                      })
                  : const SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }
}
