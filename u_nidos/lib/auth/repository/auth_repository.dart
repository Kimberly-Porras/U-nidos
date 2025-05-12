import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> register(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // Manejo específico de errores al registrar
      if (e.code == 'email-already-in-use') {
        throw Exception('firebase_auth: Este correo ya está en uso');
      } else if (e.code == 'invalid-email') {
        throw Exception('firebase_auth: Correo electrónico no válido');
      } else if (e.code == 'weak-password') {
        throw Exception('firebase_auth: La contraseña es muy débil');
      } else {
        throw Exception('firebase_auth: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error desconocido al registrar usuario');
    }
  }

  Future<User?> login(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // Manejo específico de errores al iniciar sesión
      if (e.code == 'user-not-found') {
        throw Exception('firebase_auth: Usuario no registrado');
      } else if (e.code == 'wrong-password') {
        throw Exception('firebase_auth: Contraseña incorrecta');
      } else if (e.code == 'invalid-email') {
        throw Exception('firebase_auth: Correo electrónico no válido');
      } else if (e.code == 'user-disabled') {
        throw Exception('firebase_auth: Usuario deshabilitado');
      } else {
        throw Exception('firebase_auth: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error desconocido al iniciar sesión');
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
