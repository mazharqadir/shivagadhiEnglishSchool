import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class TeachersTab extends StatefulWidget {
  final bool canAdd;

  const TeachersTab({
    super.key,
    required this.canAdd,
  });

  @override
  State<TeachersTab> createState() => _TeachersTabState();
}

class _TeachersTabState extends State<TeachersTab> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _teachers = [];
  List<Map<String, dynamic>> _filteredTeachers = [];

  @override
  void initState() {
    super.initState();
    // Dummy data - Replace with your actual data source
    _teachers = [
      {
        'name': 'Dr. Arooba Khan',
        'id': 'T001',
        'subject': 'Mathematics',
        'qualification': 'Ph.D. Mathematics',
        'contact': '+61-1234567890',
        'email': 'sarah.j@sivagadhi.edu.au',
        'address': 'Sydney, Australia',
      },
      {
        'name': 'Prof. Ali',
        'id': 'T002',
        'subject': 'Science',
        'qualification': 'M.Sc. Physics',
        'contact': '+977-9876543211',
        'email': 'michael.b@shivagadhi.edu.au',
        'address': 'Sydney, Australia',
      },
      // Add more dummy data as needed
    ];
    _filteredTeachers = List.from(_teachers);
  }

  void _filterTeachers(String query) {
    setState(() {
      _filteredTeachers = _teachers
          .where((teacher) =>
      teacher['name'].toLowerCase().contains(query.toLowerCase()) ||
          teacher['subject'].toLowerCase().contains(query.toLowerCase()) ||
          teacher['id'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _showAddTeacherDialog(BuildContext context) {
    final nameController = TextEditingController();
    final idController = TextEditingController();
    final subjectController = TextEditingController();
    final qualificationController = TextEditingController();
    final contactController = TextEditingController();
    final emailController = TextEditingController();
    final addressController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Teacher'),
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
                controller: idController,
                decoration: const InputDecoration(
                  labelText: 'Teacher ID',
                  icon: Icon(Icons.badge),
                ),
              ),
              TextField(
                controller: subjectController,
                decoration: const InputDecoration(
                  labelText: 'Subject',
                  icon: Icon(Icons.book),
                ),
              ),
              TextField(
                controller: qualificationController,
                decoration: const InputDecoration(
                  labelText: 'Qualification',
                  icon: Icon(Icons.school),
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
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  icon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
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
              // Add new teacher to the list
              setState(() {
                _teachers.add({
                  'name': nameController.text,
                  'id': idController.text,
                  'subject': subjectController.text,
                  'qualification': qualificationController.text,
                  'contact': contactController.text,
                  'email': emailController.text,
                  'address': addressController.text,
                });
                _filteredTeachers = List.from(_teachers);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Teacher added successfully'),
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

  void _showTeacherDetails(Map<String, dynamic> teacher) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(teacher['name']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const Icon(Icons.badge),
              title: Text('ID: ${teacher['id']}'),
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: Text('Subject: ${teacher['subject']}'),
            ),
            ListTile(
              leading: const Icon(Icons.school),
              title: Text('Qualification: ${teacher['qualification']}'),
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: Text('Contact: ${teacher['contact']}'),
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: Text('Email: ${teacher['email']}'),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: Text('Address: ${teacher['address']}'),
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
                hintText: 'Search teachers...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: _filterTeachers,
            ),
          ),
          Expanded(
            child: _filteredTeachers.isEmpty
                ? const Center(
              child: Text('No teachers found'),
            )
                : ListView.builder(
              itemCount: _filteredTeachers.length,
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final teacher = _filteredTeachers[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primary,
                      child: Text(
                        teacher['name'][0],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(teacher['name']),
                    subtitle: Text(
                        '${teacher['subject']} | ID: ${teacher['id']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.info_outline),
                      onPressed: () => _showTeacherDetails(teacher),
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
        onPressed: () => _showAddTeacherDialog(context),
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