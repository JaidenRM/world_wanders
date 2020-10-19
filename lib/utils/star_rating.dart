import 'package:flutter/material.dart';
import 'package:world_wanders/ui/utils/clippers/percentage_clipper.dart';

class StarRating extends StatelessWidget {
  final double rating;
  final int outOf;

  StarRating(this.rating, this.outOf)
    : assert(rating != null && outOf != null);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          children: _buildRowOf(Icons.star_border, outOf.toDouble()),
        ),
        Row(
          children: _buildRowOf(Icons.star, rating),
        ),
      ],
    );
  }

  List<Widget> _buildRowOf(IconData icon, double amount) {
    List<Widget> widgets = [];
    double remaining = amount;

    for(int i = 0; i <= amount-1; i++) {
      widgets.add(Icon(icon));
      remaining--;
    }

    if(remaining > 0) {
      widgets.add(
        ClipPath(
          clipper: PercentageClipper(remaining),
          child: Icon(icon),
        )
      );
    }

    return widgets;
  }
}