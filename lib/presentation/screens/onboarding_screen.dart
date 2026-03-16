import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../domain/services/storage_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
      description: 'Take our scientific 25-question quiz to find careers that match your personality and skills.',
      icon: Icons.explore_rounded,
      color: const Color(0xFF6C63FF),
      gradient: const [Color(0xFF6C63FF), Color(0xFF8A84FF)],
    ),
    OnboardingData(
      title: 'Expert AI Guidance',
      description: 'Chat with our AI Career Guide anytime to get personalized advice on subjects, exams, and colleges.',
      icon: Icons.psychology_rounded,
      color: const Color(0xFF2EC4B6),
      gradient: const [Color(0xFF2EC4B6), Color(0xFF3BDAD8)],
    ),
    OnboardingData(
      title: 'Detailed Roadmaps',
      description: 'Explore over 40+ career paths with detailed information on salary, top colleges, and entrance exams.',
      icon: Icons.map_rounded,
      color: const Color(0xFFFF9F1C),
      gradient: const [Color(0xFFFF9F1C), Color(0xFFFFB74D)],
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
            bottom: 60,
            left: 24,
            right: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => _controller.jumpToPage(pages.length - 1),
                  child: Text(
                    'Skip',
                    style: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.w600),
                  ),
                ),
                SmoothPageIndicator(
                  controller: _controller,
                  count: pages.length,
                  effect: ExpandingDotsEffect(
                    activeDotColor: pages[_controller.hasClients ? _controller.page?.round() ?? 0 : 0].color,
                    dotColor: Colors.grey[200]!,
                    dotHeight: 8,
                    dotWidth: 8,
                    expansionFactor: 4,
                  ),
                ),
                GestureDetector(
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
                          color: pages[_controller.hasClients ? _controller.page?.round() ?? 0 : 0].color.withAlpha(77),
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
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        if (!onLastPage) ...[
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
          // Animated Circle Background
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [data.gradient[0].withAlpha(51), data.gradient[1].withAlpha(25)],
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
          const SizedBox(height: 80),
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
              color: Color(0xFF2D3142),
            ),
          ).animate().fadeIn(duration: 600.ms, delay: 200.ms).moveY(begin: 30, end: 0),
          const SizedBox(height: 20),
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              height: 1.6,
              color: Colors.grey[600],
              fontWeight: FontWeight.w400,
            ),
          ).animate().fadeIn(duration: 600.ms, delay: 400.ms).moveY(begin: 30, end: 0),
        ],
      ),
    );
  }
}
