// lib/screens/grades_view_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shivagadhi/models/user.dart';
import '../../models/grade.dart';

class GradesViewScreen extends StatefulWidget {
  final String studentId;
  final bool isTeacher;

  const GradesViewScreen({
    super.key,
    required this.studentId,
    this.isTeacher = false, required User student,
  });

  @override
  State<GradesViewScreen> createState() => _GradesViewScreenState();
}

class _GradesViewScreenState extends State<GradesViewScreen> {
  String? _selectedSemester;
  String? _selectedSubject;
  final List<Grade> _grades = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGrades();
  }

  Future<void> _loadGrades() async {
    // Simulate loading delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _grades.addAll([
        Grade(
          id: '1',
          studentId: widget.studentId,
          subjectId: 'SUB001',
          teacherId: 'TCH001',
          subjectName: 'Mathematics',
          marksObtained: 85,
          totalMarks: 100,
          examType: 'Midterm',
          remarks: 'Good performance',
          academicYear: '2023-2024',
          semester: 'Semester 1',
        ),
        Grade(
          id: '2',
          studentId: widget.studentId,
          subjectId: 'SUB002',
          teacherId: 'TCH002',
          subjectName: 'Science',
          marksObtained: 92,
          totalMarks: 100,
          examType: 'Final',
          remarks: 'Excellent work',
          academicYear: '2023-2024',
          semester: 'Semester 1',
        ),
        Grade(
          id: '3',
          studentId: widget.studentId,
          subjectId: 'SUB003',
          teacherId: 'TCH003',
          subjectName: 'English',
          marksObtained: 78,
          totalMarks: 100,
          examType: 'Midterm',
          remarks: 'Good effort, needs improvement in writing',
          academicYear: '2023-2024',
          semester: 'Semester 1',
        ),
      ]);
      _isLoading = false;
    });
  }

  List<String> get _semesters {
    return _grades
        .map((grade) => grade.semester)
        .where((semester) => semester != null)
        .toSet()
        .toList()
        .cast<String>();
  }

  List<String> get _subjects {
    return _grades
        .map((grade) => grade.subjectName)
        .toSet()
        .toList();
  }

  List<Grade> get _filteredGrades {
    return _grades.where((grade) {
      if (_selectedSemester != null && grade.semester != _selectedSemester) {
        return false;
      }
      if (_selectedSubject != null && grade.subjectName != _selectedSubject) {
        return false;
      }
      return true;
    }).toList();
  }

  double get _averagePercentage {
    if (_filteredGrades.isEmpty) return 0;
    final total = _filteredGrades.fold<double>(
      0,
          (sum, grade) => sum + grade.percentage,
    );
    return total / _filteredGrades.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grades'),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: () {
              // Implement grade export functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Exporting grades...')),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          _buildFilters(),
          _buildSummary(),
          Expanded(child: _buildGradesList()),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filters',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Semester',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                    value: _selectedSemester,
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('All Semesters'),
                      ),
                      ..._semesters.map((semester) {
                        return DropdownMenuItem(
                          value: semester,
                          child: Text(semester),
                        );
                      }),
                    ],
                    onChanged: (value) {
                      setState(() => _selectedSemester = value);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Subject',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                    value: _selectedSubject,
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('All Subjects'),
                      ),
                      ..._subjects.map((subject) {
                        return DropdownMenuItem(
                          value: subject,
                          child: Text(subject),
                        );
                      }),
                    ],
                    onChanged: (value) {
                      setState(() => _selectedSubject = value);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildSummaryItem(
              'Average',
              '${_averagePercentage.toStringAsFixed(1)}%',
              _getGradeColor(_averagePercentage),
            ),
            _buildSummaryItem(
              'Total Subjects',
              _filteredGrades.length.toString(),
              Colors.blue,
            ),
            _buildSummaryItem(
              'Passed',
              _filteredGrades.where((g) => g.isPassing).length.toString(),
              Colors.green,
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
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildGradesList() {
    if (_filteredGrades.isEmpty) {
      return const Center(
        child: Text(
          'No grades found',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _filteredGrades.length,
      itemBuilder: (context, index) => _buildGradeCard(_filteredGrades[index]),
    );
  }

  Widget _buildGradeCard(Grade grade) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        title: Text(
          grade.subjectName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${grade.examType ?? "Exam"} - ${grade.percentage.toStringAsFixed(1)}%',
          style: TextStyle(
            color: _getGradeColor(grade.percentage),
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _getGradeColor(grade.percentage).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            grade.grade,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _getGradeColor(grade.percentage),
            ),
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildGradeDetail('Marks Obtained', '${grade.marksObtained}/${grade.totalMarks}'),
                _buildGradeDetail('Percentage', '${grade.percentage.toStringAsFixed(1)}%'),
                _buildGradeDetail('Status', grade.isPassing ? 'Passed' : 'Failed'),
                if (grade.remarks != null)
                  _buildGradeDetail('Remarks', grade.remarks!),
                _buildGradeDetail('Date', DateFormat('dd/MM/yyyy').format(grade.dateRecorded)),
                if (widget.isTeacher)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          icon: const Icon(Icons.edit),
                          label: const Text('Edit'),
                          onPressed: () {
                            // Implement edit functionality
                          },
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradeDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getGradeColor(double percentage) {
    if (percentage >= 90) return Colors.green;
    if (percentage >= 80) return Colors.blue;
    if (percentage >= 70) return Colors.orange;
    if (percentage >= 60) return Colors.deepOrange;
    return Colors.red;
  }
}