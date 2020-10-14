import 'package:flutter/cupertino.dart';
import 'package:world_wanders/ui/utils/my_paths.dart';

class GlobeClipper extends CustomClipper<Path> {
  final Size _size;

  GlobeClipper(Size size)
    : assert(size != null),
      _size = size;
  
  @override
  getClip(Size size) {
    return MyPaths.globe(_size);
  }
  
  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return false;
  }

}