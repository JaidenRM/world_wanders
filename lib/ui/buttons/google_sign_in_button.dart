import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GoogleSignInButton extends StatelessWidget {
  final Function _onPressed;

  GoogleSignInButton({ Key key, Function onPressed })
    : _onPressed = onPressed,
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0)
      ),
      padding: EdgeInsets.symmetric(vertical: 7.5, horizontal: 10.0),
      icon: Icon(FontAwesomeIcons.google, color: Colors.white), 
      label: Text('Sign in with Google', style: TextStyle(color: Colors.white)),
      color: Colors.redAccent,
      onPressed: _onPressed,
    );
  }
}