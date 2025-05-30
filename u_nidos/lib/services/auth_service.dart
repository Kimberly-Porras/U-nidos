import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 🔍 Verifica si el nombre de usuario ya existe en Firestore
  Future<bool> usernameExists(String nombre) async {
    final query = await _firestore
        .collection('usuarios')
        .where('nombre', isEqualTo: nombre)
        .get();

    return query.docs.isNotEmpty;
  }

  /// 🔍 Verifica si el correo ya fue registrado (sin lanzar excepción)
  Future<bool> emailExists(String email) async {
    try {
      final methods = await _auth.fetchSignInMethodsForEmail(email);
      return methods.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// ✅ Registra un nuevo usuario en Firebase Auth y lo guarda en Firestore
  Future<void> registrarUsuario({
    required String email,
    required String password,
    required String nombre,
    required String universidad,
    required String campus,
    required String carrera,
    required int anioIngreso,
    required String habilidades,
    required DateTime fechaNacimiento,
    required List<String> intereses,
  }) async {
    bool existe = await usernameExists(nombre.trim());
    if (existe) {
      throw Exception("El nombre de usuario '$nombre' ya está en uso.");
    }

    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('usuarios').doc(cred.user!.uid).set({
        'uid': cred.user!.uid,
        'email': email,
        'nombre': nombre.trim(),
        'universidad': universidad,
        'campus': campus,
        'carrera': carrera,
        'anioIngreso': anioIngreso,
        'habilidades': habilidades,
        'fechaNacimiento': Timestamp.fromDate(fechaNacimiento),
        'intereses': intereses,
        'fechaRegistro': FieldValue.serverTimestamp(),
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception("El correo electrónico ya está en uso.");
      } else if (e.code == 'invalid-email') {
        throw Exception("El correo electrónico no es válido.");
      } else if (e.code == 'weak-password') {
        throw Exception("La contraseña es muy débil.");
      } else {
        throw Exception("Error en el registro: ${e.message}");
      }
    }
  }

  /// 🔐 Obtiene el usuario actualmente autenticado
  User? get usuarioActual => _auth.currentUser;

  /// 🔓 Cierra sesión del usuario actual
  Future<void> logout() async {
    await _auth.signOut();
  }

  /// 🔐 Inicia sesión con correo y contraseña
  Future<void> login(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }
}
