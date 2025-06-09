import 'package:flutter/material.dart';

/// Clase base de estado
abstract class PublicationState {
  final String categoria;
  final String descripcion;
  final Color fondo;
  final bool enviando;

  const PublicationState({
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
  });
}

/// Estado normal editable
class PublicationFormState extends PublicationState {
  const PublicationFormState({
    required super.categoria,
    required super.descripcion,
    required super.fondo,
    super.enviando = false,
  });

  @override
  PublicationFormState copyWith({
    String? categoria,
    String? descripcion,
    Color? fondo,
    bool? enviando,
  }) {
    return PublicationFormState(
      categoria: categoria ?? this.categoria,
      descripcion: descripcion ?? this.descripcion,
      fondo: fondo ?? this.fondo,
      enviando: enviando ?? this.enviando,
    );
  }
}

/// Estado cuando la publicación fue exitosa
class PublicacionExitosa extends PublicationState {
  const PublicacionExitosa()
      : super(categoria: '', descripcion: '', fondo: Colors.white);
  
  @override
  PublicationState copyWith({String? categoria, String? descripcion, Color? fondo, bool? enviando}) {
    return this;
  }
}

/// Estado cuando ocurre un error
class PublicacionError extends PublicationState {
  const PublicacionError()
      : super(categoria: '', descripcion: '', fondo: Colors.white);

  @override
  PublicationState copyWith({String? categoria, String? descripcion, Color? fondo, bool? enviando}) {
    return this;
  }
}
