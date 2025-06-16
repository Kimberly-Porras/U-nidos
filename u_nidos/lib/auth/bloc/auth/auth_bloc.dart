import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    // 🔐 Sesión restaurada automáticamente
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
          final uid = user.uid;

          print('✅ Registro exitoso para ${user.email} con UID: $uid');

          // 🔽 Guardar el perfil en Firestore
          await FirebaseFirestore.instance.collection('usuarios').doc(uid).set({
            'email': event.email,
            'nombre': 'Nombre temporal', // Reemplazá esto si lo pasás desde UI
            'creado': DateTime.now(),
          });

          emit(AuthSuccess(uid));
        } else {
          emit(AuthFailure('No se pudo registrar el usuario.'));
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
