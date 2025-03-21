import 'package:ajeal/Parents/ParentHomeScreen/ParentHomeScreen.dart';
import 'package:ajeal/helpers/generated/l10n.dart';
import 'package:ajeal/helpers/theme/DarkTheme/ThemeCubit/themes_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChildAppBar extends StatelessWidget {
  const ChildAppBar({
    super.key,
    required this.context,
    required this.isDarkMode,
    required this.locale,
    required this.themeCubit,
  });

  final BuildContext context;
  final bool isDarkMode;
  final String locale;
  final ThemesCubit themeCubit;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          S.of(context).welcome_back,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.teal,
                isDarkMode ? Colors.black : Colors.teal.shade700
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -50,
                top: -50,
                child: CircleAvatar(
                  radius: 100,
                  backgroundColor: isDarkMode
                      ? Colors.black12
                      : Colors.teal.shade700 ,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Setting buttons
            Row(
              children: [
                BuildIconButton(context: context, icon: Icons.language, tooltip: S.of(context).changeLanguage, onPressed: () {
                  themeCubit.changeLang();
                }),
                const SizedBox(width: 8),
                BuildIconButton(context: context, icon: isDarkMode ? Icons.light_mode : Icons.dark_mode, tooltip: S.of(context).changeTheme, onPressed: () {
                  themeCubit.toggleTheme(!isDarkMode);
                }),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
