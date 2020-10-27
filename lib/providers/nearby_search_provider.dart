import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:world_wanders/models/city.dart';
import 'package:world_wanders/models/google_place.dart';
import 'package:world_wanders/services/nearby_place_request.dart';
import 'package:world_wanders/utils/constants/places_constants.dart';
import 'package:world_wanders/utils/constants/ui_constants.dart';
import 'package:world_wanders/utils/constants/validation_constants.dart';
import 'package:world_wanders/utils/predefined_locations.dart';

class NearbySearchProvider extends ChangeNotifier {
  List<City> _cities;
  String _selectedCountry;
  City _selectedCity;
  UiState _state = UiState.Loading;
  String _keyword;
  int _radius = 0;
  List<GooglePlace> _gPlaces = [];
  
  List<String> get countries => _cities.fold<List<String>>([], (countries, city) {
    if(!countries.contains(city.country))
      countries.add(city.country);

    return countries;
  });
  List<City> get citiesInCountry => _cities.fold<List<City>>([], (cities, city) {
    if(city.country == _selectedCountry)
      cities.add(city);
    
    return cities;
  });
  UiState get state => _state;
  String get selectedCountry => _selectedCountry;
  City get selectedCity => _selectedCity;
  int get searchRadius => _radius;
  String get searchText => _keyword;
  List<GooglePlace> get results => _gPlaces;

  NearbySearchProvider() {
    SchedulerBinding.instance.addPostFrameCallback((_) { 
      initState();
    });
  }

  void initState() async {
    _cities = await PredefinedLocations().getCities();
    _cities.sort((prev, curr) {
      var cmpCountry = prev.country.compareTo(curr.country);
      if(cmpCountry != 0) return cmpCountry;

      var cmpCity = prev.name.compareTo(curr.name);
      if(cmpCity != 0) return cmpCity;

      return prev.state.compareTo(curr.state);
    });

    _state = UiState.Ready;

    notifyListeners();
  }

  void setCountry(String country) {
    _selectedCountry = country;
    notifyListeners();
  }

  void setKeyword(String keyword) {
    _keyword = keyword;
    notifyListeners();
  }

  void setCity(City city) { 
    _selectedCity = city;
    notifyListeners();
  }

  void setSearchRadius(int radius) {
    if(radius == null || radius < 0)
      _radius = 0;
    else if(radius > PlacesConstants.PARM_RADIUS_MAX)
      _radius = PlacesConstants.PARM_RADIUS_MAX;
    else
      _radius = radius;

    notifyListeners();
  }

  void submitSearch() async {
    _state = UiState.Loading;
    notifyListeners();

    //split into var incase we want to add parameters in future
    final req = _generateRequest();
      
    _gPlaces = await req.fetchRequest();

    _state = UiState.Completed;
    notifyListeners();
  }

  NearbyPlaceRequest _generateRequest() {
    final req = NearbyPlaceRequest(_selectedCity.latlng, _radius);
    final hasReq = ValidationConstants.isStringNotNullOrEmpty(_keyword);
    
    if(!hasReq.hasError)
      req.addKeyword(hasReq.value);

    return req;
  }

} 