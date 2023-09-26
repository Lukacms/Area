import 'package:flutter/material.dart';
import 'package:mobile/main.dart';
import 'package:mobile/theme/style.dart';

class AreaCard extends StatelessWidget {
  final String name;
  const AreaCard({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: blockWidth,
      height: blockHeight * 0.5,
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
          Padding(
            padding: EdgeInsets.only(
              top: blockHeight * 2,
            ),
            child: Text(
              " $name",
              style: TextStyle(color: AppColors.white, overflow: TextOverflow.ellipsis),
            ),
          ),
        ],
      ),
    );
  }
}
