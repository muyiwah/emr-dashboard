import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';


class LabTechnician extends StatefulWidget {
  const LabTechnician({super.key});

  @override
  State<LabTechnician> createState() => _LabTechnicianState();
}

class _LabTechnicianState extends State<LabTechnician> {
  final TextEditingController _searchController = TextEditingController();
  String selectedCategory = 'All Categories';
  String selectedStatus = 'All Status';
  String selectedPriority = 'All Priority';
  DateTime? selectedDate;

  final List<TestAssignment> testAssignments = [
    TestAssignment(
      patientName: 'John Smith',
      testName: 'Complete Blood Count',
      barcode: 'LAB001234',
      priority: TestPriority.stat,
      status: TestStatus.inProgress,
    ),
    TestAssignment(
      patientName: 'Sarah Johnson',
      testName: 'X-Ray Chest',
      barcode: 'RAD005678',
      priority: TestPriority.urgent,
      status: TestStatus.pending,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildFilters(),
                  const SizedBox(height: 24),
                  _buildAssignedTests(),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(child: _buildSampleTracker()),
                      const SizedBox(width: 16),
                      Expanded(child: _buildNotifications()),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(child: _buildDailyCompletedTests()),
                      const SizedBox(width: 16),
                      Expanded(child: _buildTestCategoriesDistribution()),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildMetrics(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome, Lab Technician',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Manage tests, track samples, and upload results efficiently.',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF4CAF50),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('View Assigned Tests'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search patient or test...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildDropdown('All Categories', selectedCategory, (value) {
            setState(() => selectedCategory = value!);
          }),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildDropdown('All Status', selectedStatus, (value) {
            setState(() => selectedStatus = value!);
          }),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildDropdown('All Priority', selectedPriority, (value) {
            setState(() => selectedPriority = value!);
          }),
        ),
        const SizedBox(width: 12),
        Container(
          height: 48,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: IconButton(
            onPressed: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
              );
              if (date != null) {
                setState(() => selectedDate = date);
              }
            },
            icon: const Icon(Icons.calendar_today),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(
    String hint,
    String value,
    ValueChanged<String?> onChanged,
  ) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          hint: Text(hint),
          items:
              [value]
                  .map(
                    (item) => DropdownMenuItem(value: item, child: Text(item)),
                  )
                  .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildAssignedTests() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Assigned Tests',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(1.5),
              3: FlexColumnWidth(1),
              4: FlexColumnWidth(1),
              5: FlexColumnWidth(1.5),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(color: Colors.grey[50]),
                children: const [
                  _TableHeader('PATIENT NAME'),
                  _TableHeader('TEST NAME'),
                  _TableHeader('BARCODE ID'),
                  _TableHeader('PRIORITY'),
                  _TableHeader('STATUS'),
                  _TableHeader('ACTIONS'),
                ],
              ),
              ...testAssignments.map(
                (test) => TableRow(
                  children: [
                    _TableCell(test.patientName),
                    _TableCell(test.testName),
                    _TableCell(test.barcode),
                    _TableCell('', child: _buildPriorityChip(test.priority)),
                    _TableCell('', child: _buildStatusChip(test.status)),
                    _TableCell('', child: _buildActionButton()),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSampleTracker() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sample Collection Tracker',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildTrackerItem('Sample collected from patient', true, 'Completed'),
          _buildTrackerItem('Barcode scanned and verified', false, 'Scan'),
          _buildTrackerItem('Label generated and attached', false, 'Print'),
        ],
      ),
    );
  }

