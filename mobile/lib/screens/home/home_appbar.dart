import 'package:flutter/material.dart';
import 'package:mobile/components/search_field.dart';
import 'package:mobile/main.dart';
import 'package:mobile/theme/style.dart';

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
