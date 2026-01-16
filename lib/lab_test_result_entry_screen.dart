import 'package:flutter/material.dart';
import 'models/lab_test_request_model.dart';
import 'services/api_service.dart';

enum LabResultFieldType { number, text, select, boolean }

class LabResultTemplate {
  final String id;
  final String name;
  final String category;
  final String description;
  final int version;
  final List<LabResultField> fields;
  final List<LabResultDetailProfile> detailProfiles;
  final TemplateMatchers matchers;

  const LabResultTemplate({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.version,
    required this.fields,
    required this.detailProfiles,
    required this.matchers,
  });

  factory LabResultTemplate.fromMap(Map<String, dynamic> map) {
    return LabResultTemplate(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      category: map['category']?.toString() ?? 'General',
      description: map['description']?.toString() ?? '',
      version: map['version'] is int ? map['version'] as int : 1,
      matchers: TemplateMatchers.fromMap(
        map['matchers'] as Map<String, dynamic>? ?? {},
      ),
      fields:
          (map['fields'] as List<dynamic>? ?? [])
              .map((field) => LabResultField.fromMap(field))
              .toList(),
      detailProfiles:
          (map['detailProfiles'] as List<dynamic>? ?? [])
              .map((profile) => LabResultDetailProfile.fromMap(profile))
              .toList(),
    );
  }
}

class TemplateMatchers {
  final List<String> testCodes;
  final List<String> testNames;

  const TemplateMatchers({required this.testCodes, required this.testNames});

  factory TemplateMatchers.fromMap(Map<String, dynamic> map) {
    return TemplateMatchers(
      testCodes:
          (map['testCodes'] as List<dynamic>? ?? [])
              .map((value) => value.toString().toLowerCase().trim())
              .toList(),
      testNames:
          (map['testNames'] as List<dynamic>? ?? [])
              .map((value) => value.toString().toLowerCase().trim())
              .toList(),
    );
  }
}

class LabResultDetailProfile {
  final String id;
  final String name;
  final String? description;
  final List<LabResultField> fields;

  const LabResultDetailProfile({
    required this.id,
    required this.name,
    this.description,
    required this.fields,
  });

  factory LabResultDetailProfile.fromMap(Map<String, dynamic> map) {
    return LabResultDetailProfile(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      description: map['description']?.toString(),
      fields:
          (map['fields'] as List<dynamic>? ?? [])
              .map((field) => LabResultField.fromMap(field))
              .toList(),
    );
  }
}

class LabResultField {
  final String id;
  final String label;
  final LabResultFieldType type;
  final String? unit;
  final bool requiredField;
  final String? helpText;
  final List<String> options;
  final List<ReferenceRange> referenceRanges;

  const LabResultField({
    required this.id,
    required this.label,
    required this.type,
    this.unit,
    this.requiredField = false,
    this.helpText,
    this.options = const [],
    this.referenceRanges = const [],
  });

  factory LabResultField.fromMap(Map<String, dynamic> map) {
    final typeString = map['type']?.toString().toLowerCase() ?? 'text';
    final type = switch (typeString) {
      'number' || 'numeric' => LabResultFieldType.number,
      'select' || 'dropdown' => LabResultFieldType.select,
      'boolean' || 'bool' => LabResultFieldType.boolean,
      _ => LabResultFieldType.text,
    };

    return LabResultField(
      id: map['id']?.toString() ?? '',
      label: map['label']?.toString() ?? '',
      type: type,
      unit: map['unit']?.toString(),
      requiredField: map['required'] == true,
      helpText: map['helpText']?.toString(),
      options:
          (map['options'] as List<dynamic>? ?? [])
              .map((value) => value.toString())
              .toList(),
      referenceRanges:
          (map['referenceRanges'] as List<dynamic>? ?? [])
              .map((value) => ReferenceRange.fromMap(value))
              .toList(),
    );
  }
}

class ReferenceRange {
  final double? min;
  final double? max;
  final int? ageMin;
  final int? ageMax;
  final String? sex;
  final String? note;

  const ReferenceRange({
    this.min,
    this.max,
    this.ageMin,
    this.ageMax,
    this.sex,
    this.note,
  });

  factory ReferenceRange.fromMap(Map<String, dynamic> map) {
    double? parseNum(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString());
    }

    return ReferenceRange(
      min: parseNum(map['min']),
      max: parseNum(map['max']),
      ageMin: map['ageMin'] is int ? map['ageMin'] as int : null,
      ageMax: map['ageMax'] is int ? map['ageMax'] as int : null,
      sex: map['sex']?.toString().toLowerCase(),
      note: map['note']?.toString(),
    );
  }

  bool matches({int? age, String? sex}) {
    final normalizedSex = sex?.toLowerCase();
    final sexMatches =
        this.sex == null ||
        this.sex == 'any' ||
        normalizedSex == null ||
        normalizedSex.isEmpty ||
        this.sex == normalizedSex;
    final ageMatches =
        age == null ||
        ((ageMin == null || age >= ageMin!) &&
            (ageMax == null || age <= ageMax!));
    return sexMatches && ageMatches;
  }

  String display(String? unit) {
    final rangeText =
        min != null && max != null
            ? '${_formatNumber(min!)} - ${_formatNumber(max!)}'
            : min != null
            ? '>= ${_formatNumber(min!)}'
            : max != null
            ? '<= ${_formatNumber(max!)}'
            : 'Reference per lab';
    final unitText = unit == null || unit.isEmpty ? '' : ' $unit';
    final ageText =
        ageMin != null || ageMax != null
            ? ' (${ageMin ?? 0}-${ageMax ?? '+'} yrs)'
            : '';
    final sexText =
        sex != null && sex!.isNotEmpty && sex != 'any'
            ? ' ${sex![0].toUpperCase()}${sex!.substring(1)}'
            : '';
    final noteText = note != null && note!.isNotEmpty ? ' · $note' : '';
    return '$rangeText$unitText$sexText$ageText$noteText';
  }
}

class LabAnalyteDefinition {
  final String id;
  final String name;
  final String category;
  final LabResultFieldType type;
  final String? unit;
  final List<String> options;
  final List<String> aliases;
  final List<ReferenceRange> referenceRanges;

  const LabAnalyteDefinition({
    required this.id,
    required this.name,
    required this.category,
    required this.type,
    this.unit,
    this.options = const [],
    this.aliases = const [],
    this.referenceRanges = const [],
  });

