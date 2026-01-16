class ImagingMetricsResponse {
  final bool success;
  final String timestamp;
  final String message;
  final ImagingMetricsData data;

  ImagingMetricsResponse({
    required this.success,
    required this.timestamp,
    required this.message,
    required this.data,
  });

  factory ImagingMetricsResponse.fromJson(Map<String, dynamic> json) {
    return ImagingMetricsResponse(
      success: json['success'] ?? false,
      timestamp: json['timestamp'] ?? '',
      message: json['message'] ?? '',
      data: ImagingMetricsData.fromJson(json['data'] ?? {}),
    );
  }
}

class ImagingMetricsData {
  final String period;
  final String dateRange;
  final ImagingMetricsSummary summary;
  final Map<String, int> statusBreakdown;
  final Map<String, int> priorityBreakdown;
  final List<ModalityPerformance> modalityPerformance;

  ImagingMetricsData({
    required this.period,
    required this.dateRange,
    required this.summary,
    required this.statusBreakdown,
    required this.priorityBreakdown,
    required this.modalityPerformance,
  });

  factory ImagingMetricsData.fromJson(Map<String, dynamic> json) {
    return ImagingMetricsData(
      period: json['period'] ?? 'all',
      dateRange: json['date_range'] ?? 'All time',
      summary: ImagingMetricsSummary.fromJson(json['summary'] ?? {}),
      statusBreakdown: Map<String, int>.from(json['status_breakdown'] ?? {}),
      priorityBreakdown: Map<String, int>.from(json['priority_breakdown'] ?? {}),
      modalityPerformance: (json['modality_performance'] as List<dynamic>?)
              ?.map((e) => ModalityPerformance.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class ImagingMetricsSummary {
  final int totalOrders;
  final String completionRate;
  final int urgentOrders;
  final String urgentRate;
  final double avgTurnaroundHours;
  final int completedThisPeriod;

  ImagingMetricsSummary({
    required this.totalOrders,
    required this.completionRate,
    required this.urgentOrders,
    required this.urgentRate,
    required this.avgTurnaroundHours,
    required this.completedThisPeriod,
  });

  factory ImagingMetricsSummary.fromJson(Map<String, dynamic> json) {
    return ImagingMetricsSummary(
      totalOrders: json['total_orders'] ?? 0,
      completionRate: json['completion_rate'] ?? '0%',
      urgentOrders: json['urgent_orders'] ?? 0,
      urgentRate: json['urgent_rate'] ?? '0%',
      avgTurnaroundHours: _parseDouble(json['avg_turnaround_hours']),
      completedThisPeriod: json['completed_this_period'] ?? 0,
    );
  }
}

class ModalityPerformance {
  final String modality;
  final int total;
  final int completed;
  final int pending;
  final double completionRate;

  ModalityPerformance({
    required this.modality,
    required this.total,
    required this.completed,
    required this.pending,
    required this.completionRate,
  });

  factory ModalityPerformance.fromJson(Map<String, dynamic> json) {
    return ModalityPerformance(
      modality: json['modality'] ?? '',
      total: json['total'] ?? 0,
      completed: json['completed'] ?? 0,
      pending: json['pending'] ?? 0,
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
