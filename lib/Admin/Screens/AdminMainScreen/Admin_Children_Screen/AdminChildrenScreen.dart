import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/AdminAddChild/Addchildcubit/add_child_cubit.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/AdminAddChild/AdminAddChildScreen.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/ChildDetailsScreen/ChildDetailScreen.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/admin_children_screen_states.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/child_cards.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/colors.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/dialogs.dart';
import 'package:ajeal/Admin/models/ChildModel/ChildModel.dart';
import 'package:ajeal/helpers/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';



class AdminChildrenScreen extends StatefulWidget {
  final String doctorId;
  final String doctorName;

  const AdminChildrenScreen({
    super.key,
    required this.doctorId,
    required this.doctorName,
  });

  @override
  State<AdminChildrenScreen> createState() => _AdminChildrenScreenState();
}

class _AdminChildrenScreenState extends State<AdminChildrenScreen>
    with TickerProviderStateMixin {
  late AnimationController _fabAnimationController;
  late AnimationController _filterAnimationController;
  bool _isListView = true;
  String _currentFilter = 'all';

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _filterAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    _filterAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddChildCubit(),
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: buildAppBar(context, context.read<AddChildCubit>()),
        body: Column(
          children: [
            _buildFilterBar(),
            Expanded(child: _buildBody(context.read<AddChildCubit>())),
          ],
        ),
        floatingActionButton: _currentFilter=="Others"?AddChildButton(fabAnimationController: _fabAnimationController, widget: widget, context: context, isOthers: true): AddChildButton(fabAnimationController: _fabAnimationController, widget: widget, context: context, isOthers: false),
      ),
    );
  }

  PreferredSizeWidget buildAppBar(BuildContext context, AddChildCubit bloc) {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).primaryColor,
      title: Text(
        S.of(context).childrenList,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 24,
          color: AppColors.text,
          letterSpacing: -0.5,
        ),
      ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2, end: 0),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(
          _isListView ? Icons.grid_view : Icons.view_list,
          color: AppColors.primary,
        ),
        onPressed: () {
          setState(() => _isListView = !_isListView);
        },
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        border: const Border(
          bottom: BorderSide(
            color: AppColors.textSecondary,
          ),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip('all', 'All',_currentFilter),
            _buildFilterChip('Others', 'Others',_currentFilter),
            _buildFilterChip('completed', 'Completed',_currentFilter),
            _buildFilterChip('pending', 'Pending',_currentFilter),
          ],
        ),
      ),
    )
        .animate()
        .slideY(begin: -1, end: 0, duration: 500.ms, curve: Curves.easeOut);
  }

  Widget _buildFilterChip(String filter, String label,String currentFilter, ) {
    final isSelected = currentFilter == filter;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        label: Text(label),
        onSelected: (selected) {
          setState(() => _currentFilter = filter);
          _filterAnimationController.forward(from: 0);
        },
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.primary,
        labelStyle: TextStyle(
          color: isSelected ? AppColors.primary : AppColors.textSecondary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected
                ? AppColors.primary
                : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

 Future< List<Map<String, Child>>> getEmpty()async{
    return[];
  }


  Widget _buildBody(AddChildCubit bloc) {
    return FutureBuilder<List<Map<String, Child>>>(
      future: _currentFilter=="Others" ?bloc.getAllChildrenFromOtherDoctors():_currentFilter=="completed"?getEmpty():bloc.getAllDataFromFirestore(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ChildrenScreenLoadingState();
        } else if (snapshot.hasError) {
          return ChildrenScreenErrorState(error: snapshot.error.toString());
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return ChildrenScreenEmptyState(currentFilter: _currentFilter);
        }
        return _isListView
            ? _buildChildrenList(bloc)
            : _buildChildrenGrid(bloc);
      },
    );
  }

  Widget _buildChildrenGrid(AddChildCubit bloc) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.6,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _currentFilter=="Others" ?bloc.othersChildren.length:bloc.children.length,
      itemBuilder: (context, index) {
        final map =  _currentFilter=="Others" ?bloc.othersChildren[index]:bloc.children[index];
        final id = map.keys.first;
        final child = map[id]!;
        return ChildGridCard(
          child: child,
          onTap: () => _navigateToDetails(context, child),
        ).animate().fadeIn(delay: (index * 100).ms).slideY(begin: 0.2, end: 0);
      },
    );
  }

  Widget _buildChildrenList(AddChildCubit bloc) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _currentFilter=="Others" ?bloc.othersChildren.length:bloc.children.length,
      itemBuilder: (context, index) {
        final map =  _currentFilter=="Others" ?bloc.othersChildren[index]:bloc.children[index];
        final id = map.keys.first;
        final child = map[id]!;
        return ChildCard(

          isOthers: _currentFilter=="Others",
          child: child,
          onTap: () => _navigateToDetails(context, child),
        ).animate().fadeIn(delay: (index * 100).ms).slideX(begin: 0.2, end: 0);
      },
    );
  }



  void _navigateToDetails(BuildContext context, Child child) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChildDetailScreen(
          child: child,
          childName: child.name,
          isOthers: _currentFilter=="Others",
          birthDate:
              "${child.dateOfBirth.day}/${child.dateOfBirth.month}/${child.dateOfBirth.year}",
          goals: child.selectedGoals,
          progress: "50%",
        ),
      ),
    );
  }
}






class AddChildButton extends StatelessWidget {
  const AddChildButton({
    super.key,
    required AnimationController fabAnimationController,
    required this.widget,
    required this.context,
    required this.isOthers,
  }) : _fabAnimationController = fabAnimationController;

  final AnimationController _fabAnimationController;
  final AdminChildrenScreen widget;
  final BuildContext context;
  final bool isOthers;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        _fabAnimationController.forward(from: 0);
        isOthers?showCustomDialog(context):Navigator.push(
          context,
          MaterialPageRoute(
            builder: (c) => AdminAddChildScreen(
              doctorId: widget.doctorId,
              doctorName: widget.doctorName,
            ),
          ),
        );

      },
      backgroundColor: AppColors.primary,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      icon: const Icon(Icons.add, color: Colors.white),
      label:  Text(
        isOthers? "اضافة طفل من دكتور اخر ": 'إضافة طفل جديد',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    )
        .animate(controller: _fabAnimationController)
        .scale(
      duration: 100.ms,
      curve: Curves.easeOut,
    )
        .then()
        .shake(hz: 4, curve: Curves.easeOut);
  }
}
