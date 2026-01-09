import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:schmgtsystem/models/patient_model.dart';
import 'package:schmgtsystem/models/vitals_model.dart';
import 'package:schmgtsystem/providers/patient_proviider.dart';

class PatientDetailsScreen extends StatefulWidget {
  final Patient patient;

  const PatientDetailsScreen({Key? key, required this.patient})
    : super(key: key);

  @override
  State<PatientDetailsScreen> createState() => _PatientDetailsScreenState();
}

class _PatientDetailsScreenState extends State<PatientDetailsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch patient with vitals history
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final patientProvider = Provider.of<PatientProvider>(
        context,
        listen: false,
      );
      patientProvider.fetchPatient(widget.patient.id, includeVitals: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/patient-management/patient-records');
            }
          },
        ),
        title: const Text(
          'Patient Details',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ElevatedButton.icon(
              onPressed: () {
                context.go('/doctors/patient-dashboard', extra: widget.patient);
              },
              icon: const Icon(Icons.dashboard, size: 18),
              label: const Text('Doctor Dashboard'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Patient Info Card
          Container(
            margin: const EdgeInsets.all(16),
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
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.blueGrey.shade100,
                      child: Text(
                        widget.patient.name.isNotEmpty
                            ? widget.patient.name.substring(0, 1).toUpperCase()
                            : '?',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.patient.name,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: widget.patient.statusColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  widget.patient.status,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 24,
                            runSpacing: 12,
                            children: [
                              _infoItem(
                                label: 'MRN',
                                value: widget.patient.mrn,
                              ),
                              _infoItem(
                                label: 'Age',
                                value: '${widget.patient.age} yrs',
                              ),
                              _infoItem(
                                label: 'Gender',
                                value: widget.patient.gender,
                              ),
                              _infoItem(
                                label: 'Phone',
                                value: widget.patient.contact,
                              ),
                              _infoItem(
                                label: 'Address',
                                value:
                                    widget.patient.address?.fullAddress ?? '',
                              ),
                              _infoItem(
                                label: 'Department',
                                value: widget.patient.department,
                              ),
                              _infoItem(
                                label: 'Doctor',
                                value: widget.patient.doctor,
                              ),
                              _infoItem(
                                label: 'Registered',
                                value:
                                    '${widget.patient.registrationTime.month}/${widget.patient.registrationTime.day}/${widget.patient.registrationTime.year}',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Vitals History Section
          Expanded(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.06),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Consumer<PatientProvider>(
                builder: (context, patientProvider, _) {
                  final vitalsHistory = patientProvider.currentPatientVitals;
                  final history = vitalsHistory?.history ?? [];
                  final latest = vitalsHistory?.latest;

                  if (vitalsHistory == null || history.isEmpty) {
                    return const Center(
                      child: Text(
                        'No vitals history available',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Vitals History',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          if (vitalsHistory.totalCount > 0)
                            Text(
                              '${vitalsHistory.totalCount} records',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (latest != null) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue[200]!),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.favorite,
                                color: Colors.blue[700],
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Latest: ',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                DateFormat(
                                  'MMM d, yyyy HH:mm',
                                ).format(latest.recordedAt),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      Expanded(
                        child: ListView.builder(
                          itemCount: history.length,
                          itemBuilder: (context, index) {
                            final vital = history[index];
                            return _buildVitalCard(vital);
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoItem({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 4),
        Text(
          value.isEmpty ? '-' : value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildVitalCard(VitalsRecord vital) {
    final vs = vital.vitalSigns;
    final bp = vs.bloodPressure?.displayValue ?? '-';
    final hr = vs.heartRate?.value.toString() ?? '-';
    final rr = vs.respiratoryRate?.value.toString() ?? '-';
    final temp = vs.temperature?.displayValue ?? '-';
    final spo2 = vs.oxygenSaturation?.value.toString() ?? '-';
    final weight = vs.weight?.value.toStringAsFixed(1) ?? '-';
    final height = vs.height?.value.toStringAsFixed(0) ?? '-';
    final glucose = vs.bloodGlucose?.value?.toStringAsFixed(1) ?? '-';
    final pain = vs.painScore?.value?.toString() ?? '-';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('MMM d, yyyy HH:mm').format(vital.recordedAt),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              if (vital.recordedBy != null)
                Text(
                  vital.recordedBy!,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 12,
            children: [
              if (bp != '-') _buildVitalItem('BP', '$bp mmHg'),
              if (hr != '-') _buildVitalItem('HR', '$hr bpm'),
              if (rr != '-') _buildVitalItem('RR', '$rr /min'),
              if (temp != '-') _buildVitalItem('Temp', temp),
              if (spo2 != '-') _buildVitalItem('SpO₂', '$spo2%'),
              if (weight != '-') _buildVitalItem('Weight', '$weight kg'),
              if (height != '-') _buildVitalItem('Height', '$height cm'),
              if (glucose != '-') _buildVitalItem('Glucose', '$glucose mmol/L'),
              if (pain != '-') _buildVitalItem('Pain', '$pain/10'),
            ],
          ),
          if (vital.notes != null && vital.notes!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                vital.notes!,
                style: TextStyle(fontSize: 12, color: Colors.grey[700]),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVitalItem(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// class PatientDetailsScreen extends StatefulWidget {
//   const PatientDetailsScreen({Key? key}) : super(key: key);

//   @override
//   State<PatientDetailsScreen> createState() => _PatientDetailsScreenState();
// }

// class _PatientDetailsScreenState extends State<PatientDetailsScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 5, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F5F5),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         title: const Text(
//           'Patient Details',
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 20,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: Container(
//               width: 32,
//               height: 32,
//               decoration: const BoxDecoration(
//                 color: Color(0xFF008080),
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(Icons.add, color: Colors.white, size: 20),
//             ),
//             onPressed: () {},
//           ),
//           IconButton(
//             icon: const Icon(Icons.more_vert, color: Colors.black),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Patient Info Card
//           Container(
//             margin: const EdgeInsets.all(16),
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.1),
//                   spreadRadius: 1,
//                   blurRadius: 4,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     // Patient Avatar
//                     Container(
//                       width: 80,
//                       height: 80,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(40),
//                         image: const DecorationImage(
//                           image: NetworkImage('https://via.placeholder.com/80'),
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     // Patient Info
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               const Text(
//                                 'Sarah Johnson',
//                                 style: TextStyle(
//                                   fontSize: 24,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                               const SizedBox(width: 12),
//                               Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 8,
//                                   vertical: 4,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: const Color(0xFFFF6B6B),
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 child: const Text(
//                                   'High Risk',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(width: 8),
//                               Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 8,
//                                   vertical: 4,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: const Color(0xFFFF8C00),
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 child: const Text(
//                                   'Chronic Illness',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 16),
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       'Patient ID:',
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         color: Colors.grey[600],
//                                       ),
//                                     ),
//                                     const Text(
//                                       'PT-2024-001',
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       'Age:',
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         color: Colors.grey[600],
//                                       ),
//                                     ),
//                                     const Text(
//                                       '45 years',
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       'Phone:',
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         color: Colors.grey[600],
//                                       ),
//                                     ),
//                                     const Text(
//                                       '+1 (555) 123-4567',
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       'Last Visit:',
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         color: Colors.grey[600],
//                                       ),
//                                     ),
//                                     const Text(
//                                       'Dec 15, 2024',
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     // Action Buttons
//                     Column(
//                       children: [
//                         ElevatedButton.icon(
//                           onPressed: () {},
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFF008080),
//                             foregroundColor: Colors.white,
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 16,
//                               vertical: 8,
//                             ),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                           icon: const Icon(Icons.edit, size: 16),
//                           label: const Text('Edit Profile'),
//                         ),
//                         const SizedBox(height: 8),
//                         ElevatedButton.icon(
//                           onPressed: () {},
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFF1E90FF),
//                             foregroundColor: Colors.white,
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 16,
//                               vertical: 8,
//                             ),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                           icon: const Icon(Icons.upload, size: 16),
//                           label: const Text('Upload Files'),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           // Action Cards
//           Container(
//             margin: const EdgeInsets.symmetric(horizontal: 16),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: _buildActionCard(
//                     icon: Icons.medical_services_outlined,
//                     iconColor: const Color(0xFF008080),
//                     iconBgColor: const Color(0xFF008080).withOpacity(0.1),
//                     title: 'Add Encounter',
//                     subtitle: 'Create new medical encounter',
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: _buildActionCard(
//                     icon: Icons.calendar_today_outlined,
//                     iconColor: const Color(0xFF1E90FF),
//                     iconBgColor: const Color(0xFF1E90FF).withOpacity(0.1),
//                     title: 'Schedule Appointment',
//                     subtitle: 'Book new appointment',
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: _buildActionCard(
//                     icon: Icons.receipt_outlined,
//                     iconColor: const Color(0xFF32CD32),
//                     iconBgColor: const Color(0xFF32CD32).withOpacity(0.1),
//                     title: 'Generate Invoice',
//                     subtitle: 'Create billing invoice',
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 20),
//           // Tab Section
//           Container(
//             color: Colors.white,
//             child: TabBar(
//               controller: _tabController,
//               isScrollable: false,
//               labelColor: const Color(0xFF008080),
//               unselectedLabelColor: Colors.grey[600],
//               indicatorColor: const Color(0xFF008080),
//               tabs: const [
//                 Tab(icon: Icon(Icons.history), text: 'Medical History'),
//                 Tab(icon: Icon(Icons.medication), text: 'Prescriptions'),
//                 Tab(icon: Icon(Icons.calendar_month), text: 'Appointments'),
//                 Tab(icon: Icon(Icons.receipt), text: 'Billing'),
//                 Tab(icon: Icon(Icons.description), text: 'Documents'),
//               ],
//             ),
//           ),
//           // Tab Content
//           Expanded(
//             child: TabBarView(
//               controller: _tabController,
//               children: [
//                 _buildMedicalHistoryTab(),
//                 _buildEmptyTab('Prescriptions'),
//                 _buildEmptyTab('Appointments'),
//                 _buildEmptyTab('Billing'),
//                 _buildEmptyTab('Documents'),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildActionCard({
//     required IconData icon,
//     required Color iconColor,
//     required Color iconBgColor,
//     required String title,
//     required String subtitle,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Container(
//             width: 48,
//             height: 48,
//             decoration: BoxDecoration(
//               color: iconBgColor,
//               borderRadius: BorderRadius.circular(24),
//             ),
//             child: Icon(icon, color: iconColor, size: 24),
//           ),
//           const SizedBox(height: 12),
//           Text(
//             title,
//             style: const TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w600,
//               color: Colors.black,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             subtitle,
//             style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMedicalHistoryTab() {
//     return Container(
//       color: const Color(0xFFF5F5F5),
//       child: Column(
//         children: [
//           // Header with Add Clinical Note button
//           Container(
//             color: Colors.white,
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   'Medical History',
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//                 ElevatedButton.icon(
//                   onPressed: () {},
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF008080),
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   icon: const Icon(Icons.add, size: 16),
//                   label: const Text('Add Clinical Note'),
//                 ),
//               ],
//             ),
//           ),
//           // Medical History Items
//           Expanded(
//             child: ListView(
//               padding: const EdgeInsets.all(16),
//               children: [
//                 _buildMedicalHistoryItem(
//                   title: 'Hypertension Follow-up',
//                   date: 'Dec 15, 2024',
//                   doctor: 'Dr. Smith',
//                   description:
//                       'Blood pressure stable at 130/85. Continue current medication regimen. Patient reports good adherence to lifestyle modifications.',
//                   status: 'Follow-up Required',
//                   statusColor: const Color(0xFFFFD700),
//                 ),
//                 const SizedBox(height: 16),
//                 _buildMedicalHistoryItem(
//                   title: 'Annual Physical Exam',
//                   date: 'Nov 20, 2024',
//                   doctor: 'Dr. Johnson',
//                   description:
//                       'Comprehensive physical examination completed. All vitals within normal limits. Recommended routine screening tests.',
//                   status: 'Completed',
//                   statusColor: const Color(0xFF32CD32),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMedicalHistoryItem({
//     required String title,
//     required String date,
//     required String doctor,
//     required String description,
//     required String status,
//     required Color statusColor,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: statusColor,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Text(
//                   status,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 12,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Text(
//             '$date • $doctor',
//             style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             description,
//             style: const TextStyle(fontSize: 14, color: Colors.black87),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildEmptyTab(String tabName) {
//     return Container(
//       color: const Color(0xFFF5F5F5),
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.folder_open, size: 64, color: Colors.grey[400]),
//             const SizedBox(height: 16),
//             Text(
//               'No $tabName data available',
//               style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Usage example:
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Patient Management',
//       theme: ThemeData(primarySwatch: Colors.teal, fontFamily: 'Roboto'),
//       home: const PatientDetailsScreen(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }
