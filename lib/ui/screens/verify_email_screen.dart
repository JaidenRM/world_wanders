import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_wanders/providers/user_provider.dart';
import 'package:world_wanders/providers/validation/auth_provider.dart';
import 'package:world_wanders/ui/buttons/default_button.dart';
import 'package:world_wanders/ui/utils/my_background.dart';
import 'package:world_wanders/ui/utils/my_error_widget.dart';
import 'package:world_wanders/ui/utils/my_loading_widget.dart';
import 'package:world_wanders/utils/constants/ui_constants.dart';

class VerifyEmailScreen extends StatelessWidget { 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify email'),
      ),
      body: MyBackground(child: _viewBasedOnState(context)),
    );
  }

  Widget _viewBasedOnState(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    //userProvider.initState();

    if(userProvider.state == UiState.Loading) {
      return MyLoadingWidget();
    } else if(userProvider.state == UiState.Error) {
      return MyErrorWidget('Failed to load user information.');
    } else {
      authProvider.verifyEmail();
      return Padding(
        padding: EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Hi ${userProvider.firstName},', style: UiConstants.TS_HDR,),
            SizedBox(height: 20.0),
            Text(
              'Please verify your email address. We\'ve sent an email to ${userProvider.email} so you can do so.'
              , style: UiConstants.TS_DEFAULT,
            ),
            SizedBox(height: 10.0),
            Text('If you have verified or you didn\'t receive an email then simply push refresh', style: UiConstants.TS_DEFAULT,),
            SizedBox(height: 20.0,),
            DefaultButton(
              child: Text('Refresh'),
              onPressed: () => authProvider.verifyEmail(),
            ),
          ],
        ),
      );
    }
  }
}