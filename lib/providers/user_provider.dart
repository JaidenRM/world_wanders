import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:world_wanders/services/interfaces/user_service_interface.dart';
import 'package:world_wanders/utils/constants/ui_constants.dart';

class UserProvider extends ChangeNotifier {
  final UserServiceInterface _userService;

  UserProvider(UserServiceInterface userService)
    : assert(userService != null),
      _userService = userService {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          initState();
        });
      }

  String _firstName;
  String _lastName;
  String _email;
  UiState _state = UiState.Loading;

  String get firstName => _firstName;
  String get lastName => _lastName;
  String get email => _email;
  UiState get state => _state;

  void initState() async {
    final profile = await _userService.getProfile();

    _firstName = profile.firstName;
    _lastName = profile.lastName;
    _email = profile.email;
    _state = UiState.Ready;

    notifyListeners();
  }
}