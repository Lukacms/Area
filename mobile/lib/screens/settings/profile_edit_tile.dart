import 'package:flutter/material.dart';
import 'package:mobile/main.dart';
import 'package:mobile/theme/style.dart';

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
