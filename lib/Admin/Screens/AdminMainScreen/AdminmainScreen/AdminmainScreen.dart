import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/AdminChildrenScreen.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Communicate_Screen/AdminCommunicateScreen.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Objectives_Screen/AdminObjectevesScreen.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Profile_Screen/AdminProfileScreen.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Reports_Screen/Admin_Reports_Screen.dart';
import 'package:ajeal/Parents/ParentHomeScreen/Parentchat/Allparentschats/GlobalchatScreen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
class AdminmainScreen extends StatefulWidget {
  const AdminmainScreen({super.key});

  @override
  State<AdminmainScreen> createState() => _AdminmainScreenState();
}

class _AdminmainScreenState extends State<AdminmainScreen> {
   int _selectedIndex =0;
   List Screens =[
     const Adminchildrenscreen(),
     const AdminReportsScreen (),
     const Adminobjectevesscreen(),
      GlobalChatScreen(childName: '', doctorId: FirebaseAuth.instance.currentUser!.uid, parentId: '', isparent: false),
     const Adminprofilescreen(),



   ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Screens[_selectedIndex],
      bottomNavigationBar:  FlashyTabBar(
        selectedIndex: _selectedIndex,
        showElevation: true,
        onItemSelected: (index) => setState(() {
          _selectedIndex = index;
        }),
        items: [
          FlashyTabBarItem(
            icon: const Icon(Icons.child_care_rounded),
            title: Text("ChildrenPage".tr()),
          ),
          FlashyTabBarItem(
            icon: const Icon(Icons.analytics_outlined),
            title: Text("ReportsPage".tr()),
          ),
          FlashyTabBarItem(
            icon: const Icon(Icons.emoji_objects_outlined),
            title: Text("ObjectivesPage".tr()),
          ),
          FlashyTabBarItem(
            icon: const Icon(Icons.comment_rounded),
            title: Text("CommunicationPage".tr()),
          ),
          FlashyTabBarItem(
            icon: const Icon(Icons.person),
            title: Text("ProfilePage".tr()),
          ),
        ],
      ),
    );
  }
}
