import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:world_wanders/utils/constants/ui_constants.dart';

class DefaultButton extends StatelessWidget {
  final Widget _child;
  final Function _onPressed;
  final double _width;

  DefaultButton({ Key key, Widget child, Function onPressed, double width })
    : _child = child,
      _onPressed = onPressed,
      _width = width,
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: _width != null && _width > 88.0 ? _width : 88.0,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0)
        ),
        onPressed: _onPressed,
        child: _child,
        padding: EdgeInsets.symmetric(vertical: 12.5, horizontal: 35.0),
        color: UiConstants.PRIMARY_COLOUR,
        textColor: UiConstants.TERTIARY_COLOUR,
        hoverColor: UiConstants.SECONDARY_COLOUR,
        highlightColor: UiConstants.SECONDARY_COLOUR,
        disabledColor: UiConstants.TERTIARY_COLOUR,
        disabledTextColor: UiConstants.PRIMARY_COLOUR,
      ),
    );
  }
}