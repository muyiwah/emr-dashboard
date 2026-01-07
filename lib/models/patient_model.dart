import 'dart:ui';

import 'package:flutter/material.dart';

class Patient {
  // Demographics
  final String id;
  final String name;
  final String mrn;
  final int age;
  final String gender;
  final String contact;
  final String department;
  final String doctor;

  // Status and UI
  final String status;
  Duration waitTime;
  final bool isEmergency;
  final DateTime registrationTime;
  final String? room;
  final String? avatar;

  // Clinical Info
  final String? complaint;
  final String urgency;
  final Color? urgencyColor;

  // HPI
  final HpiRecord? hpi;

  // Dashboard Fields
  final List<String> tags;
  final List<String> criticalAlerts;
  final List<String> activeProblems;
  final List<Medication> currentMedications;
  final List<Vital> recentVitals;
  final MedicalHistory? medicalHistory;
  final String vitalsTrend;
  final MedicationSummary? medicationSummary;
  final List<LabResult> labResults;
  final List<ImagingRecord> imagingRecords;
  final ClinicalNote? clinicalNote;
  final List<Appointment> upcomingAppointments;

  Patient({
    required this.id,
    required this.name,
    required this.mrn,
    required this.age,
    this.waitTime = const Duration(seconds: 60),
    required this.gender,
    this.status = 'waiting',
    this.contact = 'contact',
    this.department = 'new dept',
    this.doctor = 'no doctor',
    this.isEmergency = false,
    required this.registrationTime,
    this.complaint,
    this.urgency = 'medium',
    this.urgencyColor,
    this.room,
    this.avatar,
    this.hpi,
    this.tags = const [],
    this.criticalAlerts = const [],
    this.activeProblems = const [],
    this.currentMedications = const [],
    this.recentVitals = const [],
    this.medicalHistory,
    this.vitalsTrend = '',
    this.medicationSummary,
    this.labResults = const [],
    this.imagingRecords = const [],
    this.clinicalNote,
    this.upcomingAppointments = const [],
  });

  Color get statusColor {
    if (isEmergency) return Colors.red;
    switch (status) {
      case 'In Consultation':
        return Colors.green;
      case 'Completed':
        return Colors.grey;
      default:
        return Colors.orange;
    }
  }

  String get formattedWaitTime {
    if (waitTime.inHours > 0) {
      return '${waitTime.inHours}h ${waitTime.inMinutes.remainder(60)}min';
    }
    return '${waitTime.inMinutes}min';
  }

