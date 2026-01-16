class LabTestRequest {
  final String id;
  final String requestNumber;
  final PatientInfo patient;
  final List<TestItem> tests;
  final String priority;
  final String priorityDisplay;
  final String priorityColor;
  final String status;
  final String statusDisplay;
  final String statusColor;
  final DoctorInfo orderingDoctor;
  final String requestDate;
  final String requestedAt;
  final String createdAt;
  final String timeAgo;
  final int? timeAgoSeconds;
  final String? clinicalIndication;
  final String? notes;
  final bool specimenCollected;
  final String? specimenCollectedAt;
  final String? processingStartedAt;
  final String? completedAt;

  LabTestRequest({
    required this.id,
    required this.requestNumber,
    required this.patient,
    required this.tests,
    required this.priority,
    required this.priorityDisplay,
    required this.priorityColor,
    required this.status,
    required this.statusDisplay,
    required this.statusColor,
    required this.orderingDoctor,
    required this.requestDate,
    required this.requestedAt,
    required this.createdAt,
    required this.timeAgo,
    this.timeAgoSeconds,
    this.clinicalIndication,
    this.notes,
    required this.specimenCollected,
    this.specimenCollectedAt,
    this.processingStartedAt,
    this.completedAt,
  });

  factory LabTestRequest.fromJson(Map<String, dynamic> json) {
    return LabTestRequest(
      id: json['id']?.toString() ?? '',
      requestNumber: json['request_number']?.toString() ?? '',
      patient: PatientInfo.fromJson(json['patient'] ?? {}),
      tests:
          (json['tests'] as List<dynamic>?)
              ?.map((test) => TestItem.fromJson(test))
              .toList() ??
          [],
      priority: json['priority']?.toString() ?? '',
      priorityDisplay:
          json['priority_display']?.toString() ??
          json['priority']?.toString() ??
          '',
      priorityColor: json['priority_color']?.toString() ?? '#DC2626',
      status: json['status']?.toString() ?? '',
      statusDisplay:
          json['status_display']?.toString() ??
          json['status']?.toString() ??
          '',
      statusColor: json['status_color']?.toString() ?? '#DC2626',
      orderingDoctor: DoctorInfo.fromJson(json['ordering_doctor'] ?? {}),
      requestDate: json['request_date']?.toString() ?? '',
      requestedAt: json['requested_at']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
      timeAgo: json['time_ago']?.toString() ?? '',
      timeAgoSeconds: json['time_ago_seconds'] as int?,
      clinicalIndication: json['clinical_indication']?.toString(),
      notes: json['notes']?.toString(),
      specimenCollected: json['specimen_collected'] == true,
      specimenCollectedAt: json['specimen_collected_at']?.toString(),
      processingStartedAt: json['processing_started_at']?.toString(),
      completedAt: json['completed_at']?.toString(),
    );
  }
}

class PatientInfo {
  final String id;
  final String mrn;
  final String name;
  final int? age;
  final String? gender;
  final String? demographics;

  PatientInfo({
    required this.id,
    required this.mrn,
    required this.name,
    this.age,
    this.gender,
    this.demographics,
  });

  factory PatientInfo.fromJson(Map<String, dynamic> json) {
    return PatientInfo(
      id: json['id']?.toString() ?? '',
      mrn: json['mrn']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      age: json['age'] as int?,
      gender: json['gender']?.toString(),
      demographics: json['demographics']?.toString(),
    );
  }
}

class TestItem {
  final String id;
  final String testCatalogId;
  final String testCode;
  final String testName;
  final String? specimenType;
  final String itemStatus;
  final String displayColor;

  TestItem({
    required this.id,
    required this.testCatalogId,
    required this.testCode,
    required this.testName,
    this.specimenType,
    required this.itemStatus,
    required this.displayColor,
  });

  factory TestItem.fromJson(Map<String, dynamic> json) {
    return TestItem(
      id: json['id']?.toString() ?? '',
      testCatalogId: json['test_catalog_id']?.toString() ?? '',
      testCode: json['test_code']?.toString() ?? '',
      testName: json['test_name']?.toString() ?? '',
      specimenType: json['specimen_type']?.toString(),
      itemStatus: json['item_status']?.toString() ?? 'Pending',
      displayColor: json['display_color']?.toString() ?? '#FEE2E2',
    );
  }
}

