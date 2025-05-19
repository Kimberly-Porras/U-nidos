import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'publication_event.dart';
import 'publication_state.dart';
import 'package:flutter/material.dart';

class PublicationBloc extends Bloc<PublicationEvent, PublicationState> {
  PublicationBloc()
    : super(
        PublicationState(
          categoria: '',
          descripcion: '',
          fondo: const Color(0xFFE1F5FE),
        ),
      ) {
    on<CategoryChanged>((event, emit) {
      emit(state.copyWith(categoria: event.categoria));
    });

    on<DescriptionChanged>((event, emit) {
      emit(state.copyWith(descripcion: event.descripcion));
    });

    on<BackgroundColorChanged>((event, emit) {
      emit(state.copyWith(fondo: event.color));
    });

    on<SubmitPublication>((event, emit) async {
      emit(state.copyWith(enviando: true));

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // 🔍 Obtener información adicional del usuario desde Firestore
      final userDoc =
          await FirebaseFirestore.instance
              .collection('usuarios')
              .doc(user.uid)
              .get();

      final data = userDoc.data() ?? {};

      final nombre = data['nombre']?.toString().trim() ?? '';
      final campus = data['campus']?.toString().trim() ?? '';
      print('[DEBUG] Nombre leído: $nombre');
      print('[DEBUG] Campus leído: $campus');

      final doc = {
        'uid': user.uid,
        'nombre': nombre,
        'email': user.email ?? '',
        'campus': campus,
        'categoria': state.categoria,
        'descripcion': state.descripcion,
        'fondo': state.fondo.value,
        'timestamp': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance.collection('publicaciones').add(doc);

      emit(state.copyWith(enviando: false, descripcion: '', categoria: ''));
    });
  }
}
