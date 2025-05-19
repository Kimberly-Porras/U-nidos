import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'auth/bloc/auth/auth_bloc.dart';
import 'auth/bloc/auth/auth_event.dart';
import 'auth/bloc/auth/auth_state.dart';
import 'auth/bloc/register/register_bloc.dart';
import 'auth/repository/auth_repository.dart';

import 'connectivity/bloc/connectivity_bloc.dart';
import 'connectivity/bloc/connectivity_state.dart';
import 'connectivity/repository/connectivity_repository.dart';
import 'connectivity/repository/connectivity_repository.dart';

import 'auth/bloc/screens/login_screen.dart';
import 'services/home_screen.dart';
import 'services/select_university_screen.dart';
import 'shared_preferences.dart';


final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final connectivityRepository = ConnectivityRepository();

  runApp(
    RepositoryProvider.value(
      value: connectivityRepository,
      child: UNidosApp(connectivityRepository: connectivityRepository),
    ),
  );
}

class UNidosApp extends StatefulWidget {
  final ConnectivityRepository connectivityRepository;

  const UNidosApp({super.key, required this.connectivityRepository});

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

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => AuthBloc(authRepository)),
        BlocProvider<RegisterBloc>(create: (_) => RegisterBloc()),
        BlocProvider<ConnectivityBloc>(
          create: (_) =>
              ConnectivityBloc(repository: widget.connectivityRepository),
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
        routes: {
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreen(),
          '/select_university': (context) =>
              SelectUniversityScreen(onSeleccion: cargarUniversidad),
          // Agrega aquí otras rutas si tienes más pantallas
        },
        builder: (context, child) {
          return BlocListener<ConnectivityBloc, ConnectivityState>(
            listener: (context, state) {
              if (state is ConnectivityOffline) {
                scaffoldMessengerKey.currentState?.showSnackBar(
                  const SnackBar(
                    content: Text('⚠️ Sin conexión a internet'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: child!,
          );
        },
        home: universidadSeleccionada == null
            ? SelectUniversityScreen(onSeleccion: cargarUniversidad)
            : const AuthWrapper(),
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
          return const HomeScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
