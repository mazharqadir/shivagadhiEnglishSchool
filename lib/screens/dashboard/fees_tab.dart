// lib/screens/dashboard/fees_tab.dart

import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../models/user_role.dart';
import '../admin/fee_management_screen.dart';  // For admin
import '../student/fee_view_screen.dart';      // For student

class FeesTab extends StatelessWidget {
  final User user;

  const FeesTab({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    // Route to appropriate screen based on user role
    if (user.role == UserRole.admin) {
      return FeeManagementScreen();  // Admin sees fee management
    } else if (user.role == UserRole.student) {
      return FeeViewScreen(student: user);  // Student sees their fees
    } else {
      // For teachers or any other role, show a message
      return const Center(
        child: Text(
          'Fee management is only available for administrators and students',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      );
    }
  }
}