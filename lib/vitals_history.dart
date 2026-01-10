import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:schmgtsystem/models/vitals_model.dart';
import 'package:schmgtsystem/providers/patient_proviider.dart';

class VitalsHistory extends StatefulWidget {
  VitalsHistory({super.key, required this.goBack});
  Null Function() goBack;
  @override
  _VitalsHistoryState createState() => _VitalsHistoryState();
}

class _VitalsHistoryState extends State<VitalsHistory> {
  @override
  void initState() {
    super.initState();
    // Fetch patient with vitals history using the same approach as PatientDetailsScreen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final patientProvider = Provider.of<PatientProvider>(
        context,
        listen: false,
      );
      final currentPatient = patientProvider.currentPatient;
      if (currentPatient?.id != null) {
        patientProvider.fetchPatient(currentPatient!.id!, includeVitals: true);
      }
    });
  }

  String _getLastUpdatedText(VitalsRecord? latestVitals) {
    if (latestVitals == null) return 'No data';
    final now = DateTime.now();
    final recordedAt = latestVitals.recordedAt;
    final difference = now.difference(recordedAt);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} mins ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return DateFormat('MMM d, yyyy HH:mm').format(recordedAt);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      body: Consumer<PatientProvider>(
        builder: (context, patientProvider, _) {
          final vitalsHistory = patientProvider.currentPatientVitals;
          final latestVitals = vitalsHistory?.latest;
          final historicalVitals = vitalsHistory?.history ?? [];
          final isLoading = patientProvider.isLoading;

          // Debug logging
          print('=== VITALS HISTORY DEBUG ===');
          print('VitalsHistory: $vitalsHistory');
          print('Latest vitals: $latestVitals');
          print('Historical vitals count: ${historicalVitals.length}');
          if (historicalVitals.isNotEmpty) {
            print('First historical vital: ${historicalVitals[0]}');
            print('First vital type: ${historicalVitals[0].runtimeType}');
            try {
              print('First vital recordedAt: ${historicalVitals[0].recordedAt}');
              print('First vital recordedBy: ${historicalVitals[0].recordedBy}');
              print('First vital vitalSigns: ${historicalVitals[0].vitalSigns}');
            } catch (e) {
              print('Error accessing vital properties: $e');
            }
          }
          print('============================');

          return SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPatientHeader(),
            SizedBox(height: 24),
                _buildVitalSignsSection(latestVitals, isLoading),
            SizedBox(height: 24),
            _buildVitalsHistorySection(),
            SizedBox(height: 24),
                _buildHistoricalRecordsSection(historicalVitals, isLoading),
            SizedBox(height: 24),
            _buildActionsSection(),
          ],
        ),
          );
        },
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

  Widget _buildVitalSignsSection(VitalsRecord? latestVitals, bool isLoading) {
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
                    'Last Updated: ${_getLastUpdatedText(latestVitals)}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  SizedBox(width: 8),
                  InkWell(
                    onTap: () {
                      final patientProvider = Provider.of<PatientProvider>(
                        context,
                        listen: false,
                      );
                      final currentPatient = patientProvider.currentPatient;
                      if (currentPatient?.id != null) {
                        patientProvider.fetchPatient(
                          currentPatient!.id!,
                          includeVitals: true,
                        );
                      }
                    },
                    child: Container(
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
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          isLoading
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ),
                )
              : latestVitals == null
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'No vitals recorded',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    )
                  : GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.8,
            children: [
                        _buildVitalCardFromData(
                'Blood Pressure',
                          latestVitals.vitalSigns.bloodPressure,
              ),
                        _buildVitalCardFromData(
                'Heart Rate',
                          latestVitals.vitalSigns.heartRate,
              ),
                        _buildVitalCardFromData(
                'Temperature',
                          latestVitals.vitalSigns.temperature,
              ),
                        _buildVitalCardFromData(
                'Respiratory Rate',
                          latestVitals.vitalSigns.respiratoryRate,
              ),
                        _buildVitalCardFromData(
                'Oxygen Saturation',
                          latestVitals.vitalSigns.oxygenSaturation,
              ),
                        _buildVitalCardFromData(
                'Pain Score',
                          latestVitals.vitalSigns.painScore,
              ),
                        _buildVitalCardFromData(
                'BMI',
                          latestVitals.vitalSigns.weight,
                          latestVitals.vitalSigns.height,
                        ),
                        _buildVitalCardFromData(
                'Blood Glucose',
                          latestVitals.vitalSigns.bloodGlucose,
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

  Widget _buildVitalCardFromData(String title, dynamic vital, [dynamic vital2]) {
    if (vital == null) {
      return _buildVitalCard(title, 'N/A', '', 'No data', Colors.grey);
    }

    String value = '';
    String unit = '';
    String status = '';
    Color statusColor = Colors.grey;

    if (vital is BloodPressure) {
      value = vital.displayValue;
      unit = 'mmHg';
      if (vital.systolic != null) {
        if (vital.systolic! >= 140 || (vital.diastolic != null && vital.diastolic! >= 90)) {
          status = 'High';
          statusColor = Colors.red;
        } else if (vital.systolic! >= 120 || (vital.diastolic != null && vital.diastolic! >= 80)) {
          status = 'Elevated';
          statusColor = Colors.orange;
        } else {
          status = 'Normal';
          statusColor = Colors.green;
        }
      } else {
        status = 'No data';
      }
    } else if (vital is HeartRate) {
      value = vital.value.toString();
      unit = 'bpm';
      if (vital.value < 60 || vital.value > 100) {
        status = vital.value < 60 ? 'Low' : 'High';
        statusColor = Colors.orange;
      } else {
        status = 'Normal';
        statusColor = Colors.green;
      }
    } else if (vital is Temperature) {
      value = vital.value.toStringAsFixed(1);
      unit = vital.unit == 'C' ? '°C' : '°F';
      final tempValue = vital.unit == 'C' ? vital.value : (vital.value - 32) * 5 / 9;
      if (tempValue >= 38.0) {
        status = 'Fever';
        statusColor = Colors.red;
      } else if (tempValue >= 37.5) {
        status = 'Elevated';
        statusColor = Colors.orange;
      } else {
        status = 'Normal';
        statusColor = Colors.green;
      }
    } else if (vital is RespiratoryRate) {
      value = vital.value.toString();
      unit = 'breaths/min';
      if (vital.value < 12 || vital.value > 20) {
        status = vital.value < 12 ? 'Low' : 'High';
        statusColor = Colors.orange;
      } else {
        status = 'Normal';
        statusColor = Colors.green;
      }
    } else if (vital is OxygenSaturation) {
      value = vital.value.toString();
      unit = '%';
      if (vital.value < 95) {
        status = 'Low';
        statusColor = Colors.red;
      } else if (vital.value < 98) {
        status = 'Below Normal';
        statusColor = Colors.orange;
      } else {
        status = 'Normal';
        statusColor = Colors.green;
      }
    } else if (vital is PainScore) {
      if (vital.value != null) {
        value = vital.value.toString();
        unit = '/10';
        if (vital.value! >= 7) {
          status = 'Severe';
          statusColor = Colors.red;
        } else if (vital.value! >= 4) {
          status = 'Moderate';
          statusColor = Colors.orange;
        } else {
          status = 'Mild';
          statusColor = Colors.green;
        }
      } else {
        value = 'N/A';
        unit = '';
        status = 'No data';
      }
    } else if (vital is Weight && vital2 is Height) {
      // Calculate BMI
      if (vital.value > 0 && vital2.value > 0) {
        final heightInMeters = vital2.unit == 'cm' ? vital2.value / 100 : vital2.value * 0.3048;
        final weightInKg = vital.unit == 'kg' ? vital.value : vital.value * 0.453592;
        final bmi = weightInKg / (heightInMeters * heightInMeters);
        value = bmi.toStringAsFixed(1);
        unit = 'kg/m²';
        if (bmi >= 30) {
          status = 'Obese';
          statusColor = Colors.red;
        } else if (bmi >= 25) {
          status = 'Overweight';
          statusColor = Colors.orange;
        } else if (bmi >= 18.5) {
          status = 'Normal';
          statusColor = Colors.green;
        } else {
          status = 'Underweight';
          statusColor = Colors.orange;
        }
      } else {
        value = 'N/A';
        unit = '';
        status = 'No data';
      }
    } else if (vital is BloodGlucose) {
      if (vital.value != null) {
        value = vital.value!.toStringAsFixed(0);
        unit = 'mg/dL';
        if (vital.value! >= 200) {
          status = 'Very High';
          statusColor = Colors.red;
        } else if (vital.value! >= 140) {
          status = 'High';
          statusColor = Colors.orange;
        } else if (vital.value! >= 70) {
          status = 'Normal';
          statusColor = Colors.green;
        } else {
          status = 'Low';
          statusColor = Colors.red;
        }
      } else {
        value = 'N/A';
        unit = '';
        status = 'No data';
      }
    } else {
      return _buildVitalCard(title, 'N/A', '', 'No data', Colors.grey);
    }

    return _buildVitalCard(title, value, unit, status, statusColor);
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

  Widget _buildHistoricalRecordsSection(
    List<VitalsRecord> historicalVitals,
    bool isLoading,
  ) {
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
          isLoading
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: CircularProgressIndicator(),
                  ),
                )
              : historicalVitals.isEmpty
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: Text(
                          'No historical vitals records found',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor: MaterialStateProperty.all(Colors.grey[50]),
                        columns: [
                          DataColumn(
                            label: Text(
                              'Date/Time',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'BP',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'HR',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Temp',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'RR',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'SpO₂',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Staff',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                        ],
                        rows: historicalVitals
                            .map((vital) {
                              try {
                                return _buildDataTableRowFromVital(vital);
                              } catch (e) {
                                print('Error building table row: $e');
                                print('Vital data: $vital');
                                return DataRow(
                                  cells: [
                                    DataCell(Text('Error')),
                                    DataCell(Text('Error')),
                                    DataCell(Text('Error')),
                                    DataCell(Text('Error')),
                                    DataCell(Text('Error')),
                                    DataCell(Text('Error')),
                                    DataCell(Text('Error')),
                                  ],
                                );
                              }
                            })
                            .toList(),
                      ),
          ),
        ],
      ),
    );
  }

  DataRow _buildDataTableRowFromVital(VitalsRecord vital) {
    try {
      // Format date/time - handle potential parsing errors
      String dateTime = 'N/A';
      try {
        dateTime = DateFormat('MMM d, yyyy HH:mm').format(vital.recordedAt);
      } catch (e) {
        print('Error formatting date: $e');
        dateTime = vital.recordedAt.toString();
      }

      // Get BP
      String bp = 'N/A';
      Color bpColor = Colors.grey[700]!;
      try {
        bp = vital.vitalSigns.bloodPressure?.displayValue ?? 'N/A';
        if (vital.vitalSigns.bloodPressure?.systolic != null) {
          final systolic = vital.vitalSigns.bloodPressure!.systolic!;
          if (systolic >= 140 ||
              (vital.vitalSigns.bloodPressure?.diastolic != null &&
                  vital.vitalSigns.bloodPressure!.diastolic! >= 90)) {
            bpColor = Colors.red;
          } else if (systolic >= 120 ||
              (vital.vitalSigns.bloodPressure?.diastolic != null &&
                  vital.vitalSigns.bloodPressure!.diastolic! >= 80)) {
            bpColor = Colors.orange;
          } else {
            bpColor = Colors.green;
          }
        }
      } catch (e) {
        print('Error parsing BP: $e');
      }

      // Get Heart Rate
      String hr = 'N/A';
      try {
        hr = vital.vitalSigns.heartRate?.value.toString() ?? 'N/A';
      } catch (e) {
        print('Error parsing HR: $e');
      }

      // Get Temperature
      String temp = 'N/A';
      try {
        if (vital.vitalSigns.temperature != null) {
          final tempValue = vital.vitalSigns.temperature!.value;
          final tempUnit = vital.vitalSigns.temperature!.unit == 'C' ? '°C' : '°F';
          temp = '${tempValue.toStringAsFixed(1)}$tempUnit';
        }
      } catch (e) {
        print('Error parsing temperature: $e');
      }

      // Get Respiratory Rate
      String rr = 'N/A';
      try {
        rr = vital.vitalSigns.respiratoryRate?.value.toString() ?? 'N/A';
      } catch (e) {
        print('Error parsing RR: $e');
      }

      // Get Oxygen Saturation
      String spo2 = 'N/A';
      try {
        spo2 = vital.vitalSigns.oxygenSaturation != null
            ? '${vital.vitalSigns.oxygenSaturation!.value}%'
            : 'N/A';
      } catch (e) {
        print('Error parsing SpO2: $e');
      }

      // Get Staff/Recorded By
      String staff = 'N/A';
      try {
        final recordedBy = vital.recordedBy;
        if (recordedBy != null) {
          // Handle both string and object cases
          if (recordedBy is String) {
            staff = recordedBy;
          } else {
            // If it's an object, try to extract name
            staff = recordedBy.toString();
          }
        }
      } catch (e) {
        print('Error parsing staff: $e');
      }

      return DataRow(
        cells: [
          DataCell(Text(dateTime, style: TextStyle(fontSize: 12))),
          DataCell(Text(bp, style: TextStyle(fontSize: 12, color: bpColor, fontWeight: FontWeight.w500))),
          DataCell(Text(hr, style: TextStyle(fontSize: 12))),
          DataCell(Text(temp, style: TextStyle(fontSize: 12, color: Colors.orange))),
          DataCell(Text(rr, style: TextStyle(fontSize: 12))),
          DataCell(Text(spo2, style: TextStyle(fontSize: 12))),
          DataCell(Text(staff, style: TextStyle(fontSize: 12))),
        ],
      );
    } catch (e, stackTrace) {
      print('Error in _buildDataTableRowFromVital: $e');
      print('Stack trace: $stackTrace');
      print('Vital record: $vital');
      // Return a safe default row
      return DataRow(
        cells: [
          DataCell(Text('Error')),
          DataCell(Text('N/A')),
          DataCell(Text('N/A')),
          DataCell(Text('N/A')),
          DataCell(Text('N/A')),
          DataCell(Text('N/A')),
          DataCell(Text('N/A')),
      ],
    );
  }
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
