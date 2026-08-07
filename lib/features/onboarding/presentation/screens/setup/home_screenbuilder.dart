import 'package:flutter/cupertino.dart';

import 'package:ajeal/features/admin/main/presentation/screens/admin_main_screen.dart';
import 'package:ajeal/core/models/child_model/child_model.dart';
import 'package:ajeal/features/parent/home/presentation/screens/parent_home_screen.dart';
import 'package:ajeal/features/onboarding/presentation/screens/role_selection/admin_or_parents_screen.dart';

class HomeScreenBuilder extends StatelessWidget {
  const HomeScreenBuilder({
    super.key,
    required bool isAdminLogin,
    required String adminDoctorId,
    required String adminDoctorName,
    required String adminDoctorPhone,
    required bool isParentLogin,
    required Child? child,
    required String parentCode,
    required String parentDoctorKey,
  })  : _isAdminLogin = isAdminLogin,
        _adminDoctorId = adminDoctorId,
        _adminDoctorName = adminDoctorName,
        _adminDoctorPhone = adminDoctorPhone,
        _isParentLogin = isParentLogin,
        _child = child,
        _parentCode = parentCode,
        _parentDoctorKey = parentDoctorKey;

  final bool _isAdminLogin;
  final String _adminDoctorId;
  final String _adminDoctorName;
  final String _adminDoctorPhone;
  final bool _isParentLogin;
  final Child? _child;
  final String _parentCode;
  final String _parentDoctorKey;

  @override
  Widget build(BuildContext context) {
    if (_isAdminLogin) {
      return AdminMainScreen(
        doctorId: _adminDoctorId,
        doctorName: _adminDoctorName,
        doctorPhone: _adminDoctorPhone,
      );
    }

    if (_isParentLogin && _child != null) {
      return ParentHomePage(
        parentCode: _parentCode,
        child: _child,
        adminId: _parentDoctorKey,
      );
    }

    return const AdminOrParentsScreen();
  }
}