class DoctorInfo {
  final String id;
  final String name;
  final String? department;
  final String display;

  DoctorInfo({
    required this.id,
    required this.name,
    this.department,
    required this.display,
  });

  factory DoctorInfo.fromJson(Map<String, dynamic> json) {
    return DoctorInfo(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      department: json['department']?.toString(),
      display: json['display']?.toString() ?? '',
    );
  }
}

class OverviewMetrics {
  final String date;
  final MetricsData metrics;
  final PriorityBreakdown priorityBreakdown;
  final StatusBreakdown statusBreakdown;

  OverviewMetrics({
    required this.date,
    required this.metrics,
    required this.priorityBreakdown,
    required this.statusBreakdown,
  });

  factory OverviewMetrics.fromJson(Map<String, dynamic> json) {
    return OverviewMetrics(
      date: json['date']?.toString() ?? '',
      metrics: MetricsData.fromJson(json['metrics'] ?? {}),
      priorityBreakdown: PriorityBreakdown.fromJson(
        json['priority_breakdown'] ?? {},
      ),
      statusBreakdown: StatusBreakdown.fromJson(json['status_breakdown'] ?? {}),
    );
  }
}

class MetricsData {
  final int totalRequests;
  final int urgent;
  final int inProgress;
  final int completed;
  final int newCount;
  final int onHold;
  final int cancelled;

  MetricsData({
    required this.totalRequests,
    required this.urgent,
    required this.inProgress,
    required this.completed,
    required this.newCount,
    required this.onHold,
    required this.cancelled,
  });

  factory MetricsData.fromJson(Map<String, dynamic> json) {
    return MetricsData(
      totalRequests: json['total_requests'] as int? ?? 0,
      urgent: json['urgent'] as int? ?? 0,
      inProgress: json['in_progress'] as int? ?? 0,
      completed: json['completed'] as int? ?? 0,
      newCount: json['new'] as int? ?? 0,
      onHold: json['on_hold'] as int? ?? 0,
      cancelled: json['cancelled'] as int? ?? 0,
    );
  }
}

class PriorityBreakdown {
  final int stat;
  final int urgent;
  final int routine;
  final int delayed;

  PriorityBreakdown({
    required this.stat,
    required this.urgent,
    required this.routine,
    required this.delayed,
  });

  factory PriorityBreakdown.fromJson(Map<String, dynamic> json) {
    return PriorityBreakdown(
      stat: json['stat'] as int? ?? 0,
      urgent: json['urgent'] as int? ?? 0,
      routine: json['routine'] as int? ?? 0,
      delayed: json['delayed'] as int? ?? 0,
    );
  }
}

class StatusBreakdown {
  final int newCount;
  final int inProgress;
  final int completed;
  final int onHold;
  final int cancelled;

  StatusBreakdown({
    required this.newCount,
    required this.inProgress,
    required this.completed,
    required this.onHold,
    required this.cancelled,
  });

  factory StatusBreakdown.fromJson(Map<String, dynamic> json) {
    return StatusBreakdown(
      newCount: json['new'] as int? ?? 0,
      inProgress: json['in_progress'] as int? ?? 0,
      completed: json['completed'] as int? ?? 0,
      onHold: json['on_hold'] as int? ?? 0,
      cancelled: json['cancelled'] as int? ?? 0,
    );
  }
}

class Pagination {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;
  final bool hasNext;
  final bool hasPrevious;

  Pagination({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
    required this.hasNext,
    required this.hasPrevious,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['current_page'] as int? ?? 1,
      totalPages: json['total_pages'] as int? ?? 1,
      totalItems: json['total_items'] as int? ?? 0,
      itemsPerPage: json['items_per_page'] as int? ?? 20,
      hasNext: json['has_next'] == true,
      hasPrevious: json['has_previous'] == true,
    );
  }
}

class Department {
  final String name;
  final int count;
  final String displayName;

  Department({
    required this.name,
    required this.count,
    required this.displayName,
  });

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      name: json['name']?.toString() ?? '',
      count: json['count'] as int? ?? 0,
      displayName:
          json['display_name']?.toString() ?? json['name']?.toString() ?? '',
    );
  }
}
