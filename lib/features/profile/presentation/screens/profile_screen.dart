import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:futurenext/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:futurenext/widgets/common/custom_button.dart';
import 'package:futurenext/widgets/common/custom_textfield.dart';
import 'package:futurenext/core/theme/app_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:futurenext/domain/services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;
  bool _isLoadingMetadata = true;
  final _nameController = TextEditingController();
  final _schoolController = TextEditingController();
  final _gradeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final state = context.read<AuthBloc>().state;
    if (state is Authenticated) {
      _nameController.text = state.user.displayName ?? '';
      
      final profile = await context.read<AuthService>().getUserProfile(state.user.uid);
      if (profile != null && mounted) {
        setState(() {
          _schoolController.text = profile['school'] ?? '';
          _gradeController.text = profile['grade'] ?? '10th';
          _isLoadingMetadata = false;
        });
      } else if (mounted) {
        setState(() => _isLoadingMetadata = false);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _schoolController.dispose();
    _gradeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w900,
            fontSize: 24,
            color: isDark ? Colors.white : AppTheme.textPrimaryLight,
            letterSpacing: -1,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          if (!_isEditing)
            IconButton(
              icon: Icon(Icons.edit_note_rounded, color: AppTheme.primaryColor),
              onPressed: () => setState(() => _isEditing = true),
            ),
        ],
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Unauthenticated) {
            context.go('/login');
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          String name = _nameController.text.isNotEmpty ? _nameController.text : 'Student';
          String email = '';
          if (state is Authenticated) {
            email = state.user.email ?? 'student@futurenext.com';
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Stack(
                    children: [
                      Hero(
                        tag: 'profile_avatar',
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppTheme.primaryColor.withValues(alpha: 0.3),
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryColor.withValues(alpha: 0.2),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/avatar.png',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                                  child: const Icon(Icons.person_rounded, size: 60, color: AppTheme.primaryColor),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
                      if (!_isEditing)
                        Positioned(
                          bottom: 4,
                          right: 4,
                          child: InkWell(
                            onTap: () => setState(() => _isEditing = true),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [AppTheme.primaryColor, Color(0xFF4338CA)],
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x406366F1),
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.camera_alt_rounded, 
                                size: 18, 
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ).animate().fadeIn(delay: 400.ms).scale(),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                if (_isEditing)
                  _buildEditForm(context, isDark)
                else
                  _buildProfileView(context, isDark, name, email),
                
                const SizedBox(height: 48),
                if (!_isEditing)
                  CustomButton(
                    text: 'Logout',
                    isSecondary: true,
                    onPressed: () {
                      context.read<AuthBloc>().add(AuthLogoutRequested());
                    },
                  ).animate().fadeIn(delay: 700.ms).scale(begin: const Offset(0.9, 0.9)),
                
                if (!_isEditing) ...[
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => _showDeleteConfirmation(context),
                    child: Text(
                      'Delete Account',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.redAccent.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ).animate().fadeIn(delay: 800.ms),
                ],
                
                const SizedBox(height: 24),
                Text(
                  'App Version 1.0.0',
                  style: GoogleFonts.plusJakartaSans(
                    color: isDark ? Colors.white24 : AppTheme.textSecondary.withValues(alpha: 0.4),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ).animate().fadeIn(delay: 900.ms),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileView(BuildContext context, bool isDark, String name, String email) {
    return Column(
      children: [
        Text(
          name,
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w900,
            fontSize: 28,
            color: isDark ? Colors.white : AppTheme.textPrimaryLight,
            letterSpacing: -0.5,
          ),
        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
        const SizedBox(height: 4),
        Text(
          email,
          style: GoogleFonts.plusJakartaSans(
            color: isDark ? Colors.white60 : AppTheme.textSecondary,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ).animate().fadeIn(delay: 300.ms),
        const SizedBox(height: 56),
        if (_isLoadingMetadata)
          const ShimmerProfileItems()
        else ...[
          _buildProfileItem(
            context: context,
            isDark: isDark,
            icon: Icons.school_outlined,
            title: _schoolController.text,
            subtitle: 'Current School',
          ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.05, end: 0),
          const SizedBox(height: 16),
          _buildProfileItem(
            context: context,
            isDark: isDark,
            icon: Icons.grade_outlined,
            title: 'Grade ${_gradeController.text}',
            subtitle: 'Academic Year',
          ).animate().fadeIn(delay: 500.ms).slideX(begin: 0.05, end: 0),
          const SizedBox(height: 16),
          _buildProfileItem(
            context: context,
            isDark: isDark,
            icon: Icons.shield_outlined,
            title: 'Privacy & Security',
            subtitle: 'Passwords and data protection',
          ).animate().fadeIn(delay: 600.ms).slideX(begin: 0.05, end: 0),
        ],
      ],
    );
  }

  Widget _buildEditForm(BuildContext context, bool isDark) {
    return Column(
      children: [
        CustomTextField(
          label: 'Full Name',
          controller: _nameController,
          hint: 'Enter your name',
          prefixIcon: Icons.person_outline_rounded,
        ),
        const SizedBox(height: 20),
        CustomTextField(
          label: 'School Name',
          controller: _schoolController,
          hint: 'Enter your school',
          prefixIcon: Icons.school_outlined,
        ),
        const SizedBox(height: 20),
        CustomTextField(
          label: 'Grade/Class',
          controller: _gradeController,
          hint: 'e.g. 10th',
          prefixIcon: Icons.grade_outlined,
        ),
        const SizedBox(height: 40),
        Row(
          children: [
            Expanded(
              child: CustomButton(
                text: 'Cancel',
                isSecondary: true,
                onPressed: () {
                  setState(() => _isEditing = false);
                  _fetchUserData(); // Reset to current data
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomButton(
                text: 'Save Changes',
                onPressed: () {
                  context.read<AuthBloc>().add(AuthProfileUpdateRequested(
                    name: _nameController.text,
                    school: _schoolController.text,
                    grade: _gradeController.text,
                  ));
                  setState(() => _isEditing = false);
                },
              ),
            ),
          ],
        ),
      ],
    ).animate().fadeIn();
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account?'),
        content: const Text('This action is permanent and will delete all your data including assessment results.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<AuthBloc>().add(AuthAccountDeletionRequested());
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem({
    required BuildContext context,
    required bool isDark,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.glassDecoration(isDark: isDark).copyWith(
        color: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.white,
        boxShadow: AppTheme.softShadow,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: AppTheme.primaryColor, size: 24),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: isDark ? Colors.white : AppTheme.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.plusJakartaSans(
                    color: isDark ? Colors.white60 : AppTheme.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded, 
            color: isDark ? Colors.white24 : const Color(0xFFCBD5E1),
          ),
        ],
      ),
    );
  }
}

class ShimmerProfileItems extends StatelessWidget {
  const ShimmerProfileItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(3, (index) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      )),
    );
  }
}

