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

import 'university_theme.dart';
import 'app_colors.dart';
import 'package:u_nidos/services/servicios_impartidos_screen.dart';

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
    final colorPrimario = AppColors.obtenerColor(universidadSeleccionada ?? '');

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => AuthBloc(authRepository)),
        BlocProvider<RegisterBloc>(create: (_) => RegisterBloc()),
        BlocProvider<ConnectivityBloc>(
          create: (_) =>
              ConnectivityBloc(repository: widget.connectivityRepository),
        ),
        BlocProvider<MessageBloc>(
          create: (_) => MessageBloc(repository: widget.chatRepository),
        ),
        BlocProvider<ConversationListBloc>(
          create: (_) => ConversationListBloc(repository: widget.chatRepository),
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
              (context) => SelectUniversityScreen(onSeleccion: cargarUniversidad),
          '/servicios_impartidos': (context) => const ServiciosImpartidosScreen(),
        },
        builder: (context, child) {
          return BlocListener<ConnectivityBloc, ConnectivityState>(
            listener: (context, state) {
              if (state is ConnectivityOffline) {
                scaffoldMessengerKey.currentState?.showSnackBar(
                  const SnackBar(
                    content: Text('⚠️ Sin conexión a internet'),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 3),
                  ),
                );
              } else if (state is ConnectivityOnline) {
                scaffoldMessengerKey.currentState?.showSnackBar(
                  const SnackBar(
                    content: Text('✅ Conexión a internet restablecida'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            child: child!,
          );
        },
        home: universidadSeleccionada == null
            ? SelectUniversityScreen(onSeleccion: cargarUniversidad)
            : const AuthWrapper(), // <-- se mantiene
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    // 🔁 Si ya hay usuario, disparar AuthLoggedIn
    if (currentUser != null) {
      context.read<AuthBloc>().add(AuthLoggedIn(uid: currentUser.uid));
    }

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is AuthSuccess) {
          final uid = state.uid;
          print('🧑 UID autenticado desde AuthSuccess: $uid');
          return HomeScreen(uid: uid);
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}