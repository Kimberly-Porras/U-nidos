import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    // 🔐 Sesión restaurada automáticamente (Firebase ya tiene un usuario)
    on<AuthLoggedIn>((event, emit) async {
      print('🔐 Sesión restaurada automáticamente: ${event.uid}');
      emit(AuthLoading());
      emit(AuthSuccess(event.uid));
    });

    // 🚀 Iniciar sesión
    on<AuthLoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        print('Iniciando sesión con: ${event.email}');
        final user = await authRepository.login(event.email, event.password);
        final uid = FirebaseAuth.instance.currentUser!.uid;

        if (user != null) {
          print('Login exitoso para ${user.email}');
          emit(AuthSuccess(uid));
        } else {
          print('Usuario devuelto es nulo');
          emit(AuthFailure('Usuario no encontrado'));
        }
      } catch (e, stack) {
        print('Error en AuthLoginRequested');
        print('Excepción capturada: $e');
        print('Stacktrace: $stack');
        emit(AuthFailure(e.toString()));
      }
    });

    // 📝 Registro de nuevo usuario
    on<AuthRegisterRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        print('Registrando usuario: ${event.email}');
        final user = await authRepository.register(event.email, event.password);
        if (user != null) {
          print('Registro exitoso para ${user.email}');
          final uid = FirebaseAuth.instance.currentUser!.uid;
          emit(AuthSuccess(uid));
        } else {
          print('Registro retornó usuario nulo');
          final uid = FirebaseAuth.instance.currentUser!.uid;
          emit(AuthSuccess(uid));
        }
      } catch (e, stack) {
        print('Error en AuthRegisterRequested');
        print('Excepción capturada: $e');
        print('Stacktrace: $stack');
        emit(AuthFailure(e.toString()));
      }
    });

    // 🚪 Cerrar sesión
    on<AuthLogoutRequested>((event, emit) async {
      print('Cerrando sesión...');
      await authRepository.logout();
      print('Sesión cerrada');
      emit(AuthInitial());
    });
  }
}
