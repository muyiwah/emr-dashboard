import 'package:flutter/material.dart';

class MedicationHistoryPopup extends StatefulWidget {
  final String patientName;
  final String patientId;

  const MedicationHistoryPopup({
    Key? key,
    required this.patientName,
    required this.patientId,
  }) : super(key: key);

  @override
  _MedicationHistoryPopupState createState() => _MedicationHistoryPopupState();
}

class _MedicationHistoryPopupState extends State<MedicationHistoryPopup> {
  String searchQuery = '';
  String selectedFilter = 'All';

  // Sample medication data
 final List<MedicationRecord> medications = [
    MedicationRecord(
      drugName: 'Metformin',
      dosage: '500mg',
      frequency: 'Twice daily',
      startDate: DateTime(2024, 1, 15),
      endDate: DateTime(2024, 6, 15),
      reason: 'Type 2 Diabetes Management',
      prescribedBy: 'Dr. Smith',
      status: 'Completed',
      notes: 'Take with meals to reduce stomach upset',
    ),
    MedicationRecord(
      drugName: 'Lisinopril',
      dosage: '10mg',
      frequency: 'Once daily',
      startDate: DateTime(2024, 3, 1),
      endDate: null,
      reason: 'Hypertension',
      prescribedBy: 'Dr. Johnson',
      status: 'Active',
      notes: 'Monitor blood pressure regularly',
    ),
    MedicationRecord(
      drugName: 'Atorvastatin',
      dosage: '20mg',
      frequency: 'Once daily (evening)',
      startDate: DateTime(2024, 2, 10),
      endDate: null,
      reason: 'High Cholesterol',
      prescribedBy: 'Dr. Smith',
      status: 'Active',
      notes: 'Take in the evening with or without food',
    ),
    MedicationRecord(
      drugName: 'Amoxicillin',
      dosage: '250mg',
      frequency: 'Three times daily',
      startDate: DateTime(2024, 5, 20),
      endDate: DateTime(2024, 5, 27),
      reason: 'Bacterial Infection',
      prescribedBy: 'Dr. Brown',
      status: 'Completed',
      notes: 'Complete full course even if feeling better',
    ),
    MedicationRecord(
      drugName: 'Aspirin',
      dosage: '81mg',
      frequency: 'Once daily',
      startDate: DateTime(2023, 12, 1),
      endDate: null,
      reason: 'Cardiovascular Prevention',
      prescribedBy: 'Dr. Johnson',
      status: 'Active',
      notes: 'Take with food to prevent stomach irritation',
    ),
    MedicationRecord(
      drugName: 'Omeprazole',
      dosage: '20mg',
      frequency: 'Once daily',
      startDate: DateTime(2024, 4, 5),
      endDate: DateTime(2024, 7, 5),
      reason: 'Acid Reflux',
      prescribedBy: 'Dr. Williams',
      status: 'Completed',
      notes: 'Take 30 minutes before breakfast',
    ),
    MedicationRecord(
      drugName: 'Levothyroxine',
      dosage: '50mcg',
      frequency: 'Once daily (morning)',
      startDate: DateTime(2023, 11, 15),
      endDate: null,
      reason: 'Hypothyroidism',
      prescribedBy: 'Dr. Anderson',
      status: 'Active',
      notes: 'Take on empty stomach, 30-60 minutes before breakfast',
    ),
    MedicationRecord(
      drugName: 'Albuterol',
      dosage: '90mcg/inhalation',
      frequency: 'As needed',
      startDate: DateTime(2024, 1, 10),
      endDate: null,
      reason: 'Asthma',
      prescribedBy: 'Dr. Lee',
      status: 'Active',
      notes: 'Use at first sign of breathing difficulty',
    ),
    MedicationRecord(
      drugName: 'Sertraline',
      dosage: '100mg',
      frequency: 'Once daily',
      startDate: DateTime(2024, 2, 20),
      endDate: null,
      reason: 'Depression',
      prescribedBy: 'Dr. Patel',
      status: 'Active',
      notes: 'May take 4-6 weeks to see full effect',
    ),
    MedicationRecord(
      drugName: 'Ibuprofen',
      dosage: '400mg',
      frequency: 'Every 6 hours as needed',
      startDate: DateTime(2024, 6, 1),
      endDate: DateTime(2024, 6, 15),
      reason: 'Pain Relief',
      prescribedBy: 'Dr. Wilson',
      status: 'Completed',
      notes: 'Take with food, maximum 1200mg per day',
    ),
    MedicationRecord(
      drugName: 'Hydrochlorothiazide',
      dosage: '25mg',
      frequency: 'Once daily',
      startDate: DateTime(2024, 3, 15),
      endDate: null,
      reason: 'Edema',
      prescribedBy: 'Dr. Johnson',
      status: 'Active',
      notes: 'Take in morning to avoid nighttime urination',
    ),
    MedicationRecord(
      drugName: 'Prednisone',
      dosage: '10mg',
      frequency: 'Once daily',
      startDate: DateTime(2024, 5, 1),
      endDate: DateTime(2024, 5, 15),
      reason: 'Inflammation',
      prescribedBy: 'Dr. Brown',
      status: 'Completed',
      notes: 'Taper dose as directed, do not stop suddenly',
    ),
    MedicationRecord(
      drugName: 'Gabapentin',
      dosage: '300mg',
      frequency: 'Three times daily',
      startDate: DateTime(2024, 4, 10),
      endDate: null,
      reason: 'Neuropathic Pain',
      prescribedBy: 'Dr. Miller',
      status: 'Active',
      notes: 'May cause drowsiness - use caution when driving',
    ),
    MedicationRecord(
      drugName: 'Losartan',
      dosage: '50mg',
      frequency: 'Once daily',
      startDate: DateTime(2024, 1, 5),
      endDate: null,
      reason: 'Hypertension',
      prescribedBy: 'Dr. Johnson',
      status: 'Active',
      notes: 'Monitor kidney function periodically',
    ),
    MedicationRecord(
      drugName: 'Citalopram',
      dosage: '20mg',
      frequency: 'Once daily',
      startDate: DateTime(2023, 12, 15),
      endDate: null,
      reason: 'Anxiety',
      prescribedBy: 'Dr. Patel',
      status: 'Active',
      notes: 'Avoid alcohol while taking this medication',
    ),
    MedicationRecord(
      drugName: 'Tramadol',
      dosage: '50mg',
      frequency: 'Every 6 hours as needed',
      startDate: DateTime(2024, 5, 10),
      endDate: DateTime(2024, 5, 24),
      reason: 'Post-Surgical Pain',
      prescribedBy: 'Dr. Wilson',
      status: 'Completed',
      notes: 'Maximum 400mg per day, may cause drowsiness',
    ),
    MedicationRecord(
      drugName: 'Montelukast',
      dosage: '10mg',
      frequency: 'Once daily (evening)',
      startDate: DateTime(2024, 2, 1),
      endDate: null,
      reason: 'Allergic Rhinitis',
      prescribedBy: 'Dr. Lee',
      status: 'Active',
      notes: 'Take in evening for nighttime/allergy symptoms',
    ),
    MedicationRecord(
      drugName: 'Pantoprazole',
      dosage: '40mg',
      frequency: 'Once daily',
      startDate: DateTime(2024, 3, 20),
      endDate: DateTime(2024, 6, 20),
      reason: 'GERD',
      prescribedBy: 'Dr. Williams',
      status: 'Active',
      notes: 'Take before breakfast',
    ),
    MedicationRecord(
      drugName: 'Metoprolol',
      dosage: '50mg',
      frequency: 'Twice daily',
      startDate: DateTime(2023, 11, 1),
      endDate: null,
      reason: 'Heart Disease',
      prescribedBy: 'Dr. Anderson',
      status: 'Active',
      notes: 'Do not stop suddenly - must taper dose',
    ),
    MedicationRecord(
      drugName: 'Diazepam',
      dosage: '5mg',
      frequency: 'As needed',
      startDate: DateTime(2024, 4, 15),
      endDate: DateTime(2024, 7, 15),
      reason: 'Muscle Spasms',
      prescribedBy: 'Dr. Miller',
      status: 'Active',
      notes: 'Use sparingly, may be habit forming',
    ),
  ];
  List<MedicationRecord> get filteredMedications {
    List<MedicationRecord> filtered = medications;

    // Apply status filter
    if (selectedFilter != 'All') {
      filtered = filtered.where((med) => med.status == selectedFilter).toList();
    }

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      filtered =
          filtered
              .where(
                (med) =>
                    med.drugName.toLowerCase().contains(
                      searchQuery.toLowerCase(),
                    ) ||
                    med.reason.toLowerCase().contains(
                      searchQuery.toLowerCase(),
                    ) ||
                    med.prescribedBy.toLowerCase().contains(
                      searchQuery.toLowerCase(),
                    ),
              )
              .toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.shade400,
                    Colors.blue.shade600,
                    Colors.purple.shade500,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.medication_liquid,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Medication History',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${widget.patientName} • ID: ${widget.patientId}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
            ),

