import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'domain/services/auth_service.dart';
import 'domain/services/chat_service.dart';
import 'domain/services/storage_service.dart';
import 'data/repositories/career_repository.dart';
import 'presentation/blocs/auth_bloc.dart';
import 'presentation/blocs/career_bloc.dart';
import 'presentation/blocs/chat_bloc.dart';
import 'presentation/blocs/quiz_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
  }

  final storageService = StorageService();
  await storageService.init();

  final authService = AuthService();
  final careerRepository = CareerRepository();
  final chatService = ChatService(apiKey: 'YOUR_API_KEY'); // Should use env or secure storage

  runApp(MyApp(
    authService: authService,
    careerRepository: careerRepository,
    chatService: chatService,
    storageService: storageService,
  ));
}

class MyApp extends StatelessWidget {
  final AuthService authService;
  final CareerRepository careerRepository;
  final ChatService chatService;
  final StorageService storageService;

  const MyApp({
    super.key,
    required this.authService,
    required this.careerRepository,
    required this.chatService,
    required this.storageService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authService),
        RepositoryProvider.value(value: careerRepository),
        RepositoryProvider.value(value: chatService),
        RepositoryProvider.value(value: storageService),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AuthBloc(authService)..add(AuthCheckRequested())),
          BlocProvider(create: (context) => CareerBloc(careerRepository)..add(CareerListRequested())),
          BlocProvider(create: (context) => ChatBloc(chatService, storageService)..add(ChatHistoryLoaded())),
          BlocProvider(create: (context) => QuizBloc()),
        ],
        child: MaterialApp.router(
          title: 'FutureNext',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          routerConfig: AppRouter.router,
        ),
      ),
    );
  }
}
