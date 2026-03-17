import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:futurenext/features/careers/presentation/blocs/career_bloc.dart';
import 'package:futurenext/core/utils/icon_mapper.dart';
import 'package:futurenext/core/theme/app_theme.dart';

class CategoryCareersScreen extends StatelessWidget {
  final String categoryId;

  const CategoryCareersScreen({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<CareerBloc, CareerState>(
      builder: (context, state) {
        if (state is CareerCategoriesLoaded) {
          final category = state.categories.firstWhere(
            (c) => c.id == categoryId,
            orElse: () => state.categories.first,
          );

          return Scaffold(
            body: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildSliverAppBar(context, category.title, isDark),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
                  sliver: SliverLayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.crossAxisExtent > 700) {
                        return SliverGrid(
                          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 400,
                            mainAxisExtent: 115,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final sub = category.subCareers[index];
                              return RepaintBoundary(
                                child: _buildCareerCard(context, sub, category.id, isDark)
                                    .animate()
                                    .fadeIn(delay: (index * 50).ms)
                                    .slideY(begin: 0.1, end: 0),
                              );
                            },
                            childCount: category.subCareers.length,
                          ),
                        );
                      }
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final sub = category.subCareers[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _buildCareerCard(context, sub, category.id, isDark)
                                  .animate()
                                  .fadeIn(delay: (index * 50).ms)
                                  .slideY(begin: 0.1, end: 0),
                            );
                          },
                          childCount: category.subCareers.length,
                        ),
                      );
                    },
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

  Widget _buildSliverAppBar(BuildContext context, String title, bool isDark) {
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: (isDark ? AppTheme.surfaceDark : Colors.white).withValues(alpha: 0.7),
            child: FlexibleSpaceBar(
              centerTitle: false,
              titlePadding: const EdgeInsets.fromLTRB(60, 0, 24, 16),
              title: Text(
                title,
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
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        onPressed: () => context.pop(),
      ),
    );
  }

  Widget _buildCareerCard(BuildContext context, dynamic sub, String catId, bool isDark) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.push('/career/$catId/${sub.id}'),
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          padding: const EdgeInsets.all(16),
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
                child: Icon(
                  IconMapper.getIcon(sub.icon),
                  color: AppTheme.primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      sub.title,
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      sub.description,
                      style: TextStyle(
                        color: isDark ? Colors.white60 : AppTheme.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppTheme.primaryColor, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
