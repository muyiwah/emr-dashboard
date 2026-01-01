import 'package:flutter/material.dart';

// Data models
class LabOrder {
  final String id;
  final String name;
  final String priority;
  final String status;
  final DateTime orderedAt;
  final String? result;

  LabOrder({
    required this.id,
    required this.name,
    required this.priority,
    required this.status,
    required this.orderedAt,
    this.result,
  });
}

class ImagingOrder {
  final String id;
  final String name;
  final String status;
  final DateTime orderedAt;
  final String? result;

  ImagingOrder({
    required this.id,
    required this.name,
    required this.status,
    required this.orderedAt,
    this.result,
  });
}

class TimelineEvent {
  final DateTime timestamp;
  final String event;
  final String details;
  final String type; // 'arrival', 'vitals', 'order', 'result', 'note'

  TimelineEvent({
    required this.timestamp,
    required this.event,
    required this.details,
    required this.type,
  });
}

class EmergencyModuleScreen extends StatefulWidget {
  @override
  _EmergencyModuleScreenState createState() => _EmergencyModuleScreenState();
}

class _EmergencyModuleScreenState extends State<EmergencyModuleScreen> {
  String selectedTab = 'Subjective';
  String selectedDisposition = 'Admit to Ward';
  String selectedWard = 'Cardiology Ward';
  String selectedBed = 'C-101';

  // Text editing controllers for editable content
  final Map<String, TextEditingController> _controllers = {
    'chiefComplaint': TextEditingController(
      text: 'Severe chest pain radiating to left arm, started 2 hours ago',
    ),
    'hpi': TextEditingController(
      text:
          '45-year-old male presents with acute onset severe substernal chest pain that started while at rest. Pain described as crushing, 9/10 severity, radiating to left arm and jaw. Associated with diaphoresis and nausea. No relief with rest.',
    ),
    'pmh': TextEditingController(
      text: 'Hypertension, diabetes mellitus type 2, hyperlipidemia',
    ),
    'medications': TextEditingController(
      text:
          'Metformin 500mg BID, Lisinopril 10mg daily, Atorvastatin 20mg daily',
    ),
    'physicalExam': TextEditingController(
      text:
          'Appears diaphoretic and in distress. Heart rate irregular, no murmurs. Lungs clear bilaterally. Abdomen soft, non-tender.',
    ),
    'assessment': TextEditingController(
      text:
          'Acute STEMI (ST-elevation myocardial infarction) - anterior wall based on clinical presentation and ECG findings.',
    ),
    'plan': TextEditingController(
      text:
          '1. Immediate cardiac catheterization\n2. Dual antiplatelet therapy (aspirin + clopidogrel)\n3. Anticoagulation with heparin\n4. Serial cardiac enzymes\n5. Cardiology consultation\n6. CCU admission',
    ),
    'transferReason': TextEditingController(
      text:
          'Acute STEMI requiring immediate cardiac catheterization and monitoring',
    ),
  };

  // Lab orders data
  List<LabOrder> labOrders = [
    LabOrder(
      id: 'LAB001',
      name: 'Troponin I',
      priority: 'STAT',
      status: 'Completed',
      orderedAt: DateTime.now().subtract(Duration(hours: 1)),
      result: '15.2 ng/mL (Critical)',
    ),
    LabOrder(
      id: 'LAB002',
      name: 'CBC with Diff',
      priority: 'Urgent',
      status: 'In Progress',
      orderedAt: DateTime.now().subtract(Duration(minutes: 45)),
    ),
    LabOrder(
      id: 'LAB003',
      name: 'BMP',
      priority: 'Urgent',
      status: 'Pending',
      orderedAt: DateTime.now().subtract(Duration(minutes: 30)),
    ),
  ];

  // Imaging orders data
  List<ImagingOrder> imagingOrders = [
    ImagingOrder(
      id: 'IMG001',
      name: 'ECG',
      status: 'Completed',
      orderedAt: DateTime.now().subtract(Duration(hours: 1, minutes: 15)),
      result: 'ST elevation in leads II, III, aVF - Inferior STEMI',
    ),
    ImagingOrder(
      id: 'IMG002',
      name: 'Chest X-ray',
      status: 'STAT',
      orderedAt: DateTime.now().subtract(Duration(minutes: 20)),
    ),
  ];

