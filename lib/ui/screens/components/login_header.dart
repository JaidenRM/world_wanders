import 'package:flutter/cupertino.dart';
import 'package:world_wanders/ui/utils/clippers/circle_clipper.dart';
import 'package:world_wanders/utils/constants/ui_constants.dart';

class LoginHeader extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    return Container(
      height: mq.size.height * 0.35,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Opacity(
            opacity: 0.7,
            child: ClipPath(
              clipper: CircleClipper(),
              child: Image.asset(
                'lib/assets/images/boat_mountains_sm.jpg'
              ),
            ),
          ),
          Column(
            children: [
              Text('World', style: TextStyle(fontSize: UiConstants.FONT_H2),),
              Text('Wanders', style: TextStyle(fontSize: UiConstants.FONT_H2),),
            ],
          )
        ],
      ),
    );
  }
}