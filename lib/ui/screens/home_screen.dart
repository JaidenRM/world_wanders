import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_wanders/providers/user_provider.dart';
import 'package:world_wanders/providers/validation/auth_provider.dart';
import 'package:world_wanders/ui/buttons/default_button.dart';
import 'package:world_wanders/ui/utils/my_error_widget.dart';
import 'package:world_wanders/ui/utils/my_loading_widget.dart';
import 'package:world_wanders/utils/constants/ui_constants.dart';

class HomeScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    return Scaffold(
      //leading if we want hamburger menu
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout
            ), 
            onPressed: authProvider.signOut
          )
        ],
      ),
      body: _viewBasedOnState(context, authProvider),
    );
  }

  Widget _viewBasedOnState(BuildContext context, AuthProvider authProvider) {
    final userProvider = Provider.of<UserProvider>(context);

    if(userProvider.state == UiState.Loading) {
      return MyLoadingWidget();
    } else if(userProvider.state == UiState.Error) {
      return MyErrorWidget('Failed to load user information');
    } else {
      return Padding(
        padding: EdgeInsets.all(10.0),
        child: Center(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 25.0),
                child: Text('Welcome ${userProvider.firstName}')
              ),
              //start tracking trip when date hits..
              DefaultButton(
                child: Text('Plan a new trip'),
                onPressed: null,
              ),
              DefaultButton(
                child: Text('Browse locations'),
                onPressed: null,
              ),
              DefaultButton(
                child: Text('History'),
                onPressed: null,
              ),
              DefaultButton(
                child: Text('Track a trip'),
                onPressed: null,
              ),
              DefaultButton(
                child: Text('Statistics'),
                onPressed: null,
              ),
            ]
          ),
        ),
      );
    }
  }
}