import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  // Connexion avec le compte gmail
  Future<UserCredential> signInWithGoogle() async {
    // Déclencher le flux d'authentification
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();

    // Obtenir les détails d'autorisation de la demande
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Créer un nouvel identifiant
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Une fois connecté, renvoyez l'indentifiant de l'utilisateur
    return await _auth.signInWithCredential(credential);
  }

  Stream<User?> get user => _auth.authStateChanges();

  // Déconnexion
  Future<void> signOut() async {
    await googleSignIn.signOut();
    await _auth.signOut();
  }
}
