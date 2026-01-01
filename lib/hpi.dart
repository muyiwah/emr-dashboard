import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schmgtsystem/models/patient_model.dart';
import 'package:schmgtsystem/providers/patient_proviider.dart';

class HpiScreen extends StatefulWidget {
  final String patientId;
  final String patientName;
  final String patientMrn;

  HpiScreen({
    required this.patientId,
    required this.patientName,
    required this.patientMrn,
    Key? key,
    required this.goBack,
  }) : super(key: key);
  final Null Function() goBack;
  @override
  _HpiScreenState createState() => _HpiScreenState();
}

class _HpiScreenState extends State<HpiScreen> {
  final TextEditingController _chiefComplaintController =
      TextEditingController();
  final TextEditingController _symptomDescriptionController =
      TextEditingController();
  final TextEditingController _aggravatingFactorsController =
      TextEditingController();
  final TextEditingController _relievingFactorsController =
      TextEditingController();
  final TextEditingController _additionalNotesController =
      TextEditingController();

  DateTime _selectedDate = DateTime.now();
  int _duration = 2;
  String _durationUnit = 'Hours';
  String _progressionType = 'Sudden';
  double _severityScale = 7.0;

  Map<String, bool> _associatedSymptoms = {
    'Fever': false,
    'Headache': false,
    'Nausea': false,
    'Vomiting': false,
    'Dizziness': false,
    'Sweating': false,
    'Fatigue': false,
    'Palpitations': false,
  };

  @override
  void initState() {
    super.initState();
    _loadExistingHpiData();
  }

  Future<void> _loadExistingHpiData() async {
    final provider = Provider.of<PatientProvider>(context, listen: false);
    final latestHpi = provider.getLatestHpiRecord(widget.patientId);

    if (latestHpi != null) {
      setState(() {
        _chiefComplaintController.text = latestHpi.chiefComplaint;
        _symptomDescriptionController.text = latestHpi.symptomDescription;
        _selectedDate = latestHpi.symptomOnset;
        _duration = latestHpi.duration;
        _durationUnit = latestHpi.durationUnit;
        _progressionType = latestHpi.progressionType;
        _severityScale = latestHpi.severityScale;
        _aggravatingFactorsController.text = latestHpi.aggravatingFactors;
        _relievingFactorsController.text = latestHpi.relievingFactors;
        _associatedSymptoms = latestHpi.associatedSymptoms;
        _additionalNotesController.text = latestHpi.additionalNotes;
      });
    }
  }

