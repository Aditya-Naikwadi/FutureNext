import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futurenext/core/theme/app_theme.dart';
import 'package:futurenext/core/router/app_router.dart';
import 'package:futurenext/core/constants/app_strings.dart';
import 'package:futurenext/domain/services/auth_service.dart';
import 'package:futurenext/domain/services/chat_service.dart';
import 'package:futurenext/domain/services/storage_service.dart';
import 'package:futurenext/domain/services/assessment_service.dart';
import 'package:futurenext/domain/services/onet_service.dart';
import 'package:futurenext/data/repositories/career_repository.dart';
import 'package:futurenext/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:futurenext/features/careers/presentation/blocs/career_bloc.dart';
import 'package:futurenext/features/chat/presentation/blocs/chat_bloc.dart';
import 'package:futurenext/features/quiz/presentation/blocs/quiz_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:futurenext/firebase_options.dart';

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
  final chatService = ChatService(apiKey: 'AIzaSyDD4O5dwkTPcRNsuRqg940-bnEHeQIDnzQ'); 
  final assessmentService = AssessmentService(apiKey: 'AIzaSyDD4O5dwkTPcRNsuRqg940-bnEHeQIDnzQ');

  final onetService = OnetService();

  runApp(MyApp(
    authService: authService,
    careerRepository: careerRepository,
    chatService: chatService,
    storageService: storageService,
    assessmentService: assessmentService,
    onetService: onetService,
  ));
}

class MyApp extends StatelessWidget {
  final AuthService authService;
  final CareerRepository careerRepository;
  final ChatService chatService;
  final StorageService storageService;
  final AssessmentService assessmentService;
  final OnetService onetService;

  const MyApp({
    super.key,
    required this.authService,
    required this.careerRepository,
    required this.chatService,
    required this.storageService,
    required this.assessmentService,
    required this.onetService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authService),
        RepositoryProvider.value(value: careerRepository),
        RepositoryProvider.value(value: chatService),
        RepositoryProvider.value(value: storageService),
        RepositoryProvider.value(value: assessmentService),
        RepositoryProvider.value(value: onetService),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AuthBloc(authService)..add(AuthCheckRequested())),
          BlocProvider(create: (context) => CareerBloc(careerRepository)..add(CareerListRequested())),
          BlocProvider(create: (context) => ChatBloc(chatService, storageService)..add(ChatHistoryLoaded())),
          BlocProvider(create: (context) => QuizBloc(assessmentService)),
        ],
        child: MaterialApp.router(
          title: AppStrings.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          routerConfig: AppRouter.router,
        ),
      ),
    );
  }
}
