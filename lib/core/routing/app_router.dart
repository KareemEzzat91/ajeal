import 'package:ajeal/admin/screens/admin_main_screen/admin_children_screen/admin_add_child/admin_add_child_screen.dart';
import 'package:ajeal/admin/screens/admin_main_screen/admin_children_screen/admin_children_screen.dart';
import 'package:ajeal/admin/screens/admin_main_screen/admin_children_screen/child_details_screen/child_detail_screen.dart';
import 'package:ajeal/admin/screens/admin_main_screen/admin_children_screen/child_details_screen/session_detail_screen/session_detail_screen.dart';
import 'package:ajeal/admin/screens/admin_main_screen/admin_main_screen/admin_main_screen.dart';
import 'package:ajeal/core/models/child_model/child_model.dart';
import 'package:ajeal/parents/parent_home_screen/parent_home_screen.dart';
import 'package:ajeal/screens/admin_or_parents/admin_or_parents_screen.dart';
import 'package:ajeal/screens/setup/buildhome_screen.dart';
import 'package:ajeal/screens/setup/home_screenbuilder.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
          path: '/admin/children/add',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>? ?? {};
            return AdminAddChildScreen(
              doctorId: extra['doctorId'] ?? '',
              doctorName: extra['doctorName'] ?? '',
            );
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
      ],
    );
  }
}