  Patient copyWith({
    String? name,
    String? mrn,
    String? doctor,
    String? department,
    bool? isEmergency,
    String? status,
    Duration? waitTime,
    String? complaint,
    String? urgency,
    Color? urgencyColor,
    String? room,
    String? avatar,
    HpiRecord? hpi,
    List<String>? tags,
    List<String>? criticalAlerts,
    List<String>? activeProblems,
    // List<Medication>? currentMedications,
    List<Vital>? recentVitals,
    MedicalHistory? medicalHistory,
    String? vitalsTrend,
    MedicationSummary? medicationSummary,
    List<LabResult>? labResults,
    List<ImagingRecord>? imagingRecords,
    ClinicalNote? clinicalNote,
    List<Appointment>? upcomingAppointments,
  }) {
    return Patient(
      id: id,
      name: name ?? this.name,
      mrn: mrn ?? this.mrn,
      age: age,
      gender: gender,
      waitTime: waitTime ?? this.waitTime,
      contact: contact,
      department: department ?? this.department,
      doctor: doctor ?? this.doctor,
      isEmergency: isEmergency ?? this.isEmergency,
      status: status ?? this.status,
      registrationTime: registrationTime,
      complaint: complaint ?? this.complaint,
      urgency: urgency ?? this.urgency,
      urgencyColor: urgencyColor ?? this.urgencyColor,
      room: room ?? this.room,
      avatar: avatar ?? this.avatar,
      hpi: hpi ?? this.hpi,
      tags: tags ?? this.tags,
      criticalAlerts: criticalAlerts ?? this.criticalAlerts,
      activeProblems: activeProblems ?? this.activeProblems,
      // currentMedications: currentMedications ?? this.currentMedications,
      recentVitals: recentVitals ?? this.recentVitals,
      medicalHistory: medicalHistory ?? this.medicalHistory,
      vitalsTrend: vitalsTrend ?? this.vitalsTrend,
      medicationSummary: medicationSummary ?? this.medicationSummary,
      labResults: labResults ?? this.labResults,
      imagingRecords: imagingRecords ?? this.imagingRecords,
      clinicalNote: clinicalNote ?? this.clinicalNote,
      upcomingAppointments: upcomingAppointments ?? this.upcomingAppointments,
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'name': name,
  //     'mrn': mrn,
  //     'age': age,
  //     'gender': gender,
  //     'contact': contact,
  //     'department': department,
  //     'doctor': doctor,
  //     'status': status,
  //     'waitTime': waitTime.inSeconds,
  //     'isEmergency': isEmergency,
  //     'registrationTime': registrationTime.toIso8601String(),
  //     'complaint': complaint,
  //     'urgency': urgency,
  //     'urgencyColor': urgencyColor?.value,
  //     'room': room,
  //     'avatar': avatar,
  //     'hpi': hpi?.toJson(),
  //     'tags': tags,
  //     'criticalAlerts': criticalAlerts,
  //     'activeProblems': activeProblems,
  //     'currentMedications': currentMedications.map((e) => e.toJson()).toList(),
  //     'recentVitals': recentVitals.map((e) => e.toJson()).toList(),
  //     'medicalHistory': medicalHistory.toJson(),
  //     'vitalsTrend': vitalsTrend,
  //     'medicationSummary': medicationSummary.toJson(),
  //     'labResults': labResults.map((e) => e.toJson()).toList(),
  //     'imagingRecords': imagingRecords.map((e) => e.toJson()).toList(),
  //     'clinicalNote': clinicalNote.toJson(),
  //     'upcomingAppointments':
  //         upcomingAppointments.map((e) => e.toJson()).toList(),
  //   };
  // }

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'],
      name: json['name'],
      mrn: json['mrn'],
      age: json['age'],
      gender: json['gender'],
      contact: json['contact'],
      department: json['department'],
      doctor: json['doctor'],
      status: json['status'],
      waitTime: Duration(seconds: json['waitTime']),
      isEmergency: json['isEmergency'],
      registrationTime: DateTime.parse(json['registrationTime']),
      complaint: json['complaint'],
      urgency: json['urgency'],
      urgencyColor:
          json['urgencyColor'] != null ? Color(json['urgencyColor']) : null,
      room: json['room'],
      avatar: json['avatar'],
      hpi: json['hpi'] != null ? HpiRecord.fromJson(json['hpi']) : null,
      tags: List<String>.from(json['tags']),
      criticalAlerts: List<String>.from(json['criticalAlerts']),
      activeProblems: List<String>.from(json['activeProblems']),
      // currentMedications:
      //     (json['currentMedications'] as List)
      //         .map((e) => Medication.fromJson(e))
      //         .toList(),
      recentVitals:
          (json['recentVitals'] as List).map((e) => Vital.fromJson(e)).toList(),
      medicalHistory: MedicalHistory.fromJson(json['medicalHistory']),
      vitalsTrend: json['vitalsTrend'],
      medicationSummary: MedicationSummary.fromJson(json['medicationSummary']),
      labResults:
          (json['labResults'] as List)
              .map((e) => LabResult.fromJson(e))
              .toList(),
      imagingRecords:
          (json['imagingRecords'] as List)
              .map((e) => ImagingRecord.fromJson(e))
              .toList(),
      clinicalNote: ClinicalNote.fromJson(json['clinicalNote']),
      upcomingAppointments:
          (json['upcomingAppointments'] as List)
              .map((e) => Appointment.fromJson(e))
              .toList(),
    );
  }

  /// Factory to create a [Patient] from the EMR backend `/api/patients` response.
  /// This maps the backend structure into the simplified dashboard model used
  /// by the `PatientRecordsScreen`.
  factory Patient.fromApi(Map<String, dynamic> json) {
    final String firstName = json['firstName'] ?? '';
    final String lastName = json['lastName'] ?? '';
    final String fullNameFromNames =
        [firstName, lastName].where((p) => p.isNotEmpty).join(' ');

    final dynamic rawAge = json['age'];

    final String rawGender = (json['gender'] ?? '').toString();
    final String formattedGender = rawGender.isNotEmpty
        ? rawGender[0].toUpperCase() + rawGender.substring(1)
        : '';

    return Patient(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['fullName'] ?? fullNameFromNames,
      mrn: json['medicalRecordNumber'] ?? '',
      age: rawAge is int ? rawAge : int.tryParse('$rawAge') ?? 0,
      gender: formattedGender,
      contact: json['phone'] ?? '',
      department: 'General Medicine',
      doctor: 'Not Assigned',
      status: 'waiting',
      waitTime: const Duration(minutes: 0),
      isEmergency: false,
      registrationTime: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      complaint: '',
      urgency: 'Medium Urgency',
      urgencyColor: Colors.orange,
      room: null,
      avatar: null,
      hpi: null,
      tags: const [],
      criticalAlerts: const [],
      activeProblems: const [],
      currentMedications: const [],
      recentVitals: const [],
      medicalHistory: null,
      vitalsTrend: '',
      medicationSummary: null,
      labResults: const [],
      imagingRecords: const [],
      clinicalNote: null,
      upcomingAppointments: const [],
    );
  }
}

