import 'package:flutter/material.dart';


class AnalyticslDashboard extends StatefulWidget {
  const AnalyticslDashboard({super.key});

  @override
  State<AnalyticslDashboard> createState() => _AnalyticslDashboardState();
}

class _AnalyticslDashboardState extends State<AnalyticslDashboard> {
  String selectedDateRange = 'Last 30 Days';
  String selectedCategory = 'All Categories';
  String selectedDepartment = 'All Departments';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 300,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Stock Analytics',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Reports & Projections',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),

                // Navigation Items
                _buildNavItem(
                  icon: Icons.assessment,
                  title: 'Stock Reports',
                  isSelected: true,
                ),
                _buildNavItem(
                  icon: Icons.trending_up,
                  title: 'Restock Projections',
                  isSelected: false,
                ),
                _buildNavItem(
                  icon: Icons.group,
                  title: 'Vendor Performance',
                  isSelected: false,
                ),

                const SizedBox(height: 32),

                // Filters Section
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    'Filters',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Date Range Filter
                _buildFilterDropdown(
                  label: 'Date Range',
                  value: selectedDateRange,
                  onChanged: (value) {
                    setState(() {
                      selectedDateRange = value!;
                    });
                  },
                ),

                // Category Filter
                _buildFilterDropdown(
                  label: 'Category',
                  value: selectedCategory,
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                  },
                ),

                // Department Filter
                _buildFilterDropdown(
                  label: 'Department',
                  value: selectedDepartment,
                  onChanged: (value) {
                    setState(() {
                      selectedDepartment = value!;
                    });
                  },
                ),

                const SizedBox(height: 24),

                // Apply Filters Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Apply Filters',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
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
                  // Header with buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Stock Report Generator',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.download, size: 16),
                            label: const Text('Download Summary'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF06B6D4),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              elevation: 0,
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.email, size: 16),
                            label: const Text('Email to Procurement'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF8B5CF6),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              elevation: 0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Stats Cards Row
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          title: 'Total Items',
                          value: '2,847',
                          icon: Icons.inventory_2,
                          iconColor: const Color(0xFF6366F1),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          title: 'Low Stock',
                          value: '47',
                          icon: Icons.warning,
                          iconColor: const Color(0xFFEF4444),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          title: 'Expiring Soon',
                          value: '23',
                          icon: Icons.schedule,
                          iconColor: const Color(0xFFF59E0B),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          title: 'Total Value',
                          value: '\$284K',
                          icon: Icons.attach_money,
                          iconColor: const Color(0xFF10B981),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Bottom Section
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Consumption Summary
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Consumption Summary',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1F2937),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                _buildConsumptionItem(
                                  'Medical Supplies',
                                  '\$45,230',
                                ),
                                const SizedBox(height: 12),
                                _buildConsumptionItem('Equipment', '\$28,450'),
                                const SizedBox(height: 12),
                                _buildConsumptionItem(
                                  'Pharmaceuticals',
                                  '\$67,890',
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        // Movement Report
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Movement Report',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1F2937),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                _buildMovementItem(
                                  'Items Received',
                                  '+342',
                                  const Color(0xFF10B981),
                                ),
                                const SizedBox(height: 12),
                                _buildMovementItem(
                                  'Items Transferred',
                                  '156',
                                  const Color(0xFF6B7280),
                                ),
                                const SizedBox(height: 12),
                                _buildMovementItem(
                                  'Items Consumed',
                                  '-289',
                                  const Color(0xFFEF4444),
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String title,
    required bool isSelected,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF6366F1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? Colors.white : const Color(0xFF6B7280),
          size: 20,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF374151),
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        dense: true,
      ),
    );
  }

  Widget _buildFilterDropdown({
    required String label,
    required String value,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFD1D5DB)),
              borderRadius: BorderRadius.circular(6),
            ),
            child: DropdownButton<String>(
              value: value,
              onChanged: onChanged,
              isExpanded: true,
              underline: const SizedBox(),
              style: const TextStyle(fontSize: 14, color: Color(0xFF374151)),
              items: _getDropdownItems(label),
            ),
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> _getDropdownItems(String label) {
    switch (label) {
      case 'Date Range':
        return ['Last 30 Days', 'Last 60 Days', 'Last 90 Days']
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList();
      case 'Category':
        return [
              'All Categories',
              'Medical Supplies',
              'Equipment',
              'Pharmaceuticals',
            ]
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList();
      case 'Department':
        return ['All Departments', 'Emergency', 'Surgery', 'Pharmacy']
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList();
      default:
        return [];
    }
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 1),
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
              Icon(icon, color: iconColor, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConsumptionItem(String category, String amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          category,
          style: const TextStyle(fontSize: 14, color: Color(0xFF374151)),
        ),
        Text(
          amount,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
      ],
    );
  }

  Widget _buildMovementItem(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Color(0xFF374151)),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
