import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:world_wanders/models/city.dart';
import 'package:world_wanders/utils/constants/route_constants.dart';

mixin DestinationsMixin {
  List<City> _cities = [];
  int _hdrCity = 0, _hdrState = 1, _hdrCountry = 2, _hdrCoords = 5;

  List<City> get cities => _cities;
  
  Future<void> loadData() async {
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

  List<City> getSortedCities({ bool sortInAsc = true }) {
    if(_cities == null)
      return null;

    return _sortCities(_cities, sortInAsc);
  }

  List<String> getCountries() {
    return _cities.fold<List<String>>([], (countries, city) {
      if(!countries.contains(city.country))
        countries.add(city.country);

      return countries;
    });
  }

  List<String> getSortedCountries({ bool sortInAsc = true }) {
    _cities = getSortedCities(sortInAsc: sortInAsc);
    return getCountries();
  }

  List<City> getCitiesInCountry(String country) {
    return _cities.fold<List<City>>([], (cities, city) {
      if(city.country == country)
        cities.add(city);
      
      return cities;
    });
  }

  List<City> getSortedCitiesInCountry(String country, { bool sortInAsc = true }) {
    var cities = getCitiesInCountry(country);
    return _sortCities(cities, sortInAsc);
  }

  List<City> getCitiesInCountries(List<String> countries) {
    return _cities.fold<List<City>>([], (cities, city) {
      if(countries.contains(city.country))
        cities.add(city);
      
      return cities;
    });
  }

  List<City> getSortedCitiesInCountries(List<String> countries, { bool sortInAsc = true }) {
    var cities = getCitiesInCountries(countries);
    return _sortCities(cities, sortInAsc);
  }

  List<City> _sortCities(List<City> cities, bool isAsc) {
    
    if(cities != null) {
      cities.sort((prev, curr) {
        int sortOrder = isAsc ? 1 : -1;
        var cmpCountry = prev.country.compareTo(curr.country) * sortOrder;
        if(cmpCountry != 0) return cmpCountry;

        var cmpCity = prev.name.compareTo(curr.name) * sortOrder;
        if(cmpCity != 0) return cmpCity;

        return prev.state.compareTo(curr.state) * sortOrder;
      });
    }

    return cities;
  }
}