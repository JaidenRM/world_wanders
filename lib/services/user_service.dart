import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:world_wanders/models/user_profile.dart';
import 'package:world_wanders/repositories/user_repository.dart';
import 'package:world_wanders/services/interfaces/user_service_interface.dart';
import 'package:world_wanders/services/logger.dart';
import 'package:world_wanders/utils/status.dart';
import 'package:world_wanders/models/user.dart' as Model;

class UserService implements UserServiceInterface {
  final FirebaseAuth _fba;
  final Logger _logger;
  final UserRepository _userRepository;
  static const String _name = "UserService";

  UserService()
    : _fba = FirebaseAuth.instance,
      _userRepository = UserRepository(),
      _logger = getLogger(_name);

  @override
  Future<bool> hasProfile() async {
    final user = await _getUser();

    return user?.userProfile != null;
  }

  @override
  Future<UserProfile> getProfile() async {
    final user = await _getUser();

    return user?.userProfile;
  }

  @override
  Future<Status> setProfile(UserProfile profile) async {
    final user = await _getUser();
    final uid = _fba.currentUser.uid;

    // if(user == null)
    //   return Status('Could not get current user', false);
    
    return _userRepository.setUser(Model.User(
      savedPlaces: user?.savedPlaces,
      userProfile: profile,  
    ), uid)
      .then((value) {
        _logger.i('User set!');
        return Status('Profile saved successfully!', true);
      })
      .catchError((e) {
        _logger.e('Setting user FAILED with ${e.toString()}');
        return Status('Profile failed to save', false);
      });
  }

  Future<Model.User> _getUser() {
    final uid = _fba.currentUser?.uid;

    return _userRepository.getUser(uid);
  }
}