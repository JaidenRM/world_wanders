import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_wanders/providers/validation/auth_provider.dart';
import 'package:world_wanders/services/authentication_service.dart';
import 'package:world_wanders/ui/screens/home_screen.dart';
import 'package:world_wanders/utils/constants/validation_constants.dart';
import 'package:world_wanders/utils/routes.dart';

import 'ui/forms/login_form.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(AuthenticationService()),
      child: MaterialApp(
        title: 'Flutter Demo',
        routes: Routes.routes,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Consumer<AuthProvider>(
          builder: (context, auth, child) {
            if(auth.authenticated.value == ValidationConstants.TRUE)
              return HomeScreen();
            else
              return LoginForm();
          },
        ),
      )
    );
  }
}
