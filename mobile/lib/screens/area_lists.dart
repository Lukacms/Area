import 'package:flutter/material.dart';
import 'package:mobile/main.dart';
import 'package:mobile/theme/style.dart';

class AreaLists extends StatelessWidget {
  final List areas;
  const AreaLists({super.key, required this.areas});

  @override
  Widget build(BuildContext context) {
    List favorites = [];
    for (var area in areas) {
      if (area['favorite']) {
        favorites.add(area);
      }
    }
    return Padding(
      padding: EdgeInsets.only(top: blockHeight * 5),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.folder_outlined, color: AppColors.lightBlue),
              Text(
                "Mes Favoris",
                style: TextStyle(color: AppColors.white),
              )
            ],
          ),
          GridView.count(
            padding: EdgeInsets.only(top: blockHeight * 2),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 2,
            children: List.generate(
              favorites.length,
              (index) {
                return Padding(
                  padding: index % 2 != 0
                      ? EdgeInsets.only(bottom: blockHeight, left: blockHeight)
                      : EdgeInsets.only(bottom: blockHeight),
                  child: Container(
                    width: blockWidth,
                    height: blockHeight * 5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppColors.white.withOpacity(0.1)),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.pending,
                                color: AppColors.white,
                              ),
                              onPressed: () {},
                            )
                          ],
                        ),
                        SizedBox(
                          width: blockWidth * 0.9,
                          child: Text(
                            favorites[index]['name'],
                            style: TextStyle(color: AppColors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
