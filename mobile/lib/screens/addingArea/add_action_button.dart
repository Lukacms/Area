import 'package:flutter/material.dart';
import 'package:mobile/back/services.dart';
import 'package:mobile/screens/addingArea/add_area.dart';
import 'package:mobile/theme/style.dart';

class AddActionButton extends StatelessWidget {
  final Function addActionCallback;
  final bool isReaction;
  final List<Service> services;
  final List<AreaAction> actions;
  const AddActionButton({
    super.key,
    required this.addActionCallback,
    required this.isReaction,
    required this.services,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
            style: TextButton.styleFrom(
                backgroundColor: AppColors.white.withOpacity(0.1),
                shape: const CircleBorder()),
            onPressed: () {
              showModalBottomSheet(
                useRootNavigator: true,
                isScrollControlled: true,
                context: context,
                backgroundColor: AppColors.darkBlue,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                showDragHandle: true,
                barrierColor: Colors.transparent,
                builder: (BuildContext context) {
                  return AddArea(
                    services: services,
                    actions: actions,
                    parentContext: context,
                    addActionCallback: addActionCallback,
                    isReaction: isReaction,
                  );
                },
              );
            },
            child: Icon(
              Icons.add,
              color: AppColors.white,
              size: 32,
            )),
      ],
    );
  }
}
