import 'package:flutter/cupertino.dart';
import 'package:world_wanders/ui/utils/clippers/globe_clipper.dart';
import 'package:world_wanders/ui/utils/painters/globe_painter.dart';
import 'package:world_wanders/utils/constants/ui_constants.dart';

class LoginHeader extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final logoSize = UiConstants.SIZE_LOGO;

    return Container(
      height: logoSize.height,//mq.size.height * 0.35,
      width: logoSize.width, //mq.size.width * 0.8,
      child: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          Opacity(
            opacity: 0.7,
            child: ClipPath(
              clipper: GlobeClipper(logoSize),
              child: Image.asset(
                'lib/assets/images/boat_mountains_sm.jpg',
                fit: BoxFit.fill,
              ),
            ),
          ),
          Opacity(
            opacity: 0.15,
            child: ClipPath(
              clipper: GlobeClipper(logoSize),
              child: Image.asset(
                'lib/assets/images/globe_cropped.png',
                fit: BoxFit.fill,
              ),
            ),
          ),
          CustomPaint(
            painter: GlobePainter(logoSize),
            child: Container(),
          ),
          Column(
            children: [
              SizedBox(height: 10.0),
              Text('World', style: UiConstants.TS_HDR),
              Text('Wanders', style: UiConstants.TS_HDR),
            ],
          ),
        ],
      ),
    );
  }
}