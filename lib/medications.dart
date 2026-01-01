import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schmgtsystem/models/patient_model.dart';
import 'package:schmgtsystem/providers/patient_proviider.dart';
import 'package:schmgtsystem/widgets/medication_history_popup.dart';
import 'package:schmgtsystem/widgets/prescription_popup.dart';

class MedicationScreen extends StatefulWidget {
  MedicationScreen({super.key, required this.goBack});
  Null Function() goBack;

  @override
  _MedicationState createState() => _MedicationState();
}

class _MedicationState extends State<MedicationScreen> {
  String selectedStatus = 'All Status';
  String selectedClass = 'All Classes';
  late PatientProvider patientProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    patientProvider = Provider.of<PatientProvider>(context);
    // Initialize demo data if empty
    if (patientProvider.medications.isEmpty) {
      patientProvider.initializeDemoMedications(
        patientProvider.currentPatient?.id ?? '',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
     final medications = patientProvider.medications;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Patient Header
              _buildPatientHeader(),
              SizedBox(height: 16),

              // Drug Interaction Warning
              _buildDrugInteractionWarning(),
              SizedBox(height: 24),

              // Search and Filter Section
              _buildSearchAndFilters(),
              SizedBox(height: 24),

              // Medications List
              // _buildMedicationsList(),
               Column(
                children:
                    medications.map((medication) {
                      return Column(
                        children: [
                          _buildMedicationCard(medication),
                          SizedBox(height: 16),
                        ],
                      );
                    }).toList(),
              ),
              SizedBox(height: 24),

              // Add New MedicationScreen Button
              _buildAddMedicationButton(),
            ],
          ),
        ),
      ),
    );
  }
  // Update the _buildMedicationCard to take a Medication object
  Widget _buildMedicationCard(Medication medication) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      medication.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(width: 12),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color:
                            medication.status == 'Active'
                                ? Colors.green[50]
                                : Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        medication.status,
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              medication.status == 'Active'
                                  ? Colors.green[700]
                                  : Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (medication.showMonitorBP) ...[
                      SizedBox(width: 8),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.monitor_heart,
                              size: 12,
                              color: Colors.red[600],
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Monitor BP',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.red[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.refresh, color: Colors.grey[600]),
                    onPressed: () {},
                    padding: EdgeInsets.all(4),
                    constraints: BoxConstraints(),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.grey[600]),
                    onPressed: () {},
                    padding: EdgeInsets.all(4),
                    constraints: BoxConstraints(),
                  ),
                  IconButton(
                    icon: Icon(Icons.check_circle, color: Colors.green[600]),
                    onPressed: () {},
                    padding: EdgeInsets.all(4),
                    constraints: BoxConstraints(),
                  ),
                  IconButton(
                    icon: Icon(Icons.cancel, color: Colors.red[600]),
                    onPressed: () {},
                    padding: EdgeInsets.all(4),
                    constraints: BoxConstraints(),
                  ),
                  IconButton(
                    icon: Icon(Icons.lock, color: Colors.indigo[600]),
                    onPressed: () {},
                    padding: EdgeInsets.all(4),
                    constraints: BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dosage',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      medication.dosage,
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Frequency',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      medication.frequency,
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Duration',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      medication.duration,
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Prescribed by: ${medication.prescribedBy}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ),
              Text(
                medication.status == 'Completed' && medication.endDate != null
                    ? 'Completed: ${medication.endDate!.month}/${medication.endDate!.day}/${medication.endDate!.year}'
                    : 'Start: ${medication.formattedStartDate}',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
          if (medication.additionalInfo != null) ...[
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      medication.additionalInfo!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (medication.targetInfo != null)
                    Text(
                      medication.targetInfo!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPatientHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Patient Avatar
          CircleAvatar(
            radius: 30,
            // backgroundImage: AssetImage(
            //   'assets/patient_avatar.jpg',
            // ), // Replace with actual image
            backgroundColor: Colors.grey[300],
            child: Icon(Icons.person, size: 30, color: Colors.grey[600]),
          ),
          SizedBox(width: 16),

          // Patient Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sarah Johnson',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'ID: #PAT-2024-0847',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                SizedBox(height: 2),
                Text(
                  '42 years • Female • O+',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          // Medical Conditions and Allergies
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Allergies
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.warning, size: 16, color: Colors.red[600]),
                    SizedBox(width: 4),
                    Text(
                      'Allergies: Penicillin, Latex',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),

              // Medical Conditions
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'ICD-10: I10 Hypertension',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'ICD-10: E11 Type 2 DM',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDrugInteractionWarning() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber, color: Colors.orange[600], size: 24),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Potential Drug Interaction Detected',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[800],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Lisinopril and Metformin may affect kidney function. Monitor creatinine levels.',
                  style: TextStyle(fontSize: 14, color: Colors.orange[700]),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.orange[600]),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Row(
      children: [
        // Search Bar
        IconButton(
          onPressed: () {
            widget.goBack();
          },
          icon: Icon(Icons.arrow_back_ios_new, size: 18),
        ),
        SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search medications...',
                prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 16),

        // Status Filter
        Expanded(
          child: Container(
            height: 48,
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedStatus,
                isExpanded: true,
                items:
                    ['All Status', 'Active', 'Completed', 'Paused'].map((
                      String value,
                    ) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedStatus = newValue!;
                  });
                },
              ),
            ),
          ),
        ),
        SizedBox(width: 16),

        // Class Filter
        Expanded(
          child: Container(
            height: 48,
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedClass,
                isExpanded: true,
                items:
                    [
                      'All Classes',
                      'ACE Inhibitors',
                      'Antidiabetics',
                      'Antibiotics',
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedClass = newValue!;
                  });
                },
              ),
            ),
          ),
        ),
        SizedBox(width: 16),

        // Med History Button
        ElevatedButton.icon(
          onPressed: () {
            showDialog(
              context: context,
              builder:
                  (context) => MedicationHistoryPopup(
                    patientName: "John Doe",
                    patientId: "P001234",
                  ),
            );
          },
          icon: Icon(Icons.history, size: 18),
          label: Text('Med History'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo[600],
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  // Widget _buildMedicationsList() {
  //   return Column(
  //     children: [
  //       // Lisinopril
  //       _buildMedicationCard(
  //         name: 'Lisinopril',
  //         dosage: '10mg tablet',
  //         frequency: 'Once daily',
  //         duration: 'Ongoing',
  //         prescribedBy: 'Dr. Michael Chen',
  //         startDate: 'Jan 15, 2024',
  //         status: 'Active',
  //         additionalInfo: 'Recent BP: 128/82 mmHg',
  //         additionalInfoColor: Colors.blue,
  //         targetInfo: 'Target: <140/90',
  //         targetInfoColor: Colors.blue,
  //         showMonitorBP: true,
  //       ),
  //       SizedBox(height: 16),

  //       // Metformin
  //       _buildMedicationCard(
  //         name: 'Metformin',
  //         dosage: '500mg tablet',
  //         frequency: 'Twice daily with meals',
  //         duration: 'Ongoing',
  //         prescribedBy: 'Dr. Sarah Williams',
  //         startDate: 'Dec 8, 2023',
  //         status: 'Active',
  //         additionalInfo: 'Recent HbA1c: 6.8%',
  //         additionalInfoColor: Colors.green,
  //         targetInfo: 'Target: <7.0%',
  //         targetInfoColor: Colors.green,
  //       ),
  //       SizedBox(height: 16),

  //       // Amoxicillin
  //       _buildMedicationCard(
  //         name: 'Amoxicillin',
  //         dosage: '500mg capsule',
  //         frequency: '3 times daily',
  //         duration: '7 days',
  //         prescribedBy: 'Dr. Michael Chen',
  //         startDate: 'Nov 28, 2024',
  //         status: 'Completed',
  //         isCompleted: true,
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildMedicationCard({
  //   required String name,
  //   required String dosage,
  //   required String frequency,
  //   required String duration,
  //   required String prescribedBy,
  //   required String startDate,
  //   required String status,
  //   String? additionalInfo,
  //   Color? additionalInfoColor,
  //   String? targetInfo,
  //   Color? targetInfoColor,
  //   bool showMonitorBP = false,
  //   bool isCompleted = false,
  // }) {
  //   return Container(
  //     padding: EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(12),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.grey.withOpacity(0.1),
  //           spreadRadius: 1,
  //           blurRadius: 4,
  //           offset: Offset(0, 2),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         // Header Row
  //         Row(
  //           children: [
  //             Expanded(
  //               child: Row(
  //                 children: [
  //                   Text(
  //                     name,
  //                     style: TextStyle(
  //                       fontSize: 18,
  //                       fontWeight: FontWeight.bold,
  //                       color: Colors.black87,
  //                     ),
  //                   ),
  //                   SizedBox(width: 12),
  //                   Container(
  //                     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  //                     decoration: BoxDecoration(
  //                       color:
  //                           status == 'Active'
  //                               ? Colors.green[50]
  //                               : Colors.grey[100],
  //                       borderRadius: BorderRadius.circular(12),
  //                     ),
  //                     child: Text(
  //                       status,
  //                       style: TextStyle(
  //                         fontSize: 12,
  //                         color:
  //                             status == 'Active'
  //                                 ? Colors.green[700]
  //                                 : Colors.grey[600],
  //                         fontWeight: FontWeight.w500,
  //                       ),
  //                     ),
  //                   ),
  //                   if (showMonitorBP) ...[
  //                     SizedBox(width: 8),
  //                     Container(
  //                       padding: EdgeInsets.symmetric(
  //                         horizontal: 8,
  //                         vertical: 4,
  //                       ),
  //                       decoration: BoxDecoration(
  //                         color: Colors.red[50],
  //                         borderRadius: BorderRadius.circular(12),
  //                       ),
  //                       child: Row(
  //                         mainAxisSize: MainAxisSize.min,
  //                         children: [
  //                           Icon(
  //                             Icons.monitor_heart,
  //                             size: 12,
  //                             color: Colors.red[600],
  //                           ),
  //                           SizedBox(width: 4),
  //                           Text(
  //                             'Monitor BP',
  //                             style: TextStyle(
  //                               fontSize: 12,
  //                               color: Colors.red[600],
  //                               fontWeight: FontWeight.w500,
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ],
  //                 ],
  //               ),
  //             ),
  //             // Action Icons
  //             Row(
  //               children: [
  //                 IconButton(
  //                   icon: Icon(Icons.refresh, color: Colors.grey[600]),
  //                   onPressed: () {},
  //                   padding: EdgeInsets.all(4),
  //                   constraints: BoxConstraints(),
  //                 ),
  //                 IconButton(
  //                   icon: Icon(Icons.edit, color: Colors.grey[600]),
  //                   onPressed: () {},
  //                   padding: EdgeInsets.all(4),
  //                   constraints: BoxConstraints(),
  //                 ),
  //                 IconButton(
  //                   icon: Icon(Icons.check_circle, color: Colors.green[600]),
  //                   onPressed: () {},
  //                   padding: EdgeInsets.all(4),
  //                   constraints: BoxConstraints(),
  //                 ),
  //                 IconButton(
  //                   icon: Icon(Icons.cancel, color: Colors.red[600]),
  //                   onPressed: () {},
  //                   padding: EdgeInsets.all(4),
  //                   constraints: BoxConstraints(),
  //                 ),
  //                 IconButton(
  //                   icon: Icon(Icons.lock, color: Colors.indigo[600]),
  //                   onPressed: () {},
  //                   padding: EdgeInsets.all(4),
  //                   constraints: BoxConstraints(),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //         SizedBox(height: 12),

  //         // MedicationScreen Details
  //         Row(
  //           children: [
  //             Expanded(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     'Dosage',
  //                     style: TextStyle(
  //                       fontSize: 12,
  //                       color: Colors.grey[600],
  //                       fontWeight: FontWeight.w500,
  //                     ),
  //                   ),
  //                   Text(
  //                     dosage,
  //                     style: TextStyle(fontSize: 14, color: Colors.black87),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             Expanded(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     'Frequency',
  //                     style: TextStyle(
  //                       fontSize: 12,
  //                       color: Colors.grey[600],
  //                       fontWeight: FontWeight.w500,
  //                     ),
  //                   ),
  //                   Text(
  //                     frequency,
  //                     style: TextStyle(fontSize: 14, color: Colors.black87),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             Expanded(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     'Duration',
  //                     style: TextStyle(
  //                       fontSize: 12,
  //                       color: Colors.grey[600],
  //                       fontWeight: FontWeight.w500,
  //                     ),
  //                   ),
  //                   Text(
  //                     duration,
  //                     style: TextStyle(fontSize: 14, color: Colors.black87),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //         SizedBox(height: 12),

  //         // Prescribed By and Start Date
  //         Row(
  //           children: [
  //             Expanded(
  //               child: Text(
  //                 'Prescribed by: $prescribedBy',
  //                 style: TextStyle(fontSize: 14, color: Colors.grey[600]),
  //               ),
  //             ),
  //             Text(
  //               isCompleted ? 'Completed: $startDate' : 'Start: $startDate',
  //               style: TextStyle(fontSize: 14, color: Colors.grey[600]),
  //             ),
  //           ],
  //         ),

  //         // Additional Info (BP or HbA1c)
  //         if (additionalInfo != null) ...[
  //           SizedBox(height: 12),
  //           Container(
  //             padding: EdgeInsets.all(12),
  //             decoration: BoxDecoration(
  //               color: additionalInfoColor?.withOpacity(0.1),
  //               borderRadius: BorderRadius.circular(8),
  //             ),
  //             child: Row(
  //               children: [
  //                 Expanded(
  //                   child: Text(
  //                     additionalInfo,
  //                     style: TextStyle(
  //                       fontSize: 14,
  //                       color: additionalInfoColor,
  //                       fontWeight: FontWeight.w500,
  //                     ),
  //                   ),
  //                 ),
  //                 if (targetInfo != null)
  //                   Text(
  //                     targetInfo,
  //                     style: TextStyle(
  //                       fontSize: 14,
  //                       color: targetInfoColor,
  //                       fontWeight: FontWeight.w500,
  //                     ),
  //                   ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ],
  //     ),
  //   );
  // }

  Widget _buildAddMedicationButton() {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddMedicationPopup(),
          ).then((e) {
            if (e != null) {
              // print('Selected medication: ${e.medication}');
              // print('Dosage: ${e.dosage}');
              // print('Frequency: ${e.frequency}');
              // print('Duration: ${e.duration}');
              // print('Start Date: ${e.startDate}');

              // // Handle the selected medication data
              // // Add to your medication list, save to database, etc.






              //  final newMedication = Medication(
              //   id: 'med-${DateTime.now().millisecondsSinceEpoch}',
              //   patientId: patientProvider.currentPatient?.id ?? '',
              //   name: result.medication,
              //   dosage: result.dosage,
              //   frequency: result.frequency,
              //   duration: result.duration,
              //   prescribedBy:
              //       'Dr. ${patientProvider.currentPatient?.doctor ?? 'Unknown'}',
              //   startDate: result.startDate,
              //   status: 'Active',
              // );

              // // Add to provider
              // patientProvider.addMedication(newMedication);
            } else {
              print('User cancelled or no medication selected');
            }
          });
        },
        icon: Icon(Icons.add, size: 20),
        label: Text('Add New Medication'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.indigo[600],
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
