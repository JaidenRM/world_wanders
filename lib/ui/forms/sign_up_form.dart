import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_wanders/providers/validation/sign_up_provider.dart';
import 'package:world_wanders/ui/buttons/default_button.dart';
import 'package:world_wanders/ui/utils/my_background.dart';
import 'package:world_wanders/ui/utils/my_loading_widget.dart';
import 'package:world_wanders/utils/constants/ui_constants.dart';

class SignUpForm extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign up'),
      ),
      body: MyBackground(child: _viewBasedOnState(context)),
    );
  }

  Widget _viewBasedOnState(BuildContext context) {
    final signUpProvider = Provider.of<SignUpProvider>(context);

    if(signUpProvider.state == UiState.Loading) {
      return MyLoadingWidget();
    } else if(signUpProvider.state == UiState.Completed) {
      Navigator.of(context).pop();
      return MyLoadingWidget();
    } 
    else {
      return Padding(
        padding: const EdgeInsets.all(UiConstants.PAD_BASE),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'First Name',
                  errorText: signUpProvider.firstName.error,
                  errorStyle: UiConstants.TS_ERR,
                  labelStyle: UiConstants.TS_DEFAULT,
                ),
                onChanged: (String val) => signUpProvider.changeFirstName(val)
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  errorText: signUpProvider.lastName.error,
                  errorStyle: UiConstants.TS_ERR,
                  labelStyle: UiConstants.TS_DEFAULT,
                ),
                onChanged: (String val) => signUpProvider.changeLastName(val)
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  errorText: signUpProvider.email.error,
                  errorStyle: UiConstants.TS_ERR,
                  labelStyle: UiConstants.TS_DEFAULT,
                ),
                onChanged: (String val) => signUpProvider.changeEmail(val),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  errorText: signUpProvider.password.error,
                  errorStyle: UiConstants.TS_ERR,
                  labelStyle: UiConstants.TS_DEFAULT,
                ),
                onChanged: (String val) => signUpProvider.changePassword(val),
                obscureText: true,
              ),
              DefaultButton(
                child: Text('Submit'),
                onPressed: (!signUpProvider.isValid) ? null : signUpProvider.submitData,
              ),
            ],
          ),
        ),
      );
    }
  }
}