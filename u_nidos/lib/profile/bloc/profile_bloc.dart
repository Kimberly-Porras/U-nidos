import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc()
      : super(
          ProfileState(
            uid: '',
            nombre: '',
            carrera: '',
            campus: '',
            email: '',
            habilidades: '',
            anioIngreso: 0,
            fechaNacimiento: null,
            cargando: false,
          ),
        ) {
    on<LoadUserProfile>((event, emit) async {
      emit(state.copyWith(cargando: true));

      try {
        final doc = await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(event.uid)
            .get();

        final data = doc.data() ?? {};

        emit(
          state.copyWith(
            uid: event.uid,
            nombre: (data['nombre'] ?? '').toString().trim(),
            carrera: (data['carrera'] ?? '').toString().trim(),
            campus: (data['campus'] ?? '').toString().trim(),
            email: (data['email'] ?? '').toString().trim(),
            habilidades: (data['habilidades'] ?? '').toString().trim(),
            anioIngreso: int.tryParse(data['anioIngreso'].toString()) ?? 0,
            fechaNacimiento: (data['fechaNacimiento'] as Timestamp?)?.toDate(),
            intereses: List<String>.from(data['intereses'] ?? []),
            cargando: false,
          ),
        );
      } catch (e) {
        emit(state.copyWith(cargando: false));
        print('❌ Error al cargar perfil: $e');
      }
    });

    on<GuardarCambiosPerfil>((event, emit) async {
      emit(state.copyWith(cargando: true));

      try {
        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(event.usuario.uid)
            .update(event.usuario.toMap());

        emit(
          state.copyWith(
            uid: event.usuario.uid,
            nombre: event.usuario.nombre,
            carrera: event.usuario.carrera,
            campus: event.usuario.campus,
            email: event.usuario.email,
            habilidades: event.usuario.habilidades,
            anioIngreso: event.usuario.anioIngreso,
            fechaNacimiento: event.usuario.fechaNacimiento,
            intereses: event.usuario.intereses,
            cargando: false,
          ),
        );
      } catch (e) {
        emit(state.copyWith(cargando: false));
        print('❌ Error al guardar perfil: $e');
      }
    });
  }
}
