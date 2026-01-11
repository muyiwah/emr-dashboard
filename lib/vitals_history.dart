import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
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

  Widget _buildLegendItemForChart(String label, Color color) {
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
            onPressed: () {
              final patientProvider = Provider.of<PatientProvider>(
                context,
                listen: false,
              );
              final vitalsHistory = patientProvider.currentPatientVitals;
              final historicalVitals = vitalsHistory?.history ?? [];
              if (historicalVitals.isNotEmpty) {
                _showFullChartDialog(context, historicalVitals);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('No historical vitals data available'),
                    backgroundColor: Colors.orange,
                  ),
                );
              }
            },
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
            onPressed: () {
              final patientProvider = Provider.of<PatientProvider>(
                context,
                listen: false,
              );
              final vitalsHistory = patientProvider.currentPatientVitals;
              final historicalVitals = vitalsHistory?.history ?? [];
              if (historicalVitals.length >= 2) {
                _showCompareDialog(context, historicalVitals[0], historicalVitals[1]);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Need at least 2 vitals records to compare'),
                    backgroundColor: Colors.orange,
                  ),
                );
              }
            },
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

  void _showFullChartDialog(BuildContext context, List<VitalsRecord> historicalVitals) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(16),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.teal[600]!, Colors.teal[700]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.show_chart, color: Colors.white, size: 24),
                        SizedBox(width: 12),
                        Text(
                          'Vitals History Chart',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              // Charts Content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBloodPressureChart(historicalVitals),
                      SizedBox(height: 20),
                      _buildHeartRateChart(historicalVitals),
                      SizedBox(height: 20),
                      _buildTemperatureChart(historicalVitals),
                      SizedBox(height: 20),
                      _buildOxygenSaturationChart(historicalVitals),
                      SizedBox(height: 20),
                      _buildRespiratoryRateChart(historicalVitals),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBloodPressureChart(List<VitalsRecord> vitals) {
    if (vitals.isEmpty) return SizedBox.shrink();

    final systolicData = <FlSpot>[];
    final diastolicData = <FlSpot>[];
    
    for (int i = 0; i < vitals.length; i++) {
      final vital = vitals[i];
      final bp = vital.vitalSigns.bloodPressure;
      if (bp?.systolic != null) {
        systolicData.add(FlSpot(i.toDouble(), bp!.systolic!.toDouble()));
      }
      if (bp?.diastolic != null) {
        diastolicData.add(FlSpot(i.toDouble(), bp!.diastolic!.toDouble()));
      }
    }

    return _buildChartCard(
      title: 'Blood Pressure (mmHg)',
      child: Container(
        height: 250,
        child: LineChart(
          LineChartData(
            gridData: FlGridData(show: true),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    if (value.toInt() < vitals.length) {
                      final date = vitals[value.toInt()].recordedAt;
                      return Text(
                        DateFormat('MMM d\nHH:mm').format(date),
                        style: TextStyle(fontSize: 10),
                      );
                    }
                    return Text('');
                  },
                ),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: true),
            lineBarsData: [
              LineChartBarData(
                spots: systolicData,
                isCurved: true,
                color: Colors.red,
                barWidth: 3,
                dotData: FlDotData(show: true),
                belowBarData: BarAreaData(show: false),
              ),
              LineChartBarData(
                spots: diastolicData,
                isCurved: true,
                color: Colors.blue,
                barWidth: 3,
                dotData: FlDotData(show: true),
                belowBarData: BarAreaData(show: false),
              ),
            ],
            minY: 0,
            maxY: 200,
          ),
        ),
      ),
      legend: [
        _buildLegendItemForChart('Systolic', Colors.red),
        _buildLegendItemForChart('Diastolic', Colors.blue),
      ],
    );
  }

  Widget _buildHeartRateChart(List<VitalsRecord> vitals) {
    if (vitals.isEmpty) return SizedBox.shrink();

    final hrData = <FlSpot>[];
    for (int i = 0; i < vitals.length; i++) {
      final vital = vitals[i];
      if (vital.vitalSigns.heartRate != null) {
        hrData.add(FlSpot(i.toDouble(), vital.vitalSigns.heartRate!.value.toDouble()));
      }
    }

    return _buildChartCard(
      title: 'Heart Rate',
      subtitle: 'bpm',
      icon: Icons.favorite,
      iconColor: Colors.green,
      child: Container(
        height: 220,
        padding: EdgeInsets.all(8),
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 20,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: Colors.grey[200]!,
                  strokeWidth: 1,
                );
              },
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    return Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Text(
                        value.toInt().toString(),
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  getTitlesWidget: (value, meta) {
                    if (value.toInt() >= 0 && value.toInt() < vitals.length) {
                      final date = vitals[value.toInt()].recordedAt;
                      return Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          DateFormat('MMM d\nHH:mm').format(date),
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    return Text('');
                  },
                ),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border(
                bottom: BorderSide(color: Colors.grey[300]!, width: 1),
                left: BorderSide(color: Colors.grey[300]!, width: 1),
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: hrData,
                isCurved: true,
                color: Colors.green[600],
                barWidth: 3,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 4,
                      color: Colors.green[600]!,
                      strokeWidth: 2,
                      strokeColor: Colors.white,
                    );
                  },
                ),
                belowBarData: BarAreaData(
                  show: true,
                  color: Colors.green[600]!.withOpacity(0.15),
                ),
              ),
            ],
            minY: 0,
            maxY: 150,
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (touchedSpot) => Colors.grey[800]!,
                tooltipRoundedRadius: 8,
                tooltipPadding: EdgeInsets.all(8),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTemperatureChart(List<VitalsRecord> vitals) {
    if (vitals.isEmpty) return SizedBox.shrink();

    final tempData = <FlSpot>[];
    for (int i = 0; i < vitals.length; i++) {
      final vital = vitals[i];
      if (vital.vitalSigns.temperature != null) {
        double tempValue = vital.vitalSigns.temperature!.value;
        // Convert to Celsius if needed
        if (vital.vitalSigns.temperature!.unit == 'F') {
          tempValue = (tempValue - 32) * 5 / 9;
        }
        tempData.add(FlSpot(i.toDouble(), tempValue));
      }
    }

    return _buildChartCard(
      title: 'Temperature',
      subtitle: '°C',
      icon: Icons.thermostat,
      iconColor: Colors.orange,
      child: Container(
        height: 220,
        padding: EdgeInsets.all(8),
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 1,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: Colors.grey[200]!,
                  strokeWidth: 1,
                );
              },
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    return Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Text(
                        value.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  getTitlesWidget: (value, meta) {
                    if (value.toInt() >= 0 && value.toInt() < vitals.length) {
                      final date = vitals[value.toInt()].recordedAt;
                      return Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          DateFormat('MMM d\nHH:mm').format(date),
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    return Text('');
                  },
                ),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border(
                bottom: BorderSide(color: Colors.grey[300]!, width: 1),
                left: BorderSide(color: Colors.grey[300]!, width: 1),
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: tempData,
                isCurved: true,
                color: Colors.orange[600],
                barWidth: 3,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 4,
                      color: Colors.orange[600]!,
                      strokeWidth: 2,
                      strokeColor: Colors.white,
                    );
                  },
                ),
                belowBarData: BarAreaData(
                  show: true,
                  color: Colors.orange[600]!.withOpacity(0.15),
                ),
              ),
            ],
            minY: 35,
            maxY: 42,
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (touchedSpot) => Colors.grey[800]!,
                tooltipRoundedRadius: 8,
                tooltipPadding: EdgeInsets.all(8),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOxygenSaturationChart(List<VitalsRecord> vitals) {
    if (vitals.isEmpty) return SizedBox.shrink();

    final spo2Data = <FlSpot>[];
    for (int i = 0; i < vitals.length; i++) {
      final vital = vitals[i];
      if (vital.vitalSigns.oxygenSaturation != null) {
        spo2Data.add(FlSpot(i.toDouble(), vital.vitalSigns.oxygenSaturation!.value.toDouble()));
      }
    }

    return _buildChartCard(
      title: 'Oxygen Saturation',
      subtitle: '%',
      icon: Icons.air,
      iconColor: Colors.purple,
      child: Container(
        height: 220,
        padding: EdgeInsets.all(8),
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 2,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: Colors.grey[200]!,
                  strokeWidth: 1,
                );
              },
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    return Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Text(
                        value.toInt().toString(),
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  getTitlesWidget: (value, meta) {
                    if (value.toInt() >= 0 && value.toInt() < vitals.length) {
                      final date = vitals[value.toInt()].recordedAt;
                      return Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          DateFormat('MMM d\nHH:mm').format(date),
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    return Text('');
                  },
                ),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border(
                bottom: BorderSide(color: Colors.grey[300]!, width: 1),
                left: BorderSide(color: Colors.grey[300]!, width: 1),
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: spo2Data,
                isCurved: true,
                color: Colors.purple[600],
                barWidth: 3,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 4,
                      color: Colors.purple[600]!,
                      strokeWidth: 2,
                      strokeColor: Colors.white,
                    );
                  },
                ),
                belowBarData: BarAreaData(
                  show: true,
                  color: Colors.purple[600]!.withOpacity(0.15),
                ),
              ),
            ],
            minY: 90,
            maxY: 100,
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (touchedSpot) => Colors.grey[800]!,
                tooltipRoundedRadius: 8,
                tooltipPadding: EdgeInsets.all(8),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRespiratoryRateChart(List<VitalsRecord> vitals) {
    if (vitals.isEmpty) return SizedBox.shrink();

    final rrData = <FlSpot>[];
    for (int i = 0; i < vitals.length; i++) {
      final vital = vitals[i];
      if (vital.vitalSigns.respiratoryRate != null) {
        rrData.add(FlSpot(i.toDouble(), vital.vitalSigns.respiratoryRate!.value.toDouble()));
      }
    }

    return _buildChartCard(
      title: 'Respiratory Rate',
      subtitle: 'breaths/min',
      icon: Icons.airline_stops,
      iconColor: Colors.cyan,
      child: Container(
        height: 220,
        padding: EdgeInsets.all(8),
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 5,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: Colors.grey[200]!,
                  strokeWidth: 1,
                );
              },
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    return Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Text(
                        value.toInt().toString(),
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  getTitlesWidget: (value, meta) {
                    if (value.toInt() >= 0 && value.toInt() < vitals.length) {
                      final date = vitals[value.toInt()].recordedAt;
                      return Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          DateFormat('MMM d\nHH:mm').format(date),
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    return Text('');
                  },
                ),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border(
                bottom: BorderSide(color: Colors.grey[300]!, width: 1),
                left: BorderSide(color: Colors.grey[300]!, width: 1),
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: rrData,
                isCurved: true,
                color: Colors.cyan[600],
                barWidth: 3,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 4,
                      color: Colors.cyan[600]!,
                      strokeWidth: 2,
                      strokeColor: Colors.white,
                    );
                  },
                ),
                belowBarData: BarAreaData(
                  show: true,
                  color: Colors.cyan[600]!.withOpacity(0.15),
                ),
              ),
            ],
            minY: 0,
            maxY: 30,
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (touchedSpot) => Colors.grey[800]!,
                tooltipRoundedRadius: 8,
                tooltipPadding: EdgeInsets.all(8),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChartCard({
    required String title,
    String? subtitle,
    IconData? icon,
    Color? iconColor,
    required Widget child,
    List<Widget>? legend,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 1,
            blurRadius: 6,
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
              Row(
                children: [
                  if (icon != null) ...[
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: (iconColor ?? Colors.teal).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        icon,
                        color: iconColor ?? Colors.teal,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 12),
                  ],
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              if (legend != null) Row(children: legend),
            ],
          ),
          SizedBox(height: 16),
          child,
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
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[700]),
        ),
        SizedBox(width: 12),
      ],
    );
  }

  void _showCompareDialog(
    BuildContext context,
    VitalsRecord mostRecent,
    VitalsRecord previous,
  ) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(16),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.indigo[600]!, Colors.indigo[700]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.compare_arrows, color: Colors.white, size: 24),
                        SizedBox(width: 12),
                        Text(
                          'Vitals Comparison',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              // Content
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Date headers
                      Row(
                        children: [
                          Expanded(
                            child: _buildComparisonHeader(
                              'Most Recent',
                              mostRecent.recordedAt,
                              Colors.green,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: _buildComparisonHeader(
                              'Previous',
                              previous.recordedAt,
                              Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      // Comparison items
                      _buildComparisonItem(
                        'Blood Pressure',
                        Icons.favorite,
                        Colors.red,
                        _formatBloodPressure(mostRecent.vitalSigns.bloodPressure),
                        _formatBloodPressure(previous.vitalSigns.bloodPressure),
                        _getBPChange(mostRecent.vitalSigns.bloodPressure, previous.vitalSigns.bloodPressure),
                      ),
                      SizedBox(height: 12),
                      _buildComparisonItem(
                        'Heart Rate',
                        Icons.favorite,
                        Colors.green,
                        _formatHeartRate(mostRecent.vitalSigns.heartRate),
                        _formatHeartRate(previous.vitalSigns.heartRate),
                        _getHRChange(mostRecent.vitalSigns.heartRate, previous.vitalSigns.heartRate),
                      ),
                      SizedBox(height: 12),
                      _buildComparisonItem(
                        'Temperature',
                        Icons.thermostat,
                        Colors.orange,
                        _formatTemperature(mostRecent.vitalSigns.temperature),
                        _formatTemperature(previous.vitalSigns.temperature),
                        _getTempChange(mostRecent.vitalSigns.temperature, previous.vitalSigns.temperature),
                      ),
                      SizedBox(height: 12),
                      _buildComparisonItem(
                        'Respiratory Rate',
                        Icons.airline_stops,
                        Colors.cyan,
                        _formatRespiratoryRate(mostRecent.vitalSigns.respiratoryRate),
                        _formatRespiratoryRate(previous.vitalSigns.respiratoryRate),
                        _getRRChange(mostRecent.vitalSigns.respiratoryRate, previous.vitalSigns.respiratoryRate),
                      ),
                      SizedBox(height: 12),
                      _buildComparisonItem(
                        'Oxygen Saturation',
                        Icons.air,
                        Colors.purple,
                        _formatOxygenSaturation(mostRecent.vitalSigns.oxygenSaturation),
                        _formatOxygenSaturation(previous.vitalSigns.oxygenSaturation),
                        _getSpO2Change(mostRecent.vitalSigns.oxygenSaturation, previous.vitalSigns.oxygenSaturation),
                      ),
                      SizedBox(height: 12),
                      _buildComparisonItem(
                        'Pain Score',
                        Icons.sentiment_satisfied,
                        Colors.pink,
                        _formatPainScore(mostRecent.vitalSigns.painScore),
                        _formatPainScore(previous.vitalSigns.painScore),
                        _getPainChange(mostRecent.vitalSigns.painScore, previous.vitalSigns.painScore),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildComparisonHeader(String title, DateTime date, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 8),
          Text(
            DateFormat('MMM d, yyyy').format(date),
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            DateFormat('HH:mm').format(date),
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonItem(
    String label,
    IconData icon,
    Color iconColor,
    String mostRecentValue,
    String previousValue,
    String? change,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
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
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildComparisonValue('Most Recent', mostRecentValue, Colors.green),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildComparisonValue('Previous', previousValue, Colors.blue),
              ),
            ],
          ),
          if (change != null) ...[
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _getChangeColor(change).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _getChangeColor(change).withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getChangeIcon(change),
                    size: 16,
                    color: _getChangeColor(change),
                  ),
                  SizedBox(width: 8),
                  Text(
                    change,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _getChangeColor(change),
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

  Widget _buildComparisonValue(String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String _formatBloodPressure(BloodPressure? bp) {
    if (bp == null) return 'N/A';
    return bp.displayValue;
  }

  String _formatHeartRate(HeartRate? hr) {
    if (hr == null) return 'N/A';
    return '${hr.value} bpm';
  }

  String _formatTemperature(Temperature? temp) {
    if (temp == null) return 'N/A';
    return temp.displayValue;
  }

  String _formatRespiratoryRate(RespiratoryRate? rr) {
    if (rr == null) return 'N/A';
    return '${rr.value} breaths/min';
  }

  String _formatOxygenSaturation(OxygenSaturation? spo2) {
    if (spo2 == null) return 'N/A';
    return '${spo2.value}%';
  }

  String _formatPainScore(PainScore? pain) {
    if (pain == null || pain.value == null) return 'N/A';
    return '${pain.value}/10';
  }

  String? _getBPChange(BloodPressure? current, BloodPressure? previous) {
    if (current?.systolic == null || previous?.systolic == null) return null;
    final diff = current!.systolic! - previous!.systolic!;
    if (diff == 0) return 'No change';
    return '${diff > 0 ? '+' : ''}$diff mmHg';
  }

  String? _getHRChange(HeartRate? current, HeartRate? previous) {
    if (current == null || previous == null) return null;
    final diff = current.value - previous.value;
    if (diff == 0) return 'No change';
    return '${diff > 0 ? '+' : ''}$diff bpm';
  }

  String? _getTempChange(Temperature? current, Temperature? previous) {
    if (current == null || previous == null) return null;
    double currentVal = current.value;
    double previousVal = previous.value;
    // Convert to same unit if needed
    if (current.unit != previous.unit) {
      if (current.unit == 'F') {
        currentVal = (currentVal - 32) * 5 / 9;
      } else {
        previousVal = (previousVal - 32) * 5 / 9;
      }
    }
    final diff = currentVal - previousVal;
    if (diff == 0) return 'No change';
    return '${diff > 0 ? '+' : ''}${diff.toStringAsFixed(1)}°C';
  }

  String? _getRRChange(RespiratoryRate? current, RespiratoryRate? previous) {
    if (current == null || previous == null) return null;
    final diff = current.value - previous.value;
    if (diff == 0) return 'No change';
    return '${diff > 0 ? '+' : ''}$diff breaths/min';
  }

  String? _getSpO2Change(OxygenSaturation? current, OxygenSaturation? previous) {
    if (current == null || previous == null) return null;
    final diff = current.value - previous.value;
    if (diff == 0) return 'No change';
    return '${diff > 0 ? '+' : ''}$diff%';
  }

  String? _getPainChange(PainScore? current, PainScore? previous) {
    if (current?.value == null || previous?.value == null) return null;
    final diff = current!.value! - previous!.value!;
    if (diff == 0) return 'No change';
    return '${diff > 0 ? '+' : ''}$diff points';
  }

  Color _getChangeColor(String change) {
    if (change.contains('No change')) return Colors.grey;
    if (change.contains('+')) {
      // For most vitals, increase might be bad, but for SpO2 it's good
      if (change.contains('%') && change.contains('+')) return Colors.green;
      return Colors.red;
    }
    // Decrease might be good for BP, HR, Temp, Pain, but bad for SpO2
    if (change.contains('%')) return Colors.red;
    return Colors.green;
  }

  IconData _getChangeIcon(String change) {
    if (change.contains('No change')) return Icons.remove;
    if (change.contains('+')) return Icons.arrow_upward;
    return Icons.arrow_downward;
  }
}
