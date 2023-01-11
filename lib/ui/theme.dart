import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

const Color greenClr = Color(0xff6baa75);
const Color redClr = Color(0xFFF34213);
const Color marineClr = Color(0xFF384E77);

const bluishClr = Colors.indigo;
const yellowClr = Colors.amber;
const pinkClr = Colors.pink;
const white = Colors.white;
const darkGreyClr = Colors.black;
const lightGreyClr = Colors.grey;

const primaryClr = bluishClr;


class Themes {
  static final light= ThemeData(
    backgroundColor: Colors.white,
  colorSchemeSeed: bluishClr,
  brightness: Brightness.light,
  );

  static final dark= ThemeData(
    backgroundColor: darkGreyClr,
  colorSchemeSeed: darkGreyClr,
  brightness: Brightness.dark,
  );
}


//tole je "public method", lahka kličemo kjerkoli v projektu
TextStyle get subHeadingStyle{ // style za on prvi row na vrhu
  return GoogleFonts.lato (
    textStyle: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Get.isDarkMode ? Colors.grey[400] : Colors.grey,
    ),
  );
}
TextStyle get headingStyle{ // drug styling
  return GoogleFonts.lato (
    textStyle: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Get.isDarkMode ? Colors.white : Colors.black,
    ),
  );
}
TextStyle get titleStyle{ // tretji styling
  return GoogleFonts.lato (
    textStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Get.isDarkMode ? Colors.white : Colors.black,
    ),
  );
}

TextStyle get subTitleStyle{ // cetrti styling
  return GoogleFonts.lato (
    textStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Get.isDarkMode ? Colors.grey[100] : Colors.grey[600],
    ),
  );
}