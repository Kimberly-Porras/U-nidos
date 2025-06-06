import 'package:cloud_firestore/cloud_firestore.dart';

class UsuarioModel {
  final String uid;
  final String nombre;
  final String carrera;
  final String campus;
  final String email;
  final String habilidades;
  final DateTime? fechaNacimiento;
  final int anioIngreso;
  final List<String> intereses;

  UsuarioModel({
    required this.uid,
    required this.nombre,
    required this.carrera,
    required this.campus,
    required this.email,
    required this.habilidades,
    required this.fechaNacimiento,
    required this.anioIngreso,
    required this.intereses,
  });

  factory UsuarioModel.fromMap(Map<String, dynamic> map, String uid) {
    return UsuarioModel(
      uid: uid,
      nombre: (map['nombre'] ?? '').toString(),
      carrera: (map['carrera'] ?? '').toString(),
      campus: (map['campus'] ?? '').toString(),
      email: (map['email'] ?? '').toString(),
      habilidades: (map['habilidades'] ?? '').toString(),
      fechaNacimiento:
          map['fechaNacimiento'] != null
              ? (map['fechaNacimiento'] as Timestamp).toDate()
              : null,
      anioIngreso: map['anioIngreso'] ?? 0,
      intereses: List<String>.from(map['intereses'] ?? []),
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
      'anioIngreso': anioIngreso,
      'intereses': intereses,
    };
  }
}
