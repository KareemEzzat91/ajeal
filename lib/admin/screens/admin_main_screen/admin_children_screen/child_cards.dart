import 'package:ajeal/core/constants/app_colors.dart';
import 'package:ajeal/core/widgets/dialogs.dart';
import 'package:ajeal/core/models/child_model/child_model.dart';
import 'package:ajeal/helpers/generated/l10n.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shimmer/shimmer.dart';


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
                    Expanded(child: _buildChildInfo(context)),
                    _buildMoreButton(context,child.parentPhone),
                  ],
                ),
                const SizedBox(height: 20),
                _buildProgressIndicator(context),
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

  Widget _buildChildInfo(BuildContext context ) {
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
          "${S.of(context).dateOfBirth}: ${child.dateOfBirth.day}/${child.dateOfBirth.month}/${child.dateOfBirth.year}",
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator(BuildContext context ) {
    // Calculate progress percentage based on completed sessions
    final int totalSessions = child.scheduleSessions.length;
    final  num completedSessions = child.completedSessions;
    final double progressPercentage = totalSessions > 0
        ? completedSessions / totalSessions
        : 0.0;

    // Format percentage for display
    final String percentageText = "${(progressPercentage * 100).toStringAsFixed(0)}%";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progressPercentage,
                  backgroundColor: Colors.grey,
                  color: AppColors.primary,
                  minHeight: 8,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              percentageText,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
             Text(
              S.of(context).goalProgress,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              "$completedSessions من $totalSessions",
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
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
                    ScaffoldMessenger.of(context).showSnackBar( const SnackBar(content: Text("Deleted Scuccfluy",),backgroundColor: CupertinoColors.activeGreen,));

                    Navigator.pop(context);
                  }catch(e){
                    ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text(e.toString())));
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
  final bool useHeroAnimation;

  const ChildGridCard({
    super.key,
    required this.child,
    required this.onTap,
    this.useHeroAnimation = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final height = MediaQuery.of(context).size.height;
    // Extract avatar URL logic to separate method
    final avatarUrl = _getAvatarUrl();

    return Container(
      decoration: BoxDecoration(
        color: theme.primaryColor,
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
        color: theme.primaryColor,
        borderRadius: BorderRadius.circular(24),
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
                _buildAvatar(context, avatarUrl, height),
                const SizedBox(height: 12),

                // Name
                Text(
                  child.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),

                // Birthdate
                Text(
                    "${S.of(context).dateOfBirth} :${_formatDate( child.dateOfBirth)}" ,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),

                // Progress
                _buildProgressIndicator(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, String imageUrl, double height) {
    final avatarContent = Container(
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
        borderRadius: BorderRadius.circular(14), // Adjusted to account for border
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => Shimmer.fromColors(
            baseColor: Colors.grey[200]!,
            highlightColor: Colors.grey[100]!,
            child: Container(color: Colors.white),
          ),
          errorWidget: (context, url, error) => Container(
            color: Colors.grey[100],
            child: const Icon(Icons.person, size: 32, color: Colors.grey),
          ),
          memCacheHeight: (height / 6.3 * MediaQuery.of(context).devicePixelRatio).round(),
        ),
      ),
    );

    return useHeroAnimation
        ? Hero(
      tag: 'child_avatar_${child.id}${child.name}',
      child: avatarContent,
    )
        : avatarContent;
  }

  Widget _buildProgressIndicator(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = S.of(context);

    // Calculate progress percentage based on completed sessions
    final int totalSessions = child.scheduleSessions.length;
    final num completedSessions = child.completedSessions;
    final double progressPercentage = totalSessions > 0
        ? (completedSessions / totalSessions).clamp(0.0, 1.0)
        : 0.0;

    // Format percentage for display
    final String percentageText = "${(progressPercentage * 100).toStringAsFixed(0)}%";
    final String progressLabel = localizations.goalProgress ;
    final String progressText = "$completedSessions من $totalSessions";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progressPercentage,
                  backgroundColor: Colors.grey,
                  color: AppColors.primary,
                  minHeight: 8,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              percentageText,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
              semanticsLabel:  "نسبة الإكمال $percentageText",
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              progressLabel,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              progressText,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
              semanticsLabel: "$completedSessions جلسات مكتملة من أصل $totalSessions",
            ),
          ],
        ),
      ],
    );
  }

  String _getAvatarUrl() {
    return child.gender == "Male"
        ? "https://img.freepik.com/premium-photo/professional-portrait-studio-photograph-adorable-mixedrace-child-generative-ai_895561-2847.jpg"
        : "https://avatarfiles.alphacoders.com/143/143832.jpg";
  }
  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

}// Handle the case where user is adding someone else's child
Future<void> handleOthersCase(BuildContext context, String childCode) async {
  // Show loading indicator
  showLoadingDialog(context);

  try {
    final childSnap = await FirebaseFirestore.instance
        .collection("Children")
        .doc(childCode)
        .get();

    // Close loading dialog
    if (!context.mounted) return;
    Navigator.pop(context);

    if (!childSnap.exists || childSnap.data() == null || childSnap.data()!.isEmpty) {
      showErrorMessage(context, 'Child code not found');
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
    if (!context.mounted) return;
    Navigator.pop(context);
    showSuccessMessage(context, 'Child added successfully');

  } catch (e) {
    if (!context.mounted) return;
    Navigator.pop(context); // Close loading dialog if open
    showErrorMessage(context, e.toString());
  }
}

// Handle the case where a doctor is being assigned to a child
Future<void> handleDoctorAssignment(
    BuildContext context,
    Child child,
    String doctorName,
    String doctorId
    ) async {
  // Show loading indicator
  showLoadingDialog(context);

  try {
    final doctorSnap = await FirebaseFirestore.instance
        .collection('Doctors')
        .doc(doctorId)
        .get();

    // Close loading dialog
    if (!context.mounted) return;
    Navigator.pop(context);

    if (!doctorSnap.exists) {
      showErrorMessage(context, 'Doctor ID does not exist');
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
    if (!context.mounted) return;
    Navigator.pop(context);
    showSuccessMessage(
        context,
        "Child transferred to Dr. $doctorName successfully!"
    );
  } catch (e) {
    if (!context.mounted) return;
    Navigator.pop(context); // Close loading dialog if open
    showErrorMessage(context, e.toString());
  }
}
