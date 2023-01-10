import 'package:flutter/material.dart';

const Color greenClr = Color(0xff6baa75);
const Color redClr = Color(0xFFF34213);
const Color marineClr = Color(0xFF384E77);

const Color bluishClr = Color(0xFF4e5ae8);
const Color yellowClr = Color(0xFFFFB746);
const Color pinkClr = Color(0xFFff4667);
const Color white = Colors.white;
const primaryClr = bluishClr;
const Color darkGreyClr = Color(0xFF1e1e1e);
const Color lightGreyClr = Color(0xFF2e2e2e);

class Themes {
  static final light= ThemeData(
  primarySwatch: Colors.red,
  brightness: Brightness.light,
  );

  static final dark= ThemeData(
  primaryColor: Colors.green,
  brightness: Brightness.dark,
  );
}