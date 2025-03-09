import 'package:ajeal/Admin/Screens/AdminLoginScreen/cubit/sign_cubit.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/AdminAddChild/Addchildcubit/add_child_cubit.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/AdminChildrenScreen.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Profile_Screen/AdminProfileScreen.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Reports_Screen/Admin_Reports_Screen.dart';
import 'package:ajeal/Parents/ParentHomeScreen/Parentchat/Allparentschats/GlobalchatScreen.dart';
import 'package:ajeal/generated/l10n.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminmainScreen extends StatefulWidget {
  final String doctorId;
  final String doctorName;
  const AdminmainScreen(
      {super.key, required this.doctorId, required this.doctorName});

  @override
  State<AdminmainScreen> createState() => _AdminmainScreenState();
}

class _AdminmainScreenState extends State<AdminmainScreen> {
  int _selectedIndex = 0;
  String doctorId = '';
  String doctorName = '';
  late List<Widget> Screens;
  @override
  void initState() {
    super.initState();
    Screens = [
      AdminChildrenScreen(
        doctorId: doctorId,
        doctorName: doctorName,
      ),
      const AdminReportsScreen(),
      GlobalChatScreen(
          childName: '',
          doctorId: FirebaseAuth.instance.currentUser!.uid,
          parentId: '',
          isparent: false),
      const AdminProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
  create: (context) => SignCubit(),
  child: BlocProvider(
  create: (context) => AddChildCubit(),
  child: Scaffold(
      body: Screens[_selectedIndex],
      bottomNavigationBar: FlashyTabBar(animationDuration: Duration(milliseconds:540 ),
        selectedIndex: _selectedIndex,
        showElevation: true,
        onItemSelected: (index) => setState(() {
          _selectedIndex = index;
        }),
        items: [
          FlashyTabBarItem(
            activeColor: Colors.blue,
            icon: const Icon(Icons.child_care_rounded),
            title: Text(S.of(context).childrenPage,style: const TextStyle(fontSize: 12),),
          ),
          FlashyTabBarItem(
            activeColor: Colors.blue,
            icon: const Icon(Icons.analytics_outlined),
            title: Text(S.of(context).reportsPage,style: const TextStyle(fontSize: 12),),
          ),
          FlashyTabBarItem(
            activeColor: Colors.blue,
            icon: const Icon(Icons.comment_rounded),
            title: Text(S.of(context).global_chat,style: const TextStyle(fontSize: 12),),
          ),
          FlashyTabBarItem(
            activeColor: Colors.blue,
            icon: const Icon(Icons.person),
            title: Text(S.of(context).profilePage,style: const TextStyle(fontSize: 12),),
          ),
        ],
      ),
    ),
),
);
  }
}
