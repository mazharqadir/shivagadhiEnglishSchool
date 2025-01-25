// lib/models/grade.dart
class Grade {
  final String subjectName;
  final String examType;
  final double marks;
  final double totalMarks;
  final String grade;
  final DateTime date;

  Grade({
    required this.subjectName,
    required this.examType,
    required this.marks,
    required this.totalMarks,
    required this.grade,
    required this.date,
  });
}

// lib/models/attendance.dart
class Attendance {
  final DateTime date;
  final bool isPresent;
  final String? remarks;

  Attendance({
    required this.date,
    required this.isPresent,
    this.remarks,
  });
}

// lib/models/fee.dart
class Fee {
  final String feeType;
  final double amount;
  final DateTime dueDate;
  final bool isPaid;
  final DateTime? paidDate;
  final String? transactionId;

  Fee({
    required this.feeType,
    required this.amount,
    required this.dueDate,
    required this.isPaid,
    this.paidDate,
    this.transactionId,
  });
}