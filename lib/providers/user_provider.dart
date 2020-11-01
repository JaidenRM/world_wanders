import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:world_wanders/models/google_place.dart';
import 'package:world_wanders/models/saved_place.dart';
import 'package:world_wanders/models/user.dart';
import 'package:world_wanders/services/interfaces/authentication_service_interface.dart';
import 'package:world_wanders/services/interfaces/user_service_interface.dart';
import 'package:world_wanders/utils/constants/ui_constants.dart';

class UserProvider extends ChangeNotifier {
  final UserServiceInterface _userService;
  final AuthenticationServiceInterface _authService;

  UserProvider(
    UserServiceInterface userService,
    AuthenticationServiceInterface authService,
  )
    : assert(userService != null && authService != null),
      _authService = authService,
      _userService = userService
    {
      SchedulerBinding.instance.addPostFrameCallback((_) { 
        initState();
      });
    }

  StreamSubscription<User> _userSubscription;
  User _user;
  String _errorMsg;
  UiState _state = UiState.Loading;

  String get firstName => _user?.userProfile?.firstName;
  String get lastName => _user?.userProfile?.lastName;
  String get email => _user?.userProfile?.email;
  List<SavedPlace> get savedPlaces => _user?.savedPlaces;
  UiState get state => _state;
  String get errMsg => _errorMsg;

  void initState() async {
    _authService.authStream.listen((user) async { 
      if(user == null) {
        _userSubscription?.cancel();
        _user = null;
        _state = UiState.Loading;
      } else {
        //being called twice?
        _user = await _userService.getUser();
        _state = UiState.Ready;

        _userSubscription = _userService.currUserStream()?.listen((user) { 
          _user = user;
          _state = user == null ? UiState.Loading : UiState.Ready;

          notifyListeners();
        });
      }
      notifyListeners();
    });
  }

  void savePlace(GooglePlace gPlace) async {
    final result = await _userService.savePlace(gPlace);
    _errorMsg = result.isSuccess ? null : result.message;
    notifyListeners();
  }

  void removePlace(String placeId) async {
    final result = await _userService.removePlace(placeId);
    _errorMsg = result.isSuccess ? null : result.message;
    notifyListeners();
  }

  @override
  void dispose() {
    _userSubscription?.cancel();
    super.dispose();
  }
}