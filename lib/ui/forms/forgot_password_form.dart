import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_wanders/providers/validation/forgot_password_provider.dart';
import 'package:world_wanders/ui/buttons/default_button.dart';
import 'package:world_wanders/ui/utils/my_background.dart';
import 'package:world_wanders/ui/utils/my_error_widget.dart';
import 'package:world_wanders/ui/utils/my_loading_widget.dart';
import 'package:world_wanders/ui/utils/my_success_widget.dart';
import 'package:world_wanders/utils/constants/ui_constants.dart';

class ForgotPasswordForm extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot password'),
      ),
      body: MyBackground(
        child: _viewBasedOnState(context)
      ),
    );
  }

  Widget _viewBasedOnState(BuildContext context) {
    final mq = MediaQuery.of(context);
    final fPwdProvider = Provider.of<ForgotPasswordProvider>(context);

    if(fPwdProvider.state == UiState.Loading) {
      return MyLoadingWidget();
    } else {
      return Padding(
        padding: EdgeInsets.all(UiConstants.PAD_BASE),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: mq.size.width * 0.75,
                child: Text('Forgot your password?', style: UiConstants.TS_HDR, textAlign: TextAlign.center,),
              ),
              SizedBox(height: 30.0),
              Text('Don\'t worry, it happens to best of us!', style: UiConstants.TS_DEFAULT,),
              SizedBox(height: mq.size.height * 0.1,),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  errorText: fPwdProvider.email.error,
                  errorStyle: UiConstants.TS_ERR,
                  labelStyle: UiConstants.TS_DEFAULT,
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: (String val) => fPwdProvider.changeEmail(val),
                style: UiConstants.TS_DEFAULT,
              ),
              SizedBox(height: 30.0,),
              DefaultButton(
                child: Text('Send'),
                onPressed: (!fPwdProvider.isValid) ? null : fPwdProvider.submitData,
              ),
              SizedBox(height: 20.0),
              if(fPwdProvider.state == UiState.Completed)
                MySuccessWidget(fPwdProvider.msg),
              if(fPwdProvider.state == UiState.Error)
                MyErrorWidget(fPwdProvider.msg),
            ],
          ),
        ),
      );
    }
  }
}