import 'package:flutter/cupertino.dart';
import 'package:world_wanders/services/interfaces/authentication_service_interface.dart';
import 'package:world_wanders/utils/constants/validation_constants.dart';
import 'package:world_wanders/utils/validation.dart';

class AuthProvider extends ChangeNotifier {
  AuthenticationServiceInterface _authService;
  
  Validation _authenticated;
  Validation _email;
  Validation _password;
  String _error;
  
  Validation get authenticated => _authenticated;
  Validation get email => _email;
  Validation get password => _password;

  bool get isValid => _email.value != null && _password.value != null;

  AuthProvider(AuthenticationServiceInterface authService)
    : assert(authService != null),
      _authService = authService 
    {
      _authService.authStream.listen((user) { 
        if(user == null) {
          _authenticated = Validation(
            value: null,
            error: _error == null ? 'User not authenticated. Please relog.' : _error
          );
        } else {
          _authenticated = Validation(value: ValidationConstants.TRUE, error: null);
        }

        notifyListeners();
      });
    }
  
  void changeEmail(String email) {
    _email = ValidationConstants.isValidEmail(email);

    notifyListeners();
  }

  void changePassword(String pwd) {
    _password = ValidationConstants.isValidPassword(pwd);

    notifyListeners();
  }
    
  void signIn(AuthType type) async {
    
    switch(type) {
      case AuthType.EmailPwd:
        final status = await _authService.signIn(_email.value, _password.value);
        _error = status.isSuccess ? null : status.message;
        break;
      case AuthType.Google:
        await _authService.signInWithGoogle();
        break;
    }
  }

  void signOut() async {
    await _authService.signOut();
  }
}