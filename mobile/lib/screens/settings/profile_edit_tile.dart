import 'package:flutter/material.dart';
import 'package:mobile/main.dart';
import 'package:mobile/theme/style.dart';

// This is the ProfileEditTile widget, which displays a single editable field in the 
// user's profile. It takes in a Function to call when the tile is tapped, a String 
// for the tile's label, and a String for the tile's value.

// The widget has a Padding widget as its parent, which adds some padding 
// to the tile. The Padding widget contains a GestureDetector widget, which allows
//  the user to tap on the tile to edit its value. The GestureDetector widget has a 
//  Row widget as its child, which contains the tile's label and value.

// When the user taps on the tile, the specified onTap function is called.

class ProfileEditTile extends StatelessWidget {
  final Function onTap;
  final String text;
  final String value;
  const ProfileEditTile({
    super.key,
    required this.onTap,
    required this.text,
    this.value = '',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: blockHeight),
      child: GestureDetector(
        onTap: () => onTap(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 20,
                color: AppColors.white,
              ),
            ),
            Row(
              children: [
                Text(
                  value.length > 15 ? '${value.substring(0, 15)}...' : value,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                SizedBox(width: blockHeight),
                Icon(Icons.chevron_right_rounded, color: AppColors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
