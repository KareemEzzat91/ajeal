import 'package:ajeal/Admin/Screens/AdminLoginScreen/LoginScreen.dart';
import 'package:ajeal/Parents/ParentLoginPage/ParentLoginPage.dart';
import 'package:ajeal/helpers/generated/l10n.dart';
import 'package:ajeal/helpers/theme/DarkTheme/ThemeCubit/themes_cubit.dart';
import 'package:flutter/material.dart';
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
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  isDarkMode
                      ? 'assets/images/freepik__deep-blue-to-purple-gradient-background-with-subtl__45166.jpeg' // Add these images to your assets
                      : 'assets/images/freepik__a-subtle-lightcolored-gradient-background-for-a-ph__45167.jpeg',
                ),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).scaffoldBackgroundColor,
                  BlendMode.srcOver,
                ),
              ),
            ),
          ),

          // Gradient overlay
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

          // Main content
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App bar with settings
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Logo or app name
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .surface
                             ,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.school,
                              color: Theme.of(context).colorScheme.primary,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Ajeal",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
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
                              themeCubit.changeLang();
                            },
                          ),
                          const SizedBox(width: 8),
                          _buildIconButton(
                            context,
                            icon:
                                isDarkMode ? Icons.light_mode : Icons.dark_mode,
                            tooltip: S.of(context).changeTheme,
                            onPressed: () {
                              themeCubit.toggleTheme(!isDarkMode);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: size.height * 0.06),

                  // Welcome illustration
                  Center(
                    child: Container(
                      height: size.height * 0.25,
                      width: size.height * 0.25,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context)
                            .colorScheme
                            .surface
                            ,
                        boxShadow: [
                          BoxShadow(
                            color:
                                Theme.of(context).shadowColor,
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                        image: const DecorationImage(
                          image: AssetImage(
                              'assets/images/Untitled design.png'), // Add this image to your assets
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: size.height * 0.03),

                  // Header
                  Center(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                               ,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                           S.of(context).selectRole,
                            style:  TextStyle(
                              fontSize: 16,
                              color:isDarkMode? Colors.black:Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: size.height * 0.05),

                  // Role selection cards
                  _buildOptionCard(
                    context,
                    icon: Icons.family_restroom,
                    label: S.of(context).parents,
                    description:
                        S.of(context).loginAsParent,
                    gradientColors: isDarkMode
                        ? [const Color(0xFF9C27B0), const Color(0xFF673AB7)]
                        : [const Color(0xFFE1BEE7), const Color(0xFF9C27B0)],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ParentLoginPage()),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildOptionCard(
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
                        MaterialPageRoute(
                            builder: (context) => AdminLoginScreen()),
                      );
                    },
                  ),

                  const Spacer(),

                  // Footer
                  Center(
                    child: Text(
                      "© 2025 Ajeal Education System",
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                        fontSize: 12,
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
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.primary,
        padding: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildOptionCard(
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
            color: gradientColors.last,
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
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      icon,
                      size: 34,
                      color: Colors.white,
                    ),
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
                          style:const  TextStyle(
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
                    decoration:const  BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
