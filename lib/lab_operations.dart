import 'package:flutter/material.dart';



class LabOperationsDashboard extends StatefulWidget {
  const LabOperationsDashboard({Key? key}) : super(key: key);

  @override
  State<LabOperationsDashboard> createState() => _LabOperationsDashboardState();
}

class _LabOperationsDashboardState extends State<LabOperationsDashboard> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedTechnician = 'All Technicians';
  String _selectedTestType = 'All Test Types';
  String _selectedStatus = 'All Status';

  final List<StatCard> _stats = [
    StatCard(
      title: 'Total Tests Today',
      value: '247',
      icon: Icons.assignment,
      color: const Color(0xFF6366F1),
    ),
    StatCard(
      title: 'Tests Pending',
      value: '34',
      icon: Icons.pending,
      color: Colors.orange,
    ),
    StatCard(
      title: 'Results Uploaded',
      value: '189',
      icon: Icons.upload_file,
      color: Colors.green,
    ),
    StatCard(
      title: 'Avg Turnaround',
      value: '2.4h',
      icon: Icons.timer,
      color: Colors.cyan,
    ),
    StatCard(
      title: 'Alerts Raised',
      value: '7',
      icon: Icons.warning,
      color: Colors.red,
    ),
  ];

  final List<SampleColumn> _sampleColumns = [
    SampleColumn(
      title: 'Ordered (12)',
      color: const Color(0xFFE0E7FF),
      samples: [
        Sample(
          patientName: 'John Doe',
          testType: 'Hematology',
          timeAgo: '2h ago',
          labId: '#LAB001',
        ),
        Sample(
          patientName: 'Jane Smith',
          testType: 'Urinalysis',
          timeAgo: '1h ago',
          labId: '#LAB002',
        ),
      ],
    ),
    SampleColumn(
      title: 'Collected (8)',
      color: const Color(0xFFDCFCE7),
      samples: [
        Sample(
          patientName: 'Mike Johnson',
          testType: 'Chemistry',
          timeAgo: '30m ago',
          labId: '#LAB003',
        ),
      ],
    ),
    SampleColumn(
      title: 'In Process (15)',
      color: const Color(0xFFFEF3C7),
      samples: [
        Sample(
          patientName: 'Sarah Wilson',
          testType: 'Microbiology',
          timeAgo: 'Dr. Smith',
          labId: '#LAB004',
        ),
      ],
    ),
    SampleColumn(
      title: 'Completed (45)',
      color: const Color(0xFFD1FAE5),
      samples: [
        Sample(
          patientName: 'Tom Brown',
          testType: 'Hematology',
          timeAgo: 'Dr. Johnson',
          labId: '#LAB005',
        ),
      ],
    ),
    SampleColumn(
      title: 'Reviewed (67)',
      color: const Color(0xFFE5E7EB),
      samples: [
        Sample(
          patientName: 'Lisa Davis',
          testType: 'Chemistry',
          timeAgo: 'Completed',
          labId: '#LAB006',
        ),
      ],
    ),
  ];

  final List<Technician> _technicians = [
    Technician(
      name: 'Dr. Smith',
      testsAssigned: 12,
      avatar: 'assets/avatar1.jpg',
      workload: 0.8,
    ),
    Technician(
      name: 'Dr. Johnson',
      testsAssigned: 8,
      avatar: 'assets/avatar2.jpg',
      workload: 0.6,
    ),
  ];

  final List<AlertItem> _alerts = [
    AlertItem(
      type: AlertType.critical,
      title: 'Critical Test Delayed',
      description: 'Patient #LAB007 - 4h overdue',
    ),
    AlertItem(
      type: AlertType.warning,
      title: 'Barcode Scan Missing',
      description: 'Sample collection not logged',
    ),
  ];

  final List<TestCategory> _testCategories = [
    TestCategory(name: 'Hematology', turnaround: '2-4h', isEnabled: true),
    TestCategory(name: 'Urinalysis', turnaround: '1-2h', isEnabled: true),
    TestCategory(name: 'Chemistry', turnaround: '3-6h', isEnabled: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf8FAFC),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            _buildStatsSection(),
            _buildFiltersSection(),
            _buildMainContent(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF6366F1),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.science,
                  color: Color(0xFF6366F1),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Lab Administrator',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_outlined),
              ),
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey[300],
                child: const Icon(Icons.person, color: Colors.white, size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Lab Operations Dashboard',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Track, manage, and optimize lab workflows.',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, size: 20),
                label: const Text('Add New Test Order'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  foregroundColor: Colors.white,
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
          const SizedBox(height: 32),
          Row(
            children:
                _stats
                    .map(
                      (stat) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: _buildStatCard(stat),
                        ),
                      ),
                    )
                    .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(StatCard stat) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
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
                stat.title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
              Icon(stat.icon, color: stat.color, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            stat.value,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by patient name or barcode...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildDropdown(
              _selectedTechnician,
              ['All Technicians', 'Dr. Smith', 'Dr. Johnson'],
              (value) {
                setState(() => _selectedTechnician = value!);
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildDropdown(
              _selectedTestType,
              ['All Test Types', 'Hematology', 'Chemistry', 'Urinalysis'],
              (value) {
                setState(() => _selectedTestType = value!);
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildDropdown(
              _selectedStatus,
              ['All Status', 'Ordered', 'In Process', 'Completed'],
              (value) {
                setState(() => _selectedStatus = value!);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(
    String value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items:
          items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildMainContent() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 2, child: _buildSampleTrackingBoard()),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              children: [
                _buildTechnicianAssignment(),
                const SizedBox(height: 24),
                _buildAlertsCompliance(),
                const SizedBox(height: 24),
                _buildTestCategories(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSampleTrackingBoard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sample Tracking Board',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 24),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  _sampleColumns
                      .map(
                        (column) => Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: _buildSampleColumn(column),
                        ),
                      )
                      .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSampleColumn(SampleColumn column) {
    return Container(
      width: 220,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: column.color,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              column.title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 12),
          ...column.samples.map(
            (sample) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildSampleCard(sample),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSampleCard(Sample sample) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sample.patientName,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            sample.testType,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          const SizedBox(height: 4),
          Text(
            sample.timeAgo,
            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
          ),
          const SizedBox(height: 8),
          Text(
            sample.labId,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6366F1),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechnicianAssignment() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Technician Assignment',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          ..._technicians.map(
            (tech) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildTechnicianCard(tech),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechnicianCard(Technician tech) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.grey[300],
          child: const Icon(Icons.person, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tech.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Text(
                '${tech.testsAssigned} tests assigned',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: tech.workload,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF6366F1),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6366F1),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: const Text('Reassign', style: TextStyle(fontSize: 12)),
        ),
      ],
    );
  }

  Widget _buildAlertsCompliance() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Alerts & Compliance',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          ..._alerts.map(
            (alert) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildAlertCard(alert),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertCard(AlertItem alert) {
    Color backgroundColor;
    Color iconColor;
    IconData icon;

    switch (alert.type) {
      case AlertType.critical:
        backgroundColor = Colors.red[50]!;
        iconColor = Colors.red;
        icon = Icons.error;
        break;
      case AlertType.warning:
        backgroundColor = Colors.orange[50]!;
        iconColor = Colors.orange;
        icon = Icons.warning;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: iconColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: iconColor.withOpacity(0.8),
                  ),
                ),
                Text(
                  alert.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: iconColor.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestCategories() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Test Categories',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          ..._testCategories.map(
            (category) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildTestCategoryItem(category),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestCategoryItem(TestCategory category) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category.name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            Text(
              category.turnaround,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        Switch(
          value: category.isEnabled,
          onChanged: (value) {
            setState(() {
              category.isEnabled = value;
            });
          },
          activeColor: const Color(0xFF6366F1),
        ),
      ],
    );
  }
}

// Models
class StatCard {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });
}

class SampleColumn {
  final String title;
  final Color color;
  final List<Sample> samples;

  SampleColumn({
    required this.title,
    required this.color,
    required this.samples,
  });
}

class Sample {
  final String patientName;
  final String testType;
  final String timeAgo;
  final String labId;

  Sample({
    required this.patientName,
    required this.testType,
    required this.timeAgo,
    required this.labId,
  });
}

class Technician {
  final String name;
  final int testsAssigned;
  final String avatar;
  final double workload;

  Technician({
    required this.name,
    required this.testsAssigned,
    required this.avatar,
    required this.workload,
  });
}

class AlertItem {
  final AlertType type;
  final String title;
  final String description;

  AlertItem({
    required this.type,
    required this.title,
    required this.description,
  });
}

enum AlertType { critical, warning }

class TestCategory {
  final String name;
  final String turnaround;
  bool isEnabled;

  TestCategory({
    required this.name,
    required this.turnaround,
    required this.isEnabled,
  });
}
