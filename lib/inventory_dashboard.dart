import 'package:flutter/material.dart';


class InventoryDashboard extends StatefulWidget {
  const InventoryDashboard({super.key});

  @override
  State<InventoryDashboard> createState() => _InventoryDashboardState();
}

class _InventoryDashboardState extends State<InventoryDashboard> {
  String selectedDepartment = 'All Departments';
  String selectedType = 'All Types';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 280,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text(
                    'Inventory & Supply',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                ),
                // Categories
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    'STOCK CATEGORIES',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF6B7280),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildSidebarItem(
                  icon: Icons.medication,
                  label: 'Drugs & Medications',
                  isSelected: true,
                ),
                _buildSidebarItem(
                  icon: Icons.local_hospital,
                  label: 'Medical Consumables',
                ),
                _buildSidebarItem(
                  icon: Icons.inventory_2,
                  label: 'Non-medical Supplies',
                ),
                _buildSidebarItem(
                  icon: Icons.medical_services,
                  label: 'Medical Equipment',
                ),
                _buildSidebarItem(
                  icon: Icons.science,
                  label: 'Lab Reagents & Tools',
                ),
                const SizedBox(height: 24),
                // Add Category Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Add Category'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF6B7280),
                      side: const BorderSide(color: Color(0xFFE5E7EB)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Main Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Inventory Dashboard',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Manage stock levels and procurement',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.shopping_cart, size: 18),
                            label: const Text('New Purchase Order'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF06B6D4),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text('Add Item'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF7C3AED),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  // Stats Cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          title: 'Total Items',
                          value: '2,847',
                          icon: Icons.inventory,
                          iconColor: const Color(0xFF7C3AED),
                          backgroundColor: const Color(0xFFF3F4F6),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          title: 'Low Stock Alerts',
                          value: '24',
                          icon: Icons.warning,
                          iconColor: const Color(0xFFF59E0B),
                          backgroundColor: const Color(0xFFFEF3C7),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          title: 'Pending Orders',
                          value: '12',
                          icon: Icons.shopping_cart,
                          iconColor: const Color(0xFF06B6D4),
                          backgroundColor: const Color(0xFFCFFAFE),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          title: 'Monthly Spend',
                          value: '\$45,230',
                          icon: Icons.attach_money,
                          iconColor: const Color(0xFF10B981),
                          backgroundColor: const Color(0xFFD1FAE5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  // Inventory Overview
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Table Header
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Inventory Overview',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1F2937),
                                  ),
                                ),
                                Row(
                                  children: [
                                    _buildDropdown(
                                      value: selectedDepartment,
                                      items: const [
                                        'All Departments',
                                        'Pharmacy',
                                        'Surgery',
                                        'Lab',
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          selectedDepartment = value!;
                                        });
                                      },
                                    ),
                                    const SizedBox(width: 16),
                                    _buildDropdown(
                                      value: selectedType,
                                      items: const [
                                        'All Types',
                                        'Medications',
                                        'Equipment',
                                        'Consumables',
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          selectedType = value!;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Search Bar
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24.0,
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search inventory...',
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: Color(0xFF9CA3AF),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFE5E7EB),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFE5E7EB),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF06B6D4),
                                  ),
                                ),
                                filled: true,
                                fillColor: const Color(0xFFF9FAFB),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Table
                          Expanded(
                            child: SingleChildScrollView(
                              child: Table(
                                columnWidths: const {
                                  0: FlexColumnWidth(3),
                                  1: FlexColumnWidth(2),
                                  2: FlexColumnWidth(1.5),
                                  3: FlexColumnWidth(2),
                                  4: FlexColumnWidth(2),
                                  5: FlexColumnWidth(2),
                                  6: FlexColumnWidth(1),
                                },
                                children: [
                                  // Table Header
                                  TableRow(
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFF9FAFB),
                                    ),
                                    children: [
                                      _buildTableHeader('ITEM'),
                                      _buildTableHeader('SKU'),
                                      _buildTableHeader('STOCK'),
                                      _buildTableHeader('LOCATION'),
                                      _buildTableHeader('EXPIRY'),
                                      _buildTableHeader('STATUS'),
                                      _buildTableHeader('ACTIONS'),
                                    ],
                                  ),
                                  // Table Rows
                                  _buildTableRow(
                                    icon: Icons.medication,
                                    iconColor: const Color(0xFF7C3AED),
                                    title: 'Paracetamol 500mg',
                                    subtitle: 'Tablets',
                                    sku: 'MED-001',
                                    stock: '2,450',
                                    location: 'Pharmacy A-1',
                                    expiry: 'Dec 2024',
                                    status: 'In Stock',
                                    statusColor: const Color(0xFF10B981),
                                  ),
                                  _buildTableRow(
                                    icon: Icons.medical_services,
                                    iconColor: const Color(0xFF06B6D4),
                                    title: 'Surgical Gloves',
                                    subtitle: 'Size M',
                                    sku: 'CON-045',
                                    stock: '89',
                                    location: 'Surgery B-2',
                                    expiry: 'Mar 2025',
                                    status: 'Low Stock',
                                    statusColor: const Color(0xFFF59E0B),
                                  ),
                                  _buildTableRow(
                                    icon: Icons.science,
                                    iconColor: const Color(0xFFEF4444),
                                    title: 'Blood Test Reagent',
                                    subtitle: 'Type A',
                                    sku: 'LAB-078',
                                    stock: '0',
                                    location: 'Lab Storage',
                                    expiry: '-',
                                    status: 'Out of Stock',
                                    statusColor: const Color(0xFFEF4444),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem({
    required IconData icon,
    required String label,
    bool isSelected = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? const Color(0xFF7C3AED) : const Color(0xFF6B7280),
          size: 20,
        ),
        title: Text(
          label,
          style: TextStyle(
            color:
                isSelected ? const Color(0xFF7C3AED) : const Color(0xFF374151),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            fontSize: 14,
          ),
        ),
        selected: isSelected,
        selectedTileColor: const Color(0xFFF3F4F6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        onTap: () {},
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F2937),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        value: value,
        items:
            items.map((item) {
              return DropdownMenuItem(value: item, child: Text(item));
            }).toList(),
        onChanged: onChanged,
        underline: const SizedBox(),
        style: const TextStyle(color: Color(0xFF374151), fontSize: 14),
      ),
    );
  }

  Widget _buildTableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF6B7280),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  TableRow _buildTableRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String sku,
    required String stock,
    required String location,
    required String expiry,
    required String status,
    required Color statusColor,
  }) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 16),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Text(
            sku,
            style: const TextStyle(color: Color(0xFF374151), fontSize: 14),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Text(
            stock,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
              fontSize: 14,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Text(
            location,
            style: const TextStyle(color: Color(0xFF374151), fontSize: 14),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Text(
            expiry,
            style: const TextStyle(color: Color(0xFF374151), fontSize: 14),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_horiz, color: Color(0xFF6B7280)),
          ),
        ),
      ],
    );
  }
}
