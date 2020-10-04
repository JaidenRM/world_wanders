//can branch out the type into children for more specific variables for the type
//can be different as we are using nosql db
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Place extends Equatable {
  final String tripId;
  
  final String type;
  final GeoPoint coords;
  final String country;
  final String state;
  final String name;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final double cost;

  Place({
    this.tripId, this.type, this.coords, this.country, this.state,
    this.name, this.description, this.startTime, this.endTime, this.cost
  });
  
  @override
  List<Object> get props => [
    tripId, type, coords, country, state, name, 
    description, startTime, endTime, cost
  ];

  factory Place.fromJson(Map<dynamic, dynamic> json) => _placeFromJson(json);
  Map<String, dynamic> toJson() => _placeToJson(this);

  
}

//helpers
Map<String, dynamic> _placeToJson(Place place) {
  return <String, dynamic> {
    'tripId': place.tripId,
    'type': place.type,
    'coords': place.coords,
    'country': place.country,
    'state': place.state,
    'name': place.name,
    'description': place.description,
    'startTime': place.startTime,
    'endTime': place.endTime,
    'cost': place.cost
  };
}

Place _placeFromJson(Map<dynamic, dynamic> json) =>
  Place(
    tripId: json['tripId'],
    type: json['type'],
    coords: json['coords'],
    country: json['country'],
    state: json['state'],
    name: json['name'],
    description: json['description'],
    startTime: json['startTime'] == null ? null : (json['startTime'] as Timestamp).toDate(),
    endTime: json['endTime'] == null ? null : (json['endTime'] as Timestamp).toDate(),
    cost: json['cost']
  );