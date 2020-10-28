import 'package:flutter/material.dart';

class IconRangeRating extends StatefulWidget {
  final int outOf;
  final IconData icon;
  final int start, end;
  final Function(int, int) onChanged;

  IconRangeRating(this.outOf, this.icon, {
    this.start = 0, this.end = 0, this.onChanged
  })
    : assert(outOf != null && icon != null
      && start != null && end != null);

  @override
  State<StatefulWidget> createState() => _IconState(outOf, icon, start, end, onChanged);
}

class _IconState extends State<IconRangeRating> {
  int outOf, start, end;
  IconData icon;
  bool useStartNext = false;
  Function(int, int) onChanged;

  _IconState(this.outOf, this.icon, this.start, this.end, this.onChanged);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _buildRow(),
    );
  }

  void updateRating(int idx) {
    setState(() {
      if(start == 0) {
        start = idx;
        end = idx;
        useStartNext = false;
      }
      else if(idx < start || idx == end) {
        start = idx;
        useStartNext = false;
      }
      else if(idx > end || idx == start) {
        end = idx;
        useStartNext = true;
      }
      else if(useStartNext) {
        start = idx;
        useStartNext = false;
      }
      else {
        end = idx;
        useStartNext = true;
      }

      if(onChanged != null)
        onChanged(start, end);
    });
  }

  List<Widget> _buildRow() {
    List<Widget> widgets = [];
    bool isActive = false;

    for(int i = 0; i < outOf; i++) {
      if(i + 1 == start)
        isActive = true;

      widgets.add(IconButton(
        icon: Icon(icon, color: isActive ? Colors.black : Colors.grey),
        onPressed: () {
          updateRating(i + 1);
        },
      ));

      if(i + 1 == end)
        isActive = false;
    }

    return widgets;
  }
}