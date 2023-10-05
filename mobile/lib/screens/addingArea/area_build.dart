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
  const AreaBuild({
    super.key,
    this.area,
    required this.areaAdd,
    required this.isEdit,
  });

  @override
  State<AreaBuild> createState() => _AreaBuildState();
}

class _AreaBuildState extends State<AreaBuild> {
  TextEditingController areaNameController = TextEditingController();
  Area newArea = Area(actions: [], name: "", user: "");
  List actionsList = [];
  Area? savedArea;

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
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: newArea.actions.isEmpty
          ? null
          : TextButton(
              onPressed: () {
                if (newArea.name.isEmpty) {
                  print("NON");
                  return;
                }
                widget.areaAdd(newArea);
                if (!widget.isEdit) {
                  addArea(newArea, "user");
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
                child: newArea.actions.isEmpty
                    ? AddActionButton(
                        addActionCallback: (value) {
                          setState(() {
                            newArea.actions.add(value);
                          });
                        },
                      )
                    : Column(
                        children: [
                          ActionBlockList(actions: newArea.actions),
                          SizedBox(height: blockHeight * 4),
                          AddActionButton(addActionCallback: (value) {
                            setState(() {
                              newArea.actions.add(value);
                            });
                          })
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
