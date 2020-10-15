//can branch out the type into children for more specific variables for the type
//can be different as we are using nosql db
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Transport extends Equatable {
  final String tripId;
  final String placeId;

  final String type;
  final double cost;
  final DateTime startTime;
  final DateTime endTime;
  final GeoPoint startLocation;
  final GeoPoint endLocation;

  Transport({
    this.tripId, this.placeId, this.type, this.cost, this.startTime,
    this.endTime, this.startLocation, this.endLocation
  });

  @override
  List<Object> get props => [
    tripId, placeId, type, cost, startTime, 
    endTime, startLocation, endLocation
  ];

  factory Transport.fromJson(Map<dynamic, dynamic> json) => _transportFromJson(json);
  Map<String, dynamic> toJson() => _transportToJson(this);
  
}

//helpers
Map<String, dynamic> _transportToJson(Transport transport) {
  return <String, dynamic> {
    'tripId': transport.tripId,
    'placeId': transport.placeId,
    'type': transport.type,
    'cost': transport.cost,
    'startTime': transport.startTime,
    'endTime': transport.endTime,
    'startLocation': transport.startLocation,
    'endLocation': transport.endLocation
  };
}

Transport _transportFromJson(Map<dynamic, dynamic> json) =>
  Transport(
    tripId: json['tripId'],
    placeId: json['placeId'],
    type: json['type'],
    cost: json['cost'],
    startTime: json['startTime'] == null ? null
      : (json['startTime'] as Timestamp).toDate(),
    endTime: json['endTime'] == null ? null
      : (json['endTime'] as Timestamp).toDate(),
    startLocation: json['startLocation'],
    endLocation: json['endLocation']
  );