            // Search and Filter Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade200, width: 1),
                ),
              ),
              child: Column(
                children: [
                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search medications...',
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: Colors.grey.shade500,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Filter Chips
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                        ['All', 'Active', 'Completed']
                            .map(
                              (filter) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                child: FilterChip(
                                  label: Text(
                                    filter,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color:
                                          selectedFilter == filter
                                              ? Colors.white
                                              : Colors.grey.shade600,
                                    ),
                                  ),
                                  selected: selectedFilter == filter,
                                  onSelected: (selected) {
                                    setState(() {
                                      selectedFilter = filter;
                                    });
                                  },
                                  selectedColor: Colors.blue.shade500,
                                  backgroundColor: Colors.white,
                                  side: BorderSide(
                                    color:
                                        selectedFilter == filter
                                            ? Colors.blue.shade500
                                            : Colors.grey.shade300,
                                  ),
                                  elevation: selectedFilter == filter ? 3 : 1,
                                  shadowColor: Colors.blue.shade200,
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ],
              ),
            ),

            // Medications List
            Expanded(
              child:
                  filteredMedications.isEmpty
                      ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No medications found',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                      : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        itemCount: filteredMedications.length,
                        itemBuilder: (context, index) {
                          final medication = filteredMedications[index];
                          return MedicationCard(
                            medication: medication,
                            index: index,
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}

class MedicationCard extends StatelessWidget {
  final MedicationRecord medication;
  final int index;

  const MedicationCard({
    Key? key,
    required this.medication,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.all(10),
          // childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          leading: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors:
                    medication.status == 'Active'
                        ? [Colors.green.shade400, Colors.teal.shade500]
                        : [Colors.grey.shade400, Colors.grey.shade500],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: (medication.status == 'Active'
                          ? Colors.green.shade300
                          : Colors.grey.shade300)
                      .withOpacity(0.4),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              medication.status == 'Active'
                  ? Icons.medical_services_rounded
                  : Icons.assignment_turned_in_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          title: Row(
            children: [
              Text(
                medication.drugName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),SizedBox(width: 20,),
               Text(
                medication.reason,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          subtitle: Row(
            children: [
              Container(margin: EdgeInsets.only(top: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color:
                      medication.status == 'Active'
                          ? Colors.green.shade100
                          : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  medication.status,
                  style: TextStyle(
                    color:
                        medication.status == 'Active'
                            ? Colors.green.shade700
                            : Colors.grey.shade600,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '${medication.dosage} • ${medication.frequency}',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildDetailRow(
                    'Start Date',
                    _formatDate(medication.startDate),
                    Icons.calendar_today,
                  ),
                  if (medication.endDate != null)
                    _buildDetailRow(
                      'End Date',
                      _formatDate(medication.endDate!),
                      Icons.event_available,
                    ),
                  _buildDetailRow(
                    'Prescribed By',
                    medication.prescribedBy,
                    Icons.person,
                  ),
                  _buildDetailRow(
                    'Dosage',
                    medication.dosage,
                    Icons.medication,
                  ),
                  _buildDetailRow(
                    'Frequency',
                    medication.frequency,
                    Icons.schedule,
                  ),
                  if (medication.notes.isNotEmpty)
                    _buildDetailRow('Notes', medication.notes, Icons.notes),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class MedicationRecord {
  final String drugName;
  final String dosage;
  final String frequency;
  final DateTime startDate;
  final DateTime? endDate;
  final String reason;
  final String prescribedBy;
  final String status;
  final String notes;

  MedicationRecord({
    required this.drugName,
    required this.dosage,
    required this.frequency,
    required this.startDate,
    this.endDate,
    required this.reason,
    required this.prescribedBy,
    required this.status,
    this.notes = '',
  });
}

// Usage example:
// To show the popup, call:
// showDialog(
//   context: context,
//   builder: (context) => MedicationHistoryPopup(
//     patientName: "John Doe",
//     patientId: "P001234",
//   ),
// );
