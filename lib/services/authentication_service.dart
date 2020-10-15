import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:world_wanders/models/user_profile.dart';
import 'package:world_wanders/repositories/user_repository.dart';
import 'package:world_wanders/services/interfaces/authentication_service_interface.dart';
import 'package:world_wanders/services/logger.dart';
import 'package:world_wanders/utils/status.dart';
import 'package:world_wanders/models/user.dart' as Model;

class AuthenticationService implements AuthenticationServiceInterface {
  final FirebaseAuth _fba;
  final UserRepository _userRepository = UserRepository();
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

  Future<Status> signUp(String email, String password, { UserProfile userProfile }) async {
    try {
      final userCred = await _fba.createUserWithEmailAndPassword(email: email, password: password);
      await _userRepository.setUser(Model.User(userProfile: userProfile), userCred.user.uid);
      return Status('Signed up successfully!', true);
    } on FirebaseAuthException catch (e) {
      _logger.w('Signed in FAILED with FirebaseAuth code ${e.code}');
      return Status(e.message, false);
    } catch (e) {
      _logger.e('FAILED to sign up with error message: ${e.toString()}');
      return Status('Unknown error', false);
    }
  }

  Future<void> signOut() async {
    _logger.i('Signed out');
    await _fba.signOut();
    return await _googleSignIn.signOut();
  }

  Future<bool> isEmailVerified() async {
    await _fba.currentUser?.reload();
    final emailv = _fba.currentUser?.emailVerified;
    return emailv ?? false;
  }

  bool isSignedIn() {
    return _fba.currentUser != null;
  }

  Future<void> sendEmailVerification() {
    _logger.i('Sending email verification...');
    final user = _fba.currentUser;

    if(user != null && !user.emailVerified) {
      return user.sendEmailVerification();
    }
      
    _logger.w('User email is already verified');
    return null;
  }

  Future<Status> signInWithGoogle() async {
    try {
      final UserRepository userRepository = UserRepository();
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken
        , accessToken: googleAuth.accessToken
      );

      final status = await _fba.signInWithCredential(credential);

      if(status.additionalUserInfo.isNewUser) {
        try {
          final names = status.user.displayName.split(' ');
          final Model.User user = Model.User(
            userProfile: UserProfile(
              firstName: names[0],
              lastName: names.length > 1 ? names[names.length-1] : '',
              email: status.user.email,
            ),
          ); 
          await userRepository.setUser(user, status.user.uid);
        } catch (e) {
          _logger.e('Google Sign In FAILED to create a new user with error message: ${e.toString()}');
          return Status('Something went wrong when trying to create an account with your Google profile', false);
        }
      }

      return Status('Signed in with Google successfully!', true);
    } on FirebaseAuthException catch (e) {
      _logger.w('Signed in with Google FAILED with FirebaseAuth code ${e.code}');
      return Status(e.message, false);
    } catch (e) {
      _logger.e('FAILED to sign in with Google with error message: ${e.toString()}');
      return Status('Unknown error', false);
    }
  }

  //Firebase email allows any pwd > 6 chars... need to think of whether to change pwd policy to
  //match this or make my own auth system... perhaps send a token to the email to verify and change pwd in app?
  Future<Status> sendEmailForgotPassword(String email) async {
    try {
      
      await _fba.sendPasswordResetEmail(email: email);
      return Status('Email sent successfully!', true);
    } on FirebaseAuthException catch (e) {
      _logger.w('Forgot Pwd FAILED with FirebaseAuth code ${e.code}');
      return Status(e.message, false);
    } catch (e) {
      _logger.e('FAILED to send password reset email with error message: ${e.toString()}');
      return Status('Unknown error', false);
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