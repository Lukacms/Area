import 'package:mobile/theme/style.dart';
import 'package:flutter/material.dart';

class BackgroundCircles extends StatelessWidget {
  const BackgroundCircles({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: -275,
      top: -150,
      child: Opacity(
        opacity: 0.7,
        child: Column(
          verticalDirection: VerticalDirection.up,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  color: AppColors.grenat,
                  borderRadius: BorderRadius.circular(200),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.grenat,
                      blurRadius: 70,
                      spreadRadius: 150,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 200),
              child: Container(
                height: 100,
                width: 150,
                decoration: BoxDecoration(
                  color: AppColors.purple,
                  borderRadius: BorderRadius.circular(200),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.purple,
                      blurRadius: 70,
                      spreadRadius: 150,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: Container(
                height: 100,
                width: 150,
                decoration: BoxDecoration(
                  color: AppColors.greyBlue,
                  borderRadius: BorderRadius.circular(200),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.greyBlue,
                      blurRadius: 70,
                      spreadRadius: 150,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: Container(
                height: 250,
                width: 250,
                decoration: BoxDecoration(
                  color: AppColors.blue,
                  borderRadius: BorderRadius.circular(200),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.blue,
                      blurRadius: 70,
                      spreadRadius: 150,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
