import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_wanders/providers/validation/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    //TO ADD below comment
    //Dont forget changenotifierprovider
    //final userProvider = Provider.of<UserProvider>(context);
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
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Text('Welcome'),
            RaisedButton(
              child: Text('Button'),
              onPressed: null,
            ),
          ]
        ),
      ),
    );
  }
}