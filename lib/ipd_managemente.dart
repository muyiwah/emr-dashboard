import 'package:flutter/material.dart';




class IPDDashboard extends StatefulWidget {
  const IPDDashboard({super.key});

  @override
  State<IPDDashboard> createState() => _IPDDashboardState();
}

class _IPDDashboardState extends State<IPDDashboard> {
  String selectedWard = 'ICU';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IPD Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          const CircleAvatar(
            radius: 16,
            // backgroundImage: NetworkImage('https://via.placeholder.com/32'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Navigation Tabs
            _buildNavigationTabs(),
            const SizedBox(height: 24),

            // Stats Cards Row
            _buildStatsCards(),
            const SizedBox(height: 24),

            // Main Content Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Column - Bed Management
                Expanded(flex: 2, child: _buildBedManagement()),
                const SizedBox(width: 16),

                // Right Column - Patient Overview
                Expanded(flex: 1, child: _buildPatientOverview()),
              ],
            ),
            const SizedBox(height: 24),

            // Bottom Row - Charts and Recent Admissions
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildAdmissionsByDepartment()),
                const SizedBox(width: 16),
                Expanded(child: _buildWardOccupancyRate()),
              ],
            ),
            const SizedBox(height: 24),

            // Recent Admissions
            _buildRecentAdmissions(),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationTabs() {
    return Row(
      children: [
        _buildNavTab('Dashboard', true),
        const SizedBox(width: 8),
        _buildNavTab('Admissions', false),
        const SizedBox(width: 8),
        _buildNavTab('Bed Management', false),
      ],
    );
  }

  Widget _buildNavTab(String title, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF6366F1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey[600],
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
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
            Icons.person,
            const Color(0xFF6366F1),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Available Beds',
            '28',
            Icons.bed,
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
            Icons.person_remove,
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
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
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
          const SizedBox(height: 4),
          Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildBedManagement() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
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
                'Bed Management',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, size: 16),
                label: const Text('New Admission'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Ward Selection
          Row(
            children: [
              _buildWardButton('ICU', selectedWard == 'ICU'),
              const SizedBox(width: 8),
              _buildWardButton('General Ward', selectedWard == 'General Ward'),
              const SizedBox(width: 8),
              _buildWardButton('Private', selectedWard == 'Private'),
              const SizedBox(width: 8),
              _buildWardButton('Pediatric', selectedWard == 'Pediatric'),
            ],
          ),
          const SizedBox(height: 20),

          // Bed Grid
          _buildBedGrid(),
          const SizedBox(height: 16),

          // Legend
          _buildBedLegend(),
        ],
      ),
    );
  }

  Widget _buildWardButton(String ward, bool isSelected) {
    return GestureDetector(
      onTap: () => setState(() => selectedWard = ward),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6366F1) : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          ward,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildBedGrid() {
    final beds = [
      BedInfo('101', 'J. Smith', BedStatus.occupied),
      BedInfo('102', 'M. Johnson', BedStatus.occupied),
      BedInfo('103', 'Available', BedStatus.available),
      BedInfo('104', 'Available', BedStatus.available),
      BedInfo('105', 'Reserved', BedStatus.reserved),
      BedInfo('106', 'Cleaning', BedStatus.cleaning),
      BedInfo('107', 'K. Wilson', BedStatus.occupied),
      BedInfo('108', 'Available', BedStatus.available),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: beds.length,
      itemBuilder: (context, index) {
        final bed = beds[index];
        return _buildBedCard(bed);
      },
    );
  }

  Widget _buildBedCard(BedInfo bed) {
    Color backgroundColor;
    Color textColor = Colors.white;
    IconData icon = Icons.bed;

    switch (bed.status) {
      case BedStatus.occupied:
        backgroundColor = const Color(0xFFEF4444);
        break;
      case BedStatus.available:
        backgroundColor = const Color(0xFF10B981);
        break;
      case BedStatus.reserved:
        backgroundColor = const Color(0xFFF59E0B);
        break;
      case BedStatus.cleaning:
        backgroundColor = const Color(0xFF6366F1);
        break;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: textColor, size: 20),
          const SizedBox(height: 4),
          Text(
            bed.number,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            bed.patient,
            style: TextStyle(color: textColor, fontSize: 10),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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
        _buildLegendItem('Cleaning', const Color(0xFF6366F1)),
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
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildPatientOverview() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Patient Overview',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // Patient Info
          Row(
            children: [
              const CircleAvatar(
                radius: 24,
                // backgroundImage: NetworkImage('https://via.placeholder.com/48'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'John Smith',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Bed 101 • ICU',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    Text(
                      'Admitted: 2 days ago',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Vital Signs
          _buildVitalSigns(),
          const SizedBox(height: 20),

          // Action Buttons
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildVitalSigns() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildVitalCard('Heart Rate', '72 BPM')),
            const SizedBox(width: 12),
            Expanded(child: _buildVitalCard('Blood Pressure', '120/80')),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildVitalCard('Temperature', '98.6°F')),
            const SizedBox(width: 12),
            Expanded(child: _buildVitalCard('Oxygen', '98%')),
          ],
        ),
      ],
    );
  }

  Widget _buildVitalCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        _buildActionButton(
          'Add Progress Note',
          const Color(0xFF6366F1),
          Icons.note_add,
        ),
        const SizedBox(height: 8),
        _buildActionButton(
          'Add Medication',
          const Color(0xFF06B6D4),
          Icons.medication,
        ),
        const SizedBox(height: 8),
        _buildActionButton('Transfer Bed', Colors.grey[600]!, Icons.swap_horiz),
        const SizedBox(height: 8),
        _buildActionButton(
          'Discharge Patient',
          const Color(0xFF10B981),
          Icons.logout,
        ),
      ],
    );
  }

  Widget _buildActionButton(String label, Color color, IconData icon) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: Icon(icon, size: 16),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildAdmissionsByDepartment() {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Admissions by Department',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Center(
              child: Text(
                'Chart Placeholder',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWardOccupancyRate() {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ward Occupancy Rate',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Center(
              child: Text(
                'Chart Placeholder',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentAdmissions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Admissions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Expanded(
                  flex: 2,
                  child: Text(
                    'PATIENT',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                ),
                const Expanded(
                  child: Text(
                    'BED',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                ),
                const Expanded(
                  flex: 2,
                  child: Text(
                    'DOCTOR',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                ),
                const Expanded(
                  flex: 2,
                  child: Text(
                    'DIAGNOSIS',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                ),
                const Expanded(
                  child: Text(
                    'ADMITTED',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                ),
                const Expanded(
                  child: Text(
                    'STATUS',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Table Rows
          _buildAdmissionRow(
            'Sarah Connor',
            'ID: 12345',
            'ICU-101',
            'Dr. Williams',
            'Pneumonia',
            '2 hours ago',
            'Stable',
          ),
          _buildAdmissionRow(
            'Mike Johnson',
            'ID: 12346',
            'GEN-205',
            'Dr. Davis',
            'Appendicitis',
            '4 hours ago',
            'Monitoring',
          ),
        ],
      ),
    );
  }

  Widget _buildAdmissionRow(
    String name,
    String id,
    String bed,
    String doctor,
    String diagnosis,
    String admitted,
    String status,
  ) {
    Color statusColor =
        status == 'Stable' ? const Color(0xFF10B981) : const Color(0xFFF59E0B);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 16,
                  // backgroundImage: NetworkImage(
                  //   'https://via.placeholder.com/32',
                  // ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      id,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(child: Text(bed)),
          Expanded(flex: 2, child: Text(doctor)),
          Expanded(flex: 2, child: Text(diagnosis)),
          Expanded(child: Text(admitted, style: const TextStyle(fontSize: 12))),
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
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BedInfo {
  final String number;
  final String patient;
  final BedStatus status;

  BedInfo(this.number, this.patient, this.status);
}

enum BedStatus { occupied, available, reserved, cleaning }
