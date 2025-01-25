// lib/models/user.dart

import 'user_role.dart';

class User {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? profileImage;
  final String? phoneNumber;
  final String? address;
  final String? className; // For students
  final String? subjects; // For teachers
  final DateTime? dateJoined;
  final bool isActive;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.profileImage,
    this.phoneNumber,
    this.address,
    this.className,
    this.subjects,
    this.dateJoined,
    this.isActive = true,
  });

  // Factory constructor to create a User from JSON data
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: UserRole.values.firstWhere(
            (role) => role.toString() == 'UserRole.${json['role']}',
      ),
      profileImage: json['profileImage'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      className: json['className'],
      subjects: json['subjects'],
      dateJoined: json['dateJoined'] != null
          ? DateTime.parse(json['dateJoined'])
          : null,
      isActive: json['isActive'] ?? true,
    );
  }

  // Convert User object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role.toString().split('.').last,
      'profileImage': profileImage,
      'phoneNumber': phoneNumber,
      'address': address,
      'className': className,
      'subjects': subjects,
      'dateJoined': dateJoined?.toIso8601String(),
      'isActive': isActive,
    };
  }

  // Create a copy of User with updated fields
  User copyWith({
    String? id,
    String? name,
    String? email,
    UserRole? role,
    String? profileImage,
    String? phoneNumber,
    String? address,
    String? className,
    String? subjects,
    DateTime? dateJoined,
    bool? isActive,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      profileImage: profileImage ?? this.profileImage,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      className: className ?? this.className,
      subjects: subjects ?? this.subjects,
      dateJoined: dateJoined ?? this.dateJoined,
      isActive: isActive ?? this.isActive,
    );
  }
}