// import 'package:flutter/material.dart';

// class OPDManagementScreen extends StatefulWidget {
//   const OPDManagementScreen({Key? key}) : super(key: key);

//   @override
//   State<OPDManagementScreen> createState() => _OPDManagementScreenState();
// }

// class _OPDManagementScreenState extends State<OPDManagementScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   int _selectedNavIndex = 0;
//   int _selectedQueueTab = 0;

//   // Form controllers
//   final _nameController = TextEditingController();
//   final _ageController = TextEditingController();
//   final _contactController = TextEditingController();
//   final _complaintController = TextEditingController();
//   final _insuranceController = TextEditingController();

//   String _selectedGender = 'Male';
//   String _selectedLanguage = 'English';
//   String _selectedDepartment = 'General Medicine';
//   String _selectedDoctor = 'Dr. Smith';
//   bool _isEmergency = false;

//   final List<String> _navItems = [
//     'Patient Registration',
//     'Queue Dashboard',
//     'Appointments',
//     'Analytics',
//   ];

//   final List<String> _queueTabs = ['General', 'Pediatrics', 'ENT'];

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: _queueTabs.length, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     _nameController.dispose();
//     _ageController.dispose();
//     _contactController.dispose();
//     _complaintController.dispose();
//     _insuranceController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: Colors.blue[600],
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: const Icon(
//                 Icons.local_hospital,
//                 color: Colors.white,
//                 size: 20,
//               ),
//             ),
//             const SizedBox(width: 12),
//             const Text(
//               'OPD Management System',
//               style: TextStyle(
//                 color: Colors.black87,
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           Container(
//             margin: const EdgeInsets.only(right: 16),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 12,
//                     vertical: 6,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.green[100],
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Row(
//                     children: [
//                       Container(
//                         width: 8,
//                         height: 8,
//                         decoration: const BoxDecoration(
//                           color: Colors.green,
//                           shape: BoxShape.circle,
//                         ),
//                       ),
//                       const SizedBox(width: 6),
//                       const Text(
//                         'Live Queue',
//                         style: TextStyle(
//                           color: Colors.green,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 const CircleAvatar(
//                   radius: 16,
//                   backgroundImage: AssetImage('assets/profile_avatar.png'),
//                 ),
//               ],
//             ),
//           ),
//         ],
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(60),
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Row(
//               children:
//                   _navItems.asMap().entries.map((entry) {
//                     final index = entry.key;
//                     final item = entry.value;
//                     final isSelected = index == _selectedNavIndex;

//                     return GestureDetector(
//                       onTap: () => setState(() => _selectedNavIndex = index),
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 12,
//                         ),
//                         margin: const EdgeInsets.only(right: 8),
//                         decoration: BoxDecoration(
//                           color:
//                               isSelected
//                                   ? Colors.blue[600]
//                                   : Colors.transparent,
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Row(
//                           children: [
//                             Icon(
//                               _getNavIcon(index),
//                               color:
//                                   isSelected ? Colors.white : Colors.grey[600],
//                               size: 20,
//                             ),
//                             const SizedBox(width: 8),
//                             Text(
//                               item,
//                               style: TextStyle(
//                                 color:
//                                     isSelected
//                                         ? Colors.white
//                                         : Colors.grey[600],
//                                 fontWeight:
//                                     isSelected
//                                         ? FontWeight.w600
//                                         : FontWeight.w400,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   }).toList(),
//             ),
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             // Stats Cards
//             _buildStatsCards(),
//             const SizedBox(height: 24),

//             // Main Content
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Left Column - Patient Registration
//                 Expanded(flex: 2, child: _buildPatientRegistrationCard()),
//                 const SizedBox(width: 16),

//                 // Right Column - Queue
//                 Expanded(flex: 1, child: _buildQueueCard()),
//               ],
//             ),
//             const SizedBox(height: 24),

//             // Book Appointment Section
//             _buildBookAppointmentCard(),
//           ],
//         ),
//       ),
//     );
//   }

//   IconData _getNavIcon(int index) {
//     switch (index) {
//       case 0:
//         return Icons.person_add;
//       case 1:
//         return Icons.dashboard;
//       case 2:
//         return Icons.calendar_today;
//       case 3:
//         return Icons.analytics;
//       default:
//         return Icons.help;
//     }
//   }

//   Widget _buildStatsCards() {
//     return Row(
//       children: [
//         _buildStatCard(
//           'Today\'s Appointments',
//           '24',
//           Icons.calendar_today,
//           Colors.blue,
//         ),
//         const SizedBox(width: 16),
//         _buildStatCard('Walk-ins', '12', Icons.directions_walk, Colors.cyan),
//         const SizedBox(width: 16),
//         _buildStatCard(
//           'Avg Wait Time',
//           '15m',
//           Icons.access_time,
//           Colors.orange,
//         ),
//         const SizedBox(width: 16),
//         _buildStatCard('No-show Rate', '8%', Icons.person_remove, Colors.red),
//       ],
//     );
//   }

//   Widget _buildStatCard(
//     String title,
//     String value,
//     IconData icon,
//     Color color,
//   ) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.1),
//               spreadRadius: 1,
//               blurRadius: 8,
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: color.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Icon(icon, color: color, size: 20),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: TextStyle(
//                       color: Colors.grey[600],
//                       fontSize: 12,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     value,
//                     style: const TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPatientRegistrationCard() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 8,
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   'Patient Registration',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//                 ),
//                 TextButton.icon(
//                   onPressed: () {},
//                   icon: const Icon(Icons.qr_code_scanner),
//                   label: const Text('Scan Card'),
//                   style: TextButton.styleFrom(
//                     foregroundColor: Colors.blue[600],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),

//             // Search Bar
//             TextField(
//               decoration: InputDecoration(
//                 hintText: 'Search existing patient by name or MRN...',
//                 prefixIcon: const Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                   borderSide: BorderSide(color: Colors.grey[300]!),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                   borderSide: BorderSide(color: Colors.grey[300]!),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                   borderSide: BorderSide(color: Colors.blue[600]!),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),

//             // Form Fields
//             Row(
//               children: [
//                 Expanded(child: _buildTextField('Full Name', _nameController)),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: _buildTextField(
//                     'MRN',
//                     TextEditingController()..text = 'Auto-generated',
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),

//             Row(
//               children: [
//                 Expanded(child: _buildTextField('Age', _ageController)),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: _buildDropdown('Gender', _selectedGender, [
//                     'Male',
//                     'Female',
//                     'Other',
//                   ]),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: _buildDropdown('Language', _selectedLanguage, [
//                     'English',
//                     'Spanish',
//                     'French',
//                   ]),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),

//             Row(
//               children: [
//                 Expanded(
//                   child: _buildTextField('Contact Number', _contactController),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: _buildTextField('Insurance', _insuranceController),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),

//             _buildTextField(
//               'Chief Complaint',
//               _complaintController,
//               maxLines: 3,
//             ),
//             const SizedBox(height: 16),

//             Row(
//               children: [
//                 Expanded(
//                   child: _buildDropdown('Department', _selectedDepartment, [
//                     'General Medicine',
//                     'Pediatrics',
//                     'ENT',
//                   ]),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: _buildDropdown('Consulting Doctor', _selectedDoctor, [
//                     'Dr. Smith',
//                     'Dr. Johnson',
//                     'Dr. Williams',
//                   ]),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),

//             CheckboxListTile(
//               value: _isEmergency,
//               onChanged:
//                   (value) => setState(() => _isEmergency = value ?? false),
//               title: const Text('Emergency Priority'),
//               controlAffinity: ListTileControlAffinity.leading,
//               contentPadding: EdgeInsets.zero,
//             ),
//             const SizedBox(height: 24),

//             // Action Buttons
//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () {},
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue[600],
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: const Text('Register Patient'),
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 OutlinedButton(
//                   onPressed: () {},
//                   style: OutlinedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(
//                       vertical: 16,
//                       horizontal: 24,
//                     ),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: const Text('Clear'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildQueueCard() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 8,
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Today\'s Queue',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//             ),
//             const SizedBox(height: 16),

//             // Queue Tabs
//             TabBar(
//               controller: _tabController,
//               tabs: _queueTabs.map((tab) => Tab(text: tab)).toList(),
//               labelColor: Colors.blue[600],
//               unselectedLabelColor: Colors.grey[600],
//               indicatorColor: Colors.blue[600],
//               indicatorSize: TabBarIndicatorSize.tab,
//             ),
//             const SizedBox(height: 16),

//             // Queue Items
//             _buildQueueItem(
//               'Q001',
//               'John Doe',
//               '12345',
//               'In Consultation',
//               '09:30 AM - Appointment',
//               'Dr. Smith',
//               Colors.green,
//             ),
//             _buildQueueItem(
//               'Q002',
//               'Jane Smith',
//               '12346',
//               'Waiting',
//               '10:00 AM - Walk-in',
//               'Dr. Johnson',
//               Colors.orange,
//             ),
//             _buildQueueItem(
//               'Q003',
//               'Mike Johnson',
//               '12347',
//               'Emergency',
//               '10:15 AM - Walk-in',
//               'Dr. Williams',
//               Colors.red,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildQueueItem(
//     String queueId,
//     String name,
//     String mrn,
//     String status,
//     String time,
//     String doctor,
//     Color statusColor,
//   ) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.grey[50],
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Colors.grey[200]!),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: statusColor.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//                 child: Text(
//                   queueId,
//                   style: TextStyle(
//                     color: statusColor,
//                     fontWeight: FontWeight.w600,
//                     fontSize: 12,
//                   ),
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: statusColor.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//                 child: Text(
//                   status,
//                   style: TextStyle(
//                     color: statusColor,
//                     fontWeight: FontWeight.w500,
//                     fontSize: 12,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Text(
//             name,
//             style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
//           ),
//           Text(
//             'MRN: $mrn',
//             style: TextStyle(color: Colors.grey[600], fontSize: 12),
//           ),
//           const SizedBox(height: 4),
//           Text(time, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
//           Text(doctor, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
//           if (status == 'Waiting') ...[
//             const SizedBox(height: 8),
//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () {},
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue[600],
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(vertical: 8),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(6),
//                       ),
//                     ),
//                     child: const Text('Start', style: TextStyle(fontSize: 12)),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 OutlinedButton(
//                   onPressed: () {},
//                   style: OutlinedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(
//                       vertical: 8,
//                       horizontal: 16,
//                     ),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(6),
//                     ),
//                   ),
//                   child: const Text('Skip', style: TextStyle(fontSize: 12)),
//                 ),
//               ],
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _buildBookAppointmentCard() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 8,
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Book Appointment',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//             ),
//             const SizedBox(height: 16),

//             Row(
//               children: [
//                 Expanded(
//                   child: _buildDropdown('Doctor', _selectedDoctor, [
//                     'Dr. Smith',
//                     'Dr. Johnson',
//                     'Dr. Williams',
//                   ]),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(child: _buildDateField('Date')),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: _buildDropdown('Time Slot', '09:00 AM', [
//                     '09:00 AM',
//                     '10:00 AM',
//                     '11:00 AM',
//                   ]),
//                 ),
//                 const SizedBox(width: 16),
//                 SizedBox(
//                   width: 160,
//                   child: ElevatedButton(
//                     onPressed: () {},
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue[600],
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: const Text('Book Appointment'),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),

//             Row(
//               children: [
//                 Checkbox(value: false, onChanged: (value) {}),
//                 const Text('Send SMS notification'),
//                 const SizedBox(width: 24),
//                 Checkbox(value: false, onChanged: (value) {}),
//                 const Text('Recurring appointment'),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField(
//     String label,
//     TextEditingController controller, {
//     int maxLines = 1,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
//         ),
//         const SizedBox(height: 8),
//         TextField(
//           controller: controller,
//           maxLines: maxLines,
//           decoration: InputDecoration(
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(color: Colors.grey[300]!),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(color: Colors.grey[300]!),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(color: Colors.blue[600]!),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildDropdown(String label, String value, List<String> items) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
//         ),
//         const SizedBox(height: 8),
//         DropdownButtonFormField<String>(
//           value: value,
//           decoration: InputDecoration(
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(color: Colors.grey[300]!),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(color: Colors.grey[300]!),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(color: Colors.blue[600]!),
//             ),
//           ),
//           items:
//               items.map((item) {
//                 return DropdownMenuItem(value: item, child: Text(item));
//               }).toList(),
//           onChanged: (newValue) {
//             setState(() {
//               if (label == 'Gender') _selectedGender = newValue!;
//               if (label == 'Language') _selectedLanguage = newValue!;
//               if (label == 'Department') _selectedDepartment = newValue!;
//               if (label == 'Consulting Doctor') _selectedDoctor = newValue!;
//             });
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildDateField(String label) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
//         ),
//         const SizedBox(height: 8),
//         TextField(
//           decoration: InputDecoration(
//             hintText: 'mm/dd/yyyy',
//             suffixIcon: const Icon(Icons.calendar_today),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(color: Colors.grey[300]!),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(color: Colors.grey[300]!),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(color: Colors.blue[600]!),
//             ),
//           ),
//           readOnly: true,
//           onTap: () async {
//             final date = await showDatePicker(
//               context: context,
//               initialDate: DateTime.now(),
//               firstDate: DateTime.now(),
//               lastDate: DateTime.now().add(const Duration(days: 365)),
//             );
//             // Handle date selection
//           },
//         ),
//       ],
//     );
//   }

// }

//   // Queue Dashboard Components
//   Widget _buildQueueStatsCards() {
//     return Row(
//       children: [
//         _buildStatCard(
//           'Total in Queue',
//           '18',
//           Icons.people,
//           Colors.blue,
//         ),
//         const SizedBox(width: 16),
//         _buildStatCard(
//           'Currently Serving',
//           '3',
//           Icons.medical_services,
//           Colors.green,
//         ),
//         const SizedBox(width: 16),
//         _buildStatCard(
//           'Average Wait',
//           '12m',
//           Icons.timer,
//           Colors.orange,
//         ),
//         const SizedBox(width: 16),
//         _buildStatCard(
//           'Completed Today',
//           '45',
//           Icons.check_circle,
//           Colors.purple,
//         ),
//       ],
//     );
//   }

//   Widget _buildQueueManagementCard() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 8,
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   'Queue Management',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 Row(
//                   children: [
//                     IconButton(
//                       onPressed: () {},
//                       icon: const Icon(Icons.refresh),
//                       tooltip: 'Refresh Queue',
//                     ),
//                     IconButton(
//                       onPressed: () {},
//                       icon: const Icon(Icons.settings),
//                       tooltip: 'Queue Settings',
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),

//             // Department Filter
//             Row(
//               children: [
//                 const Text('Department: '),
//                 const SizedBox(width: 8),
//                 DropdownButton<String>(
//                   value: 'All',
//                   items: ['All', 'General', 'Pediatrics', 'ENT', 'Cardiology']
//                       .map((dept) => DropdownMenuItem(value: dept, child: Text(dept)))
//                       .toList(),
//                   onChanged: (value) {},
//                 ),
//                 const Spacer(),
//                 const Text('Status: '),
//                 const SizedBox(width: 8),
//                 DropdownButton<String>(
//                   value: 'All',
//                   items: ['All', 'Waiting', 'In Progress', 'Completed']
//                       .map((status) => DropdownMenuItem(value: status, child: Text(status)))
//                       .toList(),
//                   onChanged: (value) {},
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),

//             // Queue List
//             Container(
//               height: 400,
//               child: ListView.builder(
//                 itemCount: 8,
//                 itemBuilder: (context, index) {
//                   return _buildQueueManagementItem(index);
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildQueueManagementItem(int index) {
//     final patients = [
//       {'name': 'John Doe', 'mrn': '12345', 'dept': 'General', 'time': '09:30 AM', 'status': 'In Progress', 'doctor': 'Dr. Smith'},
//       {'name': 'Jane Smith', 'mrn': '12346', 'dept': 'Pediatrics', 'time': '10:00 AM', 'status': 'Waiting', 'doctor': 'Dr. Johnson'},
//       {'name': 'Mike Johnson', 'mrn': '12347', 'dept': 'ENT', 'time': '10:15 AM', 'status': 'Emergency', 'doctor': 'Dr. Williams'},
//       {'name': 'Sarah Wilson', 'mrn': '12348', 'dept': 'General', 'time': '10:30 AM', 'status': 'Waiting', 'doctor': 'Dr. Smith'},
//       {'name': 'David Brown', 'mrn': '12349', 'dept': 'Cardiology', 'time': '11:00 AM', 'status': 'Waiting', 'doctor': 'Dr. Davis'},
//       {'name': 'Lisa Anderson', 'mrn': '12350', 'dept': 'Pediatrics', 'time': '11:15 AM', 'status': 'Waiting', 'doctor': 'Dr. Johnson'},
//       {'name': 'Tom Wilson', 'mrn': '12351', 'dept': 'ENT', 'time': '11:30 AM', 'status': 'Waiting', 'doctor': 'Dr. Williams'},
//       {'name': 'Mary Davis', 'mrn': '12352', 'dept': 'General', 'time': '12:00 PM', 'status': 'Waiting', 'doctor': 'Dr. Smith'},
//     ];

//     final patient = patients[index];
//     Color statusColor = _getStatusColor(patient['status']!);

//     return Container(
//       margin: const EdgeInsets.only(bottom: 8),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.grey[50],
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Colors.grey[200]!),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 40,
//             height: 40,
//             decoration: BoxDecoration(
//               color: statusColor.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Center(
//               child: Text(
//                 'Q${(index + 1).toString().padLeft(2, '0')}',
//                 style: TextStyle(
//                   color: statusColor,
//                   fontWeight: FontWeight.w600,
//                   fontSize: 12,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Text(
//                       patient['name']!,
//                       style: const TextStyle(
//                         fontWeight: FontWeight.w600,
//                         fontSize: 14,
//                       ),
//                     ),
//                     const Spacer(),
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                       decoration: BoxDecoration(
//                         color: statusColor.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                       child: Text(
//                         patient['status']!,
//                         style: TextStyle(
//                           color: statusColor,
//                           fontWeight: FontWeight.w500,
//                           fontSize: 12,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 4),
//                 Row(
//                   children: [
//                     Text(
//                       'MRN: ${patient['mrn']}',
//                       style: TextStyle(
//                         color: Colors.grey[600],
//                         fontSize: 12,
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     Text(
//                       patient['dept']!,
//                       style: TextStyle(
//                         color: Colors.grey[600],
//                         fontSize: 12,
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     Text(
//                       patient['time']!,
//                       style: TextStyle(
//                         color: Colors.grey[600],
//                         fontSize: 12,
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     Text(
//                       patient['doctor']!,
//                       style: TextStyle(
//                         color: Colors.grey[600],
//                         fontSize: 12,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(width: 12),
//           Row(
//             children: [
//               if (patient['status'] == 'Waiting') ...[
//                 IconButton(
//                   onPressed: () {},
//                   icon: const Icon(Icons.play_arrow, color: Colors.green),
//                   tooltip: 'Start Consultation',
//                 ),
//                 IconButton(
//                   onPressed: () {},
//                   icon: const Icon(Icons.skip_next, color: Colors.orange),
//                   tooltip: 'Skip Patient',
//                 ),
//               ],
//               if (patient['status'] == 'In Progress') ...[
//                 IconButton(
//                   onPressed: () {},
//                   icon: const Icon(Icons.check, color: Colors.green),
//                   tooltip: 'Complete',
//                 ),
//                 IconButton(
//                   onPressed: () {},
//                   icon: const Icon(Icons.pause, color: Colors.orange),
//                   tooltip: 'Pause',
//                 ),
//               ],
//               IconButton(
//                 onPressed: () {},
//                 icon: const Icon(Icons.more_vert, color: Colors.grey),
//                 tooltip: 'More Options',
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildQuickActionsCard() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 8,
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Quick Actions',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(height: 16),

//             _buildQuickActionButton(
//               'Call Next Patient',
//               Icons.campaign,
//               Colors.blue,
//               () {},
//             ),
//             const SizedBox(height: 12),
//             _buildQuickActionButton(
//               'Emergency Override',
//               Icons.warning,
//               Colors.red,
//               () {},
//             ),
//             const SizedBox(height: 12),
//             _buildQuickActionButton(
//               'Pause Queue',
//               Icons.pause_circle,
//               Colors.orange,
//               () {},
//             ),
//             const SizedBox(height: 12),
//             _buildQuickActionButton(
//               'Add Walk-in',
//               Icons.person_add,
//               Colors.green,
//               () {},
//             ),
//             const SizedBox(height: 24),

//             const Text(
//               'Room Status',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(height: 12),

//             _buildRoomStatus('Room 1', 'Occupied', Colors.red),
//             _buildRoomStatus('Room 2', 'Available', Colors.green),
//             _buildRoomStatus('Room 3', 'Cleaning', Colors.orange),
//             _buildRoomStatus('Room 4', 'Available', Colors.green),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildQuickActionButton(String title, IconData icon, Color color, VoidCallback onPressed) {
//     return SizedBox(
//       width: double.infinity,
//       child: ElevatedButton.icon(
//         onPressed: onPressed,
//         icon: Icon(icon, size: 20),
//         label: Text(title),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: color,
//           foregroundColor: Colors.white,
//           padding: const EdgeInsets.symmetric(vertical: 12),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildRoomStatus(String room, String status, Color color) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 8),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.grey[50],
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Colors.grey[200]!),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 8,
//             height: 8,
//             decoration: BoxDecoration(
//               color: color,
//               shape: BoxShape.circle,
//             ),
//           ),
//           const SizedBox(width: 12),
//           Text(
//             room,
//             style: const TextStyle(
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           const Spacer(),
//           Text(
//             status,
//             style: TextStyle(
//               color: color,
//               fontWeight: FontWeight.w500,
//               fontSize: 12,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildQueueAnalyticsCard() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 8,
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Queue Analytics',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(height: 16),

//             Container(
//               height: 200,
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: Colors.grey[50],
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: const Center(
//                         child: Text(
//                           'Wait Time Trends Chart\n(Placeholder)',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(color: Colors.grey),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: Colors.grey[50],
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: const Center(
//                         child: Text(
//                           'Department Load Chart\n(Placeholder)',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(color: Colors.grey),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Appointments Components
//   Widget _buildAppointmentStatsCards() {
//     return Row(
//       children: [
//         _buildStatCard(
//           'Today\'s Appointments',
//           '24',
//           Icons.calendar_today,
//           Colors.blue,
//         ),
//         const SizedBox(width: 16),
//         _buildStatCard(
//           'Confirmed',
//           '18',
//           Icons.check_circle,
//           Colors.green,
//         ),
//         const SizedBox(width: 16),
//         _buildStatCard(
//           'Pending',
//           '4',
//           Icons.pending,
//           Colors.orange,
//         ),
//         const SizedBox(width: 16),
//         _buildStatCard(
//           'Cancelled',
//           '2',
//           Icons.cancel,
//           Colors.red,
//         ),
//       ],
//     );
//   }

//   Widget _buildAppointmentsListCard() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 8,
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   'Appointments',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 Row(
//                   children: [
//                     DropdownButton<String>(
//                       value: 'Today',
//                       items: ['Today', 'Tomorrow', 'This Week', 'This Month']
//                           .map((period) => DropdownMenuItem(value: period, child: Text(period)))
//                           .toList(),
//                       onChanged: (value) {},
//                     ),
//                     const SizedBox(width: 8),
//                     ElevatedButton.icon(
//                       onPressed: () {},
//                       icon: const Icon(Icons.add, size: 20),
//                       label: const Text('New Appointment'),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue[600],
//                         foregroundColor: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),

//             Container(
//               height: 400,
//               child: ListView.builder(
//                 itemCount: 6,
//                 itemBuilder: (context, index) {
//                   return _buildAppointmentItem(index);
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

// class OPDManagementScreen extends StatefulWidget {
//   const OPDManagementScreen({Key? key}) : super(key: key);

//   @override
//   State<OPDManagementScreen> createState() => _OPDManagementScreenState();
// }

// class _OPDManagementScreenState extends State<OPDManagementScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   int _selectedNavIndex = 0;
//   int _selectedQueueTab = 0;

//   // Form controllers
//   final _nameController = TextEditingController();
//   final _ageController = TextEditingController();
//   final _contactController = TextEditingController();
//   final _complaintController = TextEditingController();
//   final _insuranceController = TextEditingController();

//   String _selectedGender = 'Male';
//   String _selectedLanguage = 'English';
//   String _selectedDepartment = 'General Medicine';
//   String _selectedDoctor = 'Dr. Smith';
//   bool _isEmergency = false;

//   final List<String> _navItems = [
//     'Patient Registration',
//     'Queue Dashboard',
//     'Appointments',
//     'Analytics'
//   ];

//   final List<String> _queueTabs = ['General', 'Pediatrics', 'ENT'];

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: _queueTabs.length, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     _nameController.dispose();
//     _ageController.dispose();
//     _contactController.dispose();
//     _complaintController.dispose();
//     _insuranceController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: Colors.blue[600],
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: const Icon(
//                 Icons.local_hospital,
//                 color: Colors.white,
//                 size: 20,
//               ),
//             ),
//             const SizedBox(width: 12),
//             const Text(
//               'OPD Management System',
//               style: TextStyle(
//                 color: Colors.black87,
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           Container(
//             margin: const EdgeInsets.only(right: 16),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                   decoration: BoxDecoration(
//                     color: Colors.green[100],
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Row(
//                     children: [
//                       Container(
//                         width: 8,
//                         height: 8,
//                         decoration: const BoxDecoration(
//                           color: Colors.green,
//                           shape: BoxShape.circle,
//                         ),
//                       ),
//                       const SizedBox(width: 6),
//                       const Text(
//                         'Live Queue',
//                         style: TextStyle(
//                           color: Colors.green,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 const CircleAvatar(
//                   radius: 16,
//                   backgroundImage: AssetImage('assets/profile_avatar.png'),
//                 ),
//               ],
//             ),
//           ),
//         ],
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(60),
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Row(
//               children: _navItems.asMap().entries.map((entry) {
//                 final index = entry.key;
//                 final item = entry.value;
//                 final isSelected = index == _selectedNavIndex;

//                 return GestureDetector(
//                   onTap: () => setState(() => _selectedNavIndex = index),
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                     margin: const EdgeInsets.only(right: 8),
//                     decoration: BoxDecoration(
//                       color: isSelected ? Colors.blue[600] : Colors.transparent,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Row(
//                       children: [
//                         Icon(
//                           _getNavIcon(index),
//                           color: isSelected ? Colors.white : Colors.grey[600],
//                           size: 20,
//                         ),
//                         const SizedBox(width: 8),
//                         Text(
//                           item,
//                           style: TextStyle(
//                             color: isSelected ? Colors.white : Colors.grey[600],
//                             fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               }).toList(),
//             ),
//           ),
//         ),
//       ),
//       body: _buildCurrentView(),
//     );
//   }

//   Widget _buildCurrentView() {
//     switch (_selectedNavIndex) {
//       case 0:
//         return _buildPatientRegistrationView();
//       case 1:
//         return _buildQueueDashboardView();
//       case 2:
//         return _buildAppointmentsView();
//       case 3:
//         return _buildAnalyticsView();
//       default:
//         return _buildPatientRegistrationView();
//     }
//   }

//   Widget _buildPatientRegistrationView() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           // Stats Cards
//           _buildStatsCards(),
//           const SizedBox(height: 24),

//           // Main Content
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Left Column - Patient Registration
//               Expanded(
//                 flex: 2,
//                 child: _buildPatientRegistrationCard(),
//               ),
//               const SizedBox(width: 16),

//               // Right Column - Queue
//               Expanded(
//                 flex: 1,
//                 child: _buildQueueCard(),
//               ),
//             ],
//           ),
//           const SizedBox(height: 24),

//           // Book Appointment Section
//           _buildBookAppointmentCard(),
//         ],
//       ),
//     );
//   }

//   Widget _buildQueueDashboardView() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           // Queue Stats
//           _buildQueueStatsCards(),
//           const SizedBox(height: 24),

//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Left Column - Queue Management
//               Expanded(
//                 flex: 2,
//                 child: _buildQueueManagementCard(),
//               ),
//               const SizedBox(width: 16),

//               // Right Column - Quick Actions
//               Expanded(
//                 flex: 1,
//                 child: _buildQuickActionsCard(),
//               ),
//             ],
//           ),
//           const SizedBox(height: 24),

//           // Queue Analytics
//           _buildQueueAnalyticsCard(),
//         ],
//       ),
//     );
//   }

//   Widget _buildAppointmentsView() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           // Appointment Stats
//           _buildAppointmentStatsCards(),
//           const SizedBox(height: 24),

//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Left Column - Appointments List
//               Expanded(
//                 flex: 2,
//                 child: _buildAppointmentsListCard(),
//               ),
//               const SizedBox(width: 16),

//               // Right Column - Calendar
//               Expanded(
//                 flex: 1,
//                 child: _buildCalendarCard(),
//               ),
//             ],
//           ),
//           const SizedBox(height: 24),

//           // Appointment Actions
//           _buildAppointmentActionsCard(),
//         ],
//       ),
//     );
//   }

//   Widget _buildAnalyticsView() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           // Analytics Stats
//           _buildAnalyticsStatsCards(),
//           const SizedBox(height: 24),

//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Left Column - Charts
//               Expanded(
//                 flex: 2,
//                 child: _buildChartsCard(),
//               ),
//               const SizedBox(width: 16),

//               // Right Column - Reports
//               Expanded(
//                 flex: 1,
//                 child: _buildReportsCard(),
//               ),
//             ],
//           ),
//           const SizedBox(height: 24),

//           // Performance Metrics
//           _buildPerformanceMetricsCard(),
//         ],
//       ),
//     );
//   }

//   IconData _getNavIcon(int index) {
//     switch (index) {
//       case 0: return Icons.person_add;
//       case 1: return Icons.dashboard;
//       case 2: return Icons.calendar_today;
//       case 3: return Icons.analytics;
//       default: return Icons.help;
//     }
//   }

//   Widget _buildStatsCards() {
//     return Row(
//       children: [
//         _buildStatCard(
//           'Today\'s Appointments',
//           '24',
//           Icons.calendar_today,
//           Colors.blue,
//         ),
//         const SizedBox(width: 16),
//         _buildStatCard(
//           'Walk-ins',
//           '12',
//           Icons.directions_walk,
//           Colors.cyan,
//         ),
//         const SizedBox(width: 16),
//         _buildStatCard(
//           'Avg Wait Time',
//           '15m',
//           Icons.access_time,
//           Colors.orange,
//         ),
//         const SizedBox(width: 16),
//         _buildStatCard(
//           'No-show Rate',
//           '8%',
//           Icons.person_remove,
//           Colors.red,
//         ),
//       ],
//     );
//   }

//   Widget _buildStatCard(String title, String value, IconData icon, Color color) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.1),
//               spreadRadius: 1,
//               blurRadius: 8,
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: color.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Icon(icon, color: color, size: 20),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: TextStyle(
//                       color: Colors.grey[600],
//                       fontSize: 12,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     value,
//                     style: const TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPatientRegistrationCard() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 8,
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   'Patient Registration',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 TextButton.icon(
//                   onPressed: () {},
//                   icon: const Icon(Icons.qr_code_scanner),
//                   label: const Text('Scan Card'),
//                   style: TextButton.styleFrom(
//                     foregroundColor: Colors.blue[600],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),

//             // Search Bar
//             TextField(
//               decoration: InputDecoration(
//                 hintText: 'Search existing patient by name or MRN...',
//                 prefixIcon: const Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                   borderSide: BorderSide(color: Colors.grey[300]!),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                   borderSide: BorderSide(color: Colors.grey[300]!),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                   borderSide: BorderSide(color: Colors.blue[600]!),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),

//             // Form Fields
//             Row(
//               children: [
//                 Expanded(
//                   child: _buildTextField('Full Name', _nameController),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: _buildTextField('MRN', TextEditingController()..text = 'Auto-generated'),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),

//             Row(
//               children: [
//                 Expanded(
//                   child: _buildTextField('Age', _ageController),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: _buildDropdown('Gender', _selectedGender, ['Male', 'Female', 'Other']),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: _buildDropdown('Language', _selectedLanguage, ['English', 'Spanish', 'French']),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),

//             Row(
//               children: [
//                 Expanded(
//                   child: _buildTextField('Contact Number', _contactController),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: _buildTextField('Insurance', _insuranceController),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),

//             _buildTextField('Chief Complaint', _complaintController, maxLines: 3),
//             const SizedBox(height: 16),

//             Row(
//               children: [
//                 Expanded(
//                   child: _buildDropdown('Department', _selectedDepartment, ['General Medicine', 'Pediatrics', 'ENT']),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: _buildDropdown('Consulting Doctor', _selectedDoctor, ['Dr. Smith', 'Dr. Johnson', 'Dr. Williams']),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),

//             CheckboxListTile(
//               value: _isEmergency,
//               onChanged: (value) => setState(() => _isEmergency = value ?? false),
//               title: const Text('Emergency Priority'),
//               controlAffinity: ListTileControlAffinity.leading,
//               contentPadding: EdgeInsets.zero,
//             ),
//             const SizedBox(height: 24),

//             // Action Buttons
//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () {},
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue[600],
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: const Text('Register Patient'),
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 OutlinedButton(
//                   onPressed: () {},
//                   style: OutlinedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: const Text('Clear'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildQueueCard() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 8,
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Today\'s Queue',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(height: 16),

//             // Queue Tabs
//             TabBar(
//               controller: _tabController,
//               tabs: _queueTabs.map((tab) => Tab(text: tab)).toList(),
//               labelColor: Colors.blue[600],
//               unselectedLabelColor: Colors.grey[600],
//               indicatorColor: Colors.blue[600],
//               indicatorSize: TabBarIndicatorSize.tab,
//             ),
//             const SizedBox(height: 16),

//             // Queue Items
//             _buildQueueItem('Q001', 'John Doe', '12345', 'In Consultation', '09:30 AM - Appointment', 'Dr. Smith', Colors.green),
//             _buildQueueItem('Q002', 'Jane Smith', '12346', 'Waiting', '10:00 AM - Walk-in', 'Dr. Johnson', Colors.orange),
//             _buildQueueItem('Q003', 'Mike Johnson', '12347', 'Emergency', '10:15 AM - Walk-in', 'Dr. Williams', Colors.red),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildQueueItem(String queueId, String name, String mrn, String status, String time, String doctor, Color statusColor) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.grey[50],
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Colors.grey[200]!),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: statusColor.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//                 child: Text(
//                   queueId,
//                   style: TextStyle(
//                     color: statusColor,
//                     fontWeight: FontWeight.w600,
//                     fontSize: 12,
//                   ),
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: statusColor.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//                 child: Text(
//                   status,
//                   style: TextStyle(
//                     color: statusColor,
//                     fontWeight: FontWeight.w500,
//                     fontSize: 12,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Text(
//             name,
//             style: const TextStyle(
//               fontWeight: FontWeight.w600,
//               fontSize: 14,
//             ),
//           ),
//           Text(
//             'MRN: $mrn',
//             style: TextStyle(
//               color: Colors.grey[600],
//               fontSize: 12,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             time,
//             style: TextStyle(
//               color: Colors.grey[600],
//               fontSize: 12,
//             ),
//           ),
//           Text(
//             doctor,
//             style: TextStyle(
//               color: Colors.grey[600],
//               fontSize: 12,
//             ),
//           ),
//           if (status == 'Waiting') ...[
//             const SizedBox(height: 8),
//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () {},
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue[600],
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(vertical: 8),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(6),
//                       ),
//                     ),
//                     child: const Text('Start', style: TextStyle(fontSize: 12)),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 OutlinedButton(
//                   onPressed: () {},
//                   style: OutlinedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(6),
//                     ),
//                   ),
//                   child: const Text('Skip', style: TextStyle(fontSize: 12)),
//                 ),
//               ],
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _buildBookAppointmentCard() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 8,
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Book Appointment',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(height: 16),

//             Row(
//               children: [
//                 Expanded(
//                   child: _buildDropdown('Doctor', _selectedDoctor, ['Dr. Smith', 'Dr. Johnson', 'Dr. Williams']),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: _buildDateField('Date'),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: _buildDropdown('Time Slot', '09:00 AM', ['09:00 AM', '10:00 AM', '11:00 AM']),
//                 ),
//                 const SizedBox(width: 16),
//                 SizedBox(
//                   width: 160,
//                   child: ElevatedButton(
//                     onPressed: () {},
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue[600],
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: const Text('Book Appointment'),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),

//             Row(
//               children: [
//                 Checkbox(
//                   value: false,
//                   onChanged: (value) {},
//                 ),
//                 const Text('Send SMS notification'),
//                 const SizedBox(width: 24),
//                 Checkbox(
//                   value: false,
//                   onChanged: (value) {},
//                 ),
//                 const Text('Recurring appointment'),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             fontWeight: FontWeight.w500,
//             fontSize: 14,
//           ),
//         ),
//         const SizedBox(height: 8),
//         TextField(
//           controller: controller,
//           maxLines: maxLines,
//           decoration: InputDecoration(
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(color: Colors.grey[300]!),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(color: Colors.grey[300]!),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(color: Colors.blue[600]!),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildDropdown(String label, String value, List<String> items) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             fontWeight: FontWeight.w500,
//             fontSize: 14,
//           ),
//         ),
//         const SizedBox(height: 8),
//         DropdownButtonFormField<String>(
//           value: value,
//           decoration: InputDecoration(
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(color: Colors.grey[300]!),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(color: Colors.grey[300]!),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(color: Colors.blue[600]!),
//             ),
//           ),
//           items: items.map((item) {
//             return DropdownMenuItem(
//               value: item,
//               child: Text(item),
//             );
//           }).toList(),
//           onChanged: (newValue) {
//             setState(() {
//               if (label == 'Gender') _selectedGender = newValue!;
//               if (label == 'Language') _selectedLanguage = newValue!;
//               if (label == 'Department') _selectedDepartment = newValue!;
//               if (label == 'Consulting Doctor') _selectedDoctor = newValue!;
//             });
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildDateField(String label) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             fontWeight: FontWeight.w500,
//             fontSize: 14,
//           ),
//         ),
//         const SizedBox(height: 8),
//         TextField(
//           decoration: InputDecoration(
//             hintText: 'mm/dd/yyyy',
//             suffixIcon: const Icon(Icons.calendar_today),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(color: Colors.grey[300]!),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(color: Colors.grey[300]!),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(color: Colors.blue[600]!),
//             ),
//           ),
//           readOnly: true,
//           onTap: () async {
//             final date = await showDatePicker(
//               context: context,
//               initialDate: DateTime.now(),
//               firstDate: DateTime.now(),
//               lastDate: DateTime.now().add(const Duration(days: 365)),
//             );
//             // Handle date selection
//           },
//         ),
//       ],
//     );
//   }
// }

// }

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:schmgtsystem/providers/patient_proviider.dart';
import 'package:schmgtsystem/widgets/success_snack.dart';

import 'models/patient_model.dart';

class OPDManagementScreen extends StatefulWidget {
  @override
  _OPDManagementScreenState createState() => _OPDManagementScreenState();
}

class _OPDManagementScreenState extends State<OPDManagementScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    PatientRegistrationScreen(),
    QueueDashboard(),
    AppointmentsScreen(),
    AnalyticsScreen(),
  ];
  //   Widget _buildQueueManagementItem(int index) {
  //     final patients = [
  //       {'name': 'John Doe', 'mrn': '12345', 'dept': 'General', 'time': '09:30 AM', 'status': 'In Progress', 'doctor': 'Dr. Smith'},
  //       {'name': 'Jane Smith', 'mrn': '12346', 'dept': 'Pediatrics', 'time': '10:00 AM', 'status': 'Waiting', 'doctor': 'Dr. Johnson'},
  //       {'name': 'Mike Johnson', 'mrn': '12347', 'dept': 'ENT', 'time': '10:15 AM', 'status': 'Emergency', 'doctor': 'Dr. Williams'},
  //       {'name': 'Sarah Wilson', 'mrn': '12348', 'dept': 'General', 'time': '10:30 AM', 'status': 'Waiting', 'doctor': 'Dr. Smith'},
  //       {'name': 'David Brown', 'mrn': '12349', 'dept': 'Cardiology', 'time': '11:00 AM', 'status': 'Waiting', 'doctor': 'Dr. Davis'},
  //       {'name': 'Lisa Anderson', 'mrn': '12350', 'dept': 'Pediatrics', 'time': '11:15 AM', 'status': 'Waiting', 'doctor': 'Dr. Johnson'},
  //       {'name': 'Tom Wilson', 'mrn': '12351', 'dept': 'ENT', 'time': '11:30 AM', 'status': 'Waiting', 'doctor': 'Dr. Williams'},
  //       {'name': 'Mary Davis', 'mrn': '12352', 'dept': 'General', 'time': '12:00 PM', 'status': 'Waiting', 'doctor': 'Dr. Smith'},
  //     ];
  final List<String> _titles = [
    'Patient Registration',
    'Queue Dashboard',
    'Appointments',
    'Analytics',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Row(
          children: [
            Icon(Icons.local_hospital, color: Colors.blue[600], size: 28),
            SizedBox(width: 8),
            Text(
              'OPD Management System',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.circle, color: Colors.white, size: 8),
                      SizedBox(width: 4),
                      Text(
                        'Live Queue',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  child: Icon(Icons.person, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Container(
            color: Colors.white,
            child: Row(
              children: [
                _buildTopNavItem(0, Icons.person_add, 'Patient Registration'),
                _buildTopNavItem(1, Icons.dashboard, 'Queue Dashboard'),
                _buildTopNavItem(2, Icons.calendar_today, 'Appointments'),
                // _buildTopNavItem(3, Icons.analytics, 'Analytics'),
              ],
            ),
          ),
        ),
      ),
      body: _screens[_selectedIndex],
    );
  }

  Widget _buildTopNavItem(int index, IconData icon, String title) {
    bool isSelected = _selectedIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedIndex = index),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? Colors.blue[600]! : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.blue[600] : Colors.grey[600],
                size: 20,
              ),
              SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.blue[600] : Colors.grey[600],
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Patient Registration Screen
class PatientRegistrationScreen extends StatefulWidget {
  @override
  _PatientRegistrationScreenState createState() =>
      _PatientRegistrationScreenState();
}

class _PatientRegistrationScreenState extends State<PatientRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  // Basic Information
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  DateTime? _dateOfBirth;

  // Address Information
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _countryController = TextEditingController();

  // Emergency Contact
  final _emergencyNameController = TextEditingController();
  final _emergencyRelationshipController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();
  final _emergencyEmailController = TextEditingController();

  // Insurance Information
  final _insuranceProviderController = TextEditingController();
  final _insurancePolicyNumberController = TextEditingController();
  final _insuranceGroupNumberController = TextEditingController();

  // Other fields
  final _complaintController = TextEditingController();
  String _selectedGender = 'male';
  String _selectedLanguage = 'English';
  String _selectedDepartment = 'General Medicine';
  String _selectedDoctor = 'Dr. Smith';
  bool _isEmergency = false;
  String _mrn = '';

  // Department to doctors mapping
  final Map<String, List<String>> _departmentDoctors = {
    'General Medicine': ['Dr. Smith', 'Dr. Johnson', 'Dr. Brown'],
    'Pediatrics': ['Dr. Williams', 'Dr. Davis', 'Dr. Miller'],
    'ENT': ['Dr. Wilson', 'Dr. Moore', 'Dr. Taylor'],
  };
  void _generateMRN() {
    final now = DateTime.now();
    final random = Random().nextInt(9000) + 1000; // 4-digit random number
    setState(() {
      _mrn =
          'MRN${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}$random';

      print(_mrn);
    });
  }

  /// Build patient data for API request
  /// All API calls go through state management (PatientProvider)
  Map<String, dynamic> _buildPatientData() {
    // Format dateOfBirth to ISO 8601 format
    final dateOfBirth =
        _dateOfBirth != null ? _dateOfBirth!.toUtc().toIso8601String() : null;

    if (dateOfBirth == null) {
      throw Exception('Date of birth is required');
    }

    // Build request body matching backend API structure
    return {
      "firstName": _firstNameController.text.trim(),
      "lastName": _lastNameController.text.trim(),
      "dateOfBirth": dateOfBirth,
      "gender": _selectedGender.toLowerCase(),
      "phone": _phoneController.text.trim(),
      "email": _emailController.text.trim(),
      "address": {
        "street": _streetController.text.trim(),
        "city": _cityController.text.trim(),
        "state": _stateController.text.trim(),
        "zipCode": _zipCodeController.text.trim(),
        "country": _countryController.text.trim(),
      },
      "emergencyContact": {
        "name": _emergencyNameController.text.trim(),
        "relationship": _emergencyRelationshipController.text.trim(),
        "phone": _emergencyPhoneController.text.trim(),
        "email": _emergencyEmailController.text.trim(),
      },
      "insurance": {
        "provider": _insuranceProviderController.text.trim(),
        "policyNumber": _insurancePolicyNumberController.text.trim(),
        "groupNumber": _insuranceGroupNumberController.text.trim(),
      },
    };
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    setState(() {
      // Clear all text controllers
      _firstNameController.clear();
      _lastNameController.clear();
      _phoneController.clear();
      _emailController.clear();
      _streetController.clear();
      _cityController.clear();
      _stateController.clear();
      _zipCodeController.clear();
      _countryController.clear();
      _emergencyNameController.clear();
      _emergencyRelationshipController.clear();
      _emergencyPhoneController.clear();
      _emergencyEmailController.clear();
      _insuranceProviderController.clear();
      _insurancePolicyNumberController.clear();
      _insuranceGroupNumberController.clear();
      _complaintController.clear();

      // Reset other fields
      _dateOfBirth = null;
      _selectedGender = 'male';
      _selectedLanguage = 'English';
      _selectedDepartment = 'General Medicine';
      _selectedDoctor = 'Dr. Smith';
      _isEmergency = false;
      _mrn = '';
    });
  }

  Widget _buildDatePickerField(String label, DateTime? selectedDate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate:
                  selectedDate ??
                  DateTime.now().subtract(Duration(days: 365 * 30)),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
              helpText: 'Select Date of Birth',
            );
            if (picked != null && picked != selectedDate) {
              setState(() {
                _dateOfBirth = picked;
              });
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedDate == null
                      ? 'Select date'
                      : DateFormat('yyyy-MM-dd').format(selectedDate),
                  style: TextStyle(
                    fontSize: 16,
                    color:
                        selectedDate == null
                            ? Colors.grey[600]
                            : Colors.black87,
                  ),
                ),
                Icon(Icons.calendar_today, color: Colors.grey[600], size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left side - Registration Form
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  _buildStatsCards(),
                  SizedBox(height: 24),
                  _buildRegistrationForm(),
                  SizedBox(height: 24),
                  _buildAppointmentBooking(),
                ],
              ),
            ),
            SizedBox(width: 16),
            // Right side - Today's Queue
            Expanded(flex: 1, child: _buildTodaysQueue()),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCards() {
    return Row(
      children: [
        _buildStatCard(
          "Today's Appointments",
          "24",
          Icons.calendar_today,
          Colors.blue,
        ),
        SizedBox(width: 16),
        _buildStatCard("Walk-ins", "12", Icons.directions_walk, Colors.cyan),
        SizedBox(width: 16),
        _buildStatCard(
          "Avg Wait Time",
          "15m",
          Icons.access_time,
          Colors.orange,
        ),
        SizedBox(width: 16),
        _buildStatCard("No-show Rate", "8%", Icons.person_off, Colors.red),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(10),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(icon, color: color, size: 20),
              ],
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegistrationForm() {
    return Container(
      padding: EdgeInsets.all(24),
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
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Patient Registration',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.qr_code_scanner, size: 16),
                  label: Text('Scan Card'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[100],
                    foregroundColor: Colors.black87,
                    elevation: 0,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            // Basic Information Section
            Text(
              'Basic Information',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField('First Name', _firstNameController),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildTextField('Last Name', _lastNameController),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildDatePickerField('Date of Birth', _dateOfBirth),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildDropdown(
                    'Gender',
                    _selectedGender,
                    ['male', 'female', 'other'],
                    (value) {
                      setState(() => _selectedGender = value!);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    'Phone',
                    _phoneController,
                    hintText: '+1234567890',
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    'Email',
                    _emailController,
                    hintText: 'patient@example.com',
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            // Address Information Section
            Text(
              'Address Information',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
            _buildTextField(
              'Street',
              _streetController,
              hintText: '123 Main Street',
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildTextField('City', _cityController)),
                SizedBox(width: 16),
                Expanded(child: _buildTextField('State', _stateController)),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField('Zip Code', _zipCodeController),
                ),
                SizedBox(width: 16),
                Expanded(child: _buildTextField('Country', _countryController)),
              ],
            ),
            SizedBox(height: 24),
            // Emergency Contact Section
            Text(
              'Emergency Contact',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField('Name', _emergencyNameController),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    'Relationship',
                    _emergencyRelationshipController,
                    hintText: 'Spouse, Parent, etc.',
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    'Phone',
                    _emergencyPhoneController,
                    hintText: '+1234567890',
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    'Email',
                    _emergencyEmailController,
                    hintText: 'contact@example.com',
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            // Insurance Information Section
            Text(
              'Insurance Information',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
            _buildTextField(
              'Provider',
              _insuranceProviderController,
              hintText: 'Blue Cross Blue Shield',
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    'Policy Number',
                    _insurancePolicyNumberController,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    'Group Number',
                    _insuranceGroupNumberController,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            // Additional Information
            Text(
              'Additional Information',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
            _buildTextField(
              'Chief Complaint',
              _complaintController,
              maxLines: 3,
              hintText: 'Reason for visit...',
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildDropdown(
                    'Department',
                    _selectedDepartment,
                    ['General Medicine', 'Pediatrics', 'ENT', 'N/A'],
                    (value) {
                      setState(() => _selectedDepartment = value!);
                    },
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildDropdown(
                    'Consulting Doctor',
                    _selectedDoctor,
                    ['N/A', 'Dr. Smith', 'Dr. Johnson', 'Dr. Williams'],
                    (value) {
                      setState(() => _selectedDoctor = value!);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            CheckboxListTile(
              title: Text('Emergency Priority'),
              value: _isEmergency,
              onChanged: (value) => setState(() => _isEmergency = value!),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Consumer<PatientProvider>(
                    builder: (context, provider, child) {
                      return ElevatedButton(
                        onPressed:
                            provider.isLoading
                                ? null
                                : () async {
                                  if (_formKey.currentState!.validate()) {
                                    if (_dateOfBirth == null) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Please select date of birth',
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      return;
                                    }

                                    // All API calls go through state management
                                    final patientProvider =
                                        Provider.of<PatientProvider>(
                                          context,
                                          listen: false,
                                        );

                                    try {
                                      // Build patient data
                                      final patientData = _buildPatientData();

                                      // Register patient via provider (state management)
                                      final response = await patientProvider
                                          .registerPatient(patientData);

                                      // Handle response from state management
                                      if (response.success) {
                                        _generateMRN();

                                        // Create local patient object for UI
                                        final fullName =
                                            '${_firstNameController.text} ${_lastNameController.text}';
                                        final newPatient = Patient(
                                          waitTime: Duration.zero,
                                          id:
                                              DateTime.now()
                                                  .millisecondsSinceEpoch
                                                  .toString(),
                                          name: fullName,
                                          mrn: _mrn,
                                          age:
                                              DateTime.now()
                                                  .difference(_dateOfBirth!)
                                                  .inDays ~/
                                              365,
                                          gender: _selectedGender,
                                          contact: _phoneController.text,
                                          department: _selectedDepartment,
                                          doctor: _selectedDoctor,
                                          isEmergency: _isEmergency,
                                          registrationTime: DateTime.now(),
                                          complaint: _complaintController.text,
                                        );

                                        patientProvider.addPatient(newPatient);

                                        showSnackbar(
                                          context,
                                          '${_firstNameController.text} ${_lastNameController.text} registered successfully!',
                                        );

                                        _addPatientToQueue(
                                          fullName,
                                          _mrn,
                                          _selectedDepartment,
                                          _selectedDoctor,
                                        );

                                        // Clear form after successful registration
                                        _clearForm();
                                      } else {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              response.error ??
                                                  'Failed to register patient',
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text('Error: $e'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                },
                        child:
                            provider.isLoading
                                ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                                : Text('Register Patient'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[600],
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(width: 16),
                OutlinedButton(
                  onPressed: () {
                    _clearForm();
                  },
                  child: Text('Clear'),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentBooking() {
    return Container(
      padding: EdgeInsets.all(24),
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
          Text(
            'Book Appointment',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildDropdown('Doctor', 'Dr. Smith', [
                  'Dr. Smith',
                  'Dr. Johnson',
                  'Dr. Williams',
                ], (value) {}),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  'Date',
                  TextEditingController()..text = 'mm/dd/yyyy',
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildDropdown('Time Slot', '09:00 AM', [
                  '09:00 AM',
                  '10:00 AM',
                  '11:00 AM',
                ], (value) {}),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text('Book Appointment'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Checkbox(value: false, onChanged: (value) {}),
              Text('Send SMS notification'),
              SizedBox(width: 24),
              Checkbox(value: false, onChanged: (value) {}),
              Text('Recurring appointment'),
            ],
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> patientQueue = [
    {
      'queueId': 'Q001',
      'name': 'John Doe',
      'mrn': '12345',
      'status': 'In Consultation',
      'time': '09:30 AM - Appointment',
      'doctor': 'Dr. Smith',
      'color': Colors.green,
    },
    {
      'queueId': 'Q002',
      'name': 'Jane Smith',
      'mrn': '12346',
      'status': 'Waiting',
      'time': '10:00 AM - Walk-in',
      'doctor': 'Dr. Johnson',
      'color': Colors.orange,
    },
    {
      'queueId': 'Q003',
      'name': 'Mike Johnson',
      'mrn': '12347',
      'status': 'Emergency',
      'time': '10:15 AM - Walk-in',
      'doctor': 'Dr. Williams',
      'color': Colors.red,
    },
  ];

  // Add this method to handle adding new patients to queue
  void _addPatientToQueue(
    String name,
    String mrn,
    String department,
    String doctor,
  ) {
    setState(() {
      patientQueue.add({
        'queueId': 'Q${(patientQueue.length + 1).toString().padLeft(3, '0')}',
        'name': name,
        'mrn': mrn,
        'status': 'Waiting',
        'time': '${TimeOfDay.now().format(context)} - Walk-in',
        'doctor': doctor,
        'color': Colors.orange,
        'department': department,
      });
    });
  }

  // Updated queue builder with drag and drop
  Widget _buildTodaysQueue() {
    return Container(
      padding: EdgeInsets.all(24),
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
          Text(
            "Today's Queue",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              _buildQueueTab('General', true),
              _buildQueueTab('Pediatrics', false),
              _buildQueueTab('ENT', false),
            ],
          ),
          SizedBox(height: 16),
          ReorderableListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: patientQueue.length,
            itemBuilder: (context, index) {
              final patient = patientQueue[index];
              return _buildQueueItem(
                key: Key(patient['queueId']),
                queueId: patient['queueId'],
                name: patient['name'],
                mrn: patient['mrn'],
                status: patient['status'],
                time: patient['time'],
                doctor: patient['doctor'],
                statusColor: patient['color'],
              );
            },
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final item = patientQueue.removeAt(oldIndex);
                patientQueue.insert(newIndex, item);
                // Update queue IDs to reflect new order
                for (int i = 0; i < patientQueue.length; i++) {
                  patientQueue[i]['queueId'] =
                      'Q${(i + 1).toString().padLeft(3, '0')}';
                }
              });
            },
          ),
        ],
      ),
    );
  }

  // Updated queue item with drag handle
  Widget _buildQueueItem({
    required Key key,
    required String queueId,
    required String name,
    required String mrn,
    required String status,
    required String time,
    required String doctor,
    required Color statusColor,
  }) {
    return Container(
      key: key,
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
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
              Row(
                children: [
                  Icon(Icons.drag_handle, color: Colors.grey),
                  SizedBox(width: 8),
                  Text(
                    queueId,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Text(
            'MRN: $mrn',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          SizedBox(height: 4),
          Text(time, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          Text(doctor, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          if (status == 'Waiting') ...[
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        patientQueue.firstWhere(
                              (p) => p['queueId'] == queueId,
                            )['status'] =
                            'In Consultation';
                      });
                    },
                    child: Text('Start'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 8),
                      textStyle: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        patientQueue.removeWhere(
                          (p) => p['queueId'] == queueId,
                        );
                        // Update remaining queue IDs
                        for (int i = 0; i < patientQueue.length; i++) {
                          patientQueue[i]['queueId'] =
                              'Q${(i + 1).toString().padLeft(3, '0')}';
                        }
                      });
                    },
                    child: Text('Remove'),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      textStyle: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

Widget _buildQueueTab(String title, bool isActive) {
  return Expanded(
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? Colors.blue[50] : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: isActive ? Colors.blue[600] : Colors.grey[600],
          fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          fontSize: 12,
        ),
      ),
    ),
  );
}

Widget _buildQueueItem(
  String queueId,
  String name,
  String mrn,
  String status,
  String time,
  String doctor,
  Color statusColor,
) {
  return Container(
    margin: EdgeInsets.only(bottom: 12),
    padding: EdgeInsets.all(16),
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
              queueId,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          name,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        Text(
          'MRN: $mrn',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        SizedBox(height: 4),
        Text(time, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        Text(doctor, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        if (status == 'Waiting') ...[
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text('Start'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 8),
                    textStyle: TextStyle(fontSize: 12),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  child: Text('Skip'),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    textStyle: TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    ),
  );
}

Widget _buildTextField(
  String label,
  TextEditingController controller, {
  int maxLines = 1,
  String? hintText,
  bool readOnly = false,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      SizedBox(height: 8),
      TextFormField(
        controller: controller,
        maxLines: maxLines,
        readOnly: readOnly,
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.blue[600]!),
          ),
          filled: true,
          fillColor: readOnly ? Colors.grey[100] : Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field is required';
          }
          return null;
        },
      ),
    ],
  );
}

Widget _buildDropdown(
  String label,
  String value,
  List<String> items,
  ValueChanged<String?> onChanged,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      SizedBox(height: 8),
      DropdownButtonFormField<String>(
        value: value,
        items:
            items.map((item) {
              return DropdownMenuItem(value: item, child: Text(item));
            }).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.blue[600]!),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),
    ],
  );
}

// Appointments Screen
class AppointmentsScreen extends StatefulWidget {
  @override
  _AppointmentsScreenState createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  DateTime selectedDate = DateTime.now();
  String selectedView = 'Day';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Appointments',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Row(
                children: [
                  _buildViewToggle(),
                  SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.add),
                    label: Text('New Appointment'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 1, child: _buildCalendar()),
                SizedBox(width: 16),
                Expanded(flex: 2, child: _buildAppointmentsList()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewToggle() {
    List<String> views = ['Day', 'Week', 'Month'];

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children:
            views.map((view) {
              bool isSelected = selectedView == view;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedView = view;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue[600] : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    view,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      padding: EdgeInsets.all(20),
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
          Text(
            'Calendar',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          // Simple calendar placeholder
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1,
            ),
            itemCount: 35,
            itemBuilder: (context, index) {
              int day = index - 6;
              bool isToday = day == DateTime.now().day;
              bool isSelected = day == selectedDate.day;

              return GestureDetector(
                onTap: () {
                  if (day > 0 && day <= 31) {
                    setState(() {
                      selectedDate = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        day,
                      );
                    });
                  }
                },
                child: Container(
                  margin: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? Colors.blue[600]
                            : (isToday ? Colors.blue[100] : Colors.transparent),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      day > 0 && day <= 31 ? day.toString() : '',
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight:
                            isSelected || isToday
                                ? FontWeight.w600
                                : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 20),
          _buildQuickStats(),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Column(
      children: [
        _buildQuickStatItem('Today\'s Appointments', '12', Colors.blue),
        _buildQuickStatItem('This Week', '68', Colors.green),
        _buildQuickStatItem('This Month', '284', Colors.orange),
        _buildQuickStatItem('Cancelled', '8', Colors.red),
      ],
    );
  }

  Widget _buildQuickStatItem(String label, String value, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentsList() {
    return Container(
      padding: EdgeInsets.all(20),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Appointments - ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.filter_list),
                    tooltip: 'Filter',
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.search),
                    tooltip: 'Search',
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: 6,
              itemBuilder: (context, index) {
                return _buildAppointmentCard(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(int index) {
    List<Map<String, dynamic>> appointments = [
      {
        'time': '09:00 AM',
        'patient': 'John Doe',
        'mrn': '12345',
        'doctor': 'Dr. Smith',
        'department': 'General Medicine',
        'status': 'Confirmed',
        'color': Colors.green,
        'type': 'Follow-up',
      },
      {
        'time': '09:30 AM',
        'patient': 'Jane Smith',
        'mrn': '12346',
        'doctor': 'Dr. Johnson',
        'department': 'Pediatrics',
        'status': 'Confirmed',
        'color': Colors.green,
        'type': 'New Patient',
      },
      {
        'time': '10:00 AM',
        'patient': 'Mike Johnson',
        'mrn': '12347',
        'doctor': 'Dr. Williams',
        'department': 'ENT',
        'status': 'Cancelled',
        'color': Colors.red,
        'type': 'Consultation',
      },
      {
        'time': '10:30 AM',
        'patient': 'Sarah Wilson',
        'mrn': '12348',
        'doctor': 'Dr. Smith',
        'department': 'General Medicine',
        'status': 'Pending',
        'color': Colors.orange,
        'type': 'Check-up',
      },
      {
        'time': '11:00 AM',
        'patient': 'Robert Brown',
        'mrn': '12349',
        'doctor': 'Dr. Johnson',
        'department': 'Pediatrics',
        'status': 'Confirmed',
        'color': Colors.green,
        'type': 'Vaccination',
      },
      {
        'time': '11:30 AM',
        'patient': 'Emily Davis',
        'mrn': '12350',
        'doctor': 'Dr. Williams',
        'department': 'ENT',
        'status': 'Rescheduled',
        'color': Colors.blue,
        'type': 'Surgery Follow-up',
      },
    ];

    var appointment = appointments[index];

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 70,
            decoration: BoxDecoration(
              color: appointment['color'],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      appointment['time'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: appointment['color'],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        appointment['status'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  appointment['patient'],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'MRN: ${appointment['mrn']}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.person, size: 14, color: Colors.grey[600]),
                    SizedBox(width: 4),
                    Text(
                      appointment['doctor'],
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    SizedBox(width: 16),
                    Icon(
                      Icons.local_hospital,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    SizedBox(width: 4),
                    Text(
                      appointment['department'],
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    appointment['type'],
                    style: TextStyle(fontSize: 10, color: Colors.grey[700]),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.edit, size: 20),
                tooltip: 'Edit',
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.more_vert, size: 20),
                tooltip: 'More',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Analytics Screen
class AnalyticsScreen extends StatefulWidget {
  @override
  _AnalyticsScreenState createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String selectedPeriod = 'This Month';
  String selectedDepartment = 'General Medicine';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Analytics',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              DropdownButton<String>(
                value: selectedPeriod,
                items:
                    ['Today', 'This Week', 'This Month', 'This Year'].map((
                      period,
                    ) {
                      return DropdownMenuItem(
                        value: period,
                        child: Text(period),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedPeriod = value!;
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildMetricsCards(),
                  SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildPatientFlowChart()),
                      SizedBox(width: 16),
                      Expanded(child: _buildDepartmentStats()),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildDoctorPerformance()),
                      SizedBox(width: 16),
                      Expanded(
                        child: Text('_buildWaitTimeAnalysis'),
                        // child: _buildWaitTimeAnalysis(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsCards() {
    return Row(
      children: [
        _buildMetricCard(
          'Total Patients',
          '1,234',
          '+12%',
          Icons.people,
          Colors.blue,
        ),
        SizedBox(width: 16),
        _buildMetricCard(
          'Appointments',
          '856',
          '+8%',
          Icons.calendar_today,
          Colors.green,
        ),
        SizedBox(width: 16),
        _buildMetricCard(
          'Walk-ins',
          '378',
          '+15%',
          Icons.directions_walk,
          Colors.orange,
        ),
        SizedBox(width: 16),
        _buildMetricCard(
          'Revenue',
          '\$45,670',
          '+22%',
          Icons.attach_money,
          Colors.purple,
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    String change,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(20),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(icon, color: color, size: 24),
              ],
            ),
            SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 4),
            Text(
              change,
              style: TextStyle(
                fontSize: 12,
                color: Colors.green[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientFlowChart() {
    return Container(
      padding: EdgeInsets.all(20),
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
          Text(
            'Patient Flow',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          Container(
            height: 200,
            child: Center(
              child: Text(
                'Chart Placeholder\n(Patient flow over time)',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDepartmentStats() {
    return Container(
      padding: EdgeInsets.all(20),
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
          Text(
            'Department Performance',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          _buildDepartmentItem('General Medicine', 45, Colors.blue),
          _buildDepartmentItem('Pediatrics', 30, Colors.green),
          _buildDepartmentItem('ENT', 15, Colors.orange),
          _buildDepartmentItem('Cardiology', 25, Colors.red),
          _buildDepartmentItem('Orthopedics', 20, Colors.purple),
        ],
      ),
    );
  }

  Widget _buildDepartmentItem(String department, int percentage, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                department,
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              Text(
                '$percentage%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorPerformance() {
    return Container(
      padding: EdgeInsets.all(20),
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
          Text(
            'Doctor Performance',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          _buildDoctorItem('Dr. Smith', 42, '4.8', Colors.green),
          _buildDoctorItem('Dr. Johnson', 38, '4.7', Colors.blue),
          _buildDoctorItem('Dr. Williams', 35, '4.6', Colors.orange),
          _buildDoctorItem('Dr. Brown', 29, '4.5', Colors.purple),
        ],
      ),
    );
  }

  Widget _buildDoctorItem(
    String doctor,
    int patients,
    String rating,
    Color color,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 2, child: _buildQueueList()),
          SizedBox(width: 16),
          Expanded(
            flex: 1,
            child: Text('soething missing'),
            // child: _buildQueueStats(),
          ),
        ],
      ),
    );
  }

  Widget _buildQueueList() {
    return Container(
      padding: EdgeInsets.all(20),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Current Queue - $selectedDepartment',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.refresh),
                    tooltip: 'Refresh Queue',
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.settings),
                    tooltip: 'Queue Settings',
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: 8,
              itemBuilder: (context, index) {
                return _buildQueueCard(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQueueCard(int index) {
    List<Map<String, dynamic>> queueData = [
      {
        'name': 'John Doe',
        'mrn': '12345',
        'status': 'In Consultation',
        'time': '09:30 AM',
        'doctor': 'Dr. Smith',
        'color': Colors.green,
        'priority': 'Normal',
      },
      {
        'name': 'Jane Smith',
        'mrn': '12346',
        'status': 'Waiting',
        'time': '10:00 AM',
        'doctor': 'Dr. Johnson',
        'color': Colors.orange,
        'priority': 'Normal',
      },
      {
        'name': 'Mike Johnson',
        'mrn': '12347',
        'status': 'Emergency',
        'time': '10:15 AM',
        'doctor': 'Dr. Williams',
        'color': Colors.red,
        'priority': 'High',
      },
      {
        'name': 'Sarah Wilson',
        'mrn': '12348',
        'status': 'Checked In',
        'time': '10:30 AM',
        'doctor': 'Dr. Smith',
        'color': Colors.blue,
        'priority': 'Normal',
      },
      {
        'name': 'Robert Brown',
        'mrn': '12349',
        'status': 'Waiting',
        'time': '10:45 AM',
        'doctor': 'Dr. Johnson',
        'color': Colors.orange,
        'priority': 'Normal',
      },
      {
        'name': 'Emily Davis',
        'mrn': '12350',
        'status': 'No Show',
        'time': '11:00 AM',
        'doctor': 'Dr. Williams',
        'color': Colors.grey,
        'priority': 'Normal',
      },
      {
        'name': 'David Miller',
        'mrn': '12351',
        'status': 'Completed',
        'time': '11:15 AM',
        'doctor': 'Dr. Smith',
        'color': Colors.green[800]!,
        'priority': 'Normal',
      },
      {
        'name': 'Lisa Anderson',
        'mrn': '12352',
        'status': 'Waiting',
        'time': '11:30 AM',
        'doctor': 'Dr. Johnson',
        'color': Colors.orange,
        'priority': 'Normal',
      },
    ];

    var patient = queueData[index];

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 60,
            decoration: BoxDecoration(
              color: patient['color'],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(width: 16),
        ],
      ),
    );
    //         Expanded(
    //           chil
  }
}

class QueueDashboard extends StatefulWidget {
  @override
  _QueueDashboardState createState() => _QueueDashboardState();
}

class _QueueDashboardState extends State<QueueDashboard> {
  String _selectedDepartment = 'General Medicine';
  final Map<String, List<String>> _departmentDoctors = {
    'General Medicine': ['Dr. Smith', 'Dr. Johnson', 'Dr. Brown'],
    'Pediatrics': ['Dr. Williams', 'Dr. Davis', 'Dr. Miller'],
    'ENT': ['Dr. Wilson', 'Dr. Moore', 'Dr. Taylor'],
    'Cardiology': ['Dr. Anderson', 'Dr. Roberts', 'Dr. Clark'],
    'Orthopedics': ['Dr. White', 'Dr. Harris', 'Dr. Martin'],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Patient Queue Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => _refreshData(context),
          ),
        ],
      ),
      body: Consumer<PatientProvider>(
        builder: (context, provider, child) {
          final patients = provider.getPatientsByDepartment(
            _selectedDepartment,
          );

          return Column(
            children: [
              // Department Filter
              _buildDepartmentFilter(),

              // Queue Statistics
              _buildQueueStats(patients),

              // Patient List
              Expanded(
                child:
                    patients.isEmpty
                        ? Center(child: Text('No patients in queue'))
                        : ReorderableListView.builder(
                          padding: EdgeInsets.all(16),
                          itemCount: patients.length,
                          itemBuilder: (context, index) {
                            return _buildPatientCard(
                              context,
                              patients[index],
                              index + 1,
                              provider,
                            );
                          },
                          onReorder: (oldIndex, newIndex) {
                            provider.reorderPatient(
                              _selectedDepartment,
                              oldIndex,
                              newIndex,
                            );
                          },
                        ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPatientCard(
    BuildContext context,
    Patient patient,
    int queueNumber,
    PatientProvider provider,
  ) {
    return Card(
      color: Colors.white,
      key: ValueKey(patient.id),
      margin: EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showPatientActions(context, patient, provider),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              // Drag Handle
              Icon(Icons.drag_handle, color: Colors.grey),
              SizedBox(width: 12),

              // Queue Number
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: patient.statusColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$queueNumber',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: patient.statusColor,
                    ),
                  ),
                ),
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
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        if (patient.isEmergency)
                          Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: Icon(
                              Icons.warning,
                              color: Colors.red,
                              size: 16,
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      'MRN: ${patient.mrn}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.person, size: 14, color: Colors.grey),
                        SizedBox(width: 4),
                        Text(
                          patient.doctor,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    // Timer Widget
                    _buildWaitingTimer(patient.registrationTime),
                  ],
                ),
              ),

              // Status Badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: patient.statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  patient.status,
                  style: TextStyle(
                    color: patient.statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWaitingTimer(DateTime registrationTime) {
    return StreamBuilder<DateTime>(
      stream: Stream.periodic(Duration(seconds: 1), (_) => DateTime.now()),
      builder: (context, snapshot) {
        final now = snapshot.data ?? DateTime.now();
        final duration = now.difference(registrationTime);

        String formatDuration(Duration d) {
          String twoDigits(int n) => n.toString().padLeft(2, "0");
          String hours = twoDigits(d.inHours);
          String minutes = twoDigits(d.inMinutes.remainder(60));
          String seconds = twoDigits(d.inSeconds.remainder(60));
          return "$hours:$minutes:$seconds";
        }

        return Row(
          children: [
            Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
            SizedBox(width: 4),
            Text(
              'Waiting: ${formatDuration(duration)}',
              style: TextStyle(
                fontSize: 12,
                color: duration.inMinutes > 30 ? Colors.red : Colors.grey[600],
                fontWeight:
                    duration.inMinutes > 30
                        ? FontWeight.bold
                        : FontWeight.normal,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDepartmentFilter() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children:
            _departmentDoctors.keys.map((dept) {
              final isSelected = dept == _selectedDepartment;
              return Padding(
                padding: EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(dept),
                  selected: isSelected,
                  onSelected: (_) => setState(() => _selectedDepartment = dept),
                  selectedColor: Colors.blue,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildQueueStats(List<Patient> patients) {
    final stats = {
      'Total': patients.length,
      'Waiting': patients.where((p) => p.status == 'Waiting').length,
      'In Progress':
          patients.where((p) => p.status == 'In Consultation').length,
      'Emergency': patients.where((p) => p.isEmergency).length,
    };

    return Card(
      color: Colors.white,
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children:
              stats.entries.map((e) => _buildStatItem(e.key, e.value)).toList(),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, int value) {
    return Column(
      children: [
        Text(
          '$value',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  Future<void> _showPatientActions(
    BuildContext context,
    Patient patient,
    PatientProvider provider,
  ) async {
    final action = await showModalBottomSheet<String>(
      context: context,
      builder:
          (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.edit),
                title: Text('Reassign Doctor'),
                onTap: () => Navigator.pop(context, 'reassign'),
              ),
              ListTile(
                leading: Icon(Icons.medical_services),
                title: Text('Change Department'),
                onTap: () => Navigator.pop(context, 'department'),
              ),
              ListTile(
                leading: Icon(Icons.check_circle),
                title: Text('Mark as Completed'),
                onTap: () => Navigator.pop(context, 'complete'),
              ),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text(
                  'Remove from Queue',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () => Navigator.pop(context, 'remove'),
              ),
            ],
          ),
    );

    switch (action) {
      case 'reassign':
        await _reassignDoctor(context, patient, provider);
        break;
      case 'department':
        await _changeDepartment(context, patient, provider);
        break;
      case 'complete':
        provider.updatePatientStatus(patient.id, 'Completed');
        break;
      case 'remove':
        await _confirmRemovePatient(context, patient, provider);
        break;
    }
  }

  Future<void> _reassignDoctor(
    BuildContext context,
    Patient patient,
    PatientProvider provider,
  ) async {
    final newDoctor = await showDialog<String>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Select New Doctor'),
            content: DropdownButtonFormField<String>(
              value: patient.doctor,
              items:
                  _departmentDoctors[patient.department]!
                      .map(
                        (doctor) => DropdownMenuItem(
                          value: doctor,
                          child: Text(doctor),
                        ),
                      )
                      .toList(),
              onChanged: (value) => Navigator.pop(context, value),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
            ],
          ),
    );

    if (newDoctor != null) {
      provider.updateDoctor(patient.id, newDoctor);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Doctor reassigned successfully')));
    }
  }

  Future<void> _changeDepartment(
    BuildContext context,
    Patient patient,
    PatientProvider provider,
  ) async {
    final newDepartment = await showDialog<String>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Select New Department'),
            content: DropdownButtonFormField<String>(
              value: patient.department,
              items:
                  _departmentDoctors.keys
                      .map(
                        (dept) =>
                            DropdownMenuItem(value: dept, child: Text(dept)),
                      )
                      .toList(),
              onChanged: (value) => Navigator.pop(context, value),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
            ],
          ),
    );

    if (newDepartment != null) {
      provider.updateDepartment(patient.id, newDepartment);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Department changed successfully')),
      );
    }
  }

  Future<void> _confirmRemovePatient(
    BuildContext context,
    Patient patient,
    PatientProvider provider,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Confirm Removal'),
            content: Text('Remove ${patient.name} from the queue?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('Remove', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      provider.removeFromQueue(patient.id);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Patient removed from queue')));
    }
  }

  Future<void> _refreshData(BuildContext context) async {
    await Provider.of<PatientProvider>(
      context,
      listen: false,
    ).refreshPatients();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Queue refreshed')));
  }
}
