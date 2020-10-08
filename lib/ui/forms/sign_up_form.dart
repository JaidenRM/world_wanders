import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_wanders/providers/validation/sign_up_provider.dart';

class SignUpForm extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final signUpProvider = Provider.of<SignUpProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'First Name',
                errorText: signUpProvider.firstName.error
              ),
              onChanged: (String val) => signUpProvider.changeFirstName(val)
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Last Name',
                errorText: signUpProvider.lastName.error
              ),
              onChanged: (String val) => signUpProvider.changeLastName(val)
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                errorText: signUpProvider.email.error
              ),
              onChanged: (String val) => signUpProvider.changeEmail(val),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Password',
                errorText: signUpProvider.password.error,
              ),
              onChanged: (String val) => signUpProvider.changePassword(val),
              obscureText: true,
            ),
            RaisedButton(
              child: Text('Submit'),
              onPressed: (!signUpProvider.isValid) ? null : signUpProvider.submitData,
            ),
          ],
        ),
      ),
    );
  }

}