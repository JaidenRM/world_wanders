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

  //0xFF[...] - 0x signify hex, ff = 255 for full opacity, [...] = hex code
  static const Color SECONDARY_COLOUR = Color(0xFF88CCF1); //light cornflower blue
  static const Color PRIMARY_COLOUR = Color(0xFF3587A4); //blue munsell
  static const Color TERTIARY_COLOUR = Color(0xFFC1DFF0); //columbia blue
}