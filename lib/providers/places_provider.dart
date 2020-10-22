import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:world_wanders/models/google_place.dart';
import 'package:world_wanders/services/interfaces/user_service_interface.dart';
import 'package:world_wanders/services/text_search_request.dart';
import 'package:world_wanders/utils/constants/ui_constants.dart';

class PlacesProvider extends ChangeNotifier {
  final UserServiceInterface _userService;

  UiState _state = UiState.Ready;
  String _msg;
  String _searchText = "";
  String _currPlaceId;
  List<GooglePlace> _gPlaces = [];
  Set<Marker> _gPlaceMarkers = {};

  UiState get state => _state;
  String get searchText => _searchText;
  String get msg => _msg;
  List<GooglePlace> get googlePlaces => _gPlaces;
  Set<Marker> get markers => _gPlaceMarkers;
  String get currPlaceId => _currPlaceId;

  GoogleMapController gController;
  
  PlacesProvider({ 
    UserServiceInterface userService,
  })
    : assert(userService != null),
      _userService = userService;

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

    if(_gPlaces.length > 0) {
      _updateGoogleController(_gPlaces[0]);
    }

    notifyListeners();
  }

  void selectNewPlace(String placeId) {
    var newPlace = _gPlaces.singleWhere((place) => place.placeId == placeId);
    
    if(newPlace != null) {
      _updateGoogleController(newPlace);
      notifyListeners();
    }
  }

  void _updateGoogleController(GooglePlace place) {
    if(gController != null && place != null) {
      if(place.location != null) {
        _gPlaceMarkers.add(Marker(
          markerId: MarkerId(place.placeId),
          position: place.location,
        ));
      }

      gController.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: place.location ?? LatLng(0, 0),
            zoom: 15.0,
          )
        )
      );

      _currPlaceId = place.placeId;
    }
  }

}