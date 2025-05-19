import 'package:flutter/material.dart';

class PublicationState {
  final String categoria;
  final String descripcion;
  final Color fondo;
  final bool enviando;

  PublicationState({
    required this.categoria,
    required this.descripcion,
    required this.fondo,
    this.enviando = false,
  });

  PublicationState copyWith({
    String? categoria,
    String? descripcion,
    Color? fondo,
    bool? enviando,
  }) {
    return PublicationState(
      categoria: categoria ?? this.categoria,
      descripcion: descripcion ?? this.descripcion,
      fondo: fondo ?? this.fondo,
      enviando: enviando ?? this.enviando,
    );
  }
}
