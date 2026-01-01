import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

// Data Models
class Patient {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String insuranceProvider;
  final String insuranceNumber;

  Patient({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.insuranceProvider,
    required this.insuranceNumber,
  });
}

class BillableItem {
  final String id;
  final String name;
  final String category;
  final double basePrice;
  final String description;
  final bool isActive;

  BillableItem({
    required this.id,
    required this.name,
    required this.category,
    required this.basePrice,
    required this.description,
    this.isActive = true,
  });
}

class InvoiceItem {
  final BillableItem service;
  final int quantity;
  final double unitPrice;
  final double discount;

  InvoiceItem({
    required this.service,
    required this.quantity,
    required this.unitPrice,
    this.discount = 0.0,
  });

  double get total => (unitPrice * quantity) - discount;
}

class PaymentMethod {
  final String id;
  final String name;
  final double taxRate;
  final double processingFee;

  PaymentMethod({
    required this.id,
    required this.name,
    required this.taxRate,
    this.processingFee = 0.0,
  });
}

class Invoice {
  final String id;
  final String patientId;
  final DateTime date;
  final List<InvoiceItem> items;
  final PaymentMethod paymentMethod;
  final String status;
  final double discount;

  Invoice({
    required this.id,
    required this.patientId,
    required this.date,
    required this.items,
    required this.paymentMethod,
    required this.status,
    this.discount = 0.0,
  });

  double get subtotal => items.fold(0.0, (sum, item) => sum + item.total);
  double get tax => subtotal * paymentMethod.taxRate;
  double get total => subtotal + tax + paymentMethod.processingFee - discount;
}

class EnhancedBillingPaymentsScreen extends StatefulWidget {
  const EnhancedBillingPaymentsScreen({super.key});

  @override
  State<EnhancedBillingPaymentsScreen> createState() =>
      _EnhancedBillingPaymentsScreenState();
}

