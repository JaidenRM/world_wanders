import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_wanders/providers/validation/auth_provider.dart';
import 'package:world_wanders/ui/buttons/default_button.dart';
import 'package:world_wanders/ui/buttons/google_sign_in_button.dart';
import 'package:world_wanders/ui/screens/components/login_header.dart';
import 'package:world_wanders/ui/utils/my_background.dart';
import 'package:world_wanders/utils/constants/route_constants.dart';
import 'package:world_wanders/utils/constants/ui_constants.dart';
import 'package:world_wanders/utils/constants/validation_constants.dart';

class LoginForm extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: MyBackground(
        child: Padding(
          padding: EdgeInsets.all(UiConstants.PAD_BASE),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20.0),
                LoginHeader(),
                SizedBox(height: 20.0,),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    errorText: authProvider.email.error,
                    errorStyle: UiConstants.TS_ERR,
                    labelStyle: UiConstants.TS_DEFAULT,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (String val) => authProvider.changeEmail(val),
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    errorText: authProvider.password.error,
                    errorStyle: UiConstants.TS_ERR,
                    labelStyle: UiConstants.TS_DEFAULT,
                  ),
                  obscureText: true,
                  onChanged: (String val) => authProvider.changePassword(val),
                ),
                SizedBox(height: 20.0),
                DefaultButton(
                  child: Container(
                    alignment: Alignment.center,
                    width: mq.size.width * 0.75,
                    child: Text('Log In'),
                  ),
                  onPressed: authProvider.isValid ?
                    () => authProvider.signIn(AuthType.EmailPwd) :
                    null
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DefaultButton(
                      child: Text('Sign Up'),
                      onPressed: () => Navigator.of(context).pushNamed(RouteConstants.SIGNUP),
                    ),
                    GoogleSignInButton(
                      onPressed: () => authProvider.signIn(AuthType.Google),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                RichText(
                  text: TextSpan(
                    text: 'Forgot your password?',
                    style: UiConstants.TS_DEFAULT,
                    recognizer: TapGestureRecognizer()..onTap =
                      () => Navigator.of(context).pushNamed(RouteConstants.FORGOT_PWD)
                  ),
                ),
                SizedBox(height: 10.0,),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(authProvider.authenticated.error ?? '', style: UiConstants.TS_ERR,),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}