import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_wanders/providers/validation/auth_provider.dart';
import 'package:world_wanders/utils/constants/route_constants.dart';
import 'package:world_wanders/utils/constants/ui_constants.dart';
import 'package:world_wanders/utils/constants/validation_constants.dart';

class LoginForm extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Center(
              child: Text('World Wanders', style: TextStyle(fontSize: UiConstants.FONT_H2)),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                errorText: authProvider.email.error,
              ),
              keyboardType: TextInputType.emailAddress,
              onChanged: (String val) => authProvider.changeEmail(val),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Password',
                errorText: authProvider.password.error,
              ),
              obscureText: true,
              onChanged: (String val) => authProvider.changePassword(val),
            ),
            RaisedButton(
              child: Text('Log In'),
              onPressed: authProvider.isValid ?
                null :
                () => authProvider.signIn(AuthType.EmailPwd)
            ),
            Row(
              children: [
                RaisedButton(
                  child: Text('Sign Up'),
                  onPressed: () => Navigator.of(context).pushNamed(RouteConstants.SIGNUP),
                ),
                RaisedButton(
                  child: Text('Google Sign In'),
                  onPressed: () => authProvider.signIn(AuthType.Google),
                ),
              ],
            ),
            ErrorWidget(authProvider.authenticated.error), //look into this
          ],
        ),
      ),
    );
  }

}