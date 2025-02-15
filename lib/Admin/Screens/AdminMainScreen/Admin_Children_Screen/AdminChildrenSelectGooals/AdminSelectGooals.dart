import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/AdminAddChild/Addchildcubit/add_child_cubit.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/AdminChildrenSelectGooals/GoalDetailScreen.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/Goals.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/goal_lists/goal_lists.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminSelectGoals extends StatelessWidget {
   final String Phone ;
   AdminSelectGoals({super.key, required this.Phone});


   @override
  Widget build(BuildContext context) {
    final bloc = context.read<AddChildCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("اختيار الأهداف"),
        actions: [
          BlocBuilder<AddChildCubit, AddChildState>(

              builder: (BuildContext context, state) {
                return Text(
                    "${(bloc.selectedGoals[Phone]?.length ?? 0) > 9 ? "You have reached the max" : (bloc.selectedGoals[Phone]?.length ?? 0)} / 10"
                );
         },)
        ],
      ),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) {
            return;
          }


          const bool shouldPop =  true;
          if (context.mounted && shouldPop &&bloc.selectedGoals[Phone]!=null) {
             Navigator.pop(context,bloc.selectedGoals[Phone]);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: Goals_Lists.goalList.length,
            itemBuilder: (context, index) {

              return GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (c)=>GoalDetailScreen(goal:  Goals_Lists.goalList[index],)));
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
                                Goals_Lists.goalList[index].goalName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                               Text(
                                 Goals_Lists.goalList[index].goalDescription,
                                style: const TextStyle(fontSize: 14, color: Colors.grey),
                
                
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                
                                  bloc.AddGoal(  Goals_Lists.goalList[index],Phone,context);
                                  // اكتب هنا وظيفة التحديد
                                },
                                child: const Text("اختر الهدف"),
                              ),
                              IconButton(
                                icon: const Icon(Icons.info_outline),
                                onPressed: () {
                                },
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
      ),
    );
  }
}
