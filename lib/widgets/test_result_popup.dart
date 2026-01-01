import 'package:flutter/material.dart';

class LabResultsPopup extends StatelessWidget {
  const LabResultsPopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 900,
        height: 600,
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.health_and_safety_rounded, color: Colors.blue[600], size: 24),
                  SizedBox(width: 12),
                  Text(
                    'Lab Results – Detailed View',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            // Patient Info
            Container(
              padding: EdgeInsets.all(24),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Patient Name',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Sarah Johnson',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Patient ID',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'PT-2024-1856',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Age / Gender',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '34 / Female',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Test Date',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Jan 8, 2025',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    // Full Blood Count Section
                    _buildTestSection(
                      icon: Icons.water_drop,
                      iconColor: Colors.red[600]!,
                      title: 'Full Blood Count (FBC)',
                      criticalCount: 2,
                      backgroundColor: Colors.red[50]!,
                      borderColor: Colors.red[200]!,
                      tests: [
                        _TestResult(
                          name: 'WBC Count',
                          value: '12.8',
                          unit: 'x10³/μL',
                          normalRange: '4.0-11.0',
                          status: 'High',
                          statusColor: Colors.red[600]!,
                          date: 'Jan 8, 2025',
                        ),
                        _TestResult(
                          name: 'RBC Count',
                          value: '4.2',
                          unit: 'x10⁶/μL',
                          normalRange: '3.8-5.2',
                          status: 'Normal',
                          statusColor: Colors.green[600]!,
                          date: 'Jan 8, 2025',
                        ),
                        _TestResult(
                          name: 'Hemoglobin',
                          value: '8.9',
                          unit: 'g/dL',
                          normalRange: '12.0-16.0',
                          status: 'Low',
                          statusColor: Colors.red[600]!,
                          date: 'Jan 8, 2025',
                        ),
                        _TestResult(
                          name: 'Platelets',
                          value: '285',
                          unit: 'x10³/μL',
                          normalRange: '150-450',
                          status: 'Normal',
                          statusColor: Colors.green[600]!,
                          date: 'Jan 8, 2025',
                        ),
                      ],
                    ),

                    SizedBox(height: 16),

                    // Urinalysis Section
                    _buildTestSection(
                      icon: Icons.science,
                      iconColor: Colors.blue[600]!,
                      title: 'Urinalysis',
                      normalTag: 'All Normal',
                      backgroundColor: Colors.blue[50]!,
                      borderColor: Colors.blue[200]!,
                      tests: [],
                    ),

                    SizedBox(height: 16),

                    // Lipid Panel Section
                    _buildTestSection(
                      icon: Icons.show_chart,
                      iconColor: Colors.orange[600]!,
                      title: 'Lipid Panel',
                      criticalCount: 1,
                      backgroundColor: Colors.orange[50]!,
                      borderColor: Colors.orange[200]!,
                      tests: [],
                    ),

                    SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Bottom Action Buttons
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  _buildActionButton(
                    icon: Icons.download,
                    label: 'Download PDF',
                    backgroundColor: Colors.blue[600]!,
                    textColor: Colors.white,
                  ),
                  SizedBox(width: 12),
                  _buildActionButton(
                    icon: Icons.add,
                    label: 'Add Comment',
                    backgroundColor: Colors.teal[600]!,
                    textColor: Colors.white,
                  ),
                  SizedBox(width: 12),
                  _buildActionButton(
                    icon: Icons.note_add,
                    label: 'Add to Summary',
                    backgroundColor: Colors.grey[700]!,
                    textColor: Colors.white,
                  ),
                  Spacer(),
                  _buildActionButton(
                    icon: Icons.close,
                    label: 'Close',
                    backgroundColor: Colors.transparent,
                    textColor: Colors.grey[700]!,
                    showBorder: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestSection({
    required IconData icon,
    required Color iconColor,
    required String title,
    int? criticalCount,
    String? normalTag,
    required Color backgroundColor,
    required Color borderColor,
    required List<_TestResult> tests,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Section Header
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: iconColor, size: 20),
                SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 12),
                if (criticalCount != null)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red[600],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$criticalCount Critical',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                if (normalTag != null)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green[600],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      normalTag,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                Spacer(),
                Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
              ],
            ),
          ),

          // Test Results
          if (tests.isNotEmpty)
            ...tests.map((test) => _buildTestResultRow(test)).toList(),
        ],
      ),
    );
  }

  Widget _buildTestResultRow(_TestResult test) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              test.name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: Text(
              test.value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: test.status == 'Normal' ? Colors.black : Colors.red[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              test.unit,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ),
          Expanded(
            child: Text(
              test.normalRange,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Icon(
                  test.status == 'Normal' ? Icons.check_circle : Icons.warning,
                  color: test.statusColor,
                  size: 16,
                ),
                SizedBox(width: 4),
                Text(
                  test.status,
                  style: TextStyle(
                    fontSize: 12,
                    color: test.statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Text(
              test.date,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color backgroundColor,
    required Color textColor,
    bool showBorder = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: showBorder ? Border.all(color: Colors.grey[300]!) : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {},
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: textColor, size: 16),
                SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TestResult {
  final String name;
  final String value;
  final String unit;
  final String normalRange;
  final String status;
  final Color statusColor;
  final String date;

  _TestResult({
    required this.name,
    required this.value,
    required this.unit,
    required this.normalRange,
    required this.status,
    required this.statusColor,
    required this.date,
  });
}

// Usage example:
// showDialog(
//   context: context,
//   builder: (context) => LabResultsPopup(),
// );
