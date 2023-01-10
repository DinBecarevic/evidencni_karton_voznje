import 'package:flutter/material.dart';

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
  colorSchemeSeed: bluishClr,
  brightness: Brightness.light,
  );

  static final dark= ThemeData(
  colorSchemeSeed: darkGreyClr,
  brightness: Brightness.dark,
  );
}