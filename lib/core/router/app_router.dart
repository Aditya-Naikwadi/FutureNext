import 'package:go_router/go_router.dart';
import 'package:futurenext/data/models/assessment_model.dart';
import 'package:futurenext/features/onboard/presentation/screens/splash_screen.dart';
import 'package:futurenext/features/onboard/presentation/screens/onboarding_screen.dart';
import 'package:futurenext/features/auth/presentation/screens/login_screen.dart';
import 'package:futurenext/features/auth/presentation/screens/register_screen.dart';
import 'package:futurenext/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:futurenext/features/quiz/presentation/screens/quiz_screen.dart';
import 'package:futurenext/features/quiz/presentation/screens/quiz_result_screen.dart';
import 'package:futurenext/features/chat/presentation/screens/chat_screen.dart';
import 'package:futurenext/features/careers/presentation/screens/career_detail_screen.dart';
import 'package:futurenext/features/careers/presentation/screens/category_careers_screen.dart';
import 'package:futurenext/features/profile/presentation/screens/profile_screen.dart';

import 'package:futurenext/features/careers/presentation/screens/categories_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/categories',
        builder: (context, state) => const CategoriesScreen(),
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
        path: '/quiz-result',
        name: 'quiz_result',
        builder: (context, state) {
          final results = state.extra as AssessmentResults;
          return QuizResultScreen(results: results);
        },
      ),
      GoRoute(
        path: '/chat',
        name: 'chat',
        builder: (context, state) => const ChatScreen(),
      ),
      GoRoute(
        path: '/category/:categoryId',
        name: 'category_details',
        builder: (context, state) {
          final categoryId = state.pathParameters['categoryId']!;
          return CategoryCareersScreen(categoryId: categoryId);
        },
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
