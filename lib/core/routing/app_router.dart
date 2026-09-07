import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'routes.dart';

import '../../features/admin/auth/presentation/screens/login_screen.dart';
import '../../features/admin/auth/presentation/screens/reset_password_screen.dart';
import '../../features/admin/auth/presentation/screens/sign_up_screen.dart';
import '../../features/admin/auth/presentation/screens/verification_screen.dart';
import '../../features/admin/children/presentation/screens/admin_add_child/admin_add_child_screen.dart';
import '../../features/admin/children/presentation/screens/admin_children_select_goals/admin_select_goals_screen.dart';
import '../../features/admin/children/presentation/screens/admin_children_select_goals/goal_detail_screen.dart';
import '../../features/admin/children/presentation/screens/child_details_screen/ai_result_screen.dart';
import '../../features/admin/children/presentation/screens/child_details_screen/all_details_screen.dart';
import '../../features/admin/children/presentation/screens/child_details_screen/child_detail_screen.dart';
import '../../features/admin/children/presentation/screens/child_details_screen/child_info.dart';
import '../../features/admin/children/presentation/screens/child_details_screen/daily_notes_screen/daily_notes_screen.dart';
import '../../features/admin/children/presentation/screens/child_details_screen/session_detail_screen/choosetasks_screen/choosetasks_screen.dart';
import '../../features/admin/children/presentation/screens/child_details_screen/session_detail_screen/session_detail_screen.dart';
import '../../features/admin/children/presentation/screens/child_details_screen/session_detail_screen/sessiontaskrate_screen/sessiontaskrate_screen.dart';
import '../../features/admin/main/presentation/screens/admin_main_screen.dart';
import '../../features/parent/chat/presentation/screens/all_parents_chats/global_chat_screen.dart';
import '../../features/parent/chat/presentation/screens/parent_admin_chat/parent_admin_chat_screen.dart';
import '../../features/parent/goals/presentation/screens/parentchildgoals_screen.dart';
import '../../features/parent/home/presentation/screens/parent_home_screen.dart';
import '../../features/parent/schedule/presentation/screens/parent_session_schedule_screen.dart';
import '../../features/parent/auth/presentation/screens/parent_login_page.dart';
import '../../features/onboarding/presentation/screens/role_selection/admin_or_parents_screen.dart';
import '../../features/onboarding/presentation/screens/setup/home_screenbuilder.dart';
import '../models/child_model/child_model.dart';

