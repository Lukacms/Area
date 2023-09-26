import 'package:flutter/material.dart';
import 'package:mobile/main.dart';
import 'package:mobile/theme/style.dart';

class HomeAppBar extends AppBar {
  final TextEditingController searchController;
  HomeAppBar({super.key, required this.searchController})
      : super(
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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal:blockWidth / 4),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: "Recherche",
                      hintStyle: TextStyle(
                        color: AppColors.white.withOpacity(0.5),
                      ),
                      fillColor: AppColors.white.withOpacity(0.1),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: AppColors.white.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
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
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                Icons.add,
                color: AppColors.lightBlue,
                size: 30,
              ),
              onPressed: () {},
            )
          ],
        );
}
