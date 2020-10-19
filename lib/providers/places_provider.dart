import 'package:flutter/material.dart';
import 'package:world_wanders/models/google_place.dart';
import 'package:world_wanders/services/interfaces/user_service_interface.dart';
import 'package:world_wanders/services/text_search_request.dart';
import 'package:world_wanders/utils/constants/ui_constants.dart';

class PlacesProvider extends ChangeNotifier {
  final UserServiceInterface _userService;

  UiState _state = UiState.Ready;
  String _msg;
  String _searchText = "";
  List<GooglePlace> _gPlaces = [];

  PlacesProvider({ 
    UserServiceInterface userService,
  })
    : assert(userService != null),
      _userService = userService;

  UiState get state => _state;
  String get searchText => _searchText;
  String get msg => _msg;
  List<GooglePlace> get googlePlaces => _gPlaces;

  void changeSearchText(String text) {
    _searchText = text;

    notifyListeners();
  }

  void search() async {
    _state = UiState.Loading;
    notifyListeners();

    var req = TextSearchRequest(query: _searchText);
    _gPlaces = await req.fetchRequest();
    _state = UiState.Completed;

    notifyListeners();
  }

}