class AppRouter {
  static GoRouter getRouter({
    required bool isAdminLogin,
    required String adminDoctorId,
    required String adminDoctorName,
    required String adminDoctorPhone,
    required bool isParentLogin,
    Child? child,
    required String parentCode,
    required String parentDoctorKey,
  }) {
    return GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) {
            return HomeScreenBuilder(
              isAdminLogin: isAdminLogin,
              adminDoctorId: adminDoctorId,
              adminDoctorName: adminDoctorName,
              adminDoctorPhone: adminDoctorPhone,
              isParentLogin: isParentLogin,
              parentCode: parentCode,
              parentDoctorKey: parentDoctorKey,
              child: child,
            );
          },
        ),
        GoRoute(
          path: '/choice',
          builder: (context, state) => const AdminOrParentsScreen(),
        ),
        GoRoute(
          path: '/admin/main',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>? ?? {};
            return AdminMainScreen(
              doctorName: extra['doctorName'] ?? '',
              doctorId: extra['doctorId'] ?? '',
              doctorPhone: extra['doctorPhone'] ?? '',
            );
          },
        ),
        GoRoute(
          path: '/parent/main',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>? ?? {};
            return ParentHomePage(
              child: extra['child'],
              parentCode: extra['parentCode'] ?? '',
              adminId: extra['adminId'] ?? '',
            );
          },
        ),
        GoRoute(
          path: Routes.adminChildrenAdd,
          builder: (context, state) {
            return const AdminAddChildScreen();
          },
        ),
        GoRoute(
          path: '/admin/children/details',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            return ChildDetailScreen(
              child: extra?['child'],
              isOthers: extra?['isOthers'] ?? false,
              birthDate: extra?['birthDate'] ?? '',
              childName: extra?['childName'] ?? '',
              goals: extra?['goals'] ?? [],
              progress: extra?['progress'] ?? '0%',
            );
          },
        ),
        GoRoute(
          path: '/admin/children/sessions',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            return SessionDetailScreen(
              sessionName: extra?['sessionName'] ?? 1,
              childName: extra?['childName'] ?? '',
              date: extra?['date'] ?? '',
              goals: extra?['goals'] ?? [],
              childId: extra?['childId'] ?? '',
              rate: extra?['rate'] ?? 0,
              notes: extra?['notes'] ?? '',
              tasks: extra?['tasks'] ?? [],
              isParent: extra?['isParent'] ?? false,
              isCompleted: extra?['isCompleted'] ?? false,
              isOthers: extra?['isOthers'],
              doctorId: extra?['doctorId'],
              completedSessions: extra?['completedSessions'],
            );
          },
        ),
        GoRoute(
          path: '/admin/login',
          builder: (context, state) => const AdminLoginScreen(),
        ),
        GoRoute(
          path: '/admin/reset_password',
          builder: (context, state) => const ResetPasswordScreen(),
        ),
        GoRoute(
          path: '/admin/signup',
          builder: (context, state) => const SignupScreen(),
        ),
        GoRoute(
          path: '/admin/verification',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>? ?? {};
            return VerificationScreen(user: extra['user']);
          },
        ),
        GoRoute(
          path: '/parent/login',
          builder: (context, state) => const ParentLoginPage(),
        ),
        GoRoute(
          path: '/admin/children/add/goals',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>? ?? {};
            return AdminSelectGoals(
              phone: extra['phone'] ?? '',
            );
          },
        ),
        GoRoute(
          path: '/admin/children/details/info',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            return ChildInfoSection(
              child: extra?['child'],
              birthDate: extra?['birthDate'] ?? '',
              context: context,
              theme: Theme.of(context),
            );
          },
        ),
        GoRoute(
          path: '/admin/children/details/ai_results',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            return AIResultsScreen(
              childName: extra?['childName'] ?? '',
              analysis: extra?['analysis'] ?? '',
              sessionsData: extra?['sessionsData'] ?? [],
            );
          },
        ),
        GoRoute(
          path: '/admin/children/details/daily_notes',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>? ?? {};
            return DailyNotesScreen(
              childID: extra['childID'] ?? extra['childId'] ?? '',
              userType: extra['userType'] ?? 'Admin',
              isOthers: extra['isOthers'] ?? false,
              otherDoctorId: extra['otherDoctorId'],
            );
          },
        ),
        GoRoute(
          path: '/admin/children/sessions/choose_tasks',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>? ?? {};
            return ChooseTasksScreen(
              selectedGoal: extra['selectedGoal'],
            );
          },
        ),
        GoRoute(
          path: '/admin/children/sessions/rate_task',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            return SessionTaskRateScreen(
              task: extra?['task'],
              isParent: extra?['isParent'] ?? false,
            );
          },
        ),
        GoRoute(
          path: '/parent/global_chat',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>? ?? {};
            return GlobalChatScreen(
              childName: extra['childName'] ?? '',
              doctorId: extra['doctorId'] ?? '',
              parentId: extra['parentId'] ?? '',
              isParent: extra['isParent'] ?? true,
            );
          },
        ),
        GoRoute(
          path: '/parent/child_goals',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            return ChildGoalsPage(
              goals: extra?['child']?.selectedGoals ?? [],
            );
          },
        ),
        GoRoute(
          path: '/parent/session_schedule',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            return SessionSchedulePage(
              child: extra?['child'],
              completedSesions: extra?['child']?.completedSessions.toInt() ?? 0,
              name: extra?['child']?.name ?? '',
              isParent: extra?['isParent'] ?? true,
              childId: extra?['child']?.parentPhone ?? '',
              scheduleSessions: extra?['child']?.scheduleSessions ?? [],
            );
          },
        ),
        GoRoute(
          path: '/admin/children/details/all',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            return AllDetailsScreen(
              extra?['child'],
            );
          },
        ),
        GoRoute(
          path: '/parent/chat',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>? ?? {};
            return ChatScreen(
              doctorId: extra['doctorId'] ?? '',
              isParent: extra['isParent'] ?? false,
              parentId: extra['parentId'] ?? '',
              isOthers: extra['isOthers'] ?? false,
              doctorOthersId: extra['doctorOthersId'],
              role: extra['role'] ?? '',
            );
          },
        ),
        GoRoute(
          path: '/admin/children/add/goals/detail',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            return GoalDetailScreen(
              goal: extra?['goal'],
            );
          },
        ),
      ],
    );
  }
}
