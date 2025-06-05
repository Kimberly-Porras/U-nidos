class Publicacion {
  final String uid;
  final String nombre;
  final String descripcion;
  final String campus;
  final int fondo;

  Publicacion({
    required this.uid,
    required this.nombre,
    required this.descripcion,
    required this.campus,
    required this.fondo,
  });

  factory Publicacion.fromMap(Map<String, dynamic> data) {
    return Publicacion(
      uid: data['uid'] ?? '',
      nombre: data['nombre'] ?? '',
      descripcion: data['descripcion'] ?? '',
      campus: data['campus'] ?? '',
      fondo: data['fondo'] ?? 0,
    );
  }
}
