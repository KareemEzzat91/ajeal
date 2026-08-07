import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:ajeal/features/admin/children/presentation/cubit/add_child/add_child_cubit.dart';
import 'package:ajeal/features/admin/children/presentation/screens/admin_children_screen_states.dart';
import 'package:ajeal/features/admin/children/presentation/screens/child_cards.dart';
import 'package:ajeal/core/constants/app_colors.dart';
import 'package:ajeal/core/models/child_model/child_model.dart';
import 'package:ajeal/core/widgets/dialogs.dart';
import 'package:ajeal/features/admin/children/presentation/cubit/children_list/children_list_cubit.dart';
import 'package:ajeal/features/admin/children/presentation/cubit/children_list/children_list_state.dart';
import 'package:ajeal/helpers/generated/l10n.dart';

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
  bool _isListView = true;

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    // Load children on first open
    context.read<ChildrenListCubit>().loadChildren();
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddChildCubit>(
      create: (_) => AddChildCubit(),
      child: BlocBuilder<ChildrenListCubit, ChildrenListState>(
        builder: (context, state) {
          final currentFilter =
              state is ChildrenListLoaded ? state.filter : 'all';
          return Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            appBar: _buildAppBar(context, currentFilter),
            body: Column(
              children: [
                _buildFilterBar(context, currentFilter),
                Expanded(child: _buildBody(context, state)),
              ],
            ),
            floatingActionButton: AddChildButton(
              fabAnimationController: _fabAnimationController,
              widget: widget,
              context: context,
              isOthers: currentFilter == 'Others',
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, String currentFilter) {
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
        onPressed: () => setState(() => _isListView = !_isListView),
      ),
    );
  }

  Widget _buildFilterBar(BuildContext context, String currentFilter) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        border: const Border(
          bottom: BorderSide(color: AppColors.textSecondary),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip(context, 'all', 'All', currentFilter),
            _buildFilterChip(context, 'Others', 'Others', currentFilter),
            _buildFilterChip(context, 'completed', 'Completed', currentFilter),
            _buildFilterChip(context, 'pending', 'Pending', currentFilter),
          ],
        ),
      ),
    )
        .animate()
        .slideY(begin: -1, end: 0, duration: 500.ms, curve: Curves.easeOut);
  }

  Widget _buildFilterChip(
      BuildContext context, String filter, String label, String currentFilter) {
    final isSelected = currentFilter == filter;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        label: Text(label),
        onSelected: (_) {
          context.read<ChildrenListCubit>().setFilter(filter);
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
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ChildrenListState state) {
    if (state is ChildrenListLoading || state is ChildrenListInitial) {
      return const ChildrenScreenLoadingState();
    }
    if (state is ChildrenListError) {
      return ChildrenScreenErrorState(error: state.message);
    }
    if (state is ChildrenListLoaded) {
      final items = state.visibleChildren;
      if (items.isEmpty) {
        return ChildrenScreenEmptyState(currentFilter: state.filter);
      }
      return _isListView
          ? _buildChildrenList(context, items)
          : _buildChildrenGrid(context, items);
    }
    return const ChildrenScreenLoadingState();
  }

  Widget _buildChildrenGrid(
      BuildContext context, List<Map<String, Child>> items) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.6,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final map = items[index];
        final child = map.values.first;
        return ChildGridCard(
          child: child,
          onTap: () => _navigateToDetails(context, child),
        ).animate().fadeIn(delay: (index * 100).ms).slideY(begin: 0.2, end: 0);
      },
    );
  }

  Widget _buildChildrenList(
      BuildContext context, List<Map<String, Child>> items) {
    final currentFilter = context.read<ChildrenListCubit>().state
            is ChildrenListLoaded
        ? (context.read<ChildrenListCubit>().state as ChildrenListLoaded).filter
        : 'all';
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final map = items[index];
        final child = map.values.first;
        return ChildCard(
          isOthers: currentFilter == 'Others',
          child: child,
          onTap: () => _navigateToDetails(context, child),
        ).animate().fadeIn(delay: (index * 100).ms).slideX(begin: 0.2, end: 0);
      },
    );
  }

  void _navigateToDetails(BuildContext context, Child child) {
    context.push('/admin/children/details', extra: {
      'child': child,
      'isOthers':
          context.read<ChildrenListCubit>().state is ChildrenListLoaded &&
              (context.read<ChildrenListCubit>().state as ChildrenListLoaded)
                      .filter ==
                  'Others',
    }).then((v) {
      if (v == true) {
        context.read<ChildrenListCubit>().loadChildren();
      }
    });
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
        if (isOthers) {
          showCustomDialog(context);
        } else {
          context.push('/admin/children/add', extra: {
            'doctorId': widget.doctorId,
            'doctorName': widget.doctorName,
          }).then((v) {
            if (v == true) {
              context.read<ChildrenListCubit>().loadChildren();
            }
          });
        }
      },
      backgroundColor: AppColors.primary,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      icon: const Icon(Icons.add, color: Colors.white),
      label: Text(
        isOthers ? S.of(context).addNewChildOthers : S.of(context).addNewChild,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    )
        .animate(controller: _fabAnimationController)
        .scale(duration: 100.ms, curve: Curves.easeOut)
        .then()
        .shake(hz: 4, curve: Curves.easeOut);
  }
}
