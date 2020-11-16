import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:world_wanders/models/transport.dart';
import 'package:world_wanders/repositories/firebase_base.dart';
import 'package:world_wanders/services/logger.dart';
import 'package:world_wanders/utils/constants/firebase_constants.dart';

class TransportRepository extends FirebaseDB {
  final Logger _logger;
  static const String _name = "TransportRepository";

  TransportRepository(String tripId)
    : _logger = getLogger(_name),
      super(
        FirebaseFirestore.instance
          .collection(FirebaseConstants.COL_TRIPS)
          .doc(tripId)
          .collection(FirebaseConstants.SUBCOL_TRANSPORT)
      );

  Future<void> deleteTransport(String id) {
    _logger.i("deleting transport $id...");
    return cref.doc(id).delete()
      .then((value) => _logger.i("deleted transport $id"))
      .catchError((e) => _logger.w("error occurred while trying to delete transport $id"));
  }

  Future<Transport> getTransport(String id) async {
    _logger.i("looking for transport $id...");

    try {
      final transport = await cref
        .doc(id)
        .get();
        
      _logger.i("transport found!");
      return Transport.fromJson(transport.data());
    } catch(e) {
      _logger.w("looking for transport FAILED");
      return null;
    }
  }

  Future<List<Transport>> getTransports() {
    _logger.i("looking for all transports...");

    try {
      final mappedTransports = cref
        .get()
        .then((qs) => 
          qs.docs.map((doc) => Transport.fromJson(doc.data())).toList()
        );
      
      _logger.i("Transports found!");
      return mappedTransports;
    } catch(e) {
      _logger.w("looking for all transports FAILED");
      return null;
    }
    
  }

  Future<void> setTransport(Transport transport) {
    _logger.i("Setting transport...");

    final empty = cref.add(transport.toJson())
      .then((value) => _logger.i("Transport set!"))
      .catchError((e) => _logger.w("Setting transport FAILED!"));

    return empty;
  }
}