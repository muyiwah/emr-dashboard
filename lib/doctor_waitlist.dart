import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schmgtsystem/models/patient_model.dart';
import 'package:schmgtsystem/providers/patient_proviider.dart';

class DoctorWaitListScreen extends StatefulWidget {
  DoctorWaitListScreen({super.key, required this.onPatientSelected});

  final Function(dynamic patient) onPatientSelected;

  @override
  State<DoctorWaitListScreen> createState() => _DoctorWaitListScreenState();
}

class _DoctorWaitListScreenState extends State<DoctorWaitListScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    patients =
        Provider.of<PatientProvider>(
          context,
          listen: false,
        ).patients.where((e) => e.doctor == 'Dr. Smith').toList();
    setState(() {});
  }

  List<Patient> patients = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              _buildHeader(),
              SizedBox(height: 24),

              // Search and Filter Section
              _buildSearchAndFilters(),
              SizedBox(height: 24),

              // Patient List
              Expanded(child: _buildPatientList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        // Doctor Info
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage('assets/doctor_avatar.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[600],
            ),
            child: Icon(Icons.person, color: Colors.white, size: 24),
          ),
        ),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dr. Smith',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1D1D1D),
              ),
            ),
            Text(
              'Internal Medicine',
              style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
            ),
          ],
        ),
        Spacer(),

        // Stats
        _buildStatItem('12', 'Patients in Queue'),
        SizedBox(width: 32),
        _buildStatItem('45min', 'Est. Wait Time'),
        SizedBox(width: 32),

        // Current Patient
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Color(0xFFE5E7EB),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Current Patient',
                style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
              ),
              Text(
                'Sarah Johnson #P001',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4F46E5),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 16),

        // Start Next Button
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Color(0xFF4F46E5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.play_arrow, color: Colors.white, size: 16),
              SizedBox(width: 4),
              Text(
                'Start Next Consultation',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Color(0xFF4F46E5),
          ),
        ),
        Text(label, style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
      ],
    );
  }

  Widget _buildSearchAndFilters() {
    return Row(
      children: [
        Text(
          'Patient Wait List',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1D1D1D),
          ),
        ),
        Spacer(),

        // Search Bar
        Container(
          width: 300,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Color(0xFFE5E7EB)),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search by name, ID, or complaint...',
              hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
              prefixIcon: Icon(
                Icons.search,
                color: Color(0xFF9CA3AF),
                size: 18,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
          ),
        ),
        SizedBox(width: 16),

        // Filter Dropdown
        Container(
          height: 40,
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Color(0xFFE5E7EB)),
          ),
          child: Row(
            children: [
              Text(
                'All Triage Levels',
                style: TextStyle(fontSize: 14, color: Color(0xFF374151)),
              ),
              SizedBox(width: 8),
              Icon(
                Icons.keyboard_arrow_down,
                color: Color(0xFF9CA3AF),
                size: 18,
              ),
            ],
          ),
        ),
        SizedBox(width: 16),

        // Sort Dropdown
        Container(
          height: 40,
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Color(0xFFE5E7EB)),
          ),
          child: Row(
            children: [
              Text(
                'Sort by Waiting Time',
                style: TextStyle(fontSize: 14, color: Color(0xFF374151)),
              ),
              SizedBox(width: 8),
              Icon(
                Icons.keyboard_arrow_down,
                color: Color(0xFF9CA3AF),
                size: 18,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPatientList() {
    return ListView.builder(
      itemCount: patients.length,
      itemBuilder: (context, index) {
        return _buildPatientCard(patients[index]);
      },
    );
  }

  Widget _buildPatientCard(Patient patient) {
    return GestureDetector(
      onTap: () {
        widget.onPatientSelected(patient);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[300],
              ),
              child: Icon(Icons.person, color: Colors.grey[600], size: 24),
            ),
            SizedBox(width: 16),

            // Patient Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        patient.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1D1D1D),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color:
                              patient.urgencyColor?.withOpacity(0.1) ??
                              Colors.orange.withOpacity(.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          patient.urgency.toString(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: patient.urgencyColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        'ID: ${patient.id}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      SizedBox(width: 8),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Color(0xFF6B7280),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        '${patient.gender}, ${patient.age} years',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Chief Complaint: ${patient.complaint}',
                    style: TextStyle(fontSize: 14, color: Color(0xFF374151)),
                  ),
                ],
              ),
            ),

            // Wait Time and Room
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  patient.waitTime.toString(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1D1D1D),
                  ),
                ),
                Text(
                  'Waiting',
                  style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                ),
                SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      patient.room.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF374151),
                      ),
                    ),
                    Text(
                      patient.department,
                      style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(width: 16),

            // Action Icons
            Row(
              children: [
                _buildActionIcon(Icons.visibility_outlined),
                SizedBox(width: 8),
                _buildActionIcon(Icons.insert_chart_outlined),
                SizedBox(width: 8),
                _buildActionIcon(Icons.access_time_outlined),
                SizedBox(width: 8),
                _buildActionIcon(Icons.more_vert),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionIcon(IconData icon) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(icon, size: 16, color: Color(0xFF6B7280)),
    );
  }
}

class PatientData {
  final String name;
  final String id;
  final String gender;
  final int age;
  final String complaint;
  final String urgency;
  final Color urgencyColor;
  final String waitTime;
  final String room;
  final String department;
  final String avatar;

  PatientData({
    required this.name,
    required this.id,
    required this.gender,
    required this.age,
    required this.complaint,
    required this.urgency,
    required this.urgencyColor,
    required this.waitTime,
    required this.room,
    required this.department,
    required this.avatar,
  });
}