  factory LabAnalyteDefinition.fromMap(Map<String, dynamic> map) {
    final typeString = map['type']?.toString().toLowerCase() ?? 'number';
    final type = switch (typeString) {
      'number' || 'numeric' => LabResultFieldType.number,
      'select' || 'dropdown' => LabResultFieldType.select,
      'boolean' || 'bool' => LabResultFieldType.boolean,
      _ => LabResultFieldType.text,
    };
    return LabAnalyteDefinition(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      category: map['category']?.toString() ?? 'General',
      type: type,
      unit: map['unit']?.toString(),
      options:
          (map['options'] as List<dynamic>? ?? [])
              .map((value) => value.toString())
              .toList(),
      aliases:
          (map['aliases'] as List<dynamic>? ?? [])
              .map((value) => value.toString().toLowerCase())
              .toList(),
      referenceRanges:
          (map['referenceRanges'] as List<dynamic>? ?? [])
              .map((value) => ReferenceRange.fromMap(value))
              .toList(),
    );
  }
}

class LabAnalyteCatalog {
  static final List<LabAnalyteDefinition> items =
      _analyteCatalogDefinitions
          .map((definition) => LabAnalyteDefinition.fromMap(definition))
          .toList();

  static LabAnalyteDefinition? suggestForField(LabResultField field) {
    final label = field.label.toLowerCase();
    for (final analyte in items) {
      if (label == analyte.name.toLowerCase()) {
        return analyte;
      }
      if (label.contains(analyte.name.toLowerCase())) {
        return analyte;
      }
      if (analyte.aliases.any((alias) => label.contains(alias))) {
        return analyte;
      }
      if (field.id.toLowerCase() == analyte.id.toLowerCase()) {
        return analyte;
      }
    }
    return null;
  }
}

class LabResultEntryData {
  final String requestId;
  final String testId;
  final String patientId;
  final String templateId;
  final int templateVersion;
  final String capturedAt;
  final Map<String, dynamic> values;
  final String? comments;

  LabResultEntryData({
    required this.requestId,
    required this.testId,
    required this.patientId,
    required this.templateId,
    required this.templateVersion,
    required this.capturedAt,
    required this.values,
    this.comments,
  });

  Map<String, dynamic> toJson() {
    return {
      'request_id': requestId,
      'test_id': testId,
      'patient_id': patientId,
      'template_id': templateId,
      'template_version': templateVersion,
      'captured_at': capturedAt,
      'values': values,
      'comments': comments,
    };
  }
}

class LabResultTemplateRegistry {
  static final List<LabResultTemplate> templates =
      _templateDefinitions
          .map((definition) => LabResultTemplate.fromMap(definition))
          .toList();

  static LabResultTemplate templateForTest(TestItem test) {
    final code = test.testCode.toLowerCase().trim();
    final name = test.testName.toLowerCase().trim();
    for (final template in templates) {
      if (template.matchers.testCodes.contains(code) ||
          template.matchers.testNames.any((match) => name.contains(match))) {
        return template;
      }
    }
    return templates.firstWhere((template) => template.id == 'generic');
  }
}

class LabTestResultEntryScreen extends StatefulWidget {
  final LabTestRequest request;
  final TestItem test;

  const LabTestResultEntryScreen({
    super.key,
    required this.request,
    required this.test,
  });

  @override
  State<LabTestResultEntryScreen> createState() =>
      _LabTestResultEntryScreenState();
}

