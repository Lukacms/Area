import 'package:flutter/material.dart';
import 'package:mobile/back/services.dart';
import 'package:mobile/screens/addingArea/add_area.dart';
import 'package:mobile/theme/style.dart';

// This file contains the implementation of the AddActionButton widget, which is 
// a stateless widget that displays a button to add a new action or reaction block. 
// The AddActionButton widget takes in several parameters, including a callback function 
// to add a new action or reaction block, a boolean value to determine whether the block is an 
// action or a reaction, and lists of services, user services, actions, and reactions. When the 
// button is pressed, the widget displays a modal bottom sheet that allows the user to select a 
// service and configure the new action or reaction block. The AddActionButton widget is used to
//  display a button to add a new action or reaction block in the mobile app.

class AddActionButton extends StatelessWidget {
  final Function addActionCallback;
  final bool isReaction;
  final List<Service> services;
  final List<int> userServices;
  final List<AreaAction> actions;
  final List<AreaAction> reactions;
  const AddActionButton({
    super.key,
    required this.addActionCallback,
    required this.isReaction,
    required this.services,
    required this.userServices,
    required this.actions,
    required this.reactions,
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
                    userServices: userServices,
                    actions: actions,
                    reactions: reactions,
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
