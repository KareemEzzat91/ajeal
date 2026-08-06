import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/models/child_model/child_model.dart';
import '../../core/theme/dark_theme/theme_cubit/themes_cubit.dart';
import 'child_action_cards.dart';
import 'child_app_bar.dart';
import 'child_profile_section_name_age.dart';
import 'child_progress.dart';
import 'child_quickstats.dart';
import 'emergency_contact_dialog.dart';

class ParentHomePage extends StatelessWidget {
  final String parentCode;
  final Child child;
  final String adminId;

  const ParentHomePage({
    super.key,
    required this.parentCode,
    required this.child,
    required this.adminId,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final locale = context.watch<ThemesCubit>().state.loc.languageCode;
    final themeCubit = context.read<ThemesCubit>();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          ChildAppBar(
            context: context,
            isDarkMode: isDarkMode,
            locale: locale,
            themeCubit: themeCubit,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// إضافة FadeInDown عند تحميل بيانات الطفل
                  FadeInDown(
                    duration: 600.ms,
                    child: ChildProfileHeader(
                        child: child, isDarkMode: isDarkMode),
                  ),
                  const SizedBox(height: 24),

                  /// إضافة SlideInUp لإحصائيات الطفل
                  SlideInUp(
                    duration: 800.ms,
                    child: ChildQuickStats(child: child, context: context),
                  ),
                  const SizedBox(height: 24),

                  /// إضافة ZoomIn لتحميل قسم التقدم
                  ZoomIn(
                    duration: 1000.ms,
                    child: ChildProgressSection(child: child, context: context),
                  ),
                  const SizedBox(height: 24),

                  /// إضافة BounceIn لحركة البطاقات
                  BounceIn(
                    duration: 1200.ms,
                    child: ChildActionCards(
                      child: child,
                      adminId: adminId,
                      parentCode: parentCode,
                      context: context,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      /// إضافة Flash لزر الطوارئ ليظهر بشكل واضح
      floatingActionButton: Flash(
        duration: 1500.ms,
        child: FloatingActionButton(
          onPressed: () {
            showEmergencyContactDialog(context, child.doctorPhone);
          },
          backgroundColor: Colors.red,
          child: const Icon(Icons.emergency, color: Colors.white),
        ),
      ),
    );
  }
}

class BuildIconButton extends StatelessWidget {
  const BuildIconButton({
    super.key,
    required this.context,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final BuildContext context;
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SlideInUp(
      duration: 500.ms,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
        tooltip: tooltip,
        style: IconButton.styleFrom(
          padding: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
