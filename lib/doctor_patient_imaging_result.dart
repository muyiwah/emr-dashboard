import 'package:flutter/material.dart';
import 'package:schmgtsystem/widgets/medical_imaging_popup.dart';

class MedicalImagingScreen extends StatefulWidget {
  const MedicalImagingScreen({super.key, required Null Function() goBack});

  @override
  State<MedicalImagingScreen> createState() => _MedicalImagingScreenState();
}

class _MedicalImagingScreenState extends State<MedicalImagingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            color: Colors.white,
            child: Row(
              children: [
                Icon(Icons.medical_services, color: Colors.blue[600], size: 24),
                SizedBox(width: 8),
                Icon(Icons.folder, color: Colors.orange, size: 20),
                SizedBox(width: 8),
                Text(
                  'Imaging Results – Patient Viewer',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                Spacer(),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.download, size: 16),
                  label: Text('Export Report'),
                  style: ElevatedButton.styleFrom(
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
              ],
            ),
          ),

          // Patient Info Bar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),

            color: Colors.white,
            child: Row(
              children: [
                _buildPatientInfo('Patient:', 'Sarah Johnson'),
                SizedBox(width: 24),
                _buildPatientInfo('ID:', 'PT-2024-001'),
                SizedBox(width: 24),
                _buildPatientInfo('Age:', '45'),
                SizedBox(width: 24),
                _buildPatientInfo('Gender:', 'Female'),
                SizedBox(width: 24),
                _buildPatientInfo('Visit Date:', 'Jan 15, 2024'),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Inpatient',
                    style: TextStyle(
                      color: Colors.green[800],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Current Visit - Jan 15, 2024',
                        style: TextStyle(fontSize: 12),
                      ),
                      Icon(Icons.arrow_drop_down, size: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: Row(
              children: [
                // Left Panel - Imaging
                Expanded(
                  flex: 2,
                  child: Container(
                    margin: EdgeInsets.all(16),
                    // padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 3,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 10,
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Current Imaging',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Spacer(),
                              _buildImageButton(
                                'Compare',
                                Icons.compare_arrows,
                              ),
                              SizedBox(width: 8),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder:
                                        (context) => MedicalImagingPopup(
                                          image: 'assets/scan1.png',
                                        ),
                                  );
                                },
                                child: _buildImageButton(
                                  'Fullscreen',
                                  Icons.fullscreen,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),

                        // X-ray Image
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              // borderRadius: BorderRadius.circular(8),
                            ),
                            child: Stack(
                              children: [
                                Image.asset(
                                  'assets/scan1.png',
                                  fit: BoxFit.fitWidth,
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Row(
                                    children: [
                                      _buildImageControlButton(Icons.search),
                                      SizedBox(width: 4),
                                      _buildImageControlButton(Icons.zoom_in),
                                      SizedBox(width: 4),
                                      _buildImageControlButton(Icons.refresh),
                                      SizedBox(width: 4),
                                      _buildImageControlButton(Icons.add),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // SizedBox(height: 8),

                        // Image Details
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Test Type:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    'Chest X-ray',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Date Taken:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    'Jan 15, 2024 - 2:30 PM',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Requesting Doctor:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    'Dr. Michael Chen',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Technician:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    'Tech ID: RAD-001',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // SizedBox(height: 12),
                        // Row(
                        //   children: [
                        //     Expanded(
                        //       child: Column(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           Text(
                        //             'Requesting Doctor:',
                        //             style: TextStyle(
                        //               fontWeight: FontWeight.w500,
                        //               fontSize: 12,
                        //             ),
                        //           ),
                        //           Text(
                        //             'Dr. Michael Chen',
                        //             style: TextStyle(fontSize: 12),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //     Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         Text(
                        //           'Technician:',
                        //           style: TextStyle(
                        //             fontWeight: FontWeight.w500,
                        //             fontSize: 12,
                        //           ),
                        //         ),
                        //         Text(
                        //           'Tech ID: RAD-001',
                        //           style: TextStyle(fontSize: 12),
                        //         ),
                        //       ],
                        //     ),
                        //   ],
                        // ),
                        // SizedBox(height: 16),

                        // Technician's Note
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Technician\'s Note:',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Patient positioned properly. Good inspiration. No artifacts noted.',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),

                        // SizedBox(height: 12),

                        // Attached Report
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.attach_file,
                                size: 16,
                                color: Colors.blue,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Attached Report (PDF)',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 12,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Right Panel - Radiologist Report
                Container(
                  width: 320,
                  margin: EdgeInsets.only(top: 16, right: 16, bottom: 16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Radiologist Report',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Spacer(),
                            Icon(
                              Icons.print,
                              size: 18,
                              color: Colors.grey[600],
                            ),
                          ],
                        ),
                        SizedBox(height: 20),

                        // Findings
                        _buildReportSection(
                          'Findings:',
                          'The lungs are clear bilaterally with no evidence of consolidation, pleural effusion, or pneumothorax. Heart size is within normal limits. No acute osseous abnormalities are identified.',
                        ),

                        SizedBox(height: 20),

                        // Impression
                        _buildReportSection(
                          'Impression:',
                          'Normal chest X-ray. No acute cardiopulmonary abnormalities.',
                        ),

                        SizedBox(height: 20),

                        // Recommendation
                        _buildReportSection(
                          'Recommendation:',
                          'No further imaging required at this time. Clinical correlation recommended.',
                        ),

                        SizedBox(height: 30),

                        // Doctor signature
                        Row(
                          children: [
                            Text(
                              'Dr. Emily Rodriguez, MD',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Spacer(),
                            Text(
                              'Jan 15, 2024 - 3:45 PM',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 20),

                        // Action Buttons
                        Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () {},
                                icon: Icon(Icons.chat, size: 16),
                                label: Text('Consult Radiologist'),
                                style: ElevatedButton.styleFrom(
                                  shape: BeveledRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  backgroundColor: Colors.blue[600],
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: () {},
                                icon: Icon(Icons.download, size: 16),
                                label: Text('Download Report as PDF'),
                                style: OutlinedButton.styleFrom(
                                  shape: BeveledRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Historical Imaging Results
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Historical Imaging Results',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Text('All Types', style: TextStyle(fontSize: 12)),
                          Icon(Icons.arrow_drop_down, size: 16),
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Text('All Areas', style: TextStyle(fontSize: 12)),
                          Icon(Icons.arrow_drop_down, size: 16),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),

                // Historical images thumbnails
                Row(
                  children: [
                    _buildHistoricalThumbnail(
                      'Chest X-ray',
                      'Dec 20, 2023',

                      'assets/scan2.png',
                      tap: () {
                        showDialog(
                          context: context,
                          builder:
                              (context) => MedicalImagingPopup(
                                image: 'assets/scan2.png',
                              ),
                        );
                      },
                    ),
                    SizedBox(width: 12),
                    _buildHistoricalThumbnail(
                      'CT Chest',
                      'Nov 15, 2023',
                      'assets/scan3.png',
                       tap: () {
                        showDialog(
                          context: context,
                          builder:
                              (context) => MedicalImagingPopup(
                                image: 'assets/scan3.png',
                              ),
                        );
                      },
                    ),
                    SizedBox(width: 12),
                    _buildHistoricalThumbnail(
                      'MRI Brain',
                      'Oct 10, 2023',
                      'assets/scan4.png',
                       tap: () {
                        showDialog(
                          context: context,
                          builder:
                              (context) => MedicalImagingPopup(
                                image: 'assets/scan4.png',
                              ),
                        );
                      },
                    ),
                    SizedBox(width: 12),
                    _buildHistoricalThumbnail(
                      'Ultrasound',
                      'Sep 5, 2023',
                      'assets/scan5.png',
                       tap: () {
                        showDialog(
                          context: context,
                          builder:
                              (context) => MedicalImagingPopup(
                                image: 'assets/scan5.png',
                              ),
                        );
                      },
                    ),
                    SizedBox(width: 12),
                    _buildHistoricalThumbnail(
                      'Chest X-ray',
                      'Aug 20, 2023',
                      'assets/scan6.png',
                       tap: () {
                        showDialog(
                          context: context,
                          builder:
                              (context) => MedicalImagingPopup(
                                image: 'assets/scan6.png',
                              ),
                        );
                      },
                    ),
                    SizedBox(width: 12),
                    _buildHistoricalThumbnail(
                      'CT Abdomen',
                      'Jul 15, 2023',
                      'assets/scan1.png',
                       tap: () {
                        showDialog(
                          context: context,
                          builder:
                              (context) => MedicalImagingPopup(
                                image: 'assets/scan1.png',
                              ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientInfo(String label, String value) {
    return RichText(
      text: TextSpan(
        style: TextStyle(color: Colors.black, fontSize: 14),
        children: [
          TextSpan(
            text: '$label ',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }

  Widget _buildImageButton(String text, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.blue[600]),
          SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: Colors.blue[600],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageControlButton(IconData icon) {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Icon(icon, size: 16, color: Colors.black),
    );
  }

  Widget _buildReportSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(content, style: TextStyle(fontSize: 13, height: 1.4)),
        ),
      ],
    );
  }

  Widget _buildHistoricalThumbnail(
    String type,
    String date,
    String image, {
    required Null Function() tap,
  }) {
    return GestureDetector(
      onTap: () {
        tap();
      },
      child: Container(
        width: 120,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Stack(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(image, fit: BoxFit.cover, width: 120, height: 80),
            // SizedBox(height: 2),
            Positioned(
              bottom: 5,
              left: 5,
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(color: Colors.black.withOpacity(.5)),
                child: Column(
                  children: [
                    Text(
                      type,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      date,
                      style: TextStyle(color: Colors.white70, fontSize: 8),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
