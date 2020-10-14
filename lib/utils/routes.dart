import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:world_wanders/providers/validation/forgot_password_provider.dart';
import 'package:world_wanders/providers/validation/sign_up_provider.dart';
import 'package:world_wanders/services/authentication_service.dart';
import 'package:world_wanders/services/user_service.dart';
import 'package:world_wanders/ui/forms/forgot_password_form.dart';
import 'package:world_wanders/ui/forms/login_form.dart';
import 'package:world_wanders/ui/forms/sign_up_form.dart';
import 'package:world_wanders/ui/screens/verify_email_screen.dart';
import 'package:world_wanders/utils/constants/route_constants.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> routes = {
    RouteConstants.LOGIN: (context) => LoginForm(),
    RouteConstants.SIGNUP: (context) 
      => ChangeNotifierProvider(
        create: (context) => SignUpProvider(
          authService: AuthenticationService(),
          userService: UserService(),
        ),
        child: SignUpForm(),
      ),
    RouteConstants.VERIFY_EMAIL: (context) => VerifyEmailScreen(),
    RouteConstants.FORGOT_PWD: (context)
      => ChangeNotifierProvider(
        create: (context) => ForgotPasswordProvider(
          authService: AuthenticationService(),
        ),
        child: ForgotPasswordForm(),
      ),
  };
}