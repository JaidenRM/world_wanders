import 'package:flutter/material.dart';
import 'package:world_wanders/ui/utils/my_paths.dart';
import 'package:world_wanders/utils/constants/ui_constants.dart';

class GlobePainter extends CustomPainter {
  final Size _size;

  GlobePainter(Size size)
    : assert(size != null),
      _size = size;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0
      ..color = UiConstants.PRIMARY_COLOUR;
    final path = MyPaths.globe(_size);
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}