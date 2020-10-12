import 'package:flutter/material.dart';

class MyErrorWidget extends StatelessWidget {
  final String _error;

  MyErrorWidget(String errorMsg)
    : _error = errorMsg;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(_error),
    );
  }
}