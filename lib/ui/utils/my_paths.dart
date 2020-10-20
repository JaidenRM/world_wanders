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

  static Path percentageRect(Size size, double percToCover) {
    final path = Path();
    final paddingOffset = size.width * 0.25;
    path.moveTo(0, 0);
    path.lineTo((size.width - paddingOffset * 2) * percToCover + paddingOffset, 0);
    path.lineTo((size.width - paddingOffset * 2) * percToCover + paddingOffset, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 0);

    path.close();
    return path;
  }
}