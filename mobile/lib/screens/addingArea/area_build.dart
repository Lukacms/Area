import 'package:flutter/material.dart';
import 'package:mobile/back/api.dart';
import 'package:mobile/back/services.dart';
import 'package:mobile/components/backgroundCircles.dart';
import 'package:mobile/main.dart';
import 'package:mobile/screens/addingArea/action_blocks_list.dart';
import 'package:mobile/screens/addingArea/add_action_button.dart';
import 'package:mobile/theme/style.dart';

class AreaBuild extends StatefulWidget {
  final Area? area;
  final Function areaAdd;
  final bool isEdit;
  final String token;
  final int userId;
  final int areasLenght;
  const AreaBuild({
    super.key,
    this.area,
    required this.areaAdd,
    required this.isEdit,
    required this.token,
    required this.userId,
    required this.areasLenght,
  });

  @override
  State<AreaBuild> createState() => _AreaBuildState();
}

class _AreaBuildState extends State<AreaBuild> {
  TextEditingController areaNameController = TextEditingController();
  Area newArea =
      Area(action: null, reactions: [], name: "", userId: -1, areaId: -1);
  List actionsList = [];
  Area? savedArea;
  bool isNamed = true;

  @override
  void initState() {
    super.initState();
    if (widget.area != null) {
      areaNameController.text = widget.area!.name;
    }
    areaNameController.addListener(() {
      newArea.name = areaNameController.text;
    });
    if (widget.area != null) {
      newArea = widget.area!;
    }
    if (widget.isEdit) {
      savedArea = widget.area;
    }
  }

  @override
  Widget build(BuildContext context) {
    final safePadding = MediaQuery.of(context).padding.top;
    if (newArea.name.isNotEmpty) {
      isNamed = true;
    }
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.darkBlue,
      appBar: AppBar(
        toolbarHeight: blockHeight * 9,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.lightBlue,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: AppColors.white.withOpacity(0.1),
        title: SizedBox(
          width: blockWidth * 2,
          height: blockHeight * 7,
          child: TextField(
            textAlign: TextAlign.center,
            controller: areaNameController,
            style: TextStyle(
              color: AppColors.white,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.black.withOpacity(0.1),
              hintText: "Nom de l'Area",
              hintStyle: TextStyle(
                color: AppColors.white.withOpacity(0.5),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              errorText: !isNamed ? "Veuillez nommer votre Area" : null,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: newArea.action == null
          ? null
          : TextButton(
              onPressed: () {
                if (newArea.name.isEmpty) {
                  setState(() {
                    isNamed = false;
                  });
                  return;
                }
                widget.areaAdd(newArea);
                if (!widget.isEdit) {
                  /* serverAddFullArea(
                      widget.token,
                      widget.userId,
                      widget.areasLenght - 1,
                      newArea.name,
                      newArea.action!,
                      newArea.reactions); */
                  serverAddArea(widget.token, widget.userId,
                      widget.areasLenght - 1, newArea.name);
                } else {
                  editArea(newArea, savedArea!);
                }
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                backgroundColor: AppColors.white.withOpacity(0.1),
              ),
              child: Text(
                "Sauvegarder",
                style: TextStyle(
                  color: AppColors.lightBlue,
                ),
              ),
            ),
      body: Stack(
        children: [
          const BackgroundCircles(),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: safePadding + blockHeight * 11),
                child: newArea.action == null
                    ? AddActionButton(
                        isReaction: false,
                        addActionCallback: (value) {
                          setState(
                            () {
                              newArea.action = value;
                            },
                          );
                        },
                      )
                    : Column(
                        children: [
                          ActionBlockList(
                            action: newArea.action!,
                            reactions: newArea.reactions,
                            removeActionCallback: () {
                              setState(() {
                                newArea.action = null;
                                newArea.reactions = [];
                              });
                            },
                            removeReactionCallback: (value) {
                              setState(() {
                                newArea.reactions
                                    .remove(newArea.reactions[value]);
                              });
                            },
                          ),
                          SizedBox(height: blockHeight * 4),
                          AddActionButton(
                            isReaction: true,
                            addActionCallback: (value) {
                              setState(
                                () {
                                  newArea.reactions.add(value);
                                },
                              );
                            },
                          )
                        ],
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
