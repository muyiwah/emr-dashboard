// import 'package:flutter/material.dart';

// class MediCareProScreen extends StatefulWidget {
//   const MediCareProScreen({Key? key}) : super(key: key);

//   @override
//   State<MediCareProScreen> createState() => _MediCareProScreenState();
// }

// class _MediCareProScreenState extends State<MediCareProScreen> {
//   String selectedProvider = 'AIICO Insurance';
//   String selectedPlanType = 'Premium Health Plan';
//   String claimStatus = 'Draft';
//   String selectedPaymentMethod = 'Credit/Debit Card';

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
//               child: const Icon(Icons.medical_services, color: Colors.white, size: 20),
//             ),
//             const SizedBox(width: 12),
//             const Text(
//               'MediCare Pro',
//               style: TextStyle(
//                 color: Colors.black,
//                 fontSize: 20,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {},
//             child: const Text('Dashboard', style: TextStyle(color: Colors.grey)),
//           ),
//           TextButton(
//             onPressed: () {},
//             child: Text(
//               'Billing & Payments',
//               style: TextStyle(color: Colors.blue[600], fontWeight: FontWeight.w500),
//             ),
//           ),
//           TextButton(
//             onPressed: () {},
//             child: const Text('Patients', style: TextStyle(color: Colors.grey)),
//           ),
//           const SizedBox(width: 16),
//           const CircleAvatar(
//             radius: 16,
//             backgroundColor: Colors.brown,
//             child: Icon(Icons.person, color: Colors.white, size: 18),
//           ),
//           const SizedBox(width: 16),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Header Section
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Insurance Claims & Payments',
//                       style: TextStyle(
//                         fontSize: 28,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.black,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       'Manage insurance claims and process online payments',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.grey[600],
//                       ),
//                     ),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     OutlinedButton.icon(
//                       onPressed: () {},
//                       icon: const Icon(Icons.download, size: 18),
//                       label: const Text('Export'),
//                       style: OutlinedButton.styleFrom(
//                         foregroundColor: Colors.grey[700],
//                         side: BorderSide(color: Colors.grey[300]!),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     ElevatedButton.icon(
//                       onPressed: () {},
//                       icon: const Icon(Icons.add, size: 18),
//                       label: const Text('New Claim'),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue[600],
//                         foregroundColor: Colors.white,
//                         elevation: 0,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 32),

