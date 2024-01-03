import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolcg_qr_code/res/colors.dart';

final appTheme = ThemeData(
  // colorScheme: ColorScheme.fromSeed(seedColor: colorPrimary),
  appBarTheme: AppBarTheme(
    backgroundColor: colorPrimary,
  ),
  useMaterial3: true,
);

const TextStyle _fontDefault = TextStyle(
  // fontFamily: _fontFamily,
  fontWeight: FontWeight.normal,
  height: 1,
);

extension TextStyleExtension on TextStyle {
  // Font Family
  TextStyle get normalItalic => copyWith(
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.italic,
      );
  TextStyle get medium => copyWith(fontWeight: FontWeight.w500);
  TextStyle get semiBold => copyWith(fontWeight: FontWeight.w600);
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);

  // Text Color
  TextStyle get tColorPrimary => copyWith(color: colorPrimary);
  TextStyle get tColorWhite => copyWith(color: Colors.white);
  TextStyle withColor(Color? color) => copyWith(color: color);

  // Text font size
  TextStyle withFsize(double size) => copyWith(fontSize: size);
  TextStyle get h13 => copyWith(height: 1.333333333);
  TextStyle get h14 => copyWith(height: 1.42857);
  TextStyle get h16 => copyWith(height: 1.6);

  // Text Decoration
  TextStyle get underLine => copyWith(decoration: TextDecoration.underline);

  TextStyle lSpacing(double space) => copyWith(letterSpacing: space);
  TextStyle get lSpacing04 => copyWith(letterSpacing: 0.4);

  TextStyle shadow(List<Shadow> shadows) => copyWith(shadows: shadows);
}

// Create Sizes
TextStyle get text8 => _fontDefault.copyWith(fontSize: 8.sp);
TextStyle get text10 => _fontDefault.copyWith(fontSize: 10.sp);
TextStyle get text11 => _fontDefault.copyWith(fontSize: 11.sp);
TextStyle get text12 => _fontDefault.copyWith(fontSize: 12.sp);
TextStyle get text13 => _fontDefault.copyWith(fontSize: 13.sp);
TextStyle get text13_5 => _fontDefault.copyWith(fontSize: 13.5.sp);
TextStyle get text14 => _fontDefault.copyWith(fontSize: 14.sp);
TextStyle get text15 => _fontDefault.copyWith(fontSize: 15.sp);
TextStyle get text16 => _fontDefault.copyWith(fontSize: 16.sp);
TextStyle get text18 => _fontDefault.copyWith(fontSize: 18.sp);
TextStyle get text20 => _fontDefault.copyWith(fontSize: 20.sp);
TextStyle get text22 => _fontDefault.copyWith(fontSize: 22.sp);
TextStyle get text23 => _fontDefault.copyWith(fontSize: 23.sp);
TextStyle get text24 => _fontDefault.copyWith(fontSize: 24.sp);
TextStyle get text28 => _fontDefault.copyWith(fontSize: 28.sp);
TextStyle get text40 => _fontDefault.copyWith(fontSize: 40.sp);