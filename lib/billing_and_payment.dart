import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BillingPaymentsScreen extends StatefulWidget {
  const BillingPaymentsScreen({Key? key}) : super(key: key);

  @override
  State<BillingPaymentsScreen> createState() => _BillingPaymentsScreenState();
}

class _BillingPaymentsScreenState extends State<BillingPaymentsScreen> {
  String selectedTimeFrame = 'Daily';
  String selectedDepartment = 'All Departments';
  String selectedInsuranceType = 'All Insurance Types';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            const Text(
              'Billing & Payments',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 40),
            _buildTabButton('Payment History', true),
            const SizedBox(width: 20),
            _buildTabButton('Outstanding Balances', false),
            const SizedBox(width: 20),
            _buildTabButton('Income Reports', false),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.grey),
            onPressed: () {},
          ),
          const SizedBox(width: 10),
          const CircleAvatar(
            radius: 16,
            // backgroundImage: NetworkImage('https://via.placeholder.com/32'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPatientPaymentHistory(),
            const SizedBox(height: 32),
            _buildOutstandingBalances(),
            const SizedBox(height: 32),
            _buildIncomeReporting(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF6366F1),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTabButton(String text, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF6366F1) : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.grey[600],
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildPatientPaymentHistory() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
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
                'Patient Payment History',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.file_download, size: 16),
                label: const Text('Export'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: 'Search patient by name or MRN...',
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildPatientCard(),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: () {},
              child: const Text(
                'View All Invoices →',
                style: TextStyle(
                  color: Color(0xFF6366F1),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
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
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Running Balance: \$0.00',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Account Current',
                    style: TextStyle(color: Colors.green[600], fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildPaymentItem(
            'Consultation Fee',
            'Jan 15, 2024',
            '\$150.00',
            'Credit Card',
            'Receipt #RC-001',
            Colors.green,
          ),
          const SizedBox(height: 12),
          _buildPaymentItem(
            'Lab Tests',
            'Jan 10, 2024',
            '\$85.00',
            'Bank Transfer',
            'Receipt #RC-002',
            Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentItem(
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
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: iconColor, shape: BoxShape.circle),
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
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
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
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            Text(
              receipt,
              style: TextStyle(color: Colors.blue[600], fontSize: 10),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOutstandingBalances() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
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
                'Outstanding Balances & Debt Tracker',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.send, size: 16),
                label: const Text('Send Reminders'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildDropdown(selectedDepartment, ['All Departments']),
              const SizedBox(width: 16),
              _buildDropdown(selectedInsuranceType, ['All Insurance Types']),
            ],
          ),
          const SizedBox(height: 24),
          _buildDebtTable(),
        ],
      ),
    );
  }

  Widget _buildDropdown(String value, List<String> items) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Text(value),
          const SizedBox(width: 8),
          const Icon(Icons.keyboard_arrow_down, size: 16),
        ],
      ),
    );
  }

  Widget _buildDebtTable() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: const Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  'PATIENT',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'MRN',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'TOTAL DEBT',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'LAST PAYMENT',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'STATUS',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'ACTIONS',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
        _buildDebtRow(
          'John Smith',
          'MRN-2024-002',
          '\$1,250.00',
          'Dec 15, 2023',
          'Critical Debt',
          Colors.red,
        ),
        _buildDebtRow(
          'Maria Garcia',
          'MRN-2024-003',
          '\$450.00',
          'Jan 01, 2024',
          '5+ Days Overdue',
          Colors.orange,
        ),
      ],
    );
  }

  Widget _buildDebtRow(
    String name,
    String mrn,
    String debt,
    String lastPayment,
    String status,
    Color statusColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.grey[300],
                  child: Text(name[0], style: const TextStyle(fontSize: 12)),
                ),
                const SizedBox(width: 8),
                Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          Expanded(child: Text(mrn, style: TextStyle(color: Colors.grey[600]))),
          Expanded(
            child: Text(
              debt,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(lastPayment, style: TextStyle(color: Colors.grey[600])),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: statusColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Send Reminder',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Make Payment',
                    style: TextStyle(fontSize: 12, color: Colors.green),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncomeReporting() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
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
                'Income Reporting Dashboard',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.file_download, size: 16),
                label: const Text('Export Report'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildTimeFrameButton('Daily', true),
              const SizedBox(width: 8),
              _buildTimeFrameButton('Weekly', false),
              const SizedBox(width: 8),
              _buildTimeFrameButton('Monthly', false),
              const SizedBox(width: 8),
              _buildTimeFrameButton('Yearly', false),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Collected',
                  '\$45,230',
                  Colors.blue,
                  Icons.trending_up,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Total Outstanding',
                  '\$12,450',
                  Colors.orange,
                  Icons.warning,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Avg Payment/Visit',
                  '\$285',
                  Colors.green,
                  Icons.calculate,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Top Department',
                  'Cardiology',
                  Colors.cyan,
                  Icons.emoji_events,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Income Trend',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(height: 200, child: _buildIncomeChart()),
                  ],
                ),
              ),
              const SizedBox(width: 32),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Payment Sources',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(height: 200, child: _buildPaymentSourcesChart()),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeFrameButton(String text, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTimeFrame = text;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6366F1) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected ? const Color(0xFF6366F1) : Colors.grey[300]!,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[600],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              Icon(icon, color: Colors.white, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncomeChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  '\$${(value.toInt())}',
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                return Text(
                  days[value.toInt() % days.length],
                  style: const TextStyle(fontSize: 10),
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
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 5000),
              FlSpot(1, 5200),
              FlSpot(2, 4800),
              FlSpot(3, 6000),
              FlSpot(4, 5800),
              FlSpot(5, 4000),
              FlSpot(6, 3000),
            ],
            isCurved: true,
            color: const Color(0xFF6366F1),
            barWidth: 3,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: const Color(0xFF6366F1).withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSourcesChart() {
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            color: const Color(0xFF6366F1),
            value: 40,
            title: '',
            radius: 60,
          ),
          PieChartSectionData(
            color: Colors.green,
            value: 25,
            title: '',
            radius: 60,
          ),
          PieChartSectionData(
            color: Colors.cyan,
            value: 20,
            title: '',
            radius: 60,
          ),
          PieChartSectionData(
            color: Colors.orange,
            value: 15,
            title: '',
            radius: 60,
          ),
        ],
        centerSpaceRadius: 40,
        sectionsSpace: 2,
      ),
    );
  }
}
