import 'package:flutter/material.dart';


class ClinicalNotesScreen extends StatefulWidget {
  const ClinicalNotesScreen({super.key});

  @override
  State<ClinicalNotesScreen> createState() => _ClinicalNotesScreenState();
}

class _ClinicalNotesScreenState extends State<ClinicalNotesScreen> {
  String selectedWard = 'All Wards';
  String selectedDoctor = 'All Doctors';
  String selectedStatus = 'All Patients';

  final List<PatientData> patients = [
    PatientData(
      name: 'Sarah Johnson',
      age: 45,
      mrn: '12345',
      bed: '201A',
      status: PatientStatus.stable,
      bp: '120/80',
      hr: '72 bpm',
      temp: '98.6°F',
      medications: ['Lisinopril', 'Metformin'],
    ),
    PatientData(
      name: 'Michael Chen',
      age: 62,
      mrn: '67890',
      bed: '203B',
      status: PatientStatus.critical,
      bp: '160/95',
      hr: '95 bpm',
      temp: '101.2°F',
      medications: ['Atenolol', 'Warfarin'],
    ),
    PatientData(
      name: 'Emma Davis',
      age: 28,
      mrn: '54321',
      bed: '205C',
      status: PatientStatus.stable,
      bp: '115/75',
      hr: '68 bpm',
      temp: '98.4°F',
      medications: ['Ibuprofen'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTabBar(),
            _buildFilterSection(),
            Expanded(child: _buildPatientsList()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF6366F1),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.medical_services_outlined,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'Clinical Notes',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.dark_mode_outlined,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFF10B981),
            child: const Text(
              'DJ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'Dr. Johnson',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF374151),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          _buildTab('Ward Rounds', true),
          const SizedBox(width: 16),
          _buildTab('Nursing Notes', false),
        ],
      ),
    );
  }

  Widget _buildTab(String title, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF6366F1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: isSelected ? Colors.white : const Color(0xFF6B7280),
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Ward Round Notes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
              const Spacer(),
              Text(
                'Today, March 15, 2024',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildDropdown('Ward', selectedWard, ['All Wards']),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDropdown('Attending Doctor', selectedDoctor, [
                  'All Doctors',
                ]),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDropdown('Status', selectedStatus, [
                  'All Patients',
                ]),
              ),
              const SizedBox(width: 16),
              _buildFilterButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE5E7EB)),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF374151),
                  ),
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down,
                color: Color(0xFF9CA3AF),
                size: 20,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 22), // Align with dropdown content
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF6366F1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.filter_list, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Text(
                'Filter',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPatientsList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: patients.length,
        itemBuilder: (context, index) {
          return _buildPatientCard(patients[index]);
        },
      ),
    );
  }

  Widget _buildPatientCard(PatientData patient) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    patient.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                ),
                _buildStatusBadge(patient.status),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Age ${patient.age} • MRN: ${patient.mrn} • Bed ${patient.bed}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            _buildVitalSign(
              'BP:',
              patient.bp,
              patient.status == PatientStatus.critical,
            ),
            _buildVitalSign('HR:', patient.hr, false),
            _buildVitalSign('Temp:', patient.temp, false),
            const SizedBox(height: 16),
            const Text(
              'Current Medications:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children:
                  patient.medications
                      .map((med) => _buildMedicationChip(med))
                      .toList(),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                icon: const Icon(Icons.add, size: 18),
                label: const Text(
                  'Add Note',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(PatientStatus status) {
    Color backgroundColor;
    String text;

    switch (status) {
      case PatientStatus.stable:
        backgroundColor = const Color(0xFF10B981);
        text = 'Stable';
        break;
      case PatientStatus.critical:
        backgroundColor = const Color(0xFFEF4444);
        text = 'Critical';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildVitalSign(String label, String value, bool isAbnormal) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6B7280),
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color:
                  isAbnormal
                      ? const Color(0xFFEF4444)
                      : const Color(0xFF374151),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicationChip(String medication) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        medication,
        style: const TextStyle(fontSize: 11, color: Color(0xFF374151)),
      ),
    );
  }
}

enum PatientStatus { stable, critical }

class PatientData {
  final String name;
  final int age;
  final String mrn;
  final String bed;
  final PatientStatus status;
  final String bp;
  final String hr;
  final String temp;
  final List<String> medications;

  PatientData({
    required this.name,
    required this.age,
    required this.mrn,
    required this.bed,
    required this.status,
    required this.bp,
    required this.hr,
    required this.temp,
    required this.medications,
  });
}
