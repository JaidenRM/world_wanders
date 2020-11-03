import 'package:flutter/material.dart';
import 'package:world_wanders/utils/constants/ui_constants.dart';

enum HistScreen {
  Trips,
  Posts,
  Places,
  Main
}

class HistoryProvider extends ChangeNotifier {
  UiState _state;
  HistScreen _selScreen = HistScreen.Main;

  UiState get state => _state;
  HistScreen get selectedScreen => _selScreen;

  void setScreen(HistScreen screen) {
    if(screen == null) return;
    
    _selScreen = screen;
    notifyListeners();
  }
}