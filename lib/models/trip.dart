import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:world_wanders/models/city.dart';
import 'package:world_wanders/models/place.dart';
import 'package:world_wanders/models/transport.dart';

class Trip extends Equatable {
  final List<Place> recentPlaces;
  final List<Transport> recentTransport;
  final String userId;

  final String tripName;
  final String tripDesc;
  final DateTime startDate;
  final DateTime endDate;
  final Map<String, List<City>> destinations; //or map { country: [state, state, ..], .. }
  final double totalCost;

  Trip({
    this.recentPlaces, this.recentTransport, this.tripName, this.startDate,
    this.endDate, this.destinations, this.totalCost, this.userId, this.tripDesc
  });

  @override
  List<Object> get props => [
    recentPlaces, recentTransport, tripName, startDate, endDate,
    destinations, totalCost, tripDesc
  ];

  factory Trip.fromJson(Map<dynamic, dynamic> json) => _tripFromJson(json);
  Map<String, dynamic> toJson() => _tripToJson(this);

}

//helpers
Map<String, dynamic> _tripToJson(Trip trip) {
  return <String, dynamic> {
    'places': trip.recentPlaces == null ? null
      : trip.recentPlaces.map((place) => place.toJson()),
    'transport': trip.recentTransport == null ? null
      : trip.recentTransport.map((transport) => transport.toJson()),
    'userId': trip.userId,
    'tripName': trip.tripName,
    'tripDesc': trip.tripDesc,
    'startDate': trip.startDate,
    'endDate': trip.endDate,
    'locations': trip.destinations == null ? null
      : trip.destinations.map((key, value) => MapEntry(key, value.map((city) => city.toJson()).toList())),
    'totalCost': trip.totalCost
  };
}

Trip _tripFromJson(Map<dynamic, dynamic> json) =>
  Trip(
    recentPlaces: json['places'],
    recentTransport: json['transport'],
    userId: json['userId'],
    tripName: json['tripName'],
    tripDesc: json['tripDesc'],
    startDate: json['startDate'] == null ? null
      : (json['startDate'] as Timestamp).toDate(),
    endDate: json['endDate'] == null ? null
      : (json['endDate'] as Timestamp).toDate(),
    destinations: json['locations'],
    totalCost: json['totalCost']
  );