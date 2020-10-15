import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FirebaseDB {
  //define any helpers here
  final CollectionReference cref;

  FirebaseDB(this.cref);
  //change to concrete if needed

}