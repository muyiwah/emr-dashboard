import 'package:flutter/material.dart';


class RadiologyModuleScreen extends StatefulWidget {
  @override
  _RadiologyModuleScreenState createState() => _RadiologyModuleScreenState();
}

class _RadiologyModuleScreenState extends State<RadiologyModuleScreen> {
  String selectedPatient = 'Sarah Johnson - DOB: 03/15/1985';
  String selectedProcedure = 'CT Scan';
  String selectedPriority = 'Routine';
  String selectedQueueFilter = 'All';
  TextEditingController diagnosisController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildLeftPanel(),
                ),
                Expanded(
                  flex: 3,
                  child: _buildRightPanel(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 60,
      color: Colors.white,
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.all(12),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue[600],
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.medical_services, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  'Radiology Module',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          _buildHeaderTab('Requests', true),
          _buildHeaderTab('Admin', false),
          _buildHeaderTab('Viewer', false),
          _buildHeaderTab('Reports', false),
          Spacer(),
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: Colors.grey[600]),
            onPressed: () {},
          ),
          Container(
            margin: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 16,
              // backgroundImage: NetworkImage('https://via.placeholder.com/32'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderTab(String title, bool isActive) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        border: isActive
            ? Border(bottom: BorderSide(color: Colors.blue[600]!, width: 2))
            : null,
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isActive ? Colors.blue[600] : Colors.grey[600],
          fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildLeftPanel() {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildNewRequestSection(),
          SizedBox(height: 32),
          _buildQueueSection(),
        ],
      ),
    );
  }

  Widget _buildNewRequestSection() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
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
            children: [
              Text(
                'New Radiology Request',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              Spacer(),
              Icon(Icons.folder_outlined, color: Colors.blue[600], size: 20),
            ],
          ),
          SizedBox(height: 24),
          _buildFormField('Patient', _buildDropdown(selectedPatient, [
            'Sarah Johnson - DOB: 03/15/1985',
            'Michael Chen - DOB: 07/22/1990',
            'Emma Wilson - DOB: 11/08/1978',
          ], (value) => setState(() => selectedPatient = value!))),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildFormField('Procedure Type', _buildDropdown(selectedProcedure, [
                  'CT Scan',
                  'MRI Brain',
                  'X-Ray Chest',
                  'Ultrasound',
                ], (value) => setState(() => selectedProcedure = value!))),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildFormField('ICD-10 Diagnosis', TextField(
                  controller: diagnosisController,
                  decoration: InputDecoration(
                    hintText: 'Type to search diagnosis...',
                    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(color: Colors.blue[600]!),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                )),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildFormField('Priority', _buildDropdown(selectedPriority, [
                  'Routine',
                  'Urgent',
                  'STAT',
                  'Emergency',
                ], (value) => setState(() => selectedPriority = value!))),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildFormField('Additional Notes', Container(
            height: 80,
            child: TextField(
              controller: notesController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Clinical history and additional instructions...',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: Colors.blue[600]!),
                ),
                contentPadding: EdgeInsets.all(12),
              ),
            ),
          )),
          SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: Text(
                'Submit Request',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField(String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 6),
        child,
      ],
    );
  }

  Widget _buildDropdown(String value, List<String> items, ValueChanged<String?> onChanged) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(6),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          onChanged: onChanged,
          isExpanded: true,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Padding(
                padding: EdgeInsets.only(left: 12),
                child: Text(
                  item,
                  style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                ),
              ),
            );
          }).toList(),
          icon: Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
          ),
        ),
      ),
    );
  }

  Widget _buildQueueSection() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
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
              children: [
                Text(
                  'Radiology Queue',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                Spacer(),
                _buildQueueTab('All', selectedQueueFilter == 'All'),
                _buildQueueTab('Pending', selectedQueueFilter == 'Pending'),
                _buildQueueTab('Scheduled', selectedQueueFilter == 'Scheduled'),
              ],
            ),
            SizedBox(height: 16),
            _buildQueueHeaders(),
            SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: [
                  _buildQueueItem('#RAD-001', 'Sarah Johnson', 'CT Chest', 'STAT', 'Dr. Smith', 'Pending', Colors.orange),
                  _buildQueueItem('#RAD-002', 'Michael Chen', 'MRI Brain', 'Urgent', 'Dr. Wilson', 'Scheduled', Colors.blue),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQueueTab(String title, bool isActive) {
    return GestureDetector(
      onTap: () => setState(() => selectedQueueFilter = title),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        margin: EdgeInsets.only(left: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.blue[50] : null,
          borderRadius: BorderRadius.circular(4),
          border: isActive ? Border.all(color: Colors.blue[200]!) : null,
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.blue[600] : Colors.grey[600],
            fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildQueueHeaders() {
    return Row(
      children: [
        Expanded(flex: 1, child: _buildHeaderText('REQUEST ID')),
        Expanded(flex: 2, child: _buildHeaderText('PATIENT')),
        Expanded(flex: 1, child: _buildHeaderText('TEST TYPE')),
        Expanded(flex: 1, child: _buildHeaderText('PRIORITY')),
        Expanded(flex: 1, child: _buildHeaderText('REQUESTING DR.')),
        Expanded(flex: 1, child: _buildHeaderText('STATUS')),
        Expanded(flex: 1, child: _buildHeaderText('ACTIONS')),
      ],
    );
  }

  Widget _buildHeaderText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: Colors.grey[600],
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildQueueItem(String id, String patient, String testType, String priority, String doctor, String status, Color statusColor) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          Expanded(flex: 1, child: Text(id, style: TextStyle(fontSize: 13, color: Colors.grey[800]))),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  // backgroundImage: NetworkImage('https://via.placeholder.com/24'),
                ),
                SizedBox(width: 8),
                Text(patient, style: TextStyle(fontSize: 13, color: Colors.grey[800])),
              ],
            ),
          ),
          Expanded(flex: 1, child: Text(testType, style: TextStyle(fontSize: 13, color: Colors.grey[800]))),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: priority == 'STAT' ? Colors.red[100] : Colors.orange[100],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                priority,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: priority == 'STAT' ? Colors.red[700] : Colors.orange[700],
                ),
              ),
            ),
          ),
          Expanded(flex: 1, child: Text(doctor, style: TextStyle(fontSize: 13, color: Colors.grey[800]))),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor == Colors.orange ? Colors.orange[100] : Colors.blue[100],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                status,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: statusColor == Colors.orange ? Colors.orange[700] : Colors.blue[700],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                if (status == 'Pending') ...[
                  _buildActionButton('Approve', Colors.green),
                  SizedBox(width: 4),
                  _buildActionButton('Schedule', Colors.blue),
                ] else ...[
                  _buildActionButton('Assign', Colors.blue),
                  SizedBox(width: 4),
                  _buildActionButton('View', Colors.grey),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }

  Widget _buildRightPanel() {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          _buildStatsRow(),
          SizedBox(height: 24),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildDicomViewer(),
                ),
                SizedBox(width: 24),
                Expanded(
                  flex: 1,
                  child: _buildSidePanel(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(child: _buildStatCard('Pending Requests', '24', Colors.orange, Icons.pending_outlined)),
        SizedBox(width: 16),
        Expanded(child: _buildStatCard('Completed Today', '18', Colors.green, Icons.check_circle_outline)),
        SizedBox(width: 16),
        Expanded(child: _buildStatCard('Avg Turnaround', '2.4h', Colors.blue, Icons.schedule_outlined)),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
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
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacer(),
              if (title == 'Pending Requests')
                Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(Icons.warning_amber_outlined, color: Colors.orange[700], size: 16),
                ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              SizedBox(width: 4),
              Icon(Icons.trending_up, color: color, size: 16),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDicomViewer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              children: [
                Text(
                  'DICOM Viewer',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                Spacer(),
                Icon(Icons.search, color: Colors.grey[600], size: 20),
                SizedBox(width: 12),
                Icon(Icons.zoom_in, color: Colors.grey[600], size: 20),
                SizedBox(width: 12),
                Icon(Icons.refresh, color: Colors.grey[600], size: 20),
                SizedBox(width: 12),
                Icon(Icons.brightness_6_outlined, color: Colors.grey[600], size: 20),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.black,
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(150),
                        gradient: RadialGradient(
                          colors: [
                            Colors.blue.withOpacity(0.3),
                            Colors.cyan.withOpacity(0.2),
                            Colors.transparent,
                          ],
                          stops: [0.2, 0.6, 1.0],
                        ),
                      ),
                      child: CustomPaint(
                        painter: LungsPainter(),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Patient: Sarah Johnson',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        Text(
                          'Study: CT Chest • 2024-01-15',
                          style: TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.blue[600],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Annotate',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.grey[700],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Comment',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: Text(
                      'Slice 45/120',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidePanel() {
    return Column(
      children: [
        _buildPatientTimeline(),
        SizedBox(height: 24),
        _buildRecentReports(),
      ],
    );
  }

  Widget _buildPatientTimeline() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
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
            'Patient Timeline',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 16),
          _buildTimelineItem('CT Chest', 'Jan 15, 2024 • Completed', 'Normal', Colors.blue),
          _buildTimelineItem('MRI Brain', 'Dec 20, 2023 • Completed', 'Follow-up', Colors.blue),
          _buildTimelineItem('X-Ray Chest', 'Nov 10, 2023 • Completed', 'Normal', Colors.red),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(String title, String date, String status, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 4),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: Colors.green[700],
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

  Widget _buildRecentReports() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
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
              'Recent Reports',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 16),
            _buildReportItem('CT_Chest_Report.pdf', 'Dr. Anderson • Jan 15'),
            _buildReportItem('MRI_Brain_Report.pdf', 'Dr. Martinez • Dec 20'),
          ],
        ),
      ),
    );
  }

  Widget _buildReportItem(String filename, String details) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.picture_as_pdf, color: Colors.red[600], size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  filename,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  details,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.download_outlined, color: Colors.blue[600], size: 16),
        ],
      ),
    );
  }
}

class LungsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.cyan.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final center = Offset(size.width / 2, size.height / 2);

    // Draw left lung
    final leftLungPath = Path()
      ..moveTo(center.dx - 60, center.dy - 80)
      ..cubicTo(center.dx - 100, center.dy - 60, center.dx - 100, center.dy + 40, center.dx - 60, center.dy + 80)
      ..cubicTo(center.dx - 40, center.dy + 60, center.dx - 20, center.dy - 60, center.dx - 60, center.dy - 80);

    // Draw right lung
    final rightLungPath = Path()
      ..moveTo(center.dx + 60, center.dy - 80)
      ..cubicTo(center.dx + 100, center.dy - 60, center.dx + 100, center.dy + 40, center.dx + 60, center.dy + 80)
      ..cubicTo(center.dx + 40, center.dy + 60, center.dx + 20, center.dy - 60, center.dx + 60, center.dy - 80);

    canvas.drawPath(leftLungPath, paint);
    canvas.drawPath(rightLungPath, paint);

    // Ribcage
    final ribPaint = Paint()
      ..color = Colors.cyan.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (int i = 0; i < 8; i++) {
      final y = center.dy - 70 + (i * 20);
      final curve = 20 - (i * 2);

      final ribPath = Path()
        ..moveTo(center.dx - 80 + curve, y)
        ..quadraticBezierTo(center.dx, y - 10, center.dx + 80 - curve, y);

      canvas.drawPath(ribPath, ribPaint);
    }

    // Spine
    final spinePaint = Paint()
      ..color = Colors.cyan.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawLine(
      Offset(center.dx, center.dy - 90),
      Offset(center.dx, center.dy + 90),
      spinePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
