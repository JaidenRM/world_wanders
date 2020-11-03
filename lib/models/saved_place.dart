import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:world_wanders/models/places_widget_interface.dart';
import 'package:world_wanders/ui/screens/components/saved_place_list_tile.dart';

class SavedPlace extends PlacesWidget {
  final String gPlusCode;
  final String name;
  final String address;
  final DateTime dateAdded;

  SavedPlace({
    String placeId, LatLng location, this.gPlusCode, 
    this.name, this.address, this.dateAdded
  })
    : super(placeId, location);

  @override
  List<Object> get props => [
    placeId, gPlusCode, name, address, dateAdded
  ];

  factory SavedPlace.fromJson(Map<dynamic, dynamic> json) => _savedPlaceFromJson(json);
  Map<String, dynamic> toJson() => _savedPlaceToJson(this);

  @override
  Widget toListTile(BuildContext context) {
    return SavedPlaceListTile(savedPlace: this);
  }

}

//helpers
Map<String, dynamic> _savedPlaceToJson(SavedPlace savedPlace) {
  return <String, dynamic> {
    'placeId': savedPlace.placeId,
    'gPlusCode': savedPlace.gPlusCode,
    'name': savedPlace.name,
    'address': savedPlace.address,
    'dateAdded': savedPlace.dateAdded,
    'location': GeoPoint(savedPlace.location.latitude, savedPlace.location.longitude),
  };
}

SavedPlace _savedPlaceFromJson(Map<dynamic, dynamic> json) =>
  SavedPlace(
    placeId: json['placeId'],
    gPlusCode: json['gPlusCode'],
    name: json['name'],
    address: json['address'],
    dateAdded: json['dateAdded'] == null ? null
      : (json['dateAdded'] as Timestamp).toDate(),
    location: json['location'] == null ? null
      : LatLng((json['location'] as GeoPoint).latitude, (json['location'] as GeoPoint).longitude),
  );