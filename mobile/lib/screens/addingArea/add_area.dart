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
  final List<int> userServices;
  final List<AreaAction> actions;
  final List<AreaAction> reactions;
  const AddArea({
    super.key,
    required this.parentContext,
    required this.addActionCallback,
    required this.isReaction,
    required this.services,
    required this.userServices,
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
  List<AreaAction> filteredActions = [];
  List<AreaAction> filteredReactions = [];
  List<Service> filteredServices = [];

  searchFieldListenner() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    searchController.addListener(searchFieldListenner);
    filteredActions = widget.actions;
    filteredReactions = widget.reactions;
    filteredServices = widget.services;
  }

  @override
  Widget build(BuildContext context) {
    if (searchController.text.isNotEmpty) {
      filteredActions = [];
      filteredReactions = [];
      filteredServices = [];
      for (var service in widget.services) {
        if (service.name.toLowerCase().contains(searchController.text)) {
          filteredServices.add(service);
        }
      }
      print(filteredServices);
      if (filteredServices.isEmpty) {
        filteredServices = widget.services;
        if (selectedSegment == "Actions") {
          for (var action in widget.actions) {
            if (action.name.toLowerCase().contains(searchController.text)) {
              filteredActions.add(action);
            }
          }
        } else {
          for (var reaction in widget.reactions) {
            if (reaction.name.toLowerCase().contains(searchController.text)) {
              filteredReactions.add(reaction);
            }
          }
        }
      } else {
        filteredActions = widget.actions;
        filteredReactions = widget.reactions;
      }
    } else {
      filteredActions = widget.actions;
      filteredReactions = widget.reactions;
      filteredServices = widget.services;
    }
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
                          : AppColors.white,
                    ),
                  ),
                },
                onValueChanged: (value) {
                  setState(() {
                    selectedSegment = value.toString();
                  });
                },
              ),
            ),
            Container(width: screenWidth, height: 1, color: AppColors.white),
            Expanded(
              child: ActionReactionLists(
                type: selectedSegment.toLowerCase(),
                actions: filteredActions,
                reactions: filteredReactions,
                services: filteredServices,
                userServices: widget.userServices,
                parentContext: widget.parentContext,
                addActionCallback: widget.addActionCallback,
              ),
            )
          ],
        ),
      ),
    );
  }
}
