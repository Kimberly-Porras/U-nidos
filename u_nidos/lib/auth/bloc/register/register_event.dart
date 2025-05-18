import 'package:equatable/equatable.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

// Paso 1: Datos de acceso (correo y contraseña)
class AccessCompleted extends RegisterEvent {
  final String correo;
  final String password;

  const AccessCompleted(this.correo, this.password);

  @override
  List<Object> get props => [correo, password];
}

// Paso 2: Datos del perfil
class ProfileCompleted extends RegisterEvent {
  final String nombre;
  final String universidad;
  final String campus;
  final String carrera;
  final int anioIngreso;
  final String habilidades;
  final DateTime fechaNacimiento;

  const ProfileCompleted({
    required this.nombre,
    required this.universidad,
    required this.campus,
    required this.carrera,
    required this.anioIngreso,
    required this.habilidades,
    required this.fechaNacimiento,
  });

  @override
  List<Object> get props => [
        nombre,
        universidad,
        campus,
        carrera,
        anioIngreso,
        habilidades,
        fechaNacimiento,
      ];
}

// Paso 3: Intereses
class InterestsSelected extends RegisterEvent {
  final List<String> interests;

  const InterestsSelected(this.interests);

  @override
  List<Object> get props => [interests];
}

// Paso 4: Confirmación final (opcional)
class ConfirmationCodeEntered extends RegisterEvent {
  final String code;

  const ConfirmationCodeEntered(this.code);

  @override
  List<Object> get props => [code];
}
