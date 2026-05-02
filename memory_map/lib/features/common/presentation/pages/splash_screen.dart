import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memory_map/app/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.8, curve: Curves.elasticOut),
    );

    _controller.forward();

    // Navigate to home after a delay
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        context.go('/home');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Stack(
        children: [
          // Background Pattern
          Positioned.fill(
            child: Image.asset(
              'assets/images/MemoryMapSplash.png',
              fit: BoxFit.cover,
            ),
          ),
          // Gradient overlay for better contrast if needed
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.cream.withValues(alpha: 0.1),
                    AppColors.cream.withValues(alpha: 0.3),
                  ],
                ),
              ),
            ),
          ),
          // Centered Icon with animation
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 24,
                        spreadRadius: 4,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(32),
                  child: Image.asset(
                    'assets/images/MemoryMapIcon.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          // Optional loading indicator or text at the bottom
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  Text(
                    'MEMORY MAP',
                    style: TextStyle(
                      color: AppColors.coral,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 40,
                    height: 2,
                    child: LinearProgressIndicator(
                      backgroundColor: AppColors.coral.withValues(alpha: 0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.coral),
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
}
