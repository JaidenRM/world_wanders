import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:world_wanders/models/city.dart';
import 'package:world_wanders/models/google_place.dart';
import 'package:world_wanders/services/nearby_place_request.dart';
import 'package:world_wanders/services/places_request.dart';
import 'package:world_wanders/utils/constants/places_constants.dart';
import 'package:world_wanders/utils/constants/ui_constants.dart';
import 'package:world_wanders/utils/constants/validation_constants.dart';
import 'package:world_wanders/utils/predefined_locations.dart';
import 'package:world_wanders/utils/validation.dart';

class NearbySearchProvider extends ChangeNotifier {
  List<City> _cities;
  String _selectedCountry;
  City _selectedCity;
  UiState _state = UiState.Loading;
  String _keyword;
  String _type;
  int _radius = 0;
  List<GooglePlace> _gPlaces = [];
  PriceRange _minPrice;
  PriceRange _maxPrice;
  PlacesRequest _lastRequest;
  
  bool _isAdvancedMenu = false;
  bool _isOpenNow = false;
  bool _isRankedByDist = false;
  
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
  String get selectedType => _type;
  List<GooglePlace> get results => _gPlaces;
  int get minPriceRange => _minPrice == null ? 0 : _minPrice.index + 1;
  int get maxPriceRange => _maxPrice == null ? 0 : _maxPrice.index + 1;
  PlacesRequest get lastRequest => _lastRequest;

  bool get isAdvancedMenu => _isAdvancedMenu;
  bool get isOpenNow => _isOpenNow;
  bool get isRankedByDist => _isRankedByDist;

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

  void setPriceRange(int min, int max) {
    bool isValidMin = min != null && min - 1 >= 0 && min <= PriceRange.values.length;
    bool isValidMax = max != null && max - 1 >= 0 && max <= PriceRange.values.length;

    _minPrice = isValidMin ? PriceRange.values[min - 1] : null;
    _maxPrice = isValidMax ? PriceRange.values[max - 1] : null;

    notifyListeners();
  }

  void toggleAdvancedMenu() {
    _isAdvancedMenu = !_isAdvancedMenu;
    notifyListeners();
  }

  void toggleOpenNow() {
    _isOpenNow = !_isOpenNow;
    notifyListeners();
  }

  void toggleRankedByDist() {
    _isRankedByDist = !_isRankedByDist;
    notifyListeners();
  }

  void setType(String type) {
    _type = type;
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
    _lastRequest = _generateRequest();

    _state = UiState.Completed;
    notifyListeners();
  }


  Validation isValid() {
    bool hasLocation = _selectedCountry != null && _selectedCity != null;
    bool hasRadiusOrRankBy = _radius > 0 || _isRankedByDist;
    String errMsg;

    if(!hasLocation)
      errMsg = "Please select a country and city";
    if(!hasRadiusOrRankBy)
      errMsg = "Please specify a search radius OR tick the nearby locations checkbox";
    
    return Validation(
      error: errMsg
    );
  }

  void reset() {
    _state = UiState.Ready;
    notifyListeners();
  }

  NearbyPlaceRequest _generateRequest() {
    final req = NearbyPlaceRequest(_selectedCity.latlng, _radius);
    final hasReq = ValidationConstants.isStringNotNullOrEmpty(_keyword);
    
    if(!hasReq.hasError)
      req.addKeyword(hasReq.value);
    
    if(_isAdvancedMenu) {
      if(_isOpenNow)
        req.addOpenNow();
      if(_minPrice != null && _maxPrice != null)  
        req.addPriceRange(_minPrice, max: _maxPrice);
      if(_isRankedByDist)
        req.addRankBy(RankBy.Distance);
      if(PlacesConstants.PARM_TYPE_VALUES.contains(_type))
        req.addType(_type);
    }

    return req;
  }

} 