import 'package:flutter/cupertino.dart';
import 'package:world_wanders/services/interfaces/authentication_service_interface.dart';
import 'package:world_wanders/utils/constants/ui_constants.dart';
import 'package:world_wanders/utils/constants/validation_constants.dart';
import 'package:world_wanders/utils/validation.dart';

class ForgotPasswordProvider extends ChangeNotifier {
  final AuthenticationServiceInterface _authService;

  UiState _state = UiState.Ready;
  String _msg;
  Validation _email = Validation(value: null, error: null);

  ForgotPasswordProvider({ 
    AuthenticationServiceInterface authService,
  })
    : assert(authService != null),
      _authService = authService;

  UiState get state => _state;
  Validation get email => _email;
  String get msg => _msg;

  bool get isValid => _email.value != null;

  void changeEmail(String email) {
    _email = ValidationConstants.isValidEmail(email);

    notifyListeners();
  }

  void submitData() async {
    _state = UiState.Loading;
    notifyListeners();

    final status = await _authService.sendEmailForgotPassword(_email.value);
    _state = status.isSuccess ? UiState.Completed : UiState.Error;
    _msg = status.message;
    _cleanFields(status.isSuccess);

    notifyListeners();
  }

  void _cleanFields(bool wipe) {
    _email = wipe ? Validation(value: null, error: null) : _email;
  }

}