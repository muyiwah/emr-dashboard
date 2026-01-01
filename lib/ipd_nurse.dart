import 'package:flutter/material.dart';


class NurseStationDashboard extends StatefulWidget {
  const NurseStationDashboard({Key? key}) : super(key: key);

  @override
  State<NurseStationDashboard> createState() => _NurseStationDashboardState();
}

class _NurseStationDashboardState extends State<NurseStationDashboard> {
  String selectedBeds = 'All Beds';
  String selectedConditions = 'All Conditions';
  String selectedView = 'Cards';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 280,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4F46E5),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.local_hospital,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'IPD Nurse Station',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          Text(
                            'Ward 3A - General Medicine',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Active Alerts
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.warning,
                            color: Color(0xFFF59E0B),
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Active Alerts (3)',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Critical Vitals Alert
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF2F2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFFECACA)),
                        ),
                        child: Row(
                          children: [
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Critical Vitals',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFFDC2626),
                                    ),
                                  ),
                                  Text(
                                    'Bed 12 - BP 180/110',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF991B1B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                'Dismiss',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFFDC2626),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Medication Overdue Alert
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFFDE68A)),
                        ),
                        child: Row(
                          children: [
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Medication Overdue',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFFD97706),
                                    ),
                                  ),
                                  Text(
                                    'Bed 8 - Insulin 30min late',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF92400E),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                'Dismiss',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFFD97706),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Discharge Ready Alert
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFDF7),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFA7F3D0)),
                        ),
                        child: Row(
                          children: [
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Discharge Ready',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF059669),
                                    ),
                                  ),
                                  Text(
                                    'Bed 5 - Awaiting paperwork',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF047857),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                'Dismiss',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF059669),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Today's Tasks
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.task_alt,
                            color: Color(0xFF4F46E5),
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "Today's Tasks (8)",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Task Items
                      _buildTaskItem(
                        'Wound dressing - Bed 12',
                        false,
                        'Pending',
                      ),
                      _buildTaskItem('Catheter care - Bed 7', true, 'Done'),
                      _buildTaskItem(
                        'Physical therapy - Bed 3',
                        false,
                        'Pending',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Shift Metrics
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Shift Metrics',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Medication Completion',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Task Status',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: Column(
              children: [
                // Top Bar
                Container(
                  padding: const EdgeInsets.all(20),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Patient Dashboard',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4F46E5),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Day 06:00-18:00',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.dark_mode_outlined),
                          ),
                          const SizedBox(width: 12),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: const Color(0xFF10B981),
                                child: const Text(
                                  'SJ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Sarah Johnson, RN',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Filters
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  color: Colors.white,
                  child: Row(
                    children: [
                      _buildDropdown('All Beds', selectedBeds, (value) {
                        setState(() {
                          selectedBeds = value!;
                        });
                      }),
                      const SizedBox(width: 16),
                      _buildDropdown('All Conditions', selectedConditions, (
                        value,
                      ) {
                        setState(() {
                          selectedConditions = value!;
                        });
                      }),
                      const Spacer(),
                      Row(
                        children: [
                          _buildViewToggle('Cards', selectedView == 'Cards'),
                          _buildViewToggle('Table', selectedView == 'Table'),
                        ],
                      ),
                    ],
                  ),
                ),

                // Patient Cards
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildPatientCard(
                                'John Miller',
                                'Bed 12',
                                68,
                                'Critical',
                                'Pneumonia, Hypertension',
                                '180/110',
                                95,
                                '101.2°F',
                                '94%',
                                const Color(0xFFDC2626),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildPatientCard(
                                'Emma Davis',
                                'Bed 8',
                                45,
                                'Stable',
                                'Post-surgical recovery',
                                '120/80',
                                72,
                                '98.6°F',
                                '98%',
                                const Color(0xFF10B981),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildPatientCard(
                                'Robert Chen',
                                'Bed 5',
                                52,
                                'Discharge Ready',
                                'Appendectomy recovery',
                                '118/75',
                                68,
                                '98.4°F',
                                '99%',
                                const Color(0xFF06B6D4),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Medication Administration Record
                        Container(
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
                                'Medication Administration Record',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Table Header
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Color(0xFFE5E7EB),
                                    ),
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
                                          color: Color(0xFF6B7280),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'MEDICATION',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF6B7280),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'DUE TIME',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF6B7280),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        'STATUS',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF6B7280),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        'ACTION',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF6B7280),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Table Rows
                              _buildMedicationRow(
                                'Bed 8 - Emma Davis',
                                'Insulin 10 units',
                                '14:00 (30min overdue)',
                                'Overdue',
                                true,
                              ),
                              _buildMedicationRow(
                                'Bed 12 - John Miller',
                                'Lisinopril 10mg',
                                '15:00',
                                'Due Soon',
                                false,
                              ),
                            ],
                          ),
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
    );
  }

  Widget _buildTaskItem(String title, bool isCompleted, String status) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Checkbox(
            value: isCompleted,
            onChanged: (value) {},
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color:
                    isCompleted
                        ? const Color(0xFF6B7280)
                        : const Color(0xFF1F2937),
                decoration: isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color:
                  isCompleted
                      ? const Color(0xFF10B981)
                      : const Color(0xFFF59E0B),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              status,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(
    String hint,
    String value,
    ValueChanged<String?> onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD1D5DB)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          items:
              [hint]
                  .map(
                    (item) => DropdownMenuItem(
                      value: item,
                      child: Text(item, style: const TextStyle(fontSize: 14)),
                    ),
                  )
                  .toList(),
          onChanged: onChanged,
          icon: const Icon(Icons.keyboard_arrow_down, size: 16),
        ),
      ),
    );
  }

  Widget _buildViewToggle(String text, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedView = text;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4F46E5) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFFD1D5DB)),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: isSelected ? Colors.white : const Color(0xFF6B7280),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildPatientCard(
    String name,
    String bed,
    int age,
    String status,
    String diagnosis,
    String bp,
    int hr,
    String temp,
    String spo2,
    Color statusColor,
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
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: statusColor.withOpacity(0.1),
                child: Text(
                  name.split(' ').map((n) => n[0]).join(''),
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
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
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    Text(
                      '$bed | Age $age',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Diagnosis: $diagnosis',
            style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'BP: $bp',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Temp: $temp',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'HR: $hr',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'SpO₂: $spo2',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F46E5),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    'Vitals',
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF06B6D4),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    'Meds',
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF374151),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    'Notes',
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMedicationRow(
    String patient,
    String medication,
    String dueTime,
    String status,
    bool isOverdue,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              patient,
              style: const TextStyle(fontSize: 13, color: Color(0xFF1F2937)),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              medication,
              style: const TextStyle(fontSize: 13, color: Color(0xFF1F2937)),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              dueTime,
              style: const TextStyle(fontSize: 13, color: Color(0xFF1F2937)),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color:
                    isOverdue
                        ? const Color(0xFFDC2626)
                        : const Color(0xFFF59E0B),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                status,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isOverdue
                        ? const Color(0xFFDC2626)
                        : const Color(0xFF4F46E5),
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: Text(
                isOverdue ? 'Give Now' : 'Give',
                style: const TextStyle(fontSize: 11, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
