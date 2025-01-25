import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class StudentsTab extends StatefulWidget {
  final bool canAdd;

  const StudentsTab({
    super.key,
    required this.canAdd,
  });

  @override
  State<StudentsTab> createState() => _StudentsTabState();
}

class _StudentsTabState extends State<StudentsTab> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _students = [];
  List<Map<String, dynamic>> _filteredStudents = [];

  @override
  void initState() {
    super.initState();
    // Dummy data - Replace with your actual data source
    _students = [
      {
        'name': 'Ammar',
        'rollNo': '12201694',
        'class': '10th Grade',
        'section': 'A',
        'parentName': 'abc',
        'contact': '+61 434 910 222',
        'address': 'Australia',
      },
      {
        'name': 'Mazhar',
        'rollNo': '12300643',
        'class': '10th Grade',
        'section': 'A',
        'parentName': 'abc',
        'contact': '+61-421616595',
        'address': 'Australia',
      },
      {
        'name': 'Hari',
        'rollNo': '12203752',
        'class': '10th Grade',
        'section': 'A',
        'parentName': 'abc',
        'contact': '+61-421616595',
        'address': 'Australia',
      },
      // Add more dummy data as needed
    ];
    _filteredStudents = List.from(_students);
  }

  void _filterStudents(String query) {
    setState(() {
      _filteredStudents = _students
          .where((student) =>
      student['name'].toLowerCase().contains(query.toLowerCase()) ||
          student['rollNo'].toLowerCase().contains(query.toLowerCase()) ||
          student['class'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _showAddStudentDialog(BuildContext context) {
    final nameController = TextEditingController();
    final rollNoController = TextEditingController();
    final classController = TextEditingController();
    final sectionController = TextEditingController();
    final parentNameController = TextEditingController();
    final contactController = TextEditingController();
    final addressController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Student'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  icon: Icon(Icons.person),
                ),
              ),
              TextField(
                controller: rollNoController,
                decoration: const InputDecoration(
                  labelText: 'Roll Number',
                  icon: Icon(Icons.numbers),
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: classController,
                decoration: const InputDecoration(
                  labelText: 'Class',
                  icon: Icon(Icons.class_),
                ),
              ),
              TextField(
                controller: sectionController,
                decoration: const InputDecoration(
                  labelText: 'Section',
                  icon: Icon(Icons.category),
                ),
              ),
              TextField(
                controller: parentNameController,
                decoration: const InputDecoration(
                  labelText: 'Parent Name',
                  icon: Icon(Icons.family_restroom),
                ),
              ),
              TextField(
                controller: contactController,
                decoration: const InputDecoration(
                  labelText: 'Contact Number',
                  icon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
              ),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  icon: Icon(Icons.home),
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Add new student to the list
              setState(() {
                _students.add({
                  'name': nameController.text,
                  'rollNo': rollNoController.text,
                  'class': classController.text,
                  'section': sectionController.text,
                  'parentName': parentNameController.text,
                  'contact': contactController.text,
                  'address': addressController.text,
                });
                _filteredStudents = List.from(_students);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Student added successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showStudentDetails(Map<String, dynamic> student) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(student['name']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const Icon(Icons.numbers),
              title: Text('Roll No: ${student['rollNo']}'),
            ),
            ListTile(
              leading: const Icon(Icons.class_),
              title: Text('Class: ${student['class']}'),
            ),
            ListTile(
              leading: const Icon(Icons.category),
              title: Text('Section: ${student['section']}'),
            ),
            ListTile(
              leading: const Icon(Icons.family_restroom),
              title: Text('Parent: ${student['parentName']}'),
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: Text('Contact: ${student['contact']}'),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: Text('Address: ${student['address']}'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          if (widget.canAdd)
            ElevatedButton(
              onPressed: () {
                // Implement edit functionality
                Navigator.pop(context);
              },
              child: const Text('Edit'),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search students...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: _filterStudents,
            ),
          ),
          Expanded(
            child: _filteredStudents.isEmpty
                ? const Center(
              child: Text('No students found'),
            )
                : ListView.builder(
              itemCount: _filteredStudents.length,
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final student = _filteredStudents[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primary,
                      child: Text(
                        student['name'][0],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(student['name']),
                    subtitle: Text(
                        'Roll No: ${student['rollNo']} | Class: ${student['class']} ${student['section']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.info_outline),
                      onPressed: () => _showStudentDetails(student),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: widget.canAdd
          ? FloatingActionButton(
        onPressed: () => _showAddStudentDialog(context),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      )
          : null,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}