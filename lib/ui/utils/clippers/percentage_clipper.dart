import 'package:flutter/cupertino.dart';
import 'package:world_wanders/ui/utils/my_paths.dart';

class PercentageClipper extends CustomClipper<Path> {
  final double _percentage;

  PercentageClipper(double percToCover)
    : assert(percToCover != null),
      _percentage = percToCover;
  
  @override
  getClip(Size size) {
    return MyPaths.percentageRect(size, _percentage);
  }
  
  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return false;
  }

}