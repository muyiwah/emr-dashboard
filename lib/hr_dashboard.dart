import 'package:flutter/material.dart';


class HRDashboardScreen extends StatefulWidget {
  const HRDashboardScreen({super.key});

  @override
  State<HRDashboardScreen> createState() => _HRDashboardScreenState();
}

class _HRDashboardScreenState extends State<HRDashboardScreen> {
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 250,
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                right: BorderSide(color: Color(0xFFE5E7EB), width: 1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(
                    'HR Dashboard',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[900],
                    ),
                  ),
                ),
                // Navigation Items
                _buildNavItem(Icons.people_outline, 'Staff Management', 0),
                _buildNavItem(Icons.access_time, 'Leave & Time Tracking', 1),
                _buildNavItem(Icons.analytics_outlined, 'Analytics', 2),
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
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      children: [
                        Text(
                          'Leave & Time Tracking',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[900],
                          ),
                        ),
                        const Spacer(),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.download, color: Colors.white),
                          label: const Text(
                            'Export Timesheets',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6366F1),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.grey[300],
                          child: Icon(Icons.person, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ),
                // Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        // Stats Cards
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                'Total Leave Requests',
                                '24',
                                Icons.calendar_today,
                                const Color(0xFFEFF6FF),
                                const Color(0xFF2563EB),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildStatCard(
                                'Pending Approvals',
                                '8',
                                Icons.schedule,
                                const Color(0xFFFEF3C7),
                                const Color(0xFFD97706),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildStatCard(
                                'Active Employees',
                                '42',
                                Icons.people,
                                const Color(0xFFECFDF5),
                                const Color(0xFF059669),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildStatCard(
                                'This Week Hours',
                                '1,680',
                                Icons.access_time,
                                const Color(0xFFECFEFF),
                                const Color(0xFF0891B2),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        // Tab Navigation
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                          ),
                          child: Row(
                            children: [
                              _buildTab('Leave Dashboard', 0, true),
                              _buildTab('Time Tracker', 1, false),
                              _buildTab('Analytics', 2, false),
                            ],
                          ),
                        ),
                        // Table
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                            ),
                            child: Column(
                              children: [
                                // Table Header with Filters
                                Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Leave Requests',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey[900],
                                        ),
                                      ),
                                      const Spacer(),
                                      _buildDropdownFilter('All Types'),
                                      const SizedBox(width: 12),
                                      _buildDropdownFilter('All Status'),
                                    ],
                                  ),
                                ),
                                // Table
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: _buildLeaveRequestsTable(),
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
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String title, int index) {
    final isSelected = selectedTab == index;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? const Color(0xFF6366F1) : Colors.grey[600],
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? const Color(0xFF6366F1) : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        selected: isSelected,
        selectedColor: const Color(0xFF6366F1),
        selectedTileColor: const Color(0xFFEFF6FF),
        onTap: () {
          setState(() {
            selectedTab = index;
          });
        },
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color bgColor, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.grey[900],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String title, int index, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isActive ? const Color(0xFF6366F1) : Colors.transparent,
            width: 2,
          ),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isActive ? const Color(0xFF6366F1) : Colors.grey[600],
          fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildDropdownFilter(String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD1D5DB)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.keyboard_arrow_down,
            size: 16,
            color: Colors.grey[600],
          ),
        ],
      ),
    );
  }

  Widget _buildLeaveRequestsTable() {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(1.5),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1),
        4: FlexColumnWidth(1.5),
        5: FlexColumnWidth(1.5),
      },
      children: [
        // Header
        TableRow(
          decoration: BoxDecoration(
            color: Colors.grey[50],
          ),
          children: [
            _buildTableHeader('STAFF NAME'),
            _buildTableHeader('TYPE'),
            _buildTableHeader('DURATION'),
            _buildTableHeader('STATUS'),
            _buildTableHeader('REMAINING DAYS'),
            _buildTableHeader('ACTIONS'),
          ],
        ),
        // Rows
        TableRow(
          children: [
            _buildTableCell(
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.red[100],
                    child: Text(
                      'JS',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.red[700],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'John Smith',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            _buildTableCell(
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Sick Leave',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.red[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            _buildTableCell(const Text('3 days')),
            _buildTableCell(
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Pending',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.orange[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            _buildTableCell(const Text('15 days')),
            _buildTableCell(
              Row(
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Approve',
                      style: TextStyle(color: Color(0xFF059669)),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Reject',
                      style: TextStyle(color: Color(0xFFDC2626)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            _buildTableCell(
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.blue[100],
                    child: Text(
                      'SJ',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue[700],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Sarah Johnson',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            _buildTableCell(
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Annual Leave',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            _buildTableCell(const Text('5 days')),
            _buildTableCell(
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Approved',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            _buildTableCell(const Text('12 days')),
            _buildTableCell(
              Text(
                'Approved',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTableHeader(String title) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.grey[600],
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildTableCell(Widget child) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: child,
    );
  }
}