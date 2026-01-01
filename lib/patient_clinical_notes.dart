import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schmgtsystem/models/patient_model.dart';
import 'package:schmgtsystem/providers/patient_proviider.dart';
import 'package:schmgtsystem/widgets/clinical_note_template_popup.dart';
import 'package:schmgtsystem/widgets/clinical_notes_popup.dart';

class PatientClinicalNotes extends StatefulWidget {
  PatientClinicalNotes({super.key, required this.goBack});
  Null Function() goBack;

  @override
  State<PatientClinicalNotes> createState() => _PatientClinicalNotesState();
}

class _PatientClinicalNotesState extends State<PatientClinicalNotes> {
  Patient? _patient;

  @override
  void initState() {
    // TODO: implement initState

    _patient =
        Provider.of<PatientProvider>(context, listen: false).currentPatient;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Patient Header
                _buildPatientHeader(),
                SizedBox(height: 24),

                // Main Content Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Column - Clinical Notes
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          _buildMostRecentNote(),
                          SizedBox(height: 24),
                          _buildHistoricalNotes(),
                        ],
                      ),
                    ),
                    SizedBox(width: 24),

                    // Right Column - Actions & Highlights
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          _buildQuickActions(),
                          SizedBox(height: 24),
                          _buildAIHighlights(),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPatientHeader() {
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
      child: Row(
        children: [
          // Patient Avatar
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage(
              'assets/patient_avatar.jpg',
            ), // You'd need to add this asset
            backgroundColor: Colors.grey[300],
          ),
          SizedBox(width: 16),

          // Patient Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                 _patient?.name??'',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Patient ID: ${_patient?.mrn}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '${_patient?.gender} • ${_patient?.age} years • O+',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    SizedBox(width: 12),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Outpatient',
                        style: TextStyle(
                          color: Colors.green[700],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Allergies & Diagnoses
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Known Allergies:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  _buildAllergyCip('Penicillin', Colors.red),
                  SizedBox(width: 8),
                  _buildAllergyCip('Latex', Colors.red),
                ],
              ),
              SizedBox(height: 12),
              Text(
                'Current Diagnoses:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  _buildAllergyCip('Type 2 Diabetes', Colors.blue),
                  SizedBox(width: 8),
                  _buildAllergyCip('Hypertension', Colors.blue),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAllergyCip(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildMostRecentNote() {
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
            children: [
              IconButton(
                onPressed: () {
                  widget.goBack();
                },
                icon: Icon(Icons.arrow_back_ios),
              ),
              SizedBox(width: 8),
              Text(
                'Most Recent Clinical Note',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Progress Note',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            'January 15, 2024 • 2:30 PM    Dr. Michael Chen, MD',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          SizedBox(height: 16),

          // SOAP Notes
          _buildSOAPSection(
            'S - Subjective',
            'Patient reports improved blood sugar control since last visit. Experiencing occasional morning fatigue but overall energy levels have increased...',
            Colors.blue,
          ),
          SizedBox(height: 12),
          _buildSOAPSection(
            'O - Objective',
            'BP: 128/82 mmHg, HR: 76 bpm, Temp: 98.6°F, Weight: 165 lbs. HbA1c: 7.2% (improved from 8.1%)',
            Colors.cyan,
          ),
          SizedBox(height: 12),
          _buildSOAPSection(
            'A - Assessment',
            'Type 2 diabetes mellitus - well controlled. Hypertension - stable. Patient responding well to current medication regimen.',
            Colors.orange,
          ),
          SizedBox(height: 12),
          _buildSOAPSection(
            'P - Plan',
            'Continue current metformin dosage. Follow-up in 3 months. Order lipid panel. Dietary consultation recommended.',
            Colors.green,
          ),

          SizedBox(height: 16),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.edit, size: 16),
                label: Text('Edit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
              SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.fullscreen, size: 16),
                label: Text('View Full'),
                style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
              ),
              SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.add, size: 16),
                label: Text('Add Note'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSOAPSection(String title, String content, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: color, width: 4)),
        color: color.withOpacity(0.05),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 4),
          Text(
            content,
            style: TextStyle(fontSize: 14, color: Colors.grey[800]),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoricalNotes() {
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
            children: [
              Text(
                'Historical Clinical Notes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Spacer(),
              OutlinedButton(
                onPressed: () {},
                child: Text('Expand All'),
                style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
              ),
              SizedBox(width: 8),
              OutlinedButton(
                onPressed: () {},
                child: Text('Collapse All'),
                style: OutlinedButton.styleFrom(foregroundColor: Colors.grey),
              ),
            ],
          ),
          SizedBox(height: 16),

          // Search and filters
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search clinical notes...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Text('All Note Types'),
                    Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
              SizedBox(width: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [Text('All Doctors'), Icon(Icons.arrow_drop_down)],
                ),
              ),
              SizedBox(width: 8),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.filter_list, color: Colors.grey[600]),
              ),
            ],
          ),
          SizedBox(height: 16),

          // Historical notes list
          _buildHistoricalNoteItem(
            number: '1',
            date: 'December 18, 2023 • 10:15 AM',
            noteType: 'SOAP Note',
            status: 'Signed',
            statusColor: Colors.green,
            content:
                'Patient presents for routine diabetes follow-up. Reports good adherence to medication regimen...',
            doctor: 'Dr. Michael Chen, MD',
          ),
          SizedBox(height: 12),
          _buildHistoricalNoteItem(
            number: '2',
            date: 'November 22, 2023 • 3:45 PM',
            noteType: 'Consultation',
            status: 'Signed',
            statusColor: Colors.green,
            content:
                'Endocrinology consultation for diabetes management optimization. Recommendations for insulin therapy...',
            doctor: 'Dr. Sarah Williams, MD',
          ),
          SizedBox(height: 12),
          _buildHistoricalNoteItem(
            number: '3',
            date: 'October 15, 2023 • 9:30 AM',
            noteType: 'Progress Note',
            status: 'Signed',
            statusColor: Colors.green,
            content:
                'Initial diabetes diagnosis and treatment plan discussion. Patient education provided...',
            doctor: 'Dr. Michael Chen, MD',
          ),
        ],
      ),
    );
  }

  Widget _buildHistoricalNoteItem({
    required String number,
    required String date,
    required String noteType,
    required String status,
    required Color statusColor,
    required String content,
    required String doctor,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      date,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: 12),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        noteType,
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
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
                    Spacer(),
                    Icon(Icons.expand_more, color: Colors.grey[600]),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  content,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
                SizedBox(height: 4),
                Text(
                  doctor,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
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
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          _buildActionButton(
            icon: Icons.add,
            text: 'Add New Clinical Note',
            color: Colors.blue,
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ClinicalNotePopup();
                },
              );
            },
          ),
          SizedBox(height: 12),
          _buildActionButton(
            icon: Icons.print,
            text: 'Print/Export Notes',
            color: Colors.grey[600]!,
            onTap: () {},
          ),
          SizedBox(height: 12),
          _buildActionButton(
            icon: Icons.attach_file,
            text: 'Attach to Visit Summary',
            color: Colors.grey[600]!,
            onTap: () {},
          ),
          SizedBox(height: 12),
          _buildActionButton(
            icon: Icons.compare_arrows,
            text: 'Notes Templates',
            color: Colors.deepPurple!,
            onTap: () {
                 showDialog(
                context: context,
                builder: (context) => NoteTemplatePopup(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color == Colors.blue ? Colors.blue : Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color == Colors.blue ? Colors.blue : Colors.grey[200]!,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: color == Colors.blue ? Colors.white : color,
              size: 20,
            ),
            SizedBox(width: 12),
            Text(
              text,
              style: TextStyle(
                color: color == Colors.blue ? Colors.white : color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAIHighlights() {
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
            children: [
              Icon(Icons.auto_awesome, color: Colors.orange, size: 20),
              SizedBox(width: 8),
              Text(
                'AI Highlights',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildHighlightItem(
            title: 'Recurrent Symptoms',
            content: 'Morning fatigue mentioned in 3 recent visits',
            color: Colors.orange,
          ),
          SizedBox(height: 12),
          _buildHighlightItem(
            title: 'Diagnosis Evolution',
            content: 'HbA1c improved from 8.1% to 7.2% over 3 months',
            color: Colors.blue,
          ),
          SizedBox(height: 12),
          _buildHighlightItem(
            title: 'Medication Changes',
            content: 'Metformin dosage increased in November 2023',
            color: Colors.green,
          ),
          SizedBox(height: 12),
          _buildHighlightItem(
            title: 'Unresolved Issues',
            content: 'Lipid panel still pending from last visit',
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightItem({
    required String title,
    required String content,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: color, width: 4)),
        color: color.withOpacity(0.05),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 4),
          Text(
            content,
            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}
