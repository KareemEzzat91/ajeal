import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/AdminAddChild/Addchildcubit/add_child_cubit.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/AdminAddChild/AdminAddChildScreen.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/ChildDetailsScreen/ChildDetailScreen.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/ChildModel/ChildModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Adminchildrenscreen extends StatelessWidget {
  const Adminchildrenscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AddChildCubit>();
    return Scaffold(
      appBar: AppBar(
        title:  const Text('قائمة الأطفال'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              bloc.saveToFirestore();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Saved Succesfuilly ")));
              // بحث عن طفل
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // فتح الفلترة
            },
          ),
        ],
      ),
      body: FutureBuilder <List<Map<String, Child>>>(
          future: bloc.getAllDataFromFirestore(), // Call the method to get the Future
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: bloc.Children.length, // عدد الأطفال
            itemBuilder: (context, index) {
              final map = bloc.Children[index];//<String><Child>
              final id = map.keys.first;//<String>
              final child = map[id];
              return ChildCard(
                child: child!,
                index: index,
              );
            },
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
Navigator.push(context, MaterialPageRoute(builder: (c)=>const AdminAddChildScreen()));        },
        tooltip: 'إضافة طفل جديد',
        child: const Icon(Icons.add),
      ),

    );
  }
}

class ChildCard extends StatelessWidget {
      final Child child ;
      final int  index;

  const ChildCard({super.key, required this.child, required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        leading: const CircleAvatar(
          radius: 25,
          child: Icon(Icons.child_care),
        ),
        title: Text(child.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${child.dateOfBirth.day}/${child.dateOfBirth.month}/${child.dateOfBirth.year}",),
            const SizedBox(height: 5),
            LinearProgressIndicator(
              value: index*5 / 100,
              backgroundColor: Colors.grey[200],
              color: Colors.blue,
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChildDetailScreen(
                child :child,
                childName: child.name,
                birthDate: "${child.dateOfBirth.day}/${child.dateOfBirth.month}/${child.dateOfBirth.year}",
                goals: child.selectedGoals,
                progress: "مستوى التقدم الحالي",
              ),
            ),
          );
        },

      ),
    );
  }
}
