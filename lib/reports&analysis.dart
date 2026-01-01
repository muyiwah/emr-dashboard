import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';


class ReportAndAnalysis extends StatelessWidget {
  const ReportAndAnalysis({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF6366F1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.analytics, color: Colors.white, size: 20),
        ),
        title: const Text(
          'Cross-Facility Analytics',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: const Icon(Icons.notifications_outlined, color: Colors.grey),
          ),
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: const CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFF6366F1),
              child: Icon(Icons.person, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Reports & Analytics',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Monitor performance across all facilities',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: const [
                          Text('Last 30 Days', style: TextStyle(fontSize: 14)),
                          SizedBox(width: 8),
                          Icon(Icons.keyboard_arrow_down, size: 16),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.download, color: Colors.white, size: 16),
                          SizedBox(width: 8),
                          Text(
                            'Export',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Facility Cards
            Row(
              children: [
                Expanded(
                  child: _buildFacilityCard(
                    icon: Icons.local_hospital,
                    iconColor: const Color(0xFF6366F1),
                    statusColor: Colors.green,
                    title: 'Main Hospital',
                    subtitle: 'Downtown Campus',
                    patients: '1,247',
                    revenue: '\$2.8M',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildFacilityCard(
                    icon: Icons.location_on,
                    iconColor: const Color(0xFF06B6D4),
                    statusColor: Colors.green,
                    title: 'North Branch',
                    subtitle: 'Suburban Location',
                    patients: '892',
                    revenue: '\$1.9M',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildFacilityCard(
                    icon: Icons.public,
                    iconColor: const Color(0xFF10B981),
                    statusColor: Colors.orange,
                    title: 'South Clinic',
                    subtitle: 'Outpatient Only',
                    patients: '634',
                    revenue: '\$1.2M',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Charts Section
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: _buildMonthlyTrendsChart()),
                const SizedBox(width: 16),
                Expanded(child: _buildStaffAllocationChart()),
              ],
            ),
            const SizedBox(height: 24),

            // Metrics Row
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    icon: Icons.people,
                    iconColor: const Color(0xFF6366F1),
                    title: 'Patient Volume',
                    value: '2,773',
                    change: '↑ 12% vs last month',
                    changeColor: Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildMetricCard(
                    icon: Icons.trending_up,
                    iconColor: const Color(0xFF06B6D4),
                    title: 'Admission Rate',
                    value: '68%',
                    change: '↑ 5% vs last month',
                    changeColor: Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildMetricCard(
                    icon: Icons.attach_money,
                    iconColor: const Color(0xFF10B981),
                    title: 'Total Revenue',
                    value: '\$5.9M',
                    change: '↑ 8% vs last month',
                    changeColor: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Other Modules Section
            const Text(
              'Explore Other Modules',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildModuleCard(
                    icon: Icons.security,
                    iconColor: Colors.red,
                    title: 'Audit & Access Logs',
                    subtitle: 'Security & Compliance',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildModuleCard(
                    icon: Icons.psychology,
                    iconColor: const Color(0xFF6366F1),
                    title: 'Clinical Decision Support',
                    subtitle: 'AI Alerts & Warnings',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildModuleCard(
                    icon: Icons.phone_android,
                    iconColor: const Color(0xFF06B6D4),
                    title: 'Patient Portal',
                    subtitle: 'Mobile App Features',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildModuleCard(
                    icon: Icons.video_call,
                    iconColor: const Color(0xFF10B981),
                    title: 'Telemedicine',
                    subtitle: 'Virtual Visits',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFacilityCard({
    required IconData icon,
    required Color iconColor,
    required Color statusColor,
    required String title,
    required String subtitle,
    required String patients,
    required String revenue,
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
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patients,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const Text(
                    'Patients',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    revenue,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF06B6D4),
                    ),
                  ),
                  const Text(
                    'Revenue',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyTrendsChart() {
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
              const Text(
                'Monthly Activity Trends',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              Icon(Icons.trending_up, color: Colors.grey.shade400, size: 20),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawHorizontalLine: true,
                  drawVerticalLine: false,
                  horizontalInterval: 200,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(color: Colors.grey.shade200, strokeWidth: 1);
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        const style = TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        );
                        Widget text;
                        switch (value.toInt()) {
                          case 0:
                            text = const Text('Jan', style: style);
                            break;
                          case 1:
                            text = const Text('Feb', style: style);
                            break;
                          case 2:
                            text = const Text('Mar', style: style);
                            break;
                          case 3:
                            text = const Text('Apr', style: style);
                            break;
                          case 4:
                            text = const Text('May', style: style);
                            break;
                          case 5:
                            text = const Text('Jun', style: style);
                            break;
                          default:
                            text = const Text('', style: style);
                            break;
                        }
                        return SideTitleWidget(meta: TitleMeta(min: 3, max: 3, parentAxisSize: 33, axisPosition: 1, appliedInterval: 3, sideTitles: SideTitles(), formattedValue:'', axisSide: AxisSide.left, rotationQuarterTurns:DateTime.april),
                          child: text,
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 200,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.left,
                        );
                      },
                      reservedSize: 42,
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 5,
                minY: 500,
                maxY: 1500,
                lineBarsData: [
                  // Main Hospital
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 1200),
                      FlSpot(1, 1150),
                      FlSpot(2, 1300),
                      FlSpot(3, 1280),
                      FlSpot(4, 1400),
                      FlSpot(5, 1350),
                    ],
                    isCurved: true,
                    color: const Color(0xFF6366F1),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                  ),
                  // North Branch
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 800),
                      FlSpot(1, 750),
                      FlSpot(2, 900),
                      FlSpot(3, 880),
                      FlSpot(4, 950),
                      FlSpot(5, 920),
                    ],
                    isCurved: true,
                    color: const Color(0xFF06B6D4),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                  ),
                  // South Clinic
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 600),
                      FlSpot(1, 580),
                      FlSpot(2, 650),
                      FlSpot(3, 630),
                      FlSpot(4, 700),
                      FlSpot(5, 680),
                    ],
                    isCurved: true,
                    color: const Color(0xFF10B981),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem('Main Hospital', const Color(0xFF6366F1)),
              const SizedBox(width: 20),
              _buildLegendItem('North Branch', const Color(0xFF06B6D4)),
              const SizedBox(width: 20),
              _buildLegendItem('South Clinic', const Color(0xFF10B981)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildStaffAllocationChart() {
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
              const Text(
                'Staff Allocation by Branch',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              Icon(Icons.people, color: Colors.grey.shade400, size: 20),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sectionsSpace: 0,
                centerSpaceRadius: 60,
                sections: [
                  PieChartSectionData(
                    color: const Color(0xFF6366F1),
                    value: 45,
                    title: '',
                    radius: 30,
                  ),
                  PieChartSectionData(
                    color: const Color(0xFF06B6D4),
                    value: 30,
                    title: '',
                    radius: 30,
                  ),
                  PieChartSectionData(
                    color: const Color(0xFF10B981),
                    value: 25,
                    title: '',
                    radius: 30,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: [
              _buildPieLegendItem('Main Hospital', const Color(0xFF6366F1)),
              const SizedBox(height: 8),
              _buildPieLegendItem('North Branch', const Color(0xFF06B6D4)),
              const SizedBox(height: 8),
              _buildPieLegendItem('South Clinic', const Color(0xFF10B981)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPieLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required String change,
    required Color changeColor,
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
              Text(
                title,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            change,
            style: TextStyle(
              fontSize: 12,
              color: changeColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModuleCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
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
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
