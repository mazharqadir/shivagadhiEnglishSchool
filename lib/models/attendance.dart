// lib/models/attendance.dart

enum AttendanceStatus {
  present,
  absent,
  late,
  excused,
  halfDay, leave
}

class Attendance {
  final String id;
  final String studentId;
  final String markedById;
  final DateTime date;
  final DateTime markedAt;
  final AttendanceStatus status;
  final String? remarks;
  final String? subjectId;
  final String? subjectName;
  final String? classId;
  final String? className;
  final String? sessionId;
  final bool isVerified;

  Attendance({
    required this.id,
    required this.studentId,
    required this.markedById,
    required this.date,
    required this.markedAt,
    required this.status,
    this.remarks,
    this.subjectId,
    this.subjectName,
    this.classId,
    this.className,
    this.sessionId,
    this.isVerified = false,
  });

  // Getters
  bool get isPresent => status == AttendanceStatus.present;
  bool get isAbsent => status == AttendanceStatus.absent;
  bool get isLate => status == AttendanceStatus.late;
  bool get isExcused => status == AttendanceStatus.excused;
  bool get isHalfDay => status == AttendanceStatus.halfDay;

  // Factory constructor from JSON
  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'],
      studentId: json['studentId'],
      markedById: json['markedById'],
      date: DateTime.parse(json['date']),
      markedAt: DateTime.parse(json['markedAt']),
      status: AttendanceStatus.values.firstWhere(
            (e) => e.toString() == 'AttendanceStatus.${json['status']}',
      ),
      remarks: json['remarks'],
      subjectId: json['subjectId'],
      subjectName: json['subjectName'],
      classId: json['classId'],
      className: json['className'],
      sessionId: json['sessionId'],
      isVerified: json['isVerified'] ?? false,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'markedById': markedById,
      'date': date.toIso8601String(),
      'markedAt': markedAt.toIso8601String(),
      'status': status.toString().split('.').last,
      'remarks': remarks,
      'subjectId': subjectId,
      'subjectName': subjectName,
      'classId': classId,
      'className': className,
      'sessionId': sessionId,
      'isVerified': isVerified,
    };
  }

  // Create a copy with updated fields
  Attendance copyWith({
    String? id,
    String? studentId,
    String? markedById,
    DateTime? date,
    DateTime? markedAt,
    AttendanceStatus? status,
    String? remarks,
    String? subjectId,
    String? subjectName,
    String? classId,
    String? className,
    String? sessionId,
    bool? isVerified,
  }) {
    return Attendance(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      markedById: markedById ?? this.markedById,
      date: date ?? this.date,
      markedAt: markedAt ?? this.markedAt,
      status: status ?? this.status,
      remarks: remarks ?? this.remarks,
      subjectId: subjectId ?? this.subjectId,
      subjectName: subjectName ?? this.subjectName,
      classId: classId ?? this.classId,
      className: className ?? this.className,
      sessionId: sessionId ?? this.sessionId,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}