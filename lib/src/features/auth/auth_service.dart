import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:easy_localization/easy_localization.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static const String kGoogleClientId =
      '277044426287-f3d30knm2pt3tkrdmeqund8k8f58nlec.apps.googleusercontent.com';

  static const List<String> _scopes = <String>[
    'https://www.googleapis.com/auth/userinfo.email',
    'https://www.googleapis.com/auth/userinfo.profile',
    'openid',
  ];

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  bool _isInit = false;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserCredential?> signInWithGoogle() async {
    try {
      if (!_isInit) {
        try {
          await _googleSignIn.initialize(serverClientId: kGoogleClientId);
        } catch (_) {}
        _isInit = true;
      }

      final GoogleSignInAccount account = await _googleSignIn.authenticate(
        scopeHint: _scopes,
      );

      final googleAuthentication = account.authentication;

      try {
        final googleAuthorization = await (account as dynamic)
            .authorizationClient
            .authorizationForScopes(_scopes);

        if (googleAuthorization == null) {
          throw FirebaseAuthException(
            code: 'auth/invalid-credential',
            message: tr('errors.auth_failed_authorization'),
          );
        }

        final credential = GoogleAuthProvider.credential(
          accessToken: (googleAuthorization as dynamic).accessToken,
          idToken: (googleAuthentication as dynamic).idToken,
        );

        final userCredential = await _auth.signInWithCredential(credential);
        return userCredential;
      } catch (_) {
        final credential = GoogleAuthProvider.credential(
          accessToken: (googleAuthentication as dynamic).accessToken,
          idToken: (googleAuthentication as dynamic).idToken,
        );
        final userCredential = await _auth.signInWithCredential(credential);
        return userCredential;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred;
  }

  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred;
  }

  Future<void> signOut() async {
    await _auth.signOut();
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
  }
}
