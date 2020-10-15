import 'package:world_wanders/models/user_profile.dart';
import 'package:world_wanders/utils/status.dart';

abstract class UserServiceInterface {
  Future<bool> hasProfile();

  Future<Status> setProfile(UserProfile profile);
  Future<UserProfile> getProfile();
}