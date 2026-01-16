import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:schmgtsystem/models/patient_model.dart';
import 'package:schmgtsystem/models/vitals_model.dart';
import 'package:schmgtsystem/providers/patient_proviider.dart';
import 'package:schmgtsystem/services/api_service.dart';
import 'package:schmgtsystem/labtest_results.dart';

class DoctorPatinetDashboard extends StatefulWidget {
  DoctorPatinetDashboard({
    super.key,
    required this.onMedicalhisorySelected,
    // required this.goBack,
    required this.onMedicationsSelected,
    required this.onVitalHistorySelected,
    required this.onClinicalNotesSelected,
    required this.onImagingSelected,
  });
  // final Null Function() goBack;
  final Null Function(dynamic complaint) onMedicalhisorySelected;
  final Null Function(dynamic patient) onMedicationsSelected;
  Null Function(dynamic patient) onVitalHistorySelected;
  Null Function(dynamic patient) onClinicalNotesSelected;
  Null Function(dynamic patient) onImagingSelected;
  @override
  State<DoctorPatinetDashboard> createState() => _DoctorPatinetDashboardState();
}

Patient? patient;

class _DoctorPatinetDashboardState extends State<DoctorPatinetDashboard> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPatient();
  }

  getPatient() {
    patient =
        Provider.of<PatientProvider>(context, listen: false).currentPatient;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8FAFC), Color(0xFFF1F5F9)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                PatientHeader(),
                const SizedBox(height: 24),

                // Critical Alerts
                CriticalAlerts(),
                const SizedBox(height: 24),

                // Main Content Grid
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Column - Patient History & Vitals
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          ActiveProblemsCard(),
                          const SizedBox(height: 20),
                          MedicalHistoryCard(
                            onMedicalhisorySelected:
                                widget.onMedicalhisorySelected,
                          ),
                          const SizedBox(height: 20),
                          VitalsTimelineCard(
                            onVitalHistorySelected:
                                widget.onVitalHistorySelected,
                          ),
                          const SizedBox(height: 20),
                          ImagingCard(
                            onImagingSelected: widget.onImagingSelected,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),

                    // Right Column - Current Status & Actions
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          // Top Row - Current Status
                          Row(
                            children: [
                              Expanded(child: CurrentMedicationsCard()),
                              const SizedBox(width: 16),
                              Expanded(child: RecentVitalsCard()),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Medications Overview
                          MedicationsCard(
                            onMedicationsSelected: widget.onMedicationsSelected,
                          ),
                          const SizedBox(height: 20),

                          // Lab Results
                          LabResultsCard(),
                          const SizedBox(height: 20),

                          // Action Cards
                          Row(
                            children: [
                              Expanded(child: OrderLabTestCard()),
                              const SizedBox(width: 16),
                              Expanded(child: OrderImagingCard()),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Clinical Notes
                          ClinicalNotesCard(
                            onClinicalNotesSelected:
                                widget.onClinicalNotesSelected,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
                UpcomingAppointmentsCard(),

                // Footer
                const SizedBox(height: 16),
                Footer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PatientHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.3),
            blurRadius: 32,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.2),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.15),
              Colors.white.withOpacity(0.05),
            ],
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Text(
                patient?.name.isNotEmpty == true
                    ? patient!.name[0].toUpperCase()
                    : '?',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patient?.name ?? 'Patient Name',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'ID: ${patient?.id ?? 'N/A'} • ${patient?.gender ?? 'Unknown'}, ${patient?.age ?? 'N/A'} • Blood Type: O+',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Wrap(
              spacing: 8,
              children: [
                _buildTag('Penicillin Allergy', const Color(0xFFFF6B6B)),
                _buildTag('Follow-up Visit', Colors.green),
                _buildTag('Outpatient', Colors.blue),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class CriticalAlerts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[600],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.warning, color: Colors.white, size: 24),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Critical Alerts',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Blood pressure elevated - Last reading 142/88 mmHg • HbA1c overdue (last: 6 months ago)',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ActiveProblemsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildCard(
      title: 'Active Problems',
      accentColor: const Color(0xFFEF4444),
      goto: () {},
      child: Column(
        children: [
          _buildProblemItem('Hypertension (I10)', Colors.red[100]!),
          _buildProblemItem('Type 2 Diabetes (E11.9)', Colors.orange[100]!),
          _buildProblemItem('Hyperlipidemia (E78.5)', Colors.yellow[100]!),
        ],
      ),
    );
  }

  Widget _buildProblemItem(String text, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CurrentMedicationsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildCard(
      title: 'Current Medications',
      goto: () {},

      child: Column(
        children: [
          _buildMedicationItem('Lisinopril', '10mg daily'),
          _buildMedicationItem('Metformin', '500mg BID'),
          _buildMedicationItem('Atorvastatin', '20mg daily'),
          SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget _buildMedicationItem(String name, String dosage) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[800],
            ),
          ),
          Text(dosage, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        ],
      ),
    );
  }
}

