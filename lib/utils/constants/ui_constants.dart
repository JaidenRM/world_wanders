import 'package:flutter/material.dart';

enum UiState {
  Ready,
  Loading,
  Completed,
  Error
}

class UiConstants {
  static const double FONT_H1 = 48;
  static const double FONT_H2 = 36;
  static const double FONT_H3 = 24;
  static const double FONT_BASE = 16;
  static const double PAD_BASE = 10.0;

  static const String FONT_FAM_DEFAULT = 'Comfortaa';
  static const String FONT_FAM_HDR = 'SansitaSwashed';

  static const Size SIZE_LOGO = Size(320, 240); //320 is smallest phone width..

  //0xFF[...] - 0x signify hex, ff = 255 for full opacity, [...] = hex code
  static const Color SECONDARY_COLOUR = Color(0xFF88CCF1); //light cornflower blue
  static const Color PRIMARY_COLOUR = Color(0xFF3587A4); //blue munsell
  static const Color TERTIARY_COLOUR = Color(0xFFC1DFF0); //columbia blue
  static const Color ERR_COLOUR = Colors.red;
  static const Color SUCCESS_COLOUR = Colors.green;

  static const TextStyle TS_HDR = TextStyle(
    fontSize: UiConstants.FONT_H2,
    fontFamily: FONT_FAM_HDR,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle TS_ERR = TextStyle(
    fontWeight: FontWeight.bold,
    color: ERR_COLOUR,
  );
  static const TextStyle TS_SUCCESS = TextStyle(
    fontWeight: FontWeight.bold,
    color: SUCCESS_COLOUR,
  );
  static const TextStyle TS_DEFAULT = TextStyle(
    color: PRIMARY_COLOUR,
    fontFamily: FONT_FAM_DEFAULT,
    fontSize: FONT_BASE,
  );
}