import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:futurenext/core/constants/app_strings.dart';
import 'package:futurenext/domain/services/storage_service.dart';
import 'package:futurenext/features/auth/presentation/blocs/auth_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    final storage = context.read<StorageService>();
    final hasSeenOnboarding = await storage.hasSeenOnboarding();
    
    // Give it a small delay for branding effect
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;

    final authState = context.read<AuthBloc>().state;
    
    if (!hasSeenOnboarding) {
      context.go('/onboarding');
    } else if (authState is Authenticated) {
      context.go('/dashboard');
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.rocket_launch, size: 80, color: Colors.white),
            const SizedBox(height: 24),
            Text(
              AppStrings.appName,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
            ),
            const SizedBox(height: 8),
            const Text(
              AppStrings.tagline,
              style: TextStyle(color: Colors.white70, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(color: Colors.white70),
          ],
        ),
      ),
    );
  }
}
