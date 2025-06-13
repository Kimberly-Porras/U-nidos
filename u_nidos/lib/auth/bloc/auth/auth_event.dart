abstract class AuthEvent {}

/// 🧑‍💻 Solicita iniciar sesión con correo y contraseña
class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  AuthLoginRequested(this.email, this.password);
}

/// 📝 Solicita registrar un nuevo usuario
class AuthRegisterRequested extends AuthEvent {
  final String email;
  final String password;

  AuthRegisterRequested(this.email, this.password);
}

/// 🔐 Solicita cerrar sesión
class AuthLogoutRequested extends AuthEvent {}

/// ✅ Indica que ya hay un usuario autenticado y se debe mantener la sesión activa
class AuthLoggedIn extends AuthEvent {
  final String uid;

  AuthLoggedIn({required this.uid});
}
