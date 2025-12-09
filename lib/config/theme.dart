import 'package:flutter/material.dart';
import 'package:jlpt_jonggack/config/colors.dart';

class AppFonts {
  static const gMarket = 'GMarket';
  static const japaneseFont = 'NotoSerifJP';
  static const descriptionFont = japaneseFont;
  // static const gMaretFont = 'GMarket';
  static const gMaretFont = 'GMarket';
}

class AppThemings {
  static final darkTheme = ThemeData.dark().copyWith(
    textTheme: ThemeData.dark().textTheme.apply(fontFamily: AppFonts.gMarket),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: AppColors.scaffoldBackground,
    ),

    appBarTheme: AppBarTheme(
      color: Colors.transparent,
      scrolledUnderElevation: 0.0,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,

        fontFamily: AppFonts.gMarket,
      ),
    ),
    cardTheme: CardTheme(color: AppColors.scaffoldBackground),
  );

  static final lightTheme2 = ThemeData.light().copyWith(
    textTheme: ThemeData.light().textTheme.apply(fontFamily: AppFonts.gMarket),
    inputDecorationTheme: InputDecorationTheme(fillColor: Colors.white),
    scaffoldBackgroundColor: Colors.grey.shade200,
    primaryTextTheme: ThemeData.light().textTheme.apply(
      fontFamily: AppFonts.gMarket,
    ),
    appBarTheme: AppBarTheme(
      color: Colors.transparent,
      scrolledUnderElevation: 0.0,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontFamily: AppFonts.gMarket,
      ),
    ),
  );

  static TextStyle lightTextStyle = TextStyle(
    color: AppColors.darkGrey,
    fontFamily: AppFonts.gMaretFont,
  );

  static final lightTheme = ThemeData.light(useMaterial3: true).copyWith(
    textTheme: ThemeData.light().textTheme
        .apply(
          fontFamily: AppFonts.gMaretFont,
          bodyColor: Colors.white,
          displayColor: Colors.amber,
          decorationColor: Colors.white,
        )
        .copyWith(
          displayLarge: lightTextStyle,
          displayMedium: lightTextStyle,
          displaySmall: lightTextStyle,
          headlineLarge: lightTextStyle,
          headlineMedium: lightTextStyle,
          headlineSmall: lightTextStyle,
          titleLarge: lightTextStyle,
          titleMedium: lightTextStyle,
          titleSmall: lightTextStyle,
          bodyLarge: lightTextStyle,
          bodyMedium: lightTextStyle,
          bodySmall: lightTextStyle,
          labelLarge: lightTextStyle,
          labelMedium: lightTextStyle,
          labelSmall: lightTextStyle,
        ),
    primaryTextTheme: ThemeData.light().textTheme.apply(
      fontFamily: AppFonts.gMarket,
    ),
    scaffoldBackgroundColor: Colors.grey.shade200,
    appBarTheme: AppBarTheme(
      color: Colors.transparent,
      scrolledUnderElevation: 0.0,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontFamily: AppFonts.gMarket,
      ),
      iconTheme: IconThemeData(color: Colors.black),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.white,
      shape: CircleBorder(),
    ),
  );
}
