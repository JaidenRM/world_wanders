import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: MyBackground(
        child: Padding(
          padding: EdgeInsets.all(10.0),
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
                SizedBox(height: 20.0),
                DefaultButton(
                  child: Text('Log In'),
                  onPressed: authProvider.isValid ?
                    () => authProvider.signIn(AuthType.EmailPwd) :
                    null
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.spaceBetween,
                  buttonPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
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
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(authProvider.authenticated.error ?? '', style: TextStyle(color: Colors.red),),
                ), //look into this
              ],
            ),
          ),
        ),
      ),
    );
  }

}