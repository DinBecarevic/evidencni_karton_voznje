import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

const primaryClr = greenClr;

const Color greenClr = Color(0xff6baa75);
const Color marineClr = Color(0xFF16425B);
const Color ylwClr = Color(0xff403d39);
const Color redClr = Color(0xFFA23B72);

const bluishClr = greenClr;
const yellowClr = marineClr;
const pinkClr = ylwClr;

//const bluishClr = Colors.indigo;
//const yellowClr = Colors.amber;
//const pinkClr = Colors.pink;


const white = Colors.white;
const darkGreyClr = Colors.black;
const Color darkGreyClr2 = Color(0xFF121212);
const lightGreyClr = Colors.grey;

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
  return GoogleFonts.rubik (
    textStyle: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Get.isDarkMode ? Colors.grey[400] : Colors.grey,
    ),
  );
}
TextStyle get headingStyle{ // drug styling
  return GoogleFonts.rubik (
    textStyle: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Get.isDarkMode ? Colors.white : Colors.black,
    ),
  );
}
TextStyle get titleStyle{ // tretji styling
  return GoogleFonts.rubik (
    textStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Get.isDarkMode ? Colors.white : Colors.black,
    ),
  );
}

TextStyle get subTitleStyle{ // cetrti styling
  return GoogleFonts.rubik (
    textStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Get.isDarkMode ? Colors.grey[100] : Colors.grey[600],
    ),
  );
}