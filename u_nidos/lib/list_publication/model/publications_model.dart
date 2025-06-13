import 'package:cloud_firestore/cloud_firestore.dart';

class Publicacion {
  final String id;              // ✅ Agregado
  final String uid;
  final String nombre;
  final String descripcion;
  final String campus;
  final int fondo;

  Publicacion({
    required this.id,          // ✅ Agregado
    required this.uid,
    required this.nombre,
    required this.descripcion,
    required this.campus,
    required this.fondo,
  });

  factory Publicacion.fromMap(Map<String, dynamic> data) {
    return Publicacion(
      id: '', // ⚠️ Esto no se usa directamente en producción
      uid: data['uid'] ?? '',
      nombre: data['nombre'] ?? '',
      descripcion: data['descripcion'] ?? '',
      campus: data['campus'] ?? '',
      fondo: data['fondo'] ?? 0,
    );
  }

  factory Publicacion.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Publicacion(
      id: doc.id, // ✅ El id del documento Firestore
      uid: data['uid'] ?? '',
      nombre: data['nombre'] ?? '',
      descripcion: data['descripcion'] ?? '',
      campus: data['campus'] ?? '',
      fondo: data['fondo'] ?? 0,
    );
  }
}
