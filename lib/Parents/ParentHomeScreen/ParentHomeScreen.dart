import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/AdminChildrenSelectGooals/GoalDetailScreen.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/Goals.dart';
import 'package:flutter/material.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/ChildModel/ChildModel.dart';

class ParentHomePage extends StatelessWidget {
  final String parentCode;
  final Child child;

  const ParentHomePage({required this.parentCode, required this.child});


  @override
  Widget build(BuildContext context) {
    print(child.scheduleSesoins.length);
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome, Parent"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
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

            // Chat Button
            SizedBox(height: 20),
            _buildNavigationButton(
              context,
              label: "Chat with Admin/Teacher",
              onPressed: () {
                // Navigate to Chat Page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(parentCode: parentCode),
                  ),
                );
              },
            ),

            // Session Schedule Button
            SizedBox(height: 20),
            _buildNavigationButton(
              context,
              label: "Schedule Child's Sessions",
              onPressed: () {
                // Navigate to Session Schedule Page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SessionSchedulePage(parentCode: parentCode),
                  ),
                );
              },
            ),
          ],
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
  final List<Goals> goals;

  const ChildGoalsPage({ required this.goals});

  @override
  Widget build(BuildContext context) {
    print("goals.length:+${goals.length}");
    return Scaffold(
      appBar: AppBar(title: Text("Child's Goals & Progress")),
      body:  Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: goals.length,
          itemBuilder: (context, index) {
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

class ChatScreen extends StatelessWidget {
  final String parentCode;

  const ChatScreen({required this.parentCode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat with Admin/Teacher")),
      body: Center(child: Text("Chat Functionality Here")),
    );
  }
}

class SessionSchedulePage extends StatelessWidget {
  final String parentCode;

  const SessionSchedulePage({required this.parentCode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Schedule Child's Sessions")),
      body: Center(child: Text("Session Schedule Functionality Here")),
    );
  }
}
