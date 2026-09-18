import 'package:flutter/material.dart';

import 'App_Colors.dart';
import 'App_Fonts.dart';

class AppThemes {
  static final ThemeData LightMode = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.WhiteColor,
    primaryColor: AppColors.WhiteColor,
    splashColor: AppColors.BlackColor,
    dividerColor: const Color(0xFFE0E0E0),
    cardColor: AppColors.WhiteColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.WhiteColor,
      iconTheme: IconThemeData(
        color: AppColors.BlackColor,
      ),
      centerTitle: true,
    ),
    textTheme: TextTheme(
      titleSmall: AppFonts.Bold16Black,
      titleMedium: AppFonts.Med12Gray,
      titleLarge: AppFonts.Med14Black,
      bodySmall: AppFonts.Med24Black,
      bodyMedium: AppFonts.Med20Black,
      bodyLarge: AppFonts.Bold18Black,
      headlineSmall: AppFonts.Bold24Black,
      labelLarge: AppFonts.Bold16Black,
    ),
  );

  static final ThemeData DarkMode = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.BlackColor,
    primaryColor: AppColors.BlackColor,
    splashColor: AppColors.WhiteColor,
    dividerColor: Colors.white,
    cardColor: AppColors.BlackColor,
    textTheme: TextTheme(
      titleSmall: AppFonts.Bold16White,
      titleMedium: AppFonts.Med12Gray,
      titleLarge: AppFonts.Med14White,
      bodySmall: AppFonts.Med24White,
      bodyMedium: AppFonts.Med20White,
      bodyLarge: AppFonts.Bold18White,
      headlineSmall: AppFonts.Bold20White,
      labelLarge: AppFonts.Bold16White,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.BlackColor,
      iconTheme: IconThemeData(
        color: AppColors.WhiteColor,
      ),
      centerTitle: true,
    ),
  );
}