part of 'themes.dart';

const _tabBarTheme = TabBarTheme(
  labelStyle: TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.bold,
  ),
  unselectedLabelStyle: TextStyle(
    fontSize: 12.0,
  ),
  labelPadding: EdgeInsets.zero,
  indicator: UnderlineTabIndicator(
    insets: EdgeInsets.symmetric(horizontal: 16.0),
    borderSide: BorderSide(
      width: 4,
      color: ColorPalettes.primary,
    ),
  ),
);