import 'package:flutter/material.dart';

class IPDManagementScreen extends StatefulWidget {
  const IPDManagementScreen({Key? key}) : super(key: key);

  @override
  State<IPDManagementScreen> createState() => _IPDManagementScreenState();
}

class _IPDManagementScreenState extends State<IPDManagementScreen> {
  String selectedWardType = 'ICU';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Row(
          children: [
            // Main Content
            Expanded(
              flex: 7,
              child: Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          _buildStatsCards(),
                          const SizedBox(height: 24),
                          _buildBedManagement(),
                          const SizedBox(height: 24),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(child: _buildAdmissionsByDepartment()),
                                const SizedBox(width: 24),
                                Expanded(child: _buildWardOccupancyRate()),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          _buildRecentAdmissions(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Patient Overview Sidebar
            Container(
              width: 350,
              color: Colors.white,
              child: _buildPatientOverview(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          const Text(
            'IPD Management',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(width: 32),
          _buildNavButton('Dashboard', true),
          const SizedBox(width: 16),
          _buildNavButton('Admissions', false),
          const SizedBox(width: 16),
          _buildNavButton('Bed Management', false),
          const Spacer(),
          const Icon(Icons.notifications_outlined, color: Color(0xFF6B7280)),
          const SizedBox(width: 16),
          const CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage('https://via.placeholder.com/40'),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(String text, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF6366F1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isActive ? Colors.white : const Color(0xFF6B7280),
          fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildStatsCards() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total Admitted',
            '142',
            Icons.bed,
            const Color(0xFF6366F1),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Available Beds',
            '28',
            Icons.hotel,
            const Color(0xFF06B6D4),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Admissions Today',
            '12',
            Icons.person_add,
            const Color(0xFF10B981),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Discharges Today',
            '8',
            Icons.exit_to_app,
            const Color(0xFFF59E0B),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
          ),
        ],
      ),
    );
  }

  Widget _buildBedManagement() {
    return Container(
      padding: const EdgeInsets.all(24),
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
              const Text(
                'Bed Management',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, size: 18),
                label: const Text('New Admission'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildWardTypeButton('ICU', selectedWardType == 'ICU'),
              const SizedBox(width: 12),
              _buildWardTypeButton(
                'General Ward',
                selectedWardType == 'General Ward',
              ),
              const SizedBox(width: 12),
              _buildWardTypeButton('Private', selectedWardType == 'Private'),
              const SizedBox(width: 12),
              _buildWardTypeButton(
                'Pediatric',
                selectedWardType == 'Pediatric',
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildBedGrid(),
          const SizedBox(height: 16),
          _buildBedLegend(),
        ],
      ),
    );
  }

  Widget _buildWardTypeButton(String text, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedWardType = text;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6366F1) : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF6B7280),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildBedGrid() {
    final beds = [
      {'number': '101', 'patient': 'J. Smith', 'status': 'occupied'},
      {'number': '102', 'patient': 'M. Johnson', 'status': 'occupied'},
      {'number': '103', 'status': 'available'},
      {'number': '104', 'status': 'available'},
      {'number': '105', 'status': 'reserved'},
      {'number': '106', 'status': 'cleaning'},
      {'number': '107', 'patient': 'K. Wilson', 'status': 'occupied'},
      {'number': '108', 'status': 'available'},
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: beds.map((bed) => _buildBedCard(bed)).toList(),
    );
  }

  Widget _buildBedCard(Map<String, String> bed) {
    Color cardColor;
    Color textColor = Colors.white;
    IconData icon = Icons.bed;

    switch (bed['status']) {
      case 'occupied':
        cardColor = const Color(0xFFEF4444);
        break;
      case 'available':
        cardColor = const Color(0xFF10B981);
        break;
      case 'reserved':
        cardColor = const Color(0xFFF59E0B);
        break;
      case 'cleaning':
        cardColor = const Color(0xFF8B5CF6);
        break;
      default:
        cardColor = const Color(0xFF6B7280);
    }

    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: textColor, size: 20),
          const SizedBox(height: 4),
          Text(
            bed['number']!,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          if (bed['patient'] != null)
            Text(
              bed['patient']!,
              style: TextStyle(color: textColor, fontSize: 10),
              textAlign: TextAlign.center,
            ),
          if (bed['patient'] == null)
            Text(
              bed['status']!.substring(0, 1).toUpperCase() +
                  bed['status']!.substring(1),
              style: TextStyle(color: textColor, fontSize: 10),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }

  Widget _buildBedLegend() {
    return Row(
      children: [
        _buildLegendItem('Occupied', const Color(0xFFEF4444)),
        const SizedBox(width: 16),
        _buildLegendItem('Available', const Color(0xFF10B981)),
        const SizedBox(width: 16),
        _buildLegendItem('Reserved', const Color(0xFFF59E0B)),
        const SizedBox(width: 16),
        _buildLegendItem('Cleaning', const Color(0xFF8B5CF6)),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
        ),
      ],
    );
  }

  Widget _buildAdmissionsByDepartment() {
    return Container(
      padding: const EdgeInsets.all(24),
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
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Admissions by Department',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Center(
              child: Text(
                'Chart Placeholder',
                style: TextStyle(color: Color(0xFF6B7280), fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWardOccupancyRate() {
    return Container(
      padding: const EdgeInsets.all(24),
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
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ward Occupancy Rate',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Center(
              child: Text(
                'Chart Placeholder',
                style: TextStyle(color: Color(0xFF6B7280), fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentAdmissions() {
    final admissions = [
      {
        'patient': 'Sarah Connor',
        'id': 'ID: 12345',
        'bed': 'ICU-101',
        'doctor': 'Dr. Williams',
        'diagnosis': 'Pneumonia',
        'admitted': '2 hours ago',
        'status': 'Stable',
        'avatar': 'https://via.placeholder.com/40',
      },
      {
        'patient': 'Mike Johnson',
        'id': 'ID: 12346',
        'bed': 'GEN-205',
        'doctor': 'Dr. Davis',
        'diagnosis': 'Appendicitis',
        'admitted': '4 hours ago',
        'status': 'Monitoring',
        'avatar': 'https://via.placeholder.com/40',
      },
    ];

    return Container(
      padding: const EdgeInsets.all(24),
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
            'Recent Admissions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildTableHeader('PATIENT', flex: 2),
              _buildTableHeader('BED', flex: 1),
              _buildTableHeader('DOCTOR', flex: 2),
              _buildTableHeader('DIAGNOSIS', flex: 2),
              _buildTableHeader('ADMITTED', flex: 2),
              _buildTableHeader('STATUS', flex: 1),
            ],
          ),
          const Divider(),
          ...admissions.map((admission) => _buildAdmissionRow(admission)),
        ],
      ),
    );
  }

  Widget _buildTableHeader(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF6B7280),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildAdmissionRow(Map<String, String> admission) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(admission['avatar']!),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      admission['patient']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    Text(
                      admission['id']!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              admission['bed']!,
              style: const TextStyle(color: Color(0xFF1A1A1A)),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              admission['doctor']!,
              style: const TextStyle(color: Color(0xFF1A1A1A)),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              admission['diagnosis']!,
              style: const TextStyle(color: Color(0xFF1A1A1A)),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              admission['admitted']!,
              style: const TextStyle(color: Color(0xFF1A1A1A)),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color:
                    admission['status'] == 'Stable'
                        ? const Color(0xFF10B981).withOpacity(0.1)
                        : const Color(0xFFF59E0B).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                admission['status']!,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color:
                      admission['status'] == 'Stable'
                          ? const Color(0xFF10B981)
                          : const Color(0xFFF59E0B),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }





  Widget _buildPatientOverview() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Patient Overview',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.add,
                  color: Color(0xFF6366F1),
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const CircleAvatar(
                radius: 24,
                // backgroundImage: NetworkImage('https://via.placeholder.com/48'),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'John Smith',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    Text(
                      'Bed 101 • ICU',
                      style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                    ),
                    Text(
                      'Admitted: 2 days ago',
                      style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildVitalCard('Heart Rate', '72 BPM', 'Blood Pressure', '120/80'),
          const SizedBox(height: 16),
          _buildVitalCard('Temperature', '98.6°F', 'Oxygen', '98%'),
          const SizedBox(height: 24),
          _buildActionButton(
            'Add Progress Note',
            const Color(0xFF6366F1),
            Icons.note_add,
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            'Add Medication',
            const Color(0xFF06B6D4),
            Icons.medication,
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            'Transfer Bed',
            const Color(0xFF6B7280),
            Icons.swap_horiz,
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            'Discharge Patient',
            const Color(0xFF10B981),
            Icons.exit_to_app,
          ),
        ],
      ),
    );
  }

  Widget _buildVitalCard(
    String label1,
    String value1,
    String label2,
    String value2,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label1,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value1,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
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
                  label2,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value2,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String text, Color color, IconData icon) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: Icon(icon, size: 18),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
