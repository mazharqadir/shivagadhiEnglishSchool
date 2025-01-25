// lib/models/fee.dart

enum FeeStatus {
  pending,
  paid,
  overdue,
  partiallyPaid,
  cancelled,
  refunded
}

enum PaymentMethod {
  cash,
  creditCard,
  debitCard,
  bankTransfer,
  onlineBanking,
  cheque, onlinePayment
}

class FeePayment {
  final String id;
  final double amount;
  final DateTime date;
  final PaymentMethod method;
  final String receivedBy;
  final String? transactionId;
  final String? remarks;

  FeePayment({
    required this.id,
    required this.amount,
    required this.date,
    required this.method,
    required this.receivedBy,
    this.transactionId,
    this.remarks,
  });

  // Convert from JSON
  factory FeePayment.fromJson(Map<String, dynamic> json) {
    return FeePayment(
      id: json['id'],
      amount: json['amount'].toDouble(),
      date: DateTime.parse(json['date']),
      method: PaymentMethod.values.firstWhere(
              (e) => e.toString() == 'PaymentMethod.${json['method']}'
      ),
      receivedBy: json['receivedBy'],
      transactionId: json['transactionId'],
      remarks: json['remarks'],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'date': date.toIso8601String(),
      'method': method.toString().split('.').last,
      'receivedBy': receivedBy,
      'transactionId': transactionId,
      'remarks': remarks,
    };
  }
}

class Fee {
  final String id;
  final String studentId;
  final String feeType;
  final double amount;
  final DateTime dueDate;
  final DateTime generatedDate;
  FeeStatus status;
  double paidAmount;
  final double? lateFee;
  final List<FeePayment> payments;
  final String? description;
  final String generatedBy;
  final bool isRecurring;
  final String? academicYear;
  final String? semester;

  Fee({
    required this.id,
    required this.studentId,
    required this.feeType,
    required this.amount,
    required this.dueDate,
    required this.generatedDate,
    required this.status,
    this.paidAmount = 0.0,
    this.lateFee,
    List<FeePayment>? payments,
    this.description,
    required this.generatedBy,
    this.isRecurring = false,
    this.academicYear,
    this.semester,
  }) : payments = payments ?? [];

  // Getters for fee status
  bool get isPaid => status == FeeStatus.paid || paidAmount >= totalAmount;
  bool get isPending => status == FeeStatus.pending;
  bool get isOverdue => !isPaid && DateTime.now().isAfter(dueDate);
  bool get isPartiallyPaid => paidAmount > 0 && paidAmount < totalAmount;

  // Getters for amounts
  double get remainingAmount => totalAmount - paidAmount;
  double get totalAmount => amount + (lateFee ?? 0);
  bool get hasLateFee => lateFee != null && lateFee! > 0;

  // Update fee status based on payments
  void updateStatus() {
    if (paidAmount >= totalAmount) {
      status = FeeStatus.paid;
    } else if (paidAmount > 0) {
      status = FeeStatus.partiallyPaid;
    } else if (DateTime.now().isAfter(dueDate)) {
      status = FeeStatus.overdue;
    } else {
      status = FeeStatus.pending;
    }
  }

  // Add a payment
  void addPayment(FeePayment payment) {
    payments.add(payment);
    paidAmount += payment.amount;
    updateStatus();
  }

  // Factory constructor from JSON
  factory Fee.fromJson(Map<String, dynamic> json) {
    return Fee(
      id: json['id'],
      studentId: json['studentId'],
      feeType: json['feeType'],
      amount: json['amount'].toDouble(),
      dueDate: DateTime.parse(json['dueDate']),
      generatedDate: DateTime.parse(json['generatedDate']),
      status: FeeStatus.values.firstWhere(
              (e) => e.toString() == 'FeeStatus.${json['status']}'
      ),
      paidAmount: json['paidAmount'].toDouble(),
      lateFee: json['lateFee']?.toDouble(),
      payments: (json['payments'] as List?)
          ?.map((payment) => FeePayment.fromJson(payment))
          .toList() ?? [],
      description: json['description'],
      generatedBy: json['generatedBy'],
      isRecurring: json['isRecurring'] ?? false,
      academicYear: json['academicYear'],
      semester: json['semester'],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'feeType': feeType,
      'amount': amount,
      'dueDate': dueDate.toIso8601String(),
      'generatedDate': generatedDate.toIso8601String(),
      'status': status.toString().split('.').last,
      'paidAmount': paidAmount,
      'lateFee': lateFee,
      'payments': payments.map((payment) => payment.toJson()).toList(),
      'description': description,
      'generatedBy': generatedBy,
      'isRecurring': isRecurring,
      'academicYear': academicYear,
      'semester': semester,
    };
  }

  // Create a copy with updated fields
  Fee copyWith({
    String? id,
    String? studentId,
    String? feeType,
    double? amount,
    DateTime? dueDate,
    DateTime? generatedDate,
    FeeStatus? status,
    double? paidAmount,
    double? lateFee,
    List<FeePayment>? payments,
    String? description,
    String? generatedBy,
    bool? isRecurring,
    String? academicYear,
    String? semester,
  }) {
    return Fee(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      feeType: feeType ?? this.feeType,
      amount: amount ?? this.amount,
      dueDate: dueDate ?? this.dueDate,
      generatedDate: generatedDate ?? this.generatedDate,
      status: status ?? this.status,
      paidAmount: paidAmount ?? this.paidAmount,
      lateFee: lateFee ?? this.lateFee,
      payments: payments ?? List.from(this.payments),
      description: description ?? this.description,
      generatedBy: generatedBy ?? this.generatedBy,
      isRecurring: isRecurring ?? this.isRecurring,
      academicYear: academicYear ?? this.academicYear,
      semester: semester ?? this.semester,
    );
  }
}