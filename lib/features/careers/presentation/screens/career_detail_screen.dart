import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:futurenext/features/careers/presentation/blocs/career_bloc.dart';
import 'package:futurenext/core/theme/app_theme.dart';

class CareerDetailScreen extends StatefulWidget {
  final String categoryId;
  final String subCareerId;
  const CareerDetailScreen({super.key, required this.categoryId, required this.subCareerId});

  @override
  State<CareerDetailScreen> createState() => _CareerDetailScreenState();
}

class _CareerDetailScreenState extends State<CareerDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CareerBloc>().add(SubCareerSelected(widget.categoryId, widget.subCareerId));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocBuilder<CareerBloc, CareerState>(
        builder: (context, state) {
          if (state is CareerDetailLoaded) {
            final career = state.subCareer;
            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildParallaxAppBar(context, career.title, isDark),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader('Overview', isDark)
                            .animate().fadeIn(duration: 400.ms).slideX(begin: -0.05, end: 0),
                        const SizedBox(height: 16),
                        Text(
                          career.overview,
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.7,
                            color: isDark ? Colors.white70 : AppTheme.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
                        const SizedBox(height: 48),
                        _buildSectionHeader('Required Skills', isDark)
                            .animate().fadeIn(delay: 200.ms),
                        const SizedBox(height: 20),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: career.skills.asMap().entries.map((e) => 
                            _buildSkillChip(e.value, isDark)
                                .animate()
                                .fadeIn(delay: (300 + e.key * 50).ms)
                                .scale(begin: const Offset(0.9, 0.9))
                          ).toList(),
                        ),
                        const SizedBox(height: 56),
                        _buildInfoGrid(career, isDark),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(
              color: AppTheme.primaryColor,
              strokeWidth: 3,
            ),
          );
        },
      ),
    );
  }

  Widget _buildParallaxAppBar(BuildContext context, String title, bool isDark) {
    return SliverAppBar(
      expandedHeight: 240,
      pinned: true,
      stretch: true,
      backgroundColor: AppTheme.primaryColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: IconButton.filledTonal(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        titlePadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
        stretchModes: const [StretchMode.zoomBackground, StretchMode.blurBackground],
        title: Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 26,
            letterSpacing: -0.5,
            shadows: [
              const Shadow(
                color: Colors.black26, 
                blurRadius: 10, 
                offset: Offset(0, 4)
              ),
            ],
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppTheme.primaryColor, Color(0xFF4338CA)],
                ),
              ),
            ),
            Positioned(
              right: -50,
              top: -50,
              child: Opacity(
                opacity: 0.1,
                child: const Icon(
                  Icons.auto_awesome_mosaic_rounded, 
                  size: 300, 
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.2),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.5),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Text(
      title,
      style: GoogleFonts.plusJakartaSans(
        fontWeight: FontWeight.w900,
        color: isDark ? Colors.white : const Color(0xFF0F172A),
        fontSize: 22,
        letterSpacing: -0.5,
      ),
    );
  }

  Widget _buildSkillChip(String skill, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: AppTheme.glassDecoration(isDark: isDark).copyWith(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        boxShadow: AppTheme.softShadow,
      ),
      child: Text(
        skill,
        style: TextStyle(
          color: isDark ? Colors.white : const Color(0xFF334155),
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildInfoGrid(dynamic career, bool isDark) {
    return Column(
      children: [
        _buildInfoCard('Entrance Exams', career.entranceExams.join(', '), Icons.assignment_rounded, 0, isDark),
        const SizedBox(height: 16),
        _buildInfoCard('Salary Range', career.salaryRange, Icons.payments_rounded, 1, isDark),
        const SizedBox(height: 16),
        _buildInfoCard('Top Colleges', (career.topColleges as List).take(3).join(', '), Icons.account_balance_rounded, 2, isDark),
      ],
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon, int index, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: AppTheme.glassDecoration(isDark: isDark).copyWith(
        color: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.white,
        boxShadow: AppTheme.softShadow,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppTheme.primaryColor, size: 24),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  style: GoogleFonts.plusJakartaSans(
                    color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w800,
                    fontSize: 17,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: (400 + index * 100).ms).slideY(begin: 0.1, end: 0);
  }
}
