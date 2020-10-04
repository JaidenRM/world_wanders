import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Trip extends Equatable {
  final List<String> places;
  final List<String> transport;

  final String tripName;
  final DateTime startDate;
  final DateTime endDate;
  final Map<String, List<String>> locations; //or map { country: [state, state, ..], .. }
  final double totalCost;

  Trip({
    this.places, this.transport, this.tripName, this.startDate,
    this.endDate, this.locations, this.totalCost
  });

  @override
  List<Object> get props => [
    places, transport, tripName, startDate, endDate,
    locations, totalCost
  ];

  factory Trip.fromJson(Map<dynamic, dynamic> json) => _tripFromJson(json);
  Map<String, dynamic> toJson() => _tripToJson(this);

}

//helpers
Map<String, dynamic> _tripToJson(Trip trip) {
  return <String, dynamic> {
    'places': trip.places,
    'transport': trip.transport,
    'tripName': trip.tripName,
    'startDate': trip.startDate,
    'endDate': trip.endDate,
    'locations': trip.locations,
    'totalCost': trip.totalCost
  };
}

Trip _tripFromJson(Map<dynamic, dynamic> json) =>
  Trip(
    places: json['places'],
    transport: json['transport'],
    tripName: json['tripName'],
    startDate: json['startDate'] == null ? null
      : (json['startDate'] as Timestamp).toDate(),
    endDate: json['endDate'] == null ? null
      : (json['endDate'] as Timestamp).toDate(),
    locations: json['locations'],
    totalCost: json['totalCost']
  );