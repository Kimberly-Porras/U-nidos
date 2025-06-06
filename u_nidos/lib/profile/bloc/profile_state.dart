class ProfileState {
  final String nombre;
  final String carrera;
  final String campus;
  final String email;
  final String habilidades;
  final DateTime? fechaNacimiento;
  final int anioIngreso;
  final List<String> intereses;
  final bool cargando;

  const ProfileState({
    this.nombre = '',
    this.carrera = '',
    this.campus = '',
    this.email = '',
    this.habilidades = '',
    this.fechaNacimiento,
    this.anioIngreso = 0,
    this.intereses = const [],
    this.cargando = false,
  });

  ProfileState copyWith({
    String? nombre,
    String? carrera,
    String? campus,
    String? email,
    String? habilidades,
    DateTime? fechaNacimiento,
    int? anioIngreso,
    List<String>? intereses,
    bool? cargando,
  }) {
    return ProfileState(
      nombre: nombre ?? this.nombre,
      carrera: carrera ?? this.carrera,
      campus: campus ?? this.campus,
      email: email ?? this.email,
      habilidades: habilidades ?? this.habilidades,
      fechaNacimiento: fechaNacimiento ?? this.fechaNacimiento,
      anioIngreso: anioIngreso ?? this.anioIngreso,
      intereses: intereses ?? this.intereses,
      cargando: cargando ?? this.cargando,
    );
  }
}
