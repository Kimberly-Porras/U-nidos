import 'package:flutter/material.dart';

abstract class PublicationEvent {}

class CategoryChanged extends PublicationEvent {
  final String categoria;
  CategoryChanged(this.categoria);
}

class DescriptionChanged extends PublicationEvent {
  final String descripcion;
  DescriptionChanged(this.descripcion);
}

class BackgroundColorChanged extends PublicationEvent {
  final Color color;
  BackgroundColorChanged(this.color);
}

class SubmitPublication extends PublicationEvent {}
