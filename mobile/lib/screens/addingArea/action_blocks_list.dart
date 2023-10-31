import 'package:flutter/material.dart';
import 'package:mobile/back/services.dart';
import 'package:mobile/main.dart';
import 'package:mobile/screens/addingArea/action_block.dart';
import 'package:mobile/theme/style.dart';

class ActionBlockList extends StatefulWidget {
  final AreaAction action;
  final List<AreaAction> reactions;
  final List<Service> services;
  final Function removeActionCallback;
  final Function removeReactionCallback;
  const ActionBlockList({
    super.key,
    required this.services,
    required this.action,
    required this.reactions,
    required this.removeActionCallback,
    required this.removeReactionCallback,
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
            itemCount:
                widget.reactions.isNotEmpty ? widget.reactions.length + 1 : 1,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return index == 0
                  ? Column(
                      children: [
                        ActionBlock(
                          isAction: true,
                          service: widget.services.where((element) => element.id == widget.action.serviceId).first,
                          action: widget.action,
                          deleteBlock: () {
                            widget.removeActionCallback();
                          },
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
                          isAction: false,
                          service: widget.services.where((element) => element.id == widget.reactions[index - 1].serviceId).first,
                          deleteBlock: () {
                            widget.removeReactionCallback(index - 1);
                          },
                          action: widget.reactions[index - 1],
                        ),
                        index == widget.reactions.length
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