// Define HpiRecord, Medication, Vital, MedicalHistory, MedicationSummary,
// LabResult, ImagingRecord, ClinicalNote, Appointment in separate files or below as needed.

// class Medication {
//   final String name;
//   final String dosage;

//   Medication({required this.name, required this.dosage});

//   Map<String, dynamic> toJson() => {'name': name, 'dosage': dosage};

//   factory Medication.fromJson(Map<String, dynamic> json) =>
//       Medication(name: json['name'], dosage: json['dosage']);
// }

class Vital {
  final String value;
  final String label;
  final int colorValue;

  Vital({required this.value, required this.label, required Color color})
    : colorValue = color.value;

  Color get color => Color(colorValue);

  Map<String, dynamic> toJson() => {
    'value': value,
    'label': label,
    'color': colorValue,
  };

  factory Vital.fromJson(Map<String, dynamic> json) => Vital(
    value: json['value'],
    label: json['label'],
    color: Color(json['color']),
  );
}

class MedicalHistory {
  final String pastMedical;
  final String surgical;
  final String family;

  MedicalHistory({
    required this.pastMedical,
    required this.surgical,
    required this.family,
  });

  Map<String, dynamic> toJson() => {
    'pastMedical': pastMedical,
    'surgical': surgical,
    'family': family,
  };

  factory MedicalHistory.fromJson(Map<String, dynamic> json) => MedicalHistory(
    pastMedical: json['pastMedical'],
    surgical: json['surgical'],
    family: json['family'],
  );
}

class MedicationSummary {
  final int activeCount;
  final String lastUpdated;
  final bool allCompliant;

  MedicationSummary({
    required this.activeCount,
    required this.lastUpdated,
    required this.allCompliant,
  });

  Map<String, dynamic> toJson() => {
    'activeCount': activeCount,
    'lastUpdated': lastUpdated,
    'allCompliant': allCompliant,
  };

  factory MedicationSummary.fromJson(Map<String, dynamic> json) =>
      MedicationSummary(
        activeCount: json['activeCount'],
        lastUpdated: json['lastUpdated'],
        allCompliant: json['allCompliant'],
      );
}

class LabResult {
  final String testName;
  final String value;
  final String trend;
  final int colorValue;

  LabResult({
    required this.testName,
    required this.value,
    required this.trend,
    required Color color,
  }) : colorValue = color.value;

  Color get color => Color(colorValue);

  Map<String, dynamic> toJson() => {
    'testName': testName,
    'value': value,
    'trend': trend,
    'color': colorValue,
  };

  factory LabResult.fromJson(Map<String, dynamic> json) => LabResult(
    testName: json['testName'],
    value: json['value'],
    trend: json['trend'],
    color: Color(json['color']),
  );
}

class ImagingRecord {
  final String description;
  final String date;
  final String iconName;
  final int iconColorValue;

  ImagingRecord({
    required this.description,
    required this.date,
    required IconData icon,
    required Color iconColor,
  }) : iconName = icon.codePoint.toString(),
       iconColorValue = iconColor.value;

  IconData get icon =>
      IconData(int.parse(iconName), fontFamily: 'MaterialIcons');
  Color get iconColor => Color(iconColorValue);

  Map<String, dynamic> toJson() => {
    'description': description,
    'date': date,
    'iconName': iconName,
    'iconColor': iconColorValue,
  };

  factory ImagingRecord.fromJson(Map<String, dynamic> json) => ImagingRecord(
    description: json['description'],
    date: json['date'],
    icon: IconData(int.parse(json['iconName']), fontFamily: 'MaterialIcons'),
    iconColor: Color(json['iconColor']),
  );
}

class ClinicalNote {
  final String summary;
  final String doctor;
  final String date;

  ClinicalNote({
    required this.summary,
    required this.doctor,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
    'summary': summary,
    'doctor': doctor,
    'date': date,
  };

  factory ClinicalNote.fromJson(Map<String, dynamic> json) => ClinicalNote(
    summary: json['summary'],
    doctor: json['doctor'],
    date: json['date'],
  );
}

class Appointment {
  final String title;
  final String details;
  final int colorValue;

  Appointment({
    required this.title,
    required this.details,
    required Color color,
  }) : colorValue = color.value;

  Color get color => Color(colorValue);

