import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:world_wanders/models/google_place.dart';
import 'package:world_wanders/models/saved_place.dart';
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

  Model.User _currUser;
  StreamSubscription<Model.User> _userSubscription;

  UserService()
    : _fba = FirebaseAuth.instance,
      _userRepository = UserRepository(),
      _logger = getLogger(_name) 
    {
      _userSubscription = 
        currUserStream()?.listen((user) { 
          _currUser = user;
        });
    }

  @override
  Future<bool> hasProfile() async {
    final user = await getUser();

    return user?.userProfile != null;
  }

  @override
  Future<UserProfile> getProfile() async {
    final user = await getUser();

    return user?.userProfile;
  }

  @override
  Future<Status> setProfile(UserProfile profile) async {
    final user = await getUser();
    final uid = _fba.currentUser.uid;

    if(user == null)
      return Status('Could not get current user', false);
    
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

  @override
  Future<List<SavedPlace>> getSavedPlaces() async {
    final user = await getUser();

    return user?.savedPlaces;
  }

  @override
  Future<Status> removePlace(String placeId) async {
    final user = await getUser();
    final uid = _fba.currentUser.uid;

    if(!user.savedPlaces.any((place) => place.placeId == placeId))
      return Status('No saved places with this id found', false);

    user.savedPlaces.removeWhere((place) => place.placeId == placeId);

    return _userRepository.setUser(Model.User(
      savedPlaces: user?.savedPlaces,
      userProfile: user?.userProfile,
    ), uid)
      .then((value) {
        _logger.i('User set!');
        return Status('Place removed successfully!', true);
      })
      .catchError((e) {
        _logger.e('Setting user FAILED with ${e.toString()}');
        return Status('Place failed to remove', false);
      });
  }

  @override
  Future<Status> savePlace(GooglePlace gPlace) async {
    final user = await getUser();
    final uid = _fba.currentUser.uid;
    final sPlace = SavedPlace(
      address: gPlace.address ?? gPlace.vicinity,
      name: gPlace.name,
      placeId: gPlace.placeId,
      location: gPlace.location,
      gPlusCode: gPlace.plusCodeGlobal,
      dateAdded: DateTime.now(),
    );

    return _userRepository.setUser(Model.User(
      savedPlaces: [sPlace, ...user?.savedPlaces ?? []],
      userProfile: user?.userProfile,
    ), uid, isMerge: true)
      .then((value) {
        _logger.i('User set!');
        return Status('Place saved successfully!', true);
      })
      .catchError((e) {
        _logger.e('Setting user FAILED with ${e.toString()}');
        return Status('Place failed to save', false);
      });
    
  }

  @override
  Stream<Model.User> currUserStream() {
    final uid = _fba.currentUser?.uid;

    return _userRepository.userStream(uid).map((event) {
      if(event.exists) {
        return Model.User.fromJson(event.data());
      }

      return null;
    });
  }

  @override
  Future<Model.User> getUser() async {
    if(_currUser == null) {
      final uid = _fba.currentUser?.uid;
      return await _userRepository.getUser(uid);
    }

    return _currUser;
  }

}