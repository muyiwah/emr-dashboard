import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BillingPaymentsScreen2 extends StatefulWidget {
  const BillingPaymentsScreen2({Key? key}) : super(key: key);

  @override
  State<BillingPaymentsScreen2> createState() => _BillingPaymentsScreenState();
}

class _BillingPaymentsScreenState extends State<BillingPaymentsScreen2>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedReportTab = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Billing & Payments',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF5B5FE5),
          labelColor: const Color(0xFF5B5FE5),
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Payment History'),
            Tab(text: 'Outstanding Balances'),
            Tab(text: 'Income Reports'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPaymentHistoryTab(),
          _buildOutstandingBalancesTab(),
          _buildIncomeReportsTab(),
        ],
      ),
    );
  }

  Widget _buildPaymentHistoryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPatientPaymentHistory(),
          const SizedBox(height: 24),
          _buildOutstandingBalancesSection(),
          const SizedBox(height: 24),
          _buildIncomeReportingDashboard(),
        ],
      ),
    );
  }

  Widget _buildOutstandingBalancesTab() {
    return const Center(child: Text('Outstanding Balances Content'));
  }

  Widget _buildIncomeReportsTab() {
    return const Center(child: Text('Income Reports Content'));
  }

  Widget _buildPatientPaymentHistory() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Patient Payment History',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download, size: 16),
                label: const Text('Export'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5B5FE5),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search patient by name or MRN...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sarah Johnson',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'MRN: MRN-2024-001',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Running Balance: \$0.00',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Account Current',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildPaymentHistoryItem(
            'Consultation Fee',
            'Jan 15, 2024',
            '\$150.00',
            'Credit Card',
            'Receipt #RC-001',
            Colors.green,
          ),
          const SizedBox(height: 12),
          _buildPaymentHistoryItem(
            'Lab Tests',
            'Jan 10, 2024',
            '\$85.00',
            'Bank Transfer',
            'Receipt #RC-002',
            Colors.blue,
          ),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: () {},
              child: const Text(
                'View All Invoices →',
                style: TextStyle(
                  color: Color(0xFF5B5FE5),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentHistoryItem(
    String title,
    String date,
    String amount,
    String method,
    String receipt,
    Color iconColor,
  ) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.receipt, color: iconColor, size: 20),
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
                ),
              ),
              Text(
                date,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              amount,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            Text(
              method,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            Text(
              receipt,
              style: TextStyle(fontSize: 10, color: Colors.blue.shade600),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOutstandingBalancesSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Outstanding Balances & Debt Tracker',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.send, size: 16),
                label: const Text('Send Reminders'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5B5FE5),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildDropdown('All Departments'),
              const SizedBox(width: 12),
              _buildDropdown('All Insurance Types'),
            ],
          ),
          const SizedBox(height: 20),
          _buildOutstandingBalanceHeader(),
          const SizedBox(height: 12),
          _buildOutstandingBalanceItem(
            'John Smith',
            'MRN-2024-002',
            '\$1,250.00',
            'Dec 15, 2023',
            'Critical Debt',
            Colors.red,
          ),
          const SizedBox(height: 12),
          _buildOutstandingBalanceItem(
            'Maria Garcia',
            'MRN-2024-003',
            '\$450.00',
            'Jan 01, 2024',
            '30 Days Overdue',
            Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 8),
          const Icon(Icons.keyboard_arrow_down, size: 16),
        ],
      ),
    );
  }

  Widget _buildOutstandingBalanceHeader() {
    return Row(
      children: [
        const Expanded(
          flex: 2,
          child: Text(
            'PATIENT',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ),
        const Expanded(
          flex: 1,
          child: Text(
            'MRN',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ),
        const Expanded(
          flex: 1,
          child: Text(
            'TOTAL DEBT',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ),
        const Expanded(
          flex: 1,
          child: Text(
            'LAST PAYMENT',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ),
        const Expanded(
          flex: 1,
          child: Text(
            'STATUS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ),
        const Expanded(
          flex: 2,
          child: Text(
            'ACTIONS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOutstandingBalanceItem(
    String name,
    String mrn,
    String debt,
    String lastPayment,
    String status,
    Color statusColor,
  ) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.grey.shade300,
                child: Text(
                  name.substring(0, 1),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(mrn, style: const TextStyle(fontSize: 14)),
        ),
        Expanded(
          flex: 1,
          child: Text(
            debt,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(lastPayment, style: const TextStyle(fontSize: 14)),
        ),
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 12,
                color: statusColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Row(
            children: [
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Send Reminder',
                  style: TextStyle(color: Color(0xFF5B5FE5)),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Make Payment',
                  style: TextStyle(color: Color(0xFF5B5FE5)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIncomeReportingDashboard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Income Reporting Dashboard',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download, size: 16),
                label: const Text('Export Report'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5B5FE5),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildReportTab('Daily', 0),
              _buildReportTab('Weekly', 1),
              _buildReportTab('Monthly', 2),
              _buildReportTab('Yearly', 3),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatsCard(
                  'Total Collected',
                  '\$45,230',
                  Colors.blue,
                  Icons.trending_up,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatsCard(
                  'Total Outstanding',
                  '\$12,450',
                  Colors.orange,
                  Icons.warning,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatsCard(
                  'Avg Payment/Visit',
                  '\$285',
                  Colors.green,
                  Icons.assessment,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatsCard(
                  'Top Department',
                  'Cardiology',
                  Colors.cyan,
                  Icons.emoji_events,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(flex: 2, child: _buildIncomeChart()),
              const SizedBox(width: 20),
              Expanded(flex: 1, child: _buildPaymentSourcesChart()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReportTab(String text, int index) {
    bool isSelected = _selectedReportTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedReportTab = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF5B5FE5) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF5B5FE5) : Colors.grey.shade300,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
              Icon(Icons.more_vert, color: Colors.grey.shade400, size: 16),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncomeChart() {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Income Trend',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true, drawVerticalLine: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '\$${(value / 1000).toInt()}k',
                          style: const TextStyle(fontSize: 10),
                        );
                      },
                    ),
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
                        return Text(
                          days[value.toInt() % days.length],
                          style: const TextStyle(fontSize: 10),
                        );
                      },
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 5000),
                      FlSpot(1, 5200),
                      FlSpot(2, 4800),
                      FlSpot(3, 6000),
                      FlSpot(4, 6200),
                      FlSpot(5, 5800),
                      FlSpot(6, 3000),
                    ],
                    isCurved: true,
                    color: const Color(0xFF5B5FE5),
                    barWidth: 3,
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xFF5B5FE5).withOpacity(0.1),
                    ),
                    dotData: FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSourcesChart() {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Sources',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    value: 40,
                    color: const Color(0xFF5B5FE5),
                    radius: 60,
                    showTitle: false,
                  ),
                  PieChartSectionData(
                    value: 25,
                    color: Colors.green,
                    radius: 60,
                    showTitle: false,
                  ),
                  PieChartSectionData(
                    value: 20,
                    color: Colors.cyan,
                    radius: 60,
                    showTitle: false,
                  ),
                  PieChartSectionData(
                    value: 15,
                    color: Colors.orange,
                    radius: 60,
                    showTitle: false,
                  ),
                ],
                centerSpaceRadius: 40,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: [
              _buildLegendItem('Insurance', const Color(0xFF5B5FE5)),
              _buildLegendItem('Cash', Colors.green),
              _buildLegendItem('Credit Card', Colors.cyan),
              _buildLegendItem('Bank Transfer', Colors.orange),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
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
}
