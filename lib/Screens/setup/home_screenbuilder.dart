

import 'package:ajeal/Admin/Screens/AdminMainScreen/AdminmainScreen/AdminmainScreen.dart';
import 'package:ajeal/Admin/models/ChildModel/ChildModel.dart';
import 'package:ajeal/Parents/ParentHomeScreen/ParentHomeScreen.dart';
import 'package:ajeal/Screens/AdminOrparents/AdminOrParintsScreen.dart';
import 'package:flutter/cupertino.dart';

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
  }) : _isAdminLogin = isAdminLogin, _adminDoctorId = adminDoctorId, _adminDoctorName = adminDoctorName, _adminDoctorPhone = adminDoctorPhone, _isParentLogin = isParentLogin, _child = child, _parentCode = parentCode, _parentDoctorKey = parentDoctorKey;

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
      return AdminmainScreen(
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