class _LabTestResultEntryScreenState extends State<LabTestResultEntryScreen> {
  late LabResultTemplate _template;
  LabResultDetailProfile? _selectedProfile;
  final Map<String, TextEditingController> _textControllers = {};
  final Map<String, dynamic> _fieldValues = {};
  final Map<String, LabAnalyteDefinition?> _selectedAnalytes = {};
  final TextEditingController _commentsController = TextEditingController();
  final List<LabResultField> _customFields = [];
  bool _showTableView = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _template = LabResultTemplateRegistry.templateForTest(widget.test);
    _selectedProfile =
        _template.detailProfiles.isNotEmpty
            ? _template.detailProfiles.first
            : null;
    _initializeFieldControllers();
  }

  @override
  void dispose() {
    for (final controller in _textControllers.values) {
      controller.dispose();
    }
    _commentsController.dispose();
    super.dispose();
  }

  void _initializeFieldControllers() {
    _textControllers.clear();
    _fieldValues.clear();
    for (final field in _allFields) {
      if (field.type == LabResultFieldType.text ||
          field.type == LabResultFieldType.number) {
        _textControllers[field.id] = TextEditingController();
      } else if (field.type == LabResultFieldType.select &&
          field.options.isNotEmpty) {
        _fieldValues[field.id] = field.options.first;
      } else if (field.type == LabResultFieldType.boolean) {
        _fieldValues[field.id] = false;
      }
      _selectedAnalytes[field.id] ??= LabAnalyteCatalog.suggestForField(field);
    }
  }

  List<LabResultField> get _allFields => [
    ...(_selectedProfile?.fields ?? _template.fields),
    ..._customFields,
  ];

  void _changeTemplate(LabResultTemplate template) {
    setState(() {
      _template = template;
      _selectedProfile =
          template.detailProfiles.isNotEmpty
              ? template.detailProfiles.first
              : null;
      _customFields.clear();
      _selectedAnalytes.clear();
      _initializeFieldControllers();
    });
  }

  void _changeProfile(LabResultDetailProfile? profile) {
    if (profile == null || profile.id == _selectedProfile?.id) return;
    setState(() {
      _selectedProfile = profile;
      _customFields.clear();
      _selectedAnalytes.clear();
      _initializeFieldControllers();
    });
  }

  void _addCustomField() {
    final labelController = TextEditingController();
    LabResultFieldType selectedType = LabResultFieldType.text;
    String? unit;

    showDialog<void>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add custom result field'),
            content: SizedBox(
              width: 360,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: labelController,
                    decoration: const InputDecoration(
                      labelText: 'Field label',
                      hintText: 'e.g. ESR, Appearance',
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<LabResultFieldType>(
                    value: selectedType,
                    decoration: const InputDecoration(labelText: 'Field type'),
                    items:
                        LabResultFieldType.values
                            .map(
                              (value) => DropdownMenuItem(
                                value: value,
                                child: Text(_fieldTypeLabel(value)),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        selectedType = value;
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Unit (optional)',
                    ),
                    onChanged: (value) => unit = value,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final label = labelController.text.trim();
                  if (label.isEmpty) return;
                  setState(() {
                    _customFields.add(
                      LabResultField(
                        id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
                        label: label,
                        type: selectedType,
                        unit: unit?.trim().isEmpty == true ? null : unit,
                      ),
                    );
                    _initializeFieldControllers();
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('Add'),
              ),
            ],
          ),
    );
  }

  ReferenceRange? _matchingRange(LabResultField field) {
    if (field.referenceRanges.isEmpty) return null;
    final age = widget.request.patient.age;
    final sex = widget.request.patient.gender;
    final candidates =
        field.referenceRanges.where((range) {
          return range.matches(age: age, sex: sex);
        }).toList();
    return candidates.isNotEmpty
        ? candidates.first
        : field.referenceRanges.first;
  }

  ReferenceRange? _matchingRangeForRanges(List<ReferenceRange> ranges) {
    if (ranges.isEmpty) return null;
    final age = widget.request.patient.age;
    final sex = widget.request.patient.gender;
    final candidates =
        ranges.where((range) => range.matches(age: age, sex: sex)).toList();
    return candidates.isNotEmpty ? candidates.first : ranges.first;
  }

  String? _rangeStatus(LabResultField field, String? valueText) {
    if (field.type != LabResultFieldType.number) return null;
    final value = double.tryParse(valueText ?? '');
    final range = _matchingRange(field);
    if (value == null || range == null) return null;
    if (range.min != null && value < range.min!) return 'Low';
    if (range.max != null && value > range.max!) return 'High';
    return 'Normal';
  }

  String? _rangeStatusForRanges(
    List<ReferenceRange> ranges,
    LabResultFieldType type,
    String? valueText,
  ) {
    if (type != LabResultFieldType.number) return null;
    final value = double.tryParse(valueText ?? '');
    final range = _matchingRangeForRanges(ranges);
    if (value == null || range == null) return null;
    if (range.min != null && value < range.min!) return 'Low';
    if (range.max != null && value > range.max!) return 'High';
    return 'Normal';
  }

  Color _rangeStatusColor(String status) {
    switch (status) {
      case 'Low':
        return const Color(0xFFDC2626);
      case 'High':
        return const Color(0xFFF59E0B);
      case 'Normal':
        return const Color(0xFF059669);
      default:
        return const Color(0xFF6B7280);
    }
  }

  String? _fieldValueForApi(LabResultField field) {
    dynamic rawValue;
    if (field.type == LabResultFieldType.text ||
        field.type == LabResultFieldType.number) {
      rawValue = _textControllers[field.id]?.text.trim();
    } else {
      rawValue = _fieldValues[field.id];
    }
    if (rawValue == null) return null;
    if (rawValue is String) {
      final trimmed = rawValue.trim();
      return trimmed.isEmpty ? null : trimmed;
    }
    return rawValue.toString();
  }

  List<Map<String, dynamic>> _buildResultEntries() {
    final entries = <Map<String, dynamic>>[];
    for (final field in _allFields) {
      final valueText = _fieldValueForApi(field);
      if (valueText == null) continue;
      final analyte =
          _selectedAnalytes[field.id] ??
          LabAnalyteCatalog.suggestForField(field);
      final unit = analyte?.unit ?? field.unit;
      final ranges = analyte?.referenceRanges ?? field.referenceRanges;
      final referenceRange = _matchingRangeForRanges(ranges);
      final referenceRangeText = referenceRange?.display(unit);
      final flag = _rangeStatusForRanges(
        ranges,
        analyte?.type ?? field.type,
        valueText,
      );
      entries.add({
        'analyte_code': analyte?.id ?? field.id,
        'analyte_name': analyte?.name ?? field.label,
        'value': valueText,
        if (unit != null && unit.isNotEmpty) 'unit': unit,
        if (referenceRangeText != null) 'reference_range': referenceRangeText,
        if (flag != null) 'flag': flag,
      });
    }
    return entries;
  }

  Future<void> _saveResults({required String resultStatus}) async {
    if (_isSaving) return;
    setState(() {
      _isSaving = true;
    });

    final resultText = _commentsController.text.trim();
    final resultEntries = _buildResultEntries();

    try {
      final nowIso = DateTime.now().toUtc().toIso8601String();
      final response = await ApiService.saveLabTestResult(
        widget.request.id,
        widget.test.id,
        resultStatus: resultStatus,
        enteredAt: nowIso,
        verifiedAt: resultStatus == 'Verified' ? nowIso : null,
        resultText: resultText.isEmpty ? null : resultText,
        resultEntries: resultEntries,
        patientId: widget.request.patient.id,
      );

      if (response.success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                resultStatus == 'Verified'
                    ? 'Result verified for ${widget.test.testName}'
                    : 'Result saved for ${widget.test.testName}',
              ),
              backgroundColor: const Color(0xFF059669),
            ),
          );
          Navigator.of(context).pop(true);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Failed to save result: ${response.error ?? "Unknown error"}',
              ),
              backgroundColor: const Color(0xFFDC2626),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving result: ${e.toString()}'),
            backgroundColor: const Color(0xFFDC2626),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final patient = widget.request.patient;
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'Enter Lab Result',
          style: TextStyle(color: Color(0xFF111827)),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF111827)),
      ),
      body: Column(
        children: [
          _buildHeader(patient),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTemplateCard(),
                  const SizedBox(height: 16),
                  _buildResultFields(),
                  const SizedBox(height: 16),
                  _buildCommentsCard(),
                  const SizedBox(height: 24),
                  _buildActions(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(PatientInfo patient) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.science, color: Color(0xFF2563EB)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.test.testName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Patient: ${patient.name} • MRN ${patient.mrn}',
                  style: const TextStyle(color: Color(0xFF6B7280)),
                ),
                const SizedBox(height: 4),
                Text(
                  patient.demographics ??
                      '${patient.gender ?? 'Unknown'}, ${patient.age ?? '-'} yrs',
                  style: const TextStyle(color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              widget.test.itemStatus,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF374151),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Template',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: _addCustomField,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add custom field'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildTemplatePicker(),
          const SizedBox(height: 12),
          DropdownButtonFormField<LabResultTemplate>(
            value: _template,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF9FAFB),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
            items:
                LabResultTemplateRegistry.templates
                    .map(
                      (template) => DropdownMenuItem(
                        value: template,
                        child: Text(template.name),
                      ),
                    )
                    .toList(),
            onChanged: (value) {
              if (value != null && value.id != _template.id) {
                _changeTemplate(value);
              }
            },
          ),
          const SizedBox(height: 10),
          if (_template.detailProfiles.isNotEmpty) _buildProfileSelector(),
          const SizedBox(height: 8),
          Text(
            _selectedProfile?.description ?? _template.description,
            style: const TextStyle(color: Color(0xFF6B7280)),
          ),
          const SizedBox(height: 6),
          Text(
            'Category: ${_template.category} • Version ${_template.version}',
            style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSelector() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Result Detail Set',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<LabResultDetailProfile>(
            value: _selectedProfile,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
            items:
                _template.detailProfiles
                    .map(
                      (profile) => DropdownMenuItem(
                        value: profile,
                        child: Text(profile.name),
                      ),
                    )
                    .toList(),
            onChanged: _changeProfile,
          ),
          if (_selectedProfile?.description != null) ...[
            const SizedBox(height: 6),
            Text(
              _selectedProfile!.description!,
              style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTemplatePicker() {
    return SizedBox(
      height: 128,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: LabResultTemplateRegistry.templates.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final template = LabResultTemplateRegistry.templates[index];
          final isSelected = template.id == _template.id;
          final isMatch =
              LabResultTemplateRegistry.templateForTest(widget.test).id ==
              template.id;
          return _buildTemplateTile(template, isSelected, isMatch);
        },
      ),
    );
  }

  Widget _buildTemplateTile(
    LabResultTemplate template,
    bool isSelected,
    bool isMatch,
  ) {
    final color = _templateColor(template.category);
    return InkWell(
      onTap: () => _changeTemplate(template),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 220,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.12) : const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : const Color(0xFFE5E7EB),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _templateIcon(template.category),
                    color: color,
                    size: 18,
                  ),
                ),
                const Spacer(),
                if (isMatch)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDBEAFE),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Recommended',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              template.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              template.category,
              style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
            ),
            const Spacer(),
            Text(
              '${template.fields.length} fields • v${template.version}',
              style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultFields() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Result Data',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
              ),
              const Spacer(),
              _buildViewToggle(
                label: 'Table',
                icon: Icons.table_rows,
                isActive: _showTableView,
                onTap: () => setState(() => _showTableView = true),
              ),
              const SizedBox(width: 8),
              _buildViewToggle(
                label: 'Cards',
                icon: Icons.view_agenda_outlined,
                isActive: !_showTableView,
                onTap: () => setState(() => _showTableView = false),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _showTableView ? _buildTableFields() : _buildCardFields(),
        ],
      ),
    );
  }

  Widget _buildViewToggle({
    required String label,
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF2563EB) : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 14,
              color: isActive ? Colors.white : Colors.black54,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.white : const Color(0xFF374151),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardFields() {
    return Column(children: _allFields.map(_buildFieldCard).toList());
  }

  Widget _buildTableFields() {
    final fields = _allFields;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              const Expanded(flex: 3, child: Text('Analyte')),
              const Expanded(flex: 3, child: Text('Result')),
              const Expanded(flex: 2, child: Text('Unit')),
              const Expanded(flex: 3, child: Text('Reference')),
              const Expanded(flex: 2, child: Text('Flag')),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: _addCustomRow,
                    icon: const Icon(Icons.add_circle_outline, size: 16),
                    label: const Text('Add'),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF2563EB),
                      textStyle: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        ...List.generate(
          fields.length,
          (index) => _buildTableRow(fields[index], index),
        ),
      ],
    );
  }

  Widget _buildFieldCard(LabResultField field) {
    final controller = _textControllers[field.id];
    final referenceRange = _matchingRange(field);
    final status =
        controller != null ? _rangeStatus(field, controller.text) : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  field.label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
              ),
              if (status != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _rangeStatusColor(status).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _rangeStatusColor(status),
                    ),
                  ),
                ),
            ],
          ),
          if (field.helpText != null) ...[
            const SizedBox(height: 6),
            Text(
              field.helpText!,
              style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12),
            ),
          ],
          const SizedBox(height: 10),
          _buildFieldInput(field),
          if (referenceRange != null) ...[
            const SizedBox(height: 8),
            Text(
              'Reference: ${referenceRange.display(field.unit)}',
              style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTableRow(LabResultField field, int index) {
    final selectedAnalyte = _selectedAnalytes[field.id];
    final analyteType = selectedAnalyte?.type ?? field.type;
    final analyteUnit = selectedAnalyte?.unit ?? field.unit;
    final analyteRanges =
        selectedAnalyte?.referenceRanges ?? field.referenceRanges;
    final controller = _textControllers[field.id];
    final referenceRange = _matchingRangeForRanges(analyteRanges);
    final status =
        controller != null
            ? _rangeStatusForRanges(analyteRanges, analyteType, controller.text)
            : null;
    final statusTint =
        status == 'Low'
            ? const Color(0xFFFEE2E2)
            : status == 'High'
            ? const Color(0xFFFEF3C7)
            : status == 'Normal'
            ? const Color(0xFFDCFCE7)
            : null;
    final rowColor = index.isEven ? Colors.white : const Color(0xFFF9FAFB);
    final analyteColor = _analyteColor(selectedAnalyte?.category);
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: statusTint ?? rowColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 28,
                  decoration: BoxDecoration(
                    color: analyteColor.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<LabAnalyteDefinition>(
                    value: selectedAnalyte,
                    isExpanded: true,
                    isDense: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                    ),
                    items:
                        LabAnalyteCatalog.items
                            .map(
                              (analyte) => DropdownMenuItem(
                                value: analyte,
                                child: SizedBox(
                                  width: 180,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: _analyteColor(
                                            analyte.category,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          analyte.name,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => _selectedAnalytes[field.id] = value);
                    },
                    hint: Text(
                      field.label,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: _buildTableInput(field, analyte: selectedAnalyte),
          ),
          Expanded(
            flex: 2,
            child: Text(
              analyteUnit ?? '-',
              style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              referenceRange?.display(analyteUnit) ?? '-',
              style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
            ),
          ),
          Expanded(
            flex: 2,
            child:
                status == null
                    ? const Text(
                      '-',
                      style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
                    )
                    : Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _rangeStatusColor(status).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: _rangeStatusColor(status),
                        ),
                      ),
                    ),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerRight,
              child:
                  _isCustomField(field)
                      ? IconButton(
                        tooltip: 'Remove row',
                        icon: const Icon(Icons.close, size: 18),
                        color: const Color(0xFFEF4444),
                        onPressed: () => _removeCustomRow(field),
                      )
                      : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableInput(
    LabResultField field, {
    LabAnalyteDefinition? analyte,
  }) {
    final effectiveType = analyte?.type ?? field.type;
    final effectiveOptions = analyte?.options ?? field.options;
    switch (effectiveType) {
      case LabResultFieldType.number:
      case LabResultFieldType.text:
        return TextField(
          controller: _textControllers[field.id],
          keyboardType:
              effectiveType == LabResultFieldType.number
                  ? TextInputType.number
                  : TextInputType.text,
          decoration: InputDecoration(
            isDense: true,
            hintText: 'Value',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),
          ),
          onChanged: (_) => setState(() {}),
        );
      case LabResultFieldType.select:
        return DropdownButtonFormField<String>(
          value: _fieldValues[field.id],
          isDense: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          ),
          items:
              effectiveOptions
                  .map(
                    (value) => DropdownMenuItem(
                      value: value,
                      child: Text(value, overflow: TextOverflow.ellipsis),
                    ),
                  )
                  .toList(),
          onChanged: (value) => setState(() => _fieldValues[field.id] = value),
        );
      case LabResultFieldType.boolean:
        final value = _fieldValues[field.id] == true;
        return DropdownButtonFormField<bool>(
          value: value,
          isDense: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          ),
          items: const [
            DropdownMenuItem(value: true, child: Text('Yes')),
            DropdownMenuItem(value: false, child: Text('No')),
          ],
          onChanged: (next) => setState(() => _fieldValues[field.id] = next),
        );
    }
  }

  bool _isCustomField(LabResultField field) {
    return _customFields.any((custom) => custom.id == field.id);
  }

  void _addCustomRow() {
    setState(() {
      final field = LabResultField(
        id: 'custom_row_${DateTime.now().millisecondsSinceEpoch}',
        label: 'Custom Analyte',
        type: LabResultFieldType.number,
      );
      _customFields.add(field);
      _initializeFieldControllers();
    });
  }

  void _removeCustomRow(LabResultField field) {
    setState(() {
      _customFields.removeWhere((custom) => custom.id == field.id);
      _textControllers.remove(field.id)?.dispose();
      _fieldValues.remove(field.id);
      _selectedAnalytes.remove(field.id);
    });
  }

  Widget _buildFieldInput(LabResultField field) {
    switch (field.type) {
      case LabResultFieldType.number:
        return TextField(
          controller: _textControllers[field.id],
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Enter value',
            suffixText: field.unit,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
          onChanged: (_) => setState(() {}),
        );
      case LabResultFieldType.select:
        return DropdownButtonFormField<String>(
          value: _fieldValues[field.id],
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          items:
              field.options
                  .map(
                    (value) =>
                        DropdownMenuItem(value: value, child: Text(value)),
                  )
                  .toList(),
          onChanged: (value) => setState(() => _fieldValues[field.id] = value),
        );
      case LabResultFieldType.boolean:
        final value = _fieldValues[field.id] == true;
        return SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(value ? 'Yes' : 'No'),
          value: value,
          onChanged: (next) => setState(() => _fieldValues[field.id] = next),
        );
      case LabResultFieldType.text:
        return TextField(
          controller: _textControllers[field.id],
          decoration: InputDecoration(
            hintText: 'Enter text',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        );
    }
  }

  Widget _buildCommentsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Comments',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _commentsController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Add observations, flags, or lab notes',
              filled: true,
              fillColor: const Color(0xFFF9FAFB),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed:
                _isSaving ? null : () => _saveResults(resultStatus: 'Entered'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              backgroundColor: const Color(0xFF2563EB),
            ),
            child:
                _isSaving
                    ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                    : const Text(
                      'Save Result',
                      style: TextStyle(color: Colors.white),
                    ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed:
                _isSaving ? null : () => _saveResults(resultStatus: 'Verified'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              backgroundColor: const Color(0xFF059669),
            ),
            child:
                _isSaving
                    ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                    : const Text(
                      'Verify Result',
                      style: TextStyle(color: Colors.white),
                    ),
          ),
        ),
      ],
    );
  }
}

