import 'package:equatable/equatable.dart';
import 'package:world_wanders/business_logic/models/user_profile.dart';

class User extends Equatable {
  final UserProfile userProfile;
  final List<String> savedPlaces;

  User({
    this.userProfile, this.savedPlaces
  });

  @override
  List<Object> get props => [
    userProfile, savedPlaces
  ];

  factory User.fromJson(Map<dynamic, dynamic> json) => _userFromJson(json);
  Map<String, dynamic> toJson() => _userToJson(this);

}

//helpers
Map<String, dynamic> _userToJson(User user) {
  return <String, dynamic> {
    'userProfile': user.userProfile == null ? null
      : user.userProfile.toJson(),
    'savedPlaces': user.savedPlaces
  };
}

User _userFromJson(Map<dynamic, dynamic> json) =>
  User(
    userProfile: json['userProfile'] == null ? null
      : UserProfile.fromJson(json['userProfile']),
    savedPlaces: json['savedPlaces']
  );