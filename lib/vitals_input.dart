import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:schmgtsystem/models/patient_model.dart';
import 'package:schmgtsystem/models/vitals_model.dart';
import 'package:schmgtsystem/providers/patient_proviider.dart';
import 'package:schmgtsystem/services/api_service.dart';

class VitalSignsScreen extends StatefulWidget {
  final Patient patient;

  const VitalSignsScreen({Key? key, required this.patient}) : super(key: key);

  @override
  _VitalSignsScreenState createState() => _VitalSignsScreenState();
}

class _VitalSignsScreenState extends State<VitalSignsScreen> {
  final TextEditingController _systolicController = TextEditingController();
  final TextEditingController _diastolicController = TextEditingController();
  final TextEditingController _heartRateController = TextEditingController();
  final TextEditingController _respiratoryRateController =
      TextEditingController();
  final TextEditingController _temperatureController = TextEditingController();
  final TextEditingController _oxygenSaturationController =
      TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _bloodGlucoseController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  double _painLevel = 0.0;
  String _temperatureUnit = '°C';

  bool _isSaving = false;
  String? _saveMessage;

  @override
  void initState() {
    super.initState();
    // Fetch patient with vitals history
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final patientProvider = Provider.of<PatientProvider>(
        context,
        listen: false,
      );
      patientProvider.fetchPatient(widget.patient.id, includeVitals: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final patient = widget.patient;

    // Also set it in the provider for consistency (if provider is available)
    try {
      final patientProvider = Provider.of<PatientProvider>(
        context,
        listen: false,
      );
      if (patientProvider.currentPatient?.id != patient.id) {
        patientProvider.setCurrentPatient(patient);
      }
    } catch (e) {
      // Provider might not be available, that's okay
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/patient-management/patient-vitals');
            }
          },
        ),
        centerTitle: false,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              patient.name.isNotEmpty ? patient.name : 'Patient Vitals',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (patient.mrn.isNotEmpty)
              Text(
                'MRN: ${patient.mrn}',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
          ],
        ),
        titleSpacing: 0,
      ),
      body: SafeArea(
        child: Row(
          children: [
            // Main content area
            Expanded(
              flex: 3,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    SizedBox(height: 24),
                    _buildVitalSignsForm(),
                    SizedBox(height: 24),
                    _buildActionButtons(),
                  ],
                ),
              ),
            ),
            // Sidebar
            Container(
              width: 300,
              color: Colors.white,
              child: Consumer<PatientProvider>(
                builder: (context, patientProvider, _) {
                  return _buildSidebar(patientProvider.currentPatientVitals);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final patient = widget.patient;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.blueGrey.shade100,
            child: Text(
              patient.name.isNotEmpty
                  ? patient.name.substring(0, 1).toUpperCase()
                  : '?',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        patient.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Inpatient',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.blue[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Age: ${patient.age} • ${patient.gender}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              // TODO: Navigate to vitals history
            },
            child: const Text(
              'View History',
              style: TextStyle(fontSize: 12, color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVitalSignsForm() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.favorite, color: Colors.blue[600], size: 20),
              SizedBox(width: 8),
              Text(
                'Vital Signs Entry',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            'Record patient vitals with real-time validation',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          SizedBox(height: 24),
          _buildVitalSignsGrid(),
          SizedBox(height: 24),
          _buildPainScale(),
          SizedBox(height: 24),
          _buildOptionalFields(),
          SizedBox(height: 16),
          _buildAutoSaveIndicator(),
        ],
      ),
    );
  }

  Widget _buildVitalSignsGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildBloodPressureField()),
            SizedBox(width: 16),
            Expanded(child: _buildHeartRateField()),
            SizedBox(width: 16),
            Expanded(child: _buildRespiratoryRateField()),
          ],
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildTemperatureField()),
            SizedBox(width: 16),
            Expanded(child: _buildOxygenSaturationField()),
            SizedBox(width: 16),
            Expanded(child: _buildWeightField()),
          ],
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildHeightField()),
            SizedBox(width: 16),
            Expanded(child: Container()),
            SizedBox(width: 16),
            Expanded(child: Container()),
          ],
        ),
      ],
    );
  }

  Widget _buildBloodPressureField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.show_chart, color: Colors.purple[600], size: 16),
            SizedBox(width: 4),
            Text(
              'Blood Pressure',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: TextFormField(
                  controller: _systolicController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                '/',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: TextFormField(
                  controller: _diastolicController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        Text(
          'mmHg • Normal: 90-140/60-90',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildHeartRateField() {
    return _buildVitalField(
      'Heart Rate',
      _heartRateController,
      Icons.favorite,
      Colors.red[600]!,
      'bpm • Normal: 60-100',
    );
  }

  Widget _buildRespiratoryRateField() {
    return _buildVitalField(
      'Respiratory Rate',
      _respiratoryRateController,
      Icons.air,
      Colors.blue[600]!,
      'bpm • Normal: 12-20',
    );
  }

  Widget _buildTemperatureField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.thermostat, color: Colors.orange[600], size: 16),
            SizedBox(width: 4),
            Text(
              'Temperature',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: TextFormField(
                  controller: _temperatureController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(width: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: DropdownButton<String>(
                value: _temperatureUnit,
                underline: SizedBox(),
                isDense: true,
                items:
                    ['°C', '°F'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _temperatureUnit = newValue!;
                  });
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        Text(
          'Normal: 36.1-37.2°C',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildOxygenSaturationField() {
    return _buildVitalField(
      'Oxygen Saturation',
      _oxygenSaturationController,
      Icons.opacity,
      Colors.cyan[600]!,
      '% • Normal: 95-100%',
    );
  }

  Widget _buildWeightField() {
    return _buildVitalField(
      'Weight',
      _weightController,
      Icons.monitor_weight,
      Colors.purple[600]!,
      'kg',
    );
  }

  Widget _buildHeightField() {
    return _buildVitalField(
      'Height',
      _heightController,
      Icons.straighten,
      Colors.green[600]!,
      'cm',
    );
  }

  Widget _buildVitalField(
    String label,
    TextEditingController controller,
    IconData icon,
    Color iconColor,
    String unit,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: iconColor, size: 16),
            SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.green[200]!),
          ),
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(height: 4),
        Text(unit, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildPainScale() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.sentiment_dissatisfied,
              color: Colors.orange[600],
              size: 16,
            ),
            SizedBox(width: 4),
            Text(
              'Pain Scale (0-10)',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Text(
              '0',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            Expanded(
              child: Slider(
                value: _painLevel,
                min: 0,
                max: 10,
                divisions: 10,
                onChanged: (value) {
                  setState(() {
                    _painLevel = value;
                  });
                },
                activeColor: Colors.blue[600],
              ),
            ),
            Text(
              '10',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            SizedBox(width: 16),
            Text(
              '${_painLevel.toInt()}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'No Pain',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            Text(
              'Worst Pain',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOptionalFields() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.bloodtype, color: Colors.red[600], size: 16),
                  SizedBox(width: 4),
                  Text(
                    'Blood Glucose (Optional)',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: TextFormField(
                  controller: _bloodGlucoseController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: TextStyle(fontSize: 16),
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
              Row(
                children: [
                  Icon(Icons.note, color: Colors.orange[600], size: 16),
                  SizedBox(width: 4),
                  Text(
                    'Notes/Comments (Optional)',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: TextFormField(
                  controller: _notesController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    hintText: 'Additional observations or comments...',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                  ),
                  style: TextStyle(fontSize: 16),
                  maxLines: 3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAutoSaveIndicator() {
    return Row(
      children: [
        Icon(Icons.access_time, color: Colors.grey[600], size: 16),
        SizedBox(width: 4),
        Text(
          _saveMessage ?? 'No vitals saved yet',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: _isSaving ? null : _resetForm,
          child: Text('Cancel'),
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey[700],
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        SizedBox(width: 12),
        ElevatedButton(
          onPressed: _isSaving ? null : () => _submitVitals(resetAfter: true),
          child: Text('Save & Add Another'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[800],
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        SizedBox(width: 12),
        ElevatedButton(
          onPressed: _isSaving ? null : () => _submitVitals(resetAfter: false),
          child: _isSaving ? Text('Saving...') : Text('Save Vitals'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[600],
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  void _resetForm() {
    _systolicController.clear();
    _diastolicController.clear();
    _heartRateController.clear();
    _respiratoryRateController.clear();
    _temperatureController.clear();
    _oxygenSaturationController.clear();
    _weightController.clear();
    _heightController.clear();
    _bloodGlucoseController.clear();
    _notesController.clear();
    setState(() {
      _painLevel = 0.0;
      _saveMessage = null;
    });
  }

  Future<void> _submitVitals({required bool resetAfter}) async {
    final patient = widget.patient;

    if (patient.id.isEmpty) {
      setState(() {
        _saveMessage = 'No patient selected.';
      });
      return;
    }

    final String patientId = patient.id;

    // Build vitalSigns object according to backend contract
    final Map<String, dynamic> vitalSigns = {};

    // Blood Pressure
    final String systolicText = _systolicController.text.trim();
    final String diastolicText = _diastolicController.text.trim();
    if (systolicText.isNotEmpty || diastolicText.isNotEmpty) {
      final int? systolic = int.tryParse(systolicText);
      final int? diastolic = int.tryParse(diastolicText);
      if (systolic != null || diastolic != null) {
        vitalSigns['bloodPressure'] = {
          if (systolic != null) 'systolic': systolic,
          if (diastolic != null) 'diastolic': diastolic,
          'unit': 'mmHg',
        };
      }
    }

    // Heart Rate
    final String heartRateText = _heartRateController.text.trim();
    final int? heartRate = int.tryParse(heartRateText);
    if (heartRate != null) {
      vitalSigns['heartRate'] = {'value': heartRate, 'unit': 'bpm'};
    }

    // Respiratory Rate
    final String rrText = _respiratoryRateController.text.trim();
    final int? rr = int.tryParse(rrText);
    if (rr != null) {
      vitalSigns['respiratoryRate'] = {'value': rr, 'unit': 'breaths/min'};
    }

    // Temperature
    final String tempText = _temperatureController.text.trim();
    final double? temp = double.tryParse(tempText);
    if (temp != null) {
      // Strip degree symbol for backend (backend expects "C" or "F")
      final String tempUnit = _temperatureUnit.replaceAll('°', '');
      vitalSigns['temperature'] = {'value': temp, 'unit': tempUnit};
    }

    // Oxygen Saturation
    final String spo2Text = _oxygenSaturationController.text.trim();
    final int? spo2 = int.tryParse(spo2Text);
    if (spo2 != null) {
      vitalSigns['oxygenSaturation'] = {'value': spo2, 'unit': '%'};
    }

    // Weight
    final String weightText = _weightController.text.trim();
    final double? weight = double.tryParse(weightText);
    if (weight != null) {
      vitalSigns['weight'] = {'value': weight, 'unit': 'kg'};
    }

    // Height
    final String heightText = _heightController.text.trim();
    final double? height = double.tryParse(heightText);
    if (height != null) {
      vitalSigns['height'] = {'value': height, 'unit': 'cm'};
    }

    // Blood Glucose
    final String glucoseText = _bloodGlucoseController.text.trim();
    final double? glucose = double.tryParse(glucoseText);
    if (glucose != null) {
      vitalSigns['bloodGlucose'] = {'value': glucose, 'unit': 'mmol/L'};
    }

    // Pain Score
    if (_painLevel > 0) {
      vitalSigns['painScore'] = {'value': _painLevel.round(), 'scale': '0-10'};
    }

    if (vitalSigns.isEmpty) {
      setState(() {
        _saveMessage = 'Please enter at least one vital sign.';
      });
      return;
    }

    final Map<String, dynamic> body = {
      'vitalSigns': vitalSigns,
      'notes': _notesController.text.trim(),
      // recordedAt: let backend default to now if omitted
    };

    setState(() {
      _isSaving = true;
      _saveMessage = null;
    });

    final response = await ApiService.post(
      '${ApiService.patientsEndpoint}/$patientId/vitals',
      body,
    );

    setState(() {
      _isSaving = false;
      if (response.success) {
        _saveMessage = 'Vitals saved successfully.';
        if (resetAfter) {
          _resetForm();
        }
      } else {
        _saveMessage =
            'Failed to save vitals: ${response.error ?? 'Unknown error'}';
      }
    });
  }

  Widget _buildSidebar(VitalsHistory? vitalsHistory) {
    final history = vitalsHistory?.history ?? [];

    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.show_chart, color: Colors.blue[600], size: 20),
              SizedBox(width: 8),
              Text(
                'Recent Vitals',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          if (history.isEmpty)
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'No vitals history available',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            )
          else
            ...history.take(3).map((vital) => _buildVitalHistoryItem(vital)),
          SizedBox(height: 16),
          if (vitalsHistory != null && vitalsHistory.totalCount > 0)
            Container(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => _showVitalsHistoryDialog(context),
                child: Text('View Full History (${vitalsHistory.totalCount})'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blue[600],
                  side: BorderSide(color: Colors.blue[600]!),
                  padding: EdgeInsets.symmetric(vertical: 12),
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

  Widget _buildVitalHistoryItem(VitalsRecord vital) {
    final vs = vital.vitalSigns;
    final bp = vs.bloodPressure?.displayValue ?? '-';
    final hr = vs.heartRate?.value.toString() ?? '-';
    final temp = vs.temperature?.displayValue ?? '-';
    final spo2 = vs.oxygenSaturation?.value.toString() ?? '-';

    final now = DateTime.now();
    final recordedAt = vital.recordedAt;
    final difference = now.difference(recordedAt);

    String timeDisplay;
    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        timeDisplay = '${difference.inMinutes}m ago';
      } else {
        timeDisplay = DateFormat('HH:mm').format(recordedAt);
      }
    } else if (difference.inDays == 1) {
      timeDisplay = 'Yesterday ${DateFormat('HH:mm').format(recordedAt)}';
    } else if (difference.inDays < 7) {
      timeDisplay = DateFormat('EEE HH:mm').format(recordedAt);
    } else {
      timeDisplay = DateFormat('MMM d, HH:mm').format(recordedAt);
    }

    final staffName = vital.recordedBy ?? 'Unknown';

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                timeDisplay,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
              Text(
                staffName,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'BP: $bp',
                      style: TextStyle(fontSize: 11, color: Colors.grey[700]),
                    ),
                    Text(
                      'Temp: $temp',
                      style: TextStyle(fontSize: 11, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'HR: $hr',
                      style: TextStyle(fontSize: 11, color: Colors.grey[700]),
                    ),
                    Text(
                      'SpO₂: $spo2%',
                      style: TextStyle(fontSize: 11, color: Colors.grey[700]),
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

  Future<void> _showVitalsHistoryDialog(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder:
          (dialogContext) => _VitalsHistoryDialog(
            patientId: widget.patient.id,
            patientName: widget.patient.name,
          ),
    );
  }
}

class _VitalsHistoryDialog extends StatefulWidget {
  final String patientId;
  final String patientName;

  const _VitalsHistoryDialog({
    required this.patientId,
    required this.patientName,
  });

  @override
  State<_VitalsHistoryDialog> createState() => _VitalsHistoryDialogState();
}

class _VitalsHistoryDialogState extends State<_VitalsHistoryDialog> {
  bool _isLoading = true;
  List<VitalsRecord> _vitals = [];
  int _currentPage = 1;
  int _totalPages = 1;
  int _totalCount = 0;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadVitalsHistory();
  }

  Future<void> _loadVitalsHistory({int page = 1}) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await ApiService.getPatientVitalsHistory(
        widget.patientId,
        page: page,
        limit: 50, // Load more items per page for dialog
      );

      if (response.success && response.data != null) {
        final dynamic data = response.data;
        final dynamic responseData =
            data is Map<String, dynamic> ? (data['data'] ?? data) : null;

        if (responseData != null) {
          final dynamic vitalsList = responseData['vitals'];
          final dynamic pagination = responseData['pagination'];

          setState(() {
            if (vitalsList is List) {
              _vitals =
                  vitalsList
                      .map(
                        (v) => VitalsRecord.fromJson(v as Map<String, dynamic>),
                      )
                      .toList();
            }
            if (pagination is Map<String, dynamic>) {
              _currentPage = pagination['current'] ?? 1;
              _totalPages = pagination['pages'] ?? 1;
              _totalCount = pagination['total'] ?? 0;
            }
            _isLoading = false;
          });
        } else {
          setState(() {
            _error = 'Failed to parse vitals data';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _error = response.error ?? 'Failed to load vitals history';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error loading vitals: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Vitals History',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.patientName,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                        if (_totalCount > 0)
                          Text(
                            '$_totalCount records found',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                    color: Colors.grey[700],
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child:
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _error != null
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 48,
                              color: Colors.red[300],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _error!,
                              style: TextStyle(color: Colors.grey[700]),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => _loadVitalsHistory(),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                      : _vitals.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.assignment_outlined,
                              size: 48,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No vitals history available',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      )
                      : Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: _vitals.length,
                              itemBuilder: (context, index) {
                                return _buildVitalCard(_vitals[index]);
                              },
                            ),
                          ),
                          // Pagination
                          if (_totalPages > 1)
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                border: Border(
                                  top: BorderSide(color: Colors.grey[200]!),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.chevron_left),
                                    onPressed:
                                        _currentPage > 1
                                            ? () => _loadVitalsHistory(
                                              page: _currentPage - 1,
                                            )
                                            : null,
                                  ),
                                  Text(
                                    'Page $_currentPage of $_totalPages',
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.chevron_right),
                                    onPressed:
                                        _currentPage < _totalPages
                                            ? () => _loadVitalsHistory(
                                              page: _currentPage + 1,
                                            )
                                            : null,
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVitalCard(VitalsRecord vital) {
    final vs = vital.vitalSigns;
    final bp = vs.bloodPressure?.displayValue ?? '-';
    final hr = vs.heartRate?.value.toString() ?? '-';
    final rr = vs.respiratoryRate?.value.toString() ?? '-';
    final temp = vs.temperature?.displayValue ?? '-';
    final spo2 = vs.oxygenSaturation?.value.toString() ?? '-';
    final weight = vs.weight?.value.toStringAsFixed(1) ?? '-';
    final height = vs.height?.value.toStringAsFixed(0) ?? '-';
    final glucose = vs.bloodGlucose?.value?.toStringAsFixed(1) ?? '-';
    final pain = vs.painScore?.value?.toString() ?? '-';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.favorite, color: Colors.red[400], size: 20),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat('MMM d, yyyy • HH:mm').format(vital.recordedAt),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              if (vital.recordedBy != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    vital.recordedBy!,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.blue[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              if (bp != '-')
                _buildVitalChip('Blood Pressure', '$bp mmHg', Colors.purple),
              if (hr != '-')
                _buildVitalChip('Heart Rate', '$hr bpm', Colors.red),
              if (rr != '-')
                _buildVitalChip('Respiratory Rate', '$rr /min', Colors.blue),
              if (temp != '-')
                _buildVitalChip('Temperature', temp, Colors.orange),
              if (spo2 != '-') _buildVitalChip('SpO₂', '$spo2%', Colors.cyan),
              if (weight != '-')
                _buildVitalChip('Weight', '$weight kg', Colors.green),
              if (height != '-')
                _buildVitalChip('Height', '$height cm', Colors.teal),
              if (glucose != '-')
                _buildVitalChip('Glucose', '$glucose mmol/L', Colors.pink),
              if (pain != '-')
                _buildVitalChip('Pain Score', '$pain/10', Colors.deepOrange),
            ],
          ),
          if (vital.notes != null && vital.notes!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.note, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      vital.notes!,
                      style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVitalChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
