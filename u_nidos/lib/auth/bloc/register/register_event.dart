import 'package:equatable/equatable.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

// Paso 1
class AccessCompleted extends RegisterEvent {
  final String correo;
  final String password;
  final String nombre;

  const AccessCompleted({
    required this.correo,
    required this.password,
    required this.nombre,
  });

  @override
  List<Object> get props => [correo, password, nombre];
}

// Paso 2
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

// Paso 3
class InterestsSelected extends RegisterEvent {
  final List<String> interests;

  const InterestsSelected(this.interests);

  @override
  List<Object> get props => [interests];
}

// Paso 4
class ConfirmationCodeEntered extends RegisterEvent {
  final String code;

  const ConfirmationCodeEntered(this.code);

  @override
  List<Object> get props => [code];
}

// Paso 5
class GuardarDatosTemporales extends RegisterEvent {
  final String email;
  final String password;
  final String nombre;
  final String universidad;
  final String campus;
  final String carrera;
  final int anioIngreso;
  final String habilidades;
  final DateTime fechaNacimiento;

  const GuardarDatosTemporales({
    required this.email,
    required this.password,
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
        email,
        password,
        nombre,
        universidad,
        campus,
        carrera,
        anioIngreso,
        habilidades,
        fechaNacimiento,
      ];
}
