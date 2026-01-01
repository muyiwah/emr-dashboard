// providers/patient_provider.dart
import 'package:flutter/material.dart';
import '../models/patient_model.dart';

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




  List<Patient> _patients = [
    Patient(
      id: 'P001',
      name: 'James Thomp',
      mrn: 'MRN001',
      age: 62,
      gender: 'Male',
      contact: '555-0101',
      department: 'Outpatient',
      doctor: 'Dr. Smith',
      isEmergency: false,
      registrationTime: DateTime.now().subtract(Duration(minutes: 12)),
      status: 'waiting',
      complaint: 'Annual physical examination',
      urgency: 'Low Urgency',
      urgencyColor: Color(0xFF10B981),
      room: 'Room 105',
      avatar: 'assets/james_avatar.png',
    ),
    Patient(
      id: 'P002',
      name: 'Sarah John',
      mrn: 'MRN002',
      age: 45,
      gender: 'Female',
      contact: '555-0102',
      department: 'Cardiology',
      doctor: 'Dr. Williams',
      isEmergency: true,
      registrationTime: DateTime.now().subtract(Duration(minutes: 5)),
      status: 'In Consultation',
      complaint: 'Chest pain and shortness of breath',
      urgency: 'High Urgency',
      urgencyColor: Colors.red,
      room: 'Room 201',
      avatar: 'assets/sarah_avatar.png',
    ),
    Patient(
      id: 'P003',
      name: 'Michael Chen',
      mrn: 'MRN003',
      age: 38,
      gender: 'Male',
      contact: '555-0103',
      department: 'Orthopedics',
      doctor: 'Dr. Brown',
      isEmergency: false,
      registrationTime: DateTime.now().subtract(Duration(minutes: 25)),
      status: 'waiting',
      complaint: 'Knee pain after fall',
      urgency: 'Medium Urgency',
      urgencyColor: Colors.orange,
      room: 'Room 302',
      avatar: 'assets/michael_avatar.png',
    ),
    Patient(
      id: 'P004',
      name: 'Emily Rod',
      mrn: 'MRN004',
      age: 29,
      gender: 'Female',
      contact: '555-0104',
      department: 'Pediatrics',
      doctor: 'Dr. Johnson',
      isEmergency: false,
      registrationTime: DateTime.now().subtract(Duration(minutes: 18)),
      status: 'waiting',
      complaint: 'Child with fever and rash',
      urgency: 'Medium Urgency',
      urgencyColor: Colors.orange,
      room: 'Room 405',
      avatar: 'assets/emily_avatar.png',
    ),
    Patient(
      id: 'P005',
      name: 'Robert Wilson',
      mrn: 'MRN005',
      age: 55,
      gender: 'Male',
      contact: '555-0105',
      department: 'Neurology',
      doctor: 'Dr. Adams',
      isEmergency: true,
      registrationTime: DateTime.now().subtract(Duration(minutes: 8)),
      status: 'In Consultation',
      complaint: 'Severe headache and dizziness',
      urgency: 'High Urgency',
      urgencyColor: Colors.red,
      room: 'Room 106',
      avatar: 'assets/robert_avatar.png',
    ),
    Patient(
      id: 'P006',
      name: 'Jennifer Lee',
      mrn: 'MRN006',
      age: 42,
      gender: 'Female',
      contact: '555-0106',
      department: 'General Medicine',
      doctor: 'Dr. Smith',
      isEmergency: false,
      registrationTime: DateTime.now().subtract(Duration(minutes: 35)),
      status: 'waiting',
      complaint: 'Follow-up for diabetes management',
      urgency: 'Low Urgency',
      urgencyColor: Color(0xFF10B981),
      room: 'Room 207',
      avatar: 'assets/jennifer_avatar.png',
    ),
    Patient(
      id: 'P007',
      name: 'David Kim',
      mrn: 'MRN007',
      age: 50,
      gender: 'Male',
      contact: '555-0107',
      department: 'ENT',
      doctor: 'Dr. Miller',
      isEmergency: false,
      registrationTime: DateTime.now().subtract(Duration(minutes: 22)),
      status: 'waiting',
      complaint: 'Ear pain and hearing loss',
      urgency: 'Medium Urgency',
      urgencyColor: Colors.orange,
      room: 'Room 303',
      avatar: 'assets/david_avatar.png',
    ),
    Patient(
      id: 'P008',
      name: 'Lisa Wong',
      mrn: 'MRN008',
      age: 33,
      gender: 'Female',
      contact: '555-0108',
      department: 'Obstetrics',
      doctor: 'Dr. Taylor',
      isEmergency: false,
      registrationTime: DateTime.now().subtract(Duration(minutes: 15)),
      status: 'waiting',
      complaint: 'Prenatal checkup',
      urgency: 'Low Urgency',
      urgencyColor: Color(0xFF10B981),
      room: 'Room 408',
      avatar: 'assets/lisa_avatar.png',
    ),
    Patient(
      id: 'P009',
      name: 'Daniel Garcia',
      mrn: 'MRN009',
      age: 47,
      gender: 'Male',
      contact: '555-0109',
      department: 'Cardiology',
      doctor: 'Dr. Williams',
      isEmergency: true,
      registrationTime: DateTime.now().subtract(Duration(minutes: 7)),
      status: 'In Consultation',
      complaint: 'Irregular heartbeat',
      urgency: 'High Urgency',
      urgencyColor: Colors.red,
      room: 'Room 202',
      avatar: 'assets/daniel_avatar.png',
    ),
    Patient(
      id: 'P010',
      name: 'Amanda Scott',
      mrn: 'MRN010',
      age: 31,
      gender: 'Female',
      contact: '555-0110',
      department: 'Dermatology',
      doctor: 'Dr. Clark',
      isEmergency: false,
      registrationTime: DateTime.now().subtract(Duration(minutes: 28)),
      status: 'waiting',
      complaint: 'Skin rash evaluation',
      urgency: 'Low Urgency',
      urgencyColor: Color(0xFF10B981),
      room: 'Room 504',
      avatar: 'assets/amanda_avatar.png',
    ),
    Patient(
      id: 'P011',
      name: 'Kevin Patel',
      mrn: 'MRN011',
      age: 58,
      gender: 'Male',
      contact: '555-0111',
      department: 'Oncology',
      doctor: 'Dr. Lewis',
      isEmergency: false,
      registrationTime: DateTime.now().subtract(Duration(minutes: 40)),
      status: 'waiting',
      complaint: 'Chemotherapy follow-up',
      urgency: 'Medium Urgency',
      urgencyColor: Colors.orange,
      room: 'Room 601',
      avatar: 'assets/kevin_avatar.png',
    ),
    Patient(
      id: 'P012',
      name: 'Michelle Brown',
      mrn: 'MRN012',
      age: 26,
      gender: 'Female',
      contact: '555-0112',
      department: 'Pediatrics',
      doctor: 'Dr. Johnson',
      isEmergency: false,
      registrationTime: DateTime.now().subtract(Duration(minutes: 19)),
      status: 'waiting',
      complaint: 'Child vaccination',
      urgency: 'Low Urgency',
      urgencyColor: Color(0xFF10B981),
      room: 'Room 406',
      avatar: 'assets/michelle_avatar.png',
    ),
    Patient(
      id: 'P013',
      name: 'Richard Davis',
      mrn: 'MRN013',
      age: 63,
      gender: 'Male',
      contact: '555-0113',
      department: 'Orthopedics',
      doctor: 'Dr. Brown',
      isEmergency: false,
      registrationTime: DateTime.now().subtract(Duration(minutes: 32)),
      status: 'waiting',
      complaint: 'Hip replacement follow-up',
      urgency: 'Low Urgency',
      urgencyColor: Color(0xFF10B981),
      room: 'Room 304',
      avatar: 'assets/richard_avatar.png',
    ),
    Patient(
      id: 'P014',
      name: 'Jessica Martinez',
      mrn: 'MRN014',
      age: 37,
      gender: 'Female',
      contact: '555-0114',
      department: 'General Medicine',
      doctor: 'Dr. Smith',
      isEmergency: false,
      registrationTime: DateTime.now().subtract(Duration(minutes: 14)),
      status: 'waiting',
      complaint: 'Annual checkup',
      urgency: 'Low Urgency',
      urgencyColor: Color(0xFF10B981),
      room: 'Room 208',
      avatar: 'assets/jessica_avatar.png',
    ),
    Patient(
      id: 'P015',
      name: 'Thomas Wilson',
      mrn: 'MRN015',
      age: 52,
      gender: 'Male',
      contact: '555-0115',
      department: 'Urology',
      doctor: 'Dr. Harris',
      isEmergency: false,
      registrationTime: DateTime.now().subtract(Duration(minutes: 27)),
      status: 'waiting',
      complaint: 'Prostate screening',
      urgency: 'Low Urgency',
      urgencyColor: Color(0xFF10B981),
      room: 'Room 502',
      avatar: 'assets/thomas_avatar.png',
    ),
    Patient(
      id: 'P016',
      name: 'Olivia Taylor',
      mrn: 'MRN016',
      age: 44,
      gender: 'Female',
      contact: '555-0116',
      department: 'Endocrinology',
      doctor: 'Dr. White',
      isEmergency: false,
      registrationTime: DateTime.now().subtract(Duration(minutes: 21)),
      status: 'waiting',
      complaint: 'Thyroid function test results',
      urgency: 'Medium Urgency',
      urgencyColor: Colors.orange,
      room: 'Room 603',
      avatar: 'assets/olivia_avatar.png',
    ),
    Patient(
      id: 'P017',
      name: 'Christopher Lee',
      mrn: 'MRN017',
      age: 39,
      gender: 'Male',
      contact: '555-0117',
      department: 'ENT',
      doctor: 'Dr. Miller',
      isEmergency: false,
      registrationTime: DateTime.now().subtract(Duration(minutes: 16)),
      status: 'waiting',
      complaint: 'Sinus infection',
      urgency: 'Medium Urgency',
      urgencyColor: Colors.orange,
      room: 'Room 305',
      avatar: 'assets/christopher_avatar.png',
    ),
    Patient(
      id: 'P018',
      name: 'Sophia Hernandez',
      mrn: 'MRN018',
      age: 48,
      gender: 'Female',
      contact: '555-0118',
      department: 'Cardiology',
      doctor: 'Dr. Williams',
      isEmergency: true,
      registrationTime: DateTime.now().subtract(Duration(minutes: 9)),
      status: 'In Consultation',
      complaint: 'High blood pressure',
      urgency: 'High Urgency',
      urgencyColor: Colors.red,
      room: 'Room 203',
      avatar: 'assets/sophia_avatar.png',
    ),
    Patient(
      id: 'P019',
      name: 'Andrew Clark',
      mrn: 'MRN019',
      age: 56,
      gender: 'Male',
      contact: '555-0119',
      department: 'Neurology',
      doctor: 'Dr. Adams',
      isEmergency: false,
      registrationTime: DateTime.now().subtract(Duration(minutes: 33)),
      status: 'waiting',
      complaint: 'Follow-up for migraines',
      urgency: 'Low Urgency',
      urgencyColor: Color(0xFF10B981),
      room: 'Room 107',
      avatar: 'assets/andrew_avatar.png',
    ),
    Patient(
      id: 'P020',
      name: 'Emma Rodriguez',
      mrn: 'MRN020',
      age: 30,
      gender: 'Female',
      contact: '555-0120',
      department: 'Dermatology',
      doctor: 'Dr. Clark',
      isEmergency: false,
      registrationTime: DateTime.now().subtract(Duration(minutes: 24)),
      status: 'waiting',
      complaint: 'Mole evaluation',
      urgency: 'Low Urgency',
      urgencyColor: Color(0xFF10B981),
      room: 'Room 505',
      avatar: 'assets/emma_avatar.png',
    ),
  
  ];
  List<Patient> _queue = [];

  List<Patient> get patients => _patients;
  List<Patient> get queue => _queue;

  void addPatient(Patient patient) {
    _patients.add(patient);
    _queue.add(patient); // Add to end of queue
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
    // Implement your refresh logic
    notifyListeners();
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
