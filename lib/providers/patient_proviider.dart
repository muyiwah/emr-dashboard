// providers/patient_provider.dart
import 'package:flutter/material.dart';
import '../models/patient_model.dart';
import '../services/api_service.dart';

class PatientProvider with ChangeNotifier {
  List<Medication> _medications = [];

  List<Medication> get medications =>
      _medications.where((m) => m.patientId == currentPatient?.id).toList();

  void addMedication(Medication medication) {
    _medications.add(medication);
    notifyListeners();
  }

  void updateMedication(String id, Medication updatedMedication) {
    final index = _medications.indexWhere((m) => m.id == id);
    if (index != -1) {
      _medications[index] = updatedMedication;
      notifyListeners();
    }
  }

  void removeMedication(String id) {
    _medications.removeWhere((m) => m.id == id);
    notifyListeners();
  }

  // Initialize with some demo data
  void initializeDemoMedications(String patientId) {
    _medications = [
      Medication(
        id: 'med1',
        patientId: patientId,
        name: 'Lisinopril',
        dosage: '10mg tablet',
        frequency: 'Once daily',
        duration: 'Ongoing',
        prescribedBy: 'Dr. Michael Chen',
        startDate: DateTime(2024, 1, 15),
        status: 'Active',
        additionalInfo: 'Recent BP: 128/82 mmHg',
        targetInfo: 'Target: <140/90',
        showMonitorBP: true,
      ),
      Medication(
        id: 'med2',
        patientId: patientId,
        name: 'Metformin',
        dosage: '500mg tablet',
        frequency: 'Twice daily with meals',
        duration: 'Ongoing',
        prescribedBy: 'Dr. Sarah Williams',
        startDate: DateTime(2023, 12, 8),
        status: 'Active',
        additionalInfo: 'Recent HbA1c: 6.8%',
        targetInfo: 'Target: <7.0%',
      ),
      Medication(
        id: 'med3',
        patientId: patientId,
        name: 'Amoxicillin',
        dosage: '500mg capsule',
        frequency: '3 times daily',
        duration: '7 days',
        prescribedBy: 'Dr. Michael Chen',
        startDate: DateTime(2024, 5, 20),
        endDate: DateTime(2024, 5, 27),
        status: 'Completed',
      ),
    ];
  }

  // API State Management
  bool _isLoading = false;
  String? _error;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<Patient> _patients = [];
  List<Patient> _queue = [];

  List<Patient> get patients => _patients;
  List<Patient> get queue => _queue;

  void addPatient(Patient patient) {
    _patients.add(patient);
    _queue.add(patient); // Add to end of queue
    notifyListeners();
  }

  /// Register a new patient via API
  /// All API calls go through state management
  Future<ApiResponse> registerPatient(Map<String, dynamic> patientData) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.createPatient(patientData);

      _isLoading = false;

