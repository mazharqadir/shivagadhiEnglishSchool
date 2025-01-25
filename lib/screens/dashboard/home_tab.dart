import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../models/user.dart';
import '../../models/user_role.dart';

class HomeTab extends StatelessWidget {
  final User user;

  const HomeTab({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Card
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome, ${user.name}!',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getRoleSpecificWelcomeMessage(),
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Role-specific dashboard content
          _buildRoleSpecificContent(),
        ],
      ),
    );
  }

  String _getRoleSpecificWelcomeMessage() {
    switch (user.role) {
      case UserRole.admin:
        return 'Manage your school\'s operations efficiently';
      case UserRole.teacher:
        return 'Track your classes and students\' progress';
      case UserRole.student:
        return 'Stay updated with your academic journey';
      default:
        return '';
    }
  }

  Widget _buildRoleSpecificContent() {
    switch (user.role) {
      case UserRole.admin:
        return _buildAdminDashboard();
      case UserRole.teacher:
        return _buildTeacherDashboard();
      case UserRole.student:
        return _buildStudentDashboard();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildAdminDashboard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Quick Stats
        Row(
          children: [
            _buildStatCard(
              'Total Students',
              '520',
              Icons.people,
              Colors.blue,
            ),
            const SizedBox(width: 16),
            _buildStatCard(
              'Total Teachers',
              '45',
              Icons.school,
              Colors.green,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildStatCard(
              'Total Classes',
              '24',
              Icons.class_,
              Colors.orange,
            ),
            const SizedBox(width: 16),
            _buildStatCard(
              'Attendance Today',
              '95%',
              Icons.check_circle,
              Colors.purple,
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Recent Activities
        const Text(
          'Recent Activities',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildRecentActivityList(),
      ],
    );
  }

  Widget _buildTeacherDashboard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Teacher's Classes
        Row(
          children: [
            _buildStatCard(
              'My Classes',
              '5',
              Icons.class_,
              Colors.blue,
            ),
            const SizedBox(width: 16),
            _buildStatCard(
              'Total Students',
              '180',
              Icons.people,
              Colors.green,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildStatCard(
              'Today\'s Classes',
              '4',
              Icons.schedule,
              Colors.orange,
            ),
            const SizedBox(width: 16),
            _buildStatCard(
              'Assignments',
              '8',
              Icons.assignment,
              Colors.purple,
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Today's Schedule
        const Text(
          'Today\'s Schedule',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildTeacherSchedule(),
      ],
    );
  }

  Widget _buildStudentDashboard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Student's Quick Info
        Row(
          children: [
            _buildStatCard(
              'Attendance',
              '95%',
              Icons.check_circle,
              Colors.blue,
            ),
            const SizedBox(width: 16),
            _buildStatCard(
              'Assignments',
              '5',
              Icons.assignment,
              Colors.orange,
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Today's Classes
        const Text(
          'Today\'s Classes',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildStudentSchedule(),

        const SizedBox(height: 24),

        // Upcoming Assignments
        const Text(
          'Upcoming Assignments',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildUpcomingAssignments(),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivityList() {
    return Card(
      elevation: 2,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const CircleAvatar(
              backgroundColor: AppColors.primary,
              child: Icon(Icons.notifications, color: Colors.white),
            ),
            title: Text('Activity ${index + 1}'),
            subtitle: Text('Description of activity ${index + 1}'),
            trailing: Text('${index + 1}h ago'),
          );
        },
      ),
    );
  }

  Widget _buildTeacherSchedule() {
    return Card(
      elevation: 2,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 4,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: Text('${index + 1}'),
            ),
            title: Text('Class ${index + 1}'),
            subtitle: Text('Grade ${10 - index}A'),
            trailing: Text('${8 + index}:00 AM'),
          );
        },
      ),
    );
  }

  Widget _buildStudentSchedule() {
    return Card(
      elevation: 2,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 4,
        itemBuilder: (context, index) {
          final subjects = ['Mathematics', 'Science', 'English', 'Social Studies'];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: Text('${index + 1}'),
            ),
            title: Text(subjects[index]),
            subtitle: Text('Room ${101 + index}'),
            trailing: Text('${8 + index}:00 AM'),
          );
        },
      ),
    );
  }

  Widget _buildUpcomingAssignments() {
    return Card(
      elevation: 2,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const CircleAvatar(
              backgroundColor: AppColors.primary,
              child: Icon(Icons.assignment, color: Colors.white),
            ),
            title: Text('Assignment ${index + 1}'),
            subtitle: Text('Due in ${index + 1} days'),
            trailing: const Icon(Icons.chevron_right),
          );
        },
      ),
    );
  }
}