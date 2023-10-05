import 'package:flutter/material.dart';

Color hexToColor(String hexString) {
  final buffer = StringBuffer();
  if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
  buffer.write(hexString.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}

class AppColors {
  static final darkBlue = hexToColor('#1B1A2A');
  static final blue = hexToColor('#304286');
  static final greyBlue = hexToColor('#252C42');
  static final purple = hexToColor('#45235B');
  static final grenat = hexToColor('#743252');
  static final white = hexToColor('#FFFAFB');
  static const spotifyGreen = Color.fromRGBO(30, 215, 96, 1);
}

ThemeData appTheme() {
  return ThemeData(
    fontFamily: 'Roboto',
    useMaterial3: true,
    textSelectionTheme: TextSelectionThemeData(cursorColor: AppColors.darkBlue),
  );
}
