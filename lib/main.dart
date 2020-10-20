import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_wanders/providers/user_provider.dart';
import 'package:world_wanders/providers/validation/auth_provider.dart';
import 'package:world_wanders/services/authentication_service.dart';
import 'package:world_wanders/services/user_service.dart';
import 'package:world_wanders/ui/screens/home_screen.dart';
import 'package:world_wanders/ui/screens/verify_email_screen.dart';
import 'package:world_wanders/utils/constants/ui_constants.dart';
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
          primaryColor: UiConstants.PRIMARY_COLOUR,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: UiConstants.FONT_FAM_DEFAULT,
          cardTheme: CardTheme(
            color: UiConstants.SECONDARY_COLOUR,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 10.0,
          ),
        ),
        //move email logic into homescreen for navigation issues?
        home: Consumer<AuthProvider>(
          builder: (context, auth, child) {
            if(auth.authenticated.value == ValidationConstants.TRUE) {
              Widget _displayScreen;
              if(!auth.emailVerified)
                _displayScreen = VerifyEmailScreen();
              else
                _displayScreen = HomeScreen();
              
              return ChangeNotifierProvider(
                create: (context) => UserProvider(UserService()),
                child: _displayScreen,
              );
            }
            else
              return LoginForm();
          },
        ),
      )
    );
  }
}