  // Timeline events
  List<TimelineEvent> timelineEvents = [];

  final List<String> tabs = [
    'Subjective',
    'Objective',
    'Assessment',
    'Plan',
    'Timeline',
  ];

  @override
  void initState() {
    super.initState();
    _initializeTimeline();
  }

  void _initializeTimeline() {
    timelineEvents = [
      TimelineEvent(
        timestamp: DateTime.now().subtract(Duration(hours: 2)),
        event: 'Patient Arrival',
        details: 'Arrived via EMS with chest pain',
        type: 'arrival',
      ),
      TimelineEvent(
        timestamp: DateTime.now().subtract(Duration(hours: 1, minutes: 45)),
        event: 'Initial Assessment',
        details: 'Triage Level 1 - Chest pain with diaphoresis',
        type: 'note',
      ),
      TimelineEvent(
        timestamp: DateTime.now().subtract(Duration(hours: 1, minutes: 30)),
        event: 'Vitals Taken',
        details: 'BP: 180/95, HR: 102, Temp: 98.6°F, SpO2: 97%',
        type: 'vitals',
      ),
      TimelineEvent(
        timestamp: DateTime.now().subtract(Duration(hours: 1, minutes: 15)),
        event: 'ECG Ordered',
        details: 'STAT ECG for chest pain evaluation',
        type: 'order',
      ),
      TimelineEvent(
        timestamp: DateTime.now().subtract(Duration(hours: 1)),
        event: 'Lab Orders Placed',
        details: 'Troponin I, CBC, BMP ordered',
        type: 'order',
      ),
      TimelineEvent(
        timestamp: DateTime.now().subtract(Duration(minutes: 45)),
        event: 'ECG Results',
        details: 'ST elevation in leads II, III, aVF - Inferior STEMI',
        type: 'result',
      ),
      TimelineEvent(
        timestamp: DateTime.now().subtract(Duration(minutes: 30)),
        event: 'Cardiology Consult',
        details: 'Dr. Johnson consulted for STEMI',
        type: 'note',
      ),
    ];
  }

