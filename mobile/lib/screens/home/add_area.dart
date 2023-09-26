import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/components/search_field.dart';
import 'package:mobile/main.dart';
import 'package:mobile/theme/style.dart';

class AddArea extends StatefulWidget {
  const AddArea({super.key});

  @override
  State<AddArea> createState() => _AddAreaState();
}

class _AddAreaState extends State<AddArea> {
  TextEditingController searchController = TextEditingController();
  String selectedSegment = "Apps";
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: screenHeight * 0.85,
      child: Column(
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
                  "Apps": Text(
                    "Apps",
                    style: TextStyle(
                        color: selectedSegment == "Apps"
                            ? Colors.black
                            : AppColors.white),
                  ),
                  "Actions": Text(
                    "Actions",
                    style: TextStyle(
                        color: selectedSegment == "Actions"
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
          Container(width: screenWidth, height: 1, color: AppColors.white)
        ],
      ),
    );
  }
}