String _fieldTypeLabel(LabResultFieldType type) {
  switch (type) {
    case LabResultFieldType.number:
      return 'Numeric';
    case LabResultFieldType.select:
      return 'Select list';
    case LabResultFieldType.boolean:
      return 'Yes/No';
    case LabResultFieldType.text:
      return 'Text';
  }
}

String _formatNumber(double value) {
  return value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 2);
}

IconData _templateIcon(String category) {
  switch (category.toLowerCase()) {
    case 'hematology':
      return Icons.opacity;
    case 'biochemistry':
      return Icons.science;
    case 'urinalysis':
      return Icons.water_drop;
    case 'serology':
      return Icons.biotech;
    case 'lipid':
      return Icons.favorite;
    case 'endocrine':
      return Icons.monitor_heart;
    case 'microbiology':
      return Icons.bug_report;
    case 'immunology':
      return Icons.shield;
    default:
      return Icons.assignment;
  }
}

Color _templateColor(String category) {
  switch (category.toLowerCase()) {
    case 'hematology':
      return const Color(0xFFDC2626);
    case 'biochemistry':
      return const Color(0xFF2563EB);
    case 'urinalysis':
      return const Color(0xFF059669);
    case 'serology':
      return const Color(0xFF7C3AED);
    case 'lipid':
      return const Color(0xFFF59E0B);
    case 'endocrine':
      return const Color(0xFF0EA5E9);
    case 'microbiology':
      return const Color(0xFF16A34A);
    case 'immunology':
      return const Color(0xFF8B5CF6);
    default:
      return const Color(0xFF6B7280);
  }
}

