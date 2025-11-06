import 'package:flutter/material.dart';
import 'package:jlpt_jonggack/config/colors.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';

class AppFonts {
  static const gMarket = 'GMarket';
  static const japaneseFont = 'NotoSerifJP';
  static const descriptionFont = japaneseFont;
  // static const gMaretFont = 'GMarket';
  static const gMaretFont = 'GMarket';
}

class AppThemings {
  // static TextStyle darkTextStyle = const TextStyle(
  //   color: AppColors.whiteGrey,
  //   fontFamily: AppFonts.gMarket,
  // );

  // static final dartTheme = ThemeData.light(useMaterial3: true).copyWith(
  //   textTheme: ThemeData.dark().textTheme
  //       .apply(
  //         fontFamily: AppFonts.gMaretFont,
  //         bodyColor: Colors.white,
  //         displayColor: Colors.amber,
  //         decorationColor: Colors.white,
  //       )
  //       .copyWith(
  //         displayLarge: darkTextStyle,
  //         displayMedium: darkTextStyle,
  //         displaySmall: darkTextStyle,
  //         headlineLarge: darkTextStyle,
  //         headlineMedium: darkTextStyle,
  //         headlineSmall: darkTextStyle,
  //         titleLarge: darkTextStyle,
  //         titleMedium: darkTextStyle,
  //         titleSmall: darkTextStyle,
  //         bodyLarge: darkTextStyle,
  //         bodyMedium: darkTextStyle,
  //         bodySmall: darkTextStyle,
  //         labelLarge: darkTextStyle,
  //         labelMedium: darkTextStyle,
  //         labelSmall: darkTextStyle,
  //       ),
  //   primaryTextTheme: ThemeData.dark().textTheme.apply(
  //     fontFamily: AppFonts.gMarket,
  //   ),
  //   scaffoldBackgroundColor: AppColors.scaffoldBackground,
  //   appBarTheme: const AppBarTheme(
  //     color: Colors.transparent,
  //     titleTextStyle: TextStyle(
  //       color: Colors.black,
  //       fontWeight: FontWeight.bold,
  //       fontSize: 18,
  //       fontFamily: AppFonts.gMaretFont,
  //     ),
  //     iconTheme: IconThemeData(color: Colors.black),
  //   ),
  //   cardTheme: CardTheme(color: Colors.white),
  //   elevatedButtonTheme: ElevatedButtonThemeData(
  //     style: ElevatedButton.styleFrom(
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //     ),
  //   ),
  // );

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
