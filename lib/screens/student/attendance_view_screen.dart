// lib/screens/attendance_view_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shivagadhi/models/user.dart';
import '../../models/attendance.dart';

class AttendanceViewScreen extends StatefulWidget {
  final String studentId;
  final bool isTeacher;

  const AttendanceViewScreen({
    super.key,
    required this.studentId,
    this.isTeacher = false, required User student,
  });

  @override
  State<AttendanceViewScreen> createState() => _AttendanceViewScreenState();
}

class _AttendanceViewScreenState extends State<AttendanceViewScreen> {
  final List<Attendance> _attendanceRecords = [];
  bool _isLoading = true;
  DateTime? _selectedMonth;

  @override
  void initState() {
    super.initState();
    _selectedMonth = DateTime.now();
    _loadAttendance();
  }

  Future<void> _loadAttendance() async {
    // Simulate loading delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _attendanceRecords.addAll([
        Attendance(
          id: '1',
          studentId: widget.studentId,
          markedById: 'TCH001',
          date: DateTime.now().subtract(const Duration(days: 1)),
          markedAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
          status: AttendanceStatus.present,
          subjectName: 'Mathematics',
          className: 'Class 10-A',
        ),
        Attendance(
          id: '2',
          studentId: widget.studentId,
          markedById: 'TCH002',
          date: DateTime.now().subtract(const Duration(days: 2)),
          markedAt: DateTime.now().subtract(const Duration(days: 2, hours: 2)),
          status: AttendanceStatus.absent,
          remarks: 'Medical Leave',
          subjectName: 'Science',
          className: 'Class 10-A',
        ),
        // Add more sample attendance records as needed
      ]);
      _isLoading = false;
    });
  }

  List<Attendance> get _filteredAttendance {
    if (_selectedMonth == null) return _attendanceRecords;
    return _attendanceRecords.where((record) {
      return record.date.year == _selectedMonth!.year &&
          record.date.month == _selectedMonth!.month;
    }).toList();
  }

  double get _attendancePercentage {
    if (_filteredAttendance.isEmpty) return 0;
    final totalPresent = _filteredAttendance
        .where((record) => record.isPresent || record.isExcused)
        .length;
    return (totalPresent / _filteredAttendance.length) * 100;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: _selectedMonth ?? DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
                initialDatePickerMode: DatePickerMode.year,
              );
              if (picked != null) {
                setState(() => _selectedMonth = picked);
              }
            },
          ),
          if (widget.isTeacher)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                // Implement add attendance functionality
              },
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          _buildAttendanceSummary(),
          Expanded(child: _buildAttendanceList()),
        ],
      ),
    );
  }

  Widget _buildAttendanceSummary() {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              DateFormat('MMMM yyyy').format(_selectedMonth ?? DateTime.now()),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem(
                  'Attendance',
                  '${_attendancePercentage.toStringAsFixed(1)}%',
                  _getAttendanceColor(_attendancePercentage),
                ),
                _buildSummaryItem(
                  'Present',
                  _filteredAttendance
                      .where((r) => r.isPresent)
                      .length
                      .toString(),
                  Colors.green,
                ),
                _buildSummaryItem(
                  'Absent',
                  _filteredAttendance
                      .where((r) => r.isAbsent)
                      .length
                      .toString(),
                  Colors.red,
                ),
                _buildSummaryItem(
                  'Late',
                  _filteredAttendance
                      .where((r) => r.isLate)
                      .length
                      .toString(),
                  Colors.orange,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildAttendanceList() {
    if (_filteredAttendance.isEmpty) {
      return const Center(
        child: Text(
          'No attendance records found',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _filteredAttendance.length,
      itemBuilder: (context, index) {
        final record = _filteredAttendance[index];
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _getStatusColor(record.status).withOpacity(0.1),
              child: Icon(
                _getStatusIcon(record.status),
                color: _getStatusColor(record.status),
              ),
            ),
            title: Text(
              DateFormat('EEEE, MMMM d, yyyy').format(record.date),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(record.subjectName ?? 'All Subjects'),
                if (record.remarks != null)
                  Text(
                    record.remarks!,
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
              ],
            ),
            trailing: widget.isTeacher
                ? IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // Implement edit functionality
              },
            )
                : null,
          ),
        );
      },
    );
  }

  Color _getAttendanceColor(double percentage) {
    if (percentage >= 90) return Colors.green;
    if (percentage >= 75) return Colors.blue;
    if (percentage >= 60) return Colors.orange;
    return Colors.red;
  }

  Color _getStatusColor(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present:
        return Colors.green;
      case AttendanceStatus.absent:
        return Colors.red;
      case AttendanceStatus.late:
        return Colors.orange;
      case AttendanceStatus.excused:
        return Colors.blue;
      case AttendanceStatus.halfDay:
        return Colors.amber;
      case AttendanceStatus.leave:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  IconData _getStatusIcon(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present:
        return Icons.check_circle;
      case AttendanceStatus.absent:
        return Icons.cancel;
      case AttendanceStatus.late:
        return Icons.access_time;
      case AttendanceStatus.excused:
        return Icons.medical_services;
      case AttendanceStatus.halfDay:
        return Icons.brightness_6;
      case AttendanceStatus.leave:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }
}