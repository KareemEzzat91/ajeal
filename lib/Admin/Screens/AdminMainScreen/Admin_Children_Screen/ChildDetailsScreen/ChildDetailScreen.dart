import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/AdminAddChild/Addchildcubit/add_child_cubit.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/AdminChildrenSelectGooals/GoalDetailScreen.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/Goals.dart';
import 'package:flutter/material.dart';

class ChildDetailScreen extends StatelessWidget {
  final Child child;
  final String childName;
  final String birthDate;
  final List <Goals> goals; // يجب أن تكون من نوع String لتظهر النصوص بشكل صحيح
  final String progress;

  const ChildDetailScreen({
    super.key,
    required this.childName,
    required this.birthDate,
    required this.goals,
    required this.progress,  required this.child,
  });

  @override
  Widget build(BuildContext context) {
    print(child.scheduleSesoins);
    return Scaffold(
      appBar: AppBar(
        title: Text("تفاصيل $childName"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                    "https://avatarfiles.alphacoders.com/143/143832.jpg"), // رابط صورة الطفل
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "اسم الطفل: $childName",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "تاريخ الميلاد: $birthDate",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: child.scheduleSesoins.length, // Number of sessions
                itemBuilder: (context, index) {
                  final session = child.scheduleSesoins[index]; // Get the current session data
                  return Container(
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.blue[50], // Background color for each session
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Session: ${session['session']}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Date: ${session['date']}',
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Goals: ${session['goals'].join(', ')}', // Displaying the goals
                          style: TextStyle(color: Colors.black87),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "الأهداف:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // حاوية للـ ListView لضبط حجمها
            Expanded(
              child: ListView.builder(
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
                              offset: const Offset(0, 3),
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
                                height: 150,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
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
                                  const SizedBox(height: 8),
                                   Text(
                                    goals[index].goalDescription,
                                    style:
                                    const TextStyle(fontSize: 14, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.info_outline),
                                    onPressed: () {
                                      // كود عرض المزيد من التفاصيل حول الهدف
                                    },
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // كود التعديل
                                    },
                                    child: const Text(
                                      "تحديث التقدم",
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(

                              padding: const EdgeInsets.only(right: 7),
                              child: LinearProgressIndicator(
                                value: index*5 / 100,
                                backgroundColor: Colors.grey[200],
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),
            const Text(
              "التقدم الحالي:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              progress,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),

      ),
    );
  }
}
