// import 'package:flutter/material.dart';




// class PatientManagementScreen extends StatefulWidget {
//   const PatientManagementScreen({super.key});

//   @override
//   State<PatientManagementScreen> createState() =>
//       _PatientManagementScreenState();
// }

// class _PatientManagementScreenState extends State<PatientManagementScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   String _selectedFilter = 'All Patients';

//   final List<Patient> _patients = [
//     Patient(
//       id: 'PT-2024-001',
//       name: 'Emily Johnson',
//       age: 32,
//       phone: '(555) 123-4567',
//       lastVisit: 'Dec 15, 2024',
//       status: PatientStatus.highRisk,
//       avatar: 'assets/emily.jpg',
//     ),
//     Patient(
//       id: 'PT-2024-002',
//       name: 'Michael Chen',
//       age: 45,
//       phone: '(555) 987-6543',
//       lastVisit: 'Dec 18, 2024',
//       status: PatientStatus.chronic,
//       avatar: 'assets/michael.jpg',
//     ),
//     Patient(
//       id: 'PT-2024-003',
//       name: 'Sarah Davis',
//       age: 28,
//       phone: '(555) 456-7890',
//       lastVisit: 'Dec 20, 2024',
//       status: PatientStatus.stable,
//       avatar: 'assets/sarah.jpg',
//     ),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FA),
//       appBar: _buildAppBar(),
//       body: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildHeader(),
//             const SizedBox(height: 32),
//             _buildSearchAndFilter(),
//             const SizedBox(height: 32),
//             Expanded(child: _buildPatientGrid()),
//           ],
//         ),
//       ),
//     );
//   }

//   PreferredSizeWidget _buildAppBar() {
//     return AppBar(
//       backgroundColor: Colors.white,
//       elevation: 0,
//       toolbarHeight: 80,
//       leading: Padding(
//         padding: const EdgeInsets.only(left: 24.0),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               width: 32,
//               height: 32,
//               decoration: const BoxDecoration(
//                 color: Color(0xFF00A693),
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(Icons.favorite, color: Colors.white, size: 18),
//             ),
//             const SizedBox(width: 12),
//             const Text(
//               'Medicare EMR',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.black,
//               ),
//             ),
//           ],
//         ),
//       ),
//       leadingWidth: 200,
//       actions: [
//         _buildNavItem('Patients', true),
//         _buildNavItem('Appointments', false),
//         _buildNavItem('Billing', false),
//         _buildNavItem('Reports', false),
//         const SizedBox(width: 40),
//         const Icon(Icons.notifications_outlined, color: Colors.grey),
//         const SizedBox(width: 20),
//         _buildUserProfile(),
//         const SizedBox(width: 24),
//       ],
//     );
//   }

//   Widget _buildNavItem(String title, bool isActive) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//       child: Text(
//         title,
//         style: TextStyle(
//           fontSize: 16,
//           fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
//           color: isActive ? Colors.black : Colors.grey[600],
//         ),
//       ),
//     );
//   }

//   Widget _buildUserProfile() {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         CircleAvatar(
//           radius: 18,
//           backgroundColor: Colors.grey[300],
//           child: const Icon(Icons.person, color: Colors.grey),
//         ),
//         const SizedBox(width: 8),
//         const Text(
//           'Dr. Sarah Wilson',
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//             color: Colors.black,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildHeader() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Patient Management',
//               style: TextStyle(
//                 fontSize: 32,
//                 fontWeight: FontWeight.w700,
//                 color: Colors.black,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Manage patient records and medical information',
//               style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//             ),
//           ],
//         ),
//         ElevatedButton.icon(
//           onPressed: () {},
//           icon: const Icon(Icons.add, size: 18),
//           label: const Text('Add New Patient'),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: const Color(0xFF00A693),
//             foregroundColor: Colors.white,
//             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//             textStyle: const TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildSearchAndFilter() {
//     return Row(
//       children: [
//         Expanded(
//           child: Container(
//             height: 48,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(color: Colors.grey[300]!),
//             ),
//             child: TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 hintText: 'Search patients by name, ID, or phone...',
//                 hintStyle: TextStyle(color: Colors.grey[500]),
//                 prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
//                 border: InputBorder.none,
//                 contentPadding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 12,
//                 ),
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(width: 16),
//         Container(
//           height: 48,
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(color: Colors.grey[300]!),
//           ),
//           child: DropdownButtonHideUnderline(
//             child: DropdownButton<String>(
//               value: _selectedFilter,
//               items:
//                   ['All Patients', 'High Risk', 'Chronic', 'Stable']
//                       .map(
//                         (filter) => DropdownMenuItem(
//                           value: filter,
//                           child: Text(filter),
//                         ),
//                       )
//                       .toList(),
//               onChanged: (value) {
//                 setState(() {
//                   _selectedFilter = value!;
//                 });
//               },
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildPatientGrid() {
//     return GridView.builder(
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 3,
//         childAspectRatio: 1.2,
//         crossAxisSpacing: 24,
//         mainAxisSpacing: 24,
//       ),
//       itemCount: _patients.length,
//       itemBuilder: (context, index) {
//         return _buildPatientCard(_patients[index]);
//       },
//     );
//   }

//   Widget _buildPatientCard(Patient patient) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 CircleAvatar(
//                   radius: 24,
//                   backgroundColor: Colors.grey[300],
//                   child: const Icon(Icons.person, color: Colors.grey, size: 28),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         patient.name,
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.black,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         'ID: ${patient.id}',
//                         style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                       ),
//                     ],
//                   ),
//                 ),
//                 _buildStatusBadge(patient.status),
//               ],
//             ),
//             const SizedBox(height: 24),
//             _buildPatientInfo(Icons.cake_outlined, '${patient.age} years old'),
//             const SizedBox(height: 12),
//             _buildPatientInfo(Icons.phone_outlined, patient.phone),
//             const SizedBox(height: 12),
//             _buildPatientInfo(
//               Icons.calendar_today_outlined,
//               'Last visit: ${patient.lastVisit}',
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStatusBadge(PatientStatus status) {
//     Color backgroundColor;
//     String text;

//     switch (status) {
//       case PatientStatus.highRisk:
//         backgroundColor = const Color(0xFFDC3545);
//         text = 'High Risk';
//         break;
//       case PatientStatus.chronic:
//         backgroundColor = const Color(0xFFFD7E14);
//         text = 'Chronic';
//         break;
//       case PatientStatus.stable:
//         backgroundColor = const Color(0xFF198754);
//         text = 'Stable';
//         break;
//     }

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: backgroundColor,
//         borderRadius: BorderRadius.circular(4),
//       ),
//       child: Text(
//         text,
//         style: const TextStyle(
//           color: Colors.white,
//           fontSize: 10,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     );
//   }

//   Widget _buildPatientInfo(IconData icon, String text) {
//     return Row(
//       children: [
//         Icon(icon, size: 16, color: Colors.grey[600]),
//         const SizedBox(width: 8),
//         Expanded(
//           child: Text(
//             text,
//             style: TextStyle(fontSize: 14, color: Colors.grey[700]),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class Patient {
//   final String id;
//   final String name;
//   final int age;
//   final String phone;
//   final String lastVisit;
//   final PatientStatus status;
//   final String avatar;

//   Patient({
//     required this.id,
//     required this.name,
//     required this.age,
//     required this.phone,
//     required this.lastVisit,
//     required this.status,
//     required this.avatar,
//   });
// }

// enum PatientStatus { highRisk, chronic, stable }
