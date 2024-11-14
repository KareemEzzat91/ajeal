import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/AdminChildrenScreen.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Communicate_Screen/AdminCommunicateScreen.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Objectives_Screen/AdminObjectevesScreen.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Profile_Screen/AdminProfileScreen.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Reports_Screen/Admin_Reports_Screen.dart';
import 'package:ajeal/generated/l10n.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class AdminmainScreen extends StatefulWidget {
  const AdminmainScreen({super.key});

  @override
  State<AdminmainScreen> createState() => _AdminmainScreenState();
}

class _AdminmainScreenState extends State<AdminmainScreen> {
   int _selectedIndex =0;
   List Screens =[
     Adminchildrenscreen(),
     AdminReportsScreen (),
     Adminobjectevesscreen(),

     Admincommunicatescreen(),
     Adminprofilescreen(),



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
            icon: Icon(Icons.child_care_rounded),
            title: Text(S.of(context).ChildrenPage),
          ),
          FlashyTabBarItem(
            icon: Icon(Icons.analytics_outlined),
            title: Text(S.of(context).ReportsPage),
          ),
          FlashyTabBarItem(
            icon: Icon(Icons.emoji_objects_outlined),
            title: Text(S.of(context).ObjectivesPage),
          ),
          FlashyTabBarItem(
            icon: Icon(Icons.comment_rounded),
            title: Text(S.of(context).CommunicationPage),
          ),
          FlashyTabBarItem(
            icon: Icon(Icons.person),
            title: Text(S.of(context).ProfilePage),
          ),
        ],
      ),
    );
  }
}
