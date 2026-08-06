import 'package:ajeal/admin/screens/admin_login_screen/login_screen.dart';
import 'package:ajeal/parents/parent_login_page/parent_login_page.dart';
import 'package:ajeal/helpers/generated/l10n.dart';
import 'package:ajeal/helpers/theme/dark_theme/theme_cubit/themes_cubit.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminOrParentsScreen extends StatelessWidget {
  const AdminOrParentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final themeCubit = context.read<ThemesCubit>();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Gradient overlay with animated pattern
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).scaffoldBackgroundColor,
                  Theme.of(context).scaffoldBackgroundColor,
                  Theme.of(context).scaffoldBackgroundColor,
                ],
              ),
            ),
          ),

          // Animated patterns or shapes for visual interest
          Positioned(
            top: size.height * 0.1,
            right: -20,
            child: FadeInRight(
              duration: const Duration(milliseconds: 1500),
              child: Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primary.withAlpha(40),
                ),
              ),
            ),
          ),

          Positioned(
            bottom: size.height * 0.2,
            left: -30,
            child: FadeInLeft(
              duration: const Duration(milliseconds: 1500),
              delay: const Duration(milliseconds: 500),
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.secondary.withAlpha(30),
                ),
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App bar with settings - animate from top
                  FadeInDown(
                    duration: const Duration(milliseconds: 800),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Logo or app name
                        Container(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              Icon(
                                Icons.school,
                                color: Theme.of(context).colorScheme.primary,
                                size: 24,
                              ).animate()
                                  .scale(delay: 300.ms, duration: 500.ms)
                                  .then(delay: 200.ms)
                                  .shake(hz: 4, curve: Curves.easeInOut),
                              const SizedBox(width: 8),
                              Text(
                                "Ajeal",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ).animate()
                                  .fadeIn(duration: 800.ms)
                                  .slide(begin: const Offset(-0.5, 0), duration: 500.ms),
                            ],
                          ),
                        ),

                        // Setting buttons
                        Row(
                          children: [
                            _buildIconButton(
                              context,
                              icon: Icons.language,
                              tooltip: S.of(context).changeLanguage,
                              onPressed: () {
                                themeCubit.toggleLanguage();
                              },
                            ).animate().fadeIn(delay: 400.ms, duration: 300.ms),
                            const SizedBox(width: 8),
                            _buildIconButton(
                              context,
                              icon: isDarkMode ? Icons.light_mode : Icons.dark_mode,
                              tooltip: S.of(context).changeTheme,
                              onPressed: () {
                                themeCubit.toggleTheme(!isDarkMode);
                              },
                            ).animate().fadeIn(delay: 600.ms, duration: 300.ms),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: size.height * 0.05),

                  // Welcome illustration with bounce animation
                  FadeInDown(
                    duration: const Duration(milliseconds: 1000),
                    child: Center(
                      child: Container(
                        height: size.height * 0.25,
                        width: size.height * 0.25,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.surface,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).shadowColor,
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                          image: const DecorationImage(
                            image: AssetImage('assets/images/Untitled design.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ).animate()
                        .fadeIn(duration: 800.ms)
                        .scale(
                      delay: 200.ms,
                      duration: 700.ms,
                      curve: Curves.elasticOut,
                    )
                        .then(delay: 1.seconds)
                        .shimmer(duration: 1.seconds),
                  ),

                  SizedBox(height: size.height * 0.03),

                  // Header with bounce effect
                  Center(
                    child: FadeInUp(
                      duration: const Duration(milliseconds: 1000),
                      delay: const Duration(milliseconds: 300),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          S.of(context).selectRole,
                          style: TextStyle(
                            fontSize: 16,
                            color: isDarkMode ? Colors.black : Colors.white,
                          ),
                        ),
                      ).animate()
                          .scale(
                          delay: 300.ms,
                          duration: 400.ms,
                          curve: Curves.bounceOut
                      ),
                    ),
                  ),

                  SizedBox(height: size.height * 0.05),

                  // Parent role card with slide-in animation
                  SlideInLeft(
                    duration: const Duration(milliseconds: 1000),
                    from: 50,
                    child: _buildAnimatedOptionCard(
                      context,
                      icon: Icons.family_restroom,
                      label: S.of(context).parents,
                      description: S.of(context).loginAsParent,
                      gradientColors: isDarkMode
                          ? [const Color(0xFF9C27B0), const Color(0xFF673AB7)]
                          : [const Color(0xFFE1BEE7), const Color(0xFF9C27B0)],
                      onTap: () {
                        // Add tap animation
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) =>
                            const ParentLoginPage(),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              var begin = const Offset(1.0, 0.0);
                              var end = Offset.zero;
                              var curve = Curves.easeInOut;
                              var tween = Tween(begin: begin, end: end).chain(
                                CurveTween(curve: curve),
                              );
                              return SlideTransition(
                                position: animation.drive(tween),
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Admin role card with slide-in animation
                  SlideInRight(
                    duration: const Duration(milliseconds: 1000),
                    from: 50,
                    child: _buildAnimatedOptionCard(
                      context,
                      icon: Icons.admin_panel_settings_outlined,
                      label: S.of(context).admin,
                      description: S.of(context).loginAsAdmin,
                      gradientColors: isDarkMode
                          ? [const Color(0xFF00BCD4), const Color(0xFF2196F3)]
                          : [const Color(0xFFB2EBF2), const Color(0xFF00BCD4)],
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) =>
                                AdminLoginScreen(),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              var begin = const Offset(1.0, 0.0);
                              var end = Offset.zero;
                              var curve = Curves.easeInOut;
                              var tween = Tween(begin: begin, end: end).chain(
                                CurveTween(curve: curve),
                              );
                              return SlideTransition(
                                position: animation.drive(tween),
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),

                  const Spacer(),

                  // Footer with fade-in animation
                  FadeInUp(
                    duration: const Duration(milliseconds: 800),
                    delay: const Duration(milliseconds: 1200),
                    child: Center(
                      child: Text(
                        "© 2025 Ajeal Education System",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontSize: 12,
                        ),
                      ),
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

  Widget _buildIconButton(
      BuildContext context, {
        required IconData icon,
        required String tooltip,
        required VoidCallback onPressed,
      }) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
      tooltip: tooltip,
      style: IconButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Theme.of(context).colorScheme.surface,
        padding: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildAnimatedOptionCard(
      BuildContext context, {
        required IconData icon,
        required String label,
        required String description,
        required List<Color> gradientColors,
        required VoidCallback onTap,
      }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: gradientColors.last.withAlpha(150),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    height: 64,
                    width: 64,
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(50),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      icon,
                      size: 34,
                      color: Colors.white,
                    ).animate()
                        .fade(duration: 300.ms)
                        .scale(delay: 200.ms),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          description,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(50),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 20,
                    ),
                  ).animate(onPlay: (controller) => controller.repeat())
                      .shake(delay: 2.seconds, duration: 700.ms, hz: 3)
                      .then(delay: 3.seconds),
                ],
              ),
            ),
          ),
        ),
      ),
    ).animate()
        .scale(
      begin: const Offset(0.97, 0.97),
      end: const Offset(1, 1),
      duration: 2.seconds,
      curve: Curves.easeInOut,
    )
        .then()
        .shimmer(delay: 1.seconds, duration: 1.seconds);
  }
}