class RecentVitalsCard extends StatefulWidget {
  @override
  State<RecentVitalsCard> createState() => _RecentVitalsCardState();
}

class _RecentVitalsCardState extends State<RecentVitalsCard> {
  VitalsRecord? _latestVitals;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLatestVitals();
  }

  Future<void> _loadLatestVitals() async {
    final patientProvider = Provider.of<PatientProvider>(
      context,
      listen: false,
    );
    final currentPatient = patientProvider.currentPatient;

    if (currentPatient?.id == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await ApiService.getPatientVitalsHistory(
        currentPatient!.id!,
        page: 1,
        limit: 1,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
          if (response.success && response.data != null) {
            // The response structure is: {success: true, data: {vitals: [...], pagination: {...}}, message: "..."}
            // So we need to access response.data['data']['vitals']
            if (response.data is Map<String, dynamic>) {
              final responseData = response.data as Map<String, dynamic>;

              // Check if response.data has 'data' key (which contains vitals)
              if (responseData.containsKey('data')) {
                final innerData = responseData['data'] as Map<String, dynamic>?;
                if (innerData != null) {
                  final dynamic vitalsList = innerData['vitals'];
                  if (vitalsList is List && vitalsList.isNotEmpty) {
                    _latestVitals = VitalsRecord.fromJson(
                      vitalsList[0] as Map<String, dynamic>,
                    );
                  }
                }
              } else {
                // Fallback: check if vitals is directly in response.data
                final dynamic vitalsList = responseData['vitals'];
                if (vitalsList is List && vitalsList.isNotEmpty) {
                  _latestVitals = VitalsRecord.fromJson(
                    vitalsList[0] as Map<String, dynamic>,
                  );
                }
              }
            }
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildCard(
      title: 'Recent Vitals',
      goto: () {},

      child:
          _isLoading
              ? Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                ),
              )
              : _latestVitals == null
              ? Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'No vitals recorded',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ),
              )
              : Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildVitalItem(
                        _latestVitals!.vitalSigns.bloodPressure?.displayValue ??
                            'N/A',
                        'BP (mmHg)',
                        _getBPColor(_latestVitals!.vitalSigns.bloodPressure),
                      ),
                      _buildVitalItem(
                        _latestVitals!.vitalSigns.heartRate?.value.toString() ??
                            'N/A',
                        'HR (bpm)',
                        _getHRColor(_latestVitals!.vitalSigns.heartRate),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildVitalItem(
                        _latestVitals!.vitalSigns.temperature?.displayValue ??
                            'N/A',
                        'Temp',
                        Colors.blue,
                      ),
                      _buildVitalItem(
                        _latestVitals!.vitalSigns.oxygenSaturation?.value
                                .toString() ??
                            'N/A',
                        'SpO₂',
                        _getSpO2Color(
                          _latestVitals!.vitalSigns.oxygenSaturation,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                ],
              ),
    );
  }

  Color _getBPColor(BloodPressure? bp) {
    if (bp == null || bp.systolic == null) return Colors.grey;
    if (bp.systolic! >= 140 || (bp.diastolic != null && bp.diastolic! >= 90)) {
      return Colors.red;
    } else if (bp.systolic! >= 120 ||
        (bp.diastolic != null && bp.diastolic! >= 80)) {
      return Colors.orange;
    }
    return Colors.green;
  }

  Color _getHRColor(HeartRate? hr) {
    if (hr == null) return Colors.grey;
    if (hr.value < 60 || hr.value > 100) {
      return Colors.orange;
    }
    return Colors.green;
  }

  Color _getSpO2Color(OxygenSaturation? spo2) {
    if (spo2 == null) return Colors.grey;
    if (spo2.value < 95) {
      return Colors.red;
    } else if (spo2.value < 98) {
      return Colors.orange;
    }
    return Colors.green;
  }

  Widget _buildVitalItem(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }
}

