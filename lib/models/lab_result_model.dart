/// Lab Result model for API responses
/// Endpoints:
/// - GET /api/v1/lab-test-requests/:id/items/:itemId/results
/// - GET /api/patients/:patientId/lab-results

class LabResultEntry {
  final String? analyteCode;
  final String? analyteName;
  final String? value;
  final String? unit;
  final String? referenceRange;
  final String? flag;

  LabResultEntry({
    this.analyteCode,
    this.analyteName,
    this.value,
    this.unit,
    this.referenceRange,
    this.flag,
  });

  factory LabResultEntry.fromJson(Map<String, dynamic> json) {
    return LabResultEntry(
      analyteCode: json['analyte_code']?.toString(),
      analyteName: json['analyte_name']?.toString(),
      value: json['value']?.toString(),
      unit: json['unit']?.toString(),
      referenceRange: json['reference_range']?.toString(),
      flag: json['flag']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (analyteCode != null) 'analyte_code': analyteCode,
      if (analyteName != null) 'analyte_name': analyteName,
      if (value != null) 'value': value,
      if (unit != null) 'unit': unit,
      if (referenceRange != null) 'reference_range': referenceRange,
      if (flag != null) 'flag': flag,
    };
  }
}

class LabResultAttachment {
  final String? filename;
  final String? url;
  final String? mimeType;
  final int? size;
  final String? uploadedAt;
  final String? uploadedBy;

  LabResultAttachment({
    this.filename,
    this.url,
    this.mimeType,
    this.size,
    this.uploadedAt,
    this.uploadedBy,
  });

  factory LabResultAttachment.fromJson(Map<String, dynamic> json) {
    return LabResultAttachment(
      filename: json['filename']?.toString(),
      url: json['url']?.toString(),
      mimeType: json['mime_type']?.toString(),
      size: json['size'] is int ? json['size'] : null,
      uploadedAt: json['uploaded_at']?.toString(),
      uploadedBy: json['uploaded_by']?.toString(),
    );
  }
}

class LabResult {
  final String id;
  final String requestId;
  final String itemId;
  final String patientId;
  final String resultStatus;
  final String? resultText;
  final List<LabResultEntry> resultEntries;
  final String? notes;
  final List<LabResultAttachment> attachments;
  final String? enteredBy;
  final String? enteredAt;
  final String? verifiedBy;
  final String? verifiedAt;
  final String? createdAt;
  final String? updatedAt;

  LabResult({
    required this.id,
    required this.requestId,
    required this.itemId,
    required this.patientId,
    required this.resultStatus,
    this.resultText,
    this.resultEntries = const [],
    this.notes,
    this.attachments = const [],
    this.enteredBy,
    this.enteredAt,
    this.verifiedBy,
    this.verifiedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory LabResult.fromJson(Map<String, dynamic> json) {
    return LabResult(
      id: json['id']?.toString() ?? '',
      requestId: json['request_id']?.toString() ?? '',
      itemId: json['item_id']?.toString() ?? '',
      patientId: json['patient_id']?.toString() ?? '',
      resultStatus: json['result_status']?.toString() ?? 'Unknown',
      resultText: json['result_text']?.toString(),
      resultEntries: (json['result_entries'] as List<dynamic>?)
              ?.map((e) => LabResultEntry.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      notes: json['notes']?.toString(),
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map(
                  (e) => LabResultAttachment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      enteredBy: json['entered_by']?.toString(),
      enteredAt: json['entered_at']?.toString(),
      verifiedBy: json['verified_by']?.toString(),
      verifiedAt: json['verified_at']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  bool get isVerified => resultStatus.toLowerCase() == 'verified';
  bool get isEntered => resultStatus.toLowerCase() == 'entered';
}

/// Response for GET /api/v1/lab-test-requests/:id/items/:itemId/results
class LabResultItemResponse {
  final String requestId;
  final LabResultItemInfo item;
  final LabResult? result;

  LabResultItemResponse({
    required this.requestId,
    required this.item,
    this.result,
  });

  factory LabResultItemResponse.fromJson(Map<String, dynamic> json) {
    return LabResultItemResponse(
      requestId: json['request_id']?.toString() ?? '',
      item: LabResultItemInfo.fromJson(json['item'] as Map<String, dynamic>? ?? {}),
      result: json['result'] != null
          ? LabResult.fromJson(json['result'] as Map<String, dynamic>)
          : null,
    );
  }
}

class LabResultItemInfo {
  final String id;
  final String testCode;
  final String testName;
  final String itemStatus;

  LabResultItemInfo({
    required this.id,
    required this.testCode,
    required this.testName,
    required this.itemStatus,
  });

  factory LabResultItemInfo.fromJson(Map<String, dynamic> json) {
    return LabResultItemInfo(
      id: json['id']?.toString() ?? '',
      testCode: json['test_code']?.toString() ?? '',
      testName: json['test_name']?.toString() ?? '',
      itemStatus: json['item_status']?.toString() ?? 'Pending',
    );
  }
}

/// Response for GET /api/patients/:patientId/lab-results
class PatientLabResultsResponse {
  final String patientId;
  final int page;
  final int limit;
  final int total;
  final List<LabResult> results;

  PatientLabResultsResponse({
    required this.patientId,
    required this.page,
    required this.limit,
    required this.total,
    required this.results,
  });

  factory PatientLabResultsResponse.fromJson(Map<String, dynamic> json) {
    return PatientLabResultsResponse(
      patientId: json['patient_id']?.toString() ?? '',
      page: json['page'] is int ? json['page'] : 1,
      limit: json['limit'] is int ? json['limit'] : 20,
      total: json['total'] is int ? json['total'] : 0,
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => LabResult.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