  @override
  void dispose() {
    _controllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _addLabOrder() {
    showDialog(
      context: context,
      builder: (context) => _buildAddLabOrderDialog(),
    );
  }

  void _addImagingOrder() {
    showDialog(
      context: context,
      builder: (context) => _buildAddImagingOrderDialog(),
    );
  }

  void _executeRapidOrder(String bundleName) {
    setState(() {
      DateTime now = DateTime.now();

      if (bundleName == 'Cardiac Bundle') {
        // Add cardiac-specific orders
        labOrders.addAll([
          LabOrder(
            id: 'LAB${DateTime.now().millisecondsSinceEpoch}',
            name: 'CK-MB',
            priority: 'STAT',
            status: 'Pending',
            orderedAt: now,
          ),
          LabOrder(
            id: 'LAB${DateTime.now().millisecondsSinceEpoch + 1}',
            name: 'PT/PTT',
            priority: 'STAT',
            status: 'Pending',
            orderedAt: now,
          ),
        ]);

        imagingOrders.add(
          ImagingOrder(
            id: 'IMG${DateTime.now().millisecondsSinceEpoch}',
            name: 'Echocardiogram',
            status: 'STAT',
            orderedAt: now,
          ),
        );
      }

      timelineEvents.insert(
        0,
        TimelineEvent(
          timestamp: now,
          event: '$bundleName Activated',
          details: 'Rapid order set executed',
          type: 'order',
        ),
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$bundleName orders have been placed'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _viewTimeline() {
    showDialog(context: context, builder: (context) => _buildTimelineDialog());
  }

  void _showStatOrders() {
    showDialog(
      context: context,
      builder: (context) => _buildStatOrdersDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 1, child: _buildLeftPanel()),
                    SizedBox(width: 16),
                    Expanded(flex: 2, child: _buildCenterPanel()),
                    SizedBox(width: 16),
                    Expanded(flex: 1, child: _buildRightPanel()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(Icons.local_hospital, color: Colors.white, size: 20),
          ),
          SizedBox(width: 12),
          Text(
            'Emergency Module',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          Spacer(),
          Row(
            children: [
              Text(
                'Dr. Sarah Wilson',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              SizedBox(width: 8),
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.grey[300],
                child: Icon(Icons.person, size: 16, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLeftPanel() {
    return Column(
      children: [
        _buildPatientInfoCard(),
        SizedBox(height: 16),
        _buildVitalsCard(),
        SizedBox(height: 16),
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildPatientInfoCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Patient Info',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Level 1',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildInfoRow('MRN:', 'ER-2024-001234'),
          _buildInfoRow('Name:', 'John Martinez'),
          _buildInfoRow('Age:', '45M'),
          _buildInfoRow('Arrival:', '14:30'),
          Row(
            children: [
              Text(
                'Status:',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              SizedBox(width: 8),
              Text(
                'In Progress',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.orange[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVitalsCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Latest Vitals',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildVitalItem('BP:', '180/95', Colors.red)),
              Expanded(child: _buildVitalItem('HR:', '102', Colors.orange)),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildVitalItem('Temp:', '98.6°F', Colors.green)),
              Expanded(child: _buildVitalItem('SpO2:', '97%', Colors.green)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVitalItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _showStatOrders,
            icon: Icon(Icons.flash_on, size: 18),
            label: Text('STAT Orders'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _viewTimeline,
            icon: Icon(Icons.timeline, size: 18),
            label: Text('View Timeline'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.cyan,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCenterPanel() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildTabBar(),
          Expanded(child: _buildTabContent()),
          _buildDispositionSection(),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Emergency Encounter Note',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 16),
          Row(children: tabs.map((tab) => _buildTabItem(tab)).toList()),
        ],
      ),
    );
  }

  Widget _buildTabItem(String tab) {
    bool isSelected = selectedTab == tab;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = tab;
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: 8),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.red.withOpacity(0.1) : Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: isSelected ? Colors.red : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          tab,
          style: TextStyle(
            fontSize: 14,
            color: isSelected ? Colors.red : Colors.grey[600],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (selectedTab == 'Subjective') _buildSubjectiveContent(),
            if (selectedTab == 'Objective') _buildObjectiveContent(),
            if (selectedTab == 'Assessment') _buildAssessmentContent(),
            if (selectedTab == 'Plan') _buildPlanContent(),
            if (selectedTab == 'Timeline') _buildTimelineContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectiveContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Chief Complaint'),
        _buildEditableTextArea('chiefComplaint'),
        SizedBox(height: 16),
        _buildSectionTitle('History of Present Illness'),
        _buildEditableTextArea('hpi'),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Past Medical History'),
                  _buildEditableTextArea('pmh'),
                ],
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Medications'),
                  _buildEditableTextArea('medications'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildObjectiveContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Physical Examination'),
        _buildEditableTextArea('physicalExam'),
        SizedBox(height: 16),
        _buildSectionTitle('Vital Signs'),
        _buildVitalSignsTable(),
        SizedBox(height: 16),
        _buildSectionTitle('Lab Results'),
        _buildLabResultsTable(),
      ],
    );
  }

  Widget _buildAssessmentContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Primary Assessment'),
        _buildEditableTextArea('assessment'),
      ],
    );
  }

  Widget _buildPlanContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Treatment Plan'),
        _buildEditableTextArea('plan'),
      ],
    );
  }

  Widget _buildTimelineContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Patient Timeline'),
        SizedBox(height: 12),
        ...timelineEvents.map((event) => _buildTimelineItem(event)),
      ],
    );
  }

  Widget _buildVitalSignsTable() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          _buildVitalRow('Blood Pressure', '180/95 mmHg', 'High'),
          _buildVitalRow('Heart Rate', '102 bpm', 'Elevated'),
          _buildVitalRow('Temperature', '98.6°F', 'Normal'),
          _buildVitalRow('Oxygen Saturation', '97%', 'Normal'),
          _buildVitalRow('Respiratory Rate', '20/min', 'Normal'),
        ],
      ),
    );
  }

  Widget _buildVitalRow(String parameter, String value, String status) {
    Color statusColor =
        status == 'Normal'
            ? Colors.green
            : status == 'Elevated'
            ? Colors.orange
            : Colors.red;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(parameter, style: TextStyle(fontSize: 14)),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabResultsTable() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children:
            labOrders
                .where((lab) => lab.result != null)
                .map((lab) => _buildLabResultRow(lab.name, lab.result!))
                .toList(),
      ),
    );
  }

  Widget _buildLabResultRow(String test, String result) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(test, style: TextStyle(fontSize: 14))),
          Expanded(
            child: Text(
              result,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color:
                    result.contains('Critical') ? Colors.red : Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(TimelineEvent event) {
    IconData icon;
    Color color;

    switch (event.type) {
      case 'arrival':
        icon = Icons.login;
        color = Colors.blue;
        break;
      case 'vitals':
        icon = Icons.favorite;
        color = Colors.red;
        break;
      case 'order':
        icon = Icons.assignment;
        color = Colors.orange;
        break;
      case 'result':
        icon = Icons.assessment;
        color = Colors.green;
        break;
      default:
        icon = Icons.note;
        color = Colors.grey;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      event.event,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    Spacer(),
                    Text(
                      '${event.timestamp.hour.toString().padLeft(2, '0')}:${event.timestamp.minute.toString().padLeft(2, '0')}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  event.details,
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey[800],
        ),
      ),
    );
  }

  Widget _buildEditableTextArea(String key) {
    return Container(
      width: double.infinity,
      child: TextField(
        controller: _controllers[key],
        maxLines: null,
        minLines: 2,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(6),
          ),
          contentPadding: EdgeInsets.all(12),
        ),
        style: TextStyle(fontSize: 13, color: Colors.grey[700], height: 1.4),
      ),
    );
  }

  Widget _buildDispositionSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Disposition',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              _buildDispositionButton(
                'Admit to Ward',
                Icons.hotel,
                selectedDisposition == 'Admit to Ward',
              ),
              SizedBox(width: 8),
              _buildDispositionButton(
                'Discharge',
                Icons.home,
                selectedDisposition == 'Discharge',
              ),
              SizedBox(width: 8),
              _buildDispositionButton(
                'Transfer',
                Icons.local_shipping,
                selectedDisposition == 'Transfer',
              ),
              SizedBox(width: 8),
              _buildDispositionButton(
                'Expired',
                Icons.airline_seat_flat,
                selectedDisposition == 'Expired',
              ),
            ],
          ),
          if (selectedDisposition == 'Admit to Ward') ...[
            SizedBox(height: 16),
            Text(
              'Admission Details',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ward',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 4),
                      _buildDropdown(selectedWard, [
                        'Cardiology Ward',
                        'ICU',
                        'General Ward',
                        'CCU',
                        'Telemetry Unit',
                      ], true),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bed Number',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 4),
                      _buildDropdown(selectedBed, [
                        'C-101',
                        'C-102',
                        'C-103',
                        'C-104',
                        'C-105',
                      ], false),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              'Transfer Reason',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            SizedBox(height: 4),
            _buildEditableTextArea('transferReason'),
          ],
        ],
      ),
    );
  }

  Widget _buildDispositionButton(String label, IconData icon, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedDisposition = label;
          });

          // Add timeline event for disposition change
          timelineEvents.insert(
            0,
            TimelineEvent(
              timestamp: DateTime.now(),
              event: 'Disposition Updated',
              details: 'Patient disposition changed to: $label',
              type: 'note',
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.red.withOpacity(0.1) : Colors.grey[50],
            border: Border.all(
              color: isSelected ? Colors.red : Colors.grey[300]!,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.red : Colors.grey[600],
                size: 20,
              ),
              SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? Colors.red : Colors.grey[600],
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(String value, List<String> options, bool isWard) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(6),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          style: TextStyle(fontSize: 14, color: Colors.grey[800]),
          onChanged: (String? newValue) {
            setState(() {
              if (isWard) {
                selectedWard = newValue!;
              } else {
                selectedBed = newValue!;
              }
            });
          },
          items:
              options.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
        ),
      ),
    );
  }

  Widget _buildRightPanel() {
    return ListView(
      children: [
        _buildRapidOrdersCard(),
        SizedBox(height: 16),
        _buildLabOrdersCard(),
        SizedBox(height: 16),
        _buildImagingOrdersCard(),
        SizedBox(height: 16),
        _buildOrderStatusCard(),
      ],
    );
  }

  Widget _buildRapidOrdersCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rapid Orders',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 12),
          _buildRapidOrderButton('Cardiac Bundle', Colors.red, Icons.favorite),
          SizedBox(height: 8),
          _buildRapidOrderButton(
            'Stroke Bundle',
            Colors.orange,
            Icons.psychology,
          ),
          SizedBox(height: 8),
          _buildRapidOrderButton(
            'Trauma Bundle',
            Colors.purple,
            Icons.local_hospital,
          ),
        ],
      ),
    );
  }

  Widget _buildRapidOrderButton(String label, Color color, IconData icon) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _executeRapidOrder(label),
        icon: Icon(icon, size: 16),
        label: Text(
          label,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
    );
  }

  Widget _buildLabOrdersCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lab Orders',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 12),
          ...labOrders.map((order) => _buildLabOrderItem(order)).toList(),
          SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _addLabOrder,
              icon: Icon(Icons.add, size: 16),
              label: Text('Add Lab Order'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.grey[600],
                side: BorderSide(color: Colors.grey[300]!),
                padding: EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabOrderItem(LabOrder order) {
    Color priorityColor = order.priority == 'STAT' ? Colors.red : Colors.orange;
    Color statusColor =
        order.status == 'Completed'
            ? Colors.green
            : order.status == 'In Progress'
            ? Colors.orange
            : Colors.grey;

    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: () {
          if (order.result != null) {
            _showLabResult(order);
          }
        },
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.name,
                      style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                    ),
                    Text(
                      order.status,
                      style: TextStyle(fontSize: 12, color: statusColor),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: priorityColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  order.priority,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagingOrdersCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Imaging Orders',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 12),
          ...imagingOrders
              .map((order) => _buildImagingOrderItem(order))
              .toList(),
          SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _addImagingOrder,
              icon: Icon(Icons.add_a_photo, size: 16),
              label: Text('Add Imaging Order'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.grey[600],
                side: BorderSide(color: Colors.grey[300]!),
                padding: EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagingOrderItem(ImagingOrder order) {
    Color statusColor = order.status == 'Completed' ? Colors.green : Colors.red;

    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: () {
          if (order.result != null) {
            _showImagingResult(order);
          }
        },
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.name,
                      style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                    ),
                    Text(
                      order.status,
                      style: TextStyle(fontSize: 12, color: statusColor),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  order.status,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderStatusCard() {
    int pendingCount =
        labOrders.where((order) => order.status == 'Pending').length +
        imagingOrders
            .where(
              (order) => order.status == 'STAT' || order.status == 'Pending',
            )
            .length;
    int inProgressCount =
        labOrders.where((order) => order.status == 'In Progress').length +
        imagingOrders.where((order) => order.status == 'In Progress').length;
    int completedCount =
        labOrders.where((order) => order.status == 'Completed').length +
        imagingOrders.where((order) => order.status == 'Completed').length;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Status',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 12),
          _buildStatusRow('Pending:', pendingCount.toString()),
          _buildStatusRow('In Progress:', inProgressCount.toString()),
          _buildStatusRow('Completed:', completedCount.toString()),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, String count) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          Text(
            count,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  // Dialog builders
  Widget _buildAddLabOrderDialog() {
    String selectedLab = 'CBC';
    String selectedPriority = 'Routine';

    return StatefulBuilder(
      builder: (context, setDialogState) {
        return AlertDialog(
          title: Text('Add Lab Order'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedLab,
                decoration: InputDecoration(labelText: 'Lab Test'),
                items:
                    [
                          'CBC',
                          'BMP',
                          'Lipid Panel',
                          'Liver Function',
                          'Thyroid Panel',
                          'Cardiac Enzymes',
                          'PT/INR',
                          'Urinalysis',
                          'Blood Culture',
                        ]
                        .map(
                          (lab) =>
                              DropdownMenuItem(value: lab, child: Text(lab)),
                        )
                        .toList(),
                onChanged:
                    (value) => setDialogState(() => selectedLab = value!),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedPriority,
                decoration: InputDecoration(labelText: 'Priority'),
                items:
                    ['STAT', 'Urgent', 'Routine']
                        .map(
                          (priority) => DropdownMenuItem(
                            value: priority,
                            child: Text(priority),
                          ),
                        )
                        .toList(),
                onChanged:
                    (value) => setDialogState(() => selectedPriority = value!),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  labOrders.add(
                    LabOrder(
                      id: 'LAB${DateTime.now().millisecondsSinceEpoch}',
                      name: selectedLab,
                      priority: selectedPriority,
                      status: 'Pending',
                      orderedAt: DateTime.now(),
                    ),
                  );

                  timelineEvents.insert(
                    0,
                    TimelineEvent(
                      timestamp: DateTime.now(),
                      event: 'Lab Order Added',
                      details: '$selectedLab - $selectedPriority priority',
                      type: 'order',
                    ),
                  );
                });
                Navigator.pop(context);
              },
              child: Text('Add Order'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAddImagingOrderDialog() {
    String selectedImaging = 'X-ray Chest';

    return StatefulBuilder(
      builder: (context, setDialogState) {
        return AlertDialog(
          title: Text('Add Imaging Order'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedImaging,
                decoration: InputDecoration(labelText: 'Imaging Study'),
                items:
                    [
                          'X-ray Chest',
                          'CT Head',
                          'CT Abdomen',
                          'MRI Brain',
                          'Ultrasound Abdomen',
                          'Echo',
                          'Nuclear Stress Test',
                        ]
                        .map(
                          (imaging) => DropdownMenuItem(
                            value: imaging,
                            child: Text(imaging),
                          ),
                        )
                        .toList(),
                onChanged:
                    (value) => setDialogState(() => selectedImaging = value!),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  imagingOrders.add(
                    ImagingOrder(
                      id: 'IMG${DateTime.now().millisecondsSinceEpoch}',
                      name: selectedImaging,
                      status: 'Pending',
                      orderedAt: DateTime.now(),
                    ),
                  );

                  timelineEvents.insert(
                    0,
                    TimelineEvent(
                      timestamp: DateTime.now(),
                      event: 'Imaging Order Added',
                      details: selectedImaging,
                      type: 'order',
                    ),
                  );
                });
                Navigator.pop(context);
              },
              child: Text('Add Order'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTimelineDialog() {
    return AlertDialog(
      title: Text('Patient Timeline'),
      content: Container(
        width: 500,
        height: 400,
        child: SingleChildScrollView(
          child: Column(
            children:
                timelineEvents
                    .map((event) => _buildTimelineItem(event))
                    .toList(),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Close'),
        ),
      ],
    );
  }

  Widget _buildStatOrdersDialog() {
    return AlertDialog(
      title: Text('STAT Orders'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.flash_on, color: Colors.red),
            title: Text('Emergency Intubation Kit'),
            onTap: () => _orderStatItem('Emergency Intubation Kit'),
          ),
          ListTile(
            leading: Icon(Icons.flash_on, color: Colors.red),
            title: Text('Crash Cart'),
            onTap: () => _orderStatItem('Crash Cart'),
          ),
          ListTile(
            leading: Icon(Icons.flash_on, color: Colors.red),
            title: Text('Type & Cross Match 4 Units'),
            onTap: () => _orderStatItem('Type & Cross Match 4 Units'),
          ),
          ListTile(
            leading: Icon(Icons.flash_on, color: Colors.red),
            title: Text('Arterial Blood Gas'),
            onTap: () => _orderStatItem('Arterial Blood Gas'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Close'),
        ),
      ],
    );
  }

  void _orderStatItem(String item) {
    setState(() {
      timelineEvents.insert(
        0,
        TimelineEvent(
          timestamp: DateTime.now(),
          event: 'STAT Order Placed',
          details: item,
          type: 'order',
        ),
      );
    });

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('STAT order placed: $item'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showLabResult(LabOrder order) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('${order.name} Result'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ordered: ${order.orderedAt.toString().substring(0, 16)}'),
                SizedBox(height: 8),
                Text('Status: ${order.status}'),
                SizedBox(height: 8),
                Text('Result: ${order.result ?? 'Pending'}'),
                if (order.result != null && order.result!.contains('Critical'))
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      'CRITICAL VALUE - Physician notified',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Close'),
              ),
            ],
          ),
    );
  }

  void _showImagingResult(ImagingOrder order) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('${order.name} Result'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ordered: ${order.orderedAt.toString().substring(0, 16)}'),
                SizedBox(height: 8),
                Text('Status: ${order.status}'),
                SizedBox(height: 8),
                Text('Result: ${order.result ?? 'Pending'}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Close'),
              ),
            ],
          ),
    );
  }
}