      if (response.success) {
        // Optionally add the patient to local list if API returns patient data
        if (response.data != null) {
          // You can parse the response and add to local list if needed
          // For now, we'll just notify listeners
        }
        _error = null;
        notifyListeners();
        return response;
      } else {
        _error = response.error ?? 'Failed to register patient';
        notifyListeners();
        return response;
      }
    } catch (e) {
      _isLoading = false;
      _error = 'Error registering patient: $e';
      notifyListeners();
      return ApiResponse(success: false, statusCode: 0, error: _error);
    }
  }

  /// Fetch all patients from API
  Future<ApiResponse> fetchPatients() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.getPatients();

      _isLoading = false;

      if (response.success && response.data != null) {
        // Expected structure:
        // {
        //   "success": true,
        //   "data": { "patients": [ ... ], "pagination": { ... } },
        //   ...
        // }
        final dynamic root = response.data;
        final dynamic data = root is Map<String, dynamic> ? root['data'] : null;
        final dynamic patientsJson =
            data is Map<String, dynamic> ? data['patients'] : null;

        if (patientsJson is List) {
          final fetchedPatients =
              patientsJson
                  .whereType<Map<String, dynamic>>()
                  .map((p) => Patient.fromApi(p))
                  .toList();

          _patients = fetchedPatients;
          _queue = List<Patient>.from(fetchedPatients);
        }

        _error = null;
        notifyListeners();
        return response;
      } else {
        _error = response.error ?? 'Failed to fetch patients';
        notifyListeners();
        return response;
      }
    } catch (e) {
      _isLoading = false;
      _error = 'Error fetching patients: $e';
      notifyListeners();
      return ApiResponse(success: false, statusCode: 0, error: _error);
    }
  }

  /// Get a specific patient by ID from API
  Future<ApiResponse> fetchPatient(String patientId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.getPatient(patientId);

      _isLoading = false;

      if (response.success) {
        _error = null;
        notifyListeners();
        return response;
      } else {
        _error = response.error ?? 'Failed to fetch patient';
        notifyListeners();
        return response;
      }
    } catch (e) {
      _isLoading = false;
      _error = 'Error fetching patient: $e';
      notifyListeners();
      return ApiResponse(success: false, statusCode: 0, error: _error);
    }
  }

  /// Update a patient via API
  Future<ApiResponse> updatePatientViaApi(
    String patientId,
    Map<String, dynamic> patientData,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.updatePatient(patientId, patientData);

      _isLoading = false;

      if (response.success) {
        _error = null;
        notifyListeners();
        return response;
      } else {
        _error = response.error ?? 'Failed to update patient';
        notifyListeners();
        return response;
      }
    } catch (e) {
      _isLoading = false;
      _error = 'Error updating patient: $e';
      notifyListeners();
      return ApiResponse(success: false, statusCode: 0, error: _error);
    }
  }

  /// Delete a patient via API
  Future<ApiResponse> deletePatientViaApi(String patientId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.deletePatient(patientId);

      _isLoading = false;

      if (response.success) {
        // Remove from local list
        _patients.removeWhere((p) => p.id == patientId);
        _queue.removeWhere((p) => p.id == patientId);
        _error = null;
        notifyListeners();
        return response;
      } else {
        _error = response.error ?? 'Failed to delete patient';
        notifyListeners();
        return response;
      }
    } catch (e) {
      _isLoading = false;
      _error = 'Error deleting patient: $e';
      notifyListeners();
      return ApiResponse(success: false, statusCode: 0, error: _error);
    }
  }

  /// Clear error state
  void clearError() {
    _error = null;
    notifyListeners();
  }

  void removeFromQueue(String patientId) {
    _queue.removeWhere((patient) => patient.id == patientId);
    notifyListeners();
  }

  void reorderQueue(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final patient = _queue.removeAt(oldIndex);
    _queue.insert(newIndex, patient);
    notifyListeners();
  }

  void updatePatientStatus(String patientId, String newStatus) {
    final index = _patients.indexWhere((p) => p.id == patientId);
    if (index != -1) {
      final patient = _patients[index];
      if (newStatus == 'Completed') {
        // Store the final waiting time
        final waitDuration = DateTime.now().difference(
          patient.registrationTime,
        );
        _patients[index] = patient.copyWith(
          status: newStatus,
          waitTime: waitDuration, // Add this field to your model if needed
        );
      } else {
        _patients[index] = patient.copyWith(
          status: newStatus,
          waitTime: Duration(seconds: 40),
        );
      }
      notifyListeners();
    }
  }

  void reorderQueue2(
    String patientId,
    int oldIndex,
    int newIndex,
    String department,
  ) {
    if (oldIndex < newIndex) newIndex -= 1;
    final patient = _patients.firstWhere((p) => p.id == patientId);
    _patients.remove(patient);
    _patients.insert(newIndex, patient);
    notifyListeners();
  }

  void markAsCompleted(String patientId) {
    _patients.removeWhere((p) => p.id == patientId);
    notifyListeners();
  }

  List<Patient> getPatientsByDepartment(String department) {
    return _patients.where((p) => p.department == department).toList();
  }

  void reorderPatient(String department, int oldIndex, int newIndex) {
    final departmentPatients = getPatientsByDepartment(department);
    if (oldIndex < newIndex) newIndex -= 1;

    final patient = departmentPatients[oldIndex];
    _patients.remove(patient);
    _patients.insert(newIndex, patient);

    notifyListeners();
  }

  void updateDoctor(String patientId, String newDoctor) {
    final index = _patients.indexWhere((p) => p.id == patientId);
    if (index != -1) {
      _patients[index] = _patients[index].copyWith(doctor: newDoctor);
      notifyListeners();
    }
  }

  void updateDepartment(String patientId, String newDepartment) {
    final index = _patients.indexWhere((p) => p.id == patientId);
    if (index != -1) {
      _patients[index] = _patients[index].copyWith(department: newDepartment);
      notifyListeners();
    }
  }

  Future<void> refreshPatients() async {
    await fetchPatients();
  }

  /* ========== New HPI Methods ========== */
  // New HPI Records Storage
  List<HpiRecord> _hpiRecords = [];

  // Get HPI records for a specific patient
  List<HpiRecord> getHpiRecordsForPatient(String patientId) {
    return _hpiRecords
        .where((record) => record.patientId == patientId)
        .toList();
  }

  // Add a new HPI record
  void addHpiRecord(HpiRecord record) {
    _hpiRecords.add(record);
    notifyListeners();
    // Here you would typically sync with your backend
  }

  // Update an existing HPI record
  void updateHpiRecord(String recordId, HpiRecord updatedRecord) {
    final index = _hpiRecords.indexWhere((r) => r.id == recordId);
    if (index != -1) {
      _hpiRecords[index] = updatedRecord;
      notifyListeners();
    }
  }

  // Delete an HPI record
  void deleteHpiRecord(String recordId) {
    _hpiRecords.removeWhere((r) => r.id == recordId);
    notifyListeners();
  }

  // Get the most recent HPI for a patient
  HpiRecord? getLatestHpiRecord(String patientId) {
    final patientRecords = getHpiRecordsForPatient(patientId);
    if (patientRecords.isEmpty) return null;

    patientRecords.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return patientRecords.first;
  }

  // Create a new HPI record from current patient data
  HpiRecord createNewHpiTemplate(String patientId, String providerId) {
    final patient = _patients.firstWhere((p) => p.id == patientId);

    return HpiRecord(
      id: 'hpi-${DateTime.now().millisecondsSinceEpoch}',
      patientId: patientId,
      providerId: providerId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      chiefComplaint: '',
      symptomDescription: '${patient.name} presents with...',
      symptomOnset: DateTime.now(),
      duration: 1,
      durationUnit: 'Days',
      progressionType: 'Gradual',
      severityScale: 5.0,
      aggravatingFactors: '',
      relievingFactors: '',
      associatedSymptoms: {},
      additionalNotes: 'Seen in ${patient.department} department',
    );
  }

  /* ========== Combined Patient + HPI Methods ========== */

  // Get patient with their HPI records
  PatientWithHpi getPatientWithHpi(String patientId) {
    final patient = _patients.firstWhere((p) => p.id == patientId);
    final hpiRecords = getHpiRecordsForPatient(patientId);
    return PatientWithHpi(patient: patient, hpiRecords: hpiRecords);
  }

  // Delete patient and their associated HPI records
  void deletePatientAndRecords(String patientId) {
    _patients.removeWhere((p) => p.id == patientId);
    _hpiRecords.removeWhere((r) => r.patientId == patientId);
    notifyListeners();
  }

  // Add this to your existing PatientProvider class

  /* ========== Navigation State Management ========== */
  Patient? _currentPatient;
  String? _currentChiefComplaint;

  // Set the current patient being processed
  void setCurrentPatient(Patient patient) {
    _currentPatient = patient;
    notifyListeners();
  }

  // Get the current patient
  Patient? get currentPatient => _currentPatient;

  // Set the chief complaint for the current patient
  void setChiefComplaint(String complaint) {
    _currentChiefComplaint = complaint;
    notifyListeners();

    // If we have a current patient, create an initial HPI record
    if (_currentPatient != null) {
      final initialHpi = HpiRecord(
        id: 'hpi-${DateTime.now().millisecondsSinceEpoch}',
        patientId: _currentPatient!.id,
        providerId: 'current-provider-id', // Replace with actual provider ID
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        chiefComplaint: _currentChiefComplaint!,
        symptomDescription: '',
        symptomOnset: DateTime.now(),
        duration: 1,
        durationUnit: 'Days',
        progressionType: 'Gradual',
        severityScale: 5.0,
        aggravatingFactors: '',
        relievingFactors: '',
        associatedSymptoms: {},
        additionalNotes: '',
      );
      print(initialHpi.toJson());
      addHpiRecord(initialHpi);
    }
  }

  // Get the current chief complaint
  String? get currentChiefComplaint => _currentChiefComplaint;

  // Clear navigation state
  void clearNavigationState() {
    _currentPatient = null;
    _currentChiefComplaint = null;
    notifyListeners();
  }
}

// Helper class to combine patient with their HPI records
class PatientWithHpi {
  final Patient patient;
  final List<HpiRecord> hpiRecords;

  PatientWithHpi({required this.patient, required this.hpiRecords});
}
