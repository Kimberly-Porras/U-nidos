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

  void _onAccessCompleted(AccessCompleted event, Emitter<RegisterState> emit) {
    _email = event.correo;
    _password = event.password;
    emit(RegisterAccessCompleted());
  }

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
      emit(RegisterError('Error al guardar en Firebase: ${e.toString()}'));
    }
  }

  void _onConfirmationCodeEntered(
      ConfirmationCodeEntered event, Emitter<RegisterState> emit) {
    emit(RegisterConfirmationCompleted());
  }
}
