import 'package:flutter/cupertino.dart';

class MyBackground extends StatelessWidget {
  final Widget _child;
  final AlignmentGeometry _alignment;

  MyBackground({ Key key, @required Widget child, AlignmentGeometry alignment = Alignment.center })
    : assert(child != null),
      _child = child,
      _alignment = alignment,
      super(key: key);

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final isPortrait = mq.orientation == Orientation.portrait;
    return Container(
      height: mq.size.height,
      child: Stack(
        alignment: _alignment,
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: Opacity(
              opacity: 0.5,
              child: Image.asset(
                'lib/assets/images/watercolor_bg.jpg',
                height: isPortrait ? mq.size.height : null,
                width: isPortrait ? null : mq.size.width,
              )
            ),
          ),
          _child,
        ],
      ),
    );
  }
}