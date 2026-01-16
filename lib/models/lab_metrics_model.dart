class LabMetricsResponse {
  final bool success;
  final String timestamp;
  final String message;
  final LabMetricsData data;

  LabMetricsResponse({
    required this.success,
    required this.timestamp,
    required this.message,
    required this.data,
  });

  factory LabMetricsResponse.fromJson(Map<String, dynamic> json) {
    return LabMetricsResponse(
      success: json['success'] ?? false,
      timestamp: json['timestamp'] ?? '',
      message: json['message'] ?? '',
      data: LabMetricsData.fromJson(json['data'] ?? {}),
    );
  }
}

class LabMetricsData {
  final String period;
  final String dateRange;
  final LabMetricsSummary summary;
  final Map<String, int> statusBreakdown;
  final Map<String, int> priorityBreakdown;
  final List<DepartmentPerformance> departmentPerformance;
  final Map<String, int> testItemStatus;

  LabMetricsData({
    required this.period,
    required this.dateRange,
    required this.summary,
    required this.statusBreakdown,
    required this.priorityBreakdown,
    required this.departmentPerformance,
    required this.testItemStatus,
  });

  factory LabMetricsData.fromJson(Map<String, dynamic> json) {
    return LabMetricsData(
      period: json['period'] ?? 'all',
      dateRange: json['date_range'] ?? 'All time',
      summary: LabMetricsSummary.fromJson(json['summary'] ?? {}),
      statusBreakdown: Map<String, int>.from(json['status_breakdown'] ?? {}),
      priorityBreakdown: Map<String, int>.from(json['priority_breakdown'] ?? {}),
      departmentPerformance: (json['department_performance'] as List<dynamic>?)
              ?.map((e) => DepartmentPerformance.fromJson(e))
              .toList() ??
          [],
      testItemStatus: Map<String, int>.from(json['test_item_status'] ?? {}),
    );
  }
}

class LabMetricsSummary {
  final int totalRequests;
  final String completionRate;
  final int urgentRequests;
  final String urgentRate;
  final double avgTurnaroundHours;
  final int completedThisPeriod;

  LabMetricsSummary({
    required this.totalRequests,
    required this.completionRate,
    required this.urgentRequests,
    required this.urgentRate,
    required this.avgTurnaroundHours,
    required this.completedThisPeriod,
  });

  factory LabMetricsSummary.fromJson(Map<String, dynamic> json) {
    return LabMetricsSummary(
      totalRequests: json['total_requests'] ?? 0,
      completionRate: json['completion_rate'] ?? '0%',
      urgentRequests: json['urgent_requests'] ?? 0,
      urgentRate: json['urgent_rate'] ?? '0%',
      avgTurnaroundHours: _parseDouble(json['avg_turnaround_hours']),
      completedThisPeriod: json['completed_this_period'] ?? 0,
    );
  }
}

class DepartmentPerformance {
  final String department;
  final int total;
  final int completed;
  final int pending;
  final int urgent;
  final double completionRate;

  DepartmentPerformance({
    required this.department,
    required this.total,
    required this.completed,
    required this.pending,
    required this.urgent,
    required this.completionRate,
  });

  factory DepartmentPerformance.fromJson(Map<String, dynamic> json) {
    return DepartmentPerformance(
      department: json['department'] ?? '',
      total: json['total'] ?? 0,
      completed: json['completed'] ?? 0,
      pending: json['pending'] ?? 0,
      urgent: json['urgent'] ?? 0,
      completionRate: _parseDouble(json['completion_rate']),
    );
  }
}

// Helper function to safely parse double values from JSON
double _parseDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) {
    return double.tryParse(value) ?? 0.0;
  }
  return 0.0;
}
