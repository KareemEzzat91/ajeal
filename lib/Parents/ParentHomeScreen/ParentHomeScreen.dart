import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/AdminChildrenSelectGooals/GoalDetailScreen.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/ChildDetailsScreen/SessionDetailScreen/SessionDetailScreen.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/Goals.dart';
import 'package:ajeal/Parents/ParentHomeScreen/Parentchat/Allparentschats/GlobalchatScreen.dart';
import 'package:ajeal/Parents/ParentHomeScreen/Parentchat/ParentAdminchat/ParentAdminchatscreen.dart';
import 'package:flutter/material.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/ChildModel/ChildModel.dart';

class ParentHomePage extends StatelessWidget {
  final String parentCode;
  final Child child;
  final String AdminId;

  const ParentHomePage({required this.parentCode, required this.child, required this.AdminId});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome, Parent"),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              Text(
                "Hello, ${child.name}!",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Age: ${child.age}",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              SizedBox(height: 20),
        
              // Child's Progress Section
              _buildProgressSection(),
        
              // Goals Button
              SizedBox(height: 20),
              _buildNavigationButton(
                context,
                label: "View Child's Goals & Progress",
                onPressed: () {
                  // Navigate to Goals Page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChildGoalsPage( goals:child.selectedGoals ,),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              _buildNavigationButton(
                context,
                label: "Schedule Child's Sessions",
                onPressed: () {
                  // Navigate to Session Schedule Page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SessionSchedulePage(childId:child.parentOccupation+"${child.id+1}" ,scheduleSesoins: child.scheduleSesoins,),
                    ),
                  );
                },
              ),
        
              // Chat Button
              SizedBox(height: 20),
              _buildNavigationButton(
                context,
                label: "Chat with Teacher",
                onPressed: () {
                  // Navigate to Chat Page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(isparent: true,chatId:AdminId+child.parentOccupation,doctorId:AdminId ,parentId:child.parentOccupation+1.toString() ,),
                    ),
                  );
                },
              ),
        
              // Session Schedule Button
              SizedBox(height: 20),
              _buildNavigationButton(
                context,
                label: "Global Chat",
                onPressed: () {
                  // Navigate to Chat Page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GlobalChatScreen(childName:child.name,isparent: true,doctorId:AdminId ,parentId:child.parentOccupation+1.toString() ,),
                    ),
                  );
                },
              ),
        
            ],
          ),
        ),
      ),
    );
  }

  // Child's Progress Section
  Widget _buildProgressSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Progress Overview",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  "Total Goals Achieved: ${child.selectedGoals.length}",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  "Total Pending Goals: ${child.selectedGoals.length}",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            Icon(Icons.track_changes, color: Colors.teal, size: 40),
          ],
        ),
      ),
    );
  }

  // Navigation Button
  Widget _buildNavigationButton(BuildContext context, {required String label, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(label, style: TextStyle(fontSize: 16, color: Colors.white)),
    );
  }
}

class ChildGoalsPage extends StatelessWidget {
  final List<Goal> goals;

  const ChildGoalsPage({ required this.goals});

  @override
  Widget build(BuildContext context) {
    print("goals.length:+${goals}");
    return Scaffold(
      appBar: AppBar(title: Text("Child's Goals & Progress")),
      body:  Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: goals.length,
          itemBuilder: (context, index) {
            final goal =goals[index];
            goal.goalDescription;
            return GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (c)=>GoalDetailScreen(goal: goals[index],)));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        child: Image.network(
                          "https://www.ces-schools.net/wp-content/uploads/2020/07/AdobeStock_234287116-1024x683.jpeg",
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 200,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              goals[index].goalName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              goals[index].goalDescription,
                              style: const TextStyle(fontSize: 14, color: Colors.grey),

                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}


class SessionSchedulePage extends StatelessWidget {
  final String childId;
  final List<Map<String, dynamic>> scheduleSesoins;
  const SessionSchedulePage({super.key, required this.scheduleSesoins, required this.childId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Schedule Child's Sessions")),
      body:               ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: scheduleSesoins.length,
        itemBuilder: (context, index) {
          final session = scheduleSesoins[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SessionDetailScreen(
                    childId: childId,
                    sessionName: session['session'],
                    date: session['date'],
                    goals: List<String>.from(session['goals']),
                      notes: session['notes']??'',
                      rate: session['rate']??0.toDouble(),
                      tasks : List.from(session['tasks']??[])
                  ),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blueAccent),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'جلسة: ${session['session']}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'التاريخ: ${session['date']}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'الأهداف: ${session['goals'].join(', ')}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
