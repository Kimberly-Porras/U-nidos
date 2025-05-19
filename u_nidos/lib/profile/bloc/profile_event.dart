import 'package:u_nidos/profile/model/profile_model.dart';

abstract class ProfileEvent {}

class LoadUserProfile extends ProfileEvent {
  final String uid;
  LoadUserProfile(this.uid);
}

class GuardarCambiosPerfil extends ProfileEvent {
  final UsuarioModel usuario;
  GuardarCambiosPerfil(this.usuario);
}
