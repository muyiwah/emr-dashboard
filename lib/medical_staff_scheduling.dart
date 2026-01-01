import 'package:flutter/material.dart';



class SchedulingScreen extends StatefulWidget {
  const SchedulingScreen({super.key});

  @override
  State<SchedulingScreen> createState() => _SchedulingScreenState();
}

class _SchedulingScreenState extends State<SchedulingScreen> {
  String selectedStaff = 'All Staff';
  String selectedView = 'Week View';

  final List<String> staffOptions = ['All Staff', 'Doctors', 'Nurses', 'Tech'];
  final List<String> viewOptions = ['Week View', 'Month View', 'Day View'];

  final List<StaffMember> staff = [
    StaffMember(
      name: 'Dr. Sarah Johnson',
      role: StaffRole.doctor,
      avatar: 'assets/images/doctor1.jpg',
    ),
    StaffMember(
      name: 'Nurse Emily Chen',
      role: StaffRole.nurse,
      avatar: 'assets/images/nurse1.jpg',
    ),
    StaffMember(
      name: 'Tech Mike Rodriguez',
      role: StaffRole.tech,
      avatar: 'assets/images/tech1.jpg',
    ),
    StaffMember(
      name: 'Nurse Lisa Park',
      role: StaffRole.nurse,
      avatar: 'assets/images/nurse2.jpg',
    ),
  ];

