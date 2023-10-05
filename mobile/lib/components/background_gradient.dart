import 'package:flutter/material.dart';
import 'package:mobile/theme/style.dart';

class BackgroundGradient extends StatelessWidget {
  const BackgroundGradient({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.blue.withOpacity(0.8),
              AppColors.greyBlue.withOpacity(0.8),
              AppColors.purple.withOpacity(0.8),
              AppColors.grenat.withOpacity(0.8)
            ],
          ),
        ),
      ),
    );
  }
}
