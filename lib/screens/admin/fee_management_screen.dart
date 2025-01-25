// lib/screens/admin/fee_management_screen.dart
import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../models/fee.dart';
import 'package:intl/intl.dart';

class FeeManagementScreen extends StatefulWidget {
  const FeeManagementScreen({super.key});

  @override
  State<FeeManagementScreen> createState() => _FeeManagementScreenState();
}

class _FeeManagementScreenState extends State<FeeManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Fee> _fees = [
    Fee(
      id: '1', // Added required field
      studentId: 'STD001', // Added required field
      feeType: 'Tuition Fee',
      amount: 5000,
      dueDate: DateTime.now().add(const Duration(days: 7)),
      generatedDate: DateTime.now(), // Added required field
      status: FeeStatus.pending, // Added required field
      generatedBy: 'ADMIN001', // Added required field
    ),
    Fee(
      id: '2',
      studentId: 'STD002',
      feeType: 'Library Fee',
      amount: 1000,
      dueDate: DateTime.now().add(const Duration(days: 14)),
      generatedDate: DateTime.now(),
      status: FeeStatus.pending,
      generatedBy: 'ADMIN001',
    ),
    // Add more sample fees if needed
  ];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fee Management'),
        backgroundColor: AppColors.primary,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Fee Structure'),
            Tab(text: 'Payments'),
            Tab(text: 'Reports'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFeeStructureTab(),
          _buildPaymentsTab(),
          _buildReportsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddFeeDialog,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _deleteFee(Fee fee) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Fee'),
        content: Text('Are you sure you want to delete ${fee.feeType}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _fees.removeWhere((f) => f.id == fee.id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fee deleted successfully')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildFeeList() {
    return ListView.builder(
      itemCount: _fees.length,
      itemBuilder: (context, index) {
        final fee = _fees[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text(fee.feeType),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Amount: \${fee.amount.toStringAsFixed(2)}'),
                Text(
                    'Due Date: ${DateFormat('dd/MM/yyyy').format(fee.dueDate)}'),
                Text('Status: ${fee.status.toString().split('.').last}'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!fee.isPaid) // Now using the isPaid getter
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _editFee(fee),
                  ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteFee(fee),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPaymentsList() {
    return ListView.builder(
      itemCount: _fees.where((fee) => fee.isPaid).length,
      itemBuilder: (context, index) {
        final fee = _fees.where((fee) => fee.isPaid).toList()[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text('Payment #${1000 + index}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Fee Type: ${fee.feeType}'),
                Text('Amount: \${fee.amount.toStringAsFixed(2)}'),
                Text(
                    'Date: ${DateFormat('dd/MM/yyyy').format(fee.generatedDate)}'),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.visibility),
              onPressed: () => _showPaymentDetails(index),
            ),
          ),
        );
      },
    );
  }

  Widget _buildReportsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildReportCard(
            'Total Collections',
            '\${_calculateTotalCollections().toStringAsFixed(2)}',
            Icons.attach_money,
            Colors.green,
          ),
          _buildReportCard(
            'Pending Payments',
            '\${_calculatePendingPayments().toStringAsFixed(2)}',
            Icons.warning,
            Colors.orange,
          ),
          _buildReportCard(
            'Total Students',
            _calculateTotalStudents().toString(),
            Icons.people,
            Colors.blue,
          ),
          const SizedBox(height: 24),
          _buildReportActions(),
        ],
      ),
    );
  }

  double _calculateTotalCollections() {
    return _fees
        .where((fee) => fee.isPaid)
        .fold(0, (sum, fee) => sum + fee.amount);
  }

  double _calculatePendingPayments() {
    return _fees
        .where((fee) => !fee.isPaid)
        .fold(0, (sum, fee) => sum + fee.amount);
  }

  int _calculateTotalStudents() {
    return _fees.map((fee) => fee.studentId).toSet().length;
  }

  Widget _buildFeeStructureTab() {
    return ListView.builder(
      itemCount: _fees.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final fee = _fees[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ExpansionTile(
            title: Text(fee.feeType),
            subtitle: Text('\${fee.amount}'),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildFeeDetail('Due Date',
                        '${fee.dueDate.day}/${fee.dueDate.month}/${fee.dueDate.year}'),
                    _buildFeeDetail('Late Fee', '50'),
                    _buildFeeDetail(
                        'Status', fee.isPaid ? 'Active' : 'Inactive'),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _editFee(fee),
                          icon: const Icon(Icons.edit),
                          label: const Text('Edit'),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _deleteFee(fee),
                          icon: const Icon(Icons.delete),
                          label: const Text('Delete'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
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
    );
  }

  Widget _buildPaymentsTab() {
    return Column(
      children: [
        _buildPaymentFilters(),
        Expanded(
          child: ListView.builder(
            itemCount: 10, // Sample payment records
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.receipt),
                  ),
                  title: Text('Payment #${1000 + index}'),
                  subtitle: Text('Student: John Doe - Class: 10A'),
                  trailing: const Text('\\500'),
                  onTap: () => _showPaymentDetails(index),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search payments...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterOptions,
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportActions() {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: _generateReport,
          icon: const Icon(Icons.download),
          label: const Text('Generate Report'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _exportToExcel,
          icon: const Icon(Icons.table_chart),
          label: const Text('Export to Excel'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
          ),
        ),
      ],
    );
  }

  Widget _buildFeeDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.grey),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void _showAddFeeDialog() {
    final formKey = GlobalKey<FormState>();
    String feeType = '';
    double amount = 0;
    DateTime dueDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Fee'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Fee Type',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
                onSaved: (value) => feeType = value ?? '',
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                  prefixText: '\$',
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
                onSaved: (value) => amount = double.tryParse(value ?? '0') ?? 0,
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: dueDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    dueDate = date;
                  }
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Due Date',
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    '${dueDate.day}/${dueDate.month}/${dueDate.year}',
                  ),
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
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                formKey.currentState?.save();
                // Create new fee with all required fields
                final newFee = Fee(
                  id: DateTime.now()
                      .millisecondsSinceEpoch
                      .toString(), // Generate unique ID
                  studentId: 'STD001', // This should come from selected student
                  feeType: feeType,
                  amount: amount,
                  dueDate: dueDate,
                  generatedDate: DateTime.now(),
                  status: FeeStatus.pending,
                  generatedBy:
                      'ADMIN001', // This should come from logged-in admin
                );
                setState(() {
                  _fees.add(newFee);
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fee added successfully')),
                );
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _editFee(Fee fee) {
    // Implement edit fee logic
    final formKey = GlobalKey<FormState>();
    String feeType = fee.feeType;
    double amount = fee.amount;
    DateTime dueDate = fee.dueDate;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Fee'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: feeType,
                decoration: const InputDecoration(
                  labelText: 'Fee Type',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
                onSaved: (value) => feeType = value ?? '',
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: amount.toString(),
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                  prefixText: '\$',
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
                onSaved: (value) => amount = double.tryParse(value ?? '0') ?? 0,
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: dueDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    dueDate = date;
                  }
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Due Date',
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    '${dueDate.day}/${dueDate.month}/${dueDate.year}',
                  ),
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
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                formKey.currentState?.save();
                // Create updated fee with all required fields
                final updatedFee = Fee(
                  id: fee.id,
                  studentId: fee.studentId,
                  feeType: feeType,
                  amount: amount,
                  dueDate: dueDate,
                  generatedDate: fee.generatedDate,
                  status: fee.status,
                  generatedBy: fee.generatedBy,
                  paidAmount: fee.paidAmount,
                );
                setState(() {
                  final index = _fees.indexWhere((f) => f.id == fee.id);
                  if (index != -1) {
                    _fees[index] = updatedFee;
                  }
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fee updated successfully')),
                );
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showPaymentDetails(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Payment #${1000 + index}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFeeDetail('Student', 'John Doe'),
            _buildFeeDetail('Class', '10A'),
            _buildFeeDetail('Amount', '\\500'),
            _buildFeeDetail('Date', '15/01/2024'),
            _buildFeeDetail('Payment Method', 'Credit Card'),
            _buildFeeDetail('Status', 'Completed'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              // Implement print receipt logic
            },
            child: const Text('Print Receipt'),
          ),
        ],
      ),
    );
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Filter Payments',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Add filter options here
          ],
        ),
      ),
    );
  }

  void _generateReport() {
    // Implement report generation logic
  }

  void _exportToExcel() {
    // Implement Excel export logic
  }
}
