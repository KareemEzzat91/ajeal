import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/ChildDetailsScreen/DailyNotesScreen/DailyNotesScreen.dart';
import 'package:ajeal/Admin/models/ChildModel/ChildModel.dart';
import 'package:ajeal/Parents/ParentHomeScreen/Parentchat/Allparentschats/GlobalchatScreen.dart';
import 'package:ajeal/Parents/ParentHomeScreen/Parentchat/ParentAdminchat/ParentAdminchatscreen.dart';
import 'package:ajeal/Parents/ParentHomeScreen/parentchildgoalspage/parentchildgoals_screen.dart';
import 'package:ajeal/Parents/ParentHomeScreen/parentsessionschedulepage/parentssessionschedule_screen.dart';
import 'package:ajeal/Screens/AdminOrparents/AdminOrParintsScreen.dart';
import 'package:ajeal/generated/l10n.dart';
import 'package:ajeal/helpers/theme/DarkTheme/ThemeCubit/themes_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:url_launcher/url_launcher.dart';

class ParentHomePage extends StatelessWidget {
  final String parentCode;
  final Child child;
  final String AdminId;

  const ParentHomePage(
      {super.key,
      required this.parentCode,
      required this.child,
      required this.AdminId});

  Future<void> _launchUrl(String url) async {
    try {
      final Uri url0 = Uri.parse(url); // Convert the string URL to a Uri
      if (!await launchUrl(url0)) {
        throw Exception('Could not launch $url0');
      }
    } catch (e) {
      throw Exception('Could not launch $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final locale = context.watch<ThemesCubit>().state.loc.languageCode;
    final themeCubit = context.read<ThemesCubit>();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, isDarkMode, locale, themeCubit),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileHeader(isDarkMode),
                  const SizedBox(height: 24),
                  _buildQuickStats(context),
                  const SizedBox(height: 24),
                  _buildProgressSection(context),
                  const SizedBox(height: 24),
                  _buildActionCards(context),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add emergency contact functionality
          _showEmergencyContactDialog(context);
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.emergency, color: Colors.white),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, bool isDarkMode, String locale,
      ThemesCubit themeCubit) {
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
                      : Colors.white ,
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
                  icon: isDarkMode ? Icons.light_mode : Icons.dark_mode,
                  tooltip: S.of(context).changeTheme,
                  onPressed: () {
                    themeCubit.toggleTheme(!isDarkMode);
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProfileHeader(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor:
                isDarkMode ? Colors.teal.shade600 : Colors.teal.shade100,
            child: Text(
              child.name[0].toUpperCase(),
              style: const TextStyle(
                fontSize: 30,
                color: Colors.teal,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  child.name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Age: ${child.age}",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatCard(
          S.of(context).sessions,
          "${child.scheduleSesoins.length}",
          Icons.calendar_today,
          Colors.blue,
        ),
        _buildStatCard(
          S.of(context).goals,
          "${child.selectedGoals.length}",
          Icons.track_changes,
          Colors.green,
        ),
        _buildStatCard(
          S.of(context).progress,
          "75%",
          Icons.trending_up,
          Colors.orange,
        ),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection(context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal.shade400, Colors.teal.shade600],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).progress_overview,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const LinearProgressIndicator(
            value: 0.75,
            backgroundColor: Colors.white ,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildProgressDetail(
                  S.of(context).completed, "${child.selectedGoals.length}"),
              _buildProgressDetail(
                  S.of(context).in_progress, "${child.selectedGoals.length}"),
              _buildProgressDetail(S.of(context).upcoming, "3"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressDetail(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white ,
          ),
        ),
      ],
    );
  }

  Widget _buildActionCards(BuildContext context) {
    return Column(
      children: [
        _buildActionCard(
          context,
          S.of(context).view_child_goals,
          S.of(context).track_progress,
          Icons.flag,
          Colors.orange,
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChildGoalsPage(goals: child.selectedGoals),
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildActionCard(
          context,
          S.of(context).schedule_sessions,
          S.of(context).manage_sessions,
          Icons.calendar_today,
          Colors.purple,
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SessionSchedulePage(
                name :child.name,
                isParent: true,
                childId: child.parentPhone,
                scheduleSesoins: child.scheduleSesoins,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildActionCard(
          context,
          S.of(context).chat_teacher,
          S.of(context).direct_communication,
          Icons.chat,
          Colors.blue,
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                role: "parent",
                isParent: true,
                chatId: AdminId + child.parentPhone,
                doctorId: AdminId,
                parentId: child.parentPhone,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildActionCard(
          context,
          S.of(context).global_chat,
          S.of(context).connect_community,
          Icons.people,
          Colors.green,
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GlobalChatScreen(
                childName: child.name,
                isparent: true,
                doctorId: AdminId,
                parentId: child.parentPhone,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildActionCard(
          context,
          S.of(context).daily_notes,
          S.of(context).write_daily_notes,
          Icons.note_add_sharp,
          Colors.brown,
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DailyNotesScreen(
                childID: parentCode,
                userType: "Parent",
              ),
            ),
          ),
        ),
      ],
    );
  }

//          IconButton(onPressed: (){
//             Navigator.push(context, MaterialPageRoute(builder: (context)=>DailyNotesScreen(userType: 'Doctor',childID: '${child.parentOccupation}${child.id+1}',)));
//           }, icon: const Icon(Icons.add_task_outlined,color: Colors.black,))
  Widget _buildActionCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color ,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showEmergencyContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context).emergency_contact),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.phone, color: Colors.red),
              title: Text(S.of(context).call_emergency),
              onTap: () {
                _launchUrl(
                    "https://wa.me/<+20 100 409 2979>?text=السلام عليكم");
              },
            ),
            ListTile(
              leading: const Icon(Icons.message, color: Colors.orange),
              title: Text(S.of(context).message_teacher),
              onTap: () {
                _launchUrl(
                    "https://wa.me/<+2${child.doctorPhone}>?text=السلام عليكم");
              },
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.logout),
              label: Text(S.of(context).logout),
              onPressed: () {
                logout(context);
              },
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    final pref = await SharedPreferences.getInstance();
    await pref.setBool("ParentLogin", false);
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const AdminOrParentsScreen()),
        (route) => false,
      );
    }
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
        padding: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
