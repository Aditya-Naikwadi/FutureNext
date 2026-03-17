import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:futurenext/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:futurenext/widgets/common/custom_button.dart';
import 'package:futurenext/widgets/common/custom_textfield.dart';
import 'package:futurenext/core/constants/app_strings.dart';
import 'package:futurenext/core/theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            context.go('/dashboard');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(
                      Icons.stars_rounded, 
                      size: 72, 
                      color: AppTheme.primaryColor,
                    ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
                    const SizedBox(height: 40),
                    Text(
                      AppStrings.loginTitle,
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            fontSize: 36,
                            height: 1.1,
                          ),
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
                    const SizedBox(height: 12),
                    Text(
                      AppStrings.loginSubtitle,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 16,
                      ),
                    ).animate().fadeIn(delay: 400.ms),
                    const SizedBox(height: 56),
                    CustomTextField(
                      label: 'Email Address',
                      hint: 'name@example.com',
                      prefixIcon: Icons.email_rounded,
                      controller: _emailController,
                      validator: (val) => val == null || !val.contains('@') ? 'Enter a valid email' : null,
                    ).animate().fadeIn(delay: 600.ms),
                    const SizedBox(height: 24),
                    CustomTextField(
                      label: 'Password',
                      hint: '••••••••',
                      prefixIcon: Icons.lock_rounded,
                      isPassword: true,
                      controller: _passwordController,
                      validator: (val) => val == null || val.length < 6 ? 'Min. 6 characters' : null,
                    ).animate().fadeIn(delay: 700.ms),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(foregroundColor: AppTheme.primaryColor),
                        child: const Text('Forgot Password?', style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ).animate().fadeIn(delay: 800.ms),
                    const SizedBox(height: 40),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return CustomButton(
                          text: 'Sign In',
                          isLoading: state is AuthLoading,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<AuthBloc>().add(
                                AuthLoginRequested(_emailController.text, _passwordController.text),
                              );
                            }
                          },
                        );
                      },
                    ).animate().fadeIn(delay: 900.ms).scale(begin: const Offset(0.9, 0.9)),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account?',
                          style: TextStyle(color: AppTheme.textSecondary),
                        ),
                        TextButton(
                          onPressed: () => context.go('/register'),
                          style: TextButton.styleFrom(foregroundColor: AppTheme.primaryColor),
                          child: const Text('Sign Up', style: TextStyle(fontWeight: FontWeight.w800)),
                        ),
                      ],
                    ).animate().fadeIn(delay: 1000.ms),
                  ],

                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
