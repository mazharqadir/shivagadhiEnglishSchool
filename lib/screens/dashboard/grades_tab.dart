// lib/screens/dashboard/grades_tab.dart

import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../models/user_role.dart';
import '../teacher/grade_marking_screen.dart';
import '../student/grades_view_screen.dart';

class GradesTab extends StatelessWidget {
  final User user;

  const GradesTab({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    // Route to appropriate screen based on user role
    if (user.role == UserRole.teacher) {
      return GradeMarkingScreen(teacher: user);
    } else if (user.role == UserRole.student) {
      return GradesViewScreen(student: user, studentId: '',);
    } else {
      // For admin or any other role, show a message or redirect
      return const Center(
        child: Text(
          'Grade management is only available for teachers and students',
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