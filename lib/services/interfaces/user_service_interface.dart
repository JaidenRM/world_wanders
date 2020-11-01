import 'package:world_wanders/models/google_place.dart';
import 'package:world_wanders/models/saved_place.dart';
import 'package:world_wanders/models/user.dart';
import 'package:world_wanders/models/user_profile.dart';
import 'package:world_wanders/utils/status.dart';

abstract class UserServiceInterface {
  Future<bool> hasProfile();
  Stream<User> currUserStream();

  Future<Status> setProfile(UserProfile profile);
  Future<UserProfile> getProfile();
  Future<List<SavedPlace>> getSavedPlaces();
  Future<Status> savePlace(GooglePlace gPlace);
  Future<Status> removePlace(String placeId);
  Future<User> getUser();
}