Color _analyteColor(String? category) {
  switch ((category ?? '').toLowerCase()) {
    case 'lipid':
      return const Color(0xFFF59E0B);
    case 'hematology':
      return const Color(0xFFDC2626);
    case 'biochemistry':
      return const Color(0xFF2563EB);
    case 'endocrine':
      return const Color(0xFF0EA5E9);
    case 'immunology':
      return const Color(0xFF8B5CF6);
    case 'urinalysis':
      return const Color(0xFF059669);
    case 'renal':
      return const Color(0xFF16A34A);
    case 'liver':
      return const Color(0xFF7C3AED);
    default:
      return const Color(0xFF6B7280);
  }
}

const List<Map<String, dynamic>> _templateDefinitions = [
  {
    'id': 'cbc',
    'name': 'Complete Blood Count (CBC)',
    'category': 'Hematology',
    'description':
        'Standard CBC panel with automated reference ranges by age and sex.',
    'version': 2,
    'matchers': {
      'testCodes': ['CBC', 'FBC'],
      'testNames': ['complete blood count', 'full blood count'],
    },
    'detailProfiles': [
      {
        'id': 'cbc_standard',
        'name': 'Standard CBC',
        'description': 'Core CBC analytes with basic morphology.',
        'fields': [
          {
            'id': 'hgb',
            'label': 'Hemoglobin',
            'type': 'number',
            'unit': 'g/dL',
            'required': true,
            'referenceRanges': [
              {
                'sex': 'male',
                'ageMin': 18,
                'ageMax': 150,
                'min': 13.5,
                'max': 17.5,
              },
              {
                'sex': 'female',
                'ageMin': 18,
                'ageMax': 150,
                'min': 12.0,
                'max': 15.5,
              },
              {
                'sex': 'any',
                'ageMin': 1,
                'ageMax': 17,
                'min': 11.0,
                'max': 16.0,
              },
            ],
          },
          {
            'id': 'wbc',
            'label': 'White Blood Cells',
            'type': 'number',
            'unit': 'x10^9/L',
            'required': true,
            'referenceRanges': [
              {
                'sex': 'any',
                'ageMin': 18,
                'ageMax': 150,
                'min': 4.0,
                'max': 11.0,
              },
            ],
          },
          {
            'id': 'platelets',
            'label': 'Platelets',
            'type': 'number',
            'unit': 'x10^9/L',
            'required': true,
            'referenceRanges': [
              {
                'sex': 'any',
                'ageMin': 18,
                'ageMax': 150,
                'min': 150,
                'max': 450,
              },
            ],
          },
          {
            'id': 'hematocrit',
            'label': 'Hematocrit',
            'type': 'number',
            'unit': '%',
            'referenceRanges': [
              {
                'sex': 'male',
                'ageMin': 18,
                'ageMax': 150,
                'min': 41,
                'max': 53,
              },
              {
                'sex': 'female',
                'ageMin': 18,
                'ageMax': 150,
                'min': 36,
                'max': 46,
              },
            ],
          },
          {
            'id': 'rbc_morphology',
            'label': 'RBC Morphology',
            'type': 'select',
            'options': [
              'Normal',
              'Microcytosis',
              'Macrocytosis',
              'Anisocytosis',
            ],
          },
        ],
      },
      {
        'id': 'cbc_differential',
        'name': 'CBC + Differential',
        'description': 'Adds WBC differential counts for clinical review.',
        'fields': [
          {
            'id': 'hgb',
            'label': 'Hemoglobin',
            'type': 'number',
            'unit': 'g/dL',
            'required': true,
          },
          {
            'id': 'wbc',
            'label': 'White Blood Cells',
            'type': 'number',
            'unit': 'x10^9/L',
            'required': true,
          },
          {
            'id': 'platelets',
            'label': 'Platelets',
            'type': 'number',
            'unit': 'x10^9/L',
            'required': true,
          },
          {
            'id': 'hematocrit',
            'label': 'Hematocrit',
            'type': 'number',
            'unit': '%',
          },
          {
            'id': 'neutrophils',
            'label': 'Neutrophils',
            'type': 'number',
            'unit': '%',
          },
          {
            'id': 'lymphocytes',
            'label': 'Lymphocytes',
            'type': 'number',
            'unit': '%',
          },
          {
            'id': 'monocytes',
            'label': 'Monocytes',
            'type': 'number',
            'unit': '%',
          },
          {
            'id': 'eosinophils',
            'label': 'Eosinophils',
            'type': 'number',
            'unit': '%',
          },
          {
            'id': 'basophils',
            'label': 'Basophils',
            'type': 'number',
            'unit': '%',
          },
          {
            'id': 'rbc_morphology',
            'label': 'RBC Morphology',
            'type': 'select',
            'options': [
              'Normal',
              'Microcytosis',
              'Macrocytosis',
              'Anisocytosis',
            ],
          },
        ],
      },
    ],
    'fields': [
      {
        'id': 'hgb',
        'label': 'Hemoglobin',
        'type': 'number',
        'unit': 'g/dL',
        'required': true,
        'referenceRanges': [
          {
            'sex': 'male',
            'ageMin': 18,
            'ageMax': 150,
            'min': 13.5,
            'max': 17.5,
          },
          {
            'sex': 'female',
            'ageMin': 18,
            'ageMax': 150,
            'min': 12.0,
            'max': 15.5,
          },
          {'sex': 'any', 'ageMin': 1, 'ageMax': 17, 'min': 11.0, 'max': 16.0},
        ],
      },
      {
        'id': 'wbc',
        'label': 'White Blood Cells',
        'type': 'number',
        'unit': 'x10^9/L',
        'required': true,
        'referenceRanges': [
          {'sex': 'any', 'ageMin': 18, 'ageMax': 150, 'min': 4.0, 'max': 11.0},
        ],
      },
      {
        'id': 'platelets',
        'label': 'Platelets',
        'type': 'number',
        'unit': 'x10^9/L',
        'required': true,
        'referenceRanges': [
          {'sex': 'any', 'ageMin': 18, 'ageMax': 150, 'min': 150, 'max': 450},
        ],
      },
      {
        'id': 'rbc_morphology',
        'label': 'RBC Morphology',
        'type': 'select',
        'options': ['Normal', 'Microcytosis', 'Macrocytosis', 'Anisocytosis'],
      },
    ],
  },
  {
    'id': 'creatinine',
    'name': 'Serum Creatinine',
    'category': 'Biochemistry',
    'description':
        'Single-analyte renal marker with sex-specific reference ranges.',
    'version': 1,
    'matchers': {
      'testCodes': ['CRE', 'CREAT'],
      'testNames': ['creatinine'],
    },
    'fields': [
      {
        'id': 'creatinine',
        'label': 'Creatinine',
        'type': 'number',
        'unit': 'mg/dL',
        'required': true,
        'referenceRanges': [
          {'sex': 'male', 'ageMin': 18, 'ageMax': 150, 'min': 0.7, 'max': 1.3},
          {
            'sex': 'female',
            'ageMin': 18,
            'ageMax': 150,
            'min': 0.6,
            'max': 1.1,
          },
        ],
      },
      {
        'id': 'egfr',
        'label': 'eGFR',
        'type': 'number',
        'unit': 'mL/min/1.73m2',
        'helpText': 'If calculated, enter the derived value.',
      },
    ],
  },
  {
    'id': 'urinalysis',
    'name': 'Urinalysis',
    'category': 'Urinalysis',
    'description':
        'Dipstick and microscopy panel with customizable observations.',
    'version': 3,
    'matchers': {
      'testCodes': ['UA'],
      'testNames': ['urinalysis', 'urine routine'],
    },
    'detailProfiles': [
      {
        'id': 'ua_dipstick',
        'name': 'Dipstick',
        'description': 'Chemical urinalysis panel results.',
        'fields': [
          {
            'id': 'appearance',
            'label': 'Appearance',
            'type': 'select',
            'options': ['Clear', 'Turbid', 'Cloudy', 'Bloody'],
          },
          {
            'id': 'protein',
            'label': 'Protein',
            'type': 'select',
            'options': ['Negative', 'Trace', '+1', '+2', '+3'],
          },
          {
            'id': 'glucose',
            'label': 'Glucose',
            'type': 'select',
            'options': ['Negative', 'Trace', '+1', '+2', '+3'],
          },
          {
            'id': 'ketones',
            'label': 'Ketones',
            'type': 'select',
            'options': ['Negative', 'Trace', '+1', '+2', '+3'],
          },
        ],
      },
      {
        'id': 'ua_microscopy',
        'name': 'Microscopy',
        'description': 'Microscopic urine sediment findings.',
        'fields': [
          {
            'id': 'wbc_hpf',
            'label': 'WBC / HPF',
            'type': 'number',
            'unit': 'cells',
            'referenceRanges': [
              {'sex': 'any', 'ageMin': 18, 'ageMax': 150, 'min': 0, 'max': 5},
            ],
          },
          {
            'id': 'rbc_hpf',
            'label': 'RBC / HPF',
            'type': 'number',
            'unit': 'cells',
            'referenceRanges': [
              {'sex': 'any', 'ageMin': 18, 'ageMax': 150, 'min': 0, 'max': 3},
            ],
          },
          {
            'id': 'casts',
            'label': 'Casts',
            'type': 'select',
            'options': ['None', 'Hyaline', 'Granular', 'Waxy'],
          },
        ],
      },
    ],
    'fields': [
      {
        'id': 'appearance',
        'label': 'Appearance',
        'type': 'select',
        'options': ['Clear', 'Turbid', 'Cloudy', 'Bloody'],
      },
      {
        'id': 'protein',
        'label': 'Protein',
        'type': 'select',
        'options': ['Negative', 'Trace', '+1', '+2', '+3'],
      },
      {
        'id': 'glucose',
        'label': 'Glucose',
        'type': 'select',
        'options': ['Negative', 'Trace', '+1', '+2', '+3'],
      },
      {
        'id': 'wbc_hpf',
        'label': 'WBC / HPF',
        'type': 'number',
        'unit': 'cells',
        'referenceRanges': [
          {'sex': 'any', 'ageMin': 18, 'ageMax': 150, 'min': 0, 'max': 5},
        ],
      },
    ],
  },
  {
    'id': 'lipid_panel',
    'name': 'Lipid Panel',
    'category': 'Lipid',
    'description': 'Cholesterol profile including LDL and HDL.',
    'version': 1,
    'matchers': {
      'testCodes': ['LIPID', 'CHOL'],
      'testNames': ['lipid panel', 'cholesterol'],
    },
    'detailProfiles': [
      {
        'id': 'lipid_standard',
        'name': 'Standard Lipid Panel',
        'description': 'Total cholesterol, HDL, LDL, and triglycerides.',
        'fields': [
          {
            'id': 'total_cholesterol',
            'label': 'Total Cholesterol',
            'type': 'number',
            'unit': 'mg/dL',
            'referenceRanges': [
              {
                'sex': 'any',
                'ageMin': 18,
                'ageMax': 150,
                'min': 125,
                'max': 200,
              },
            ],
          },
          {'id': 'hdl', 'label': 'HDL', 'type': 'number', 'unit': 'mg/dL'},
          {'id': 'ldl', 'label': 'LDL', 'type': 'number', 'unit': 'mg/dL'},
          {
            'id': 'triglycerides',
            'label': 'Triglycerides',
            'type': 'number',
            'unit': 'mg/dL',
          },
        ],
      },
      {
        'id': 'lipid_cardiometabolic',
        'name': 'Cardio-Metabolic Profile',
        'description': 'Expanded ratios and calculated markers.',
        'fields': [
          {
            'id': 'total_cholesterol',
            'label': 'Total Cholesterol',
            'type': 'number',
            'unit': 'mg/dL',
          },
          {'id': 'hdl', 'label': 'HDL', 'type': 'number', 'unit': 'mg/dL'},
          {
            'id': 'ldl',
            'label': 'LDL (calculated)',
            'type': 'number',
            'unit': 'mg/dL',
          },
          {
            'id': 'non_hdl',
            'label': 'Non-HDL Cholesterol',
            'type': 'number',
            'unit': 'mg/dL',
          },
          {
            'id': 'chol_hdl_ratio',
            'label': 'Total Cholesterol : HDL-C',
            'type': 'number',
            'unit': 'ratio',
          },
          {
            'id': 'ldl_hdl_ratio',
            'label': 'LDL-C : HDL-C',
            'type': 'number',
            'unit': 'ratio',
          },
          {
            'id': 'triglycerides',
            'label': 'Triglycerides',
            'type': 'number',
            'unit': 'mg/dL',
          },
        ],
      },
    ],
    'fields': [
      {
        'id': 'total_cholesterol',
        'label': 'Total Cholesterol',
        'type': 'number',
        'unit': 'mg/dL',
        'referenceRanges': [
          {'sex': 'any', 'ageMin': 18, 'ageMax': 150, 'min': 125, 'max': 200},
        ],
      },
      {
        'id': 'hdl',
        'label': 'HDL',
        'type': 'number',
        'unit': 'mg/dL',
        'referenceRanges': [
          {'sex': 'male', 'ageMin': 18, 'ageMax': 150, 'min': 40, 'max': 100},
          {'sex': 'female', 'ageMin': 18, 'ageMax': 150, 'min': 50, 'max': 110},
        ],
      },
      {
        'id': 'ldl',
        'label': 'LDL',
        'type': 'number',
        'unit': 'mg/dL',
        'referenceRanges': [
          {'sex': 'any', 'ageMin': 18, 'ageMax': 150, 'min': 0, 'max': 130},
        ],
      },
      {
        'id': 'triglycerides',
        'label': 'Triglycerides',
        'type': 'number',
        'unit': 'mg/dL',
        'referenceRanges': [
          {'sex': 'any', 'ageMin': 18, 'ageMax': 150, 'min': 0, 'max': 150},
        ],
      },
    ],
  },
  {
    'id': 'liver_function',
    'name': 'Liver Function Panel',
    'category': 'Biochemistry',
    'description': 'ALT, AST, ALP, and bilirubin results.',
    'version': 1,
    'matchers': {
      'testCodes': ['LFT', 'LIVER'],
      'testNames': ['liver function', 'hepatic panel'],
    },
    'fields': [
      {
        'id': 'alt',
        'label': 'ALT',
        'type': 'number',
        'unit': 'U/L',
        'referenceRanges': [
          {'sex': 'male', 'ageMin': 18, 'ageMax': 150, 'min': 10, 'max': 45},
          {'sex': 'female', 'ageMin': 18, 'ageMax': 150, 'min': 7, 'max': 35},
        ],
      },
      {
        'id': 'ast',
        'label': 'AST',
        'type': 'number',
        'unit': 'U/L',
        'referenceRanges': [
          {'sex': 'any', 'ageMin': 18, 'ageMax': 150, 'min': 10, 'max': 40},
        ],
      },
      {
        'id': 'alp',
        'label': 'ALP',
        'type': 'number',
        'unit': 'U/L',
        'referenceRanges': [
          {'sex': 'any', 'ageMin': 18, 'ageMax': 150, 'min': 44, 'max': 147},
        ],
      },
      {
        'id': 'bilirubin_total',
        'label': 'Total Bilirubin',
        'type': 'number',
        'unit': 'mg/dL',
        'referenceRanges': [
          {'sex': 'any', 'ageMin': 18, 'ageMax': 150, 'min': 0.2, 'max': 1.2},
        ],
      },
    ],
  },
  {
    'id': 'blood_glucose',
    'name': 'Blood Glucose',
    'category': 'Endocrine',
    'description': 'Fasting or random glucose with interpretation.',
    'version': 1,
    'matchers': {
      'testCodes': ['GLU', 'GLUC'],
      'testNames': ['glucose', 'blood sugar'],
    },
    'fields': [
      {
        'id': 'glucose',
        'label': 'Glucose',
        'type': 'number',
        'unit': 'mg/dL',
        'referenceRanges': [
          {'sex': 'any', 'ageMin': 18, 'ageMax': 150, 'min': 70, 'max': 99},
        ],
      },
      {
        'id': 'sample_type',
        'label': 'Sample Type',
        'type': 'select',
        'options': ['Fasting', 'Random', 'Post-prandial'],
      },
    ],
  },
  {
    'id': 'crp',
    'name': 'C-Reactive Protein',
    'category': 'Immunology',
    'description': 'Inflammation marker with qualitative note.',
    'version': 1,
    'matchers': {
      'testCodes': ['CRP'],
      'testNames': ['c-reactive protein', 'crp'],
    },
    'fields': [
      {
        'id': 'crp_level',
        'label': 'CRP',
        'type': 'number',
        'unit': 'mg/L',
        'referenceRanges': [
          {'sex': 'any', 'ageMin': 18, 'ageMax': 150, 'min': 0, 'max': 5},
        ],
      },
      {
        'id': 'interpretation',
        'label': 'Interpretation',
        'type': 'select',
        'options': ['Normal', 'Mildly Elevated', 'Elevated'],
      },
    ],
  },
  {
    'id': 'generic',
    'name': 'Generic Quantitative Result',
    'category': 'General',
    'description': 'Fallback template for tests without a defined schema.',
    'version': 1,
    'matchers': {'testCodes': [], 'testNames': []},
    'fields': [
      {
        'id': 'result_value',
        'label': 'Result Value',
        'type': 'number',
        'unit': '',
        'required': true,
      },
      {'id': 'result_notes', 'label': 'Result Notes', 'type': 'text'},
    ],
  },
];

