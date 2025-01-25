// lib/screens/dashboard/dashboard_screen.dart

import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../models/user_role.dart';
import 'home_tab.dart';
import 'students_tab.dart';
import 'teachers_tab.dart';
import 'classes_tab.dart';
import 'profile_tab.dart';
import 'grades_tab.dart';
import 'attendance_tab.dart';
import 'fees_tab.dart';

class DashboardScreen extends StatefulWidget {
  final User user;

  const DashboardScreen({
    super.key,
    required this.user,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  late List<Widget> _screens;
  late List<BottomNavigationBarItem> _navItems;

  @override
  void initState() {
    super.initState();
    _initializeNavigation();
  }

// In _initializeNavigation() method of dashboard_screen.dart

void _initializeNavigation() {
    switch (widget.user.role) {
      case UserRole.admin:
        _screens = [
          HomeTab(user: widget.user),
          StudentsTab(canAdd: true),
          TeachersTab(canAdd: true),
          ClassesTab(canAdd: true),
          FeesTab(user: widget.user),  // Admin sees fee management
          ProfileTab(user: widget.user),
        ];
        _navItems = const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Students'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Teachers'),
          BottomNavigationBarItem(icon: Icon(Icons.class_), label: 'Classes'),
          BottomNavigationBarItem(icon: Icon(Icons.payment), label: 'Fees'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ];
        break;

      case UserRole.teacher:
        _screens = [
          HomeTab(user: widget.user),
          StudentsTab(canAdd: false),
          GradesTab(user: widget.user),
          AttendanceTab(user: widget.user),
          ProfileTab(user: widget.user),
        ];
        _navItems = const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Students'),
          BottomNavigationBarItem(icon: Icon(Icons.grade), label: 'Grades'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: 'Attendance'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ];
        break;

      case UserRole.student:
        _screens = [
          HomeTab(user: widget.user),
          GradesTab(user: widget.user),
          FeesTab(user: widget.user),  // Student sees fee view
          AttendanceTab(user: widget.user),
          ProfileTab(user: widget.user),
        ];
        _navItems = const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.grade), label: 'Grades'),
          BottomNavigationBarItem(icon: Icon(Icons.payment), label: 'Fees'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: 'Attendance'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ];
        break;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_navItems[_selectedIndex].label!),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // TODO: Implement notifications
            },
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: _navItems,
      ),
    );
  }
}