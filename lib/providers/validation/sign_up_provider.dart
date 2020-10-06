import 'package:flutter/cupertino.dart';
import 'package:string_validator/string_validator.dart';
import 'package:world_wanders/utils/constants/validation_constants.dart';
import 'package:world_wanders/utils/validation.dart';

class SignUpProvider extends ChangeNotifier {
  Validation _firstName = Validation(value: null, error: null);
  Validation _lastName = Validation(value: null, error: null);
  Validation _email = Validation(value: null, error: null);
  Validation _password = Validation(value: null, error: null);

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
    if(isEmail(email))
      _email = Validation(value: email, error: null);
    else
      _email = Validation(value: null, error: 'Please enter a valid email');

    notifyListeners();
  }

  void changePassword(String pwd) {
    final alphaLower = whitelist(pwd, 'a-z').length;
    final alphaUpper = whitelist(pwd, 'A-Z').length;
    final nums = whitelist(pwd, '0-9').length;
    final nonAlphaNums = blacklist(pwd, 'a-zA-Z0-9').length;

    if(pwd.length < ValidationConstants.MIN_PWD)
      _password = Validation(value: null, error: 'Password is too short. Minimum length of 8 characters.');
    else if(pwd.length > ValidationConstants.MAX_PWD)
      _password = Validation(value: null, error: 'Password is too long. Maximum length of 128 characters.');
    else if(alphaLower < ValidationConstants.MIN_ALPHA_LWR)
      _password = Validation(value: null, error: 'A minimum of ${ValidationConstants.MIN_ALPHA_LWR} lowercase character(s) needed.');
    else if(alphaUpper < ValidationConstants.MIN_ALPHA_UPR)
      _password = Validation(value: null, error: 'A minimum of ${ValidationConstants.MIN_ALPHA_UPR} uppercase character(s) needed.');
    else if(nums < ValidationConstants.MIN_NUM)
      _password = Validation(value: null, error: 'A minimum of ${ValidationConstants.MIN_NUM} numeric character(s) needed.');
    else if(nonAlphaNums < ValidationConstants.MIN_SPECIAL)
      _password = Validation(value: null, error: 'A minimum of ${ValidationConstants.MIN_SPECIAL} special character(s) needed.');
    else
      _password = Validation(value: pwd, error: null);

    notifyListeners();
  }

  void submitData() {
    //do db stuff?
  }

}