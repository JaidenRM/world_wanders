import 'package:flutter/cupertino.dart';

class CircleClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
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
  
  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return false;
  }

}