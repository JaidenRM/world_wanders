import 'package:flutter/cupertino.dart';
import 'package:string_validator/string_validator.dart';
import 'package:world_wanders/models/user_profile.dart';
import 'package:world_wanders/services/interfaces/authentication_service_interface.dart';
import 'package:world_wanders/services/interfaces/user_service_interface.dart';
import 'package:world_wanders/utils/constants/ui_constants.dart';
import 'package:world_wanders/utils/constants/validation_constants.dart';
import 'package:world_wanders/utils/validation.dart';

class SignUpProvider extends ChangeNotifier {
  final AuthenticationServiceInterface _authService;
  final UserServiceInterface _userService;

  UiState _state = UiState.Ready;
  Validation _firstName = Validation(value: null, error: null);
  Validation _lastName = Validation(value: null, error: null);
  Validation _email = Validation(value: null, error: null);
  Validation _password = Validation(value: null, error: null);

  SignUpProvider({ 
    AuthenticationServiceInterface authService,
    UserServiceInterface userService,
  })
    : assert(authService != null && userService != null),
      _userService = userService,
      _authService = authService;

  UiState get state => _state;
  Validation get firstName => _firstName;
  Validation get lastName => _lastName;
  Validation get email => _email;
  Validation get password => _password;

  bool get isValid => 
    _firstName.value != null && _lastName.value != null &&
    _email.value != null && _password.value != null;

  void changeFirstName(String name) {
    if(isLength(name, 1))
      _firstName = Validation(value: name, error: null);
    else
      _firstName = Validation(value: null, error: 'No valid characters found');

    notifyListeners();
  }

  void changeLastName(String name) {
    if(isLength(name, 1))
      _lastName = Validation(value: name, error: null);
    else
      _lastName = Validation(value: null, error: 'No valid characters found');

    notifyListeners();
  }

  void changeEmail(String email) {
    _email = ValidationConstants.isValidEmail(email);

    notifyListeners();
  }

  void changePassword(String pwd) {
    _password = ValidationConstants.isValidPassword(pwd);

    notifyListeners();
  }

  void submitData() async {
    _state = UiState.Loading;
    notifyListeners();

    var status = await _authService.signUp(_email.value, _password.value);
    _state = status.isSuccess ? UiState.Completed : UiState.Error;

    if(status.isSuccess)
      await _userService.setProfile(UserProfile(
        firstName: _firstName.value,
        lastName: _lastName.value,
        email: _email.value,
      ));

    notifyListeners();
  }

}