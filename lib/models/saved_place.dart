import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class SavedPlace extends Equatable {
  final String placeId;
  final String gPlusCode;
  final String name;
  final String address;
  final DateTime dateAdded;

  SavedPlace({
    this.placeId, this.gPlusCode, 
    this.name, this.address, this.dateAdded
  });

  @override
  List<Object> get props => [
    placeId, gPlusCode, name, address, dateAdded
  ];

  factory SavedPlace.fromJson(Map<dynamic, dynamic> json) => _savedPlaceFromJson(json);
  Map<String, dynamic> toJson() => _savedPlaceToJson(this);

}

//helpers
Map<String, dynamic> _savedPlaceToJson(SavedPlace savedPlace) {
  return <String, dynamic> {
    'placeId': savedPlace.placeId,
    'gPlusCode': savedPlace.gPlusCode,
    'name': savedPlace.name,
    'address': savedPlace.address,
    'dateAdded': savedPlace.dateAdded
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
  );