  final List<String> weekDays = [
    'Mon\n18',
    'Tue\n19',
    'Wed\n20',
    'Thu\n21',
    'Fri\n22',
    'Sat\n23',
    'Sun\n24',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildRoleLegend(),
              const SizedBox(height: 20),
              _buildNavigationRow(),
              const SizedBox(height: 20),
              Expanded(child: _buildScheduleView()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Text(
          'Availability & Scheduling',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(width: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                'Week of March 18-24, 2024',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
        ),
        const Spacer(),
        Row(
          children: [
            _buildCheckbox('Sync with On-Call Roster'),
            const SizedBox(width: 16),
            _buildCheckbox('External HR System'),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Add Availability'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCheckbox(String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: Checkbox(
            value: false,
            onChanged: (value) {},
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildRoleLegend() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Role Legend',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildLegendItem('Nurse', Colors.purple),
              const SizedBox(width: 24),
              _buildLegendItem('Doctor', Colors.blue),
              const SizedBox(width: 24),
              _buildLegendItem('Tech', Colors.green),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildNavigationRow() {
    return Row(
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.chevron_left),
          color: Colors.grey[600],
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.chevron_right),
          color: Colors.grey[600],
        ),
        const SizedBox(width: 16),
        TextButton(
          onPressed: () {},
          child: const Text(
            'Today',
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
          ),
        ),
        const Spacer(),
        _buildDropdown(selectedStaff, staffOptions, (value) {
          setState(() {
            selectedStaff = value!;
          });
        }),
        const SizedBox(width: 16),
        _buildDropdown(selectedView, viewOptions, (value) {
          setState(() {
            selectedView = value!;
          });
        }),
      ],
    );
  }

  Widget _buildDropdown(
    String value,
    List<String> options,
    ValueChanged<String?> onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButton<String>(
        value: value,
        items:
            options.map((option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(option),
              );
            }).toList(),
        onChanged: onChanged,
        underline: const SizedBox(),
        isDense: true,
      ),
    );
  }

  Widget _buildScheduleView() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          _buildScheduleHeader(),
          Expanded(child: _buildScheduleGrid()),
        ],
      ),
    );
  }

  Widget _buildScheduleHeader() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 150,
            child: Center(
              child: Text(
                'Staff',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),
          ),
          ...weekDays.map(
            (day) => Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border(left: BorderSide(color: Colors.grey[300]!)),
                ),
                child: Center(
                  child: Text(
                    day,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleGrid() {
    return Column(
      children:
          staff.map((staffMember) => _buildStaffRow(staffMember)).toList(),
    );
  }

  Widget _buildStaffRow(StaffMember staffMember) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          _buildStaffInfo(staffMember),
          ..._buildScheduleCells(staffMember),
        ],
      ),
    );
  }

  Widget _buildStaffInfo(StaffMember staffMember) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: _getRoleColor(staffMember.role),
            child: Text(
              staffMember.name.split(' ')[0][0] +
                  staffMember.name.split(' ')[1][0],
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  staffMember.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _getRoleColor(staffMember.role),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _getRoleText(staffMember.role),
                      style: TextStyle(color: Colors.grey[600], fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildScheduleCells(StaffMember staffMember) {
    return List.generate(7, (index) {
      return Expanded(
        child: Container(
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: Colors.grey[200]!)),
          ),
          child: _buildScheduleCell(staffMember, index),
        ),
      );
    });
  }

  Widget _buildScheduleCell(StaffMember staffMember, int dayIndex) {
    final schedules = _getScheduleForStaffAndDay(staffMember, dayIndex);

    if (schedules.isEmpty) {
      return const Center(
        child: Text('Off', style: TextStyle(color: Colors.grey, fontSize: 12)),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
            schedules.map((schedule) => _buildScheduleBlock(schedule)).toList(),
      ),
    );
  }

  Widget _buildScheduleBlock(ScheduleBlock schedule) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: schedule.color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: schedule.color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            schedule.time,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: schedule.color.withOpacity(0.8),
            ),
          ),
          if (schedule.department.isNotEmpty)
            Text(
              schedule.department,
              style: TextStyle(
                fontSize: 9,
                color: schedule.color.withOpacity(0.7),
              ),
            ),
        ],
      ),
    );
  }

  List<ScheduleBlock> _getScheduleForStaffAndDay(
    StaffMember staffMember,
    int dayIndex,
  ) {
    // Sample schedule data based on the image
    final schedules = <String, List<List<ScheduleBlock>>>{
      'Dr. Sarah Johnson': [
        [
          ScheduleBlock('8:00 AM - 6:00 PM', 'Emergency Dept', Colors.blue),
        ], // Mon
        [ScheduleBlock('8:00 AM - 6:00 PM', 'Surgery', Colors.blue)], // Tue
        [], // Wed - Off
        [ScheduleBlock('10:00 AM - 8:00 PM', 'ICU', Colors.blue)], // Thu
        [ScheduleBlock('8:00 AM - 6:00 PM', 'General', Colors.blue)], // Fri
        [], // Sat - Off
        [], // Sun - Off
      ],
      'Nurse Emily Chen': [
        [ScheduleBlock('6:00 AM - 2:00 PM', 'ICU', Colors.purple)], // Mon
        [ScheduleBlock('6:00 AM - 2:00 PM', 'ICU', Colors.purple)], // Tue
        [
          ScheduleBlock('2:00 PM - 10:00 PM', 'Emergency', Colors.purple),
        ], // Wed
        [ScheduleBlock('6:00 AM - 2:00 PM', 'ICU', Colors.purple)], // Thu
        [ScheduleBlock('6:00 AM - 2:00 PM', 'ICU', Colors.purple)], // Fri
        [], // Sat - Off
        [], // Sun - Off
      ],
      'Tech Mike Rodriguez': [
        [ScheduleBlock('7:00 AM - 3:00 PM', 'Radiology', Colors.green)], // Mon
        [ScheduleBlock('7:00 AM - 3:00 PM', 'Lab', Colors.green)], // Tue
        [ScheduleBlock('7:00 AM - 3:00 PM', 'Radiology', Colors.green)], // Wed
        [ScheduleBlock('3:00 PM - 11:00 PM', 'Lab', Colors.green)], // Thu
        [ScheduleBlock('7:00 AM - 3:00 PM', 'Radiology', Colors.green)], // Fri
        [], // Sat - Off
        [], // Sun - Off
      ],
      'Nurse Lisa Park': [
        [
          ScheduleBlock('2:00 PM - 10:00 PM', 'Pediatrics', Colors.purple),
        ], // Mon
        [], // Tue - Off
        [
          ScheduleBlock('2:00 PM - 10:00 PM', 'Pediatrics', Colors.purple),
        ], // Wed
        [
          ScheduleBlock('2:00 PM - 10:00 PM', 'Pediatrics', Colors.purple),
        ], // Thu
        [
          ScheduleBlock('10:00 PM - 6:00 AM', 'Night Shift', Colors.purple),
        ], // Fri
        [
          ScheduleBlock('10:00 PM - 6:00 AM', 'Night Shift', Colors.purple),
        ], // Sat
        [], // Sun - Off
      ],
    };

    return schedules[staffMember.name]?[dayIndex] ?? [];
  }

  Color _getRoleColor(StaffRole role) {
    switch (role) {
      case StaffRole.doctor:
        return Colors.blue;
      case StaffRole.nurse:
        return Colors.purple;
      case StaffRole.tech:
        return Colors.green;
    }
  }

  String _getRoleText(StaffRole role) {
    switch (role) {
      case StaffRole.doctor:
        return 'Doctor';
      case StaffRole.nurse:
        return 'Nurse';
      case StaffRole.tech:
        return 'Tech';
    }
  }
}

enum StaffRole { doctor, nurse, tech }

class StaffMember {
  final String name;
  final StaffRole role;
  final String avatar;

  StaffMember({required this.name, required this.role, required this.avatar});
}

class ScheduleBlock {
  final String time;
  final String department;
  final Color color;

  ScheduleBlock(this.time, this.department, this.color);
}
