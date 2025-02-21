import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/ChildDetailsScreen/DailyNotesScreen/DailyNotesScreen.dart';
import 'package:ajeal/Parents/ParentHomeScreen/Parentchat/Allparentschats/GlobalchatScreen.dart';
import 'package:ajeal/Parents/ParentHomeScreen/Parentchat/ParentAdminchat/ParentAdminchatscreen.dart';
import 'package:ajeal/Parents/ParentHomeScreen/parentchildgoalspage/parentchildgoals_screen.dart';
import 'package:ajeal/Parents/ParentHomeScreen/parentsessionschedulepage/parentssessionschedule_screen.dart';
import 'package:ajeal/Screens/AdminOrparents/AdminOrParintsScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/ChildModel/ChildModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ParentHomePage extends StatelessWidget {
  final String parentCode;
  final Child child;
  final String AdminId;

  const ParentHomePage(
      {required this.parentCode, required this.child, required this.AdminId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileHeader(),
                  SizedBox(height: 24),
                  _buildQuickStats(),
                  SizedBox(height: 24),
                  _buildProgressSection(),
                  SizedBox(height: 24),
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

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          "Welcome Back!",
          style: TextStyle(
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
                Colors.teal.shade700,
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
                  backgroundColor: Colors.white.withOpacity(0.1),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.notifications),
          onPressed: () {
            // Add notifications functionality
          },
        ),
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            // Add settings functionality
          },
        ),
      ],
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.teal.shade100,
            child: Text(
              child.name[0].toUpperCase(),
              style: TextStyle(
                fontSize: 30,
                color: Colors.teal,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  child.name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Age: ${child.age}",
                  style: TextStyle(
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

  Widget _buildQuickStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatCard(
          "Sessions",
          "${child.scheduleSesoins.length}",
          Icons.calendar_today,
          Colors.blue,
        ),
        _buildStatCard(
          "Goals",
          "${child.selectedGoals.length}",
          Icons.track_changes,
          Colors.green,
        ),
        _buildStatCard(
          "Progress",
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
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color),
          SizedBox(height: 8),
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
              color: color.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal.shade400, Colors.teal.shade600],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Progress Overview",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16),
          LinearProgressIndicator(
            value: 0.75,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildProgressDetail(
                  "Completed", "${child.selectedGoals.length}"),
              _buildProgressDetail(
                  "In Progress", "${child.selectedGoals.length}"),
              _buildProgressDetail("Upcoming", "3"),
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
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.8),
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
          "View Child's Goals",
          "Track progress and achievements",
          Icons.flag,
          Colors.orange,
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChildGoalsPage(goals: child.selectedGoals),
            ),
          ),
        ),
        SizedBox(height: 16),
        _buildActionCard(
          context,
          "Schedule Sessions",
          "Manage upcoming sessions",
          Icons.calendar_today,
          Colors.purple,
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SessionSchedulePage(
                childId: "${child.parentOccupation}${child.id + 1}",
                scheduleSesoins: child.scheduleSesoins,
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
        _buildActionCard(
          context,
          "Chat with Teacher",
          "Direct communication channel",
          Icons.chat,
          Colors.blue,
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                isparent: true,
                chatId: AdminId + child.parentOccupation,
                doctorId: AdminId,
                parentId: child.parentOccupation + 1.toString(),
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
        _buildActionCard(
          context,
          "Global Chat",
          "Connect with the community",
          Icons.people,
          Colors.green,
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GlobalChatScreen(
                childName: child.name,
                isparent: true,
                doctorId: AdminId,
                parentId: child.parentOccupation + 1.toString(),
              ),
            ),
          ),
        ), SizedBox(height: 16),
        _buildActionCard(
          context,
          "Daily Notes",
          "Write Your Daily Notes",
          Icons.note_add_sharp,
          Colors.brown,
              () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DailyNotesScreen(
              childID:parentCode ,
              userType:"Parent" ,
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
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color),
              ),
              SizedBox(width: 16),
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
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16),
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
        title: Text("Emergency Contact"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.phone, color: Colors.red),
              title: Text("Call Emergency Number"),
              onTap: () {
                // Add emergency call functionality
              },
            ),
            ListTile(
              leading: Icon(Icons.message, color: Colors.orange),
              title: Text("Message Teacher"),
              onTap: () {
                // Add quick message functionality
              },
            ),
            ElevatedButton.icon(
                    icon: const Icon(Icons.logout),
                    label: const Text("تسجيل الخروج"),
                    onPressed: (){
                    logout(context);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                  )


          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }
  void logout(context) async{
    await  FirebaseAuth.instance.signOut();
    final pref = await SharedPreferences.getInstance();
    pref.setBool("ParentLogin", false);
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const AdminOrParentsScreen()),(Route<dynamic> route) => false );
  }

}
// Previous ParentHomePage code remains the same...