//             // Stats Cards
//             Row(
//               children: [
//                 Expanded(
//                   child: _buildStatCard(
//                     '1,247',
//                     'Total Claims',
//                     '+12% from last month',
//                     Colors.blue[100]!,
//                     Colors.blue[600]!,
//                     Icons.description,
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: _buildStatCard(
//                     '1,089',
//                     'Approved Claims',
//                     '87.3% approval rate',
//                     Colors.green[100]!,
//                     Colors.green[600]!,
//                     Icons.check_circle,
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: _buildStatCard(
//                     '₦2.4M',
//                     'Online Payments',
//                     '68% of total revenue',
//                     Colors.cyan[100]!,
//                     Colors.cyan[600]!,
//                     Icons.payment,
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: _buildStatCard(
//                     '2.3 days',
//                     'Avg Payment Time',
//                     '-0.5 days improvement',
//                     Colors.purple[100]!,
//                     Colors.purple[600]!,
//                     Icons.schedule,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 32),

//             // Charts Section
//             Row(
//               children: [
//                 Expanded(
//                   child: _buildChartCard('Claims Approval Rate'),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: _buildChartCard('Payment Methods Distribution'),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 32),

//             // Insurance Claims Processing Section
//             Row(
//               children: [
//                 Expanded(
//                   flex: 2,
//                   child: _buildClaimsProcessingCard(),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: _buildPaymentProcessingCard(),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 32),

//             // Recent Claims Table
//             _buildRecentClaimsTable(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStatCard(String value, String title, String subtitle, Color bgColor, Color iconColor, IconData icon) {
//     return Container(
//       padding: const EdgeInsets.all(20),
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
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Colors.grey[600],
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: bgColor,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Icon(icon, color: iconColor, size: 16),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Text(
//             value,
//             style: const TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.w700,
//               color: Colors.black,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             subtitle,
//             style: TextStyle(
//               fontSize: 12,
//               color: Colors.grey[500],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildChartCard(String title) {
//     return Container(
//       height: 200,
//       padding: const EdgeInsets.all(20),
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
//           Text(
//             title,
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: Colors.black,
//             ),
//           ),
//           const SizedBox(height: 20),
//           Expanded(
//             child: Center(
//               child: Text(
//                 'Chart Placeholder',
//                 style: TextStyle(
//                   color: Colors.grey[400],
//                   fontSize: 14,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildClaimsProcessingCard() {
//     return Container(
//       padding: const EdgeInsets.all(20),
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
//               const Text(
//                 'Insurance Claims Processing',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black,
//                 ),
//               ),
//               ElevatedButton.icon(
//                 onPressed: () {},
//                 icon: const Icon(Icons.add, size: 16),
//                 label: const Text('New Claim'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue[600],
//                   foregroundColor: Colors.white,
//                   elevation: 0,
//                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 24),
          
//           // Patient Insurance Information
//           const Text(
//             'Patient Insurance Information',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: Colors.black,
//             ),
//           ),
//           const SizedBox(height: 16),
          
//           Row(
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Policy Number',
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.grey[600],
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     TextFormField(
//                       initialValue: 'INS-2024-001234',
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                           borderSide: BorderSide(color: Colors.grey[300]!),
//                         ),
//                         contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Insurance Provider',
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.grey[600],
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     DropdownButtonFormField<String>(
//                       value: selectedProvider,
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                           borderSide: BorderSide(color: Colors.grey[300]!),
//                         ),
//                         contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                       ),
//                       items: ['AIICO Insurance', 'Other Provider']
//                           .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//                           .toList(),
//                       onChanged: (value) {
//                         setState(() {
//                           selectedProvider = value!;
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Plan Type',
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.grey[600],
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     DropdownButtonFormField<String>(
//                       value: selectedPlanType,
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                           borderSide: BorderSide(color: Colors.grey[300]!),
//                         ),
//                         contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                       ),
//                       items: ['Premium Health Plan', 'Basic Plan']
//                           .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//                           .toList(),
//                       onChanged: (value) {
//                         setState(() {
//                           selectedPlanType = value!;
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
          
//           Row(
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Expiry Date',
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.grey[600],
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     TextFormField(
//                       initialValue: '12/31/2024',
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                           borderSide: BorderSide(color: Colors.grey[300]!),
//                         ),
//                         contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                         suffixIcon: const Icon(Icons.calendar_today, size: 16),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Authorization Code',
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.grey[600],
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     TextFormField(
//                       initialValue: 'AUTH-789012',
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                           borderSide: BorderSide(color: Colors.grey[300]!),
//                         ),
//                         contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(width: 16),
//               const Expanded(child: SizedBox()),
//             ],
//           ),
//           const SizedBox(height: 24),
          
//           // Claim Details
//           const Text(
//             'Claim Details',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: Colors.black,
//             ),
//           ),
//           const SizedBox(height: 16),
          
//           Row(
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Services Rendered',
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.grey[600],
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     TextFormField(
//                       initialValue: 'General Consultation, Blood Test, X-Ray',
//                       maxLines: 3,
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                           borderSide: BorderSide(color: Colors.grey[300]!),
//                         ),
//                         contentPadding: const EdgeInsets.all(12),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'ICD-10/Procedure Codes',
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.grey[600],
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     TextFormField(
//                       initialValue: 'Z00.00, 85025, 71020',
//                       maxLines: 3,
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                           borderSide: BorderSide(color: Colors.grey[300]!),
//                         ),
//                         contentPadding: const EdgeInsets.all(12),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
          
//           Row(
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Claim Status',
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.grey[600],
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     DropdownButtonFormField<String>(
//                       value: claimStatus,
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                           borderSide: BorderSide(color: Colors.grey[300]!),
//                         ),
//                         contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                       ),
//                       items: ['Draft', 'Submitted', 'Approved', 'Rejected']
//                           .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//                           .toList(),
//                       onChanged: (value) {
//                         setState(() {
//                           claimStatus = value!;
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Claim Total',
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.grey[600],
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     TextFormField(
//                       initialValue: '₦45,000',
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                           borderSide: BorderSide(color: Colors.grey[300]!),
//                         ),
//                         contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(width: 16),
//               const Expanded(child: SizedBox()),
//             ],
//           ),
//           const SizedBox(height: 16),
          
//           // Supporting Documents
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Supporting Documents',
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: Colors.grey[600],
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Container(
//                 height: 80,
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey[300]!, style: BorderStyle.solid),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.cloud_upload, color: Colors.grey[400], size: 24),
//                       const SizedBox(height: 4),
//                       Text(
//                         'Drop files here or click to upload',
//                         style: TextStyle(color: Colors.grey[500], fontSize: 12),
//                       ),
//                       Text(
//                         'PDF, JPG, PNG up to 10MB',
//                         style: TextStyle(color: Colors.grey[400], fontSize: 10),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPaymentProcessingCard() {
//     return Container(
//       padding: const EdgeInsets.all(20),
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
//           const Text(
//             'Online Payment Processing',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//               color: Colors.black,
//             ),
//           ),
//           const SizedBox(height: 24),
          
//           // Payment Interface Preview
//           const Text(
//             'Payment Interface Preview',
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//               color: Colors.black,
//             ),
//           ),
//           const SizedBox(height: 16),
          
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.grey[50],
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(color: Colors.grey[200]!),
//             ),
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: Colors.blue[600],
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: const Icon(Icons.security, color: Colors.white, size: 16),
//                     ),
//                     const SizedBox(width: 12),
//                     const Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Secure Payment',
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           Text(
//                             'Invoice #INV-2024-001',
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: Colors.grey,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       'Amount Due:',
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.grey,
//                       ),
//                     ),
//                     const Text(
//                       '₦45,000',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 16),
          
//           // Payment Methods
//           Column(
//             children: [
//               _buildPaymentOption(
//                 'Credit/Debit Card',
//                 Icons.credit_card,
//                 'VISA MASTERCARD',
//                 selectedPaymentMethod == 'Credit/Debit Card',
//                 () => setState(() => selectedPaymentMethod = 'Credit/Debit Card'),
//               ),
//               const SizedBox(height: 8),
//               _buildPaymentOption(
//                 'Bank Transfer',
//                 Icons.account_balance,
//                 'NIBSS',
//                 selectedPaymentMethod == 'Bank Transfer',
//                 () => setState(() => selectedPaymentMethod = 'Bank Transfer'),
//               ),
//               const SizedBox(height: 8),
//               _buildPaymentOption(
//                 'Mobile Money',
//                 Icons.phone_android,
//                 'Wallet',
//                 selectedPaymentMethod == 'Mobile Money',
//                 () => setState(() => selectedPaymentMethod = 'Mobile Money'),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
          
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               onPressed: () {},
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue[600],
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(vertical: 12),
//                 elevation: 0,
//               ),
//               child: const Text('Pay Securely'),
//             ),
//           ),
//           const SizedBox(height: 24),
          
//           // Payment Status Monitor
//           const Text(
//             'Payment Status Monitor',
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//               color: Colors.black,
//             ),
//           ),
//           const SizedBox(height: 16),
          
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.green[50],
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(color: Colors.green[200]!),
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(6),
//                   decoration: BoxDecoration(
//                     color: Colors.green[600],
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: const Icon(Icons.check, color: Colors.white, size: 16),
//                 ),
//                 const SizedBox(width: 12),
//                 const Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Payment Successful',
//                         style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.green,
//                         ),
//                       ),
//                       Text(
//                         'REF: PAY-2024-001234',
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.green,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Text(
//                   '₦45,000',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.green[700],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPaymentOption(String title, IconData icon, String subtitle, bool isSelected, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: isSelected ? Colors.blue[50] : Colors.white,
//           border: Border.all(
//             color: isSelected ? Colors.blue[600]! : Colors.grey[300]!,
//             width: isSelected ? 2 : 1,
//           ),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: isSelected ? Colors.blue[600] : Colors.grey[100],
//                 borderRadius: BorderRadius.circular(6),
//               ),
//               child: Icon(
//                 icon,
//                 color: isSelected ? Colors.white : Colors.grey[600],
//                 size: 16,
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 title,
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                   color: isSelected ? Colors.blue[600] : Colors.black,
//                 ),
//               ),
//             ),
//             Text(
//               subtitle,
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Colors.grey[500],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildRecentClaimsTable() {
//     return Container(
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
//           Padding(
//             padding: const EdgeInsets.all(20),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   'Recent Claims',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.black,
//                   ),
//                 ),
//                 Row(
//                   children: [
//                     DropdownButton<String>(
//                       value: 'All Providers',
//                       underline: const SizedBox(),
//                       items: ['All Providers', 'AIICO Insurance', 'Other']
//                           .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//                           .toList(),
//                       onChanged: (value) {},
//                     ),
//                     const SizedBox(width: 16),
//                     DropdownButton<String>(
//                       value: 'All Status',
//                       underline: const SizedBox(),
//                       items: ['All Status', 'Approved', 'Pending', 'Draft']
//                           .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//                           .toList(),
//                       onChanged: (value) {},
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           // Table Header
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//             decoration: BoxDecoration(
//               color: Colors.grey[50],
//               border: Border(
//                 top: BorderSide(color: Colors.grey[200]!),
//                 bottom: BorderSide(color: Colors.grey[200]!),
//               ),
//             ),
//             child: const Row(
//               children: [
//                 Expanded(
//                   flex: 2,
//                   child: Text(
//                     'CLAIM ID',
//                     style: TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.grey,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   flex: 2,
//                   child: Text(
//                     'DATE',
//                     style: TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.grey,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   flex: 2,
//                   child: Text(
//                     'PATIENT',
//                     style: TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.grey,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   flex: 2,
//                   child: Text(
//                     'PROVIDER',
//                     style: TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.grey,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   flex: 2,
//                   child: Text(
//                     'AMOUNT',
//                     style: TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.grey,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   flex: 2,
//                   child: Text(
//                     'STATUS',
//                     style: TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.grey,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   flex: 1,
//                   child: Text(
//                     'ACTIONS',
//                     style: TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.grey,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           // Table Rows
//           // _buildTableRow(
//           //   'CLM-2024-001',
//           //   '2024-01-15',
//           //   'John Doe',
//           //   'Dr. Smith',
//           //   '₦45,000',
//           //   'Approved',
//           //   Colors.green,
//           // ),
//           // _buildTableRow(
//           //   'CLM-2024-002',
//           //   '2024-01-14',
//           //   'Jane Smith',
//           //   'Dr. Johnson',
//           //   '₦32,500',
//           //   'Pending',
//           //   Colors.orange,
//           // ),
          
//           }