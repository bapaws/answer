import 'package:flutter/material.dart';

class AppTheme {
  late final ThemeData light = _getTheme(Brightness.light);
  late final ThemeData dark = _getTheme(Brightness.dark);

  static const lightPrimaryColor = Color(0xFF97EB68);
  static const darkPrimaryColor = Color(0xFF00B859);

  Color _getPrimaryColor(Brightness brightness) =>
      brightness == Brightness.light ? lightPrimaryColor : darkPrimaryColor;

  Color _getScaffoldBackgroundColor(Brightness brightness) =>
      brightness == Brightness.light
          ? const Color(0xFFEDEDED)
          : const Color(0xFF111111);

  Color _getUnselectedWidgetColor(Brightness brightness) =>
      brightness == Brightness.light
          ? const Color(0xFFFFFFFF)
          : const Color(0xFF2D2C2C);

  ElevatedButtonThemeData _getElevatedButtonTheme(Brightness brightness) =>
      ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            _getPrimaryColor(brightness),
          ),
          foregroundColor: MaterialStateProperty.all(
            Colors.white,
          ),
          splashFactory: NoSplash.splashFactory,
          shadowColor: MaterialStateProperty.all(
            Colors.transparent,
          ),
          textStyle: MaterialStateProperty.all(
            const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          padding: MaterialStateProperty.all(
            const EdgeInsets.all(4),
          ),
        ),
      );

  OutlinedButtonThemeData _getOutlineButtonTheme(Brightness brightness) =>
      OutlinedButtonThemeData(
        style: ButtonStyle(
          splashFactory: NoSplash.splashFactory,
          shadowColor: MaterialStateProperty.all(
            Colors.transparent,
          ),
          iconColor: MaterialStateProperty.all(
            brightness == Brightness.light ? Colors.black : Colors.white,
          ),
          textStyle: MaterialStateProperty.all(
            TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color:
                  brightness == Brightness.light ? Colors.black : Colors.white,
            ),
          ),
          padding: MaterialStateProperty.all(
            const EdgeInsets.all(4),
          ),
        ),
      );

  TextButtonThemeData _getTextButtonTheme(Brightness brightness) =>
      TextButtonThemeData(
        style: ButtonStyle(
          splashFactory: NoSplash.splashFactory,
          overlayColor: MaterialStateProperty.all(
            Colors.transparent,
          ),
          foregroundColor: MaterialStateProperty.all(
            _getPrimaryColor(brightness),
          ),
        ),
      );

  ButtonThemeData _getButtonTheme(Brightness brightness) =>
      const ButtonThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      );

  AppBarTheme _getAppBarTheme(Brightness brightness, TextTheme textTheme) =>
      AppBarTheme(
        backgroundColor: brightness == Brightness.light
            ? const Color(0xFFEDEDED)
            : const Color(0xFF111111),
        foregroundColor: brightness == Brightness.light
            ? const Color(0xFF181818)
            : const Color(0xFFD1D1D1),
        // toolbarHeight: AppValues.appBarHeight,
        elevation: 0,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: brightness == Brightness.light
              ? const Color(0xFF181818)
              : const Color(0xFFCBCBCB),
        ),
        toolbarTextStyle: textTheme.titleMedium,
      );

  BottomNavigationBarThemeData _getBottomNavigationBarTheme(
          Brightness brightness) =>
      BottomNavigationBarThemeData(
        backgroundColor: brightness == Brightness.light
            ? const Color(0xF2F6F6F6)
            : const Color(0xF21C1C1C),
        selectedItemColor: _getPrimaryColor(brightness),
        unselectedItemColor: brightness == Brightness.light
            ? const Color(0xFF181818)
            : const Color(0xFFD1D1D1),
      );

  IconThemeData _getIconTheme(Brightness brightness) => IconThemeData(
        color: brightness == Brightness.light
            ? const Color(0xFF181818)
            : const Color(0xFFCBCBCB),
      );

  ThemeData _getTheme(Brightness brightness) {
    final themeData =
        brightness == Brightness.light ? ThemeData.light() : ThemeData.dark();

    return themeData.copyWith(
      primaryColor: _getPrimaryColor(brightness),
      primaryColorLight: _getPrimaryColor(Brightness.light),
      primaryColorDark: _getPrimaryColor(Brightness.dark),
      primaryTextTheme: themeData.textTheme.apply(
        displayColor: _getPrimaryColor(brightness),
        bodyColor: _getPrimaryColor(brightness),
      ),
      unselectedWidgetColor: _getUnselectedWidgetColor(brightness),
      scaffoldBackgroundColor: _getScaffoldBackgroundColor(brightness),
      splashFactory: NoSplash.splashFactory,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      outlinedButtonTheme: _getOutlineButtonTheme(brightness),
      elevatedButtonTheme: _getElevatedButtonTheme(brightness),
      textButtonTheme: _getTextButtonTheme(brightness),
      buttonTheme: _getButtonTheme(brightness),
      iconTheme: _getIconTheme(brightness),
      appBarTheme: _getAppBarTheme(brightness, themeData.textTheme),
      bottomNavigationBarTheme: _getBottomNavigationBarTheme(brightness),
    );
  }
}
