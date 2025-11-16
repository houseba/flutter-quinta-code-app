import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  bool _initialized = false;

  Future<void> _ensureInitialized() async {
    if (_initialized) {
      return;
    }
    await _googleSignIn.initialize(
      serverClientId: '118517688599-oidd1tgj3hq3si3oof0m20s19themv75.apps.googleusercontent.com',
    );
    _initialized = true;
  }

  Future <void> handleSignIn() async {
    try {
      // v7+: inicializar antes de cualquier operación
      await _ensureInitialized();
      
      final GoogleSignInAccount? googleUser = await _googleSignIn.authenticate();

      // Si la autenticación se cancela, googleUser será null
      if (googleUser == null) {
        return;
      }
      // Obtener los tokens de autenticación
      final GoogleSignInAuthentication googleTokens = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        // accessToken: googleTokens.accessToken, # al parecer no se usa más
        idToken: googleTokens.idToken,
      );
      // Iniciar sesión en Firebase con las credenciales de Google
      await _auth.signInWithCredential(credential);

    } on GoogleSignInException catch (e) {
      print('ERROR: ${e.code}');
      return;
    
    } on FirebaseAuthException catch (e) {
      print('ERROR: ${e.message}');
      return;
    }
  }

  // Método para cerrar sesión de Google y Firebase
  GoogleSignOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}