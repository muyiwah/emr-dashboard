import 'package:flutter/material.dart';


class NextShift extends StatefulWidget {
  @override
  _NextShiftState createState() => _NextShiftState();
}

class _NextShiftState extends State<NextShift> {
  bool showOnlyActiveShifts = false;
  int selectedTab = 0; // 0 for Doctors, 1 for Nurses

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      body: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(),
            SizedBox(height: 24),

            // Stats Cards
            _buildStatsCards(),
            SizedBox(height: 24),

            // Filters
            _buildFilters(),
            SizedBox(height: 24),

            // Main Content
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Panel - Current On-Duty Staff
                  Expanded(flex: 1, child: _buildCurrentStaffPanel()),
                  SizedBox(width: 24),

                  // Right Panel - Upcoming Shift Handover
                  Expanded(flex: 1, child: _buildUpcomingHandoverPanel()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'On-Duty & Handover Overview',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1D29),
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Hospital Staff Management Dashboard',
              style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Color(0xFF2563EB),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Icon(Icons.file_download, color: Colors.white, size: 16),
                  SizedBox(width: 8),
                  Text(
                    'Export PDF',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Today',
                  style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                ),
                Text(
                  'January 15, 2025',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1A1D29),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsCards() {
    return Row(
      children: [
        _buildStatCard(
          icon: Icons.people,
          title: 'Total Staff on Duty',
          value: '24',
          color: Color(0xFF3B82F6),
        ),
        SizedBox(width: 16),
        _buildStatCard(
          icon: Icons.verified_user,
          title: 'Active',
          value: 'Doctors: 12 | Nurses: 12',
          color: Color(0xFF10B981),
        ),
        SizedBox(width: 16),
        _buildStatCard(
          icon: Icons.schedule,
          title: 'Shifts Ending Soon',
          value: '6',
          color: Color(0xFFF59E0B),
        ),
        SizedBox(width: 16),
        _buildStatCard(
          icon: Icons.warning,
          title: 'Unfilled Shifts',
          value: '2',
          color: Color(0xFFEF4444),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1D29),
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

  Widget _buildFilters() {
    return Row(
      children: [
        Icon(Icons.filter_alt_outlined, size: 16, color: Color(0xFF6B7280)),
        SizedBox(width: 8),
        Text(
          'Filters:',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF6B7280),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: 16),
        _buildDropdown('All Departments'),
        SizedBox(width: 16),
        _buildDropdown('All Roles'),
        SizedBox(width: 16),
        Row(
          children: [
            Checkbox(
              value: showOnlyActiveShifts,
              onChanged: (value) {
                setState(() {
                  showOnlyActiveShifts = value ?? false;
                });
              },
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            Text(
              'Show Only Active Shifts',
              style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDropdown(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Text(text, style: TextStyle(fontSize: 14, color: Color(0xFF374151))),
          SizedBox(width: 8),
          Icon(Icons.keyboard_arrow_down, size: 16, color: Color(0xFF6B7280)),
        ],
      ),
    );
  }

  Widget _buildCurrentStaffPanel() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Current On-Duty Staff',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1D29),
              ),
            ),
          ),
          _buildTabBar(),
          Expanded(child: _buildStaffList()),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _buildTab('Doctors', 0),
          SizedBox(width: 8),
          _buildTab('Nurses', 1),
        ],
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    bool isSelected = selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF2563EB) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : Color(0xFF6B7280),
          ),
        ),
      ),
    );
  }

  Widget _buildStaffList() {
    return ListView(
      padding: EdgeInsets.all(20),
      children: [
        _buildStaffCard(
          name: 'Dr. Michael Smith',
          department: 'Emergency Department',
          time: '08:00 - 16:00',
          timeLeft: '2h 15m left',
          timeLeftColor: Color(0xFF2563EB),
          avatar: 'assets/avatar1.png',
        ),
        SizedBox(height: 12),
        _buildStaffCard(
          name: 'Dr. Sarah Johnson',
          department: 'Pediatrics',
          time: '12:00 - 20:00',
          timeLeft: '6h 45m left',
          timeLeftColor: Color(0xFF10B981),
          avatar: 'assets/avatar2.png',
        ),
        SizedBox(height: 12),
        _buildStaffCard(
          name: 'Dr. James Wilson',
          department: 'Cardiology',
          time: '06:00 - 14:00',
          timeLeft: '45m left',
          timeLeftColor: Color(0xFFF59E0B),
          avatar: 'assets/avatar3.png',
        ),
      ],
    );
  }

  Widget _buildStaffCard({
    required String name,
    required String department,
    required String time,
    required String timeLeft,
    required Color timeLeftColor,
    required String avatar,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Color(0xFF3B82F6),
            child: Text(
              name.split(' ').map((e) => e[0]).join(),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1D29),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  department,
                  style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                time,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1A1D29),
                ),
              ),
              SizedBox(height: 2),
              Text(
                timeLeft,
                style: TextStyle(
                  fontSize: 12,
                  color: timeLeftColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(width: 12),
          Icon(Icons.phone, color: Color(0xFF3B82F6), size: 16),
        ],
      ),
    );
  }

  Widget _buildUpcomingHandoverPanel() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Upcoming Shift Handover',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1D29),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Next in Line - Grouped by Department',
                  style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
          Expanded(child: _buildHandoverList()),
        ],
      ),
    );
  }

  Widget _buildHandoverList() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20),
      children: [
        _buildDepartmentSection(
          'Emergency Department',
          '15 min overlap',
          Color(0xFF3B82F6),
        ),
        _buildHandoverCard(
          name: 'Dr. Emily Davis',
          startTime: 'Starts at 16:00',
          tag: 'First Time Today',
          tagColor: Color(0xFFF59E0B),
        ),
        SizedBox(height: 16),

        _buildDepartmentSection('Pediatrics', 'No overlap', Color(0xFF6B7280)),
        _buildHandoverCard(
          name: 'Dr. Lisa Brown',
          startTime: 'Starts at 20:00',
          tag: 'Back-to-back',
          tagColor: Color(0xFFEF4444),
        ),
        SizedBox(height: 16),

        _buildDepartmentSection(
          'Cardiology',
          '30 min overlap',
          Color(0xFF3B82F6),
        ),
        _buildHandoverCard(
          name: 'Dr. Anna Taylor',
          startTime: 'Starts at 14:00',
          tag: null,
          tagColor: null,
        ),
      ],
    );
  }

  Widget _buildDepartmentSection(
    String title,
    String overlap,
    Color overlapColor,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1D29),
            ),
          ),
          Text(
            overlap,
            style: TextStyle(
              fontSize: 12,
              color: overlapColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHandoverCard({
    required String name,
    required String startTime,
    String? tag,
    Color? tagColor,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Color(0xFF10B981),
            child: Text(
              name.split(' ').map((e) => e[0]).join(),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1D29),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  startTime,
                  style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
          if (tag != null && tagColor != null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: tagColor,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                tag,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