class MedicalHistoryCard extends StatelessWidget {
  MedicalHistoryCard({super.key, required this.onMedicalhisorySelected});

  Null Function(dynamic complaint) onMedicalhisorySelected;

  @override
  Widget build(BuildContext context) {
    return _buildCard(
      title: 'Medical History',
      actionText: 'View Full History',
      accentColor: const Color(0xFF8B5CF6),
      goto: () {
        // Ensure we have a patient - use global patient or get from provider
        final currentPatient =
            patient ??
            Provider.of<PatientProvider>(context, listen: false).currentPatient;
        onMedicalhisorySelected(currentPatient);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHistoryItem(
            'Past Medical:',
            'Hypertension (2018), Type 2 DM (2020)',
          ),
          _buildHistoryItem('Surgical:', 'Appendectomy (2015)'),
          _buildHistoryItem('Family:', 'Father - CAD, Mother - DM'),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(String label, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 14, color: Colors.grey[800]),
          children: [
            TextSpan(
              text: label,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            TextSpan(text: ' $text'),
          ],
        ),
      ),
    );
  }
}

class MedicationsCard extends StatelessWidget {
  MedicationsCard({super.key, required this.onMedicationsSelected});
  final Null Function(dynamic patient) onMedicationsSelected;
  @override
  Widget build(BuildContext context) {
    return _buildCard(
      title: 'Medications',
      actionText: 'View Full Medications',
      goto: () {
        onMedicationsSelected(patient);
      },

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Active: 3 medications',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Last updated: Today, 2:30 PM',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'All compliant',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green[800],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class VitalsTimelineCard extends StatefulWidget {
  VitalsTimelineCard({super.key, required this.onVitalHistorySelected});
  final Null Function(dynamic patient) onVitalHistorySelected;

  @override
  State<VitalsTimelineCard> createState() => _VitalsTimelineCardState();
}

class _VitalsTimelineCardState extends State<VitalsTimelineCard> {
  List<VitalsRecord> _recentVitals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecentVitals();
  }

  Future<void> _loadRecentVitals() async {
    final patientProvider = Provider.of<PatientProvider>(
      context,
      listen: false,
    );
    final currentPatient = patientProvider.currentPatient;

    if (currentPatient?.id == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await ApiService.getPatientVitalsHistory(
        currentPatient!.id!,
        page: 1,
        limit: 3, // Get last 3 readings for trend analysis
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
          if (response.success && response.data != null) {
            // The response structure is: {success: true, data: {vitals: [...], pagination: {...}}, message: "..."}
            // So we need to access response.data['data']['vitals']
            if (response.data is Map<String, dynamic>) {
              final responseData = response.data as Map<String, dynamic>;

              // Check if response.data has 'data' key (which contains vitals)
              if (responseData.containsKey('data')) {
                final innerData = responseData['data'] as Map<String, dynamic>?;
                if (innerData != null) {
                  final dynamic vitalsList = innerData['vitals'];
                  if (vitalsList is List) {
                    _recentVitals =
                        vitalsList
                            .map(
                              (v) => VitalsRecord.fromJson(
                                v as Map<String, dynamic>,
                              ),
                            )
                            .toList();
                  }
                }
              } else {
                // Fallback: check if vitals is directly in response.data
                final dynamic vitalsList = responseData['vitals'];
                if (vitalsList is List) {
                  _recentVitals =
                      vitalsList
                          .map(
                            (v) => VitalsRecord.fromJson(
                              v as Map<String, dynamic>,
                            ),
                          )
                          .toList();
                }
              }
            }
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _getBPTrend() {
    if (_recentVitals.length < 2) return 'Insufficient data';

    final bpReadings =
        _recentVitals
            .where((v) => v.vitalSigns.bloodPressure?.systolic != null)
            .map((v) => v.vitalSigns.bloodPressure!.systolic!)
            .toList();

    if (bpReadings.length < 2) return 'Insufficient data';

    // Compare first and last reading
    final first = bpReadings.last; // Oldest (last in list since sorted desc)
    final last = bpReadings.first; // Most recent (first in list)

    if (last > first + 5) return '↑ Increasing';
    if (last < first - 5) return '↓ Decreasing';
    return '→ Stable';
  }

  Color _getBPTrendColor() {
    final trend = _getBPTrend();
    if (trend.contains('↑')) return Colors.red;
    if (trend.contains('↓')) return Colors.green;
    return Colors.blue;
  }

  String _getBPTrendDescription() {
    if (_recentVitals.isEmpty) return 'No vitals recorded';
    if (_recentVitals.length < 3) return 'Insufficient readings for trend';

    final aboveTarget =
        _recentVitals.where((v) {
          final bp = v.vitalSigns.bloodPressure;
          return bp != null &&
              bp.systolic != null &&
              (bp.systolic! >= 140 ||
                  (bp.diastolic != null && bp.diastolic! >= 90));
        }).length;

    if (aboveTarget >= 3) return 'Last 3 readings above target';
    if (aboveTarget > 0)
      return '$aboveTarget of last ${_recentVitals.length} readings above target';
    return 'All readings within target';
  }

  @override
  Widget build(BuildContext context) {
    return _buildCard(
      title: 'Vitals Timeline',
      actionText: 'View Full Vitals History',
      accentColor: const Color(0xFF06B6D4),
      goto: () {
        // Navigate to patient vitals history screen using normal routing
        final currentPatient =
            patient ??
            Provider.of<PatientProvider>(context, listen: false).currentPatient;
        if (currentPatient != null) {
          context.push(
            '/patient-management/patient-vitals/history',
            extra: currentPatient,
          );
        } else {
          context.push('/patient-management/patient-vitals/history');
        }
      },

      child:
          _isLoading
              ? Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                ),
              )
              : _recentVitals.isEmpty
              ? Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'No vitals recorded',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ),
              )
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                      children: [
                        TextSpan(
                          text: 'BP Trend: ',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        TextSpan(
                          text: _getBPTrend(),
                          style: TextStyle(color: _getBPTrendColor()),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    _getBPTrendDescription(),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
    );
  }
}

class LabResultsCard extends StatelessWidget {
  LabResultsCard({super.key});
  @override
  Widget build(BuildContext context) {
    return _buildCard(
      title: 'Lab Results',
      actionText: 'View Full Lab Results',
      accentColor: const Color(0xFF84CC16),
      goto: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (context) => MedicalLabResultsScreen(
                  goBack: () {
                    Navigator.of(context).pop();
                    return null;
                  },
                  patientId: patient?.id,
                  patientName: patient?.name,
                  patientMrn: patient?.mrn,
                ),
          ),
        );
      },

      child: Column(
        children: [
          _buildLabItem('HbA1c', '7.2%', '↑', Colors.red),
          _buildLabItem('LDL Cholesterol', '145 mg/dL', '↑', Colors.red),
          SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Last drawn: 2 weeks ago',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabItem(String test, String value, String trend, Color color) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            test,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[800],
            ),
          ),
          Row(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 4),
              Text(
                trend,
                style: TextStyle(
                  fontSize: 14,
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ImagingCard extends StatelessWidget {
  ImagingCard({super.key, required this.onImagingSelected});
  Null Function(dynamic patient) onImagingSelected;
  @override
  Widget build(BuildContext context) {
    return _buildCard(
      title: 'Imaging',
      actionText: 'View All Imaging',
      goto: () {
        onImagingSelected(patient);
      },

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.medical_services, size: 16, color: Colors.blue),
              SizedBox(width: 8),
              Text(
                'Chest X-ray - Normal (3 months ago)',
                style: TextStyle(fontSize: 14, color: Colors.grey[800]),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.favorite, size: 16, color: Colors.red),
              SizedBox(width: 8),
              Text(
                'EKG - Normal sinus rhythm (6 months ago)',
                style: TextStyle(fontSize: 14, color: Colors.grey[800]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class OrderLabTestCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildCard(
      title: 'Lab Test Orders',
      actionText: 'Order Lab Test',
      accentColor: const Color(0xFFF59E0B),
      goto: () {
        // Navigate to lab test ordering screen
        final currentPatient =
            patient ??
            Provider.of<PatientProvider>(context, listen: false).currentPatient;
        if (currentPatient != null) {
          context.push('/doctors/order-lab-test', extra: currentPatient);
        } else {
          context.push('/doctors/order-lab-test');
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6366F1).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.science, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Request Lab Tests',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Order diagnostic tests for patient',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
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

class OrderImagingCard extends StatefulWidget {
  @override
  State<OrderImagingCard> createState() => _OrderImagingCardState();
}

class _OrderImagingCardState extends State<OrderImagingCard> {
  int? pendingCount;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPendingCount();
  }

  Future<void> _loadPendingCount() async {
    setState(() => isLoading = true);

    try {
      final response = await ApiService.get(
        '/api/v1/imaging-orders/count/pending',
      );

      if (response.success && response.data != null) {
        final data = response.data['data'] as Map<String, dynamic>;
        setState(() {
          pendingCount = data['count'] as int?;
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildCard(
      title: 'Imaging Orders',
      actionText: 'Order Imaging',
      accentColor: const Color(0xFF10B981),
      goto: () {
        // Navigate to imaging ordering screen
        final currentPatient =
            patient ??
            Provider.of<PatientProvider>(context, listen: false).currentPatient;
        if (currentPatient != null) {
          context.push('/doctors/order-imaging', extra: currentPatient);
        } else {
          context.push('/doctors/order-imaging');
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF10B981), Color(0xFF059669)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF10B981).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.medical_services,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Schedule patient imaging',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                        if (pendingCount != null && pendingCount! > 0) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '$pendingCount pending',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFF59E0B),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Order X-rays, CT scans, MRIs, and ultrasounds',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
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

class ClinicalNotesCard extends StatelessWidget {
  ClinicalNotesCard({super.key, required this.onClinicalNotesSelected});
  Null Function(dynamic patient) onClinicalNotesSelected;

  @override
  Widget build(BuildContext context) {
    return _buildCard(
      title: 'Clinical Notes',
      actionText: 'View Full Notes',
      accentColor: const Color(0xFFF97316),
      goto: () {
        // Navigate to clinical notes screen using normal routing
        final currentPatient =
            patient ??
            Provider.of<PatientProvider>(context, listen: false).currentPatient;
        if (currentPatient != null) {
          context.push('/doctors/clinical-notes', extra: currentPatient);
        } else {
          context.push('/doctors/clinical-notes');
        }
      },

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Last Visit (1 week ago):',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Patient reports good medication compliance. BP remains elevated despite current therapy. Discussed lifestyle modifications...',
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
          SizedBox(height: 8),
          Text(
            'Dr. Martinez - Internal Medicine',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

class UpcomingAppointmentsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildCard(
      title: 'Upcoming Appointments & Procedures',
      goto: () {},

      child: Column(
        children: [
          _buildAppointmentItem(
            'Cardiology Consultation',
            'Dr. Chen - March 15, 2024 at 2:00 PM',
            Colors.blue,
          ),
          SizedBox(height: 12),
          _buildAppointmentItem(
            'Lab Draw - HbA1c, Lipid Panel',
            'March 20, 2024 at 8:00 AM',
            Colors.green,
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.add, size: 16),
                label: Text('New Encounter'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: BeveledRectangleBorder(),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
              SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.science, size: 16),
                label: Text('Order Lab'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 57, 22, 231),
                  shape: BeveledRectangleBorder(),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.favorite, size: 16),
                label: Text('Record Vitals'),
                style: ElevatedButton.styleFrom(
                  shape: BeveledRectangleBorder(),
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
              SizedBox(width: 8),

              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.medication, size: 16),
                label: Text('Prescribe'),
                style: ElevatedButton.styleFrom(
                  shape: BeveledRectangleBorder(),
                  backgroundColor: const Color.fromARGB(255, 0, 164, 123),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: Text('Print Summary'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[700],
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentItem(String title, String details, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border(left: BorderSide(width: 4, color: color)),
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_today, size: 16, color: color),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                Text(
                  details,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Last updated: Today, 3:45 PM by Dr. Martinez',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          Text(
            'EMR System v2.1 | Patient Privacy Protected',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}

Widget _buildCard({
  required String title,
  String? actionText,
  required Widget child,
  required Null Function() goto,
  Color? accentColor,
}) {
  final Color cardAccentColor = accentColor ?? const Color(0xFF6366F1);

  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
      border: Border.all(color: Colors.grey.withOpacity(0.08), width: 1),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.grey.withOpacity(0.02)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with accent bar
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.topRight,
                  colors: [
                    cardAccentColor.withOpacity(0.08),
                    cardAccentColor.withOpacity(0.04),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 20,
                        decoration: BoxDecoration(
                          color: cardAccentColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1E293B),
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  if (actionText != null)
                    GestureDetector(
                      onTap: goto,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: cardAccentColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: cardAccentColor.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              actionText,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: cardAccentColor,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward,
                              size: 14,
                              color: cardAccentColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Content
            Padding(padding: const EdgeInsets.all(20), child: child),
          ],
        ),
      ),
    ),
  );
}
