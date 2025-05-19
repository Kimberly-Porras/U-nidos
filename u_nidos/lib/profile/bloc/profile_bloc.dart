import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(const ProfileState()) {
    on<LoadUserProfile>((event, emit) async {
      emit(state.copyWith(cargando: true));

      final doc =
          await FirebaseFirestore.instance
              .collection('usuarios')
              .doc(event.uid)
              .get();

      final data = doc.data() ?? {};

      emit(
        state.copyWith(
          nombre: (data['nombre'] ?? '').toString().trim(),
          carrera: (data['carrera'] ?? '').toString().trim(),
          campus: (data['campus'] ?? '').toString().trim(),
          email: (data['email'] ?? '').toString().trim(),
          habilidades: (data['habilidades'] ?? '').toString().trim(),
          fechaNacimiento: (data['fechaNacimiento'] as Timestamp?)?.toDate(),
          cargando: false,
        ),
      );
    });
  }
}
