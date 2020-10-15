import 'package:flutter/material.dart';

class MyLoadingWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      child: CircularProgressIndicator(),
    );
  }
}