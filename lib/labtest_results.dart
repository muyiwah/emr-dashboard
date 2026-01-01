import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:schmgtsystem/widgets/test_result_popup.dart';

class MedicalLabResultsScreen extends StatefulWidget {
  MedicalLabResultsScreen({super.key, required this.goBack});
  Null Function() goBack;

  @override
  _MedicalLabResultsScreenState createState() =>
      _MedicalLabResultsScreenState();
}

class _MedicalLabResultsScreenState extends State<MedicalLabResultsScreen> {
  String selectedCategory = 'All Categories';
  String selectedTimeframe = 'Last 30 days';
  TextEditingController notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(
                'assets/profile_image.jpg',
              ), // Replace with actual image
              backgroundColor: Colors.grey[300],
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sarah Johnson',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'ID: EMR-2024-001 • Female, 34 years',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 8),
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.add, size: 18),
              label: Text('Order Tests'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6366F1),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.print, color: Colors.grey[600]),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Patient tags
              Row(
                children: [
                  _buildTag('Outpatient', Colors.blue),
                  SizedBox(width: 8),
                  _buildTag('Penicillin Allergy', Colors.orange),
                  SizedBox(width: 8),
                  _buildTag('Diabetes Type 2', Colors.orange),
                ],
              ),
              SizedBox(height: 20),

              // Search and filters
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      widget.goBack();
                    },
                    icon: Icon(Icons.arrow_back_ios),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search tests...',
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey[400],
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  _buildDropdown(selectedCategory, [
                    'All Categories',
                    'Blood Tests',
                    'Urine Tests',
                  ]),
                  SizedBox(width: 12),
                  _buildDropdown(selectedTimeframe, [
                    'Last 30 days',
                    'Last 60 days',
                    'Last 90 days',
                  ]),
                  SizedBox(width: 12),
                  _buildFilterButton('Abnormal Only', Colors.orange),
                  SizedBox(width: 8),
                  _buildFilterButton('AI Assist', Colors.cyan),
                ],
              ),
              SizedBox(height: 24),

              // Test panels
              Row(
                children: [
                  Expanded(
                    child:
                        _buildTestPanel('Complete Blood Count', '2 Abnormal', [
                          _buildTestItem('WBC', '12.5', 'K/μL', Colors.red),
                          _buildTestItem('RBC', '4.2', 'M/μL', Colors.black),
                          _buildTestItem(
                            'Hemoglobin',
                            '9.8',
                            'g/dL',
                            Colors.black,
                          ),
                        ]),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildTestPanel('Metabolic Panel', '1 Abnormal', [
                      _buildTestItem('Glucose', '165', 'mg/dL', Colors.red),
                      _buildTestItem(
                        'Creatinine',
                        '0.9',
                        'mg/dL',
                        Colors.green,
                      ),
                      _buildTestItem('Sodium', '142', 'mEq/L', Colors.green),
                    ]),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildTestPanel('Urinalysis', 'Normal', [
                      _buildTestItem('Protein', 'Negative', '', Colors.green),
                      _buildTestItem('Glucose', 'Negative', '', Colors.green),
                      _buildTestItem('Ketones', 'Negative', '', Colors.green),
                    ]),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildTestPanel('Lipid Panel', 'Critical', [
                      _buildTestItem(
                        'Total Cholesterol',
                        '285',
                        'mg/dL',
                        Colors.red,
                      ),
                      _buildTestItem('LDL', '195', 'mg/dL', Colors.red),
                      _buildTestItem('HDL', '35', 'mg/dL', Colors.red),
                    ]),
                  ),
                ],
              ),
              SizedBox(height: 32),

              // Detailed results and chart section
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left column - Detailed results and chart
                  Expanded(
                    // flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailedResults(),
                        SizedBox(height: 32),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _buildGlucoseChart()),
                            SizedBox(width: 8),
                            Expanded(
                              // flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabNotes(),
                                  _buildDoctorNotes(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 24),
                  // Right column - Notes
                  // Expanded(
                  //   flex: 1,
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       _buildLabNotes(),
                  //       SizedBox(height: 24),
                  //       _buildDoctorNotes(),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildDropdown(String value, List<String> options) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButton<String>(
        value: value,
        items:
            options
                .map(
                  (option) => DropdownMenuItem(
                    value: option,
                    child: Text(option, style: TextStyle(fontSize: 14)),
                  ),
                )
                .toList(),
        onChanged: (newValue) {
          setState(() {
            if (options.contains('All Categories')) {
              selectedCategory = newValue!;
            } else {
              selectedTimeframe = newValue!;
            }
          });
        },
        underline: Container(),
        icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
      ),
    );
  }

  Widget _buildFilterButton(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTestPanel(String title, String status, List<Widget> items) {
    Color statusColor =
        status.contains('Normal')
            ? Colors.green
            : status.contains('Critical')
            ? Colors.red
            : Colors.orange;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
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
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
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
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ...items,
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => LabResultsPopup(),
                );
              },
              child: Text('View Details'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6366F1),
                foregroundColor: Colors.white,
                elevation: 0,
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

  Widget _buildTestItem(
    String name,
    String value,
    String unit,
    Color valueColor,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          Row(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: valueColor,
                ),
              ),
              if (unit.isNotEmpty)
                Text(
                  ' $unit',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedResults() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Detailed Lab Results',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 16),
          _buildDetailedResultsTable(),
        ],
      ),
    );
  }

  Widget _buildDetailedResultsTable() {
    return Table(
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey[50]),
          children: [
            _buildTableHeader('TEST NAME'),
            _buildTableHeader('RESULT'),
            _buildTableHeader('UNIT'),
            _buildTableHeader('REFERENCE RANGE'),
            _buildTableHeader('FLAG'),
            _buildTableHeader('DATE/TIME'),
            _buildTableHeader('ACTIONS'),
          ],
        ),
        _buildTableRow(
          'Hemoglobin',
          '9.8',
          'g/dL',
          '12.0-15.5',
          'Critical Low',
          Colors.red,
        ),
        _buildTableRow(
          'White Blood Cells',
          '12.5',
          'K/μL',
          '4.5-11.0',
          'High',
          Colors.orange,
        ),
        _buildTableRow(
          'Red Blood Cells',
          '4.2',
          'M/μL',
          '4.0-5.2',
          'Normal',
          Colors.green,
        ),
      ],
    );
  }

  Widget _buildTableHeader(String text) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  TableRow _buildTableRow(
    String testName,
    String result,
    String unit,
    String range,
    String flag,
    Color flagColor,
  ) {
    return TableRow(
      children: [
        Padding(
          padding: EdgeInsets.all(12),
          child: Text(testName, style: TextStyle(fontSize: 14)),
        ),
        Padding(
          padding: EdgeInsets.all(12),
          child: Text(
            result,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: flagColor,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(12),
          child: Text(unit, style: TextStyle(fontSize: 14)),
        ),
        Padding(
          padding: EdgeInsets.all(12),
          child: Text(range, style: TextStyle(fontSize: 14)),
        ),
        Padding(
          padding: EdgeInsets.all(12),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: flagColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              flag,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(12),
          child: Text('Jan 15, 2024 09:30', style: TextStyle(fontSize: 14)),
        ),
        Padding(
          padding: EdgeInsets.all(12),
          child: Icon(Icons.trending_up, color: Colors.blue, size: 18),
        ),
      ],
    );
  }

  Widget _buildGlucoseChart() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Glucose Trend',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 26),
          Container(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true, drawVerticalLine: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const titles = ['Jan 1', 'Jan 8', 'Jan 15'];
                        return Text(titles[value.toInt() % titles.length]);
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: [FlSpot(0, 145), FlSpot(1, 158), FlSpot(2, 165)],
                    isCurved: true,
                    color: Colors.orange,
                    barWidth: 3,
                    dotData: FlDotData(show: true),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabNotes() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lab Notes & Interpretations',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.warning, color: Colors.orange, size: 16),
                    SizedBox(width: 8),
                    Text(
                      'Lab Technician Note',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange[800],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'Hemoglobin levels critically low. Recommend immediate consultation with hematologist.',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 8),
                Text(
                  'Dr. Martinez - Jan 15, 2024',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorNotes() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Doctor\'s Notes',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 16),
          TextField(
            controller: notesController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Add your notes here...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Color(0xFF6366F1)),
              ),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            child: Text('Save Note'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF6366F1),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