  Map<String, dynamic> toJson() => {
    'title': title,
    'details': details,
    'color': colorValue,
  };

  factory Appointment.fromJson(Map<String, dynamic> json) => Appointment(
    title: json['title'],
    details: json['details'],
    color: Color(json['color']),
  );
}

class HpiRecord {
  final String id;
  final String patientId;
  final String providerId;
  final DateTime createdAt;
  final DateTime updatedAt;

  // HPI Components
  final String chiefComplaint;
  final String symptomDescription;
  final DateTime symptomOnset;
  final int duration;
  final String durationUnit; // 'Hours', 'Days', 'Weeks', 'Months'
  final String
  progressionType; // 'Sudden', 'Gradual', 'Intermittent', 'Progressive'
  final double severityScale; // 1-10
  final String aggravatingFactors;
  final String relievingFactors;
  final Map<String, bool> associatedSymptoms;
  final String additionalNotes;

  HpiRecord({
    required this.id,
    required this.patientId,
    required this.providerId,
    required this.createdAt,
    required this.updatedAt,
    required this.chiefComplaint,
    required this.symptomDescription,
    required this.symptomOnset,
    required this.duration,
    required this.durationUnit,
    required this.progressionType,
    required this.severityScale,
    required this.aggravatingFactors,
    required this.relievingFactors,
    required this.associatedSymptoms,
    required this.additionalNotes,
  });

  // Convert to JSON for Firestore/API storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'providerId': providerId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'chiefComplaint': chiefComplaint,
      'symptomDescription': symptomDescription,
      'symptomOnset': symptomOnset.toIso8601String(),
      'duration': duration,
      'durationUnit': durationUnit,
      'progressionType': progressionType,
      'severityScale': severityScale,
      'aggravatingFactors': aggravatingFactors,
      'relievingFactors': relievingFactors,
      'associatedSymptoms': associatedSymptoms,
      'additionalNotes': additionalNotes,
    };
  }

  // Create from JSON (e.g., from Firestore)
  factory HpiRecord.fromJson(Map<String, dynamic> json) {
    return HpiRecord(
      id: json['id'],
      patientId: json['patientId'],
      providerId: json['providerId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      chiefComplaint: json['chiefComplaint'],
      symptomDescription: json['symptomDescription'],
      symptomOnset: DateTime.parse(json['symptomOnset']),
      duration: json['duration'],
      durationUnit: json['durationUnit'],
      progressionType: json['progressionType'],
      severityScale: json['severityScale'].toDouble(),
      aggravatingFactors: json['aggravatingFactors'],
      relievingFactors: json['relievingFactors'],
      associatedSymptoms: Map<String, bool>.from(json['associatedSymptoms']),
      additionalNotes: json['additionalNotes'],
    );
  }
}

class Medication {
  final String id;
  final String patientId;
  final String name;
  final String dosage;
  final String frequency;
  final String additionalInfo;
  final String description;
  final String duration;
  final List<String>? conflictsWith;

  final String prescribedBy;
  final DateTime? startDate;
  final DateTime? endDate;
  final String status;
  final String? chemicalComposition;
  final String? targetInfo;
  final bool showMonitorBP;
  final String? notes;

  Medication({
    this.id = '',
    this.patientId = '',
    this.additionalInfo = '',
    this.name = '',
    this.description = '',
    this.dosage = '',
    this.conflictsWith,
    this.frequency = '',
    this.duration = '',
    this.prescribedBy = '',
    this.startDate,
    this.endDate,
    this.status = '',
    this.chemicalComposition,
    this.targetInfo,
    this.showMonitorBP = false,
    this.notes,
  });

  // Helper method to format date
  String get formattedStartDate {
    return '${startDate?.month}/${startDate?.day}/${startDate?.year}';
  }

  // Copy with method for updates
  Medication copyWith({
    String? name,
    String? dosage,
    String? additionalInfo,
    String? frequency,
    List? conflictsWith,
    String? duration,
    String? prescribedBy,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    String? chemicalComposition,
    String? targetInfo,
    bool? showMonitorBP,
    String? notes,
  }) {
    return Medication(
      id: id,
      patientId: patientId,
      name: name ?? this.name,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      conflictsWith: [],
      dosage: dosage ?? this.dosage,
      frequency: frequency ?? this.frequency,
      description: description ?? this.description,
      duration: duration ?? this.duration,
      prescribedBy: prescribedBy ?? this.prescribedBy,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      chemicalComposition: chemicalComposition ?? this.chemicalComposition,
      targetInfo: targetInfo ?? this.targetInfo,
      showMonitorBP: showMonitorBP ?? this.showMonitorBP,
      notes: notes ?? this.notes,
    );
  }
}
