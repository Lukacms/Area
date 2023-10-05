import 'package:flutter/material.dart';
import 'package:mobile/theme/style.dart';

class SearchField extends StatefulWidget {
  final TextEditingController searchController;
  final String hintText;
  final double padding;
  final bool horizontal;
  const SearchField({
    super.key,
    required this.searchController,
    this.hintText = "Recherche",
    required this.padding,
    this.horizontal = true,
  });

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.horizontal
          ? EdgeInsets.symmetric(horizontal: widget.padding)
          : EdgeInsets.only(left: widget.padding),
      child: TextField(
        controller: widget.searchController,
        style: TextStyle(
          color: AppColors.white,
        ),
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
    );
  }
}