  Widget _buildNotifications() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Notifications',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildNotificationItem(
            'Urgent Test Assignment',
            'New STAT blood work assigned',
            Colors.red,
            Icons.warning,
          ),
          _buildNotificationItem(
            'Sample Recollection',
            'Patient ID: 12345 needs new sample',
            Colors.orange,
            Icons.refresh,
          ),
          _buildNotificationItem(
            'System Update',
            'New reference ranges updated',
            Colors.blue,
            Icons.info,
          ),
        ],
      ),
    );
  }

  Widget _buildDailyCompletedTests() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Daily Completed Tests',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = [
                          'Mon',
                          'Tue',
                          'Wed',
                          'Thu',
                          'Fri',
                          'Sat',
                          'Sun',
                        ];
                        return Text(days[value.toInt() % 7]);
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
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 45),
                      FlSpot(1, 52),
                      FlSpot(2, 38),
                      FlSpot(3, 62),
                      FlSpot(4, 25),
                      FlSpot(5, 23),
                      FlSpot(6, 32),
                    ],
                    isCurved: true,
                    color: const Color(0xFF4CAF50),
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestCategoriesDistribution() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Test Categories Distribution',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 150,
                  child: PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          value: 40,
                          color: const Color(0xFF4CAF50),
                          title: '',
                          radius: 40,
                        ),
                        PieChartSectionData(
                          value: 25,
                          color: const Color(0xFF607D8B),
                          title: '',
                          radius: 40,
                        ),
                        PieChartSectionData(
                          value: 20,
                          color: const Color(0xFFFFC107),
                          title: '',
                          radius: 40,
                        ),
                        PieChartSectionData(
                          value: 15,
                          color: const Color(0xFFF44336),
                          title: '',
                          radius: 40,
                        ),
                      ],
                      sectionsSpace: 2,
                      centerSpaceRadius: 30,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLegendItem('Hematology', const Color(0xFF4CAF50)),
                  _buildLegendItem('Radiology', const Color(0xFF607D8B)),
                  _buildLegendItem('Urinalysis', const Color(0xFFFFC107)),
                  _buildLegendItem('Chemistry', const Color(0xFFF44336)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetrics() {
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            '2.5 hrs',
            'Average Turnaround Time',
            Icons.access_time,
            Colors.green,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildMetricCard(
            '47',
            'Tests Completed Today',
            Icons.check_circle,
            Colors.green,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildMetricCard(
            '12',
            'Pending Results',
            Icons.hourglass_empty,
            Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    String value,
    String label,
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
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            label,
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTrackerItem(String title, bool isCompleted, String actionText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Checkbox(
            value: isCompleted,
            onChanged: (value) {},
            activeColor: const Color(0xFF4CAF50),
          ),
          Expanded(child: Text(title)),
          if (!isCompleted)
            TextButton(
              onPressed: () {},
              child: Text(
                actionText,
                style: const TextStyle(color: Color(0xFF4CAF50)),
              ),
            ),
          if (isCompleted)
            const Icon(Icons.check_circle, color: Color(0xFF4CAF50)),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(
    String title,
    String subtitle,
    Color color,
    IconData icon,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey[600], fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildPriorityChip(TestPriority priority) {
    Color color;
    String text;

    switch (priority) {
      case TestPriority.stat:
        color = Colors.red;
        text = 'STAT';
        break;
      case TestPriority.urgent:
        color = Colors.orange;
        text = 'Urgent';
        break;
      case TestPriority.routine:
        color = Colors.blue;
        text = 'Routine';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStatusChip(TestStatus status) {
    Color color;
    String text;

    switch (status) {
      case TestStatus.pending:
        color = Colors.grey;
        text = 'Pending';
        break;
      case TestStatus.inProgress:
        color = Colors.orange;
        text = 'In Progress';
        break;
      case TestStatus.completed:
        color = Colors.green;
        text = 'Completed';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4CAF50),
        minimumSize: const Size(80, 32),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      child: const Text(
        'Enter Result',
        style: TextStyle(fontSize: 10, color: Colors.white),
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  final String text;

  const _TableHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
          color: Colors.grey[600],
        ),
      ),
    );
  }
}

class _TableCell extends StatelessWidget {
  final String text;
  final Widget? child;

  const _TableCell(this.text, {this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: child ?? Text(text, style: const TextStyle(fontSize: 12)),
    );
  }
}

class TestAssignment {
  final String patientName;
  final String testName;
  final String barcode;
  final TestPriority priority;
  final TestStatus status;

  TestAssignment({
    required this.patientName,
    required this.testName,
    required this.barcode,
    required this.priority,
    required this.status,
  });
}

enum TestPriority { stat, urgent, routine }

enum TestStatus { pending, inProgress, completed }