class _EnhancedBillingPaymentsScreenState
    extends State<EnhancedBillingPaymentsScreen> {
  final TextEditingController _patientSearchController =
      TextEditingController();
  final TextEditingController _serviceSearchController =
      TextEditingController();
  final TextEditingController _newServiceController = TextEditingController();
  final TextEditingController _newServicePriceController =
      TextEditingController();
  final TextEditingController _discountController = TextEditingController();

  Patient? selectedPatient;
  PaymentMethod selectedPaymentMethod = PaymentMethod(
    id: 'self_pay',
    name: 'Self Pay',
    taxRate: 0.085,
  );
  String paymeth = 'Transter';
  List<InvoiceItem> currentInvoiceItems = [];
  List<Patient> filteredPatients = [];
  List<BillableItem> filteredServices = [];

  String selectedStatus = 'All Status';
  DateTime selectedDate = DateTime.now();

  // Mock data
  final List<Patient> allPatients = [
    Patient(
      id: 'P001',
      name: 'John Smith',
      email: 'john.smith@email.com',
      phone: '(555) 123-4567',
      address: '123 Main St, City, State',
      insuranceProvider: 'Blue Cross',
      insuranceNumber: 'BC123456',
    ),
    Patient(
      id: 'P002',
      name: 'Mary Johnson',
      email: 'mary.johnson@email.com',
      phone: '(555) 987-6543',
      address: '456 Oak Ave, City, State',
      insuranceProvider: 'Aetna',
      insuranceNumber: 'AE789012',
    ),
    Patient(
      id: 'P003',
      name: 'David Wilson',
      email: 'david.wilson@email.com',
      phone: '(555) 456-7890',
      address: '789 Pine St, City, State',
      insuranceProvider: 'Self Pay',
      insuranceNumber: '',
    ),
  ];

  final List<BillableItem> allServices = [
    BillableItem(
      id: 'S001',
      name: 'General Consultation',
      category: 'Consultation',
      basePrice: 120.00,
      description: 'Standard doctor consultation',
    ),
    BillableItem(
      id: 'S002',
      name: 'Blood Test - Complete Panel',
      category: 'Laboratory',
      basePrice: 85.00,
      description: 'Comprehensive blood work analysis',
    ),
    BillableItem(
      id: 'S003',
      name: 'X-Ray - Chest',
      category: 'Radiology',
      basePrice: 150.00,
      description: 'Chest X-ray imaging',
    ),
    BillableItem(
      id: 'S004',
      name: 'ECG Test',
      category: 'Cardiology',
      basePrice: 75.00,
      description: 'Electrocardiogram test',
    ),
    BillableItem(
      id: 'S005',
      name: 'Prescription Fee',
      category: 'Pharmacy',
      basePrice: 25.00,
      description: 'Prescription processing fee',
    ),
  ];

  final List<PaymentMethod> paymentMethods = [
    PaymentMethod(id: 'self_pay', name: 'Self Pay', taxRate: 0.085),
    PaymentMethod(
      id: 'insurance',
      name: 'Insurance',
      taxRate: 0.05,
      processingFee: 5.00,
    ),
    PaymentMethod(id: 'medicare', name: 'Medicare', taxRate: 0.03),
    PaymentMethod(id: 'medicaid', name: 'Medicaid', taxRate: 0.02),
  ];

  @override
  void initState() {
    super.initState();
    filteredPatients = allPatients;
    filteredServices = allServices;
  }

  void _searchPatients(String query) {
    setState(() {
      filteredPatients =
          allPatients
              .where(
                (patient) =>
                    patient.name.toLowerCase().contains(query.toLowerCase()) ||
                    patient.id.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    });
  }

  void _searchServices(String query) {
    setState(() {
      filteredServices =
          allServices
              .where(
                (service) =>
                    service.name.toLowerCase().contains(query.toLowerCase()) ||
                    service.category.toLowerCase().contains(
                      query.toLowerCase(),
                    ),
              )
              .toList();
    });
  }

  void _addServiceToInvoice(BillableItem service) {
    setState(() {
      final existingIndex = currentInvoiceItems.indexWhere(
        (item) => item.service.id == service.id,
      );

      if (existingIndex >= 0) {
        currentInvoiceItems[existingIndex] = InvoiceItem(
          service: service,
          quantity: currentInvoiceItems[existingIndex].quantity + 1,
          unitPrice: service.basePrice,
        );
      } else {
        currentInvoiceItems.add(
          InvoiceItem(
            service: service,
            quantity: 1,
            unitPrice: service.basePrice,
          ),
        );
      }
    });
  }

  void _removeServiceFromInvoice(int index) {
    setState(() {
      currentInvoiceItems.removeAt(index);
    });
  }

  void _addNewService() {
    if (_newServiceController.text.isNotEmpty &&
        _newServicePriceController.text.isNotEmpty) {
      final newService = BillableItem(
        id: 'S${DateTime.now().millisecondsSinceEpoch}',
        name: _newServiceController.text,
        category: 'Custom',
        basePrice: double.tryParse(_newServicePriceController.text) ?? 0.0,
        description: 'Custom service added by accountant',
      );

      setState(() {
        allServices.add(newService);
        filteredServices = allServices;
      });

      _newServiceController.clear();
      _newServicePriceController.clear();
      Navigator.of(context).pop();
    }
  }

  void _generateInvoice() {
    if (selectedPatient != null && currentInvoiceItems.isNotEmpty) {
      final invoice = Invoice(
        id: 'INV-${DateTime.now().millisecondsSinceEpoch}',
        patientId: selectedPatient!.id,
        date: DateTime.now(),
        items: List.from(currentInvoiceItems),
        paymentMethod: selectedPaymentMethod,
        status: 'Generated',
        discount: double.tryParse(_discountController.text) ?? 0.0,
      );

      _showInvoiceDialog(invoice);
    }
  }

  void _showInvoiceDialog(Invoice invoice) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            child: Container(
              width: 500,
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Invoice Generated',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  Text('Invoice ID: ${invoice.id}'),
                  Text('Patient: ${selectedPatient!.name}'),
                  Text('Total: \$${invoice.total.toStringAsFixed(2)}'),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _showReceiptDialog(invoice);
                          },
                          child: Text('Generate Receipt'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            // Clear current invoice
                            setState(() {
                              currentInvoiceItems.clear();
                              selectedPatient = null;
                              _patientSearchController.clear();
                            });
                          },
                          child: Text('New Invoice'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }

  void _showReceiptDialog(Invoice invoice) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            child: Container(
              width: 600,
              height: 700,
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(
                    'PAYMENT RECEIPT',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Receipt ID: RCP-${invoice.id.substring(4)}'),
                          Text(
                            'Date: ${invoice.date.toString().substring(0, 10)}',
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Patient Information:',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text('Name: ${selectedPatient!.name}'),
                          Text('ID: ${selectedPatient!.id}'),
                          const SizedBox(height: 16),
                          Text(
                            'Services:',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          ...invoice.items.map(
                            (item) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${item.service.name} x${item.quantity}',
                                  ),
                                  Text('\$${item.total.toStringAsFixed(2)}'),
                                ],
                              ),
                            ),
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Subtotal:'),
                              Text('\$${invoice.subtotal.toStringAsFixed(2)}'),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Tax:'),
                              Text('\$${invoice.tax.toStringAsFixed(2)}'),
                            ],
                          ),
                          if (invoice.paymentMethod.processingFee > 0)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Processing Fee:'),
                                Text(
                                  '\$${invoice.paymentMethod.processingFee.toStringAsFixed(2)}',
                                ),
                              ],
                            ),
                          if (invoice.discount > 0)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Discount:'),
                                Text(
                                  '-\$${invoice.discount.toStringAsFixed(2)}',
                                ),
                              ],
                            ),
                          const Divider(thickness: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'TOTAL:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '\$${invoice.total.toStringAsFixed(2)}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Close'),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 32),
                _buildMetricsCards(),
                const SizedBox(height: 32),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: _buildNewBillingEntry()),
                    const SizedBox(width: 24),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          _buildQuickActions(),
                          const SizedBox(height: 24),
                          _buildTopBillableItems(),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                _buildPatientBillingHistory(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF6366F1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.receipt_long, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 12),
        const Text(
          'Billing & Payments',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
        const Spacer(),
        ElevatedButton.icon(
          onPressed: _showAddServiceDialog,
          icon: const Icon(Icons.add),
          label: const Text('Add Service'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6366F1),
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  void _showAddServiceDialog() {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            child: Container(
              width: 400,
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Add New Service',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _newServiceController,
                    decoration: InputDecoration(
                      labelText: 'Service Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _newServicePriceController,
                    decoration: InputDecoration(
                      labelText: 'Price (\$)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('Cancel'),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _addNewService,
                          child: Text('Add Service'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildMetricsCards() {
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            'Total Billed',
            '\$24,580',
            Colors.blue,
            Icons.attach_money,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildMetricCard(
            'Collected',
            '\$22,340',
            Colors.green,
            Icons.check_circle,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildMetricCard(
            'Pending',
            '\$2,240',
            Colors.red,
            Icons.schedule,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildMetricCard(
            'Avg Bill/Visit',
            '\$185',
            Colors.blue,
            Icons.trending_up,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    Color iconColor,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Icon(icon, color: iconColor, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F2937),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewBillingEntry() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'New Billing Entry',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 24),
          _buildPatientSearch(),
          const SizedBox(height: 24),
          _buildPaymentMethodSelection(),
          const SizedBox(height: 24),
          _buildServiceSelection(),
          const SizedBox(height: 24),
          _buildCurrentItems(),
          const SizedBox(height: 24),
          _buildBillingSummary(),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
                  selectedPatient != null && currentInvoiceItems.isNotEmpty
                      ? _generateInvoice
                      : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Generate Invoice',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientSearch() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Patient',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _patientSearchController,
          decoration: InputDecoration(
            hintText: 'Search patients by name or ID...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onChanged: _searchPatients,
        ),
        const SizedBox(height: 8),
        if (filteredPatients.isNotEmpty && selectedPatient == null)
          Container(
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView.builder(
              itemCount: filteredPatients.length,
              itemBuilder: (context, index) {
                final patient = filteredPatients[index];
                return ListTile(
                  title: Text(patient.name),
                  subtitle: Text('${patient.id} • ${patient.phone}'),
                  onTap: () {
                    setState(() {
                      selectedPatient = patient;
                      _patientSearchController.text = patient.name;
                    });
                  },
                );
              },
            ),
          ),
        if (selectedPatient != null)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selected Patient: ${selectedPatient!.name}',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Text('ID: ${selectedPatient!.id}'),
                Text('Insurance: ${selectedPatient!.insuranceProvider}'),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildPaymentMethodSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Method',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: paymeth,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          items:
              ['Transter','POS','CASH'].map((method) {
                return DropdownMenuItem<String>(
                  value: method,
                  child: Text(
                    method,
                  ),
                );
              }).toList(),
          onChanged: (newMethod) {
            if (newMethod != null) {
              setState(() {
                paymeth = newMethod;
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildServiceSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Add Services',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _serviceSearchController,
          decoration: InputDecoration(
            hintText: 'Search services...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onChanged: _searchServices,
        ),
        const SizedBox(height: 8),
        Container(
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListView.builder(
            itemCount: filteredServices.length,
            itemBuilder: (context, index) {
              final service = filteredServices[index];
              return ListTile(
                title: Text(service.name),
                subtitle: Text(
                  '${service.category} • \$${service.basePrice.toStringAsFixed(2)}',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _addServiceToInvoice(service),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentItems() {
    if (currentInvoiceItems.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          'No items added yet',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Current Items',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 12),
        ...currentInvoiceItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.service.name,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'Qty: ${item.quantity} × \$${item.unitPrice.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Text(
                  '\$${item.total.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.remove, color: Colors.red),
                  onPressed: () => _removeServiceFromInvoice(index),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildBillingSummary() {
    final subtotal = currentInvoiceItems.fold(
      0.0,
      (sum, item) => sum + item.total,
    );
    final tax = subtotal * selectedPaymentMethod.taxRate;
    final discount = double.tryParse(_discountController.text) ?? 0.0;
    final total =
        subtotal + tax + selectedPaymentMethod.processingFee - discount;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _buildSummaryRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: 8),
          _buildSummaryRow(
            'Tax (${(selectedPaymentMethod.taxRate * 100).toStringAsFixed(1)}%)',
            '\$${tax.toStringAsFixed(2)}',
          ),
          if (selectedPaymentMethod.processingFee > 0)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: _buildSummaryRow(
                'Processing Fee',
                '\${selectedPaymentMethod.processingFee.toStringAsFixed(2)}',
              ),
            ),
          const SizedBox(height: 8),
          TextField(
            controller: _discountController,
            decoration: InputDecoration(
              labelText: 'Discount (\$)',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) => setState(() {}),
          ),
          const Divider(height: 24),
          _buildSummaryRow(
            'Total',
            '\${total.toStringAsFixed(2)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            color: const Color(0xFF1F2937),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w600,
            color: const Color(0xFF1F2937),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 16),
          _buildQuickActionItem(Icons.print, 'Print Last Invoice', Colors.blue),
          const SizedBox(height: 12),
          _buildQuickActionItem(
            Icons.picture_as_pdf,
            'Download PDF',
            Colors.red,
          ),
          const SizedBox(height: 12),
          _buildQuickActionItem(Icons.email, 'Email Invoice', Colors.cyan),
          const SizedBox(height: 12),
          _buildQuickActionItem(Icons.receipt, 'View Receipts', Colors.green),
        ],
      ),
    );
  }

  Widget _buildQuickActionItem(IconData icon, String title, Color iconColor) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$title functionality')));
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1F2937),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBillableItems() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top Billable Items',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 12000,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const labels = [
                          'Consultation',
                          'Blood Test',
                          'X-Ray',
                          'Prescription',
                          'ECG',
                        ];
                        if (value.toInt() < labels.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              labels[value.toInt()],
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${(value / 1000).toInt()}k',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF6B7280),
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: const FlGridData(show: false),
                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barRods: [
                      BarChartRodData(
                        toY: 11000,
                        color: const Color(0xFF6366F1),
                        width: 20,
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 1,
                    barRods: [
                      BarChartRodData(
                        toY: 8500,
                        color: const Color(0xFF6366F1),
                        width: 20,
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 2,
                    barRods: [
                      BarChartRodData(
                        toY: 6200,
                        color: const Color(0xFF6366F1),
                        width: 20,
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 3,
                    barRods: [
                      BarChartRodData(
                        toY: 5100,
                        color: const Color(0xFF6366F1),
                        width: 20,
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 4,
                    barRods: [
                      BarChartRodData(
                        toY: 3400,
                        color: const Color(0xFF6366F1),
                        width: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientBillingHistory() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Patient Billing History',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
              const Spacer(),
              _buildStatusDropdown(),
              const SizedBox(width: 16),
              _buildDatePicker(),
            ],
          ),
          const SizedBox(height: 24),
          _buildHistoryTable(),
        ],
      ),
    );
  }

  Widget _buildStatusDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD1D5DB)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedStatus,
          items:
              ['All Status', 'Generated', 'Paid', 'Pending', 'Overdue'].map((
                String value,
              ) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: const TextStyle(fontSize: 14)),
                );
              }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedStatus = newValue!;
            });
          },
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
        );
        if (picked != null) {
          setState(() {
            selectedDate = picked;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFD1D5DB)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
              style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.calendar_today,
              size: 16,
              color: Color(0xFF6B7280),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryTable() {
    // Mock history data - in a real app, this would come from a database
    List<Map<String, dynamic>> historyData = [
      {
        'invoiceId': '#INV-2024-001',
        'patient': 'John Smith',
        'date': 'Jan 15, 2024',
        'amount': '\$222.43',
        'status': 'Paid',
        'type': 'Self-pay',
        'isPaid': true,
      },
      {
        'invoiceId': '#INV-2024-002',
        'patient': 'Mary Johnson',
        'date': 'Jan 14, 2024',
        'amount': '\$156.80',
        'status': 'Pending',
        'type': 'Insurance',
        'isPaid': false,
      },
      {
        'invoiceId': '#INV-2024-003',
        'patient': 'David Wilson',
        'date': 'Jan 13, 2024',
        'amount': '\$310.25',
        'status': 'Generated',
        'type': 'Medicare',
        'isPaid': false,
      },
    ];

    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1.5),
        1: FlexColumnWidth(1.5),
        2: FlexColumnWidth(1.2),
        3: FlexColumnWidth(1),
        4: FlexColumnWidth(1),
        5: FlexColumnWidth(1),
        6: FlexColumnWidth(1),
      },
      children: [
        _buildTableHeader(),
        ...historyData
            .map(
              (data) => _buildTableRow(
                data['invoiceId']!.toString(),
                data['patient']!,
                data['date']!,
                data['amount']!,
                data['status']!,
                data['type']!,
                data['isPaid'] as bool,
              ),
            )
            .toList(),
      ],
    );
  }

  TableRow _buildTableHeader() {
    return TableRow(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      children:
          [
                'INVOICE ID',
                'PATIENT',
                'DATE',
                'AMOUNT',
                'STATUS',
                'TYPE',
                'ACTIONS',
              ]
              .map(
                (header) => Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 8,
                  ),
                  child: Text(
                    header,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7280),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              )
              .toList(),
    );
  }

  TableRow _buildTableRow(
    String invoiceId,
    String patient,
    String date,
    String amount,
    String status,
    String type,
    bool isPaid,
  ) {
    Color statusColor;
    Color statusBgColor;

    switch (status.toLowerCase()) {
      case 'paid':
        statusColor = Colors.green[700]!;
        statusBgColor = Colors.green.withOpacity(0.1);
        break;
      case 'pending':
        statusColor = Colors.orange[700]!;
        statusBgColor = Colors.orange.withOpacity(0.1);
        break;
      case 'generated':
        statusColor = Colors.blue[700]!;
        statusBgColor = Colors.blue.withOpacity(0.1);
        break;
      default:
        statusColor = Colors.red[700]!;
        statusBgColor = Colors.red.withOpacity(0.1);
    }

    return TableRow(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Text(
            invoiceId,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Text(
            patient,
            style: const TextStyle(fontSize: 14, color: Color(0xFF1F2937)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Text(
            date,
            style: const TextStyle(fontSize: 14, color: Color(0xFF1F2937)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Text(
            amount,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusBgColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              type,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6366F1),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Viewing invoice $invoiceId')),
                  );
                },
                child: Icon(
                  Icons.visibility,
                  size: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Printing invoice $invoiceId')),
                  );
                },
                child: Icon(Icons.print, size: 16, color: Colors.grey[600]),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Downloading invoice $invoiceId')),
                  );
                },
                child: Icon(Icons.download, size: 16, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _patientSearchController.dispose();
    _serviceSearchController.dispose();
    _newServiceController.dispose();
    _newServicePriceController.dispose();
    _discountController.dispose();
    super.dispose();
  }
}
