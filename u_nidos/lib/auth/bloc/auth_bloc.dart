import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../repository/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<AuthLoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.login(event.email, event.password);
        emit(AuthSuccess());
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<AuthRegisterRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.register(event.email, event.password);
        emit(AuthSuccess());
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<AuthLogoutRequested>((event, emit) async {
      await authRepository.logout();
      emit(AuthInitial());
    });
  }
}
