import 'package:flutter/material.dart';

class PharmaCareScreenDrugs extends StatefulWidget {
  const PharmaCareScreenDrugs({Key? key}) : super(key: key);

  @override
  State<PharmaCareScreenDrugs> createState() => _PharmaCareScreenState();
}

class _PharmaCareScreenState extends State<PharmaCareScreenDrugs> {
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Row(
        children: [
          // Left Sidebar
          Container(
            width: 250,
            color: Colors.white,
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFF6366F1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.medical_services,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PharmaCare',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          Text(
                            'Pharmacy Management System',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                // Navigation Items
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    children: [
                      _buildNavItem(Icons.receipt_long, 'Prescriptions', 0),
                      _buildNavItem(Icons.inventory_2, 'Inventory', 1),
                      _buildNavItem(Icons.analytics, 'Analytics', 2),
                      _buildNavItem(Icons.people, 'Patients', 3),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Main Content
          Expanded(
            child: Column(
              children: [
                // Top Bar
                Container(
                  height: 70,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(
                          child: Text(
                            '2',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const CircleAvatar(
                        radius: 16,
                        backgroundColor: Color(0xFF6B7280),
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Prescription Queue Section
                        _buildPrescriptionQueue(),
                        const SizedBox(height: 24),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left Column
                            Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  _buildDispensingPanel(),
                                  const SizedBox(height: 24),
                                  _buildPharmacyInventory(),
                                ],
                              ),
                            ),
                            const SizedBox(width: 24),
                            // Right Column
                            Expanded(flex: 1, child: _buildQuickMetrics()),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String title, int index) {
    final isSelected = selectedTab == index;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: ListTile(
        selected: isSelected,
        selectedTileColor: const Color(0xFF6366F1).withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        leading: Icon(
          icon,
          color: isSelected ? const Color(0xFF6366F1) : const Color(0xFF6B7280),
          size: 20,
        ),
        title: Text(
          title,
          style: TextStyle(
            color:
                isSelected ? const Color(0xFF6366F1) : const Color(0xFF374151),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
        onTap: () => setState(() => selectedTab = index),
      ),
    );
  }

  Widget _buildPrescriptionQueue() {
    return Container(
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
          // Header
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Prescription Queue',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 16,
                      color: Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Last updated: 2 min ago',
                      style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Tabs
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                _buildTab('Outpatient (12)', true),
                _buildTab('Inpatient (8)', false),
                _buildTab('Emergency (3)', false),
                _buildTab('Ward (15)', false),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            color: const Color(0xFFF9FAFB),
            child: const Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Patient',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Color(0xFF374151),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Prescription ID',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Color(0xFF374151),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Department',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Color(0xFF374151),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Doctor',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Color(0xFF374151),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Date/Time',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Color(0xFF374151),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Status',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Color(0xFF374151),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Action',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Color(0xFF374151),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Table Rows
          _buildPrescriptionRow(
            'Sarah Johnson',
            'RX-2024-001',
            'Cardiology',
            'Dr. Smith',
            'Dec 18, 9:30 AM',
            'Pending',
            const Color(0xFFFBBF24),
            'View & Dispense',
            const Color(0xFF6366F1),
          ),
          _buildPrescriptionRow(
            'Michael Chen',
            'RX-2024-002',
            'Neurology',
            'Dr. Williams',
            'Dec 18, 9:15 AM',
            'Dispensed',
            const Color(0xFF10B981),
            'Completed',
            const Color(0xFF6B7280),
          ),
          _buildPrescriptionRow(
            'David Wilson',
            'RX-2024-003',
            'Emergency',
            'Dr. Brown',
            'Dec 18, 8:45 AM',
            'Urgent',
            const Color(0xFFEF4444),
            'View & Dispense',
            const Color(0xFFEF4444),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String text, bool isActive) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF6366F1) : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: isActive ? Colors.white : const Color(0xFF6B7280),
        ),
      ),
    );
  }

  Widget _buildPrescriptionRow(
    String patient,
    String prescriptionId,
    String department,
    String doctor,
    String dateTime,
    String status,
    Color statusColor,
    String action,
    Color actionColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: const Color(0xFF6B7280),
                  child: Text(
                    patient[0],
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  patient,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(prescriptionId, style: const TextStyle(fontSize: 14)),
          ),
          Expanded(
            flex: 2,
            child: Text(department, style: const TextStyle(fontSize: 14)),
          ),
          Expanded(
            flex: 1,
            child: Text(doctor, style: const TextStyle(fontSize: 14)),
          ),
          Expanded(
            flex: 2,
            child: Text(dateTime, style: const TextStyle(fontSize: 14)),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                status,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: statusColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: actionColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                minimumSize: Size.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: Text(action, style: const TextStyle(fontSize: 11)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDispensingPanel() {
    return Container(
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
          const Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Dispensing Panel',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Patient: Sarah Johnson',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 4),
                Text('RX-2024-001', style: TextStyle(color: Color(0xFF6B7280))),
                SizedBox(height: 4),
                Text(
                  'Doctor: Dr. Smith | Department: Cardiology',
                  style: TextStyle(color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                _buildMedicationItem(
                  'Lisinopril 10mg',
                  'In Stock',
                  const Color(0xFF10B981),
                ),
                const SizedBox(height: 16),
                _buildMedicationItem(
                  'Metformin 500mg',
                  'Low Stock',
                  const Color(0xFFFBBF24),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.print, size: 16),
                        label: const Text('Print Label'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF06B6D4),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.check, size: 16),
                        label: const Text('Confirm Dispense'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6366F1),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildMedicationItem(String name, String status, Color statusColor) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Route: Oral | Frequency: Once daily | Duration: 30 days',
                style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            status,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: statusColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickMetrics() {
    return Container(
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
          const Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Quick Metrics',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    '8',
                    'Out of Stock',
                    const Color(0xFFEF4444),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    '15',
                    'Near Expiry',
                    const Color(0xFFFBBF24),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Chart placeholder
          Container(
            height: 200,
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'Inventory Chart',
                style: TextStyle(color: Color(0xFF6B7280)),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Dispensing Accuracy',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const Text(
                  '98.5%',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF10B981),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(24),
            height: 8,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: 0.985,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String number, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(Icons.warning, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            number,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPharmacyInventory() {
    return Container(
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
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Pharmacy Inventory',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('Add Item'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.refresh, size: 16),
                      label: const Text('Update Stock'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF06B6D4),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Inventory Table
          _buildInventoryHeader(),
          _buildInventoryRow(
            'Lisinopril',
            'Tablet',
            '10mg',
            '450 units',
            'Mar 2025',
            'PharmaCorp',
            'Good Stock',
            const Color(0xFF10B981),
          ),
          _buildInventoryRow(
            'Metformin',
            'Tablet',
            '500mg',
            '25 units',
            'Feb 2025',
            'MediSupply',
            'Low Stock',
            const Color(0xFFFBBF24),
          ),
          _buildInventoryRow(
            'Amoxicillin',
            'Syrup',
            '250mg/5ml',
            '0 units',
            'Jan 2025',
            'HealthPlus',
            'Out of Stock',
            const Color(0xFFEF4444),
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      color: const Color(0xFFF9FAFB),
      child: const Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              'Drug Name',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: Color(0xFF374151),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'Form',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: Color(0xFF374151),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'Strength',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: Color(0xFF374151),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'Stock',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: Color(0xFF374151),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'Expiry',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: Color(0xFF374151),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'Supplier',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: Color(0xFF374151),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'Status',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: Color(0xFF374151),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryRow(
    String drugName,
    String form,
    String strength,
    String stock,
    String expiry,
    String supplier,
    String status,
    Color statusColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              drugName,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(form, style: const TextStyle(fontSize: 14)),
          ),
          Expanded(
            flex: 1,
            child: Text(strength, style: const TextStyle(fontSize: 14)),
          ),
          Expanded(
            flex: 1,
            child: Text(stock, style: const TextStyle(fontSize: 14)),
          ),
          Expanded(
            flex: 1,
            child: Text(expiry, style: const TextStyle(fontSize: 14)),
          ),
          Expanded(
            flex: 1,
            child: Text(supplier, style: const TextStyle(fontSize: 14)),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                status,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: statusColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Main App
class PharmaCareApp extends StatelessWidget {
  const PharmaCareApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PharmaCare',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: 'Inter',
        useMaterial3: true,
      ),
      home: const PharmaCareScreenDrugs(),
      debugShowCheckedModeBanner: false,
    );
  }
}

