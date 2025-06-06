class ProfileState {
  final String uid;
  final String nombre;
  final String carrera;
  final String campus;
  final String email;
  final String habilidades;
  final int anioIngreso;
  final DateTime? fechaNacimiento;
  final List<String> intereses;
  final bool cargando;

  ProfileState({
    required this.uid,
    required this.nombre,
    required this.carrera,
    required this.campus,
    required this.email,
    required this.habilidades,
    required this.anioIngreso,
    required this.fechaNacimiento,
    this.intereses = const [],
    required this.cargando,
  });

  ProfileState copyWith({
    String? uid,
    String? nombre,
    String? carrera,
    String? campus,
    String? email,
    String? habilidades,
    int? anioIngreso,
    DateTime? fechaNacimiento,
    List<String>? intereses,
    bool? cargando,
  }) {
    return ProfileState(
      uid: uid ?? this.uid,
      nombre: nombre ?? this.nombre,
      carrera: carrera ?? this.carrera,
      campus: campus ?? this.campus,
      email: email ?? this.email,
      habilidades: habilidades ?? this.habilidades,
      anioIngreso: anioIngreso ?? this.anioIngreso,
      fechaNacimiento: fechaNacimiento ?? this.fechaNacimiento,
      intereses: intereses ?? this.intereses,
      cargando: cargando ?? this.cargando,
    );
  }
}
