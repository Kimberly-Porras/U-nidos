import 'package:cloud_firestore/cloud_firestore.dart';

class Publication {
  final String id;
  final String uid;
  final String nombre;
  final String email;
  final String campus;
  final String categoria;
  final String descripcion;
  final int fondoColor;
  final DateTime timestamp;

  Publication({
    required this.id,
    required this.uid,
    required this.nombre,
    required this.email,
    required this.campus,
    required this.categoria,
    required this.descripcion,
    required this.fondoColor,
    required this.timestamp,
  });

  factory Publication.fromMap(String id, Map<String, dynamic> data) {
    return Publication(
      id: id,
      uid: data['uid'] ?? '',
      nombre: data['nombre'] ?? '',
      email: data['email'] ?? '',
      campus: data['campus'] ?? '',
      categoria: data['categoria'] ?? '',
      descripcion: data['descripcion'] ?? '',
      fondoColor: data['fondo'] ?? 0xFFE0F7FA,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nombre': nombre,
      'email': email,
      'campus': campus,
      'categoria': categoria,
      'descripcion': descripcion,
      'fondo': fondoColor,
      'timestamp': timestamp,
    };
  }
}
