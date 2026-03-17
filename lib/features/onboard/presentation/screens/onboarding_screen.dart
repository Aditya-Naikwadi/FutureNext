import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:futurenext/domain/services/storage_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:futurenext/core/theme/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool onLastPage = false;

  final List<OnboardingData> pages = [
    OnboardingData(
      title: 'Discover Your Path',
      description: 'Take our scientific assessment to find careers that match your unique personality and skills.',
      icon: Icons.auto_awesome_rounded,
      color: AppTheme.primaryColor,
      gradient: [AppTheme.primaryColor, Color(0xFF8B5CF6)],
    ),
    OnboardingData(
      title: 'Expert AI Guidance',
      description: 'Chat with our AI Career Guide anytime to get personalized advice on subjects and colleges.',
      icon: Icons.psychology_rounded,
      color: AppTheme.secondaryColor,
      gradient: [AppTheme.secondaryColor, Color(0xFF3BDAD8)],
    ),
    OnboardingData(
      title: 'Detailed Roadmaps',
      description: 'Explore 40+ career paths with detailed information on salary, colleges, and entrance exams.',
      icon: Icons.map_rounded,
      color: AppTheme.accentColor,
      gradient: [AppTheme.accentColor, Color(0xFFFFB74D)],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: pages.length,
            onPageChanged: (index) {
              setState(() => onLastPage = (index == pages.length - 1));
            },
            itemBuilder: (context, index) {
              return OnboardingPage(data: pages[index]);
            },
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => _controller.jumpToPage(pages.length - 1),
                      child: Text(
                        'Skip',
                        style: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.w700),
                      ),
                    ),
                    SmoothPageIndicator(
                      controller: _controller,
                      count: pages.length,
                      effect: ExpandingDotsEffect(
                        activeDotColor: pages[_controller.hasClients ? _controller.page?.round() ?? 0 : 0].color,
                        dotColor: const Color(0xFFF1F5F9),
                        dotHeight: 8,
                        dotWidth: 8,
                        expansionFactor: 4,
                      ),
                    ),
                    _buildNextButton(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (onLastPage) {
          final router = GoRouter.of(context);
          await context.read<StorageService>().setOnboardingSeen();
          router.go('/login');
        } else {
          _controller.nextPage(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOutQuart,
          );
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(
          horizontal: onLastPage ? 32 : 16,
          vertical: 16,
        ),
        decoration: BoxDecoration(
          color: pages[_controller.hasClients ? _controller.page?.round() ?? 0 : 0].color,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: pages[_controller.hasClients ? _controller.page?.round() ?? 0 : 0].color.withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Text(
              onLastPage ? 'Get Started' : 'Next',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
            if (!onLastPage) ...[
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.white),
            ],
          ],
        ),
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final List<Color> gradient;

  OnboardingData({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.gradient,
  });
}

class OnboardingPage extends StatelessWidget {
  final OnboardingData data;
  const OnboardingPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [data.gradient[0].withAlpha(38), data.gradient[1].withAlpha(13)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ).animate().scale(duration: 800.ms, curve: Curves.easeOutBack),
              Icon(data.icon, size: 120, color: data.color)
                  .animate(onPlay: (controller) => controller.repeat(reverse: true))
                  .moveY(begin: -10, end: 10, duration: 2.seconds, curve: Curves.easeInOut)
                  .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 2.seconds),
            ],
          ),
          const SizedBox(height: 60),
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              fontSize: 36,
              height: 1.1,
              letterSpacing: -1.5,
            ),
          ).animate().fadeIn(duration: 600.ms, delay: 200.ms).moveY(begin: 20, end: 0),
          const SizedBox(height: 20),
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.textSecondary,
              fontSize: 17,
              height: 1.6,
              fontWeight: FontWeight.w500,
            ),
          ).animate().fadeIn(duration: 600.ms, delay: 400.ms).moveY(begin: 20, end: 0),

        ],
      ),
    );
  }
}
