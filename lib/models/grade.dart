// lib/models/grade.dart

enum GradeStatus {
  draft,
  published,
  archived
}

class Grade {
  final String id;
  final String studentId;
  final String subjectId;
  final String teacherId;
  final String subjectName;
  final double marksObtained;
  final double totalMarks;
  final String? examType;
  final DateTime dateRecorded;
  final String? remarks;
  final GradeStatus status;
  final String? academicYear;
  final String? semester;

  Grade({
    required this.id,
    required this.studentId,
    required this.subjectId,
    required this.teacherId,
    required this.subjectName,
    required this.marksObtained,
    required this.totalMarks,
    this.examType,
    DateTime? dateRecorded,
    this.remarks,
    this.status = GradeStatus.draft,
    this.academicYear,
    this.semester,
  }) : dateRecorded = dateRecorded ?? DateTime.now();

  // Getters
  double get percentage => (marksObtained / totalMarks) * 100;
  String get grade {
    if (percentage >= 90) return 'A+';
    if (percentage >= 80) return 'A';
    if (percentage >= 70) return 'B';
    if (percentage >= 60) return 'C';
    if (percentage >= 50) return 'D';
    return 'F';
  }

  bool get isPassing => percentage >= 50;

  // Factory constructor from JSON
  factory Grade.fromJson(Map<String, dynamic> json) {
    return Grade(
      id: json['id'],
      studentId: json['studentId'],
      subjectId: json['subjectId'],
      teacherId: json['teacherId'],
      subjectName: json['subjectName'],
      marksObtained: json['marksObtained'].toDouble(),
      totalMarks: json['totalMarks'].toDouble(),
      examType: json['examType'],
      dateRecorded: json['dateRecorded'] != null
          ? DateTime.parse(json['dateRecorded'])
          : null,
      remarks: json['remarks'],
      status: GradeStatus.values.firstWhere(
            (e) => e.toString() == 'GradeStatus.${json['status']}',
        orElse: () => GradeStatus.draft,
      ),
      academicYear: json['academicYear'],
      semester: json['semester'],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'subjectId': subjectId,
      'teacherId': teacherId,
      'subjectName': subjectName,
      'marksObtained': marksObtained,
      'totalMarks': totalMarks,
      'examType': examType,
      'dateRecorded': dateRecorded.toIso8601String(),
      'remarks': remarks,
      'status': status.toString().split('.').last,
      'academicYear': academicYear,
      'semester': semester,
    };
  }

  // Create a copy with updated fields
  Grade copyWith({
    String? id,
    String? studentId,
    String? subjectId,
    String? teacherId,
    String? subjectName,
    double? marksObtained,
    double? totalMarks,
    String? examType,
    DateTime? dateRecorded,
    String? remarks,
    GradeStatus? status,
    String? academicYear,
    String? semester,
  }) {
    return Grade(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      subjectId: subjectId ?? this.subjectId,
      teacherId: teacherId ?? this.teacherId,
      subjectName: subjectName ?? this.subjectName,
      marksObtained: marksObtained ?? this.marksObtained,
      totalMarks: totalMarks ?? this.totalMarks,
      examType: examType ?? this.examType,
      dateRecorded: dateRecorded ?? this.dateRecorded,
      remarks: remarks ?? this.remarks,
      status: status ?? this.status,
      academicYear: academicYear ?? this.academicYear,
      semester: semester ?? this.semester,
    );
  }
}