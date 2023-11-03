import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/back/services.dart';
import 'package:mobile/components/search_field.dart';
import 'package:mobile/main.dart';
import 'package:mobile/screens/addingArea/action_reaction_lists.dart';
import 'package:mobile/theme/style.dart';

class AddArea extends StatefulWidget {
  final BuildContext parentContext;
  final Function addActionCallback;
  final bool isReaction;
  final List<Service> services;
  final List<AreaAction> actions;
  final List<AreaAction> reactions;
  const AddArea({
    super.key,
    required this.parentContext,
    required this.addActionCallback,
    required this.isReaction,
    required this.services,
    required this.actions,
    required this.reactions,
  });

  @override
  State<AddArea> createState() => _AddAreaState();
}

class _AddAreaState extends State<AddArea> {
  TextEditingController searchController = TextEditingController();
  String selectedSegment = "Actions";
  String selectedCategory = "";
  @override
  Widget build(BuildContext context) {
    if (widget.isReaction) {
      selectedSegment = "Reactions";
    }
    return SizedBox(
      height: screenHeight * 0.85,
      child: Scaffold(
        backgroundColor: AppColors.darkBlue,
        body: Column(
          children: [
            SearchField(
              searchController: searchController,
              hintText: "Rechercher apps et actions",
              padding: blockWidth / 4,
              horizontal: true,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: blockHeight * 2),
              child: CupertinoSlidingSegmentedControl(
                  groupValue: selectedSegment,
                  children: {
                    "Actions": Text(
                      "Actions",
                      style: TextStyle(
                          color: selectedSegment == "Actions"
                              ? Colors.black
                              : AppColors.white),
                    ),
                    "Reactions": Text(
                      "Reactions",
                      style: TextStyle(
                          color: selectedSegment == "Reactions"
                              ? Colors.black
                              : AppColors.white),
                    ),
                  },
                  onValueChanged: (value) {
                    setState(() {
                      selectedSegment = value.toString();
                    });
                  }),
            ),
            Container(width: screenWidth, height: 1, color: AppColors.white),
            selectedSegment == "Actions"
                ? GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    childAspectRatio: blockWidth / (blockHeight * 2),
                    padding: EdgeInsets.only(
                        left: blockHeight * 2, top: blockHeight),
                    children: List.generate(
                      AppServices().categories.length,
                      (index) {
                        return Builder(builder: (context) {
                          return TextButton(
                            style:
                                TextButton.styleFrom(padding: EdgeInsets.zero),
                            onPressed: () {
                              setState(() {
                                selectedCategory =
                                    AppServices().categories[index][0];
                              });
                              Scaffold.of(context).openEndDrawer();
                            },
                            child: Row(
                              children: [
                                AppServices().categories[index][1],
                                SizedBox(width: blockHeight),
                                Text(
                                  AppServices().categories[index][0],
                                  style: TextStyle(color: AppColors.lightBlue),
                                ),
                              ],
                            ),
                          );
                        });
                      },
                    ),
                  )
                : GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 1,
                    childAspectRatio: blockWidth / (blockHeight * 2),
                    padding: EdgeInsets.only(
                        left: blockHeight * 2, top: blockHeight),
                    children: List.generate(
                      AppServices().categories.length,
                      (index) {
                        return Builder(builder: (context) {
                          return TextButton(
                            style:
                                TextButton.styleFrom(padding: EdgeInsets.zero),
                            onPressed: () {
                              setState(() {
                                selectedCategory =
                                    AppServices().categories[index][0];
                              });
                              Scaffold.of(context).openEndDrawer();
                            },
                            child: Row(
                              children: [
                                AppServices().categories[index][1],
                                SizedBox(width: blockHeight),
                                Text(
                                  AppServices().categories[index][0],
                                  style: TextStyle(color: AppColors.lightBlue),
                                ),
                              ],
                            ),
                          );
                        });
                      },
                    ),
                  )
          ],
        ),
        endDrawer: ActionReactionLists(
          type: selectedSegment.toLowerCase(),
          actions: widget.actions,
          reactions: widget.reactions,
          services: widget.services,
          category: selectedCategory,
          parentContext: widget.parentContext,
          addActionCallback: widget.addActionCallback,
        ),
      ),
    );
  }
}