  Future<void> _saveHpiData() async {
    final provider = Provider.of<PatientProvider>(context, listen: false);

    final newHpiRecord = HpiRecord(
      id: 'hpi-${DateTime.now().millisecondsSinceEpoch}',
      patientId: widget.patientId,
      providerId: 'current-provider-id', // Replace with actual provider ID
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      chiefComplaint: _chiefComplaintController.text,
      symptomDescription: _symptomDescriptionController.text,
      symptomOnset: _selectedDate,
      duration: _duration,
      durationUnit: _durationUnit,
      progressionType: _progressionType,
      severityScale: _severityScale,
      aggravatingFactors: _aggravatingFactorsController.text,
      relievingFactors: _relievingFactorsController.text,
      associatedSymptoms: _associatedSymptoms,
      additionalNotes: _additionalNotesController.text,
    );

    provider.addHpiRecord(newHpiRecord);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('HPI data saved successfully')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            widget.goBack();
          },
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey[300],
              child: Icon(Icons.person, color: Colors.grey[600]),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.patientName,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'MRN: ${widget.patientMrn}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save, color: Colors.blue),
            onPressed: _saveHpiData,
          ),
        ],
      ),
      body: Row(
        children: [
          // Main content
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  SizedBox(height: 24),
                  _buildChiefComplaint(),
                  SizedBox(height: 24),
                  _buildSymptomDescription(),
                  SizedBox(height: 24),
                  _buildSymptomOnsetAndDuration(),
                  SizedBox(height: 24),
                  _buildProgressionType(),
                  SizedBox(height: 24),
                  _buildSeverityScale(),
                  SizedBox(height: 24),
                  _buildFactors(),
                  SizedBox(height: 24),
                  _buildAssociatedSymptoms(),
                  SizedBox(height: 24),
                  _buildAdditionalNotes(),
                  SizedBox(height: 32),
                  _buildSaveButton(),
                ],
              ),
            ),
          ),
          // Right sidebar
          Container(
            width: 300,
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                children: [_buildQuickTemplates(), _buildAuditTrail()],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Text(
          'History of Present Illness',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildChiefComplaint() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Chief Complaint*',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: _chiefComplaintController,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
              hintText: 'Enter chief complaint',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSymptomDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Symptom Description*',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: _symptomDescriptionController,
            maxLines: 4,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
              hintText:
                  'Describe symptoms in detail (onset, location, character, etc.)',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSymptomOnsetAndDuration() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Symptom Onset*',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: InkWell(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime.now().subtract(Duration(days: 365)),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      setState(() {
                        _selectedDate = date;
                      });
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Text('${_selectedDate.toLocal()}'.split(' ')[0]),
                        Spacer(),
                        Icon(Icons.calendar_today, color: Colors.grey[600]),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Duration*',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                          hintText: '2',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _duration = int.tryParse(value) ?? 2;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      value: _durationUnit,
                      underline: SizedBox(),
                      items:
                          ['Hours', 'Days', 'Weeks', 'Months'].map((
                            String value,
                          ) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _durationUnit = newValue!;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressionType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Progression Type*',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            _buildRadioOption('Gradual', 'Gradual'),
            _buildRadioOption('Sudden', 'Sudden'),
            _buildRadioOption('Intermittent', 'Intermittent'),
            _buildRadioOption('Progressive', 'Progressive'),
          ],
        ),
      ],
    );
  }

  Widget _buildRadioOption(String value, String label) {
    return Expanded(
      child: Row(
        children: [
          Radio<String>(
            value: value,
            groupValue: _progressionType,
            onChanged: (String? newValue) {
              setState(() {
                _progressionType = newValue!;
              });
            },
          ),
          Text(label),
        ],
      ),
    );
  }

  Widget _buildSeverityScale() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Severity Scale (1-10)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Text('Mild', style: TextStyle(color: Colors.grey[600])),
            Expanded(
              child: Slider(
                value: _severityScale,
                min: 1,
                max: 10,
                divisions: 9,
                onChanged: (value) {
                  setState(() {
                    _severityScale = value;
                  });
                },
              ),
            ),
            Text('Severe', style: TextStyle(color: Colors.grey[600])),
            SizedBox(width: 16),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${_severityScale.round()}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFactors() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Aggravating Factors',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _aggravatingFactorsController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                    hintText: 'What makes symptoms worse?',
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Relieving Factors',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _relievingFactorsController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                    hintText: 'What makes symptoms better?',
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAssociatedSymptoms() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Associated Symptoms',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 16),
        Wrap(
          spacing: 20,
          runSpacing: 12,
          children:
              _associatedSymptoms.entries.map((entry) {
                return SizedBox(
                  width: 140,
                  child: Row(
                    children: [
                      Checkbox(
                        value: entry.value,
                        onChanged: (bool? value) {
                          setState(() {
                            _associatedSymptoms[entry.key] = value!;
                          });
                        },
                      ),
                      Text(entry.key),
                    ],
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildAdditionalNotes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Additional Notes/Comments',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: _additionalNotesController,
            maxLines: 3,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
              hintText: 'Other relevant information',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickTemplates() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Templates',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16),
          _buildTemplateButton('Chest Pain', () {
            setState(() {
              _chiefComplaintController.text = 'Chest pain';
              _symptomDescriptionController.text =
                  'Patient reports chest discomfort/pain. Location: ${_getLocationText()}. Character: ${_getCharacterText()}. Radiation: ${_getRadiationText()}.';
            });
          }),
          _buildTemplateButton('Headache', () {
            setState(() {
              _chiefComplaintController.text = 'Headache';
              _symptomDescriptionController.text =
                  'Patient reports headache. Location: ${_getLocationText()}. Character: ${_getCharacterText()}. Severity: ${_severityScale.round()}/10.';
            });
          }),
          _buildTemplateButton('Abdominal Pain', () {
            setState(() {
              _chiefComplaintController.text = 'Abdominal pain';
              _symptomDescriptionController.text =
                  'Patient reports abdominal pain. Location: ${_getLocationText()}. Character: ${_getCharacterText()}. Relation to meals: ${_getRelationText()}.';
            });
          }),
        ],
      ),
    );
  }

  String _getLocationText() {
    return 'central'; // Could be made dynamic
  }

  String _getCharacterText() {
    return 'sharp'; // Could be made dynamic
  }

  String _getRadiationText() {
    return 'none'; // Could be made dynamic
  }

  String _getRelationText() {
    return 'no relation'; // Could be made dynamic
  }

  Widget _buildTemplateButton(String title, VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 8),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[200],
          foregroundColor: Colors.black,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text(title),
        ),
      ),
    );
  }

  Widget _buildAuditTrail() {
    final provider = Provider.of<PatientProvider>(context);
    final hpiRecords = provider.getHpiRecordsForPatient(widget.patientId);

    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'HPI History',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16),
          if (hpiRecords.isEmpty)
            Text(
              'No previous HPI records',
              style: TextStyle(color: Colors.grey),
            ),
          ...hpiRecords.map((record) => _buildHpiHistoryItem(record)).toList(),
        ],
      ),
    );
  }

  Widget _buildHpiHistoryItem(HpiRecord record) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            record.chiefComplaint,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            'Recorded: ${record.createdAt.toLocal()}',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          SizedBox(height: 8),
          InkWell(
            onTap: () {
              setState(() {
                _chiefComplaintController.text = record.chiefComplaint;
                _symptomDescriptionController.text = record.symptomDescription;
                _selectedDate = record.symptomOnset;
                _duration = record.duration;
                _durationUnit = record.durationUnit;
                _progressionType = record.progressionType;
                _severityScale = record.severityScale;
                _aggravatingFactorsController.text = record.aggravatingFactors;
                _relievingFactorsController.text = record.relievingFactors;
                _associatedSymptoms = record.associatedSymptoms;
                _additionalNotesController.text = record.additionalNotes;
              });
            },
            child: Text(
              'Load this record',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 12,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _saveHpiData,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          'Save HPI Record',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
