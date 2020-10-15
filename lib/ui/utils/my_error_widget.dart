import 'package:flutter/material.dart';
import 'package:world_wanders/utils/constants/ui_constants.dart';

class MyErrorWidget extends StatelessWidget {
  final String _error;

  MyErrorWidget(String errorMsg)
    : _error = errorMsg;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.all(UiConstants.PAD_BASE),
        child: Text(_error, style: UiConstants.TS_ERR,),
      )
    );
  }
}