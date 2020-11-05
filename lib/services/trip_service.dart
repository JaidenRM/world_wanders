import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:world_wanders/models/trip.dart';
import 'package:world_wanders/repositories/trip_repository.dart';
import 'package:world_wanders/services/interfaces/trip_service_interface.dart';
import 'package:world_wanders/services/logger.dart';
import 'package:world_wanders/utils/helpers.dart';
import 'package:world_wanders/utils/status.dart';

class TripService extends TripServiceInterface {
  final TripRepository _tripRepository;
  final Logger _logger;
  static const String _name = "TripService";

  TripService() 
    : _logger = getLogger(_name),
      _tripRepository = TripRepository(Helpers.currUserId());

  @override
  Future<Status> createTrip(Trip trip) async {
    if(trip == null)
      return Status('No trip was detected to add', false);

    return _tripRepository.addTrip(trip)
      .then((value) {
        _logger.i('Trip added successfully with id (${value.id})');
        return Status(value.id, true);
      })
      .catchError((e) {
        _logger.e('FAILED to add new trip with error message: ${e.toString()}');
        return Status('Failed to add new trip', false);
      });
  }

}