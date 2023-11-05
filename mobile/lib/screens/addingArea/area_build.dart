import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/back/api.dart';
import 'package:mobile/back/services.dart';
import 'package:mobile/components/backgroundCircles.dart';
import 'package:mobile/main.dart';
import 'package:mobile/screens/addingArea/action_blocks_list.dart';
import 'package:mobile/screens/addingArea/add_action_button.dart';
import 'package:mobile/theme/style.dart';

// This file contains the implementation of the AreaBuild widget, which is a 
// stateful widget that displays a screen to create or edit an area in the mobile app. 
// The AreaBuild widget takes in several parameters, including an Area object,
// a callback function to add a new area, a boolean value to determine whether the
// a list of actions, and a list of reactions. The widget displays a text field to enter
// the area name, a list of action and reaction blocks, and a switch to mark the area as a 
// favorite. The AreaBuild widget is used to display a screen to create or edit an area in the mobile app.

class AreaBuild extends StatefulWidget {
  final Area? area;
  final Function areaAdd;
  final bool isEdit;
  final String token;
  final int userId;
  final int areasLenght;
  final List<Service> services;
  final List<int> userServices;
  final List<AreaAction> actions;
  final List<AreaAction> reactions;
  const AreaBuild({
    super.key,
    this.area,
    required this.areaAdd,
    required this.isEdit,
    required this.token,
    required this.userId,
    required this.areasLenght,
    required this.services,
    required this.userServices,
    required this.actions,
    required this.reactions,
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
              onPressed: () async {
                if (newArea.name.isEmpty) {
                  setState(() {
                    isNamed = false;
                  });
                  return;
                }
                if (!widget.isEdit) {
                  await serverAddFullArea(
                    widget.token,
                    widget.userId,
                    widget.areasLenght - 1,
                    newArea.name,
                    newArea.action!,
                    newArea.reactions,
                    newArea.favorite
                  );
                } else {
                  await serverDeleteArea(widget.token, newArea.areaId);
                  await serverAddFullArea(
                    widget.token,
                    widget.userId,
                    widget.areasLenght - 1,
                    newArea.name,
                    newArea.action!,
                    newArea.reactions,
                    newArea.favorite
                  );
                }
                widget.areaAdd(newArea);
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
                        actions: widget.actions,
                        reactions: widget.reactions,
                        services: widget.services,
                        userServices: widget.userServices,
                        isReaction: false,
                        addActionCallback: (value) {
                          setState(
                            () {
                              newArea.action = value;
                            },
                          );
                        },
                      )
                    : SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics()),

                      child: Column(
                          children: [
                            ActionBlockList(
                              services: widget.services,
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
                              actions: widget.actions,
                              reactions: widget.reactions,
                              services: widget.services,
                              userServices: widget.userServices,
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
              ),
            ],
          ),
        ],
      ),
      persistentFooterAlignment: AlignmentDirectional.center,
      persistentFooterButtons: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: blockHeight),
              child: Text(
                "Favorite",
                style: TextStyle(color: AppColors.white, fontSize: 18),
              ),
            ),
            CupertinoSwitch(
                value: newArea.favorite,
                onChanged: (value) {
                  setState(() {
                    newArea.favorite = value;
                  });
                })
          ],
        )
      ],
    );
  }
}
