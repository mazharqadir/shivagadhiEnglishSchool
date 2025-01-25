// lib/screens/teacher/grade_marking_screen.dart
import 'package:flutter/material.dart';
import 'package:shivagadhi/models/user.dart';
import '../../constants/colors.dart';

class GradeMarkingScreen extends StatefulWidget {
  const GradeMarkingScreen({super.key, required User teacher});

  @override
  State<GradeMarkingScreen> createState() => _GradeMarkingScreenState();
}

class _GradeMarkingScreenState extends State<GradeMarkingScreen> {
  final List<String> _subjects = ['Mathematics', 'Science', 'English', 'History'];
  final List<String> _examTypes = ['Mid Term', 'Final Term', 'Quiz', 'Assignment'];
  String _selectedSubject = 'Mathematics';
  String _selectedExamType = 'Mid Term';
  List<StudentGrade> _studentGrades = [];

  @override
  void initState() {
    super.initState();
    // Simulate loading student data
    _studentGrades = [
      StudentGrade(
        studentId: '1',
        studentName: 'Ammar',
        rollNumber: 'A001',
      ),
      StudentGrade(
        studentId: '2',
        studentName: 'Mazhar',
        rollNumber: 'A002',
      ),

    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mark Grades'),
        backgroundColor: AppColors.primary,
      ),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(
            child: _buildStudentsList(),
          ),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            value: _selectedSubject,
            decoration: const InputDecoration(
              labelText: 'Subject',
              border: OutlineInputBorder(),
            ),
            items: _subjects.map((String subject) {
              return DropdownMenuItem(
                value: subject,
                child: Text(subject),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedSubject = newValue!;
              });
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedExamType,
            decoration: const InputDecoration(
              labelText: 'Exam Type',
              border: OutlineInputBorder(),
            ),
            items: _examTypes.map((String type) {
              return DropdownMenuItem(
                value: type,
                child: Text(type),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedExamType = newValue!;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStudentsList() {
    return ListView.builder(
      itemCount: _studentGrades.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final student = _studentGrades[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            student.studentName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Roll No: ${student.rollNumber}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.history),
                      onPressed: () => _showGradeHistory(student),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Marks Obtained',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          student.marksObtained = double.tryParse(value);
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Total Marks',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          student.totalMarks = double.tryParse(value);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Remarks',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    student.remarks = value;
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: _submitGrades,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          minimumSize: const Size(double.infinity, 50),
        ),
        child: const Text('Submit Grades'),
      ),
    );
  }

  void _showGradeHistory(StudentGrade student) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Grade History - ${student.studentName}'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: 3, // Sample history count
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('$_selectedSubject - Quiz ${index + 1}'),
                subtitle: Text('Grade: A (90%)'),
                trailing: Text('${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}'),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _submitGrades() {
    // Validate grades
    bool isValid = true;
    String errorMessage = '';

    for (var student in _studentGrades) {
      if (student.marksObtained == null || student.totalMarks == null) {
        isValid = false;
        errorMessage = 'Please enter marks for all students';
        break;
      }
      if (student.marksObtained! > student.totalMarks!) {
        isValid = false;
        errorMessage = 'Obtained marks cannot be greater than total marks';
        break;
      }
    }

    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
      return;
    }

    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Submission'),
        content: const Text('Are you sure you want to submit these grades?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Implement grade submission logic here
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Grades submitted successfully')),
              );
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}

class StudentGrade {
  final String studentId;
  final String studentName;
  final String rollNumber;
  double? marksObtained;
  double? totalMarks;
  String? remarks;

  StudentGrade({
    required this.studentId,
    required this.studentName,
    required this.rollNumber,
    this.marksObtained,
    this.totalMarks,
    this.remarks,
  });
}