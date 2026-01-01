import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';


class DoctorRoundsScreen extends StatefulWidget {
  const DoctorRoundsScreen({super.key});

  @override
  State<DoctorRoundsScreen> createState() => _DoctorRoundsScreenState();
}

class _DoctorRoundsScreenState extends State<DoctorRoundsScreen> {
  String selectedTab = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Panel
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    _buildFilters(),
                    const SizedBox(height: 32),
                    _buildStatsCards(),
                    const SizedBox(height: 32),
                    _buildPatientRounds(),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              // Right Panel
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    _buildMissedRounds(),
                    const SizedBox(height: 24),
                    _buildRoundMetrics(),
                  ],
                ),
              ),
            ],
          ),
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
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: Color(0xFF6366F1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.local_hospital,
            color: Colors.white,
            size: 18,
          ),
        ),
        const SizedBox(width: 12),
        const Text(
          'Doctor Rounds Tracker',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        const Spacer(),
        const Text(
          'Current Shift: Day (7:00 AM - 7:00 PM)',
          style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
        ),
        const SizedBox(width: 12),
        CircleAvatar(
          radius: 16,
          backgroundColor: Colors.orange,
          child: const Text(
            'JD',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilters() {
    return Row(
      children: [
        _buildDropdown('All Doctors'),
        const SizedBox(width: 16),
        _buildDropdown('All Wards'),
        const SizedBox(width: 16),
        _buildDropdown('Current Shift'),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.filter_list, color: Colors.white, size: 16),
          label: const Text('Apply Filters'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6366F1),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE2E8F0)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: const TextStyle(fontSize: 14, color: Color(0xFF475569)),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.keyboard_arrow_down,
            color: Color(0xFF94A3B8),
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    return Row(
      children: [
        _buildStatCard(
          'Patients\nAssigned',
          '18',
          Icons.people,
          const Color(0xFF3B82F6),
        ),
        const SizedBox(width: 16),
        _buildStatCard(
          'Seen',
          '12',
          Icons.check_circle,
          const Color(0xFF10B981),
        ),
        const SizedBox(width: 16),
        _buildStatCard('Missed', '3', Icons.cancel, const Color(0xFFEF4444)),
        const SizedBox(width: 16),
        _buildStatCard('Critical', '2', Icons.warning, const Color(0xFFEF4444)),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String count,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              count,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientRounds() {
    return Expanded(
      child: Container(
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
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Patient Rounds',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildTab('All', selectedTab == 'All'),
                      const SizedBox(width: 8),
                      _buildTab('Pending', selectedTab == 'Pending'),
                      const SizedBox(width: 8),
                      _buildTab('Completed', selectedTab == 'Completed'),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildPatientCard(
                    'Sarah Johnson',
                    'MRN: 12345 • Room 204A • Bed 1',
                    'BP: 120/80   HR: 72   Temp: 98.6°F',
                    ['Pending Labs', 'Seen'],
                    'assets/patient1.jpg',
                  ),
                  _buildPatientCard(
                    'Robert Martinez',
                    'MRN: 67890 • Room 301B • Bed 2',
                    'BP: 140/90   HR: 95   Temp: 101.2°F',
                    ['Post-Op', 'Critical'],
                    'assets/patient2.jpg',
                  ),
                  _buildPatientCard(
                    'Emily Davis',
                    'MRN: 11223 • Room 105C • Bed 1',
                    'BP: 110/70   HR: 68   Temp: 97.8°F',
                    ['New Admission', 'Pending'],
                    'assets/patient3.jpg',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String title, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6366F1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }

  Widget _buildPatientCard(
    String name,
    String details,
    String vitals,
    List<String> tags,
    String imagePath,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[300],
                child: Text(
                  name.split(' ').map((e) => e[0]).join(''),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF64748B),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      details,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      vitals,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              Row(children: tags.map((tag) => _buildTag(tag)).toList()),
              const SizedBox(width: 8),
              const Icon(Icons.keyboard_arrow_down, color: Color(0xFF94A3B8)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text) {
    Color backgroundColor;
    Color textColor;

    switch (text) {
      case 'Seen':
        backgroundColor = const Color(0xFFDCFCE7);
        textColor = const Color(0xFF16A34A);
        break;
      case 'Critical':
        backgroundColor = const Color(0xFFFEE2E2);
        textColor = const Color(0xFFDC2626);
        break;
      case 'Pending':
        backgroundColor = const Color(0xFFFEF3C7);
        textColor = const Color(0xFFD97706);
        break;
      case 'Pending Labs':
        backgroundColor = const Color(0xFFFEF3C7);
        textColor = const Color(0xFFD97706);
        break;
      case 'Post-Op':
        backgroundColor = const Color(0xFFE0E7FF);
        textColor = const Color(0xFF3730A3);
        break;
      case 'New Admission':
        backgroundColor = const Color(0xFFDCFCE7);
        textColor = const Color(0xFF16A34A);
        break;
      default:
        backgroundColor = const Color(0xFFF1F5F9);
        textColor = const Color(0xFF475569);
    }

    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildMissedRounds() {
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
            'Missed Rounds',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 16),
          _buildMissedRoundItem('James Wilson', 'Room 402A • In Surgery', 'JW'),
          const SizedBox(height: 12),
          _buildMissedRoundItem('Lisa Brown', 'Room 208B • Discharged', 'LB'),
        ],
      ),
    );
  }

  Widget _buildMissedRoundItem(String name, String details, String initials) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: const Color(0xFF6366F1),
          child: Text(
            initials,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              Text(
                details,
                style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRoundMetrics() {
    return Expanded(
      child: Container(
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
              'Round Metrics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Patients Seen per Doctor',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(flex: 2, child: _buildBarChart()),
            const SizedBox(height: 24),
            const Text(
              'Round Completion',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(flex: 2, child: _buildPieChart()),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 16,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                const style = TextStyle(fontSize: 10, color: Color(0xFF64748B));
                switch (value.toInt()) {
                  case 0:
                    return const Text('Dr. Chen', style: style);
                  case 1:
                    return const Text('Dr. Rodriguez', style: style);
                  case 2:
                    return const Text('Dr. Smith', style: style);
                  case 3:
                    return const Text('Dr. Johnson', style: style);
                  default:
                    return const Text('');
                }
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 20,
              getTitlesWidget: (double value, TitleMeta meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF64748B),
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
        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                toY: 12,
                color: const Color(0xFF06B6D4),
                width: 20,
              ),
            ],
          ),
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(
                toY: 15,
                color: const Color(0xFF06B6D4),
                width: 20,
              ),
            ],
          ),
          BarChartGroupData(
            x: 2,
            barRods: [
              BarChartRodData(
                toY: 8,
                color: const Color(0xFF06B6D4),
                width: 20,
              ),
            ],
          ),
          BarChartGroupData(
            x: 3,
            barRods: [
              BarChartRodData(
                toY: 10,
                color: const Color(0xFF06B6D4),
                width: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPieChart() {
    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 40,
        sections: [
          PieChartSectionData(
            color: const Color(0xFF10B981),
            value: 60,
            title: '',
            radius: 25,
          ),
          PieChartSectionData(
            color: const Color(0xFFEF4444),
            value: 15,
            title: '',
            radius: 25,
          ),
          PieChartSectionData(
            color: const Color(0xFFF59E0B),
            value: 25,
            title: '',
            radius: 25,
          ),
        ],
      ),
    );
  }
}
