import 'package:flutter/material.dart';

class LabResultEntryPanel extends StatefulWidget {
  const LabResultEntryPanel({super.key, required Null Function() goBack});

  @override
  _LabResultEntryPanelState createState() => _LabResultEntryPanelState();
}

class _LabResultEntryPanelState extends State<LabResultEntryPanel> {
  final TextEditingController _plateletsController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

  String _hemoglobinFlag = 'Normal';
  String _wbcFlag = 'High';
  String _plateletsFlag = 'Auto';
  String _hematocritFlag = 'Normal';
  String _reviewStatus = 'Complete - No Review Needed';
  bool _markAsVerified = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(16),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.height * 0.95,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchAndFilters(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPatientInfo(),
                      SizedBox(height: 16),
                      _buildTestResults(),
                      SizedBox(height: 16),
                      _buildAdditionalNotes(),
                      SizedBox(height: 16),
                      _buildVerificationControls(),
                    ],
                  ),
                ),
              ),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 56,
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE0E0E0))),
      ),
      child: Row(
        children: [
          Icon(Icons.science_outlined, size: 20, color: Color(0xFF7C3AED)),
          SizedBox(width: 8),
          Text(
            'Lab Result Entry Panel',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1F2937),
            ),
          ),
          Spacer(),
          Text(
            'Tech: Sarah Johnson',
            style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
          ),
          SizedBox(width: 24),
          Text(
            'Shift: 08:00 - 16:00',
            style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      height: 64,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Color(0xFFF9FAFB),
        border: Border(bottom: BorderSide(color: Color(0xFFE0E0E0))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 40,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search by Patient ID, Sample ID, or Name...',
                  hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Color(0xFF9CA3AF),
                    size: 20,
                  ),
                  suffixIcon: Icon(
                    Icons.qr_code_scanner,
                    color: Color(0xFF6B7280),
                    size: 20,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: Color(0xFFD1D5DB)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: Color(0xFFD1D5DB)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: Color(0xFF3B82F6)),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
          SizedBox(width: 12),
          Container(
            height: 40,
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Color(0xFFD1D5DB)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: 'All Results',
                style: TextStyle(fontSize: 14, color: Color(0xFF374151)),
                items:
                    ['All Results', 'Pending', 'Completed', 'Urgent'].map((
                      String value,
                    ) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                onChanged: (String? newValue) {},
              ),
            ),
          ),
          SizedBox(width: 8),
          Container(
            height: 40,
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Color(0xFFD1D5DB)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: 'All Categories',
                style: TextStyle(fontSize: 14, color: Color(0xFF374151)),
                items:
                    [
                      'All Categories',
                      'Hematology',
                      'Chemistry',
                      'Microbiology',
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                onChanged: (String? newValue) {},
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientInfo() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Patient & Sample Information',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  'URGENT',
                  style: TextStyle(
                    color: Color(0xDC2626),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoField('Patient Name', 'Michael Anderson'),
                    SizedBox(height: 12),
                    _buildInfoField('Test Type', 'Full Blood Count'),
                  ],
                ),
              ),
              SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoField('Age / Gender', '45 / Male'),
                    SizedBox(height: 12),
                    _buildInfoField('Ordered By', 'Dr. Emma Wilson'),
                  ],
                ),
              ),
              SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoField('Patient ID', 'P-2024-001567'),
                    SizedBox(height: 12),
                    _buildInfoField('Request Date', 'Jan 08, 2024 09:30'),
                  ],
                ),
              ),
              SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoField('Sample ID', 'S-240108-0023'),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Text(
                          'Status',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF374151),
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Text(
                            'In Progress',
                            style: TextStyle(
                              color: Color(0xD97706),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
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
    );
  }

  Widget _buildInfoField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 13, color: Color(0xFF111827))),
      ],
    );
  }

  Widget _buildTestResults() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFFF9FAFB),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(6),
                topRight: Radius.circular(6),
              ),
            ),
            child: Text(
              'Test Results Entry',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Color(0xFFF3F4F6),
              border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text('TEST NAME', style: _tableHeaderStyle()),
                ),
                Expanded(
                  flex: 2,
                  child: Text('RESULT', style: _tableHeaderStyle()),
                ),
                Expanded(
                  flex: 2,
                  child: Text('UNIT', style: _tableHeaderStyle()),
                ),
                Expanded(
                  flex: 3,
                  child: Text('REFERENCE RANGE', style: _tableHeaderStyle()),
                ),
                Expanded(
                  flex: 2,
                  child: Text('FLAG', style: _tableHeaderStyle()),
                ),
                Expanded(
                  flex: 2,
                  child: Text('STATUS', style: _tableHeaderStyle()),
                ),
              ],
            ),
          ),
          _buildTestResultRow(
            'Hemoglobin',
            '14.2',
            'g/dL',
            '12.0 - 16.0',
            'Normal',
            true,
            false,
          ),
          _buildTestResultRow(
            'White Blood Cells',
            '12.5',
            'x10³/μL',
            '4.0 - 11.0',
            'High',
            false,
            true,
          ),
          _buildTestResultRowWithInput(
            'Platelets',
            'x10³/μL',
            '150 - 450',
            'Auto',
            null,
          ),
          _buildTestResultRow(
            'Hematocrit',
            '42.1',
            '%',
            '36.0 - 48.0',
            'Normal',
            true,
            false,
          ),
        ],
      ),
    );
  }

  TextStyle _tableHeaderStyle() {
    return TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w600,
      color: Color(0xFF6B7280),
      letterSpacing: 0.5,
    );
  }

  Widget _buildTestResultRow(
    String testName,
    String result,
    String unit,
    String range,
    String flag,
    bool isNormal,
    bool isHighlighted,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isHighlighted ? Color(0xFFFEF2F2) : Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              testName,
              style: TextStyle(fontSize: 13, color: Color(0xFF111827)),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration:
                  isHighlighted
                      ? BoxDecoration(
                        border: Border.all(color: Color(0xFFFCA5A5)),
                        borderRadius: BorderRadius.circular(3),
                      )
                      : null,
              child: Text(
                result,
                style: TextStyle(fontSize: 13, color: Color(0xFF111827)),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              unit,
              style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              range,
              style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFD1D5DB)),
                borderRadius: BorderRadius.circular(3),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: flag,
                  style: TextStyle(fontSize: 12, color: Color(0xFF374151)),
                  isDense: true,
                  items:
                      ['Normal', 'High', 'Low', 'Critical'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                  onChanged: (String? newValue) {},
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Icon(
                isNormal ? Icons.check : Icons.error_outline,
                color: isNormal ? Color(0xFF10B981) : Color(0xFFF59E0B),
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestResultRowWithInput(
    String testName,
    String unit,
    String range,
    String flag,
    bool? isNormal,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              testName,
              style: TextStyle(fontSize: 13, color: Color(0xFF111827)),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              height: 32,
              child: TextField(
                controller: _plateletsController,
                decoration: InputDecoration(
                  hintText: 'Enter result',
                  hintStyle: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(3),
                    borderSide: BorderSide(color: Color(0xFFD1D5DB)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(3),
                    borderSide: BorderSide(color: Color(0xFFD1D5DB)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(3),
                    borderSide: BorderSide(color: Color(0xFF3B82F6)),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                ),
                style: TextStyle(fontSize: 13),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text(
                unit,
                style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              range,
              style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFD1D5DB)),
                borderRadius: BorderRadius.circular(3),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: flag,
                  style: TextStyle(fontSize: 12, color: Color(0xFF374151)),
                  isDense: true,
                  items:
                      ['Auto', 'Normal', 'High', 'Low', 'Critical'].map((
                        String value,
                      ) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                  onChanged: (String? newValue) {},
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                'Pending',
                style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalNotes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Additional Notes & Attachments',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF111827),
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Technician Remarks',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        SizedBox(height: 8),
        Container(
          height: 80,
          child: TextField(
            controller: _remarksController,
            maxLines: null,
            expands: true,
            textAlignVertical: TextAlignVertical.top,
            decoration: InputDecoration(
              hintText:
                  'Add any observations or remarks about the sample or test results...',
              hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 13),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: Color(0xFFD1D5DB)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: Color(0xFFD1D5DB)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: Color(0xFF3B82F6)),
              ),
              contentPadding: EdgeInsets.all(12),
            ),
            style: TextStyle(fontSize: 13),
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Attachments',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        SizedBox(height: 8),
        Container(
          height: 80,
          decoration: BoxDecoration(
            border: Border.all(
              color: Color(0xFFD1D5DB),
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.cloud_upload_outlined,
                size: 24,
                color: Color(0xFF9CA3AF),
              ),
              SizedBox(height: 6),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Drop files here or ',
                      style: TextStyle(color: Color(0xFF6B7280), fontSize: 13),
                    ),
                    TextSpan(
                      text: 'browse',
                      style: TextStyle(color: Color(0xFF3B82F6), fontSize: 13),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2),
              Text(
                'PDF, JPG, PNG up to 10MB',
                style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVerificationControls() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFF9FAFB),
        border: Border.all(color: Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Verification Controls',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              SizedBox(
                width: 18,
                height: 18,
                child: Checkbox(
                  value: _markAsVerified,
                  onChanged: (value) {
                    setState(() {
                      _markAsVerified = value!;
                    });
                  },
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),
              ),
              SizedBox(width: 8),
              Text(
                'Mark as Verified by Technician',
                style: TextStyle(fontSize: 13, color: Color(0xFF374151)),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            'Review Status',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF374151),
            ),
          ),
          SizedBox(height: 8),
          Container(
            width: 250,
            height: 36,
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Color(0xFFD1D5DB)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _reviewStatus,
                isExpanded: true,
                style: TextStyle(fontSize: 13, color: Color(0xFF374151)),
                items:
                    [
                      'Complete - No Review Needed',
                      'Needs Review',
                      'Under Review',
                      'Reviewed',
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _reviewStatus = newValue!;
                  });
                },
              ),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Timestamp: Jan 08, 2024 14:23:45',
            style: TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      height: 72,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: [
          OutlinedButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.refresh, size: 16, color: Color(0xFF6B7280)),
            label: Text(
              'Discard / Reset',
              style: TextStyle(color: Color(0xFF6B7280)),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Color(0xFFD1D5DB)),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          SizedBox(width: 12),
          OutlinedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.print, size: 16, color: Color(0xFF6B7280)),
            label: Text(
              'Print Report',
              style: TextStyle(color: Color(0xFF6B7280)),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Color(0xFFD1D5DB)),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          Spacer(),
          ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.save, size: 16, color: Colors.white),
            label: Text(
              'Save & Next Sample',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF3B82F6),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.check, size: 16, color: Colors.white),
            label: Text(
              'Mark as Completed',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF10B981),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
