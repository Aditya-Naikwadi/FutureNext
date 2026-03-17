import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/services.dart';
import 'package:futurenext/data/models/quiz_model.dart';
import 'package:futurenext/features/quiz/presentation/blocs/quiz_bloc.dart';
import 'package:futurenext/core/theme/app_theme.dart';
import 'package:futurenext/core/constants/app_strings.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryColor.withValues(alpha: 0.05),
              Theme.of(context).scaffoldBackgroundColor,
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              BlocBuilder<QuizBloc, QuizState>(
                builder: (context, state) {
                  int count = 0;
                  if (state is QuizInProgress) count = state.questionCount;
                  return _buildQuizHeader(context, count);
                },
              ),
              Expanded(
                child: BlocConsumer<QuizBloc, QuizState>(
                  listener: (context, state) {
                    if (state is QuizResult) {
                      context.push('/quiz-result', extra: state.results);
                    }
                  },
                  builder: (context, state) {
                    if (state is QuizInitial) {
                      return _buildStartView(context, isDark);
                    } else if (state is QuizInProgress) {
                      return _buildQuestionView(context, state, isDark);
                    } else if (state is QuizLoading) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(),
                            const SizedBox(height: 24),
                            Text(
                              state.message,
                              style: Theme.of(context).textTheme.titleMedium,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    } else if (state is QuizError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error_outline, size: 48, color: Colors.red),
                              const SizedBox(height: 16),
                              Text(state.message, textAlign: TextAlign.center),
                              const SizedBox(height: 24),
                              ElevatedButton(
                                onPressed: () => context.read<QuizBloc>().add(QuizRestarted()),
                                child: const Text('Try Again'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuizHeader(BuildContext context, int questionCount) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Row(
        children: [
          IconButton.filledTonal(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.close_rounded, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  questionCount > 0 ? 'Question $questionCount of 10' : 'Goal Discovery',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  questionCount > 0 ? 'Evaluating your unique traits' : 'Answer honestly for best results',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartView(BuildContext context, bool isDark) {
    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.psychology_rounded, size: 100, color: AppTheme.primaryColor)
                  .animate(onPlay: (controller) => controller.repeat(reverse: true))
                  .scale(duration: 2000.ms, begin: const Offset(0.9, 0.9), end: const Offset(1.1, 1.1), curve: Curves.easeInOut),
            ),
            const SizedBox(height: 40),
            Text(
              AppStrings.quizHeroTitle,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              AppStrings.quizHeroSubtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 60),
            SizedBox(
              width: double.infinity,
              height: 64,
              child: ElevatedButton(
                onPressed: () => context.read<QuizBloc>().add(QuizStarted()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Start Assessment', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                    SizedBox(width: 12),
                    Icon(Icons.arrow_forward_rounded),
                  ],
                ),
              ),
            ).animate().slideY(begin: 0.5, end: 0, duration: 600.ms, curve: Curves.easeOutBack).fadeIn(),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildQuestionView(BuildContext context, QuizInProgress state, bool isDark) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),
                  decoration: AppTheme.glassDecoration(isDark: isDark).copyWith(
                    color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.9),
                    boxShadow: AppTheme.premiumShadow,
                  ),
                  child: Text(
                    state.text,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      height: 1.4,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                      color: isDark ? Colors.white : AppTheme.textPrimaryLight,
                    ),
                  ),
                ).animate(key: ValueKey(state.text)).fadeIn().slideY(begin: 0.1, end: 0),
                const SizedBox(height: 32),
                if (state.options.isNotEmpty) ...[
                  Text(
                    'CHOOSE ONE OPTION',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                      letterSpacing: 1.5,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...state.options.map((optionText) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildOptionCard(context, optionText)
                        .animate(key: ValueKey(optionText))
                        .fadeIn(delay: 100.ms)
                        .slideX(begin: 0.1, end: 0),
                  )),
                ] else ...[
                  // If no options, we are likely waiting for AI analysis
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 20),
                          Text('Analyzing your unique traits...'),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOptionCard(BuildContext context, String optionText) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          // Map string to QuizOption
          context.read<QuizBloc>().add(QuizAnswerSelected(QuizOption(text: optionText, scores: const {})));
        },
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          decoration: BoxDecoration(
            color: isDark ? AppTheme.surfaceDark : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
              width: 1.5,
            ),
            boxShadow: AppTheme.softShadow,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  optionText,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Icon(
                Icons.arrow_forward_ios_rounded, 
                size: 14, 
                color: AppTheme.primaryColor
              ),
            ],
          ),
        ),
      ),
    );
  }
}
