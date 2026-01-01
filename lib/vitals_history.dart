import 'package:flutter/material.dart';

class VitalsHistory extends StatefulWidget {
  VitalsHistory({super.key, required this.goBack});
  Null Function() goBack;
  @override
  _VitalsHistoryState createState() => _VitalsHistoryState();
}

class _VitalsHistoryState extends State<VitalsHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPatientHeader(),
            SizedBox(height: 24),
            _buildVitalSignsSection(),
            SizedBox(height: 24),
            _buildVitalsHistorySection(),
            SizedBox(height: 24),
            _buildHistoricalRecordsSection(),
            SizedBox(height: 24),
            _buildActionsSection(),
          ],
        ),
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
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey[300],
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sarah Johnson',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'ID: #MR-2024-001',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    SizedBox(width: 16),
                    Text(
                      'Female, 42 years',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Inpatient',
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Room 302B',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.warning, color: Colors.red[700], size: 16),
                    SizedBox(width: 4),
                    Text(
                      'Penicillin Allergy',
                      style: TextStyle(
                        color: Colors.red[700],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Hypertension, Diabetes Type 2',
                style: TextStyle(
                  color: Colors.orange[700],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVitalSignsSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  widget.goBack();
                },
                icon: Icon(Icons.arrow_back_ios_new),
              ),
              Text(
                'Current Vital Signs',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Spacer(),
              Row(
                children: [
                  Text(
                    'Last Updated: 2 mins ago',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue[600],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.refresh, color: Colors.white, size: 16),
                        SizedBox(width: 4),
                        Text(
                          'Refresh',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.8,
            children: [
              _buildVitalCard(
                'Blood Pressure',
                '142/95',
                'mmHg',
                'High',
                Colors.red,
              ),
              _buildVitalCard(
                'Heart Rate',
                '78',
                'bpm',
                'Normal',
                Colors.green,
              ),
              _buildVitalCard(
                'Temperature',
                '99.2',
                '°F',
                'Elevated',
                Colors.orange,
              ),
              _buildVitalCard(
                'Respiratory Rate',
                '16',
                'bpm',
                'Normal',
                Colors.green,
              ),
              _buildVitalCard(
                'Oxygen Saturation',
                '98',
                '%',
                'Normal',
                Colors.green,
              ),
              _buildVitalCard(
                'Pain Score',
                '4',
                '/10',
                'Moderate',
                Colors.orange,
              ),
              _buildVitalCard(
                'BMI',
                '28.4',
                'kg/m²',
                'Overweight',
                Colors.orange,
              ),
              _buildVitalCard(
                'Blood Glucose',
                '165',
                'mg/dL',
                'High',
                Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVitalCard(
    String title,
    String value,
    String unit,
    String status,
    Color statusColor,
  ) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                  text: unit.isNotEmpty ? '\n$unit' : '',
                  style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          SizedBox(height: 4),
          Text(
            status,
            style: TextStyle(
              fontSize: 11,
              color: statusColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVitalsHistorySection() {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Vitals History',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Last 24 hours',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.arrow_drop_down,
                          size: 16,
                          color: Colors.grey[700],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Row(
                    children: [
                      _buildLegendItem('BP', Colors.blue),
                      SizedBox(width: 8),
                      _buildLegendItem('HR', Colors.green),
                      SizedBox(width: 8),
                      _buildLegendItem('Temp', Colors.orange),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            height: 200,
            child: Center(
              child: Text(
                'Chart visualization would go here',
                style: TextStyle(color: Colors.grey[500]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
      ],
    );
  }

  Widget _buildHistoricalRecordsSection() {
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
          Text(
            'Historical Records',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16),
          Table(
            border: TableBorder.all(color: Colors.grey[200]!, width: 1),
            children: [
              TableRow(
                decoration: BoxDecoration(color: Colors.grey[50]),
                children: [
                  _buildTableHeader('Date/Time'),
                  _buildTableHeader('BP'),
                  _buildTableHeader('HR'),
                  _buildTableHeader('Temp'),
                  _buildTableHeader('RR'),
                  _buildTableHeader('SpO₂'),
                  _buildTableHeader('Staff'),
                ],
              ),
              _buildTableRow(
                'Jan 8, 2025 14:30',
                '142/95',
                '78',
                '99.2°F',
                '16',
                '98%',
                'Nurse Johnson',
                Colors.red,
              ),
              _buildTableRow(
                'Jan 8, 2025 10:15',
                '138/92',
                '82',
                '98.6°F',
                '18',
                '97%',
                'Nurse Davis',
                Colors.orange,
              ),
              _buildTableRow(
                'Jan 8, 2025 06:00',
                '135/88',
                '75',
                '98.4°F',
                '16',
                '99%',
                'Nurse Smith',
                Colors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(String text) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.grey[700],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  TableRow _buildTableRow(
    String dateTime,
    String bp,
    String hr,
    String temp,
    String rr,
    String spo2,
    String staff,
    Color bpColor,
  ) {
    return TableRow(
      children: [
        _buildTableCell(dateTime),
        _buildTableCell(bp, textColor: bpColor),
        _buildTableCell(hr),
        _buildTableCell(temp, textColor: Colors.orange),
        _buildTableCell(rr),
        _buildTableCell(spo2),
        _buildTableCell(staff),
      ],
    );
  }

  Widget _buildTableCell(String text, {Color? textColor}) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: textColor ?? Colors.grey[700],
          fontWeight: textColor != null ? FontWeight.w500 : FontWeight.normal,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildActionsSection() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.add, size: 18),
            label: Text('Add Note'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.assessment, size: 18),
            label: Text('Full Chart'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal[600],
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.print, size: 18),
            label: Text('Print Summary'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[600],
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.compare_arrows, size: 18),
            label: Text('Compare Previous'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo[600],
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
