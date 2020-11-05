import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:world_wanders/models/city.dart';
import 'package:world_wanders/models/trip.dart';
import 'package:world_wanders/services/interfaces/trip_service_interface.dart';
import 'package:world_wanders/utils/constants/ui_constants.dart';
import 'package:world_wanders/utils/helpers.dart';
import 'package:world_wanders/utils/mixins/destinations_mixin.dart';

class CreateTripProvider extends ChangeNotifier with DestinationsMixin {
  final TripServiceInterface _tripService;

  CreateTripProvider(TripServiceInterface tripService)
    : assert(tripService != null),
      _tripService = tripService
    {
      SchedulerBinding.instance.addPostFrameCallback((_) async { 
        await loadData();

        _state = UiState.Ready;
        notifyListeners();
      });
    }

  UiState _state = UiState.Loading;
  DateTime _startDate;
  DateTime _endDate;
  String _tripName;
  String _tripDescription;
  Map<String, List<City>> _citiesInCountries = {};

  UiState get state => _state;
  String get startDate => _startDate == null ? "" : "${_startDate?.day}-${_startDate?.month}-${_startDate?.year}";
  String get endDate => _endDate == null ? "" : "${_endDate?.day}-${_endDate?.month}-${_endDate?.year}";
  String get tripName => _tripName;
  String get tripDescription => _tripDescription;
  List<String> get countries => _citiesInCountries?.keys?.toList();

  bool get isValid => _startDate != null && _endDate != null && _tripName != null;
  bool get hasCountries => _citiesInCountries != null && _citiesInCountries.keys.length > 0;

  void setTripName(String name) {
    _tripName = name;
    notifyListeners();
  }
  
  void setTripDescription(String description) {
    _tripDescription = description;
    notifyListeners();
  }

  void setStartDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _startDate == null ? DateTime.now() : _startDate,
      firstDate: DateTime.now(),
      lastDate: _endDate == null ? DateTime(2101) : _endDate
    );

    if (picked != null)
      _startDate = picked;

    notifyListeners();
  }

  void setEndDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _endDate != null ? _endDate 
        : (_startDate == null ? DateTime.now() : _startDate),
      firstDate: _startDate == null ? DateTime.now() : _startDate,
      lastDate: DateTime(2101)
    );

    if (picked != null)
      _endDate = picked;
      
    notifyListeners();
  }

  void setCountries(List<String> countries) {
    _citiesInCountries.removeWhere((key, val) => !countries.contains(key));

    countries.forEach((country) => _citiesInCountries[country] = []);
    notifyListeners();
  }

  void setCities(List<City> cities) {
    cities.forEach((city) { 
      if(_citiesInCountries.containsKey(city.country)) {
        _citiesInCountries[city.country].add(city);
      }
    });
    notifyListeners();
  }
  
  void submitData() async {
    _state = UiState.Loading;
    notifyListeners();

    final status = await _tripService.createTrip(
      Trip(
        tripName: _tripName, tripDesc: _tripDescription,
        startDate: _startDate, endDate: _endDate, destinations: _citiesInCountries,
        totalCost: 0, userId: Helpers.currUserId()
      )
    );

    _state = status.isSuccess ? UiState.Completed : UiState.Error;
    notifyListeners();
  }
}