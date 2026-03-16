import 'package:go_router/go_router.dart';
import 'package:futurenext/presentation/screens/splash_screen.dart';
import 'package:futurenext/presentation/screens/onboarding_screen.dart';
import 'package:futurenext/presentation/screens/login_screen.dart';
import 'package:futurenext/presentation/screens/register_screen.dart';
import 'package:futurenext/presentation/screens/dashboard_screen.dart';
import 'package:futurenext/presentation/screens/quiz_screen.dart';
import 'package:futurenext/presentation/screens/quiz_result_screen.dart';
import 'package:futurenext/presentation/screens/chat_screen.dart';
import 'package:futurenext/presentation/screens/career_detail_screen.dart';
import 'package:futurenext/presentation/screens/profile_screen.dart';
import 'package:futurenext/data/models/career_model.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/quiz',
        name: 'quiz',
        builder: (context, state) => const QuizScreen(),
      ),
      GoRoute(
        path: '/quiz-results',
        name: 'quiz_results',
        builder: (context, state) {
          final results = state.extra as List<MapEntry<CareerCategory, double>>;
          return QuizResultScreen(results: results);
        },
      ),
      GoRoute(
        path: '/chat',
        name: 'chat',
        builder: (context, state) => const ChatScreen(),
      ),
      GoRoute(
        path: '/career/:categoryId/:subCareerId',
        name: 'career_detail',
        builder: (context, state) {
          final categoryId = state.pathParameters['categoryId']!;
          final subCareerId = state.pathParameters['subCareerId']!;
          return CareerDetailScreen(categoryId: categoryId, subCareerId: subCareerId);
        },
      ),
    ],
  );
}
