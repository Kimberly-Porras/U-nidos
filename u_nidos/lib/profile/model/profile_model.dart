import 'package:cloud_firestore/cloud_firestore.dart';

class UsuarioModel {
  final String uid;
  final String nombre;
  final String carrera;
  final String campus;
  final String email;
  final String habilidades;
  final DateTime? fechaNacimiento;

  UsuarioModel({
    required this.uid,
    required this.nombre,
    required this.carrera,
    required this.campus,
    required this.email,
    required this.habilidades,
    this.fechaNacimiento,
  });

  factory UsuarioModel.fromMap(Map<String, dynamic> map, String uid) {
    return UsuarioModel(
      uid: uid,
      nombre: (map['nombre'] ?? '').toString().trim(),
      carrera: (map['carrera'] ?? '').toString().trim(),
      campus: (map['campus'] ?? '').toString().trim(),
      email: (map['email'] ?? '').toString().trim(),
      habilidades: (map['habilidades'] ?? '').toString().trim(),
      fechaNacimiento:
          map['fechaNacimiento'] != null
              ? (map['fechaNacimiento'] as Timestamp).toDate()
              : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'carrera': carrera,
      'campus': campus,
      'email': email,
      'habilidades': habilidades,
      'fechaNacimiento': fechaNacimiento,
    };
  }
}
