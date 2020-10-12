import 'package:firebase_auth/firebase_auth.dart';
import 'package:world_wanders/utils/status.dart';

abstract class AuthenticationServiceInterface {
  bool isSignedIn();
  
  Future<bool> isEmailVerified();
  Future<Status> signIn(String email, String password);
  Future<Status> signUp(String email, String password);
  Future<Status> verify(String code);
  Future<void> signInWithGoogle();
  Future<void> signOut();
  Future<void> sendEmailVerification();

  Stream<User> get authStream;
}