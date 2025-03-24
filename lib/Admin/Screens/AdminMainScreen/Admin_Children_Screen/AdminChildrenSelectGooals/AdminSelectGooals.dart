import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/AdminAddChild/Addchildcubit/add_child_cubit.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/AdminChildrenSelectGooals/GoalDetailScreen.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/goal_lists/goal_lists.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AdminSelectGoals extends StatelessWidget {
  final String phone;

  const AdminSelectGoals({super.key, required this.phone});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddChildCubit(),
      child: Builder(builder: (context) {
        // Access the cubit after it's been created
        final addChildCubit = context.read<AddChildCubit>();

        return Scaffold(
          appBar: AppBar(
            title: const Text("اختيار الأهداف"),
            centerTitle: true,
            actions: [
              BlocBuilder<AddChildCubit, AddChildState>(
                builder: (context, state) {
                  final selectedGoalsCount =
                      addChildCubit.selectedGoals[phone]?.length ?? 0;
                  final isMaxReached = selectedGoalsCount >= 7;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Center(
                      child: Text(
                        "$selectedGoalsCount / 7",
                        style: TextStyle(
                          color: isMaxReached ? Colors.red : Colors.black,
                          fontWeight: isMaxReached
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
          body: PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) async {
              if (didPop) return;

              if (context.mounted &&
                  addChildCubit.selectedGoals[phone] != null) {
                Navigator.pop(context, addChildCubit.selectedGoals[phone]);
              } else {
                Navigator.pop(context, []);
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListView.builder(
                itemCount: Goals_Lists.goalList.length,
                itemBuilder: (context, index) {
                  final goal = Goals_Lists.goalList[index];
                  return _buildGoalCard(context, goal, addChildCubit);
                },
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildGoalCard(
      BuildContext context, dynamic goal, AddChildCubit cubit) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with loading placeholder
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: CachedNetworkImage(
                imageUrl:
                    "https://th.bing.com/th/id/OIP.j-y_XOKtbpnI_dDwjSG8QAAAAA?rs=1&pid=ImgDetMain",
                fit: BoxFit.cover,
                width: double.infinity,
                height: 180,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const Center(
                  child: Icon(Icons.error),
                ),
              ),
            ),

            // Goal details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    goal.goalName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    goal.goalDescription,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Actions
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BlocBuilder<AddChildCubit, AddChildState>(
                    builder: (context, state) {
                      final selectedGoals = cubit.selectedGoals[phone] ?? [];
                      final isSelected = selectedGoals.contains(goal);
                      final isMaxReached = selectedGoals.length >= 7;

                      return ElevatedButton.icon(
                        onPressed: isSelected || (!isSelected && isMaxReached)
                            ? null
                            : () => cubit.addGoal(goal, phone, context),
                        icon: Icon(isSelected
                            ? Icons.check_circle
                            : Icons.add_circle_outline),
                        label: Text(isSelected ? "تم الاختيار" : "اختر الهدف"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSelected ? Colors.green : null,
                          foregroundColor: isSelected ? Colors.white : null,
                        ),
                      );
                    },
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GoalDetailScreen(goal: goal),
                        ),
                      );
                    },
                    icon: const Icon(Icons.info_outline),
                    label: const Text("التفاصيل"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
