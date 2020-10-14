import 'package:flutter/material.dart';
import 'package:world_wanders/utils/constants/ui_constants.dart';

class MySuccessWidget extends StatelessWidget {
  final String _msg;

  MySuccessWidget(String msg)
    : _msg = msg;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.all(UiConstants.PAD_BASE),
        child: Text(_msg, style: UiConstants.TS_SUCCESS,),
      )
    );
  }
}