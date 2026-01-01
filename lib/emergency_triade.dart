import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';



class TriageSystemScreen extends StatefulWidget {
  const TriageSystemScreen({super.key});

  @override
  State<TriageSystemScreen> createState() => _TriageSystemScreenState();
}

class _TriageSystemScreenState extends State<TriageSystemScreen> {
  String selectedGender = 'Male';
  String selectedDoctor = 'Dr. Smith';
  String selectedRoom = 'Trauma 1';
  String selectedTriage = 'Red - Immediate';
  bool showCriticalOnly = false;

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _complaintController = TextEditingController();
  final TextEditingController _bpController = TextEditingController();
  final TextEditingController _pulseController = TextEditingController();
  final TextEditingController _rrController = TextEditingController();
  final TextEditingController _spo2Controller = TextEditingController();
  final TextEditingController _tempController = TextEditingController();
  final TextEditingController _gcsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF1A1D29),
        child: Column(
          children: [
            _buildHeader(),
            _buildStatsCards(),
            Expanded(
              child: Row(
                children: [
                  Expanded(flex: 1, child: _buildLeftPanel()),
                  Expanded(flex: 2, child: _buildRightPanel()),
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
      height: 60,
      color: const Color(0xFF2D3142),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(
              Icons.local_hospital,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'Emergency Triage System',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          const Icon(Icons.settings, color: Colors.grey),
          const SizedBox(width: 16),
          const Icon(Icons.notifications, color: Colors.grey),
          const SizedBox(width: 8),
          const Text('22:40:58', style: TextStyle(color: Colors.grey)),
          const SizedBox(width: 16),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _buildStatCard('Critical', '3', Colors.red),
          const SizedBox(width: 16),
          _buildStatCard('Very Urgent', '5', Colors.orange),
          const SizedBox(width: 16),
          _buildStatCard('Urgent', '8', Colors.yellow),
          const SizedBox(width: 16),
          _buildStatCard('Less Urgent', '12', Colors.green),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2D3142),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  count,
                  style: TextStyle(
                    color: color,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftPanel() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2D3142),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.person_add, color: Colors.blue, size: 20),
              SizedBox(width: 8),
              Text(
                'Patient Intake',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSearchSection(),
          const SizedBox(height: 16),
          _buildPatientForm(),
          const SizedBox(height: 16),
          _buildVitalSigns(),
          const SizedBox(height: 16),
          _buildTriageLevel(),
          const SizedBox(height: 16),
          _buildAssignSection(),
          const Spacer(),
          _buildAddButton(),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Search Patient',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A1D29),
            borderRadius: BorderRadius.circular(4),
          ),
          child: TextField(
            controller: _searchController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'MRN or Name',
              hintStyle: const TextStyle(color: Colors.grey),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(12),
              suffixIcon: Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(Icons.search, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPatientForm() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildTextField('First Name', _firstNameController),
            ),
            const SizedBox(width: 8),
            Expanded(child: _buildTextField('Last Name', _lastNameController)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _buildTextField('Age', _ageController)),
            const SizedBox(width: 8),
            Expanded(
              child: _buildDropdown(
                'Gender',
                selectedGender,
                ['Male', 'Female'],
                (value) {
                  setState(() => selectedGender = value!);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Chief Complaint',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Container(
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF1A1D29),
                borderRadius: BorderRadius.circular(4),
              ),
              child: TextField(
                controller: _complaintController,
                maxLines: 3,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Primary reason for visit...',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVitalSigns() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Vital Signs',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _buildVitalField('BP (120/80)', _bpController)),
            const SizedBox(width: 8),
            Expanded(child: _buildVitalField('Pulse (72)', _pulseController)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _buildVitalField('RR (16)', _rrController)),
            const SizedBox(width: 8),
            Expanded(child: _buildVitalField('SpO2 (98%)', _spo2Controller)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _buildVitalField('Temp (98.6°F)', _tempController)),
            const SizedBox(width: 8),
            Expanded(child: _buildVitalField('GCS (15)', _gcsController)),
          ],
        ),
      ],
    );
  }

  Widget _buildTriageLevel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Triage Level',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        const SizedBox(height: 8),
        _buildTriageOption('Red - Immediate', Colors.red),
        _buildTriageOption('Orange - Very Urgent', Colors.orange),
        _buildTriageOption('Yellow - Urgent', Colors.yellow),
        _buildTriageOption('Green - Less Urgent', Colors.green),
      ],
    );
  }

  Widget _buildTriageOption(String label, Color color) {
    bool isSelected = selectedTriage == label;
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 2),
        borderRadius: BorderRadius.circular(4),
        color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
      ),
      child: RadioListTile<String>(
        title: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
        value: label,
        groupValue: selectedTriage,
        onChanged: (value) => setState(() => selectedTriage = value!),
        activeColor: color,
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      ),
    );
  }

  Widget _buildAssignSection() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Assign Doctor',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              const SizedBox(height: 8),
              _buildDropdown(
                'Doctor',
                selectedDoctor,
                ['Dr. Smith', 'Dr. Johnson', 'Dr. Wilson'],
                (value) {
                  setState(() => selectedDoctor = value!);
                },
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Room/Area',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              const SizedBox(height: 8),
              _buildDropdown(
                'Room',
                selectedRoom,
                ['Trauma 1', 'Trauma 2', 'ER 1', 'ER 2'],
                (value) {
                  setState(() => selectedRoom = value!);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton() {
    return Container(
      width: double.infinity,
      height: 45,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(4),
      ),
      child: TextButton(
        onPressed: () {},
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Add to Queue',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRightPanel() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildActiveQueue(),
          const SizedBox(height: 16),
          Expanded(
            child: Row(
              children: [
                Expanded(child: _buildTriageDistribution()),
                const SizedBox(width: 16),
                Expanded(child: _buildWaitTimes()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveQueue() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2D3142),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Active Queue',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () => setState(() => showCriticalOnly = false),
                    child: Text(
                      'All',
                      style: TextStyle(
                        color: showCriticalOnly ? Colors.grey : Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => setState(() => showCriticalOnly = true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color:
                            showCriticalOnly ? Colors.red : Colors.transparent,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Critical',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildQueueItem(
            'John Smith',
            'Chest Pain',
            Colors.red,
            'Trauma 1',
            '8 mins',
          ),
          _buildQueueItem(
            'Sarah Johnson',
            'Severe Headache',
            Colors.orange,
            'Bed 3',
            '8 mins',
          ),
          _buildQueueItem(
            'Mike Davis',
            'Abdominal Pain',
            Colors.orange,
            'Waiting',
            '25 mins',
          ),
          _buildQueueItem(
            'Lisa Wilson',
            'Minor Cut',
            Colors.green,
            'Fast Track',
            '12 mins',
          ),
        ],
      ),
    );
  }

  Widget _buildQueueItem(
    String name,
    String complaint,
    Color color,
    String location,
    String time,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D29),
        borderRadius: BorderRadius.circular(4),
        border: Border(left: BorderSide(color: color, width: 4)),
      ),
      child: Row(
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
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  complaint,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                location,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
              Text(
                time,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTriageDistribution() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2D3142),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Triage Distribution',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    value: 3,
                    color: Colors.red,
                    radius: 50,
                    showTitle: false,
                  ),
                  PieChartSectionData(
                    value: 5,
                    color: Colors.orange,
                    radius: 50,
                    showTitle: false,
                  ),
                  PieChartSectionData(
                    value: 8,
                    color: Colors.yellow,
                    radius: 50,
                    showTitle: false,
                  ),
                  PieChartSectionData(
                    value: 12,
                    color: Colors.green,
                    radius: 50,
                    showTitle: false,
                  ),
                ],
                sectionsSpace: 2,
                centerSpaceRadius: 30,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildLegendItem('Critical', Colors.red),
        _buildLegendItem('Very Urgent', Colors.orange),
        _buildLegendItem('Urgent', Colors.yellow),
        _buildLegendItem('Less Urgent', Colors.green),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Column(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10)),
      ],
    );
  }

  Widget _buildWaitTimes() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2D3142),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Wait Times',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 50,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        switch (value.toInt()) {
                          case 0:
                            return const Text(
                              'Red',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                              ),
                            );
                          case 1:
                            return const Text(
                              'Orange',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                              ),
                            );
                          case 2:
                            return const Text(
                              'Yellow',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                              ),
                            );
                          case 3:
                            return const Text(
                              'Green',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                              ),
                            );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barRods: [
                      BarChartRodData(toY: 5, color: Colors.red, width: 20),
                    ],
                  ),
                  BarChartGroupData(
                    x: 1,
                    barRods: [
                      BarChartRodData(toY: 15, color: Colors.orange, width: 20),
                    ],
                  ),
                  BarChartGroupData(
                    x: 2,
                    barRods: [
                      BarChartRodData(toY: 30, color: Colors.yellow, width: 20),
                    ],
                  ),
                  BarChartGroupData(
                    x: 3,
                    barRods: [
                      BarChartRodData(toY: 45, color: Colors.green, width: 20),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
        const SizedBox(height: 4),
        Container(
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1D29),
            borderRadius: BorderRadius.circular(4),
          ),
          child: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVitalField(
    String placeholder,
    TextEditingController controller,
  ) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D29),
        borderRadius: BorderRadius.circular(4),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: placeholder,
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    String value,
    List<String> options,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
        const SizedBox(height: 4),
        Container(
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1D29),
            borderRadius: BorderRadius.circular(4),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
            dropdownColor: const Color(0xFF1A1D29),
            style: const TextStyle(color: Colors.white),
            items:
                options.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
