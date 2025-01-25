// lib/screens/teacher/attendance_marking_screen.dart

import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../models/attendance.dart';

class AttendanceMarkingScreen extends StatefulWidget {
  final User teacher;

  const AttendanceMarkingScreen({
    super.key,
    required this.teacher,
  });

  @override
  State<AttendanceMarkingScreen> createState() => _AttendanceMarkingScreenState();
}

class _AttendanceMarkingScreenState extends State<AttendanceMarkingScreen> {
  String _selectedClass = 'Class 10-A';
  DateTime _selectedDate = DateTime.now();
  List<Map<String, dynamic>> _students = []; // Will be populated from database
  bool _isMarking = false;

  @override
  void initState() {
    super.initState();
    // Simulate loading students data
    _students = List.generate(
      15,
      (index) => {
        'id': 'STU${index + 1}',
        'name': 'Student ${index + 1}',
        'rollNo': '${index + 1}',
        'status': AttendanceStatus.present,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _buildStudentsList(),
          ),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildClassDropdown(),
                ),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: () => _selectDate(context),
                  icon: const Icon(Icons.calendar_today),
                ),
                const SizedBox(width: 8),
                Text(
                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildLegendItem('Present', Colors.green),
                _buildLegendItem('Absent', Colors.red),
                _buildLegendItem('Leave', Colors.orange),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedClass,
      decoration: const InputDecoration(
        labelText: 'Select Class',
        border: OutlineInputBorder(),
      ),
      items: ['Class 10-A', 'Class 10-B', 'Class 11-A', 'Class 11-B']
          .map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          _selectedClass = newValue!;
        });
      },
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(label),
      ],
    );
  }

  Widget _buildStudentsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _students.length,
      itemBuilder: (context, index) {
        final student = _students[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              child: Text(student['rollNo']),
            ),
            title: Text(student['name']),
            subtitle: Text('Roll No: ${student['rollNo']}'),
            trailing: _buildStatusToggle(index),
          ),
        );
      },
    );
  }

  Widget _buildStatusToggle(int index) {
    return ToggleButtons(
      borderRadius: BorderRadius.circular(8),
      selectedBorderColor: Colors.transparent,
      onPressed: (int selectedIndex) {
        setState(() {
          _students[index]['status'] = AttendanceStatus.values[selectedIndex];
        });
      },
      isSelected: [
        _students[index]['status'] == AttendanceStatus.present,
        _students[index]['status'] == AttendanceStatus.absent,
        _students[index]['status'] == AttendanceStatus.leave,
      ],
      children: [
        _buildToggleButton(Icons.check, Colors.green),
        _buildToggleButton(Icons.close, Colors.red),
        _buildToggleButton(Icons.schedule, Colors.orange),
      ],
    );
  }

  Widget _buildToggleButton(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Icon(icon, color: color),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: _isMarking ? null : _submitAttendance,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(50),
        ),
        child: _isMarking
            ? const CircularProgressIndicator()
            : const Text('Submit Attendance'),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 7)),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submitAttendance() async {
    setState(() {
      _isMarking = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Show success dialog
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Success'),
            content: Text(
                'Attendance marked successfully for $_selectedClass on ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      // Show error dialog
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to mark attendance. Please try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } finally {
      setState(() {
        _isMarking = false;
      });
    }
  }
}