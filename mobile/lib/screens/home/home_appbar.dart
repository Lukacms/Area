import 'package:flutter/material.dart';
import 'package:mobile/components/search_field.dart';
import 'package:mobile/main.dart';
import 'package:mobile/theme/style.dart';

// The HomeAppBar widget is a custom AppBar used in the home screen of the app. 
// It has a transparent background and no leading widget. It contains a SearchField
//  widget for searching areas and two IconButton widgets as actions: one for opening 
//  the settings screen and one for adding a new area. It takes several parameters 
//  including a TextEditingController for the search field, a BuildContext, a function 
//  to add an area, and a function to open the settings screen.

class HomeAppBar extends AppBar {
  final TextEditingController searchController;
  final BuildContext context;
  final Function addArea;
  final Function settings;
  HomeAppBar({
    super.key,
    required this.searchController,
    required this.context,
    required this.addArea,
    required this.settings,
  }) : super(
          automaticallyImplyLeading: false,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(blockHeight * 15),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: blockWidth / 4),
                  child: Row(
                    children: [
                      Text(
                        "FastR",
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 50,
                          fontFamily: "Roboto-Bold",
                        ),
                      ),
                    ],
                  ),
                ),
                SearchField(
                    searchController: searchController, padding: blockWidth / 4)
              ],
            ),
          ),
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              icon: Icon(
                Icons.pending_outlined,
                color: AppColors.lightBlue,
                size: 30,
              ),
              onPressed: () {
                settings();
              },
            ),
            IconButton(
              icon: Icon(
                Icons.add,
                color: AppColors.lightBlue,
                size: 30,
              ),
              onPressed: () {
                addArea();
              },
            )
          ],
        );
}
