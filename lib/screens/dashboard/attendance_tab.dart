// lib/screens/dashboard/attendance_tab.dart

import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../models/user_role.dart';
import '../student/attendance_view_screen.dart';
import '../teacher/attendance_marking_screen.dart';

class AttendanceTab extends StatelessWidget {
  final User user;

  const AttendanceTab({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    if (user.role == UserRole.student) {
      return AttendanceViewScreen(student: user, studentId: '',);
    } else if (user.role == UserRole.teacher) {
      return AttendanceMarkingScreen(teacher: user);
    } else {
      return const Center(
        child: Text(
          'Attendance management is only available for teachers and students',
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