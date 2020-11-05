import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class City extends Equatable {
  final String name;
  final String state;
  final String country;
  final String coords;
  final LatLng latlng;

  @override
  List<Object> get props => [name, state, country, coords, latlng];

  City({
    @required this.name, this.state,
    @required this.country, @required this.coords
  })
    : assert(name != null && country != null && coords != null && coords.split(' ').length == 2),
      latlng = convertDegreesToLatLng(coords.split(' ')[0], coords.split(' ')[1]);

  static LatLng convertDegreesToLatLng(String latCoords, String lngCoords) {
    final degreeSymbols = ['°', '′', '″'];
    final negLat = 'S', negLng = 'W';

    var lat = 0.0, lng = 0.0;

    degreeSymbols.forEach((symbol) { 
      var splitLat = latCoords.split(symbol);
      var splitLng = lngCoords.split(symbol);

      if(splitLat.length > 1) {

        lat += _convertDegreeSymbolToDecimal(
          double.tryParse(splitLat[0]) ?? 0,
          symbol
        );

        latCoords = splitLat[1];
      }
      
      if(splitLng.length > 1) {

        lng += _convertDegreeSymbolToDecimal(
          double.tryParse(splitLng[0]) ?? 0,
          symbol
        );

        lngCoords = splitLng[1];
      }
    });

    lat = latCoords.contains(negLat) ? -lat : lat;
    lng = lngCoords.contains(negLng) ? -lng : lng;

    return LatLng(lat, lng);
  }

  static double _convertDegreeSymbolToDecimal(double number, String symbol) {
    if(symbol == '′')
      return number / 60;
    if(symbol == '″')
      return number / 3600;

    return number;
  }

  factory City.fromJson(Map<dynamic, dynamic> json) => _cityFromJson(json);
  Map<String, dynamic> toJson() => _cityToJson(this);

  
}

//helpers
Map<String, dynamic> _cityToJson(City city) {
  return <String, dynamic> {
    'name': city.name,
    'state': city.state,
    'country': city.country,
    'coords': city.coords,
    'latlng': GeoPoint(city.latlng.latitude, city.latlng.longitude),
  };
}

City _cityFromJson(Map<dynamic, dynamic> json) =>
  City(
    name: json['name'],
    state: json['state'],
    country: json['country'],
    coords: json['coords'],
  );