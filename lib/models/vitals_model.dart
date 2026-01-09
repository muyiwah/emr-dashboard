class VitalsRecord {
  final String id;
  final VitalSigns vitalSigns;
  final String? notes;
  final DateTime recordedAt;
  final String? recordedBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  VitalsRecord({
    required this.id,
    required this.vitalSigns,
    this.notes,
    required this.recordedAt,
    this.recordedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VitalsRecord.fromJson(Map<String, dynamic> json) {
    return VitalsRecord(
      id: json['id'] ?? json['_id'] ?? '',
      vitalSigns: VitalSigns.fromJson(json['vitalSigns'] ?? {}),
      notes: json['notes'],
      recordedAt: json['recordedAt'] != null
          ? DateTime.parse(json['recordedAt'])
          : DateTime.now(),
      recordedBy: json['recordedBy'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }
}

class VitalSigns {
  final BloodPressure? bloodPressure;
  final HeartRate? heartRate;
  final RespiratoryRate? respiratoryRate;
  final Temperature? temperature;
  final OxygenSaturation? oxygenSaturation;
  final Weight? weight;
  final Height? height;
  final BloodGlucose? bloodGlucose;
  final PainScore? painScore;

  VitalSigns({
    this.bloodPressure,
    this.heartRate,
    this.respiratoryRate,
    this.temperature,
    this.oxygenSaturation,
    this.weight,
    this.height,
    this.bloodGlucose,
    this.painScore,
  });

  factory VitalSigns.fromJson(Map<String, dynamic> json) {
    return VitalSigns(
      bloodPressure: json['bloodPressure'] != null
          ? BloodPressure.fromJson(json['bloodPressure'])
          : null,
      heartRate: json['heartRate'] != null
          ? HeartRate.fromJson(json['heartRate'])
          : null,
      respiratoryRate: json['respiratoryRate'] != null
          ? RespiratoryRate.fromJson(json['respiratoryRate'])
          : null,
      temperature: json['temperature'] != null
          ? Temperature.fromJson(json['temperature'])
          : null,
      oxygenSaturation: json['oxygenSaturation'] != null
          ? OxygenSaturation.fromJson(json['oxygenSaturation'])
          : null,
      weight:
          json['weight'] != null ? Weight.fromJson(json['weight']) : null,
      height:
          json['height'] != null ? Height.fromJson(json['height']) : null,
      bloodGlucose: json['bloodGlucose'] != null
          ? BloodGlucose.fromJson(json['bloodGlucose'])
          : null,
      painScore: json['painScore'] != null
          ? PainScore.fromJson(json['painScore'])
          : null,
    );
  }
}

class BloodPressure {
  final int? systolic;
  final int? diastolic;
  final String unit;

  BloodPressure({
    this.systolic,
    this.diastolic,
    this.unit = 'mmHg',
  });

  factory BloodPressure.fromJson(Map<String, dynamic> json) {
    return BloodPressure(
      systolic: json['systolic'],
      diastolic: json['diastolic'],
      unit: json['unit'] ?? 'mmHg',
    );
  }

  String get displayValue {
    if (systolic != null && diastolic != null) {
      return '$systolic/$diastolic';
    } else if (systolic != null) {
      return '$systolic/-';
    } else if (diastolic != null) {
      return '-/$diastolic';
    }
    return '-';
  }
}

class HeartRate {
  final int value;
  final String unit;

  HeartRate({
    required this.value,
    this.unit = 'bpm',
  });

  factory HeartRate.fromJson(Map<String, dynamic> json) {
    return HeartRate(
      value: json['value'] ?? 0,
      unit: json['unit'] ?? 'bpm',
    );
  }
}

class RespiratoryRate {
  final int value;
  final String unit;

  RespiratoryRate({
    required this.value,
    this.unit = 'breaths/min',
  });

  factory RespiratoryRate.fromJson(Map<String, dynamic> json) {
    return RespiratoryRate(
      value: json['value'] ?? 0,
      unit: json['unit'] ?? 'breaths/min',
    );
  }
}

class Temperature {
  final double value;
  final String unit;

  Temperature({
    required this.value,
    this.unit = 'C',
  });

  factory Temperature.fromJson(Map<String, dynamic> json) {
    return Temperature(
      value: (json['value'] ?? 0).toDouble(),
      unit: json['unit'] ?? 'C',
    );
  }

  String get displayValue {
    final symbol = unit == 'C' ? '°C' : '°F';
    return '${value.toStringAsFixed(1)}$symbol';
  }
}

class OxygenSaturation {
  final int value;
  final String unit;

  OxygenSaturation({
    required this.value,
    this.unit = '%',
  });

  factory OxygenSaturation.fromJson(Map<String, dynamic> json) {
    return OxygenSaturation(
      value: json['value'] ?? 0,
      unit: json['unit'] ?? '%',
    );
  }
}

class Weight {
  final double value;
  final String unit;

  Weight({
    required this.value,
    this.unit = 'kg',
  });

  factory Weight.fromJson(Map<String, dynamic> json) {
    return Weight(
      value: (json['value'] ?? 0).toDouble(),
      unit: json['unit'] ?? 'kg',
    );
  }
}

class Height {
  final double value;
  final String unit;

  Height({
    required this.value,
    this.unit = 'cm',
  });

  factory Height.fromJson(Map<String, dynamic> json) {
    return Height(
      value: (json['value'] ?? 0).toDouble(),
      unit: json['unit'] ?? 'cm',
    );
  }
}

class BloodGlucose {
  final double? value;
  final String unit;

  BloodGlucose({
    this.value,
    this.unit = 'mmol/L',
  });

  factory BloodGlucose.fromJson(Map<String, dynamic> json) {
    return BloodGlucose(
      value: json['value'] != null ? (json['value'] as num).toDouble() : null,
      unit: json['unit'] ?? 'mmol/L',
    );
  }
}

class PainScore {
  final int? value;
  final String scale;

  PainScore({
    this.value,
    this.scale = '0-10',
  });

  factory PainScore.fromJson(Map<String, dynamic> json) {
    return PainScore(
      value: json['value'],
      scale: json['scale'] ?? '0-10',
    );
  }
}

class VitalsHistory {
  final List<VitalsRecord> history;
  final VitalsRecord? latest;
  final int totalCount;

  VitalsHistory({
    required this.history,
    this.latest,
    required this.totalCount,
  });

  factory VitalsHistory.fromJson(Map<String, dynamic> json) {
    return VitalsHistory(
      history: (json['history'] as List<dynamic>?)
              ?.map((v) => VitalsRecord.fromJson(v as Map<String, dynamic>))
              .toList() ??
          [],
      latest: json['latest'] != null
          ? VitalsRecord.fromJson(json['latest'] as Map<String, dynamic>)
          : null,
      totalCount: json['totalCount'] ?? 0,
    );
  }
}

