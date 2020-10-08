import 'package:flutter/widgets.dart';
import 'package:world_wanders/ui/forms/login_form.dart';
import 'package:world_wanders/ui/forms/sign_up_form.dart';
import 'package:world_wanders/utils/constants/route_constants.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> routes = {
    RouteConstants.LOGIN: (context) => LoginForm(),
    RouteConstants.SIGNUP: (context) => SignUpForm(),
  };
}