import 'package:string_validator/string_validator.dart';
import 'package:world_wanders/utils/validation.dart';

enum AuthType {
  EmailPwd,
  Google
}

class ValidationConstants {
  static const int MIN_PWD = 8;
  static const int MIN_ALPHA_LWR = 1;
  static const int MIN_ALPHA_UPR = 1;
  static const int MIN_NUM = 1;
  static const int MIN_SPECIAL = 1;

  static const int MAX_PWD = 128;

  static const String TRUE = "true";


  static Validation isValidEmail(String email) {
    var isValid = isEmail(email);

    return Validation(
      value: isValid ? email : null,
      error: isValid ? null : 'Email is not valid',
    );
  }

  static Validation isValidPassword(String pwd) {
    final alphaLower = whitelist(pwd, 'a-z').length;
    final alphaUpper = whitelist(pwd, 'A-Z').length;
    final nums = whitelist(pwd, '0-9').length;
    final nonAlphaNums = blacklist(pwd, 'a-zA-Z0-9').length;

    if(pwd.length < ValidationConstants.MIN_PWD)
      return Validation(value: null, error: 'Password is too short. Minimum length of 8 characters.');
    else if(pwd.length > ValidationConstants.MAX_PWD)
      return Validation(value: null, error: 'Password is too long. Maximum length of 128 characters.');
    else if(alphaLower < ValidationConstants.MIN_ALPHA_LWR)
      return Validation(value: null, error: 'A minimum of ${ValidationConstants.MIN_ALPHA_LWR} lowercase character(s) needed.');
    else if(alphaUpper < ValidationConstants.MIN_ALPHA_UPR)
      return Validation(value: null, error: 'A minimum of ${ValidationConstants.MIN_ALPHA_UPR} uppercase character(s) needed.');
    else if(nums < ValidationConstants.MIN_NUM)
      return Validation(value: null, error: 'A minimum of ${ValidationConstants.MIN_NUM} numeric character(s) needed.');
    else if(nonAlphaNums < ValidationConstants.MIN_SPECIAL)
      return Validation(value: null, error: 'A minimum of ${ValidationConstants.MIN_SPECIAL} special character(s) needed.');
    else
      return Validation(value: pwd, error: null);
  }
}