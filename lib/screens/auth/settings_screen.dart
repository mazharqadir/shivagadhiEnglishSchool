// settings_screen.dart

import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../models/user.dart';
import '../../models/user_role.dart';

class SettingsScreen extends StatefulWidget {
  final User user;

  const SettingsScreen({
    super.key,
    required this.user,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkMode = false;
  String _selectedLanguage = 'English';
  final List<String> _languages = ['English', 'Spanish', 'French', 'German'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          _buildProfileSection(),
          const Divider(),
          _buildGeneralSettings(),
          const Divider(),
          _buildNotificationSettings(),
          const Divider(),
          if (widget.user.role == UserRole.admin) ...[
            _buildAdminSettings(),
            const Divider(),
          ],
          _buildAboutSection(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: AppColors.primary,
        child: Icon(Icons.person, color: Colors.white),
      ),
      title: Text(widget.user.name),
      subtitle: Text(widget.user.role.toString().split('.').last.toUpperCase()),
      trailing: TextButton(
        onPressed: () {
          // Implement edit profile functionality
          _showEditProfileDialog();
        },
        child: const Text('Edit Profile'),
      ),
    );
  }

  Widget _buildGeneralSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'General',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SwitchListTile(
          title: const Text('Dark Mode'),
          subtitle: const Text('Enable dark theme'),
          value: _darkMode,
          onChanged: (bool value) {
            setState(() {
              _darkMode = value;
              // Implement dark mode functionality
            });
          },
        ),
        ListTile(
          title: const Text('Language'),
          subtitle: Text(_selectedLanguage),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => _showLanguageDialog(),
        ),
        ListTile(
          title: const Text('Font Size'),
          subtitle: const Text('Medium'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // Implement font size adjustment
          },
        ),
      ],
    );
  }

  Widget _buildNotificationSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Notifications',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SwitchListTile(
          title: const Text('Push Notifications'),
          subtitle: const Text('Enable push notifications'),
          value: _notificationsEnabled,
          onChanged: (bool value) {
            setState(() {
              _notificationsEnabled = value;
            });
          },
        ),
        if (_notificationsEnabled) ...[
          CheckboxListTile(
            title: const Text('Announcements'),
            value: true,
            onChanged: (bool? value) {
              // Implement announcement notifications
            },
          ),
          CheckboxListTile(
            title: const Text('Updates'),
            value: true,
            onChanged: (bool? value) {
              // Implement update notifications
            },
          ),
          if (widget.user.role == UserRole.student) ...[
            CheckboxListTile(
              title: const Text('Grades'),
              value: true,
              onChanged: (bool? value) {
                // Implement grade notifications
              },
            ),
            CheckboxListTile(
              title: const Text('Attendance'),
              value: true,
              onChanged: (bool? value) {
                // Implement attendance notifications
              },
            ),
          ],
        ],
      ],
    );
  }

  Widget _buildAdminSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Admin Settings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.security),
          title: const Text('Security Settings'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // Implement security settings
          },
        ),
        ListTile(
          leading: const Icon(Icons.backup),
          title: const Text('Backup Data'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // Implement backup functionality
          },
        ),
        ListTile(
          leading: const Icon(Icons.people),
          title: const Text('User Management'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // Implement user management
          },
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'About',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.info),
          title: const Text('About App'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            _showAboutDialog();
          },
        ),
        ListTile(
          leading: const Icon(Icons.help),
          title: const Text('Help & Support'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // Implement help & support
          },
        ),
        ListTile(
          leading: const Icon(Icons.privacy_tip),
          title: const Text('Privacy Policy'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // Show privacy policy
          },
        ),
      ],
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Language'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _languages.length,
              itemBuilder: (BuildContext context, int index) {
                return RadioListTile<String>(
                  title: Text(_languages[index]),
                  value: _languages[index],
                  groupValue: _selectedLanguage,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedLanguage = value!;
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showEditProfileDialog() {
    final TextEditingController nameController =
    TextEditingController(text: widget.user.name);
    final TextEditingController emailController =
    TextEditingController(text: widget.user.email);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    icon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    icon: Icon(Icons.email),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Implement profile update logic
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('About School Management'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Version: 1.0.0'),
              SizedBox(height: 8),
              Text('Developed by: Your Company Name'),
              SizedBox(height: 8),
              Text(
                'A comprehensive school management system designed to streamline educational operations.',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}