import 'package:expense_tracker/theme/color_scheme.dart';
import 'package:flutter/material.dart';

var theme = ThemeData().copyWith(
    colorScheme: kColorScheme,
    appBarTheme: AppBarTheme().copyWith(backgroundColor: kColorScheme.onPrimaryContainer, foregroundColor: kColorScheme.primaryContainer),
    cardTheme:
        const CardTheme().copyWith(color: kColorScheme.secondaryContainer, margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)).data,
    elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(backgroundColor: kColorScheme.primaryContainer)));

var darkTheme = ThemeData.dark().copyWith(
    colorScheme: kDarkColorScheme,
    appBarTheme: AppBarTheme().copyWith(backgroundColor: kColorScheme.onPrimaryContainer, foregroundColor: kColorScheme.primaryContainer),
    cardTheme:
        const CardTheme().copyWith(color: kColorScheme.secondaryContainer, margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)).data,
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(backgroundColor: kDarkColorScheme.primaryContainer, foregroundColor: kDarkColorScheme.secondaryContainer)));
