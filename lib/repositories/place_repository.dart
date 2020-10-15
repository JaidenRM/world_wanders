import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:world_wanders/models/place.dart';
import 'package:world_wanders/repositories/firebase_base.dart';
import 'package:world_wanders/services/logger.dart';
import 'package:world_wanders/utils/constants/firebase_constants.dart';

class PlaceRepository extends FirebaseDB {
  final Logger _logger;
  static const String _name = "PlaceRepository";

  PlaceRepository(String tripId)
    : _logger = getLogger(_name),
      super(
        FirebaseFirestore.instance
          .collection(FirebaseConstants.COL_TRIPS)
          .doc(tripId)
          .collection(FirebaseConstants.SUBCOL_PLACES)
      );

  Future<void> deletePlace(String id) {
    _logger.i("deleting place $id...");
    return cref.doc(id).delete()
      .then((value) => _logger.i("deleted place $id"))
      .catchError((e) => _logger.w("error occurred while trying to delete place $id"));
  }

  Stream<Place> getPlace(String id) {
    _logger.i("looking for place $id...");

    try {
      final mappedPlace = cref
        .doc(id)
        .get()
        .asStream()
        .map((dss) => Place.fromJson(dss.data()));
        
      _logger.i("place found!");
      return mappedPlace;
    } catch(e) {
      _logger.w("looking for place FAILED");
      return null;
    }
  }

  Stream<List<Place>> getPlaces() {
    _logger.i("looking for all places...");

    try {
      final mappedPlaces = cref
        .get()
        .asStream()
        .map((qs) => 
          qs.docs.map((doc) => Place.fromJson(doc.data())).toList()
        );
      
      _logger.i("Places found!");
      return mappedPlaces;
    } catch(e) {
      _logger.w("looking for all places FAILED");
      return null;
    }
    
  }

  Future<void> setPlace(Place place) {
    _logger.i("Setting place...");

    final empty = cref.add(place.toJson())
      .then((value) => _logger.i("Place set!"))
      .catchError((e) => _logger.w("Setting place FAILED!"));

    return empty;
  }
}