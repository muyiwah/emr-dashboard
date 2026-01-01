import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schmgtsystem/models/patient_model.dart';
import 'package:schmgtsystem/providers/patient_proviider.dart';

class ChiefComplaintPage extends StatefulWidget {
  ChiefComplaintPage({
    super.key,
    required this.onComplaintSubmitted,
    required this.goBack,
  });
  final Function(dynamic complaint) onComplaintSubmitted;
  final Function() goBack;

  @override
  State<ChiefComplaintPage> createState() => _ChiefComplaintPageState();
}

class _ChiefComplaintPageState extends State<ChiefComplaintPage> {
  final TextEditingController _chiefComplaintController =
      TextEditingController();
  final TextEditingController _timestampController = TextEditingController(
    text: '01/15/2024, 02:30 PM',
  );
  final TextEditingController _clinicianController = TextEditingController(
    text: 'Nurse Ad4wale',
  );

  final List<String> _selectedSymptoms = [];

  final List<Map<String, dynamic>> _commonSymptoms = [
    {'name': 'Fever', 'icon': Icons.thermostat},
    {'name': 'Cough', 'icon': Icons.sick},
    {'name': 'Headache', 'icon': Icons.psychology},
    {'name': 'Chest Pain', 'icon': Icons.favorite},
    {'name': 'Abdominal Pain', 'icon': Icons.circle_outlined},
    {'name': 'Fatigue', 'icon': Icons.battery_2_bar},
    {'name': 'Shortness of Breath', 'icon': Icons.air},
  ];

  void _toggleSymptom(String symptom) {
    setState(() {
      if (_selectedSymptoms.contains(symptom)) {
        _selectedSymptoms.remove(symptom);
      } else {
        _selectedSymptoms.add(symptom);
      }
    });
  }

  Patient? currentPatient;
  @override
  void initState() {
    // TODO: implement initState
   currentPatient= Provider.of<PatientProvider>(context, listen: false).currentPatient;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF059669),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.chat_bubble_outline,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chief Complaint',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Patient Encounter Entry',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            const Spacer(),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Nurse Ad4wale',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Internal Medicine',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            const CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, color: Colors.white),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patient Info Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child:  Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Color(0xFF6EE7B7),
                    child: Icon(Icons.person, color: Color(0xFF059669)),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                         currentPatient?.name??'',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'DOB: 03/15/1985  • Age:${currentPatient?.age ?? ''} • MRN: ${currentPatient?.mrn ?? ''} ',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Appointment Time',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        'Wednesday 4:57 AM',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Chief Complaint Entry Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF059669),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.chat_bubble_outline,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Chief Complaint Entry',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Question
                  const Text(
                    'What brings the patient in today?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Text Field
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: TextField(
                      controller: _chiefComplaintController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText:
                            'Enter the primary reason for today\'s visit...',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Be specific and concise. This will help guide the rest of the encounter.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),

                  const SizedBox(height: 24),

                  // Common Symptoms
                  const Text(
                    'Common Symptoms (Optional)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Symptom Chips
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ..._commonSymptoms.map(
                        (symptom) =>
                            _buildSymptomChip(symptom['name'], symptom['icon']),
                      ),
                      _buildAddOtherChip(),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Timestamp and Clinician
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Encounter Timestamp',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: TextField(
                                controller: _timestampController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 12,
                                  ),
                                  suffixIcon: Icon(
                                    Icons.calendar_today,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Attending Clinician',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: TextField(
                                controller: _clinicianController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 12,
                                  ),
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
            ),

            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                TextButton.icon(
                  onPressed: () {
                    widget.goBack();
                  },
                  icon: const Icon(Icons.arrow_back, size: 16),
                  label: const Text('Back to Patient List'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey.shade600,
                  ),
                ),
                const Spacer(),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text('Save Draft'),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    widget.onComplaintSubmitted(_chiefComplaintController.text);
                  },
                  icon: const Icon(Icons.arrow_forward, size: 16),
                  label: const Text('Continue to HPI'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF059669),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Bottom Action Cards
            Row(
              children: [
                Expanded(
                  child: _buildActionCard(
                    icon: Icons.mic,
                    title: 'Voice Input',
                    subtitle: 'Dictate complaint',
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildActionCard(
                    icon: Icons.history,
                    title: 'Previous Visits',
                    subtitle: 'View history',
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildActionCard(
                    icon: Icons.description,
                    title: 'Templates',
                    subtitle: 'Use preset',
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSymptomChip(String label, IconData icon) {
    final isSelected = _selectedSymptoms.contains(label);
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isSelected ? Colors.white : Colors.grey.shade600,
          ),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) => _toggleSymptom(label),
      selectedColor: const Color(0xFF059669),
      backgroundColor: Colors.grey.shade100,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.grey.shade700,
        fontSize: 13,
      ),
      side: BorderSide(
        color: isSelected ? const Color(0xFF059669) : Colors.grey.shade300,
      ),
    );
  }

  Widget _buildAddOtherChip() {
    return ActionChip(
      label: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.add, size: 16, color: Colors.grey),
          SizedBox(width: 6),
          Text('Other'),
        ],
      ),
      onPressed: () {
        // Handle adding other symptoms
      },
      backgroundColor: Colors.grey.shade100,
      labelStyle: TextStyle(color: Colors.grey.shade700, fontSize: 13),
      side: BorderSide(color: Colors.grey.shade300),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 24, color: const Color(0xFF059669)),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            Text(
              subtitle,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _chiefComplaintController.dispose();
    _timestampController.dispose();
    _clinicianController.dispose();
    super.dispose();
  }
}
