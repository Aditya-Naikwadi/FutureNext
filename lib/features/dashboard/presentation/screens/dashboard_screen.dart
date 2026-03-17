import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/services.dart';
import 'package:futurenext/features/careers/presentation/blocs/career_bloc.dart';
import 'package:futurenext/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:futurenext/data/models/career_model.dart';
import 'package:futurenext/core/utils/icon_mapper.dart';
import 'package:futurenext/core/theme/app_theme.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildEliteAppBar(context, isDark),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _buildWelcomeSection(context, isDark)
                        .animate()
                        .fadeIn(duration: 800.ms, curve: Curves.easeOut)
                        .slideY(begin: 0.1, end: 0),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _buildSearchBar(context, isDark)
                        .animate()
                        .fadeIn(delay: 200.ms, duration: 800.ms)
                        .slideY(begin: 0.2, end: 0),
                  ),
                  const SizedBox(height: 32),
                  _buildFeaturedSection(context, isDark)
                      .animate()
                      .fadeIn(delay: 400.ms, duration: 800.ms),
                  const SizedBox(height: 48),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _buildCategoriesHeader(context, isDark)
                        .animate()
                        .fadeIn(delay: 600.ms),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: RepaintBoundary(child: _buildCategoriesGrid(context)),
                  ),
                  const SizedBox(height: 100), // Space for FAB
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildEliteFAB(context),
    );
  }

  Widget _buildEliteAppBar(BuildContext context, bool isDark) {
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      stretch: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        titlePadding: const EdgeInsets.only(left: 20, bottom: 20),
        title: Text(
          'FutureNext',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w900,
            color: isDark ? Colors.white : AppTheme.textPrimaryLight,
            fontSize: 24,
            letterSpacing: -1,
          ),
        ),
        background: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.7),
            ),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Hero(
            tag: 'profile_avatar',
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => context.push('/profile'),
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    shape: BoxShape.circle,
                    boxShadow: AppTheme.softShadow,
                    border: Border.all(
                      color: AppTheme.primaryColor.withValues(alpha: 0.2),
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/avatar.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: AppTheme.primaryColor.withValues(alpha: 0.1),
                        child: const Icon(Icons.person_rounded, color: AppTheme.primaryColor),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.softShadow,
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
          width: 1.5,
        ),
      ),
      child: TextField(
        style: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : AppTheme.textPrimaryLight,
        ),
        decoration: InputDecoration(
          hintText: 'Search your dream career...',
          hintStyle: GoogleFonts.plusJakartaSans(
            color: AppTheme.textSecondary,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.primaryColor, size: 24),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
    );
  }

  Widget _buildFeaturedSection(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Elite Guidance',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                  color: isDark ? Colors.white : AppTheme.textPrimaryLight,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            physics: const BouncingScrollPhysics(),
            children: [
              _buildFeaturedCard(
                context,
                'Start Assessment',
                'AI-powered mapping',
                AppTheme.primaryGradient,
                Icons.psychology_rounded,
                () => context.push('/quiz'),
              ),
              _buildFeaturedCard(
                context,
                'Elite Career Chat',
                'Advanced AI Agent',
                const LinearGradient(
                  colors: [Color(0xFF10B981), Color(0xFF059669)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                Icons.auto_awesome_rounded,
                () => context.push('/chat'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedCard(
    BuildContext context, 
    String title, 
    String subtitle, 
    Gradient gradient, 
    IconData icon,
    VoidCallback onTap,
  ) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(28),
          child: Ink(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: (gradient as LinearGradient).colors.first.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -10,
                  bottom: -10,
                  child: Icon(
                    icon,
                    size: 100,
                    color: Colors.white.withValues(alpha: 0.15),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(icon, color: Colors.white, size: 24),
                    ),
                    const Spacer(),
                    Text(
                      title,
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ).animate().scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1), duration: 200.ms),
    );
  }

  Widget _buildEliteFAB(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: FloatingActionButton.extended(
        onPressed: () => context.push('/chat'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 10,
        label: const Text('AI Assistant', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
        icon: const Icon(Icons.auto_awesome_rounded, size: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ).animate().scale(delay: 800.ms, duration: 400.ms, curve: Curves.elasticOut),
    );
  }

  Widget _buildWelcomeSection(BuildContext context, bool isDark) {
    final state = context.watch<AuthBloc>().state;
    String name = 'Explorer';
    if (state is Authenticated) {
      name = state.user.displayName?.split(' ').first ?? 'Student';
    }
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.03) : AppTheme.primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : AppTheme.primaryColor.withValues(alpha: 0.1),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Hello, $name',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white : AppTheme.textPrimaryLight,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 8),
              const Text('✨', style: TextStyle(fontSize: 24)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Your career engineer is ready.\nWhat shall we explore today?',
            style: GoogleFonts.plusJakartaSans(
              color: isDark ? Colors.white60 : AppTheme.textSecondary,
              fontWeight: FontWeight.w600,
              fontSize: 15,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesHeader(BuildContext context, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Future Domains',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w900,
            fontSize: 22,
            color: isDark ? Colors.white : AppTheme.textPrimaryLight,
            letterSpacing: -0.5,
          ),
        ),
        TextButton(
          onPressed: () => context.push('/categories'),
          style: TextButton.styleFrom(
            foregroundColor: AppTheme.primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Row(
            children: [
              Text('Elite View', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800)),
              const SizedBox(width: 4),
              const Icon(Icons.arrow_forward_ios_rounded, size: 12),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesGrid(BuildContext context) {
    return BlocBuilder<CareerBloc, CareerState>(
      builder: (context, state) {
        if (state is CareerCategoriesLoaded) {
          return GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: MediaQuery.of(context).size.width > 600 ? 1.1 : 0.8,
            ),
            itemCount: state.categories.length > 4 ? 4 : state.categories.length,
            itemBuilder: (context, index) {
              final cat = state.categories[index];
              return _buildCategoryCard(context, cat)
                  .animate()
                  .fadeIn(delay: (300 + (index * 80)).ms, duration: 600.ms)
                  .slideY(begin: 0.1, end: 0, curve: Curves.easeOutBack);
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildCategoryCard(BuildContext context, CareerCategory category) {
    return _CategoryCard(category: category);
  }
}

class _CategoryCard extends StatefulWidget {
  final CareerCategory category;
  const _CategoryCard({required this.category});

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTapDown: (_) => setState(() => isPressed = true),
      onTapUp: (_) => setState(() => isPressed = false),
      onTapCancel: () => setState(() => isPressed = false),
      onTap: () {
        HapticFeedback.mediumImpact();
        context.push('/category/${widget.category.id}');
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        transform: Matrix4.diagonal3Values(
          isPressed ? 0.96 : 1.0, 
          isPressed ? 0.96 : 1.0, 
          1.0,
        ),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: isPressed 
              ? AppTheme.primaryColor.withValues(alpha: 0.3) 
              : (isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.03)),
            width: 2,
          ),
          boxShadow: isPressed ? [] : [
            BoxShadow(
              color: isDark ? Colors.black45 : Colors.black.withValues(alpha: 0.03),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: isDark ? Colors.black26 : Colors.black.withValues(alpha: 0.02),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                IconMapper.getIcon(widget.category.icon),
                color: AppTheme.primaryColor,
                size: 28,
              ),
            ),
            const Spacer(),
            Text(
              widget.category.title,
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w900,
                fontSize: 18,
                height: 1.1,
                color: isDark ? Colors.white : AppTheme.textPrimaryLight,
                letterSpacing: -0.5,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withValues(alpha: 0.05) : AppTheme.primaryColor.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${widget.category.subCareers.length} Paths',
                    style: GoogleFonts.plusJakartaSans(
                      color: AppTheme.primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 16,
                  color: isDark ? Colors.white24 : Colors.black12,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

