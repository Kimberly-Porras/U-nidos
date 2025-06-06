import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';
import 'auth/bloc/auth/auth_bloc.dart';
import 'auth/bloc/auth/auth_event.dart';
import 'auth/bloc/auth/auth_state.dart';
import 'auth/bloc/register/register_bloc.dart';
import 'auth/repository/auth_repository.dart';

import 'connectivity/bloc/connectivity_bloc.dart';
import 'connectivity/bloc/connectivity_state.dart';
import 'connectivity/repository/connectivity_repository.dart';

import 'auth/bloc/screens/login_screen.dart';
import 'services/home_screen.dart';
import 'services/select_university_screen.dart';
import 'shared_preferences.dart';

import 'chat/repository/chat_repository.dart';
import 'chat/bloc message/message_bloc.dart';
import 'chat/bloc conversation list/conversation_list_bloc.dart';

import 'package:u_nidos/list_publication/bloc/publications_bloc.dart';
import 'package:u_nidos/list_publication/repository/publications_repository.dart';
import 'package:intl/date_symbol_data_local.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDateFormatting('es_CR', null);

  final connectivityRepository = ConnectivityRepository();
  final chatRepository = ChatRepository();

  runApp(
    RepositoryProvider.value(
      value: connectivityRepository,
      child: UNidosApp(
        connectivityRepository: connectivityRepository,
        chatRepository: chatRepository,
      ),
    ),
  );
}

class UNidosApp extends StatefulWidget {
  final ConnectivityRepository connectivityRepository;
  final ChatRepository chatRepository;

  const UNidosApp({
    super.key,
    required this.connectivityRepository,
    required this.chatRepository,
  });

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
          create:
              (_) =>
                  ConnectivityBloc(repository: widget.connectivityRepository),
        ),
        BlocProvider<MessageBloc>(
          create: (_) => MessageBloc(repository: widget.chatRepository),
        ),
        BlocProvider<ConversationListBloc>(
          create:
              (_) => ConversationListBloc(repository: widget.chatRepository),
        ),
        BlocProvider<PublicacionBloc>(
          create: (_) => PublicacionBloc(PublicacionRepository()),
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
          '/home': (context) {
            final uid = FirebaseAuth.instance.currentUser!.uid;
            return HomeScreen(uid: uid);
          },
          '/select_university':
              (context) =>
                  SelectUniversityScreen(onSeleccion: cargarUniversidad),
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
        home:
            universidadSeleccionada == null
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
          final uid = state.uid;
          print('🧑 UID autenticado desde AuthSuccess: $uid');
          return HomeScreen(uid: state.uid);
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
