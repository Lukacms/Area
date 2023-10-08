import 'package:flutter/material.dart';
import 'package:mobile/back/services.dart';
import 'package:mobile/main.dart';
import 'package:mobile/screens/addingArea/action_block.dart';
import 'package:mobile/theme/style.dart';

class ActionBlockList extends StatefulWidget {
  final AreaAction action;
  const ActionBlockList({
    super.key,
    required this.action,
  });

  @override
  State<ActionBlockList> createState() => _ActionBlockListState();
}

class _ActionBlockListState extends State<ActionBlockList> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 300,
          child: ListView.builder(
            itemCount: 1,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ActionBlock(
                    action: widget.action,
                  ),
                  Container(
                    height: blockHeight * 2,
                    width: blockHeight,
                    color: AppColors.white.withOpacity(0.1),
                  )
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
