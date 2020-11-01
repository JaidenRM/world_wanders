import 'package:equatable/equatable.dart';
import 'package:world_wanders/models/saved_place.dart';
import 'package:world_wanders/models/user_profile.dart';

class User extends Equatable {
  final UserProfile userProfile;
  final List<SavedPlace> savedPlaces;

  User({
    this.userProfile, this.savedPlaces
  });

  @override
  List<Object> get props => [
    userProfile, savedPlaces
  ];

  factory User.fromJson(Map<dynamic, dynamic> json) => _userFromJson(json);
  Map<String, dynamic> toJson() {var x = _userToJson(this);
    return x;}

}

//helpers
Map<String, dynamic> _userToJson(User user) {
  return <String, dynamic> {
    'userProfile': user.userProfile == null ? null
      : user.userProfile.toJson(),
    'savedPlaces': user.savedPlaces.map((place) => place.toJson()).toList(),
  };
}

User _userFromJson(Map<dynamic, dynamic> json) =>
  User(
    userProfile: json['userProfile'] == null ? null
      : UserProfile.fromJson(json['userProfile']),
    savedPlaces: (json['savedPlaces'] as List).map((json) => SavedPlace.fromJson(json)).toList()
  );