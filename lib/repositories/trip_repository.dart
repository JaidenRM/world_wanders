import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:world_wanders/models/trip.dart';
import 'package:world_wanders/repositories/firebase_base.dart';
import 'package:world_wanders/services/logger.dart';
import 'package:world_wanders/utils/constants/firebase_constants.dart';

//N.B.: this will contain subcollections so be careful with deleting these
class TripRepository extends FirebaseDB {
  final Logger _logger;
  final String _userId;
  static const String _name = "TripRepository";

  TripRepository(String userId)
    : assert(userId != null),
      _userId = userId,
      _logger = getLogger(_name),
      super(
        FirebaseFirestore.instance
          .collection(FirebaseConstants.COL_TRIPS)
      );
  
  //delete subcollections first!
  //look into transactions!
  Future<void> deleteTrip(String id) {
    _logger.i("deleting trip $id...");

    final tripCol = cref.doc(id);
    int cntPlaces = 0, cntTransport = 0;

    //using transaction incase something goes wrong during the process then we can undo everything
    return FirebaseFirestore.instance.runTransaction((trans) async {
      //reads must be completed first!
      final scPlaces = await tripCol.collection(FirebaseConstants.SUBCOL_PLACES).get();
      final scTransport = await tripCol.collection(FirebaseConstants.SUBCOL_TRANSPORT).get();

      //start deleting and counting how many we delete for log reference
      _logger.i("deleting trip places...");
      scPlaces.docs.forEach((doc) { trans.delete(doc.reference); cntPlaces++; });
      _logger.i("deleting trip transport...");
      scTransport.docs.forEach((doc) { trans.delete(doc.reference); cntTransport++; });
      trans.delete(tripCol);
    })
      .then((value) => _logger.i("deleted $cntPlaces places, $cntTransport transport and trip $id!"))
      .catchError((e) => _logger.w("transaction to delete FAILED after completing $cntPlaces places and $cntTransport transport"));
  }

  Stream<Trip> getTrip(String id) {
    _logger.i("looking for trip $id...");

    try {
      final mappedTrip = cref
        .doc(id)
        .get()
        .asStream()
        .map((dss) => Trip.fromJson(dss.data()));
        
      _logger.i("trip found!");
      return mappedTrip;
    } catch(e) {
      _logger.w("looking for trip FAILED");
      return null;
    }
  }

  //think about making sure only get user trips!
  Stream<List<Trip>> getTrips() {
    _logger.i("looking for all trips...");

    try {
      final mappedTrips = cref
        .where('userId', isEqualTo: _userId) //ensure only user trips accessed
        .get()
        .asStream()
        .map((qs) => 
          qs.docs.map((doc) => Trip.fromJson(doc.data())).toList()
        );
      
      _logger.i("Trips found!");
      return mappedTrips;
    } catch(e) {
      _logger.w("looking for all trips FAILED");
      return null;
    }
    
  }

  Future<void> setTrip(Trip trip) {
    _logger.i("Setting trip...");

    final empty = cref.add(trip.toJson())
      .then((value) => _logger.i("Trip set!"))
      .catchError((e) => _logger.w("Setting trip FAILED!"));

    return empty;
  }
}