import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleAuthProvider googleProvider = GoogleAuthProvider();

  // Connexion avec le Google
  Future<UserCredential> signInWithGoogle() async {
    if (kIsWeb) return await _auth.signInWithPopup(googleProvider);

    // Déclencher le flux d'authentification
    final googleUser = await _googleSignIn.signIn();

    // obtenir les détails d'autorisation de la demande
    final googleAuth = await googleUser!.authentication;

    // créer un nouvel identifiant
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // une fois connecté, renvoyez l'indentifiant de l'utilisateur
    return await _auth.signInWithCredential(credential);
  }

  // l'état de l'utilisateur en temps réel
  Stream<User?> get user => _auth.authStateChanges();

  // déconnexion
  Future<void> signOut() async {
    _googleSignIn.signOut();
    return _auth.signOut();
  }
}
