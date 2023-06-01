import 'package:flutter/material.dart';
import 'package:subscribeme_mobile/commons/styles/color_palettes.dart';

part 'app_bar_theme.dart';
part 'tab_bar_theme.dart';
part 'text_theme.dart';
part 'button_theme.dart';

ThemeData appTheme = ThemeData(
  primaryColor: ColorPalettes.primary,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  scaffoldBackgroundColor: ColorPalettes.white,
  appBarTheme: _appBarTheme,
  tabBarTheme: _tabBarTheme,
  textTheme: _textTheme,
  fontFamily: "Poppins",
  textButtonTheme: _buttonTheme,
);


