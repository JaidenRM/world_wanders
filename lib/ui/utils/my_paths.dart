import 'package:flutter/material.dart';

class MyPaths {

  static Path globe(Size size) {
    final path = Path();
    
    path.moveTo(0, size.height * 0.5);
    path.arcToPoint(
      Offset(size.width, size.height * 0.5),
      radius: Radius.elliptical(1, 0.7),
      clockwise: false
    );
    path.arcToPoint(
      Offset(0, size.height * 0.5),
      radius: Radius.elliptical(1, 0.7),
      clockwise: false
    );
    path.close();

    return path;
  }
}