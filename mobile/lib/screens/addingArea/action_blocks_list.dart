import 'package:flutter/material.dart';
import 'package:mobile/back/services.dart';
import 'package:mobile/main.dart';
import 'package:mobile/screens/addingArea/action_block.dart';
import 'package:mobile/theme/style.dart';

class ActionBlockList extends StatefulWidget {
  final List<AreaAction> actions;
  const ActionBlockList({
    super.key,
    required this.actions,
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
            itemCount: widget.actions.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return index != widget.actions.length - 1
                  ? Column(
                      children: [
                        ActionBlock(
                          action: widget.actions[index],
                        ),
                        Container(
                          height: blockHeight * 2,
                          width: blockHeight,
                          color: AppColors.white.withOpacity(0.1),
                        )
                      ],
                    )
                  : ActionBlock(
                      action: widget.actions[index],
                    );
            },
          ),
        ),
      ],
    );
  }
}
