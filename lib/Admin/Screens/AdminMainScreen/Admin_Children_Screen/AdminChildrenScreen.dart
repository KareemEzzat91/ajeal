import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/AdminAddChild/Addchildcubit/add_child_cubit.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/AdminAddChild/AdminAddChildScreen.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/ChildDetailsScreen/ChildDetailScreen.dart';
import 'package:ajeal/Admin/models/ChildModel/ChildModel.dart';
import 'package:ajeal/helpers/generated/l10n.dart';
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
        backgroundColor: Theme.of(context).primaryColor,
        appBar: _buildAppBar(context, context.read<AddChildCubit>()),
        body: Column(
          children: [
            _buildFilterBar(),
            Expanded(child: _buildBody(context.read<AddChildCubit>())),
          ],
        ),
        floatingActionButton: _currentFilter=="Others"?_buildAnimatedFAB(context,true): _buildAnimatedFAB(context,false),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, AddChildCubit bloc) {
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
            _buildFilterChip('all', 'All'),
            _buildFilterChip('Others', 'Others'),
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
           _currentFilter == "completed"?"لا يوجد فترة منتهية":"لا يوجد أطفال مسجلين بعد",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _currentFilter == "completed"?"":  "اضغط على زر الإضافة لتسجيل طفل جديد",
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

  Widget _buildAnimatedFAB(BuildContext context,bool isOthers) {
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

class ChildCard extends StatelessWidget {
  final Child child;
  final VoidCallback onTap;
  final bool isOthers ;

  const ChildCard({
    super.key,
    required this.child,
    required this.onTap,
    required this.isOthers,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
         BoxShadow(
            color: Colors.black,
            blurRadius: 16,
            offset: Offset(0, 4),
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
                    _buildMoreButton(context,child.parentPhone),
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
            color: AppColors.primary,
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
                child: const LinearProgressIndicator(
                  value: 0.5,
                  backgroundColor: AppColors.primary,
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

  Widget _buildMoreButton(BuildContext context, String parentPhone) {

    return PullDownButton(
      itemBuilder: (context) => [
        PullDownMenuItem(
          enabled: !isOthers,
          onTap: () async {

            showCustomDialog(context,child: child);
          },
          title: 'Transfer',
          icon: CupertinoIcons.arrow_2_circlepath,
        ),
        PullDownMenuItem(
          onTap: () {

            QuickAlert.show(
              context: context,
              type: QuickAlertType.confirm,
              text: 'Do you want to Remove ${child.name}',
              confirmBtnText: 'Yes',
              cancelBtnText: 'No',
              confirmBtnColor: Colors.green,
              onConfirmBtnTap: (){
                try {
                  isOthers?FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).collection("OthersChildren").doc(child.parentPhone).delete()
                      :FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).collection("children").doc(child.parentPhone).delete();
                  ScaffoldMessenger.of(context).showSnackBar( const SnackBar(content: Text("Deleted Scuccfluy")));

                  Navigator.pop(context);
                }catch(e){
                  ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text(e.toString())));
                  print(e.toString());
                  Navigator.pop(context);
                }
              }
            );
          },
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
    final height = MediaQuery.sizeOf(context).height;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Colors.black ,
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Theme.of(context).primaryColor,
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
                    height: height / 6.3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.primary,
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
                        child: const LinearProgressIndicator(
                          value: 0.5,
                          backgroundColor: AppColors.primary,
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
Future<dynamic> showCustomDialog(BuildContext context, {Child? child}) {
  // Determine if we're handling an "Others" case or not
  final bool isOthers = child == null;

  // Initialize controllers with existing values if available
  final TextEditingController doctorNameController = TextEditingController(
  );

  final TextEditingController doctorIdController = TextEditingController(
  );

  final TextEditingController childCodeController = TextEditingController();

  // Form key for validation
  final formKey = GlobalKey<FormState>();

  return QuickAlert.show(
    context: context,
    type: QuickAlertType.custom,
    barrierDismissible: true,
    confirmBtnText: 'Save',
    customAsset: 'assets/images/giphy.gif',
    widget: Form(
      key: formKey,
      child: Column(
        children: [
          // Field for Doctor Name
          if (!isOthers)
            TextFormField(
              controller: doctorNameController,
              decoration: const InputDecoration(
                alignLabelWithHint: true,
                labelText: 'Doctor Name',
                hintText: 'Enter Doctor Name',
                prefixIcon: Icon(Icons.person_outline),
              ),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter doctor name';
                }
                return null;
              },
            ),

          if (!isOthers) const SizedBox(height: 16),

          // Field for Doctor ID
          if (!isOthers)
            TextFormField(
              controller: doctorIdController,
              decoration: const InputDecoration(
                alignLabelWithHint: true,
                labelText: 'Doctor ID',
                hintText: 'Enter Doctor ID',
                prefixIcon: Icon(Icons.numbers_outlined),
              ),
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter doctor ID';
                }
                return null;
              },
            ),

          if (isOthers) const SizedBox(height: 16),

          // Field for Child Code
          if (isOthers)
            TextFormField(
              controller: childCodeController,
              decoration: const InputDecoration(
                alignLabelWithHint: true,
                labelText: 'Child Code',
                hintText: 'Enter Child Code',
                prefixIcon: Icon(Icons.numbers_outlined),
              ),
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter child code';
                }
                return null;
              },
            ),
        ],
      ),
    ),
    onConfirmBtnTap: () async {
      // Validate form
      if (formKey.currentState?.validate() != true) {
        return;
      }

      try {
        if (isOthers) {
          await _handleOthersCase(context, childCodeController.text);
        } else {
          await _handleDoctorAssignment(
              context,
              child,
              doctorNameController.text,
              doctorIdController.text
          );
        }
      } catch (e) {
        // Handle errors centrally
        _showErrorMessage(context, e.toString());
      }
    },
  );
}

// Handle the case where user is adding someone else's child
Future<void> _handleOthersCase(BuildContext context, String childCode) async {
  // Show loading indicator
  _showLoadingDialog(context);

  try {
    final childSnap = await FirebaseFirestore.instance
        .collection("Children")
        .doc(childCode)
        .get();

    // Close loading dialog
    Navigator.pop(context);

    if (!childSnap.exists || childSnap.data() == null || childSnap.data()!.isEmpty) {
      _showErrorMessage(context, 'Child code not found');
      return;
    }

    final Child child = Child.fromJson(childSnap.data()!);
    final userId = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("OthersChildren")
        .doc(child.parentPhone)
        .set(child.toMap());

    // Close dialog and show success message
    Navigator.pop(context);
    _showSuccessMessage(context, 'Child added successfully');

  } catch (e) {
    Navigator.pop(context); // Close loading dialog if open
    _showErrorMessage(context, e.toString());
  }
}

// Handle the case where a doctor is being assigned to a child
Future<void> _handleDoctorAssignment(
    BuildContext context,
    Child child,
    String doctorName,
    String doctorId
    ) async {
  // Show loading indicator
  _showLoadingDialog(context);

  try {
    final doctorSnap = await FirebaseFirestore.instance
        .collection('Doctors')
        .doc(doctorId)
        .get();

    // Close loading dialog
    Navigator.pop(context);

    if (!doctorSnap.exists) {
      _showErrorMessage(context, 'Doctor ID does not exist');
      return;
    }

    // Extract doctor's phone number (only digits) from doctorId or use a dedicated field
    final String doctorPhone = doctorId.replaceAll(RegExp(r'[^0-9]'), '');

    // Update child data
    child.doctorId = doctorId;
    child.doctorName = doctorName;
    child.doctorPhone = doctorPhone;

    final uid = FirebaseAuth.instance.currentUser!.uid;

    // Save to doctor's collection
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

    // Close dialog and show success message
    Navigator.pop(context);
    _showSuccessMessage(
        context,
        "Child transferred to Dr. $doctorName successfully!"
    );
  } catch (e) {
    Navigator.pop(context); // Close loading dialog if open
    _showErrorMessage(context, e.toString());
  }
}

// Helper methods to show dialog messages
void _showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(
      child: CircularProgressIndicator(),
    ),
  );
}

void _showSuccessMessage(BuildContext context, String message) {
  QuickAlert.show(
    context: context,
    type: QuickAlertType.success,
    text: message,
  );
}

void _showErrorMessage(BuildContext context, String error) {
  QuickAlert.show(
    context: context,
    type: QuickAlertType.error,
    text: 'Error: $error',
  );
}