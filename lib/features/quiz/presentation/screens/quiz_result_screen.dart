import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:futurenext/domain/services/onet_service.dart';
import 'package:futurenext/data/models/occupation_model.dart';
import 'package:futurenext/data/models/assessment_model.dart';
import 'package:futurenext/widgets/common/custom_button.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:futurenext/core/theme/app_theme.dart';

class QuizResultScreen extends StatefulWidget {
  final AssessmentResults results;

  const QuizResultScreen({super.key, required this.results});

  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  OccupationDetails? _onetDetails;
  bool _isLoadingOnet = true;

  @override
  void initState() {
    super.initState();
    _fetchOnetDetails();
  }

  Future<void> _fetchOnetDetails() async {
    final onetService = context.read<OnetService>();
    final topRole = widget.results.results.first.role;
    
    try {
      // First search for the code, then get details
      final codes = await onetService.searchOccupations(topRole);
      if (codes.isNotEmpty) {
        final details = await onetService.getOccupationDetails(codes.first['code']!);
        if (mounted) {
          setState(() {
            _onetDetails = details;
            _isLoadingOnet = false;
          });
        }
      } else {
        if (mounted) {
          setState(() => _isLoadingOnet = false);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingOnet = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final results = widget.results;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 80, 24, 40),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.stars_rounded, size: 40, color: AppTheme.primaryColor),
                  ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
                  const SizedBox(height: 24),
                  Text(
                    'Your Assessment Results',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w900,
                      fontSize: 32,
                      letterSpacing: -1,
                      color: isDark ? Colors.white : AppTheme.textPrimaryLight,
                    ),
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
                  const SizedBox(height: 8),
                  Text(
                    'Based on your interests in ${results.domain}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isDark ? Colors.white60 : AppTheme.textSecondary, 
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ).animate().fadeIn(delay: 400.ms),
                ],
              ),
            ),
          ),
          
          // SECTION 1: Top Recommendation Card
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverToBoxAdapter(
              child: _buildTopRoleCard(context, results.results.first, isDark)
                  .animate().fadeIn(delay: 600.ms).scale(begin: const Offset(0.95, 0.95)),
            ),
          ),

          // SECTION: O*NET Elite Insights
          if (_isLoadingOnet)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: Center(child: CircularProgressIndicator()),
              ),
            )
          else if (_onetDetails != null)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
              sliver: SliverToBoxAdapter(
                child: _buildOnetInsightsCard(isDark),
              ),
            ),

          // Role Narration (AI Generated)
          if (results.topRoleCard != null)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
              sliver: SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: AppTheme.glassDecoration(isDark: isDark),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Why this fits you:',
                        style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w900, fontSize: 18),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        results.topRoleCard!,
                        style: TextStyle(
                          color: isDark ? Colors.white70 : AppTheme.textSecondary,
                          fontSize: 15,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 700.ms),
              ),
            ),

          // SECTION 2: Rankings Table
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Full Comparison',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                  letterSpacing: -0.5,
                ),
              ).animate().fadeIn(delay: 800.ms),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final rec = results.results[index];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
                  child: _buildRankingRow(context, rec, isDark)
                      .animate()
                      .fadeIn(delay: (900 + index * 50).ms)
                      .slideX(begin: 0.05, end: 0),
                );
              },
              childCount: results.results.length,
            ),
          ),

          // SECTION 3: Career Roadmap
          if (results.roadmap != null) ...[
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Your 3-Phase Roadmap',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                    letterSpacing: -0.5,
                  ),
                ).animate().fadeIn(delay: 1000.ms),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.1)),
                  ),
                  child: Text(
                    results.roadmap!,
                    style: TextStyle(
                      color: isDark ? Colors.white70 : AppTheme.textSecondary,
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),
                ).animate().fadeIn(delay: 1100.ms),
              ),
            ),
          ],

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 80),
              child: Column(
                children: [
                  CustomButton(
                    text: 'Explore All Careers',
                    onPressed: () => context.go('/dashboard'),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () => context.go('/quiz'),
                    child: Text(
                      'Retake Assessment',
                      style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnetInsightsCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: AppTheme.glassDecoration(isDark: isDark).copyWith(
        border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.3), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.rocket_launch_rounded, color: AppTheme.primaryColor),
              const SizedBox(width: 12),
              Text(
                'ELITE INSIGHTS',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  letterSpacing: 2,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildInsightItem(Icons.trending_up_rounded, 'Job Outlook', _onetDetails!.outlook, isDark),
          _buildInsightItem(Icons.payments_rounded, 'Median Salary', _onetDetails!.medianSalary, isDark),
          _buildInsightItem(Icons.school_rounded, 'Edu. Level', _onetDetails!.education, isDark),
          const Divider(height: 32),
          Text(
            'Core Skills Required:',
            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 16),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _onetDetails!.skills.map((skill) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                skill,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
              ),
            )).toList(),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.1, end: 0);
  }

  Widget _buildInsightItem(IconData icon, String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: isDark ? Colors.white60 : AppTheme.textSecondary),
          const SizedBox(width: 12),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w900, color: AppTheme.primaryColor)),
        ],
      ),
    );
  }

  Widget _buildTopRoleCard(BuildContext context, CareerRecommendation rec, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(36),
        boxShadow: AppTheme.premiumShadow,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'TOP MATCH: ${rec.fitPercentage}%',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w900, 
                color: Colors.white, 
                letterSpacing: 1.5,
                fontSize: 11,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            rec.role,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 34, 
              fontWeight: FontWeight.w900, 
              color: Colors.white,
              letterSpacing: -1,
              height: 1.1,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'MATCH TIER: ${rec.matchTier}',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankingRow(BuildContext context, CareerRecommendation rec, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.glassDecoration(isDark: isDark).copyWith(
        color: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.white,
        boxShadow: AppTheme.softShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Text(
              '${rec.rank}',
              style: const TextStyle(fontWeight: FontWeight.w900, color: AppTheme.primaryColor),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rec.role, 
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w800, 
                    fontSize: 16, 
                    color: isDark ? Colors.white : AppTheme.textPrimaryLight,
                  ),
                ),
                Text(
                  rec.matchTier,
                  style: TextStyle(
                    color: isDark ? Colors.white60 : AppTheme.textSecondary, 
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${rec.fitPercentage}%',
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w900,
              fontSize: 18,
              color: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
