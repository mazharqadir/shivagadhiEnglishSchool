// lib/screens/student/fee_view_screen.dart

import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../models/fee.dart';

class FeeViewScreen extends StatelessWidget {
  final User student;

  const FeeViewScreen({
    super.key,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFeeSummaryCard(),
          const SizedBox(height: 20),
          _buildFeeHistory(),
        ],
      ),
    );
  }

  Widget _buildFeeSummaryCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Fee Summary',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildSummaryRow('Total Fee', 'Rs. 50,000'),
            _buildSummaryRow('Paid Amount', 'Rs. 30,000'),
            _buildSummaryRow('Due Amount', 'Rs. 20,000'),
            const Divider(height: 24),
            _buildDueDateInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDueDateInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today,
            color: Colors.red.shade700,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            'Next Due Date: ${_formatDate(DateTime.now().add(const Duration(days: 7)))}',
            style: TextStyle(
              color: Colors.red.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeeHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment History',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 5, // Replace with actual payment history
          itemBuilder: (context, index) {
            return _buildPaymentHistoryCard(
              date: DateTime.now().subtract(Duration(days: index * 30)),
              amount: 10000,
              status: index == 0 ? FeeStatus.paid : FeeStatus.pending,
              paymentMethod: PaymentMethod.cash,
            );
          },
        ),
      ],
    );
  }

  Widget _buildPaymentHistoryCard({
    required DateTime date,
    required double amount,
    required FeeStatus status,
    required PaymentMethod paymentMethod,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Rs. ${amount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            _buildStatusChip(status),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              'Date: ${_formatDate(date)}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              'Payment Method: ${_formatPaymentMethod(paymentMethod)}',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(FeeStatus status) {
    Color chipColor;
    String label;

    switch (status) {
      case FeeStatus.paid:
        chipColor = Colors.green;
        label = 'Paid';
        break;
      case FeeStatus.pending:
        chipColor = Colors.orange;
        label = 'Pending';
        break;
      case FeeStatus.overdue:
        chipColor = Colors.red;
        label = 'Overdue';
        break;
      case FeeStatus.partiallyPaid:
        // TODO: Handle this case.
        throw UnimplementedError();
      case FeeStatus.cancelled:
        // TODO: Handle this case.
        throw UnimplementedError();
      case FeeStatus.refunded:
        // TODO: Handle this case.
        throw UnimplementedError();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: chipColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatPaymentMethod(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cash:
        return 'Cash';
      case PaymentMethod.bankTransfer:
        return 'Bank Transfer';
      case PaymentMethod.onlinePayment:
        return 'Online Payment';
      case PaymentMethod.creditCard:
        // TODO: Handle this case.
        throw UnimplementedError();
      case PaymentMethod.debitCard:
        // TODO: Handle this case.
        throw UnimplementedError();
      case PaymentMethod.onlineBanking:
        // TODO: Handle this case.
        throw UnimplementedError();
      case PaymentMethod.cheque:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }
}
