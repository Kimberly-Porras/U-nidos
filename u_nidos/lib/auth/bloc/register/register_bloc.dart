import 'package:flutter_bloc/flutter_bloc.dart';
import 'register_event.dart';
import 'register_state.dart';
import '../../../services/auth_service.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterInitial()) {
    on<AccessCompleted>(_onAccessCompleted);
    on<ProfileCompleted>(_onProfileCompleted);
    on<InterestsSelected>(_onInterestsSelected);
    on<ConfirmationCodeEntered>(_onConfirmationCodeEntered);
    on<GuardarDatosTemporales>(_onGuardarDatosTemporales); // ✅ Añadido
  }

  // Variables internas para armar el perfil completo
  String? _email;
  String? _password;
  String? _nombre;
  String? _universidad;
  String? _campus;
  String? _carrera;
  int? _anioIngreso;
  String? _habilidades;
  DateTime? _fechaNacimiento;
  List<String> _intereses = [];

  final AuthService _authService = AuthService();

  /// Paso 1: Validación del nombre de usuario (el correo se validará después)
  Future<void> _onAccessCompleted(
      AccessCompleted event, Emitter<RegisterState> emit) async {
    _email = event.correo;
    _password = event.password;
    _nombre = event.nombre;

    emit(RegisterLoading());

    try {
      final usernameExiste = await _authService.usernameExists(_nombre!.trim());
      if (usernameExiste) {
        emit(RegisterError("El nombre de usuario ya está en uso."));
        return;
      }

      emit(RegisterAccessCompleted());
    } catch (e) {
      emit(RegisterError("Error en la validación: ${e.toString()}"));
    }
  }

  /// Paso 2: Guardar datos del perfil
  void _onProfileCompleted(ProfileCompleted event, Emitter<RegisterState> emit) {
    _nombre = event.nombre;
    _universidad = event.universidad;
    _campus = event.campus;
    _carrera = event.carrera;
    _anioIngreso = event.anioIngreso;
    _habilidades = event.habilidades;
    _fechaNacimiento = event.fechaNacimiento;
    emit(RegisterProfileCompleted());
  }

  /// Paso 3: Intentar registrar al usuario (Firebase valida el correo)
  Future<void> _onInterestsSelected(
      InterestsSelected event, Emitter<RegisterState> emit) async {
    emit(RegisterLoading());
    _intereses = event.interests;

    try {
      await _authService.registrarUsuario(
        email: _email!,
        password: _password!,
        nombre: _nombre!,
        universidad: _universidad!,
        campus: _campus!,
        carrera: _carrera!,
        anioIngreso: _anioIngreso!,
        habilidades: _habilidades!,
        fechaNacimiento: _fechaNacimiento!,
        intereses: _intereses,
      );

      emit(RegisterInterestsCompleted());
    } catch (e) {
      final mensaje = e.toString();

      if (mensaje.contains("correo electrónico ya está en uso") ||
          mensaje.contains("ya está en uso")) {
        emit(RegisterError(mensaje));
      } else {
        emit(RegisterError('Error al guardar en Firebase: $mensaje'));
      }
    }
  }

  /// Paso 4: Confirmación (opcional)
  void _onConfirmationCodeEntered(
      ConfirmationCodeEntered event, Emitter<RegisterState> emit) {
    emit(RegisterConfirmationCompleted());
  }

  /// Paso 5: Guardar datos temporales antes de registro
  void _onGuardarDatosTemporales(
      GuardarDatosTemporales event, Emitter<RegisterState> emit) {
    _email = event.email;
    _password = event.password;
    _nombre = event.nombre;
    _universidad = event.universidad;
    _campus = event.campus;
    _carrera = event.carrera;
    _anioIngreso = event.anioIngreso;
    _habilidades = event.habilidades;
    _fechaNacimiento = event.fechaNacimiento;
  }
}
