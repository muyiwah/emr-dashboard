import 'package:flutter/material.dart';

class LabTestRequests extends StatefulWidget {
  @override
  _LabTestRequestsState createState() => _LabTestRequestsState();
}

class _LabTestRequestsState extends State<LabTestRequests> {
  String selectedStatus = 'All';
  String selectedPriority = 'All';
  String selectedDepartment = 'All Departments';
  bool isListView = true;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(16),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header Bar
            Container(
              height: 72,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                border: Border(
                  bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
                ),
              ),
              child: Row(
                children: [
                  // Lab icon
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Color(0xFF3B82F6),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(
                      Icons.science_outlined,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  SizedBox(width: 12),
                  // Title
                  Text(
                    'Lab Test Requests Inbox',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF111827),
                      letterSpacing: -0.5,
                    ),
                  ),
                  Spacer(),
                  // Notification badge
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Color(0xFFDC2626),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        '3',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  // User avatar
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Color(0xFF3B82F6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(Icons.person, color: Colors.white, size: 18),
                  ),
                  SizedBox(width: 16),
                  // Close button
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(
                      Icons.close,
                      color: Color(0xFF6B7280),
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            // Subtitle
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Text(
                'View and manage all incoming test requests from physicians',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            // Main content
            Expanded(
              child: Row(
                children: [
                  // Left Sidebar
                  Container(
                    width: 320,
                    decoration: BoxDecoration(
                      color: Color(0xFFF9FAFB),
                      border: Border(
                        right: BorderSide(color: Color(0xFFE5E7EB), width: 1),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Today's Overview
                        Padding(
                          padding: EdgeInsets.fromLTRB(24, 24, 24, 16),
                          child: Text(
                            'Today\'s Overview',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF111827),
                            ),
                          ),
                        ),
                        // Overview cards
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  _buildOverviewCard(
                                    '24',
                                    'Total Requests',
                                    Color(0xFFDBEAFE),
                                    Color(0xFF3B82F6),
                                  ),
                                  SizedBox(width: 12),
                                  _buildOverviewCard(
                                    '5',
                                    'Urgent',
                                    Color(0xFFFEE2E2),
                                    Color(0xFFDC2626),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  _buildOverviewCard(
                                    '12',
                                    'In Progress',
                                    Color(0xFFFED7AA),
                                    Color(0xFFEA580C),
                                  ),
                                  SizedBox(width: 12),
                                  _buildOverviewCard(
                                    '18',
                                    'Completed',
                                    Color(0xFFD1FAE5),
                                    Color(0xFF059669),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 32),
                        // Filters
                        Padding(
                          padding: EdgeInsets.fromLTRB(24, 0, 24, 16),
                          child: Text(
                            'Filters',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF111827),
                            ),
                          ),
                        ),
                        // Filter dropdowns
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            children: [
                              _buildDropdownFilter(
                                'Status',
                                selectedStatus,
                                ['All', 'Urgent', 'In Progress', 'Completed'],
                                (value) {
                                  setState(() {
                                    selectedStatus = value!;
                                  });
                                },
                              ),
                              SizedBox(height: 16),
                              _buildDropdownFilter(
                                'Priority',
                                selectedPriority,
                                ['All', 'High', 'Medium', 'Low'],
                                (value) {
                                  setState(() {
                                    selectedPriority = value!;
                                  });
                                },
                              ),
                              SizedBox(height: 16),
                              _buildDropdownFilter(
                                'Department',
                                selectedDepartment,
                                [
                                  'All Departments',
                                  'Emergency',
                                  'Cardiology',
                                  'Internal Med',
                                ],
                                (value) {
                                  setState(() {
                                    selectedDepartment = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24),
                        // Search
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Color(0xFFD1D5DB)),
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search patient, ID, or test...',
                                hintStyle: TextStyle(
                                  color: Color(0xFF9CA3AF),
                                  fontSize: 14,
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Color(0xFF9CA3AF),
                                  size: 18,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                  // Main Content Area
                  Expanded(
                    child: Column(
                      children: [
                        // Content Header
                        Container(
                          height: 72,
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xFFE5E7EB),
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Lab Requests (24)',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF111827),
                                ),
                              ),
                              Spacer(),
                              // View toggle
                              Container(
                                height: 36,
                                decoration: BoxDecoration(
                                  color: Color(0xFFF3F4F6),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  children: [
                                    _buildViewToggle(
                                      Icons.format_list_bulleted,
                                      isListView,
                                      () {
                                        setState(() {
                                          isListView = true;
                                        });
                                      },
                                    ),
                                    _buildViewToggle(
                                      Icons.grid_view,
                                      !isListView,
                                      () {
                                        setState(() {
                                          isListView = false;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 16),
                              // Export button
                              Container(
                                height: 36,
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Color(0xFFD1D5DB)),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.file_download_outlined,
                                      size: 16,
                                      color: Color(0xFF374151),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Export',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF374151),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Lab Requests List
                        Expanded(
                          child: Container(
                            color: Color(0xFFF9FAFB),
                            child: ListView(
                              padding: EdgeInsets.all(24),
                              children: [
                                _buildLabRequestItem(
                                  'Sarah Johnson',
                                  'P-2024-001',
                                  'F, 34',
                                  [
                                    {'name': 'FBC', 'color': Color(0xFFFEE2E2)},
                                    {
                                      'name': 'Urinalysis',
                                      'color': Color(0xFFDBEAFE),
                                    },
                                    {
                                      'name': 'Blood',
                                      'color': Color(0xFFD1FAE5),
                                    },
                                  ],
                                  'URGENT',
                                  'New',
                                  'Dr. Smith - Emergency',
                                  '2 hours ago',
                                  Color(0xFFDC2626),
                                ),
                                SizedBox(height: 16),
                                _buildLabRequestItem(
                                  'Michael Chen',
                                  'P-2024-002',
                                  'M, 45',
                                  [
                                    {
                                      'name': 'Lipid Panel',
                                      'color': Color(0xFFE9D5FF),
                                    },
                                    {
                                      'name': 'Blood',
                                      'color': Color(0xFFD1FAE5),
                                    },
                                  ],
                                  'ROUTINE',
                                  'In Progress',
                                  'Dr. Wilson - Cardiology',
                                  '4 hours ago',
                                  Color(0xFF059669),
                                ),
                                SizedBox(height: 16),
                                _buildLabRequestItem(
                                  'Emma Davis',
                                  'P-2024-003',
                                  'F, 28',
                                  [
                                    {'name': 'LFT', 'color': Color(0xFFFED7AA)},
                                    {'name': 'FBC', 'color': Color(0xFFFEE2E2)},
                                    {
                                      'name': 'Blood',
                                      'color': Color(0xFFD1FAE5),
                                    },
                                  ],
                                  'DELAYED',
                                  'New',
                                  'Dr. Brown - Internal Med',
                                  '6 hours ago',
                                  Color(0xFFEA580C),
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
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCard(
    String number,
    String label,
    Color bgColor,
    Color textColor,
  ) {
    return Expanded(
      child: Container(
        height: 79,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              number,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: textColor,
                height: 1.0,
              ),
            ),
            SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownFilter(
    String label,
    String value,
    List<String> options,
    Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF111827),
          ),
        ),
        SizedBox(height: 8),
        Container(
          height: 40,
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Color(0xFFD1D5DB)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              onChanged: onChanged,
              isExpanded: true,
              style: TextStyle(fontSize: 14, color: Color(0xFF374151)),
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: Color(0xFF6B7280),
                size: 20,
              ),
              items:
                  options.map((String option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildViewToggle(IconData icon, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isActive ? Color(0xFF3B82F6) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isActive ? Colors.white : Color(0xFF6B7280),
        ),
      ),
    );
  }

  Widget _buildLabRequestItem(
    String name,
    String id,
    String demographics,
    List<Map<String, dynamic>> tests,
    String priority,
    String status,
    String doctor,
    String time,
    Color statusColor,
  ) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFFE5E7EB)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status indicator dot
          Container(
            width: 8,
            height: 8,
            margin: EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 16),
          // Patient info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Patient name and details
                Row(
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111827),
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'ID: $id',
                      style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                    ),
                    SizedBox(width: 12),
                    Text(
                      demographics,
                      style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                // Test chips
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children:
                      tests.map((test) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: test['color'],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            test['name'],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF374151),
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ],
            ),
          ),
          // Status and metadata
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Priority and status badges
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      priority,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              // Doctor info
              Text(
                doctor,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF111827),
                ),
              ),
              SizedBox(height: 4),
              // Time
              Text(
                time,
                style: TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Usage example:
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Lab Test App')),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => LabTestRequests(),
              );
            },
            child: Text('Open Lab Test Requests'),
          ),
        ),
      ),
    );
  }
}
