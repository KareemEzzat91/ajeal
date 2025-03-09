import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/AdminAddChild/Addchildcubit/add_child_cubit.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/AdminAddChild/AdminAddChildScreen.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/ChildDetailsScreen/ChildDetailScreen.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/ChildModel/ChildModel.dart';
import 'package:ajeal/generated/l10n.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AppColors {
  static const primary = Color(0xff0186c7); // اللون الأساسي الجديد
  static const secondary = Color(0xff1e3a5c); // اللون الثانوي الجديد
  static const background = Color(0xFFF8FAFC); // لون الخلفية
  static const surface = Colors.white; // لون السطح
  static const text = Color(0xFF1E293B); // لون النص الأساسي
  static const textSecondary = Color(0xFF64748B); // لون النص الثانوي
  static const error = Color(0xFFEF4444); // لون الخطأ
  static const success = Color(0xFF22C55E); // لون النجاح
}

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
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context, context.read<AddChildCubit>()),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(child: _buildBody(context.read<AddChildCubit>())),
        ],
      ),
      floatingActionButton: _buildAnimatedFAB(context),
    ),
);
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, AddChildCubit bloc) {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.surface,
      title:  Text(
        S.of(context ).childrenList,
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
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(
            color: AppColors.textSecondary.withOpacity(0.1),
          ),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip('all', 'All'),
            _buildFilterChip('active', 'Active'),
            _buildFilterChip('completed', 'Completed'),
            _buildFilterChip('pending', 'Pending'),
          ],
        ),
      ),
    )
        .animate()
        .slideY(begin: -1, end: 0, duration: 500.ms, curve: Curves.easeOut);
  }

  Widget _buildFilterChip(String filter, String label) {
    final isSelected = _currentFilter == filter;
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
        selectedColor: AppColors.primary.withOpacity(0.1),
        labelStyle: TextStyle(
          color: isSelected ? AppColors.primary : AppColors.textSecondary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected
                ? AppColors.primary
                : AppColors.textSecondary.withOpacity(0.2),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(AddChildCubit bloc) {
    return FutureBuilder<List<Map<String, Child>>>(
      future: bloc.getAllDataFromFirestore(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        } else if (snapshot.hasError) {
          return _buildErrorState(snapshot.error.toString());
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildEmptyState();
        }
        return _isListView
            ? _buildChildrenList(bloc)
            : _buildChildrenGrid(bloc);
      },
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
          const SizedBox(height: 16),
          Text(
            "حدث خطأ",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            "لا يوجد أطفال مسجلين بعد",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "اضغط على زر الإضافة لتسجيل طفل جديد",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChildrenGrid(AddChildCubit bloc) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio:0.6,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,

      ),
      itemCount: bloc.Children.length,
      itemBuilder: (context, index) {
        final map = bloc.Children[index];
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
      itemCount: bloc.Children.length,
      itemBuilder: (context, index) {
        final map = bloc.Children[index];
        final id = map.keys.first;
        final child = map[id]!;
        return ChildCard(
          child: child,
          onTap: () => _navigateToDetails(context, child),
        ).animate().fadeIn(delay: (index * 100).ms).slideX(begin: 0.2, end: 0);
      },
    );
  }

  Widget _buildAnimatedFAB(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        _fabAnimationController.forward(from: 0);
        Navigator.push(
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
      label: const Text(
        'إضافة طفل',
        style: TextStyle(
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

  void _navigateToDetails(BuildContext context, Child child) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChildDetailScreen(
          child: child,
          childName: child.name,
          birthDate:
              "${child.dateOfBirth.day}/${child.dateOfBirth.month}/${child.dateOfBirth.year}",
          goals: child.selectedGoals,
          progress: "50%",
        ),
      ),
    );
  }
}

class ChildCard extends StatelessWidget {
  final Child child;
  final VoidCallback onTap;

  const ChildCard({
    super.key,
    required this.child,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildAvatar(),
                    const SizedBox(width: 16),
                    Expanded(child: _buildChildInfo()),
                    _buildMoreButton(context),
                  ],
                ),
                const SizedBox(height: 20),
                _buildProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Hero(
      tag: 'child_avatar_${child.id}${child.name}',
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.primary.withOpacity(0.1),
            width: 3,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: CachedNetworkImage(
            imageUrl: child.gender == "Male"
                ? "https://img.freepik.com/premium-photo/professional-portrait-studio-photograph-adorable-mixedrace-child-generative-ai_895561-2847.jpg"
                : "https://avatarfiles.alphacoders.com/143/143832.jpg",
            fit: BoxFit.cover,
            placeholder: (context, url) => Shimmer.fromColors(
              baseColor: Colors.grey[200]!,
              highlightColor: Colors.grey[100]!,
              child: Container(color: Colors.white),
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey[100],
              child: Icon(Icons.person, size: 32, color: Colors.grey[400]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          child.name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "تاريخ الميلاد: ${child.dateOfBirth.day}/${child.dateOfBirth.month}/${child.dateOfBirth.year}",
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: 0.5,
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  color: AppColors.primary,
                  minHeight: 8,
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              "50%",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          "تقدم الأهداف",
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildMoreButton(BuildContext context) {
    return PullDownButton(
      itemBuilder: (context) => [
        PullDownMenuItem(
          onTap: () {},
          title: 'Edit',
          icon: CupertinoIcons.pencil,
          iconColor: AppColors.primary,
        ),
        PullDownMenuItem(
          onTap: () async {
            // Controllers for doctorName and doctorId
            TextEditingController doctorNameController =
                TextEditingController();
            TextEditingController doctorIdController = TextEditingController();

            // Show QuickAlert with two fields
            QuickAlert.show(
              context: context,
              type: QuickAlertType.custom,
              barrierDismissible: true,
              confirmBtnText: 'Save',
              customAsset: 'assets/images/giphy.gif',
              widget: Column(
                children: [
                  // Field for Doctor Name
                  TextFormField(
                    controller: doctorNameController,
                    decoration: const InputDecoration(
                      alignLabelWithHint: true,
                      hintText: 'Enter Doctor Name',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 10), // Spacing between fields
                  // Field for Doctor ID
                  TextFormField(
                    controller: doctorIdController,
                    decoration: const InputDecoration(
                      alignLabelWithHint: true,
                      hintText: 'Enter Doctor ID',
                      prefixIcon: Icon(Icons.numbers_outlined),
                    ),
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                  ),
                ],
              ),
              onConfirmBtnTap: () async {
                // Validate inputs
                if (doctorNameController.text.isEmpty ||
                    doctorIdController.text.isEmpty) {
                  await QuickAlert.show(
                    context: context,
                    type: QuickAlertType.error,
                    text: 'Please fill all fields',
                  );
                  return;
                }

                // Close the dialog
                Navigator.pop(context);

                // Show success message
                await Future.delayed(const Duration(milliseconds: 500));
                await QuickAlert.show(
                  context: context,
                  type: QuickAlertType.success,
                  text:
                      "Doctor '${doctorNameController.text}' has been assigned!",
                );

                // Save data to Firestore
                try {
                  final uid = FirebaseAuth.instance.currentUser!.uid;
                  final doctorSnap = await FirebaseFirestore.instance
                      .collection('Doctors')
                      .doc(doctorIdController.text)
                      .get();

                  if (!doctorSnap.exists) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Doctor ID does not exist")),
                    );
                    return;
                  }

                  // Update child data
                  child.doctorId = doctorIdController.text;
                  child.doctorName = doctorNameController.text;

                  // Save to Firestore
                  await FirebaseFirestore.instance
                      .collection("users")
                      .doc(doctorSnap['Doctor_id'])
                      .collection("children")
                      .doc(child.parentPhone)
                      .set(child.toMap());

                  // Delete from current user's collection
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .collection("children")
                      .doc(child.parentPhone)
                      .delete();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Child transferred successfully!")),
                  );
                } catch (e) {
                  ScaffoldMessenger.of( context).showSnackBar(
                    SnackBar(content: Text("Error: $e")),
                  );
                }
              },
            );
          },
          title: 'Transfer',
          icon: CupertinoIcons.arrow_2_circlepath,
        ),
        PullDownMenuItem(
          onTap: () {},
          title: 'Remove',
          icon: CupertinoIcons.delete,
          iconColor: AppColors.error,
        ),
      ],
      buttonBuilder: (context, showMenu) => CupertinoButton(
        onPressed: showMenu,
        padding: EdgeInsets.zero,
        child: const Icon(
          CupertinoIcons.ellipsis_circle,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

class ChildGridCard extends StatelessWidget {
  final Child child;
  final VoidCallback onTap;

  const ChildGridCard({
    super.key,
    required this.child,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final height =MediaQuery.sizeOf(context).height;
    print(height);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(


        color: Colors.transparent,
        child: InkWell(

          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Avatar
                Hero(
                  tag: 'child_avatar_${child.id}${child.name}',
                  child: Container(
                    width: double.infinity,
                    height: height/6.3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.1),
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: CachedNetworkImage(
                        imageUrl: child.gender == "Male"
                            ? "https://img.freepik.com/premium-photo/professional-portrait-studio-photograph-adorable-mixedrace-child-generative-ai_895561-2847.jpg"
                            : "https://avatarfiles.alphacoders.com/143/143832.jpg",
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey[200]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(color: Colors.white),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[100],
                          child: Icon(Icons.person,
                              size: 32, color: Colors.grey[400]),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Name
                Text(
                  child.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                // Birthdate
                Text(
                  "تاريخ الميلاد: ${child.dateOfBirth.day}/${child.dateOfBirth.month}/${child.dateOfBirth.year}",
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                // Progress
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: 0.5,
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          color: AppColors.primary,
                          minHeight: 8,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "50%",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.text,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
