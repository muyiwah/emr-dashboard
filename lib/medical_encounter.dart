import 'package:flutter/material.dart';


class MedicalEncounterNote extends StatefulWidget {
  const MedicalEncounterNote({super.key});

  @override
  State<MedicalEncounterNote> createState() => _MedicalEncounterNoteState();
}

class _MedicalEncounterNoteState extends State<MedicalEncounterNote>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _subjectiveController = TextEditingController();
  final TextEditingController _notesToStaffController = TextEditingController();
  String _selectedEncounterType = 'Routine';
  DateTime _selectedDateTime = DateTime.now();

  // Checkbox states
  final Map<String, bool> _symptoms = {
    'Fever': false,
    'Nausea': false,
    'Headache': false,
    'Chest Pain': false,
    'Fatigue': false,
    'Shortness of Breath': false,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _subjectiveController.text =
        "Describe patient's chief complaint, symptoms, and history...";
    _notesToStaffController.text =
        "Optional notes for nurses or specialists...";
  }

  @override
  void dispose() {
    _tabController.dispose();
    _subjectiveController.dispose();
    _notesToStaffController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16),
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
                  children: [
                    _buildPatientInfo(),
                    _buildTabBar(),
                    Expanded(child: _buildTabContent()),
                    _buildBottomButtons(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.arrow_back, color: Colors.grey),
          ),
          const Icon(Icons.medical_services, color: Colors.blue, size: 24),
          const SizedBox(width: 8),
          const Text(
            'Medical Encounter Note',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.arrow_back, size: 16),
            label: const Text('Back to Patient'),
            style: TextButton.styleFrom(foregroundColor: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Patient Information',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                _buildInfoRow('Patient Name', 'Sarah Johnson'),
                const SizedBox(height: 8),
                _buildInfoRow('Patient ID', 'PT-2024-0892'),
                const SizedBox(height: 16),
                const Text(
                  'Current Medications',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildMedicationChip('Metformin 500mg', Colors.blue),
                    const SizedBox(width: 8),
                    _buildMedicationChip('Lisinopril 10mg', Colors.blue),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Allergies',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildMedicationChip('Penicillin', Colors.red),
                    const SizedBox(width: 8),
                    _buildMedicationChip('Shellfish', Colors.red),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 40),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Age / Gender',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const Spacer(),
                    const Text(
                      'Encounter Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      '34 / Female',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text(
                      'Last Encounter',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const Spacer(),
                    const Text(
                      'Date & Time',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Dec 15, 2024',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            '12/18/2024, 10:30 AM',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Clinician',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const Text(
                  'Dr. Michael Chen',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Encounter Type',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedEncounterType,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items:
                          [
                            'Routine',
                            'Follow-up',
                            'Emergency',
                            'Consultation',
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedEncounterType = newValue!;
                        });
                      },
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

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildMedicationChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: TabBar(
        controller: _tabController,
        indicatorColor: Colors.blue,
        labelColor: Colors.blue,
        unselectedLabelColor: Colors.grey,
        tabs: const [
          Tab(icon: Icon(Icons.person), text: 'Subjective'),
          Tab(icon: Icon(Icons.visibility), text: 'Objective'),
          Tab(icon: Icon(Icons.assessment), text: 'Assessment'),
          Tab(icon: Icon(Icons.list_alt), text: 'Plan'),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildSubjectiveTab(),
        _buildPlaceholderTab('Objective'),
        _buildPlaceholderTab('Assessment'),
        _buildPlaceholderTab('Plan'),
      ],
    );
  }

  Widget _buildSubjectiveTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Subjective',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Patient's reported symptoms, complaints, duration",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Container(
            height: 120,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(6),
            ),
            child: TextField(
              controller: _subjectiveController,
              maxLines: null,
              expands: true,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(12),
              ),
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Quick Symptom Checklist',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          _buildSymptomChecklist(),
          const SizedBox(height: 32),
          const Text(
            'Attachments & Additional Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'File Attachments',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 120,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey[300]!,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cloud_upload_outlined,
                              size: 32,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Drag files here or click to upload',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Lab reports, X-rays, external notes (PDF/Images)',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Notes to Staff',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 120,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: TextField(
                        controller: _notesToStaffController,
                        maxLines: null,
                        expands: true,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(12),
                        ),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSymptomChecklist() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildCheckboxTile('Fever')),
            Expanded(child: _buildCheckboxTile('Headache')),
            Expanded(child: _buildCheckboxTile('Fatigue')),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _buildCheckboxTile('Nausea')),
            Expanded(child: _buildCheckboxTile('Chest Pain')),
            Expanded(child: _buildCheckboxTile('Shortness of Breath')),
          ],
        ),
      ],
    );
  }

  Widget _buildCheckboxTile(String symptom) {
    return Row(
      children: [
        Checkbox(
          value: _symptoms[symptom] ?? false,
          onChanged: (bool? value) {
            setState(() {
              _symptoms[symptom] = value ?? false;
            });
          },
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        Expanded(
          child: Text(
            symptom,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholderTab(String tabName) {
    return Center(
      child: Text(
        '$tabName content goes here',
        style: const TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.save_outlined),
            label: const Text('Save Draft'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey[700],
              side: BorderSide(color: Colors.grey[300]!),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.check),
            label: const Text('Submit & Sign'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
          const Spacer(),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.print_outlined),
            label: const Text('Print Summary'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey[700],
              side: BorderSide(color: Colors.grey[300]!),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.send_outlined),
            label: const Text('Send to Patient Portal'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
