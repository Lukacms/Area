import 'package:flutter/material.dart';
import 'package:mobile/back/services.dart';
import 'package:mobile/main.dart';
import 'package:mobile/screens/addingArea/action_block.dart';
import 'package:mobile/theme/style.dart';

class ActionBlockList extends StatefulWidget {
  final AreaAction action;
  final List<AreaAction> reactions;
  const ActionBlockList({
    super.key,
    required this.action,
    required this.reactions,
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
            itemCount: widget.reactions.isNotEmpty ? widget.reactions.length : 1,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              print(index);
              return index == 0
                  ? Column(
                      children: [
                        ActionBlock(
                          action: widget.action,
                        ),
                        widget.reactions.isEmpty
                            ? Container()
                            : Container(
                                height: blockHeight * 2,
                                width: blockHeight,
                                color: AppColors.white.withOpacity(0.1),
                              )
                      ],
                    )
                  : Column(
                      children: [
                        ActionBlock(
                          action: widget.reactions[index],
                        ),
                        index == widget.reactions.length - 1
                            ? Container()
                            : Container(
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
