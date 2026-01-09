import 'package:flutter/material.dart';

/// Model for Family Medical Condition matching the API structure
class FamilyMedicalCondition {
  final String id;
  final String patientId;
  final String condition;
  final String relation;
  final bool isHighRisk;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? createdBy;

  // UI-only fields (not from API)
  IconData? icon;
  Color? color;

  FamilyMedicalCondition({
    required this.id,
    required this.patientId,
    required this.condition,
    required this.relation,
    required this.isHighRisk,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.createdBy,
    this.icon,
    this.color,
  });

  /// Create from API JSON response
  factory FamilyMedicalCondition.fromJson(Map<String, dynamic> json) {
    // Determine icon and color based on condition type
    final conditionLower = json['condition'].toString().toLowerCase();
    IconData? icon;
    Color? color;

    if (conditionLower.contains('hypertension') ||
        conditionLower.contains('blood pressure') ||
        conditionLower.contains('cardiac') ||
        conditionLower.contains('heart')) {
      icon = Icons.favorite;
      color = Colors.red;
    } else if (conditionLower.contains('diabetes') ||
        conditionLower.contains('diabetic')) {
      icon = Icons.water_drop;
      color = Colors.orange;
    } else if (conditionLower.contains('cancer')) {
      icon = Icons.health_and_safety;
      color = Colors.pink;
    } else if (conditionLower.contains('stroke')) {
      icon = Icons.warning;
      color = Colors.red[800];
    } else {
      icon = Icons.medical_services;
      color = Colors.blue;
    }

    return FamilyMedicalCondition(
      id: json['id'] ?? json['_id'] ?? '',
      patientId: json['patientId'] ?? '',
      condition: json['condition'] ?? '',
      relation: json['relation'] ?? '',
      isHighRisk: json['isHighRisk'] ?? false,
      notes: json['notes'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      createdBy: json['createdBy'],
      icon: icon,
      color: color,
    );
  }

  /// Convert to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'condition': condition,
      'relation': relation,
      'isHighRisk': isHighRisk,
      if (notes != null && notes!.isNotEmpty) 'notes': notes,
    };
  }

  /// Create a copy with updated fields
  FamilyMedicalCondition copyWith({
    String? id,
    String? patientId,
    String? condition,
    String? relation,
    bool? isHighRisk,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    IconData? icon,
    Color? color,
  }) {
    return FamilyMedicalCondition(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      condition: condition ?? this.condition,
      relation: relation ?? this.relation,
      isHighRisk: isHighRisk ?? this.isHighRisk,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      icon: icon ?? this.icon,
      color: color ?? this.color,
    );
  }
}

/// Summary of family history
class FamilyHistorySummary {
  final int totalConditions;
  final int highRiskCount;
  final bool hasHighRisk;

  FamilyHistorySummary({
    required this.totalConditions,
    required this.highRiskCount,
    required this.hasHighRisk,
  });

  factory FamilyHistorySummary.fromJson(Map<String, dynamic> json) {
    return FamilyHistorySummary(
      totalConditions: json['totalConditions'] ?? 0,
      highRiskCount: json['highRiskCount'] ?? 0,
      hasHighRisk: json['hasHighRisk'] ?? false,
    );
  }
}

