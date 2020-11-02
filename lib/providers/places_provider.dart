import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:world_wanders/models/places_widget_interface.dart';
import 'package:world_wanders/services/places_request.dart';
import 'package:world_wanders/services/text_search_request.dart';
import 'package:world_wanders/utils/constants/ui_constants.dart';

class PlacesProvider extends ChangeNotifier {

  UiState _state = UiState.Ready;
  String _msg;
  String _searchText = "";
  String _currPlaceId;
  List<PlacesWidget> _gPlaces = [];
  Set<Marker> _gPlaceMarkers = {};
  PlacesRequest _lastRequest;

  UiState get state => _state;
  String get searchText => _searchText;
  String get msg => _msg;
  List<PlacesWidget> get googlePlaces => _gPlaces;
  Set<Marker> get markers => _gPlaceMarkers;
  String get currPlaceId => _currPlaceId;

  GoogleMapController gController;
  
  PlacesProvider({
    PlacesRequest request,
    List<PlacesWidget> preloadedPlaces,
  })
    : _lastRequest = request,
      _gPlaces = preloadedPlaces ?? []
  {
    if(_gPlaces.length == 0) {
      SchedulerBinding.instance.addPostFrameCallback((_) async { 
        if(_lastRequest != null) {
          _gPlaces = await _lastRequest.fetchRequest();
          _updateGoogleController(_gPlaces[0]);
          notifyListeners();
        }
      });
    }
  }

  void changeSearchText(String text) {
    _searchText = text;
    
    notifyListeners();
  }

  void search() async {
    _state = UiState.Loading;
    notifyListeners();

    var req = TextSearchRequest(query: _searchText);
    await searchRequest(req);
  }

  Future<void> searchRequest(PlacesRequest request) async {

    _gPlaces = await request.fetchRequest();
    _state = UiState.Completed;

    if(_gPlaces.length > 0) {
      _updateGoogleController(_gPlaces[0]);
    }

    notifyListeners();
  }
  
  void tryFetchNextPage() async {

    if(_lastRequest != null) {
      _state = UiState.Loading;
      notifyListeners();

      final newPlaces = await _lastRequest.fetchNextPageRequest();
      if(newPlaces != null) {
        _gPlaces.addAll(newPlaces);
      }
      
      _state = UiState.Completed;
      notifyListeners();
    }
  }

  void selectNewPlace(String placeId) {
    var newPlace = _gPlaces.singleWhere((place) => place.placeId == placeId);
    
    if(newPlace != null) {
      _updateGoogleController(newPlace);
      notifyListeners();
    }
  }

  void _updateGoogleController(PlacesWidget place) {
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