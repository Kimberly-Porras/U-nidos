import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'auth/bloc/auth/auth_bloc.dart';
import 'auth/bloc/register/register_bloc.dart'; // ✅ Nuevo Bloc
import 'shared_preferences.dart';
import 'services/login_screen.dart';
import 'services/home_screen.dart';
import 'auth/bloc/auth/auth_event.dart';
import 'auth/bloc/auth/auth_state.dart';
import 'auth/repository/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'services/select_university_screen.dart';

// 👇 Clave global para usar con ScaffoldMessenger
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const UNidosApp());
}

class UNidosApp extends StatefulWidget {
  const UNidosApp({super.key});

  @override
  State<UNidosApp> createState() => _UNidosAppState();
}

class _UNidosAppState extends State<UNidosApp> {
  String? universidadSeleccionada;

  final Map<String, Color> coloresUniversidades = {
    'UNA': Color(0xFFAD002E),
    'UCR': Color(0xFF007DC5),
    'TEC': Color(0xFF0C2340),
    'UNED': Color(0xFF003366),
    'UTN': Color(0xFF003865),
  };

  final AuthRepository authRepository = AuthRepository();

  @override
  void initState() {
    super.initState();
    cargarUniversidad();
  }

  Future<void> cargarUniversidad() async {
    final uni = await SharedPrefsService.obtenerUniversidad();
    setState(() {
      universidadSeleccionada = uni;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color colorPrimario =
        coloresUniversidades[universidadSeleccionada] ?? Colors.grey;

    return RepositoryProvider.value(
      value: authRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (_) => AuthBloc(authRepository),
          ),
          BlocProvider<RegisterBloc>(
            create: (_) => RegisterBloc(), // ✅ Se añade aquí
          ),
        ],
        child: MaterialApp(
          scaffoldMessengerKey: scaffoldMessengerKey,
          debugShowCheckedModeBanner: false,
          title: 'U-NIDOS',
          theme: ThemeData(
            primaryColor: colorPrimario,
            appBarTheme: AppBarTheme(
              backgroundColor: colorPrimario,
              foregroundColor: Colors.white,
            ),
            colorScheme: ColorScheme.fromSeed(
              seedColor: colorPrimario,
              primary: colorPrimario,
            ),
          ),
          home: universidadSeleccionada == null
              ? SelectUniversityScreen(onSeleccion: cargarUniversidad)
              : const AuthWrapper(),
        ),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is AuthSuccess) {
          return HomeScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
