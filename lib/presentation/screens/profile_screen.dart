import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/auth_bloc.dart';
import '../widgets/custom_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Unauthenticated) {
            context.go('/login');
          }
        },
        builder: (context, state) {
          String name = 'Student';
          String email = '';
          if (state is Authenticated) {
            name = state.user.displayName ?? 'Student';
            email = state.user.email ?? '';
          }

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Color(0xFFF0EFFF),
                  child: Icon(Icons.person, size: 50, color: Color(0xFF6C63FF)),
                ),
                const SizedBox(height: 16),
                Text(name, style: Theme.of(context).textTheme.headlineSmall),
                Text(email, style: const TextStyle(color: Colors.grey)),
                const Spacer(),
                CustomButton(
                  text: 'Logout',
                  isSecondary: true,
                  onPressed: () {
                    context.read<AuthBloc>().add(AuthLogoutRequested());
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}
