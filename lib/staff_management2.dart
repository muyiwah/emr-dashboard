import 'package:flutter/material.dart';



class StaffMember {
  final String name;
  final String email;
  final String role;
  final String department;
  final String status;
  final String schedule;
  final String avatarUrl;
  final Color roleColor;

  StaffMember({
    required this.name,
    required this.email,
    required this.role,
    required this.department,
    required this.status,
    required this.schedule,
    required this.avatarUrl,
    required this.roleColor,
  });
}

class StaffManagementScreen extends StatefulWidget {
  const StaffManagementScreen({super.key});

  @override
  State<StaffManagementScreen> createState() => _StaffManagementScreenState();
}

class _StaffManagementScreenState extends State<StaffManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedRole = 'All Roles';
  String _selectedDepartment = 'All Departments';
  int _currentPage = 1;

  final List<StaffMember> _staffMembers = [
    StaffMember(
      name: 'Dr. John Smith',
      email: 'john.smith@hospital.com',
      role: 'Doctor',
      department: 'Cardiology',
      status: 'Active',
      schedule: '9:00 AM - 5:00 PM',
      avatarUrl: 'assets/avatar1.png',
      roleColor: const Color(0xFF4F46E5),
    ),
    StaffMember(
      name: 'Sarah Johnson',
      email: 'sarah.johnson@hospital.com',
      role: 'Nurse',
      department: 'Emergency',
      status: 'On Leave',
      schedule: '12:00 PM - 8:00 PM',
      avatarUrl: 'assets/avatar2.png',
      roleColor: const Color(0xFF7C3AED),
    ),
    StaffMember(
      name: 'Mike Chen',
      email: 'mike.chen@hospital.com',
      role: 'Lab Tech',
      department: 'Laboratory',
      status: 'Active',
      schedule: '6:00 AM - 2:00 PM',
      avatarUrl: 'assets/avatar3.png',
      roleColor: const Color(0xFF059669),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildStatsCards(),
            _buildFiltersAndActions(),
            Expanded(child: _buildStaffDirectory()),
            _buildBottomCards(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF4F46E5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.people, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          const Text(
            'Staff Management',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Add Staff'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4F46E5),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(width: 12),
          const CircleAvatar(
            radius: 18,
            backgroundColor: Color(0xFFE2E8F0),
            child: Icon(Icons.person, size: 20, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Total Staff',
              '124',
              Icons.people,
              const Color(0xFF4F46E5),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              'Active Today',
              '98',
              Icons.check_circle,
              const Color(0xFF059669),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              'On Leave',
              '12',
              Icons.event_busy,
              const Color(0xFFEAB308),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              'Departments',
              '8',
              Icons.business,
              const Color(0xFF7C3AED),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
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
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersAndActions() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search staff...',
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: Color(0xFF64748B)),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          _buildDropdown(
            _selectedRole,
            ['All Roles', 'Doctor', 'Nurse', 'Lab Tech'],
            (value) {
              setState(() => _selectedRole = value!);
            },
          ),
          const SizedBox(width: 12),
          _buildDropdown(
            _selectedDepartment,
            ['All Departments', 'Cardiology', 'Emergency', 'Laboratory'],
            (value) {
              setState(() => _selectedDepartment = value!);
            },
          ),
          const SizedBox(width: 12),
          _buildActionButton('Export', Icons.download),
          const SizedBox(width: 12),
          _buildActionButton('Filter', Icons.tune),
        ],
      ),
    );
  }

  Widget _buildDropdown(
    String value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: DropdownButton<String>(
        value: value,
        items:
            items
                .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                .toList(),
        onChanged: onChanged,
        underline: const SizedBox(),
        style: const TextStyle(color: Color(0xFF1E293B), fontSize: 14),
      ),
    );
  }

  Widget _buildActionButton(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF64748B)),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(color: Color(0xFF1E293B), fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildStaffDirectory() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
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
            padding: EdgeInsets.all(20),
            child: Text(
              'Staff Directory',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
          ),
          _buildStaffTable(),
          _buildPagination(),
        ],
      ),
    );
  }

  Widget _buildStaffTable() {
    return Column(
      children: [
        _buildTableHeader(),
        ..._staffMembers.map((staff) => _buildStaffRow(staff)),
      ],
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: const Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              'STAFF',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF64748B),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'ROLE',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF64748B),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'DEPARTMENT',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF64748B),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'STATUS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF64748B),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'SCHEDULE',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF64748B),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'ACTIONS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF64748B),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStaffRow(StaffMember staff) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: const Color(0xFFE2E8F0),
                  child: Text(
                    staff.name.split(' ').map((n) => n[0]).take(2).join(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      staff.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    Text(
                      staff.email,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: staff.roleColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                staff.role,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: staff.roleColor,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              staff.department,
              style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B)),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color:
                    staff.status == 'Active'
                        ? const Color(0xFF059669).withOpacity(0.1)
                        : const Color(0xFFEAB308).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color:
                          staff.status == 'Active'
                              ? const Color(0xFF059669)
                              : const Color(0xFFEAB308),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    staff.status,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color:
                          staff.status == 'Active'
                              ? const Color(0xFF059669)
                              : const Color(0xFFEAB308),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              staff.schedule,
              style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B)),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.edit,
                    size: 16,
                    color: Color(0xFF64748B),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.more_vert,
                    size: 16,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPagination() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Showing 1 to 3 of 124 results',
            style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
          ),
          Row(
            children: [
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Previous',
                  style: TextStyle(color: Color(0xFF64748B)),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF4F46E5),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  '1',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  '2',
                  style: TextStyle(color: Color(0xFF64748B)),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  '3',
                  style: TextStyle(color: Color(0xFF64748B)),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Next',
                  style: TextStyle(color: Color(0xFF64748B)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomCards() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: _buildManagementCard(
              'Role Management',
              'Manage user roles and permissions across different modules.',
              'Manage Roles',
              const Color(0xFF4F46E5),
              Icons.people,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildManagementCard(
              'Schedule Management',
              'View and manage staff availability schedules and shifts.',
              'View Schedules',
              const Color(0xFF059669),
              Icons.calendar_today,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildManagementCard(
              'Time Tracking',
              'Track working hours and manage leave requests efficiently.',
              'Time Reports',
              const Color(0xFF7C3AED),
              Icons.access_time,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManagementCard(
    String title,
    String description,
    String buttonText,
    Color color,
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
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF64748B),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(buttonText),
            ),
          ),
        ],
      ),
    );
  }
}
