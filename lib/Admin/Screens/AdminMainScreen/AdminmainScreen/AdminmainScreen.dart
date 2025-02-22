import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/AdminChildrenScreen.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Profile_Screen/AdminProfileScreen.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Reports_Screen/Admin_Reports_Screen.dart';
import 'package:ajeal/Parents/ParentHomeScreen/Parentchat/Allparentschats/GlobalchatScreen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
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
            title: Text("Children".tr(),style: const TextStyle(fontSize: 12),),
          ),
          FlashyTabBarItem(
            activeColor: Colors.blue,
            icon: const Icon(Icons.analytics_outlined),
            title: Text("Reports".tr(),style: const TextStyle(fontSize: 12),),
          ),
          FlashyTabBarItem(
            activeColor: Colors.blue,
            icon: const Icon(Icons.comment_rounded),
            title: Text("Global Chat".tr(),style: const TextStyle(fontSize: 12),),
          ),
          FlashyTabBarItem(
            activeColor: Colors.blue,
            icon: const Icon(Icons.person),
            title: Text("Profile".tr(),style: const TextStyle(fontSize: 12),),
          ),
        ],
      ),
    );
  }
}
