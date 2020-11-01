import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:world_wanders/models/city.dart';
import 'package:world_wanders/utils/constants/route_constants.dart';

class PredefinedLocations {
  List<City> _cities;
  int _hdrCity = 0, _hdrState = 1, _hdrCountry = 2, _hdrCoords = 5;
  
  Future<void> initData() async {
    var csv = await rootBundle.loadString(RouteConstants.ASSET_CSV_LOCATIONS);
    var csvList = const CsvToListConverter().convert(csv);
    _convertCsvListToCitiesList(csvList);
  }

  void _convertCsvListToCitiesList(List<List<dynamic>> csvList) {
    if(csvList == null || csvList.length < 2) 
      return;

    csvList.removeAt(0);
    _cities = [];
    csvList.forEach((city) { 
      if(city.length > _hdrCoords) {
        _cities.add(City(
          name: city[_hdrCity],
          state: city[_hdrState],
          country: city[_hdrCountry],
          coords: city[_hdrCoords]
        ));
      }
    });
  }

  Future<List<City>> getCities() async {
    if(_cities == null)
      await initData();

    return _cities;
  }
}