import 'package:flutter/material.dart';
import 'package:pass/src/config/dimens.dart';

class ThemeClass {
  // ! colors assigning

  static final Color orangeColor = Color(0xFFF94B26);

  static final Color orangeColor1 = Color(0xFFFD6B22);

  static final Color redColor = Color(0xFFFD5E4D);
  static final Color skyBlueColor = Color(0xFF1492E6);
  static final Color creamColor = Color(0xFFFEDED4);
  static final Color lightGreyColor = Color(0xFFF2F2F2);
  static final Color greyColor = Color(0xFF707070);
  static final Color greyMediumColor = Color(0xFFBBBBBB);

  static final Color greenColor = Color(0xFF4EBF66);

  static final themeData = ThemeData(
    // primaryColor:  ThemeClass.orangeColor,
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
    fontFamily: 'Gilroy',
    accentColor: ThemeClass.orangeColor,
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: ThemeClass.orangeColor,
        ),
        borderRadius: BorderRadius.circular(
          Dimens.outlineBorderRadius,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ThemeClass.orangeColor),
        borderRadius: BorderRadius.circular(
          Dimens.outlineBorderRadius,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          Dimens.outlineBorderRadius,
        ),
        borderSide: BorderSide(color: ThemeClass.orangeColor),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ThemeClass.orangeColor),
        borderRadius: BorderRadius.circular(
          Dimens.outlineBorderRadius,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ThemeClass.orangeColor),
        borderRadius: BorderRadius.circular(
          Dimens.outlineBorderRadius,
        ),
      ),
    ),
  );
}
