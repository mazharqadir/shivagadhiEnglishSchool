import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class ClassesTab extends StatefulWidget {
  final bool canAdd;

  const ClassesTab({
    super.key,
    required this.canAdd,
  });

  @override
  State<ClassesTab> createState() => _ClassesTabState();
}

class _ClassesTabState extends State<ClassesTab> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _classes = [];
  List<Map<String, dynamic>> _filteredClasses = [];

  @override
  void initState() {
    super.initState();
    _initializeClasses();
  }

  void _initializeClasses() {
    _classes = [
      {
        'name': 'Grade 10-A',
        'classTeacher': 'Dr. Arooba Khan',
        'totalStudents': 35,
        'roomNumber': 'OC105',
        'subjects': ['Mathematics', 'Science', 'English', 'Social Studies'],
        'schedule': 'Monday to Friday, 8:00 AM - 2:00 PM',
      },
      {
        'name': 'Grade 9-B',
        'classTeacher': 'Imran Ahmad',
        'totalStudents': 32,
        'roomNumber': 'M105',
        'subjects': ['Mathematics', 'Science', 'English', 'Computer'],
        'schedule': 'Monday to Friday, 8:00 AM - 2:00 PM',
      },
      {
        'name': 'Grade 8-A',
        'classTeacher': 'Dr. Ali',
        'totalStudents': 30,
        'roomNumber': 'M106',
        'subjects': ['Mathematics', 'Science', 'English', 'Computer'],
        'schedule': 'Monday to Friday, 8:00 AM - 2:00 PM',
      },
    ];
    _filteredClasses = List.from(_classes);
  }

  void _filterClasses(String query) {
    setState(() {
      _filteredClasses = _classes
          .where((classItem) =>
              classItem['name'].toLowerCase().contains(query.toLowerCase()) ||
              classItem['classTeacher']
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList();
    });
  }

  void _showAddClassDialog() {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final teacherController = TextEditingController();
    final roomController = TextEditingController();
    final scheduleController = TextEditingController();
    final subjectsController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Class'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Class Name',
                    icon: Icon(Icons.class_),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter class name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: teacherController,
                  decoration: const InputDecoration(
                    labelText: 'Class Teacher',
                    icon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter teacher name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: roomController,
                  decoration: const InputDecoration(
                    labelText: 'Room Number',
                    icon: Icon(Icons.room),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter room number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: scheduleController,
                  decoration: const InputDecoration(
                    labelText: 'Schedule',
                    icon: Icon(Icons.schedule),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter schedule';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: subjectsController,
                  decoration: const InputDecoration(
                    labelText: 'Subjects (comma separated)',
                    icon: Icon(Icons.book),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter subjects';
                    }
                    return null;
                  },
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                setState(() {
                  _classes.add({
                    'name': nameController.text,
                    'classTeacher': teacherController.text,
                    'totalStudents': 0,
                    'roomNumber': roomController.text,
                    'subjects': subjectsController.text
                        .split(',')
                        .map((e) => e.trim())
                        .where((e) => e.isNotEmpty)
                        .toList(),
                    'schedule': scheduleController.text,
                  });
                  _filteredClasses = List.from(_classes);
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Class added successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showClassDetails(Map<String, dynamic> classItem) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(classItem['name']),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: const Icon(Icons.person),
                title: Text('Teacher: ${classItem['classTeacher']}'),
              ),
              ListTile(
                leading: const Icon(Icons.people),
                title: Text('Students: ${classItem['totalStudents']}'),
              ),
              ListTile(
                leading: const Icon(Icons.room),
                title: Text('Room: ${classItem['roomNumber']}'),
              ),
              ListTile(
                leading: const Icon(Icons.schedule),
                title: Text('Schedule: ${classItem['schedule']}'),
              ),
              const ListTile(
                leading: Icon(Icons.book),
                title: Text('Subjects:'),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 72),
                child: Wrap(
                  spacing: 8,
                  children: (classItem['subjects'] as List).map((subject) => Chip(
                        label: Text(subject.toString()),
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                      )).toList(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          if (widget.canAdd)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showEditClassDialog(classItem);
              },
              child: const Text('Edit'),
            ),
        ],
      ),
    );
  }

  void _showEditClassDialog(Map<String, dynamic> classItem) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: classItem['name']);
    final teacherController =
        TextEditingController(text: classItem['classTeacher']);
    final roomController = TextEditingController(text: classItem['roomNumber']);
    final scheduleController = TextEditingController(text: classItem['schedule']);
    final subjectsController =
        TextEditingController(text: (classItem['subjects'] as List).join(', '));

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Class'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Class Name',
                    icon: Icon(Icons.class_),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter class name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: teacherController,
                  decoration: const InputDecoration(
                    labelText: 'Class Teacher',
                    icon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter teacher name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: roomController,
                  decoration: const InputDecoration(
                    labelText: 'Room Number',
                    icon: Icon(Icons.room),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter room number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: scheduleController,
                  decoration: const InputDecoration(
                    labelText: 'Schedule',
                    icon: Icon(Icons.schedule),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter schedule';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: subjectsController,
                  decoration: const InputDecoration(
                    labelText: 'Subjects (comma separated)',
                    icon: Icon(Icons.book),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter subjects';
                    }
                    return null;
                  },
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                setState(() {
                  final index = _classes.indexOf(classItem);
                  _classes[index] = {
                    'name': nameController.text,
                    'classTeacher': teacherController.text,
                    'totalStudents': classItem['totalStudents'],
                    'roomNumber': roomController.text,
                    'subjects': subjectsController.text
                        .split(',')
                        .map((e) => e.trim())
                        .where((e) => e.isNotEmpty)
                        .toList(),
                    'schedule': scheduleController.text,
                  };
                  _filteredClasses = List.from(_classes);
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Class updated successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text('Save'),
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
                hintText: 'Search classes...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: _filterClasses,
            ),
          ),
          Expanded(
            child: _filteredClasses.isEmpty
                ? const Center(
                    child: Text('No classes found'),
                  )
                : ListView.builder(
                    itemCount: _filteredClasses.length,
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      final classItem = _filteredClasses[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: ExpansionTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.primary,
                            child: Text(
                              classItem['name'].length > 6
                                  ? classItem['name'][6]
                                  : '?',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(classItem['name']),
                          subtitle:
                              Text('Teacher: ${classItem['classTeacher']}'),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        children: [
                                          const Icon(Icons.people),
                                          const SizedBox(height: 4),
                                          Text(
                                              '${classItem['totalStudents']} Students'),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          const Icon(Icons.room),
                                          const SizedBox(height: 4),
                                          Text('Room ${classItem['roomNumber']}'),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          const Icon(Icons.book),
                                          const SizedBox(height: 4),
                                          Text(
                                              '${(classItem['subjects'] as List).length} Subjects'),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton.icon(
                                        onPressed: () =>
                                            _showClassDetails(classItem),
                                        icon: const Icon(Icons.info_outline),
                                        label: const Text('Details'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primary,
                                        ),
                                      ),
                                      if (widget.canAdd)
                                        ElevatedButton.icon(
                                          onPressed: () =>
                                              _showEditClassDialog(classItem),
                                          icon: const Icon(Icons.edit),
                                          label: const Text('Edit'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.primary,
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: widget.canAdd
          ? FloatingActionButton(
              onPressed: _showAddClassDialog,
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