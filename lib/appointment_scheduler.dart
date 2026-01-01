import 'package:flutter/material.dart';


class AppointmentSchedulerScreen extends StatefulWidget {
  const AppointmentSchedulerScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentSchedulerScreen> createState() =>
      _AppointmentSchedulerScreenState();
}

class _AppointmentSchedulerScreenState
    extends State<AppointmentSchedulerScreen> {
  String selectedView = 'Week';
  String selectedDoctor = 'All Doctors';
  String selectedDepartment = 'All Departments';
  DateTime selectedDate = DateTime(2023, 11, 13);

  final List<String> timeSlots = ['9:00 AM', '10:00 AM', '11:00 AM'];
  final List<String> days = [
    'Mon 13',
    'Tue 14',
    'Wed 15',
    'Thu 16',
    'Fri 17',
    'Sat 18',
    'Sun 19',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Row(
        children: [
          // Left Sidebar
          Container(
            width: 300,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      const Text(
                        'Scheduler',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const Spacer(),
                      // View Toggle
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            _buildViewToggle('Week', true),
                            _buildViewToggle('Day', false),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(height: 1),

                // Filters Section
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Search Patient
                      const Text(
                        'Search Patient',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFD1D5DB)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const TextField(
                          decoration: InputDecoration(
                            hintText: 'Enter patient name or ID',
                            hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Date
                      const Text(
                        'Date',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFD1D5DB)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const TextField(
                          decoration: InputDecoration(
                            hintText: 'mm/dd/yyyy',
                            hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            suffixIcon: Icon(
                              Icons.calendar_today,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Doctor
                      const Text(
                        'Doctor',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildDropdown('All Doctors'),

                      const SizedBox(height: 24),

                      // Department
                      const Text(
                        'Department',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildDropdown('All Departments'),

                      const SizedBox(height: 32),

                      // Status Legend
                      const Text(
                        'Status Legend',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildStatusLegend(),
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
                // Header with navigation and new appointment button
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.chevron_left),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'November 13-19, 2023',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(width: 5),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.chevron_right),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Today',
                          style: TextStyle(
                            color: Color(0xFF06B6D4),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.add),
                        label: const Text('New Appointment'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF06B6D4),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      // const SizedBox(width: 16),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.dark_mode_outlined),
                      ),
                    ],
                  ),
                ),

                // Calendar Grid
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        // Calendar Header
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 100,
                                padding: const EdgeInsets.all(16),
                                child: const Text(
                                  'Time',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF374151),
                                  ),
                                ),
                              ),
                              ...days
                                  .map(
                                    (day) => Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            left: BorderSide(
                                              color: Color(0xFFE5E7EB),
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          day,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF374151),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ],
                          ),
                        ),

                        // Calendar Body
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(12),
                              ),
                              border: Border.all(
                                color: const Color(0xFFE5E7EB),
                              ),
                            ),
                            child: Column(
                              children:
                                  timeSlots
                                      .map((time) => _buildTimeSlotRow(time))
                                      .toList(),
                            ),
                          ),
                        ),

                        // Conflict Alert
                        Container(
                          margin: const EdgeInsets.only(top: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF2F2),
                            border: Border.all(color: const Color(0xFFFECACA)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.warning,
                                color: Color(0xFFDC2626),
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Scheduling Conflict Detected',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFFDC2626),
                                      ),
                                    ),
                                    Text(
                                      'Dr. Johnson already has an appointment at 2:00 PM on Tuesday.',
                                      style: TextStyle(
                                        color: Color(0xFF7F1D1D),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              TextButton(
                                onPressed: () {},
                                child: const Text(
                                  'Suggest Alternative',
                                  style: TextStyle(color: Color(0xFFDC2626)),
                                ),
                              ),
                              const SizedBox(width: 8),
                              TextButton(
                                onPressed: () {},
                                child: const Text(
                                  'Override',
                                  style: TextStyle(color: Color(0xFFDC2626)),
                                ),
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

          // Right Sidebar - Patient Info
          Container(
            width: 250,
            color: Colors.white,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Patient Profile
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: const Color(0xFF06B6D4),
                      child: const Text(
                        'SJ',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sarah Johnson',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          Text(
                            'Patient ID: #12345',
                            style: TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Patient Details
                _buildPatientDetail('Age', '32'),
                _buildPatientDetail('Phone', '+1 234 567 8900'),
                _buildPatientDetail('Last Visit', 'Oct 15, 2023'),

                const SizedBox(height: 24),

                const Text(
                  'Medical History',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Hypertension, Regular checkups',
                  style: TextStyle(color: Color(0xFF6B7280), fontSize: 14),
                ),

                const SizedBox(height: 32),

                // Schedule Appointment Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF06B6D4),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Schedule Appointment',
                      style: TextStyle(fontWeight: FontWeight.w600),
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

  Widget _buildViewToggle(String text, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF06B6D4) : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : const Color(0xFF6B7280),
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildDropdown(String value) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD1D5DB)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
        items:
            [value].map((String item) {
              return DropdownMenuItem<String>(value: item, child: Text(item));
            }).toList(),
        onChanged: (String? newValue) {},
      ),
    );
  }

  Widget _buildStatusLegend() {
    return Column(
      children: [
        _buildLegendItem('Available', const Color(0xFF10B981)),
        const SizedBox(height: 8),
        _buildLegendItem('Booked', const Color(0xFFEF4444)),
        const SizedBox(height: 8),
        _buildLegendItem('Rescheduled', const Color(0xFFF59E0B)),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Color(0xFF374151)),
        ),
      ],
    );
  }

  Widget _buildTimeSlotRow(String time) {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: [
          Container(
            width: 100,
            padding: const EdgeInsets.all(16),
            child: Text(
              time,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Color(0xFF374151),
              ),
            ),
          ),
          ...days.asMap().entries.map((entry) {
            int index = entry.key;
            return Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(left: BorderSide(color: Color(0xFFE5E7EB))),
                ),
                child: _buildAppointmentSlot(time, index),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildAppointmentSlot(String time, int dayIndex) {
    // Mock appointment data
    if (time == '9:00 AM') {
      if (dayIndex == 0)
        return _buildAppointmentCard(
          'Available',
          Colors.transparent,
          const Color(0xFF10B981),
        );
      if (dayIndex == 1)
        return _buildAppointmentCard(
          'Booked\nJohn Smith\nCheckup',
          const Color(0xFFFEF2F2),
          const Color(0xFFEF4444),
        );
      if (dayIndex == 2)
        return _buildAppointmentCard(
          'Available',
          Colors.transparent,
          const Color(0xFF10B981),
        );
      if (dayIndex == 3)
        return _buildAppointmentCard(
          'Rescheduled\nEmma Wilson\nFollow-up',
          const Color(0xFFFEF3C7),
          const Color(0xFFF59E0B),
        );
    }
    if (time == '10:00 AM') {
      if (dayIndex == 0)
        return _buildAppointmentCard(
          'Booked\nSarah Davis\nConsultation',
          const Color(0xFFFEF2F2),
          const Color(0xFFEF4444),
        );
      if (dayIndex == 1)
        return _buildAppointmentCard(
          'Available',
          Colors.transparent,
          const Color(0xFF10B981),
        );
      if (dayIndex == 2)
        return _buildAppointmentCard(
          'Booked\nMike Johnson\nTreatment',
          const Color(0xFFFEF2F2),
          const Color(0xFFEF4444),
        );
    }

    return Container();
  }

  Widget _buildAppointmentCard(
    String text,
    Color backgroundColor,
    Color borderColor,
  ) {
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color:
              borderColor == const Color(0xFF10B981)
                  ? borderColor
                  : const Color(0xFF374151),
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildPatientDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF374151),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
            ),
          ),
        ],
      ),
    );
  }
}
