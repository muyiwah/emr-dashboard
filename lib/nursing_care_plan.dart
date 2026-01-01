// import 'package:flutter/material.dart';


// class NursingCarePlansScreen extends StatefulWidget {
//   const NursingCarePlansScreen({Key? key}) : super(key: key);

//   @override
//   State<NursingCarePlansScreen> createState() => _NursingCarePlansScreenState();
// }

// class _NursingCarePlansScreenState extends State<NursingCarePlansScreen> {
//   int selectedTab = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FA),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF8B5CF6),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: const Icon(
//                 Icons.medical_services,
//                 color: Colors.white,
//                 size: 20,
//               ),
//             ),
//             const SizedBox(width: 12),
//             const Text(
//               'Nursing Care Plans',
//               style: TextStyle(
//                 color: Colors.black,
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           ElevatedButton.icon(
//             onPressed: () {},
//             icon: const Icon(Icons.add, size: 16),
//             label: const Text('New Care Plan'),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFF8B5CF6),
//               foregroundColor: Colors.white,
//               elevation: 0,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//           ),
//           const SizedBox(width: 16),
//           const CircleAvatar(
//             radius: 16,
//             // backgroundImage: NetworkImage('https://via.placeholder.com/32'),
//           ),
//           const SizedBox(width: 16),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Tab Bar
//           Container(
//             color: Colors.white,
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Row(
//               children: [
//                 _buildTab('Active Plans', 0),
//                 _buildTab('Completed', 1),
//                 _buildTab('Templates', 2),
//               ],
//             ),
//           ),
//           // Content
//           Expanded(
//             child: Row(
//               children: [
//                 // Left Panel
//                 Expanded(
//                   flex: 2,
//                   child: Container(
//                     color: Colors.white,
//                     child: Column(
//                       children: [
//                         // Stats Row
//                         Container(
//                           padding: const EdgeInsets.all(16),
//                           child: Row(
//                             children: [
//                               _buildStatCard(
//                                 'Active Plans',
//                                 '24',
//                                 Colors.blue,
//                                 Icons.description,
//                               ),
//                               const SizedBox(width: 16),
//                               _buildStatCard(
//                                 'Completed Today',
//                                 '18',
//                                 Colors.green,
//                                 Icons.check_circle,
//                               ),
//                               const SizedBox(width: 16),
//                               _buildStatCard(
//                                 'Escalations',
//                                 '3',
//                                 Colors.red,
//                                 Icons.warning,
//                               ),
//                               const SizedBox(width: 16),
//                               _buildStatCard(
//                                 'Compliance Rate',
//                                 '94%',
//                                 Colors.purple,
//                                 Icons.trending_up,
//                               ),
//                             ],
//                           ),
//                         ),
//                         // Active Care Plans
//                         Expanded(
//                           child: Padding(
//                             padding: const EdgeInsets.all(16),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const Text(
//                                   'Active Care Plans',
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 16),
//                                 Expanded(
//                                   child: ListView(
//                                     children: [
//                                       _buildPatientCard(
//                                         'Sarah Johnson',
//                                         'MRN: 12345678 | Bed: 4A-12',
//                                         'Current Nurse: Maria Santos, RN',
//                                         'Post-operative hip replacement',
//                                         [
//                                           'Pain Management',
//                                           'Mobility',
//                                           'Wound Care',
//                                         ],
//                                         '7/10 interventions',
//                                         'Active',
//                                         Colors.green,
//                                         0.7,
//                                       ),
//                                       const SizedBox(height: 12),
//                                       _buildPatientCard(
//                                         'Robert Chen',
//                                         'MRN: 87654321 | Bed: 4A-15',
//                                         'Current Nurse: Jennifer Lee, RN',
//                                         'Acute myocardial infarction',
//                                         [
//                                           'Cardiac Monitoring',
//                                           'Medication Admin',
//                                           'Vitals Alert',
//                                         ],
//                                         '5/8 interventions',
//                                         'Escalated',
//                                         Colors.red,
//                                         0.625,
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         // Patient Observation Log
//                         Container(
//                           padding: const EdgeInsets.all(16),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Text(
//                                 'Patient Observation Log',
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                               const SizedBox(height: 16),
//                               Row(
//                                 children: [
//                                   _buildObservationCard(
//                                     'Vital Signs',
//                                     'BP: 120/80 mmHg\nHR: 72 bpm\nTemp: 98.6°F\nSpO2: 98%',
//                                     'Last updated: 2 hours ago',
//                                     Colors.red,
//                                     Icons.favorite,
//                                   ),
//                                   const SizedBox(width: 16),
//                                   _buildObservationCard(
//                                     'Pain Score',
//                                     '4/10',
//                                     'Moderate pain\nLast assessed: 1 hour ago',
//                                     Colors.orange,
//                                     Icons.padding,
//                                   ),
//                                   const SizedBox(width: 16),
//                                   _buildObservationCard(
//                                     'Mobility',
//                                     'Ambulating with walker',
//                                     'Distance: 50 feet\nLast activity: 3 hours ago',
//                                     Colors.green,
//                                     Icons.directions_walk,
//                                   ),
//                                   const SizedBox(width: 16),
//                                   _buildObservationCard(
//                                     'Nutrition',
//                                     'Breakfast: 75% consumed',
//                                     'Fluid intake: 800ml\nLast meal: 4 hours ago',
//                                     Colors.blue,
//                                     Icons.restaurant,
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 // Right Panel
//                 Expanded(
//                   flex: 1,
//                   child: Container(
//                     color: const Color(0xFFF8F9FA),
//                     padding: const EdgeInsets.all(16),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Current Shift Tasks
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const Text(
//                               'Current Shift Tasks',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             Text(
//                               'Day Shift - 7:00 AM',
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: Colors.grey[600],
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 16),
//                         _buildTaskItem(
//                           'Vital Signs - Sarah J.',
//                           'Every 4 hours',
//                           true,
//                           'Done',
//                           Colors.green,
//                         ),
//                         _buildTaskItem(
//                           'Pain Assessment - Sarah J.',
//                           'Every 2 hours',
//                           false,
//                           'Pending',
//                           Colors.orange,
//                         ),
//                         _buildTaskItem(
//                           'Cardiac Monitor - Robert C.',
//                           'Continuous - Alert triggered',
//                           false,
//                           'Escalated',
//                           Colors.red,
//                         ),
//                         const SizedBox(height: 16),
//                         SizedBox(
//                           width: double.infinity,
//                           child: ElevatedButton(
//                             onPressed: () {},
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: const Color(0xFF8B5CF6),
//                               foregroundColor: Colors.white,
//                               padding: const EdgeInsets.symmetric(vertical: 12),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                             child: const Text('Add Task Note'),
//                           ),
//                         ),
//                         const SizedBox(height: 24),
//                         // Shift Handover
//                         const Text(
//                           'Shift Handover',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           'Next Shift Summary',
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: Colors.grey[600],
//                           ),
//                         ),
//                         const SizedBox(height: 12),
//                         Container(
//                           padding: const EdgeInsets.all(12),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(8),
//                             border: Border.all(color: Colors.grey[200]!),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Text(
//                                 'Sarah J. - Pain well controlled, ambulating with walker. Next pain eval due at 2 PM.',
//                                 style: TextStyle(fontSize: 12),
//                               ),
//                               const SizedBox(height: 8),
//                               const Text(
//                                 'Robert C. - BP elevated this morning, MD notified. Continue cardiac monitoring...',
//                                 style: TextStyle(fontSize: 12),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         const Text(
//                           'Ongoing Interventions',
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Wrap(
//                           spacing: 8,
//                           runSpacing: 4,
//                           children: [
//                             _buildInterventionChip(
//                               'Wound Care - Sarah J.',
//                               Colors.blue,
//                             ),
//                             _buildInterventionChip(
//                               'Cardiac Monitor - Robert C.',
//                               Colors.red,
//                             ),
//                             _buildInterventionChip(
//                               'Mobility - Sarah J.',
//                               Colors.green,
//                             ),
//                           ],
//                         ),
//                         const Spacer(),
//                         SizedBox(
//                           width: double.infinity,
//                           child: ElevatedButton.icon(
//                             onPressed: () {},
//                             icon: const Icon(Icons.handshake, size: 16),
//                             label: const Text('Sign Handover'),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.green,
//                               foregroundColor: Colors.white,
//                               padding: const EdgeInsets.symmetric(vertical: 12),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTab(String title, int index) {
//     final isSelected = selectedTab == index;
//     return GestureDetector(
//       onTap: () => setState(() => selectedTab = index),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         decoration: BoxDecoration(
//           color: isSelected ? const Color(0xFF8B5CF6) : Colors.transparent,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Text(
//           title,
//           style: TextStyle(
//             color: isSelected ? Colors.white : Colors.grey[600],
//             fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildStatCard(
//     String title,
//     String value,
//     Color color,
//     IconData icon,
//   ) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: Colors.grey[200]!),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.grey[600],
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 const Spacer(),
//                 Icon(icon, size: 16, color: color),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Text(
//               value,
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: color,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPatientCard(
//     String name,
//     String mrn,
//     String nurse,
//     String diagnosis,
//     List<String> interventions,
//     String progress,
//     String status,
//     Color statusColor,
//     double progressValue,
//   ) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey[200]!),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       name,
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     Text(
//                       mrn,
//                       style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                     ),
//                     Text(
//                       nurse,
//                       style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: statusColor.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Text(
//                   status,
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: statusColor,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Text(
//             'Primary Diagnosis:',
//             style: TextStyle(
//               fontSize: 12,
//               color: Colors.grey[600],
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           Text(
//             diagnosis,
//             style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//           ),
//           const SizedBox(height: 12),
//           Wrap(
//             spacing: 8,
//             runSpacing: 4,
//             children:
//                 interventions.map((intervention) {
//                   Color chipColor;
//                   switch (intervention) {
//                     case 'Pain Management':
//                       chipColor = Colors.blue;
//                       break;
//                     case 'Mobility':
//                       chipColor = Colors.green;
//                       break;
//                     case 'Wound Care':
//                       chipColor = Colors.purple;
//                       break;
//                     case 'Cardiac Monitoring':
//                       chipColor = Colors.teal;
//                       break;
//                     case 'Medication Admin':
//                       chipColor = Colors.orange;
//                       break;
//                     case 'Vitals Alert':
//                       chipColor = Colors.red;
//                       break;
//                     default:
//                       chipColor = Colors.grey;
//                   }
//                   return Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 8,
//                       vertical: 4,
//                     ),
//                     decoration: BoxDecoration(
//                       color: chipColor,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Text(
//                       intervention,
//                       style: const TextStyle(
//                         fontSize: 11,
//                         color: Colors.white,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   );
//                 }).toList(),
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               Text(
//                 'Progress: $progress',
//                 style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//               ),
//               const Spacer(),
//               if (status == 'Escalated')
//                 TextButton(
//                   onPressed: () {},
//                   child: const Text(
//                     'Urgent Review',
//                     style: TextStyle(
//                       color: Colors.red,
//                       fontSize: 12,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 )
//               else
//                 TextButton(
//                   onPressed: () {},
//                   child: const Text(
//                     'View Details',
//                     style: TextStyle(
//                       color: Color(0xFF8B5CF6),
//                       fontSize: 12,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           LinearProgressIndicator(
//             value: progressValue,
//             backgroundColor: Colors.grey[200],
//             valueColor: AlwaysStoppedAnimation<Color>(statusColor),
//             minHeight: 4,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildObservationCard(
//     String title,
//     String value,
//     String subtitle,
//     Color color,
//     IconData icon,
//   ) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: Colors.grey[200]!),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const Spacer(),
//                 Icon(icon, size: 16, color: color),
//               ],
//             ),
//             const SizedBox(height: 8),
//             if (title == 'Pain Score')
//               Text(
//                 value,
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: color,
//                 ),
//               )
//             else
//               Text(
//                 value,
//                 style: const TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             const SizedBox(height: 4),
//             Text(
//               subtitle,
//               style: TextStyle(fontSize: 10, color: Colors.grey[600]),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTaskItem(
//     String title,
//     String subtitle,
//     bool isCompleted,
//     String status,
//     Color statusColor,
//   ) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       child: Row(
//         children: [
//           Container(
//             width: 16,
//             height: 16,
//             decoration: BoxDecoration(
//               color: isCompleted ? Colors.green : Colors.transparent,
//               border: Border.all(
//                 color: isCompleted ? Colors.green : Colors.grey[400]!,
//               ),
//               borderRadius: BorderRadius.circular(4),
//             ),
//             child:
//                 isCompleted
//                     ? const Icon(Icons.check, size: 10, color: Colors.white)
//                     : null,
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 Text(
//                   subtitle,
//                   style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//             decoration: BoxDecoration(
//               color: statusColor.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Text(
//               status,
//               style: TextStyle(
//                 fontSize: 10,
//                 color: statusColor,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildInterventionChip(String text, Color color) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Text(
//         text,
//         style: TextStyle(
//           fontSize: 10,
//           color: color,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class NursingCarePlansScreen extends StatefulWidget {
  const NursingCarePlansScreen({Key? key}) : super(key: key);

  @override
  State<NursingCarePlansScreen> createState() => _NursingCarePlansScreenState();
}

class _NursingCarePlansScreenState extends State<NursingCarePlansScreen> {
  int selectedTab = 0;

  // Enhanced dummy data for patient progress
  final List<Map<String, dynamic>> patients = [
    {
      'name': 'Sarah Johnson',
      'mrn': '12345678',
      'bed': '4A-12',
      'nurse': 'Maria Santos, RN',
      'diagnosis': 'Post-operative hip replacement',
      'interventions': ['Pain Management', 'Mobility', 'Wound Care'],
      'progress': '7/10 interventions',
      'status': 'Active',
      'statusColor': Colors.green,
      'progressValue': 0.7,
      'vitalSigns': {
        'bp': '125/82',
        'hr': '78',
        'temp': '98.4°F',
        'spo2': '97%',
        'lastUpdate': '30 min ago',
      },
      'painScore': '3/10',
      'mobility': 'Ambulating 75ft with walker',
      'nutrition': 'Breakfast: 80% consumed, Fluids: 950ml',
      'notes':
          'Patient reports decreased pain, good appetite, cooperative with PT',
      'nextAssessment': '2:00 PM - Pain evaluation',
    },
    {
      'name': 'Robert Chen',
      'mrn': '87654321',
      'bed': '4A-15',
      'nurse': 'Jennifer Lee, RN',
      'diagnosis': 'Acute myocardial infarction',
      'interventions': [
        'Cardiac Monitoring',
        'Medication Admin',
        'Vitals Alert',
      ],
      'progress': '5/8 interventions',
      'status': 'Escalated',
      'statusColor': Colors.red,
      'progressValue': 0.625,
      'vitalSigns': {
        'bp': '145/90',
        'hr': '95',
        'temp': '99.1°F',
        'spo2': '94%',
        'lastUpdate': '15 min ago',
      },
      'painScore': '6/10',
      'mobility': 'Bed rest, turning q2h',
      'nutrition': 'Cardiac diet, limited fluids: 1200ml',
      'notes': 'BP elevated this morning, MD notified. EKG shows improvement',
      'nextAssessment': '1:30 PM - Cardiac enzymes due',
    },
    {
      'name': 'Emily Davis',
      'mrn': '55667788',
      'bed': '4A-08',
      'nurse': 'Michael Torres, RN',
      'diagnosis': 'Pneumonia with respiratory distress',
      'interventions': [
        'Oxygen Therapy',
        'Respiratory Care',
        'Antibiotic Admin',
      ],
      'progress': '6/7 interventions',
      'status': 'Improving',
      'statusColor': Colors.orange,
      'progressValue': 0.86,
      'vitalSigns': {
        'bp': '118/75',
        'hr': '88',
        'temp': '100.2°F',
        'spo2': '92%',
        'lastUpdate': '45 min ago',
      },
      'painScore': '2/10',
      'mobility': 'Up to chair BID, short walks',
      'nutrition': 'Soft diet, adequate intake, Fluids: 1100ml',
      'notes': 'Oxygen weaned from 4L to 2L. Cough productive, less SOB',
      'nextAssessment': '3:00 PM - Respiratory therapy',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isTablet = screenWidth >= 768 && screenWidth < 1200;
        final isDesktop = screenWidth >= 1200;
        final isMobile = screenWidth < 768;

        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FA),
          appBar: _buildResponsiveAppBar(isMobile),
          body: Column(
            children: [
              // Tab Bar
              Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 8 : 16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildTab('Active Plans', 0),
                      _buildTab('Completed', 1),
                      _buildTab('Templates', 2),
                    ],
                  ),
                ),
              ),
              // Content
              Expanded(
                child:
                    isMobile
                        ? _buildMobileLayout()
                        : Row(
                          children: [
                            // Left Panel
                            Expanded(
                              flex: isTablet ? 3 : 2,
                              child: _buildLeftPanel(isMobile, isTablet),
                            ),
                            // Right Panel
                            if (!isMobile)
                              Expanded(flex: 1, child: _buildRightPanel()),
                          ],
                        ),
              ),
            ],
          ),
          floatingActionButton:
              isMobile
                  ? FloatingActionButton(
                    onPressed: () {},
                    backgroundColor: const Color(0xFF8B5CF6),
                    child: const Icon(Icons.add, color: Colors.white),
                  )
                  : null,
        );
      },
    );
  }

  PreferredSizeWidget _buildResponsiveAppBar(bool isMobile) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.medical_services,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Nursing Care Plans',
              style: TextStyle(
                color: Colors.black,
                fontSize: isMobile ? 16 : 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      actions: [
        if (!isMobile) ...[
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add, size: 16),
            label: const Text('New Care Plan'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B5CF6),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
        const CircleAvatar(
          radius: 16,
          backgroundColor: Color(0xFF8B5CF6),
          child: Icon(Icons.person, color: Colors.white, size: 16),
        ),
        SizedBox(width: isMobile ? 8 : 16),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            color: Colors.white,
            child: const TabBar(
              labelColor: Color(0xFF8B5CF6),
              unselectedLabelColor: Colors.grey,
              indicatorColor: Color(0xFF8B5CF6),
              tabs: [Tab(text: 'Patients'), Tab(text: 'Tasks')],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [_buildMobilePatientsTab(), _buildMobileTasksTab()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobilePatientsTab() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Mobile Stats
          Container(
            padding: const EdgeInsets.all(16),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: _buildMobileStatCard(
                      'Active',
                      '24',
                      Colors.blue,
                      Icons.description,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildMobileStatCard(
                      'Done',
                      '18',
                      Colors.green,
                      Icons.check_circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildMobileStatCard(
                      'Alert',
                      '3',
                      Colors.red,
                      Icons.warning,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Patient Cards
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: patients.length,
              itemBuilder: (context, index) {
                final patient = patients[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildMobilePatientCard(patient),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileTasksTab() {
    return Container(
      color: const Color(0xFFF8F9FA),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Current Shift Tasks',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                _buildTaskItem(
                  'Vital Signs - Sarah J.',
                  'Every 4 hours',
                  true,
                  'Done',
                  Colors.green,
                ),
                _buildTaskItem(
                  'Pain Assessment - Sarah J.',
                  'Every 2 hours',
                  false,
                  'Pending',
                  Colors.orange,
                ),
                _buildTaskItem(
                  'Cardiac Monitor - Robert C.',
                  'Continuous - Alert triggered',
                  false,
                  'Escalated',
                  Colors.red,
                ),
                _buildTaskItem(
                  'Medication - Emily D.',
                  'Antibiotic due 2:00 PM',
                  false,
                  'Scheduled',
                  Colors.blue,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B5CF6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Add Task Note'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileStatCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(fontSize: 10, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMobilePatientCard(Map<String, dynamic> patient) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        patient['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Bed: ${patient['bed']} | ${patient['nurse']}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: patient['statusColor'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    patient['status'],
                    style: TextStyle(
                      fontSize: 12,
                      color: patient['statusColor'],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              patient['diagnosis'],
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            // Vital Signs Summary
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: _buildMobileVitalCard(
                      'BP',
                      patient['vitalSigns']['bp'],
                      Colors.red,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildMobileVitalCard(
                      'HR',
                      '${patient['vitalSigns']['hr']} bpm',
                      Colors.green,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildMobileVitalCard(
                      'Pain',
                      patient['painScore'],
                      Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: patient['progressValue'],
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(patient['statusColor']),
              minHeight: 6,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    patient['progress'],
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ),
                TextButton(
                  onPressed: () => _showPatientDetails(patient),
                  child: const Text(
                    'View Details',
                    style: TextStyle(color: Color(0xFF8B5CF6), fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileVitalCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLeftPanel(bool isMobile, bool isTablet) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Stats Row
          Container(
            padding: EdgeInsets.all(isMobile ? 8 : 16),
            child:
                isTablet
                    ? Column(
                      children: [
                        IntrinsicHeight(
                          child: Row(
                            children: [
                              _buildStatCard(
                                'Active Plans',
                                '24',
                                Colors.blue,
                                Icons.description,
                              ),
                              const SizedBox(width: 16),
                              _buildStatCard(
                                'Completed Today',
                                '18',
                                Colors.green,
                                Icons.check_circle,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        IntrinsicHeight(
                          child: Row(
                            children: [
                              _buildStatCard(
                                'Escalations',
                                '3',
                                Colors.red,
                                Icons.warning,
                              ),
                              const SizedBox(width: 16),
                              _buildStatCard(
                                'Compliance Rate',
                                '94%',
                                Colors.purple,
                                Icons.trending_up,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                    : IntrinsicHeight(
                      child: Row(
                        children: [
                          _buildStatCard(
                            'Active Plans',
                            '24',
                            Colors.blue,
                            Icons.description,
                          ),
                          const SizedBox(width: 16),
                          _buildStatCard(
                            'Completed Today',
                            '18',
                            Colors.green,
                            Icons.check_circle,
                          ),
                          const SizedBox(width: 16),
                          _buildStatCard(
                            'Escalations',
                            '3',
                            Colors.red,
                            Icons.warning,
                          ),
                          const SizedBox(width: 16),
                          _buildStatCard(
                            'Compliance Rate',
                            '94%',
                            Colors.purple,
                            Icons.trending_up,
                          ),
                        ],
                      ),
                    ),
          ),
          // Active Care Plans
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(isMobile ? 8 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Active Care Plans',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: patients.length,
                      itemBuilder: (context, index) {
                        final patient = patients[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildPatientCard(patient),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Patient Observation Log
          Container(
            padding: EdgeInsets.all(isMobile ? 8 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Patient Observation Log',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                isTablet
                    ? Column(
                      children: [
                        IntrinsicHeight(
                          child: Row(
                            children: [
                              _buildObservationCard(
                                'Vital Signs',
                                'BP: 125/82 mmHg\nHR: 78 bpm\nTemp: 98.4°F\nSpO2: 97%',
                                'Last updated: 30 min ago',
                                Colors.red,
                                Icons.favorite,
                              ),
                              const SizedBox(width: 16),
                              _buildObservationCard(
                                'Pain Score',
                                '3/10',
                                'Mild pain\nLast assessed: 30 min ago',
                                Colors.orange,
                                Icons.sentiment_satisfied,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        IntrinsicHeight(
                          child: Row(
                            children: [
                              _buildObservationCard(
                                'Mobility',
                                'Ambulating 75ft with walker',
                                'Good progress\nLast activity: 1 hour ago',
                                Colors.green,
                                Icons.directions_walk,
                              ),
                              const SizedBox(width: 16),
                              _buildObservationCard(
                                'Nutrition',
                                'Breakfast: 80% consumed',
                                'Fluid intake: 950ml\nLast meal: 2 hours ago',
                                Colors.blue,
                                Icons.restaurant,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                    : SizedBox(
                      height: 120,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: IntrinsicHeight(
                          child: Row(
                            children: [
                              SizedBox(
                                width: 200,
                                child: _buildObservationCard(
                                  'Vital Signs',
                                  'BP: 125/82 mmHg\nHR: 78 bpm\nTemp: 98.4°F\nSpO2: 97%',
                                  'Last updated: 30 min ago',
                                  Colors.red,
                                  Icons.favorite,
                                ),
                              ),
                              const SizedBox(width: 16),
                              SizedBox(
                                width: 200,
                                child: _buildObservationCard(
                                  'Pain Score',
                                  '3/10',
                                  'Mild pain\nLast assessed: 30 min ago',
                                  Colors.orange,
                                  Icons.sentiment_satisfied,
                                ),
                              ),
                              const SizedBox(width: 16),
                              SizedBox(
                                width: 200,
                                child: _buildObservationCard(
                                  'Mobility',
                                  'Ambulating 75ft with walker',
                                  'Good progress\nLast activity: 1 hour ago',
                                  Colors.green,
                                  Icons.directions_walk,
                                ),
                              ),
                              const SizedBox(width: 16),
                              SizedBox(
                                width: 200,
                                child: _buildObservationCard(
                                  'Nutrition',
                                  'Breakfast: 80% consumed',
                                  'Fluid intake: 950ml\nLast meal: 2 hours ago',
                                  Colors.blue,
                                  Icons.restaurant,
                                ),
                              ),
                            ],
                          ),
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

  Widget _buildRightPanel() {
    return Container(
      color: const Color(0xFFF8F9FA),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current Shift Tasks
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Current Shift Tasks',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Text(
                'Day Shift - 7:00 AM',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                _buildTaskItem(
                  'Vital Signs - Sarah J.',
                  'Every 4 hours',
                  true,
                  'Done',
                  Colors.green,
                ),
                _buildTaskItem(
                  'Pain Assessment - Sarah J.',
                  'Every 2 hours',
                  false,
                  'Pending',
                  Colors.orange,
                ),
                _buildTaskItem(
                  'Cardiac Monitor - Robert C.',
                  'Continuous - Alert triggered',
                  false,
                  'Escalated',
                  Colors.red,
                ),
                _buildTaskItem(
                  'Medication - Emily D.',
                  'Antibiotic due 2:00 PM',
                  false,
                  'Scheduled',
                  Colors.blue,
                ),
                _buildTaskItem(
                  'Respiratory Therapy - Emily D.',
                  'Breathing exercises q4h',
                  false,
                  'Pending',
                  Colors.teal,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B5CF6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Add Task Note'),
            ),
          ),
          const SizedBox(height: 24),
          // Shift Handover
          const Text(
            'Shift Handover',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            'Next Shift Summary',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sarah J. - Pain well controlled (3/10), ambulating 75ft with walker. Next pain eval due at 2 PM.',
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Robert C. - BP elevated (145/90), MD notified. Continue cardiac monitoring. EKG improving.',
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Emily D. - O2 weaned to 2L. Productive cough, less SOB. Continue respiratory care.',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Ongoing Interventions',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              _buildInterventionChip('Wound Care - Sarah J.', Colors.blue),
              _buildInterventionChip('Cardiac Monitor - Robert C.', Colors.red),
              _buildInterventionChip('Mobility - Sarah J.', Colors.green),
              _buildInterventionChip('O2 Therapy - Emily D.', Colors.teal),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.handshake, size: 16),
              label: const Text('Sign Handover'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPatientDetails(Map<String, dynamic> patient) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(patient['name']),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Bed: ${patient['bed']}'),
                    Text('Nurse: ${patient['nurse']}'),
                    const SizedBox(height: 12),
                    Text('Diagnosis: ${patient['diagnosis']}'),
                    const SizedBox(height: 12),
                    const Text(
                      'Vital Signs:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('BP: ${patient['vitalSigns']['bp']} mmHg'),
                    Text('HR: ${patient['vitalSigns']['hr']} bpm'),
                    Text('Temp: ${patient['vitalSigns']['temp']}'),
                    Text('SpO2: ${patient['vitalSigns']['spo2']}'),
                    Text('Updated: ${patient['vitalSigns']['lastUpdate']}'),
                    const SizedBox(height: 12),
                    Text('Pain Score: ${patient['painScore']}'),
                    Text('Mobility: ${patient['mobility']}'),
                    Text('Nutrition: ${patient['nutrition']}'),
                    const SizedBox(height: 12),
                    const Text(
                      'Notes:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(patient['notes']),
                    const SizedBox(height: 8),
                    const Text(
                      'Next Assessment:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(patient['nextAssessment']),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Handle update action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B5CF6),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Update'),
              ),
            ],
          ),
    );
  }

  Widget _buildTab(String title, int index) {
    final isSelected = selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => selectedTab = index),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF8B5CF6) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[600],
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(icon, size: 16, color: color),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientCard(Map<String, dynamic> patient) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patient['name'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'MRN: ${patient['mrn']} | Bed: ${patient['bed']}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    Text(
                      'Current Nurse: ${patient['nurse']}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: patient['statusColor'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  patient['status'],
                  style: TextStyle(
                    fontSize: 12,
                    color: patient['statusColor'],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Primary Diagnosis:',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            patient['diagnosis'],
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),

          // Enhanced patient data display
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vitals (${patient['vitalSigns']['lastUpdate']})',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'BP: ${patient['vitalSigns']['bp']} | HR: ${patient['vitalSigns']['hr']}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      'Pain: ${patient['painScore']}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getPainColor(patient['painScore']).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getPainIcon(patient['painScore']),
                      size: 16,
                      color: _getPainColor(patient['painScore']),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      patient['painScore'],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _getPainColor(patient['painScore']),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children:
                patient['interventions'].map<Widget>((intervention) {
                  Color chipColor;
                  switch (intervention) {
                    case 'Pain Management':
                      chipColor = Colors.blue;
                      break;
                    case 'Mobility':
                      chipColor = Colors.green;
                      break;
                    case 'Wound Care':
                      chipColor = Colors.purple;
                      break;
                    case 'Cardiac Monitoring':
                      chipColor = Colors.teal;
                      break;
                    case 'Medication Admin':
                      chipColor = Colors.orange;
                      break;
                    case 'Vitals Alert':
                      chipColor = Colors.red;
                      break;
                    case 'Oxygen Therapy':
                      chipColor = Colors.cyan;
                      break;
                    case 'Respiratory Care':
                      chipColor = Colors.indigo;
                      break;
                    case 'Antibiotic Admin':
                      chipColor = Colors.pink;
                      break;
                    default:
                      chipColor = Colors.grey;
                  }
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: chipColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      intervention,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
          ),
          const SizedBox(height: 12),

          // Progress notes
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              patient['notes'],
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
            ),
          ),

          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Progress: ${patient['progress']}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ),
              if (patient['status'] == 'Escalated')
                ElevatedButton(
                  onPressed: () => _showPatientDetails(patient),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    minimumSize: Size.zero,
                  ),
                  child: const Text(
                    'Urgent Review',
                    style: TextStyle(fontSize: 12),
                  ),
                )
              else
                TextButton(
                  onPressed: () => _showPatientDetails(patient),
                  child: const Text(
                    'View Details',
                    style: TextStyle(
                      color: Color(0xFF8B5CF6),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: patient['progressValue'],
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(patient['statusColor']),
            minHeight: 4,
          ),
          const SizedBox(height: 8),
          Text(
            'Next: ${patient['nextAssessment']}',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Color _getPainColor(String painScore) {
    final score = int.tryParse(painScore.split('/')[0]) ?? 0;
    if (score <= 3) return Colors.green;
    if (score <= 6) return Colors.orange;
    return Colors.red;
  }

  IconData _getPainIcon(String painScore) {
    final score = int.tryParse(painScore.split('/')[0]) ?? 0;
    if (score <= 3) return Icons.sentiment_satisfied;
    if (score <= 6) return Icons.sentiment_neutral;
    return Icons.sentiment_dissatisfied;
  }

  Widget _buildObservationCard(
    String title,
    String value,
    String subtitle,
    Color color,
    IconData icon,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(icon, size: 16, color: color),
              ],
            ),
            const SizedBox(height: 8),
            if (title == 'Pain Score')
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              )
            else
              Text(
                value,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskItem(
    String title,
    String subtitle,
    bool isCompleted,
    String status,
    Color statusColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => setState(() {}),
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isCompleted ? Colors.green : Colors.transparent,
                border: Border.all(
                  color: isCompleted ? Colors.green : Colors.grey[400]!,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child:
                  isCompleted
                      ? const Icon(Icons.check, size: 12, color: Colors.white)
                      : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 10,
                color: statusColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInterventionChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
