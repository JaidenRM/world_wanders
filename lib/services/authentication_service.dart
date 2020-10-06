import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:world_wanders/services/interfaces/authentication_service_interface.dart';
import 'package:world_wanders/services/logger.dart';
import 'package:world_wanders/utils/status.dart';

class AuthenticationService implements AuthenticationServiceInterface {
  final FirebaseAuth _fba;
  final Logger _logger;
  final GoogleSignIn _googleSignIn;
  static const String _name = "AuthenticationRepository";

  AuthenticationService()
    : _fba = FirebaseAuth.instance,
      _googleSignIn = GoogleSignIn(scopes: [ 
        'email', 'https://www.googleapis.com/auth/contacts.readonly',
      ]),
      _logger = getLogger(_name);

  Stream<User> get authStream => _fba.authStateChanges();
  
  Future<Status> signIn(String email, String password) async {
    try {
      final userCred = await _fba.signInWithEmailAndPassword(email: email, password: password);
      return Status('Signed in successfully!', true);
    } on FirebaseAuthException catch (e) {
      _logger.w('Signed in FAILED with FirebaseAuth code ${e.code}');
      return Status(e.message, false);
    } catch (e) {
      _logger.e('FAILED to sign in with error message: ${e.toString()}');
      return Status('Unknown error', false);
    }
  }

  Future<Status> signUp(String email, String password) async {
    try {
      final userCred = await _fba.createUserWithEmailAndPassword(email: email, password: password);
      return Status('Signed up successfully!', true);
    } on FirebaseAuthException catch (e) {
      _logger.w('Signed in FAILED with FirebaseAuth code ${e.code}');
      return Status(e.message, false);
    } catch (e) {
      _logger.e('FAILED to sign up with error message: ${e.toString()}');
      return Status('Unknown error', false);
    }
  }

  Future<void> signOut() {
    _logger.i('Signed out');
    return _fba.signOut();
  }

  bool isEmailVerified() {
    return _fba.currentUser.emailVerified;
  }

  bool isSignedIn() {
    return _fba.currentUser != null;
  }

  Future<void> sendEmailVerification() {
    _logger.i('Sending email verification...');
    final user = _fba.currentUser;

    if(user.emailVerified) {
      return user.sendEmailVerification();
    }
      
    _logger.w('User email is already verified');
    return null;
  }

  Future<void> signInWithGoogle() async {
    try {
      await _googleSignIn.signIn();
    } catch (e) {
      _logger.e(e.toString());
    }
  }

  Future<Status> verify(String code) async {
    try {
      await _fba.checkActionCode(code);
      await _fba.applyActionCode(code);

      _fba.currentUser.reload();
      return Status('Verified successfully!', true);
    } on FirebaseAuthException catch (e) {
      _logger.w('Verification FAILED with FirebaseAuth code ${e.code}');
      return Status(e.message, false);
    } catch (e) {
      _logger.e('FAILED to verify with error message: ${e.toString()}');
      return Status('Unknown error', false);
    }
  }

  //delete user
  //reauthenticate user
}