import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';



class OperationalDashboard extends StatelessWidget {
  const OperationalDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildQuickFilters(),
              const SizedBox(height: 32),
              _buildTopMetrics(),
              const SizedBox(height: 32),
              _buildMainContent(),
            ],
          ),
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
            const Text(
              'Reports & Analytics',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.dashboard_outlined,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  'Operational Dashboard',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  'Last updated: 2 mins ago',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.download, size: 16),
              label: const Text('Export Report'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickFilters() {
    return Row(
      children: [
        const Text(
          'Quick Filters',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const Spacer(),
        _buildFilterDropdown('Today', ['Today', 'Yesterday', 'Last 7 days']),
        const SizedBox(width: 12),
        _buildFilterDropdown('All Departments', [
          'All Departments',
          'Emergency',
          'Surgery',
        ]),
        const SizedBox(width: 12),
        _buildFilterDropdown('Main Campus', [
          'Main Campus',
          'North Campus',
          'South Campus',
        ]),
      ],
    );
  }

  Widget _buildFilterDropdown(String value, List<String> items) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 14, color: Color(0xFF374151)),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.keyboard_arrow_down,
            size: 16,
            color: Color(0xFF9CA3AF),
          ),
        ],
      ),
    );
  }

  Widget _buildTopMetrics() {
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            icon: Icons.people_outline,
            title: '1,247',
            subtitle: 'Total Patients Today',
            change: '+12%',
            changeColor: Colors.green,
            iconColor: const Color(0xFF6366F1),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildMetricCard(
            icon: Icons.bed_outlined,
            title: '340/400',
            subtitle: 'Beds Occupied',
            change: '85%',
            changeColor: Colors.orange,
            iconColor: const Color(0xFF06B6D4),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildMetricCard(
            icon: Icons.calendar_today_outlined,
            title: '892',
            subtitle: 'Appointments Booked',
            change: '+8%',
            changeColor: Colors.green,
            iconColor: const Color(0xFF10B981),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildMetricCard(
            icon: Icons.sync_alt,
            title: '+14',
            subtitle: 'Admissions vs Discharges',
            change: '156/142',
            changeColor: Colors.red,
            iconColor: const Color(0xFF8B5CF6),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String change,
    required Color changeColor,
    required Color iconColor,
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              Text(
                change,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: changeColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  _buildLiveDepartmentalActivity(),
                  const SizedBox(height: 24),
                  _buildMostActiveSpecialties(),
                ],
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _buildReadmissionRate()),
                      const SizedBox(width: 16),
                      Expanded(child: _buildAverageLengthOfStay()),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(child: _buildCommonDiagnoses()),
                      const SizedBox(width: 16),
                      Expanded(child: _buildSafetyMetrics()),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(child: _buildERWaitTimeTrends()),
            const SizedBox(width: 24),
            Expanded(child: _buildTopProcedures()),
          ],
        ),
      ],
    );
  }

  Widget _buildLiveDepartmentalActivity() {
    return _buildCard(
      title: 'Live Departmental Activity',
      child: Column(
        children: [
          _buildActivityItem('ER Visits', 'Last hour', '23', Colors.red),
          const SizedBox(height: 16),
          _buildActivityItem('OR Utilization', 'Current', '78%', Colors.blue),
        ],
      ),
    );
  }

  Widget _buildActivityItem(
    String title,
    String subtitle,
    String value,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildMostActiveSpecialties() {
    return _buildCard(
      title: 'Most Active Specialties',
      child: Column(
        children: [
          _buildSpecialtyItem('Cardiology', 34, const Color(0xFF6366F1)),
          const SizedBox(height: 12),
          _buildSpecialtyItem('Orthopedics', 28, const Color(0xFF8B5CF6)),
          const SizedBox(height: 12),
          _buildSpecialtyItem('Neurology', 21, const Color(0xFF10B981)),
        ],
      ),
    );
  }

  Widget _buildSpecialtyItem(String name, int count, Color color) {
    return Row(
      children: [
        Expanded(
          child: Text(
            name,
            style: const TextStyle(fontSize: 14, color: Color(0xFF374151)),
          ),
        ),
        Container(
          width: 60,
          height: 4,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          count.toString(),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
      ],
    );
  }

  Widget _buildReadmissionRate() {
    return _buildCard(
      title: 'Readmission Rate',
      child: Container(
        height: 120,
        child: LineChart(
          LineChartData(
            gridData: FlGridData(show: false),
            titlesData: FlTitlesData(show: false),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: const [
                  FlSpot(0, 8),
                  FlSpot(1, 7),
                  FlSpot(2, 6.5),
                  FlSpot(3, 6),
                  FlSpot(4, 7),
                  FlSpot(5, 6),
                  FlSpot(6, 5),
                ],
                isCurved: true,
                color: const Color(0xFF6366F1),
                barWidth: 2,
                dotData: FlDotData(show: false),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAverageLengthOfStay() {
    return _buildCard(
      title: 'Average Length of Stay',
      child: Container(
        height: 120,
        child: BarChart(
          BarChartData(
            gridData: FlGridData(show: false),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    const titles = [
                      'Cardio',
                      'Surgery',
                      'ICU',
                      'Emergency',
                      'Ortho',
                    ];
                    return Text(
                      titles[value.toInt()],
                      style: const TextStyle(fontSize: 10),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(show: false),
            barGroups: [
              BarChartGroupData(
                x: 0,
                barRods: [
                  BarChartRodData(toY: 4, color: const Color(0xFF06B6D4)),
                ],
              ),
              BarChartGroupData(
                x: 1,
                barRods: [
                  BarChartRodData(toY: 7, color: const Color(0xFF06B6D4)),
                ],
              ),
              BarChartGroupData(
                x: 2,
                barRods: [
                  BarChartRodData(toY: 8, color: const Color(0xFF06B6D4)),
                ],
              ),
              BarChartGroupData(
                x: 3,
                barRods: [
                  BarChartRodData(toY: 2, color: const Color(0xFF06B6D4)),
                ],
              ),
              BarChartGroupData(
                x: 4,
                barRods: [
                  BarChartRodData(toY: 6, color: const Color(0xFF06B6D4)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommonDiagnoses() {
    return _buildCard(
      title: 'Common Diagnoses',
      child: Container(
        height: 120,
        child: PieChart(
          PieChartData(
            sections: [
              PieChartSectionData(
                value: 35,
                color: const Color(0xFF6366F1),
                radius: 50,
              ),
              PieChartSectionData(
                value: 20,
                color: const Color(0xFF06B6D4),
                radius: 50,
              ),
              PieChartSectionData(
                value: 15,
                color: const Color(0xFF10B981),
                radius: 50,
              ),
              PieChartSectionData(
                value: 15,
                color: const Color(0xFFF59E0B),
                radius: 50,
              ),
              PieChartSectionData(
                value: 15,
                color: const Color(0xFFEF4444),
                radius: 50,
              ),
            ],
            centerSpaceRadius: 30,
            sectionsSpace: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildSafetyMetrics() {
    return _buildCard(
      title: 'Safety Metrics',
      child: Column(
        children: [
          _buildSafetyItem('HAIs Reported', '3', Colors.red),
          const SizedBox(height: 8),
          _buildSafetyItem('Incident Reports', '12', Colors.orange),
          const SizedBox(height: 8),
          _buildSafetyItem('Surgery Infections', '0', Colors.green),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, size: 16, color: Colors.green[600]),
                const SizedBox(width: 8),
                Text(
                  'Safety Score: 94%',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.green[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyItem(String title, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, color: Color(0xFF374151)),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildERWaitTimeTrends() {
    return _buildCard(
      title: 'ER Wait Time Trends',
      action: _buildExportButton(),
      child: Container(
        height: 200,
        child: LineChart(
          LineChartData(
            gridData: FlGridData(show: true, drawVerticalLine: false),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    const times = [
                      '6AM',
                      '9AM',
                      '12PM',
                      '3PM',
                      '6PM',
                      '9PM',
                      '12AM',
                    ];
                    if (value.toInt() < times.length) {
                      return Text(
                        times[value.toInt()],
                        style: const TextStyle(fontSize: 10),
                      );
                    }
                    return const Text('');
                  },
                ),
              ),
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: const [
                  FlSpot(0, 20),
                  FlSpot(1, 35),
                  FlSpot(2, 45),
                  FlSpot(3, 40),
                  FlSpot(4, 52),
                  FlSpot(5, 25),
                  FlSpot(6, 18),
                ],
                isCurved: true,
                color: const Color(0xFFEF4444),
                barWidth: 3,
                dotData: FlDotData(show: false),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopProcedures() {
    return _buildCard(
      title: 'Top Procedures',
      action: _buildExportButton(),
      child: Column(
        children: [
          _buildProcedureItem('Appendectomy', 0.9),
          const SizedBox(height: 8),
          _buildProcedureItem('Cataract Surgery', 0.8),
          const SizedBox(height: 8),
          _buildProcedureItem('Hip Replacement', 0.75),
          const SizedBox(height: 8),
          _buildProcedureItem('Cardiac Bypass', 0.6),
          const SizedBox(height: 8),
          _buildProcedureItem('Knee Surgery', 0.55),
        ],
      ),
    );
  }

  Widget _buildProcedureItem(String name, double progress) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            name,
            style: const TextStyle(fontSize: 14, color: Color(0xFF374151)),
          ),
        ),
        Expanded(
          flex: 3,
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
          ),
        ),
      ],
    );
  }

  Widget _buildExportButton() {
    return TextButton(
      onPressed: () {},
      child: const Text(
        'Export',
        style: TextStyle(fontSize: 12, color: Color(0xFF6366F1)),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required Widget child,
    Widget? action,
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
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              if (action != null) action,
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
