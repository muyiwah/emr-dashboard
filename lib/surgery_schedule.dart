import 'package:flutter/material.dart';

class OTSchedulerScreen extends StatefulWidget {
  const OTSchedulerScreen({Key? key}) : super(key: key);

  @override
  State<OTSchedulerScreen> createState() => _OTSchedulerScreenState();
}

class _OTSchedulerScreenState extends State<OTSchedulerScreen> {
  String selectedView = 'Day';
  DateTime selectedDate = DateTime(2024, 1, 15);
  String selectedSurgeons = 'All Surgeons';
  String selectedRooms = 'All Rooms';
  String selectedStatus = 'All Status';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.calendar_today,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'OT Scheduler',
              style: TextStyle(
                color: Color(0xFF1F2937),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, size: 16),
              label: const Text('New Surgery'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
            ),
          ),
          const CircleAvatar(
            radius: 16,
            // backgroundImage: NetworkImage('https://via.placeholder.com/32'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          // Filter Section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildViewToggle(),
                const SizedBox(width: 16),
                _buildDatePicker(),
                const Spacer(),
                _buildDropdown('All Surgeons', selectedSurgeons),
                const SizedBox(width: 12),
                _buildDropdown('All Rooms', selectedRooms),
                const SizedBox(width: 12),
                _buildDropdown('All Status', selectedStatus),
              ],
            ),
          ),
          // Main Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Schedule Section
                  Expanded(flex: 3, child: _buildScheduleSection()),
                  const SizedBox(width: 16),
                  // Side Panel
                  Expanded(flex: 1, child: _buildSidePanel()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewToggle() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildToggleButton('Day', selectedView == 'Day'),
          _buildToggleButton('Week', selectedView == 'Week'),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isSelected) {
    return GestureDetector(
      onTap: () => setState(() => selectedView = text),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6366F1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF6B7280),
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD1D5DB)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '01/15/2024',
            style: const TextStyle(
              color: Color(0xFF374151),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.calendar_today, size: 16, color: Color(0xFF6B7280)),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD1D5DB)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(color: Color(0xFF374151), fontSize: 14),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.keyboard_arrow_down,
            size: 16,
            color: Color(0xFF6B7280),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleSection() {
    return Container(
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
          Padding(
            padding: const EdgeInsets.all(20),
            child: const Text(
              'Surgery Schedule - January 15, 2024',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),
          ),
          Expanded(child: _buildScheduleGrid()),
        ],
      ),
    );
  }

  Widget _buildScheduleGrid() {
    final timeSlots = ['08:00', '10:00', '12:00', '14:00', '16:00'];
    final rooms = ['OT-1', 'OT-2', 'OT-3', 'OT-4'];

    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              const SizedBox(width: 80, child: Text('Time')),
              ...rooms.map(
                (room) => Expanded(
                  child: Center(
                    child: Text(
                      room,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(),
        // Schedule Grid
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: timeSlots.length,
            itemBuilder: (context, index) {
              return _buildTimeSlotRow(timeSlots[index], index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSlotRow(String time, int timeIndex) {
    return Container(
      height: 120,
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              time,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Color(0xFF6B7280),
              ),
            ),
          ),
          ..._buildSurgeryCards(timeIndex),
        ],
      ),
    );
  }

  List<Widget> _buildSurgeryCards(int timeIndex) {
    final surgeries = _getSurgeriesForTimeSlot(timeIndex);

    return List.generate(4, (roomIndex) {
      final surgery = surgeries[roomIndex];
      return Expanded(
        child: Container(
          margin: const EdgeInsets.only(right: 8),
          child:
              surgery != null
                  ? _buildSurgeryCard(surgery)
                  : Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFFE5E7EB),
                        style: BorderStyle.solid,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
        ),
      );
    });
  }

  Map<int, SurgeryData?> _getSurgeriesForTimeSlot(int timeIndex) {
    final Map<int, Map<int, SurgeryData?>> schedule = {
      0: {
        // 08:00
        0: SurgeryData(
          type: 'Appendectomy',
          patient: 'John Doe - MRN: 12345',
          doctor: 'Dr. Smith',
          color: const Color(0xFF3B82F6),
        ),
        2: SurgeryData(
          type: 'Heart Surgery',
          patient: 'Robert Lee - MRN: 11111',
          doctor: 'Dr. Martinez',
          color: const Color(0xFFF59E0B),
        ),
      },
      1: {
        // 10:00
        1: SurgeryData(
          type: 'Gallbladder Surgery',
          patient: 'Mike Brown - MRN: 54321',
          doctor: 'Dr. Davis',
          color: const Color(0xFF10B981),
        ),
      },
      2: {
        // 12:00
        0: SurgeryData(
          type: 'Hip Replacement',
          patient: 'Sarah Wilson - MRN: 67890',
          doctor: 'Dr. Johnson',
          color: const Color(0xFFF59E0B),
        ),
        3: SurgeryData(
          type: 'Cataract Surgery',
          patient: 'Emma Davis - MRN: 22222',
          doctor: 'Dr. Thompson',
          color: const Color(0xFF10B981),
        ),
      },
      3: {
        // 14:00
        1: SurgeryData(
          type: 'Knee Surgery',
          patient: 'Lisa Garcia - MRN: 98765',
          doctor: 'Dr. Wilson',
          color: const Color(0xFF3B82F6),
        ),
      },
    };

    return schedule[timeIndex] ?? {};
  }

  Widget _buildSurgeryCard(SurgeryData surgery) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: surgery.color.withOpacity(0.1),
        border: Border.all(color: surgery.color, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            surgery.type,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: surgery.color,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            surgery.patient,
            style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
          ),
          const SizedBox(height: 4),
          Text(
            surgery.doctor,
            style: TextStyle(
              fontSize: 11,
              color: surgery.color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidePanel() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildLiveStatus(),
          const SizedBox(height: 16),
          _buildResources(),
          const SizedBox(height: 16),
          _buildTodaysStats(),
        ],
      ),
    );
  }

  Widget _buildLiveStatus() {
    return Container(
      padding: const EdgeInsets.all(16),
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
              const Icon(Icons.favorite, color: Color(0xFFEF4444), size: 16),
              const SizedBox(width: 8),
              const Text(
                'Live Status',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildStatusCard(
            'OT-1',
            'Ongoing',
            'Started: 08:15 AM\nEst. remaining: 45 min\nNurse: Sarah K.',
            const Color(0xFFFEF3C7),
          ),
          const SizedBox(height: 12),
          _buildStatusCard(
            'OT-3',
            'Ongoing',
            'Started: 08:00 AM\nEst. remaining: 2h 15min\nNurse: Mark R.',
            const Color(0xFFFEF3C7),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(
    String room,
    String status,
    String details,
    Color bgColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                room,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF92400E),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B),
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
          const SizedBox(height: 8),
          Text(
            details,
            style: const TextStyle(fontSize: 12, color: Color(0xFF92400E)),
          ),
        ],
      ),
    );
  }

  Widget _buildResources() {
    return Container(
      padding: const EdgeInsets.all(16),
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
              const Icon(
                Icons.medical_services,
                color: Color(0xFF6366F1),
                size: 16,
              ),
              const SizedBox(width: 8),
              const Text(
                'Resources',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildResourceRow('OT-1', 'In Use', const Color(0xFFF59E0B)),
          _buildResourceRow('OT-2', 'Available', const Color(0xFF10B981)),
          _buildResourceRow('OT-3', 'In Use', const Color(0xFFF59E0B)),
          _buildResourceRow('OT-4', 'Available', const Color(0xFF10B981)),
        ],
      ),
    );
  }

  Widget _buildResourceRow(String room, String status, Color statusColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            room,
            style: const TextStyle(
              color: Color(0xFF374151),
              fontWeight: FontWeight.w500,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
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
        ],
      ),
    );
  }

  Widget _buildTodaysStats() {
    return Container(
      padding: const EdgeInsets.all(16),
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
              const Icon(Icons.bar_chart, color: Color(0xFF06B6D4), size: 16),
              const SizedBox(width: 8),
              const Text(
                "Today's Stats",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildStatRow('Total Surgeries', '8', const Color(0xFF374151)),
          _buildStatRow('Completed', '3', const Color(0xFF10B981)),
          _buildStatRow('Ongoing', '2', const Color(0xFFF59E0B)),
          _buildStatRow('Scheduled', '3', const Color(0xFF3B82F6)),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Color(0xFF6B7280), fontSize: 14),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class SurgeryData {
  final String type;
  final String patient;
  final String doctor;
  final Color color;

  SurgeryData({
    required this.type,
    required this.patient,
    required this.doctor,
    required this.color,
  });
}