const List<Map<String, dynamic>> _analyteCatalogDefinitions = [
  {
    'id': 'total_cholesterol',
    'name': 'Total Cholesterol',
    'category': 'Lipid',
    'type': 'number',
    'unit': 'mg/dL',
    'aliases': ['cholesterol'],
    'referenceRanges': [
      {'sex': 'any', 'ageMin': 18, 'ageMax': 150, 'min': 125, 'max': 200},
    ],
  },
  {
    'id': 'triglycerides',
    'name': 'Triglycerides',
    'category': 'Lipid',
    'type': 'number',
    'unit': 'mg/dL',
    'referenceRanges': [
      {'sex': 'any', 'ageMin': 18, 'ageMax': 150, 'min': 0, 'max': 150},
    ],
  },
  {
    'id': 'hdl',
    'name': 'HDL',
    'category': 'Lipid',
    'type': 'number',
    'unit': 'mg/dL',
  },
  {
    'id': 'ldl',
    'name': 'LDL',
    'category': 'Lipid',
    'type': 'number',
    'unit': 'mg/dL',
  },
  {
    'id': 'crp',
    'name': 'C-Reactive Protein',
    'category': 'Immunology',
    'type': 'number',
    'unit': 'mg/L',
    'aliases': ['crp'],
    'referenceRanges': [
      {'sex': 'any', 'ageMin': 18, 'ageMax': 150, 'min': 0, 'max': 5},
    ],
  },
  {
    'id': 'glucose',
    'name': 'Glucose',
    'category': 'Endocrine',
    'type': 'number',
    'unit': 'mg/dL',
    'aliases': ['blood sugar'],
    'referenceRanges': [
      {'sex': 'any', 'ageMin': 18, 'ageMax': 150, 'min': 70, 'max': 99},
    ],
  },
  {
    'id': 'creatinine',
    'name': 'Creatinine',
    'category': 'Renal',
    'type': 'number',
    'unit': 'mg/dL',
    'referenceRanges': [
      {'sex': 'male', 'ageMin': 18, 'ageMax': 150, 'min': 0.7, 'max': 1.3},
      {'sex': 'female', 'ageMin': 18, 'ageMax': 150, 'min': 0.6, 'max': 1.1},
    ],
  },
  {
    'id': 'alt',
    'name': 'ALT',
    'category': 'Liver',
    'type': 'number',
    'unit': 'U/L',
  },
  {
    'id': 'ast',
    'name': 'AST',
    'category': 'Liver',
    'type': 'number',
    'unit': 'U/L',
  },
  {
    'id': 'alp',
    'name': 'ALP',
    'category': 'Liver',
    'type': 'number',
    'unit': 'U/L',
  },
  {
    'id': 'bilirubin_total',
    'name': 'Total Bilirubin',
    'category': 'Liver',
    'type': 'number',
    'unit': 'mg/dL',
  },
  {
    'id': 'hemoglobin',
    'name': 'Hemoglobin',
    'category': 'Hematology',
    'type': 'number',
    'unit': 'g/dL',
    'aliases': ['hgb', 'hb'],
  },
  {
    'id': 'wbc',
    'name': 'White Blood Cells',
    'category': 'Hematology',
    'type': 'number',
    'unit': 'x10^9/L',
    'aliases': ['white blood cells', 'wbc'],
  },
  {
    'id': 'platelets',
    'name': 'Platelets',
    'category': 'Hematology',
    'type': 'number',
    'unit': 'x10^9/L',
  },
  {
    'id': 'hematocrit',
    'name': 'Hematocrit',
    'category': 'Hematology',
    'type': 'number',
    'unit': '%',
  },
  {
    'id': 'neutrophils',
    'name': 'Neutrophils',
    'category': 'Hematology',
    'type': 'number',
    'unit': '%',
  },
  {
    'id': 'lymphocytes',
    'name': 'Lymphocytes',
    'category': 'Hematology',
    'type': 'number',
    'unit': '%',
  },
  {
    'id': 'monocytes',
    'name': 'Monocytes',
    'category': 'Hematology',
    'type': 'number',
    'unit': '%',
  },
  {
    'id': 'eosinophils',
    'name': 'Eosinophils',
    'category': 'Hematology',
    'type': 'number',
    'unit': '%',
  },
  {
    'id': 'basophils',
    'name': 'Basophils',
    'category': 'Hematology',
    'type': 'number',
    'unit': '%',
  },
  {
    'id': 'urine_protein',
    'name': 'Urine Protein',
    'category': 'Urinalysis',
    'type': 'select',
    'options': ['Negative', 'Trace', '+1', '+2', '+3'],
    'aliases': ['protein'],
  },
  {
    'id': 'urine_glucose',
    'name': 'Urine Glucose',
    'category': 'Urinalysis',
    'type': 'select',
    'options': ['Negative', 'Trace', '+1', '+2', '+3'],
    'aliases': ['glucose'],
  },
  {
    'id': 'appearance',
    'name': 'Appearance',
    'category': 'Urinalysis',
    'type': 'select',
    'options': ['Clear', 'Turbid', 'Cloudy', 'Bloody'],
  },
  {
    'id': 'wbc_hpf',
    'name': 'WBC / HPF',
    'category': 'Urinalysis',
    'type': 'number',
    'unit': 'cells',
  },
  {
    'id': 'rbc_hpf',
    'name': 'RBC / HPF',
    'category': 'Urinalysis',
    'type': 'number',
    'unit': 'cells',
  },
];
