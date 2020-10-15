import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_wanders/providers/validation/sign_up_provider.dart';
import 'package:world_wanders/ui/buttons/default_button.dart';
import 'package:world_wanders/ui/utils/my_background.dart';
import 'package:world_wanders/ui/utils/my_error_widget.dart';
import 'package:world_wanders/ui/utils/my_loading_widget.dart';
import 'package:world_wanders/utils/constants/ui_constants.dart';

class SignUpForm extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final signUpProvider = Provider.of<SignUpProvider>(context);
    final mq = MediaQuery.of(context);
    final showFab = mq.viewInsets.bottom == 0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Sign up'),
      ),
      body: MyBackground(
        child: _viewBasedOnState(context, signUpProvider, mq),
        alignment: Alignment.topCenter,
      ),
      floatingActionButton: showFab ? 
        DefaultButton(
          child: Text('Submit'),
          onPressed: (!signUpProvider.isValid) ? null : signUpProvider.submitData,
        ) : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _viewBasedOnState(BuildContext context, SignUpProvider signUpProvider, MediaQueryData mq) {
    
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
            children: [
              Container(
                width: mq.size.width * 0.75,
                child: Text('Greetings!', style: UiConstants.TS_HDR, textAlign: TextAlign.center,),
              ),
              SizedBox(height: 30.0),
              Text(
                'I hope to see you wandering the world as you feast upon local delicacies and admire your surroundings', 
                style: UiConstants.TS_DEFAULT,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: mq.size.height * 0.1,),
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
              SizedBox(height: 75.0),
              if(signUpProvider.state == UiState.Error)
                MyErrorWidget(signUpProvider.errorMsg),
            ],
          ),
        ),
      );
    }
  }
}