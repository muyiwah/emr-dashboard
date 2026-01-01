import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schmgtsystem/models/patient_model.dart';
import 'package:schmgtsystem/providers/patient_proviider.dart';

class VitalSignsScreen extends StatefulWidget {
  @override
  _VitalSignsScreenState createState() => _VitalSignsScreenState();
}

class _VitalSignsScreenState extends State<VitalSignsScreen> {
  final TextEditingController _systolicController = TextEditingController(
    text: '120',
  );
  final TextEditingController _diastolicController = TextEditingController(
    text: '80',
  );
  final TextEditingController _heartRateController = TextEditingController(
    text: '72',
  );
  final TextEditingController _respiratoryRateController =
      TextEditingController(text: '16');
  final TextEditingController _temperatureController = TextEditingController(
    text: '36.5',
  );
  final TextEditingController _oxygenSaturationController =
      TextEditingController(text: '98');
  final TextEditingController _weightController = TextEditingController(
    text: '65.5',
  );
  final TextEditingController _heightController = TextEditingController(
    text: '165',
  );
  final TextEditingController _bloodGlucoseController = TextEditingController(
    text: '5.5',
  );
  final TextEditingController _notesController = TextEditingController();

  double _painLevel = 0.0;
  String _temperatureUnit = '°C';

  Patient? _patient;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _patient =
        Provider.of<PatientProvider>(context, listen: false).currentPatient;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
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
            Container(width: 300, color: Colors.white, child: _buildSidebar()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(
            'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=100&h=100&fit=crop&crop=face',
          ),
        ),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _patient?.name??'',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            Row(
              children: [
                Text(
                              _patient?.mrn ?? '',

                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                SizedBox(width: 16),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
                SizedBox(width: 8),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'View History',
                    style: TextStyle(fontSize: 12, color: Colors.blue[600]),
                  ),
                ),
              ],
            ),
            Text(
              'Age: ${_patient?.age} • ${_patient?.gender} • Ward: ICU-3 • Room: 312',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ],
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
          'Last saved: 2 minutes ago',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        SizedBox(width: 8),
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: Colors.green[600],
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 4),
        Text(
          'Auto-save enabled',
          style: TextStyle(fontSize: 12, color: Colors.green[600]),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () {},
          child: Text('Cancel'),
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey[700],
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        SizedBox(width: 12),
        ElevatedButton(
          onPressed: () {},
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
          onPressed: () {},
          child: Text('Save Vitals'),
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

  Widget _buildSidebar() {
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
          _buildVitalHistoryItem(
            'Today 14:30',
            'Dr. Smith',
            '118/76',
            '68',
            '36.8°C',
            '99%',
          ),
          _buildVitalHistoryItem(
            'Today 10:15',
            'Nurse Kate',
            '142/88',
            '72',
            '37.1°C',
            '98%',
          ),
          _buildVitalHistoryItem(
            'Yesterday 22:00',
            'Nurse John',
            '125/82',
            '75',
            '36.9°C',
            '97%',
          ),
          SizedBox(height: 16),
          Container(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              child: Text('View Full History'),
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

  Widget _buildVitalHistoryItem(
    String time,
    String staff,
    String bp,
    String hr,
    String temp,
    String spo2,
  ) {
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
                time,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
              Text(
                staff,
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
                      'SpO₂: $spo2',
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
}
