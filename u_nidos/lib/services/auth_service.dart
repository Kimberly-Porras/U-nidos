import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Crear usuario y guardar su información en Firestore
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
    // Registrar en Firebase Auth
    UserCredential cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Guardar en Firestore
    await _firestore.collection('usuarios').doc(cred.user!.uid).set({
      'uid': cred.user!.uid,
      'email': email,
      'nombre': nombre,
      'universidad': universidad,
      'campus': campus,
      'carrera': carrera,
      'anioIngreso': anioIngreso,
      'habilidades': habilidades,
      'fechaNacimiento': Timestamp.fromDate(fechaNacimiento),
      'intereses': intereses,
      'fechaRegistro': FieldValue.serverTimestamp(),
    });
  }

  // Obtener usuario autenticado
  User? get usuarioActual => _auth.currentUser;

  // Cerrar sesión
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Iniciar sesión (si quisieras agregarlo)
  Future<void> login(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }
}
