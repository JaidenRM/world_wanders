import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:world_wanders/business_logic/models/user.dart';
import 'package:world_wanders/repositories/firebase_base.dart';
import 'package:world_wanders/services/logger.dart';
import 'package:world_wanders/utils/constants/firebase_constants.dart';

class UserRepository extends FirebaseDB {
  final Logger _logger;
  static const String _name = "UserRepository";

  UserRepository()
    : _logger = getLogger(_name),
      super(
        FirebaseFirestore.instance
          .collection(FirebaseConstants.COL_USERS)
      );

  Future<void> deleteUser(String id) {
    _logger.i("deleting user $id...");
    return cref.doc(id).delete()
      .then((value) => _logger.i("deleted user $id"))
      .catchError((e) => _logger.w("error occurred while trying to delete user $id"));
  }

  Stream<User> getUser(String id) {
    _logger.i("looking for user $id...");

    try {
      final mappedUser = cref
        .doc(id)
        .get()
        .asStream()
        .map((dss) => User.fromJson(dss.data()));
        
      _logger.i("user found!");
      return mappedUser;
    } catch(e) {
      _logger.w("looking for user FAILED");
      return null;
    }
  }

  Future<void> setUser(User user) {
    _logger.i("Setting user...");

    final empty = cref.add(user.toJson())
      .then((value) => _logger.i("User set!"))
      .catchError((e) => _logger.w("Setting user FAILED!"));

    return empty;
  }
}