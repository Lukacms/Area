import 'package:flutter/material.dart';
import 'package:mobile/screens/addingArea/add_area.dart';
import 'package:mobile/theme/style.dart';

class AddActionButton extends StatelessWidget {
  final Function addActionCallback;
  final bool isReaction;
  const AddActionButton({
    super.key,
    required this.addActionCallback,
    required this.isReaction,
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
