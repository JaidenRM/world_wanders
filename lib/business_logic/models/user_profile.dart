import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String firstName;
  final String lastName;
  final String username;
  final String email;

  UserProfile({ this.firstName, this.lastName, this.username, this.email });

  @override
  List<Object> get props => [
    firstName, lastName, username, email
  ];

  factory UserProfile.fromJson(Map<dynamic, dynamic> json) => _userProfileFromJson(json);
  Map<String, dynamic> toJson() => _userProfileToJson(this);

}

//helpers
Map<String, dynamic> _userProfileToJson(UserProfile userProfile) {
  return <String, dynamic> {
    'firstName': userProfile.firstName,
    'lastName': userProfile.lastName,
    'username': userProfile.username,
    'email': userProfile.email
  };
}

UserProfile _userProfileFromJson(Map<dynamic, dynamic> json) =>
  UserProfile(
    firstName: json['firstName'],
    lastName: json['lastName'],
    username: json['username'],
    email: json['email']
  );