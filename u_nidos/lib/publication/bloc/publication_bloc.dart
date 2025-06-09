import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'publication_event.dart';
import 'publication_state.dart';
import 'package:flutter/material.dart';

class PublicationBloc extends Bloc<PublicationEvent, PublicationState> {
  PublicationBloc()
      : super(const PublicationFormState(
          categoria: '',
          descripcion: '',
          fondo: Color(0xFFE1F5FE),
        )) {
    // Cambiar categoría
    on<CategoryChanged>((event, emit) {
      final current = state as PublicationFormState;
      emit(current.copyWith(categoria: event.categoria));
    });

    // Cambiar descripción
    on<DescriptionChanged>((event, emit) {
      final current = state as PublicationFormState;
      emit(current.copyWith(descripcion: event.descripcion));
    });

    // Cambiar color
    on<BackgroundColorChanged>((event, emit) {
      final current = state as PublicationFormState;
      emit(current.copyWith(fondo: event.color));
    });

    // Publicar
    on<SubmitPublication>((event, emit) async {
      final current = state as PublicationFormState;
      emit(current.copyWith(enviando: true));

      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) throw Exception('Usuario no autenticado');

        final userDoc = await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(user.uid)
            .get();

        final data = userDoc.data() ?? {};
        final nombre = data['nombre']?.toString().trim() ?? '';
        final campus = data['campus']?.toString().trim() ?? '';

        final doc = {
          'uid': user.uid,
          'nombre': nombre,
          'email': user.email ?? '',
          'campus': campus,
          'categoria': current.categoria,
          'descripcion': current.descripcion,
          'fondo': current.fondo.value,
          'timestamp': FieldValue.serverTimestamp(),
        };

        await FirebaseFirestore.instance
            .collection('publicaciones')
            .add(doc);

        emit(const PublicacionExitosa());
      } catch (e) {
        print('❌ Error al publicar: $e');
        emit(const PublicacionError());
      } finally {
        emit(const PublicationFormState(
          categoria: '',
          descripcion: '',
          fondo: Color(0xFFE1F5FE),
          enviando: false,
        ));
      }
    });
  }
}
