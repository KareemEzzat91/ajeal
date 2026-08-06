import 'package:ajeal/admin/screens/admin_login_screen/cubit/sign_cubit.dart';
import 'package:ajeal/admin/screens/admin_main_screen/admin_children_screen/admin_add_child/add_child_cubit/add_child_cubit.dart';
import 'package:ajeal/admin/screens/admin_main_screen/admin_children_screen/admin_children_screen.dart';
import 'package:ajeal/admin/screens/admin_main_screen/admin_profile_screen/admin_profile_screen.dart';
import 'package:ajeal/admin/screens/admin_main_screen/admin_reports_screen/admin_reports_screen.dart';
import 'package:ajeal/parents/parent_home_screen/parent_chat/all_parents_chats/global_chat_screen.dart';
import 'package:ajeal/helpers/generated/l10n.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminMainScreen extends StatefulWidget {
  final String doctorId;
  final String doctorName;
  final String doctorPhone;
  const AdminMainScreen(
      {super.key, required this.doctorId, required this.doctorName, required this.doctorPhone});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  int _selectedIndex = 0;
  String doctorId = '';
  String doctorName = '';
  String doctorPhone = '';
  late List<Widget> screens;

  @override
  void initState() {
    doctorId=widget.doctorId;
    doctorPhone=widget.doctorPhone;
    doctorName=widget.doctorName;
    super.initState();
    screens = [
      AdminChildrenScreen(
        doctorId: doctorId,
        doctorName: doctorName,
      ),
      const AdminReportsScreen(),
      GlobalChatScreen(
          childName: '',
          doctorId: FirebaseAuth.instance.currentUser!.uid,
          parentId: '',
          isParent: false),
      AdminProfileScreen(doctorPhone:doctorPhone ,doctorName: doctorName,doctorId: doctorId,),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignCubit(),
      child: BlocProvider(
        create: (context) => AddChildCubit(),
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          body: AnimatedSwitcher(duration:const  Duration(milliseconds: 540),
          child: screens[_selectedIndex]),
          bottomNavigationBar: FlashyTabBar(
            backgroundColor: Theme.of(context).primaryColor,
            animationDuration: const Duration(milliseconds: 540),
            selectedIndex: _selectedIndex,
            showElevation: true,
            onItemSelected: (index) => setState(() {
              _selectedIndex = index;
            }),
            items: [
              FlashyTabBarItem(
                activeColor: Colors.blue,
                icon: const Icon(Icons.child_care_rounded),
                title: Text(
                  S.of(context).childrenPage,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              FlashyTabBarItem(
                activeColor: Colors.blue,
                icon: const Icon(Icons.analytics_outlined),
                title: Text(
                  S.of(context).reportsPage,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              FlashyTabBarItem(
                activeColor: Colors.blue,
                icon: const Icon(Icons.comment_rounded),
                title: Text(
                  S.of(context).global_chat,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              FlashyTabBarItem(
                activeColor: Colors.blue,
                icon: const Icon(Icons.person),
                title: Text(
                  S.of(context).profilePage,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
