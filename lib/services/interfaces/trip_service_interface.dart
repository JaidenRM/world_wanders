import 'package:world_wanders/models/trip.dart';
import 'package:world_wanders/utils/status.dart';

abstract class TripServiceInterface {
  Future<Status> createTrip(Trip trip);
  //get trip view model with places and transport?
  Future<void> viewTrip(String tripId);
}