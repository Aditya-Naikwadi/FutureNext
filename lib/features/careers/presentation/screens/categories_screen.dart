import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:futurenext/features/careers/presentation/blocs/career_bloc.dart';
import 'package:futurenext/core/utils/icon_mapper.dart';
import 'package:futurenext/core/theme/app_theme.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<CareerBloc, CareerState>(
      builder: (context, state) {
        if (state is CareerCategoriesLoaded) {
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildAppBar(context, isDark),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 400,
                      mainAxisExtent: 180,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final cat = state.categories[index];
                        return RepaintBoundary(
                          child: _buildSectoreCard(context, cat, isDark)
                              .animate()
                              .fadeIn(delay: (index * 50).ms)
                              .slideY(begin: 0.1, end: 0),
                        );
                      },
                      childCount: state.categories.length,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget _buildAppBar(BuildContext context, bool isDark) {
    return SliverAppBar(
      expandedHeight: 140,
      pinned: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      centerTitle: false,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        onPressed: () => context.pop(),
      ),
      flexibleSpace: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: (isDark ? AppTheme.surfaceDark : Colors.white).withValues(alpha: 0.7),
            child: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.fromLTRB(60, 0, 24, 16),
              title: Text(
                'Professional Sectors',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w900,
                  fontSize: 24,
                  letterSpacing: -0.5,
                  color: isDark ? Colors.white : AppTheme.textPrimaryLight,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectoreCard(BuildContext context, dynamic cat, bool isDark) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.push('/category/${cat.id}'),
        borderRadius: BorderRadius.circular(32),
        child: Ink(
          padding: const EdgeInsets.all(24),
          decoration: AppTheme.glassDecoration(isDark: isDark).copyWith(
            color: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.white,
            boxShadow: AppTheme.softShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  IconMapper.getIcon(cat.icon),
                  color: AppTheme.primaryColor,
                  size: 28,
                ),
              ),
              const Spacer(),
              Text(
                cat.title,
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  height: 1.1,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${cat.subCareers.length} Career Paths',
                  style: const TextStyle(
                    color: AppTheme.primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
