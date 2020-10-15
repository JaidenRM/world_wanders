import 'package:firebase_auth/firebase_auth.dart';
import 'package:world_wanders/models/user_profile.dart';
import 'package:world_wanders/utils/status.dart';

abstract class AuthenticationServiceInterface {
  bool isSignedIn();
  
  Future<bool> isEmailVerified();
  Future<Status> signIn(String email, String password);
  Future<Status> signUp(String email, String password, { UserProfile userProfile });
  Future<Status> verify(String code);
  Future<Status> signInWithGoogle();
  Future<void> signOut();
  Future<void> sendEmailVerification();
  Future<Status> sendEmailForgotPassword(String email);

  Stream<User> get authStream;
}