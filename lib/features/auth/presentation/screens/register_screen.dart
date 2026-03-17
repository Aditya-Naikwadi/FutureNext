import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:futurenext/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:futurenext/widgets/common/custom_button.dart';
import 'package:futurenext/widgets/common/custom_textfield.dart';
import 'package:futurenext/core/constants/app_strings.dart';
import 'package:futurenext/core/theme/app_theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _schoolController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _schoolController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(
                      child: Icon(
                        Icons.stars_rounded, 
                        size: 72, 
                        color: AppTheme.primaryColor,
                      ),
                    ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
                    const SizedBox(height: 32),
                    Text(
                      AppStrings.registerHeroTitle,
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            fontSize: 32,
                            height: 1.1,
                          ),
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
                    const SizedBox(height: 48),
                    CustomTextField(
                      label: 'Full Name',
                      hint: 'Jane Doe',
                      prefixIcon: Icons.person_rounded,
                      controller: _nameController,
                      validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                    ).animate().fadeIn(delay: 400.ms),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: 'Email Address',
                      hint: 'jane@example.com',
                      prefixIcon: Icons.email_rounded,
                      controller: _emailController,
                      validator: (val) => val == null || !val.contains('@') ? 'Invalid email' : null,
                    ).animate().fadeIn(delay: 500.ms),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: 'Password',
                      hint: '••••••••',
                      prefixIcon: Icons.lock_rounded,
                      isPassword: true,
                      controller: _passwordController,
                      validator: (val) => val == null || val.length < 6 ? 'Min 6 chars' : null,
                    ).animate().fadeIn(delay: 600.ms),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: 'School Name (Optional)',
                      hint: 'Springfield High',
                      prefixIcon: Icons.school_rounded,
                      controller: _schoolController,
                    ).animate().fadeIn(delay: 700.ms),
                    const SizedBox(height: 48),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return CustomButton(
                          text: 'Create Account',
                          isLoading: state is AuthLoading,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<AuthBloc>().add(
                                    AuthRegisterRequested(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                      name: _nameController.text,
                                      school: _schoolController.text,
                                    ),
                                  );
                            }
                          },
                        );
                      },
                    ).animate().fadeIn(delay: 800.ms).scale(begin: const Offset(0.9, 0.9)),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
                          style: TextStyle(color: AppTheme.textSecondary),
                        ),
                        TextButton(
                          onPressed: () => context.go('/login'),
                          style: TextButton.styleFrom(foregroundColor: AppTheme.primaryColor),
                          child: const Text('Login', style: TextStyle(fontWeight: FontWeight.w800)),
                        ),
                      ],
                    ).animate().fadeIn(delay: 900.ms),
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

