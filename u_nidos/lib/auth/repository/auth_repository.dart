import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../shared_preferences.dart'; // Asegúrate de importar esto

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> register(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
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
      final user = userCredential.user;

      // 🔥 Nuevo bloque para guardar campus y universidad
      if (user != null) {
        final doc = await _firestore.collection('usuarios').doc(user.uid).get();
        final data = doc.data();
        if (data != null) {
          final campus = data['campus'];
          final universidad = data['universidad'];

          if (campus != null) {
            await SharedPrefsService.guardarCampus(campus);
            print('✅ Campus guardado en SharedPrefs: $campus');
          }
          if (universidad != null) {
            await SharedPrefsService.guardarUniversidad(universidad);
            print('✅ Universidad guardada en SharedPrefs: $universidad');
          }
        }
      }

      return user;
    } on FirebaseAuthException catch (e) {
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
