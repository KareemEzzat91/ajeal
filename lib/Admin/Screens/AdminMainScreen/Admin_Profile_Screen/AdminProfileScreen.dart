import 'package:ajeal/Admin/Screens/AdminLoginScreen/cubit/sign_cubit.dart';
import 'package:ajeal/generated/l10n.dart';
import 'package:ajeal/helpers/theme/DarkTheme/ThemeCubit/themes_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminProfileScreen extends StatelessWidget {
  final String doctorId;
  final String doctorName;
  final String doctorPhone;
  const AdminProfileScreen({super.key, required this.doctorId, required this.doctorName, required this.doctorPhone});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final themeCubit = context.read<ThemesCubit>();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Custom App Bar with profile image
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
               centerTitle: true,
              title: Text(S.of(context).profilePage,

                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.blue.shade800,
                      Colors.blue.shade500,
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                            ),
                            child: CircleAvatar(
                              radius: 50,
                             child:  Text(doctorName[0],style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 40), ),
                            ),
                          ),
                         ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Profile Information
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildSection(
                    S.of(context).personalInfo,
                    [
                      _buildProfileCard(context,
                        icon: Icons.person,
                        title: S.of(context).name,
                        value: doctorName

                      ),
                      _buildProfileCard(
                        context,
                        icon: Icons.email,
                        title: S.of(context).email,
                        value: currentUser?.email ?? "admin@gmail.com",
                       ),
                      _buildProfileCard(
                        context,
                        icon: Icons.phone,
                        title: S.of(context).doctorCode,
                        value: doctorId,
                       ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    S.of(context).settings,
                    [
                      _buildActionButton(
                        icon: isDarkMode ? Icons.light_mode : Icons.dark_mode,
                        title: S.of(context).changeTheme,
                        onTap: () => themeCubit.toggleTheme(!isDarkMode),
                        color: isDarkMode ? Colors.brown : Colors.black12,
                      ),
                      const SizedBox(height: 12),
                      _buildActionButton(
                        icon: Icons.language,
                        title: S.of(context).changeLanguage,
                        onTap: () => themeCubit.changeLang(),
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 12),
                      BlocBuilder<SignCubit, SignState>(
                        bloc: SignCubit(),
                        builder: (context, state) {
                          return _buildActionButton(
                            icon: Icons.logout,
                            title: S.of(context).logout,
                            onTap: () =>
                                context.read<SignCubit>().logout(context),
                            color: Colors.red,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildProfileCard(context,{
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.blue),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(value, style: const TextStyle(color: Colors.blue)),
        trailing: IconButton(onPressed: (){
          Clipboard.setData(ClipboardData(text: value));
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("تم نسخ $title")));
         }, icon: const Icon(Icons.copy)),
       ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color,
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
