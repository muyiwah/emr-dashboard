import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:schmgtsystem/models/patient_model.dart';
import 'package:schmgtsystem/providers/patient_proviider.dart';
import 'package:schmgtsystem/services/api_service.dart';

// Modern Color Palette
class AppColors {
  // Primary gradient colors
  static const Color primaryStart = Color(0xFF667EEA);
  static const Color primaryEnd = Color(0xFF764BA2);

  // Section colors - Modern vibrant palette
  static const Color teal = Color(0xFF0EA5E9);
  static const Color rose = Color(0xFFF43F5E);
  static const Color emerald = Color(0xFF10B981);
  static const Color amber = Color(0xFFF59E0B);
  static const Color violet = Color(0xFF8B5CF6);
  static const Color cyan = Color(0xFF06B6D4);
  static const Color pink = Color(0xFFEC4899);
  static const Color indigo = Color(0xFF6366F1);
  static const Color orange = Color(0xFFF97316);
  static const Color lime = Color(0xFF84CC16);

  // Background colors
  static const Color background = Color(0xFFF8FAFC);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFF1F5F9);

  // Text colors
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);
}

// Custom Section Model
class CustomSection {
  final String id;
  final String title;
  final IconData icon;
  final Color color;
  final List<String> options;
  final Map<String, bool> selectedOptions;
  final TextEditingController? textController;

  CustomSection({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
    required this.options,
    Map<String, bool>? selectedOptions,
    this.textController,
  }) : selectedOptions = selectedOptions ?? {};

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'icon': icon.codePoint,
      'color': color.value,
      'options': options,
      'selectedOptions': selectedOptions,
      'hasTextField': textController != null,
    };
  }

  factory CustomSection.fromJson(Map<String, dynamic> json) {
    return CustomSection(
      id: json['id'],
      title: json['title'],
      icon: IconData(json['icon'], fontFamily: 'MaterialIcons'),
      color: Color(json['color']),
      options: List<String>.from(json['options']),
      selectedOptions: Map<String, bool>.from(json['selectedOptions'] ?? {}),
      textController: TextEditingController(),
    );
  }
}

class MedicalEncounterNote extends StatefulWidget {
  final Patient? patient;

  const MedicalEncounterNote({super.key, this.patient});

  @override
  State<MedicalEncounterNote> createState() => _MedicalEncounterNoteState();
}

class _MedicalEncounterNoteState extends State<MedicalEncounterNote> {
  // Modern color scheme for different sections
  final Map<String, Color> _sectionColors = {
    'Chief Complaint': AppColors.violet,
    'Pain Assessment': AppColors.rose,
    'Allergies': AppColors.orange,
    'Presenting Symptoms': AppColors.pink,
    'Patient Condition': AppColors.emerald,
    'Clinical Observations': AppColors.amber,
    'Notes for Doctor': AppColors.teal,
    'Handoff Summary': AppColors.indigo,
  };

  // Section collapse states
  final Map<String, bool> _sectionCollapsed = {
    'Chief Complaint': false,
    'Pain Assessment': false,
    'Allergies': false,
    'Presenting Symptoms': false,
    'Patient Condition': false,
    'Clinical Observations': false,
    'Notes for Doctor': false,
    'Handoff Summary': false,
  };

  // Chief Complaint
  String? _selectedChiefComplaint;
  final TextEditingController _customComplaintController =
      TextEditingController();
  bool _isQuotedComplaint = false; // Track if complaint is patient's own words

  // Pain Assessment
  double _painScore = 0;
  String? _selectedPainLocation;
  final List<String> _painLocations = [
    'Head',
    'Neck',
    'Chest',
    'Upper Back',
    'Lower Back',
    'Abdomen',
    'Left Arm',
    'Right Arm',
    'Left Leg',
    'Right Leg',
    'Shoulder',
    'Hip',
    'Joints',
    'Generalized',
    'Other',
  ];
  String? _selectedPainType;
  final List<String> _painTypes = [
    'Sharp',
    'Dull',
    'Throbbing',
    'Burning',
    'Stabbing',
    'Aching',
    'Cramping',
    'Shooting',
    'Tingling',
    'Pressure',
  ];
  String? _selectedPainDuration;
  final List<String> _painDurations = [
    'Just started',
    'Few hours',
    '1 day',
    '2-3 days',
    '1 week',
    '2+ weeks',
    'Chronic (months)',
    'Intermittent',
  ];
  final TextEditingController _painNotesController = TextEditingController();

  // Allergies
  final List<Map<String, String>> _drugAllergies = [];
  final List<Map<String, String>> _foodAllergies = [];
  final List<Map<String, String>> _otherAllergies = [];
  bool _noKnownAllergies = false;
  final List<String> _reactionTypes = [
    'Rash',
    'Hives',
    'Itching',
    'Swelling',
    'Anaphylaxis',
    'Breathing difficulty',
    'Nausea/Vomiting',
    'Diarrhea',
    'Other',
  ];

  // Presenting Symptoms - Toggle states with duration and severity
  final Map<String, bool> _symptoms = {
    'Fever': false,
    'Cough': false,
    'Shortness of Breath': false,
    'Chest Pain': false,
    'Headache': false,
    'Nausea/Vomiting': false,
    'Abdominal Pain': false,
    'Dizziness': false,
    'Fatigue': false,
    'Pain': false,
    'Bleeding': false,
    'Rash': false,
    'Loss of Appetite': false,
    'Chills': false,
    'Sweating': false,
    'Weakness': false,
  };

  // Symptom details (duration and severity)
  final Map<String, String> _symptomDurations = {};
  final Map<String, int> _symptomSeverities = {}; // 1-10 scale
  final List<String> _durationOptions = [
    'Just started',
    'Few hours',
    '1 day',
    '2-3 days',
    '1 week',
    '2+ weeks',
    'Chronic',
  ];

  // Patient Condition/Appearance
  String? _selectedCondition;
  String? _selectedAlertness;
  String? _selectedDistress;
  final Map<String, bool> _appearance = {
    'Well-appearing': false,
    'Mildly distressed': false,
    'Moderately distressed': false,
    'Severely distressed': false,
    'Pale': false,
    'Diaphoretic': false,
    'Cyanotic': false,
  };

  // Observations
  final TextEditingController _observationsController = TextEditingController();
  final Map<String, bool> _observations = {
    'Alert and oriented': false,
    'Follows commands': false,
    'Normal speech': false,
    'No acute distress': false,
    'Moving all extremities': false,
  };

  // Notes for Doctor
  final TextEditingController _notesForDoctorController =
      TextEditingController();

  // Handoff Summary
  final TextEditingController _handoffSummaryController =
      TextEditingController();
  bool _handoffEdited = false; // Track if user has manually edited

  // Custom Sections
  List<CustomSection> _customSections = [];

  // Encounter Details
  String _selectedEncounterType = 'Routine';
  DateTime _selectedDateTime = DateTime.now();

  // API State
  String? _currentNoteId; // ID of the current encounter note (if saved)
  String _noteStatus =
      'draft'; // Current status: draft, submitted, signed, etc.
  bool _isSaving = false;
  bool _isSubmitting = false;
  String? _lastSavedAt;

  // Preset Chief Complaints
  final List<String> _chiefComplaintPresets = [
    'Routine checkup',
    'Follow-up visit',
    'Acute illness',
    'Chronic condition management',
    'Pain management',
    'Medication review',
    'Lab results review',
    'Pre-operative assessment',
    'Post-operative follow-up',
    'Emergency visit',
    'Other',
  ];

  // Patient Condition Presets
  final List<String> _conditionPresets = [
    'Stable',
    'Stable but requires monitoring',
    'Unstable - requires immediate attention',
    'Critical',
  ];

  // Alertness Presets
  final List<String> _alertnessPresets = [
    'Alert and oriented x4',
    'Alert and oriented x3',
    'Alert and oriented x2',
    'Alert and oriented x1',
    'Confused',
    'Lethargic',
    'Unresponsive',
  ];

  // Distress Level Presets
  final List<String> _distressPresets = [
    'No distress',
    'Mild distress',
    'Moderate distress',
    'Severe distress',
  ];

  // Available colors for custom sections
  final List<Color> _availableColors = [
    AppColors.violet,
    AppColors.rose,
    AppColors.emerald,
    AppColors.amber,
    AppColors.teal,
    AppColors.cyan,
    AppColors.pink,
    AppColors.indigo,
    AppColors.orange,
    AppColors.lime,
  ];

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    // Load collapsed states
    _sectionCollapsed.forEach((key, value) {
      final collapsed = prefs.getBool('section_collapsed_$key') ?? false;
      _sectionCollapsed[key] = collapsed;
    });

    // Load custom sections
    final customSectionsJson = prefs.getString('custom_sections');
    if (customSectionsJson != null) {
      final List<dynamic> sectionsList = jsonDecode(customSectionsJson);
      setState(() {
        _customSections =
            sectionsList
                .map((s) => CustomSection.fromJson(s as Map<String, dynamic>))
                .toList();
      });
    }

    setState(() {});
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();

    // Save collapsed states
    _sectionCollapsed.forEach((key, value) {
      prefs.setBool('section_collapsed_$key', value);
    });

    // Save custom sections
    final sectionsJson = jsonEncode(
      _customSections.map((s) => s.toJson()).toList(),
    );
    prefs.setString('custom_sections', sectionsJson);
  }

  @override
  void dispose() {
    _customComplaintController.dispose();
    _painNotesController.dispose();
    _observationsController.dispose();
    _notesForDoctorController.dispose();
    _handoffSummaryController.dispose();
    for (var section in _customSections) {
      section.textController?.dispose();
    }
    super.dispose();
  }

  Patient? get _patient {
    return widget.patient ??
        Provider.of<PatientProvider>(context, listen: false).currentPatient;
  }

  // Get all selected items for review
  Map<String, List<String>> _getSelectedItems() {
    final Map<String, List<String>> selected = {};

    // Chief Complaint
    if (_selectedChiefComplaint != null) {
      String complaint;
      if (_selectedChiefComplaint == 'Other' &&
          _customComplaintController.text.trim().isNotEmpty) {
        complaint = _customComplaintController.text.trim();
      } else if (_selectedChiefComplaint != 'Other') {
        complaint = _selectedChiefComplaint!;
      } else {
        complaint = '';
      }
      if (complaint.isNotEmpty) {
        selected['Chief Complaint'] = [
          _isQuotedComplaint ? '"$complaint"' : complaint,
        ];
      }
    }

    // Pain Assessment
    if (_painScore > 0 ||
        _selectedPainLocation != null ||
        _selectedPainType != null) {
      final painItems = <String>[];
      if (_painScore > 0) painItems.add('Pain Score: ${_painScore.toInt()}/10');
      if (_selectedPainLocation != null)
        painItems.add('Location: $_selectedPainLocation');
      if (_selectedPainType != null) painItems.add('Type: $_selectedPainType');
      if (_selectedPainDuration != null)
        painItems.add('Duration: $_selectedPainDuration');
      if (_painNotesController.text.trim().isNotEmpty) {
        painItems.add('Notes: ${_painNotesController.text.trim()}');
      }
      if (painItems.isNotEmpty) {
        selected['Pain Assessment'] = painItems;
      }
    }

    // Allergies
    if (!_noKnownAllergies) {
      final allergyItems = <String>[];
      for (var allergy in _drugAllergies) {
        allergyItems.add('Drug: ${allergy['name']} → ${allergy['reaction']}');
      }
      for (var allergy in _foodAllergies) {
        allergyItems.add('Food: ${allergy['name']} → ${allergy['reaction']}');
      }
      for (var allergy in _otherAllergies) {
        allergyItems.add('Other: ${allergy['name']} → ${allergy['reaction']}');
      }
      if (allergyItems.isNotEmpty) {
        selected['Allergies'] = allergyItems;
      }
    } else {
      selected['Allergies'] = ['No Known Allergies (NKA)'];
    }

    // Symptoms with duration and severity
    final selectedSymptoms = <String>[];
    for (var entry in _symptoms.entries.where((e) => e.value)) {
      final symptom = entry.key;
      final duration = _symptomDurations[symptom];
      final severity = _symptomSeverities[symptom];
      String symptomText = symptom;
      if (duration != null || severity != null) {
        final details = <String>[];
        if (duration != null) details.add(duration);
        if (severity != null) details.add('Severity: $severity/10');
        symptomText = '$symptom (${details.join(', ')})';
      }
      selectedSymptoms.add(symptomText);
    }
    if (selectedSymptoms.isNotEmpty) {
      selected['Presenting Symptoms'] = selectedSymptoms;
    }

    // Patient Condition
    final conditionItems = <String>[];
    if (_selectedCondition != null) conditionItems.add(_selectedCondition!);
    if (_selectedAlertness != null) conditionItems.add(_selectedAlertness!);
    if (_selectedDistress != null) conditionItems.add(_selectedDistress!);
    final selectedAppearance =
        _appearance.entries.where((e) => e.value).map((e) => e.key).toList();
    conditionItems.addAll(selectedAppearance);
    if (conditionItems.isNotEmpty) {
      selected['Patient Condition'] = conditionItems;
    }

    // Observations
    final selectedObservations =
        _observations.entries.where((e) => e.value).map((e) => e.key).toList();
    if (_observationsController.text.trim().isNotEmpty) {
      selectedObservations.add('Notes: ${_observationsController.text.trim()}');
    }
    if (selectedObservations.isNotEmpty) {
      selected['Clinical Observations'] = selectedObservations;
    }

    // Notes for Doctor
    if (_notesForDoctorController.text.trim().isNotEmpty) {
      selected['Notes for Doctor'] = [_notesForDoctorController.text.trim()];
    }

    // Handoff Summary
    if (_handoffSummaryController.text.trim().isNotEmpty) {
      selected['Handoff Summary'] = [_handoffSummaryController.text.trim()];
    }

    // Custom Sections
    for (var section in _customSections) {
      final items = <String>[];
      items.addAll(
        section.selectedOptions.entries.where((e) => e.value).map((e) => e.key),
      );
      if (section.textController?.text.trim().isNotEmpty == true) {
        items.add('Notes: ${section.textController!.text.trim()}');
      }
      if (items.isNotEmpty) {
        selected[section.title] = items;
      }
    }

    return selected;
  }

  @override
  Widget build(BuildContext context) {
    final patient = _patient;

    if (patient == null) {
      return const Center(child: Text('No patient selected'));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildChiefComplaintSection(),
                    const SizedBox(height: 16),
                    _buildPainAssessmentSection(),
                    const SizedBox(height: 16),
                    _buildAllergiesSection(),
                    const SizedBox(height: 16),
                    _buildSymptomsSection(),
                    const SizedBox(height: 16),
                    _buildPatientConditionSection(),
                    const SizedBox(height: 16),
                    _buildObservationsSection(),
                    const SizedBox(height: 16),
                    _buildNotesForDoctorSection(),
                    const SizedBox(height: 16),
                    _buildHandoffSummarySection(patient),
                    // Custom sections
                    ..._customSections.map(
                      (section) => Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: _buildCustomSection(section),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Add custom section button
                    _buildAddCustomSectionButton(),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildChiefComplaintSection() {
    return _buildCollapsibleSection(
      key: 'Chief Complaint',
      title: 'Chief Complaint (Patient\'s Own Words)',
      icon: Icons.record_voice_over_outlined,
      color: _sectionColors['Chief Complaint']!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quote toggle
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color:
                  _isQuotedComplaint
                      ? _sectionColors['Chief Complaint']!.withOpacity(0.1)
                      : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    _isQuotedComplaint
                        ? _sectionColors['Chief Complaint']!
                        : Colors.transparent,
                width: 2,
              ),
            ),
            child: InkWell(
              onTap: () {
                setState(() {
                  _isQuotedComplaint = !_isQuotedComplaint;
                });
              },
              child: Row(
                children: [
                  Icon(
                    _isQuotedComplaint
                        ? Icons.format_quote_rounded
                        : Icons.format_quote_outlined,
                    color:
                        _isQuotedComplaint
                            ? _sectionColors['Chief Complaint']!
                            : AppColors.textMuted,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Patient\'s Exact Words',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color:
                                _isQuotedComplaint
                                    ? _sectionColors['Chief Complaint']!
                                    : AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'Quote the complaint verbatim as stated by patient',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _isQuotedComplaint,
                    onChanged: (value) {
                      setState(() {
                        _isQuotedComplaint = value;
                      });
                    },
                    activeColor: _sectionColors['Chief Complaint']!,
                  ),
                ],
              ),
            ),
          ),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children:
                _chiefComplaintPresets.map((complaint) {
                  final isSelected = _selectedChiefComplaint == complaint;
                  return _buildToggleChip(
                    complaint,
                    isSelected,
                    _sectionColors['Chief Complaint']!,
                    () {
                      setState(() {
                        if (_selectedChiefComplaint == complaint) {
                          _selectedChiefComplaint = null;
                        } else {
                          _selectedChiefComplaint = complaint;
                          if (complaint != 'Other') {
                            _customComplaintController.clear();
                          }
                        }
                      });
                    },
                  );
                }).toList(),
          ),
          if (_selectedChiefComplaint == 'Other') ...[
            const SizedBox(height: 16),
            _buildModernTextField(
              controller: _customComplaintController,
              hintText:
                  _isQuotedComplaint
                      ? '"Enter patient\'s exact words..."'
                      : 'Describe the chief complaint...',
              icon: Icons.edit_outlined,
              color: _sectionColors['Chief Complaint']!,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPainAssessmentSection() {
    return _buildCollapsibleSection(
      key: 'Pain Assessment',
      title: 'Pain Assessment',
      icon: Icons.sentiment_dissatisfied_outlined,
      color: _sectionColors['Pain Assessment']!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pain Score Slider
          _buildSubsectionTitle('Pain Score (0-10)', Icons.speed_outlined),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _sectionColors['Pain Assessment']!.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _sectionColors['Pain Assessment']!.withOpacity(0.2),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'No Pain',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            _getPainColor(_painScore),
                            _getPainColor(_painScore).withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: _getPainColor(_painScore).withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        '${_painScore.toInt()}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      'Worst Pain',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: _getPainColor(_painScore),
                    inactiveTrackColor: _sectionColors['Pain Assessment']!
                        .withOpacity(0.2),
                    thumbColor: _getPainColor(_painScore),
                    overlayColor: _getPainColor(_painScore).withOpacity(0.2),
                    trackHeight: 8,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 14,
                    ),
                  ),
                  child: Slider(
                    value: _painScore,
                    min: 0,
                    max: 10,
                    divisions: 10,
                    onChanged: (value) {
                      setState(() {
                        _painScore = value;
                      });
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildPainLabel('😊', 'Mild', 1, 3),
                    _buildPainLabel('😐', 'Moderate', 4, 6),
                    _buildPainLabel('😖', 'Severe', 7, 10),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Pain Location
          _buildSubsectionTitle('Pain Location', Icons.location_on_outlined),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children:
                _painLocations.map((location) {
                  final isSelected = _selectedPainLocation == location;
                  return _buildToggleChip(
                    location,
                    isSelected,
                    _sectionColors['Pain Assessment']!,
                    () {
                      setState(() {
                        _selectedPainLocation = isSelected ? null : location;
                      });
                    },
                  );
                }).toList(),
          ),
          const SizedBox(height: 20),

          // Pain Type
          _buildSubsectionTitle('Pain Type', Icons.category_outlined),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children:
                _painTypes.map((type) {
                  final isSelected = _selectedPainType == type;
                  return _buildToggleChip(
                    type,
                    isSelected,
                    _sectionColors['Pain Assessment']!,
                    () {
                      setState(() {
                        _selectedPainType = isSelected ? null : type;
                      });
                    },
                  );
                }).toList(),
          ),
          const SizedBox(height: 20),

          // Pain Duration
          _buildSubsectionTitle('Duration', Icons.timer_outlined),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children:
                _painDurations.map((duration) {
                  final isSelected = _selectedPainDuration == duration;
                  return _buildToggleChip(
                    duration,
                    isSelected,
                    _sectionColors['Pain Assessment']!,
                    () {
                      setState(() {
                        _selectedPainDuration = isSelected ? null : duration;
                      });
                    },
                  );
                }).toList(),
          ),
          const SizedBox(height: 16),

          // Additional Notes
          _buildModernTextField(
            controller: _painNotesController,
            hintText: 'Additional pain notes (e.g., aggravating factors)...',
            icon: Icons.note_add_outlined,
            color: _sectionColors['Pain Assessment']!,
          ),
        ],
      ),
    );
  }

  Color _getPainColor(double score) {
    if (score <= 3) return AppColors.emerald;
    if (score <= 6) return AppColors.amber;
    return AppColors.rose;
  }

  Widget _buildPainLabel(String emoji, String label, int min, int max) {
    final isInRange = _painScore >= min && _painScore <= max;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color:
            isInRange
                ? _getPainColor(_painScore).withOpacity(0.15)
                : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isInRange ? FontWeight.w700 : FontWeight.w500,
              color:
                  isInRange
                      ? _getPainColor(_painScore)
                      : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllergiesSection() {
    return _buildCollapsibleSection(
      key: 'Allergies',
      title: 'Allergies',
      icon: Icons.warning_amber_outlined,
      color: _sectionColors['Allergies']!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // No Known Allergies Toggle
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color:
                  _noKnownAllergies
                      ? AppColors.emerald.withOpacity(0.1)
                      : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    _noKnownAllergies ? AppColors.emerald : Colors.transparent,
                width: 2,
              ),
            ),
            child: CheckboxListTile(
              value: _noKnownAllergies,
              onChanged: (value) {
                setState(() {
                  _noKnownAllergies = value ?? false;
                  if (_noKnownAllergies) {
                    _drugAllergies.clear();
                    _foodAllergies.clear();
                    _otherAllergies.clear();
                  }
                });
              },
              title: const Text(
                'No Known Allergies (NKA)',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                'Patient has confirmed no known allergies',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              activeColor: AppColors.emerald,
              checkboxShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ),

          if (!_noKnownAllergies) ...[
            // Drug Allergies
            _buildAllergyCategory(
              'Drug Allergies',
              Icons.medication_outlined,
              _drugAllergies,
              AppColors.rose,
              () => _showAddAllergyDialog('Drug', _drugAllergies),
            ),
            const SizedBox(height: 16),

            // Food Allergies
            _buildAllergyCategory(
              'Food Allergies',
              Icons.restaurant_outlined,
              _foodAllergies,
              AppColors.amber,
              () => _showAddAllergyDialog('Food', _foodAllergies),
            ),
            const SizedBox(height: 16),

            // Other Allergies
            _buildAllergyCategory(
              'Other Allergies',
              Icons.category_outlined,
              _otherAllergies,
              AppColors.violet,
              () => _showAddAllergyDialog('Other', _otherAllergies),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAllergyCategory(
    String title,
    IconData icon,
    List<Map<String, String>> allergies,
    Color color,
    VoidCallback onAdd,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.w700, color: color),
              ),
              const Spacer(),
              InkWell(
                onTap: onAdd,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.add, size: 16, color: Colors.white),
                      const SizedBox(width: 4),
                      Text(
                        'Add',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (allergies.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  allergies.map((allergy) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: color.withOpacity(0.3)),
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.warning_rounded, size: 14, color: color),
                          const SizedBox(width: 6),
                          Text(
                            '${allergy['name']}',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            ' → ${allergy['reaction']}',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 6),
                          InkWell(
                            onTap: () {
                              setState(() {
                                allergies.remove(allergy);
                              });
                            },
                            child: Icon(
                              Icons.close,
                              size: 16,
                              color: AppColors.rose,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
            ),
          ],
          if (allergies.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'No $title recorded',
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: AppColors.textMuted,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showAddAllergyDialog(
    String type,
    List<Map<String, String>> allergyList,
  ) {
    final nameController = TextEditingController();
    String? selectedReaction;

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setDialogState) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _sectionColors['Allergies']!,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.warning_amber_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text('Add $type Allergy'),
                    ],
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: '$type Name',
                          hintText:
                              'e.g., ${type == 'Drug'
                                  ? 'Penicillin'
                                  : type == 'Food'
                                  ? 'Peanuts'
                                  : 'Latex'}',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.medication_outlined),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Reaction Type',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children:
                            _reactionTypes.map((reaction) {
                              final isSelected = selectedReaction == reaction;
                              return InkWell(
                                onTap: () {
                                  setDialogState(() {
                                    selectedReaction = reaction;
                                  });
                                },
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        isSelected
                                            ? _sectionColors['Allergies']!
                                            : AppColors.surfaceLight,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color:
                                          isSelected
                                              ? _sectionColors['Allergies']!
                                              : Colors.transparent,
                                    ),
                                  ),
                                  child: Text(
                                    reaction,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight:
                                          isSelected
                                              ? FontWeight.w600
                                              : FontWeight.w500,
                                      color:
                                          isSelected
                                              ? Colors.white
                                              : AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (nameController.text.trim().isNotEmpty &&
                            selectedReaction != null) {
                          setState(() {
                            allergyList.add({
                              'name': nameController.text.trim(),
                              'reaction': selectedReaction!,
                            });
                          });
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _sectionColors['Allergies']!,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Add Allergy'),
                    ),
                  ],
                ),
          ),
    );
  }

  Widget _buildSymptomsSection() {
    final selectedSymptoms =
        _symptoms.entries.where((e) => e.value).map((e) => e.key).toList();

    return _buildCollapsibleSection(
      key: 'Presenting Symptoms',
      title: 'Presenting Symptoms',
      icon: Icons.healing_outlined,
      color: _sectionColors['Presenting Symptoms']!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Symptom selection
          _buildSubsectionTitle('Select Symptoms', Icons.checklist_outlined),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children:
                _symptoms.keys.map((symptom) {
                  return _buildToggleChip(
                    symptom,
                    _symptoms[symptom] ?? false,
                    _sectionColors['Presenting Symptoms']!,
                    () {
                      setState(() {
                        _symptoms[symptom] = !(_symptoms[symptom] ?? false);
                        // Initialize defaults when selecting
                        if (_symptoms[symptom] == true) {
                          _symptomDurations[symptom] ??= _durationOptions[0];
                          _symptomSeverities[symptom] ??= 5;
                        }
                      });
                    },
                  );
                }).toList(),
          ),

          // Show details for selected symptoms
          if (selectedSymptoms.isNotEmpty) ...[
            const SizedBox(height: 24),
            _buildSubsectionTitle('Symptom Details', Icons.tune_outlined),
            const SizedBox(height: 12),
            ...selectedSymptoms.map(
              (symptom) => _buildSymptomDetailCard(symptom),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSymptomDetailCard(String symptom) {
    final color = _sectionColors['Presenting Symptoms']!;
    final severity = _symptomSeverities[symptom] ?? 5;
    final duration = _symptomDurations[symptom];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.healing_rounded,
                  size: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  symptom,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _symptoms[symptom] = false;
                    _symptomDurations.remove(symptom);
                    _symptomSeverities.remove(symptom);
                  });
                },
                icon: Icon(
                  Icons.close_rounded,
                  color: AppColors.rose,
                  size: 20,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Duration
          Row(
            children: [
              Icon(
                Icons.timer_outlined,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                'Duration:',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                _durationOptions.map((d) {
                  final isSelected = duration == d;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _symptomDurations[symptom] = d;
                      });
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? color : AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        d,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                          color:
                              isSelected ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
          const SizedBox(height: 16),

          // Severity
          Row(
            children: [
              Icon(
                Icons.speed_outlined,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                'Severity: ',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _getSeverityColor(severity),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$severity/10',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                ' (${_getSeverityLabel(severity)})',
                style: TextStyle(
                  fontSize: 12,
                  color: _getSeverityColor(severity),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: _getSeverityColor(severity),
              inactiveTrackColor: color.withOpacity(0.2),
              thumbColor: _getSeverityColor(severity),
              overlayColor: _getSeverityColor(severity).withOpacity(0.2),
              trackHeight: 6,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            ),
            child: Slider(
              value: severity.toDouble(),
              min: 1,
              max: 10,
              divisions: 9,
              onChanged: (value) {
                setState(() {
                  _symptomSeverities[symptom] = value.toInt();
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getSeverityColor(int severity) {
    if (severity <= 3) return AppColors.emerald;
    if (severity <= 6) return AppColors.amber;
    return AppColors.rose;
  }

  String _getSeverityLabel(int severity) {
    if (severity <= 3) return 'Mild';
    if (severity <= 6) return 'Moderate';
    return 'Severe';
  }

  Widget _buildPatientConditionSection() {
    return _buildCollapsibleSection(
      key: 'Patient Condition',
      title: 'Patient Condition & Appearance',
      icon: Icons.monitor_heart_outlined,
      color: _sectionColors['Patient Condition']!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSubsectionTitle(
            'Overall Condition',
            Icons.health_and_safety_outlined,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children:
                _conditionPresets.map((condition) {
                  final isSelected = _selectedCondition == condition;
                  return _buildToggleChip(
                    condition,
                    isSelected,
                    _sectionColors['Patient Condition']!,
                    () {
                      setState(() {
                        _selectedCondition =
                            _selectedCondition == condition ? null : condition;
                      });
                    },
                  );
                }).toList(),
          ),
          const SizedBox(height: 24),
          _buildSubsectionTitle('Alertness Level', Icons.psychology_outlined),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children:
                _alertnessPresets.map((alertness) {
                  final isSelected = _selectedAlertness == alertness;
                  return _buildToggleChip(
                    alertness,
                    isSelected,
                    _sectionColors['Patient Condition']!,
                    () {
                      setState(() {
                        _selectedAlertness =
                            _selectedAlertness == alertness ? null : alertness;
                      });
                    },
                  );
                }).toList(),
          ),
          const SizedBox(height: 24),
          _buildSubsectionTitle(
            'Distress Level',
            Icons.sentiment_dissatisfied_outlined,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children:
                _distressPresets.map((distress) {
                  final isSelected = _selectedDistress == distress;
                  return _buildToggleChip(
                    distress,
                    isSelected,
                    _sectionColors['Patient Condition']!,
                    () {
                      setState(() {
                        _selectedDistress =
                            _selectedDistress == distress ? null : distress;
                      });
                    },
                  );
                }).toList(),
          ),
          const SizedBox(height: 24),
          _buildSubsectionTitle(
            'Physical Appearance',
            Icons.visibility_outlined,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children:
                _appearance.keys.map((appearance) {
                  return _buildToggleChip(
                    appearance,
                    _appearance[appearance] ?? false,
                    _sectionColors['Patient Condition']!,
                    () {
                      setState(() {
                        _appearance[appearance] =
                            !(_appearance[appearance] ?? false);
                      });
                    },
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildObservationsSection() {
    return _buildCollapsibleSection(
      key: 'Clinical Observations',
      title: 'Clinical Observations',
      icon: Icons.assignment_outlined,
      color: _sectionColors['Clinical Observations']!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children:
                _observations.keys.map((observation) {
                  return _buildToggleChip(
                    observation,
                    _observations[observation] ?? false,
                    _sectionColors['Clinical Observations']!,
                    () {
                      setState(() {
                        _observations[observation] =
                            !(_observations[observation] ?? false);
                      });
                    },
                  );
                }).toList(),
          ),
          const SizedBox(height: 16),
          _buildModernTextField(
            controller: _observationsController,
            hintText: 'Additional observations...',
            icon: Icons.note_add_outlined,
            color: _sectionColors['Clinical Observations']!,
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildNotesForDoctorSection() {
    return _buildCollapsibleSection(
      key: 'Notes for Doctor',
      title: 'Notes for Doctor',
      icon: Icons.medical_information_outlined,
      color: _sectionColors['Notes for Doctor']!,
      child: _buildModernTextField(
        controller: _notesForDoctorController,
        hintText: 'Important notes, concerns, or questions for the doctor...',
        icon: Icons.priority_high_outlined,
        color: _sectionColors['Notes for Doctor']!,
        maxLines: 4,
      ),
    );
  }

  Widget _buildHandoffSummarySection(Patient patient) {
    final generatedSummary = _generateHandoffSummary(patient);
    final color = _sectionColors['Handoff Summary']!;

    // Auto-populate if not manually edited and there's content
    if (!_handoffEdited && generatedSummary.isNotEmpty) {
      _handoffSummaryController.text = generatedSummary;
    }

    return _buildCollapsibleSection(
      key: 'Handoff Summary',
      title: 'Handoff Summary',
      icon: Icons.summarize_outlined,
      color: color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with action buttons
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _handoffEdited ? Icons.edit_document : Icons.auto_awesome,
                  size: 18,
                  color: color,
                ),
                const SizedBox(width: 8),
                Text(
                  _handoffEdited ? 'Manually Edited' : 'Auto-Generated',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                if (_handoffEdited)
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.amber.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Modified',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.amber,
                      ),
                    ),
                  ),
                const Spacer(),
                // Regenerate button
                InkWell(
                  onTap: () {
                    setState(() {
                      _handoffEdited = false;
                      _handoffSummaryController.text = generatedSummary;
                    });
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.refresh, size: 14, color: color),
                        const SizedBox(width: 4),
                        Text(
                          'Regenerate',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Editable text area
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(16),
              ),
              border: Border.all(color: color.withOpacity(0.2)),
            ),
            child: TextField(
              controller: _handoffSummaryController,
              maxLines: null,
              minLines: 4,
              onChanged: (value) {
                if (!_handoffEdited) {
                  setState(() {
                    _handoffEdited = true;
                  });
                }
              },
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText:
                    generatedSummary.isEmpty
                        ? 'Start filling the encounter note to auto-generate, or type your handoff summary here...'
                        : 'Edit the handoff summary...',
                hintStyle: TextStyle(
                  color: AppColors.textMuted,
                  fontStyle: FontStyle.italic,
                ),
                contentPadding: const EdgeInsets.all(16),
                border: InputBorder.none,
                suffixIcon:
                    _handoffSummaryController.text.isNotEmpty
                        ? IconButton(
                          onPressed: () {
                            setState(() {
                              _handoffSummaryController.clear();
                              _handoffEdited = true;
                            });
                          },
                          icon: Icon(
                            Icons.clear_rounded,
                            size: 18,
                            color: AppColors.textMuted,
                          ),
                        )
                        : null,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Helper text
          Row(
            children: [
              Icon(Icons.lightbulb_outline, size: 16, color: AppColors.amber),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _handoffEdited
                      ? 'You\'ve edited this summary. Tap "Regenerate" to reset to auto-generated content.'
                      : 'This summary updates automatically. Edit it directly or tap "Regenerate" to refresh.',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _generateHandoffSummary(Patient patient) {
    final parts = <String>[];

    // Patient demographics
    final demographics = '${patient.age}y ${patient.gender.toLowerCase()}';

    // Chief complaint
    String? complaint;
    if (_selectedChiefComplaint != null) {
      if (_selectedChiefComplaint == 'Other' &&
          _customComplaintController.text.trim().isNotEmpty) {
        complaint = _customComplaintController.text.trim();
      } else if (_selectedChiefComplaint != 'Other') {
        complaint = _selectedChiefComplaint;
      }
    }

    // Symptoms with duration
    final symptoms =
        _symptoms.entries.where((e) => e.value).map((e) {
          final duration = _symptomDurations[e.key];
          return duration != null ? '${e.key} ($duration)' : e.key;
        }).toList();

    // Pain
    String? painInfo;
    if (_painScore > 0) {
      final painParts = <String>['Pain ${_painScore.toInt()}/10'];
      if (_selectedPainLocation != null) painParts.add(_selectedPainLocation!);
      if (_selectedPainType != null)
        painParts.add(_selectedPainType!.toLowerCase());
      painInfo = painParts.join(' ');
    }

    // Allergies
    String allergyInfo;
    if (_noKnownAllergies) {
      allergyInfo = 'NKA';
    } else {
      final allAllergies =
          [
            ..._drugAllergies.map((a) => a['name']),
            ..._foodAllergies.map((a) => a['name']),
            ..._otherAllergies.map((a) => a['name']),
          ].where((a) => a != null).toList();
      allergyInfo =
          allAllergies.isEmpty
              ? 'Allergies not recorded'
              : 'Allergies: ${allAllergies.join(', ')}';
    }

    // Condition
    String? condition = _selectedCondition;
    String? distress = _selectedDistress;

    // Build the summary
    if (complaint != null) {
      parts.add(
        '$demographics presenting with ${_isQuotedComplaint ? '"$complaint"' : complaint.toLowerCase()}.',
      );
    }

    if (symptoms.isNotEmpty) {
      parts.add('Symptoms: ${symptoms.join(', ')}.');
    }

    if (painInfo != null) {
      parts.add(painInfo + '.');
    }

    if (condition != null || distress != null) {
      final condParts = <String>[];
      if (condition != null) condParts.add(condition);
      if (distress != null) condParts.add(distress.toLowerCase());
      parts.add('Patient ${condParts.join(', ')}.');
    }

    parts.add(allergyInfo + '.');

    if (_notesForDoctorController.text.trim().isNotEmpty) {
      parts.add('Notes: ${_notesForDoctorController.text.trim()}');
    }

    parts.add('Awaiting medical review.');

    return parts.join('\n');
  }

  // ============================================================
  // API INTEGRATION METHODS
  // ============================================================

  /// Build encounter note data from form state
  Map<String, dynamic> _buildEncounterNoteData() {
    final patient = _patient;
    if (patient == null) return {};

    // Build chief complaint
    Map<String, dynamic>? chiefComplaint;
    if (_selectedChiefComplaint != null) {
      String complaintText;
      if (_selectedChiefComplaint == 'Other') {
        complaintText = _customComplaintController.text.trim();
      } else {
        complaintText = _selectedChiefComplaint!;
      }
      if (complaintText.isNotEmpty) {
        chiefComplaint = {
          'text': complaintText,
          'preset':
              _selectedChiefComplaint != 'Other'
                  ? _selectedChiefComplaint
                  : null,
          'isQuoted': _isQuotedComplaint,
        };
      }
    }

    // Build pain assessment
    Map<String, dynamic>? painAssessment;
    if (_painScore > 0 ||
        _selectedPainLocation != null ||
        _selectedPainType != null) {
      painAssessment = {
        'score': _painScore.toInt(),
        if (_selectedPainLocation != null) 'location': _selectedPainLocation,
        if (_selectedPainType != null) 'type': _selectedPainType,
        if (_selectedPainDuration != null) 'duration': _selectedPainDuration,
        if (_painNotesController.text.trim().isNotEmpty)
          'notes': _painNotesController.text.trim(),
      };
    }

    // Build allergies
    Map<String, dynamic> allergies = {
      'noKnownAllergies': _noKnownAllergies,
      'items': [
        ..._drugAllergies.map(
          (a) => {'type': 'drug', 'name': a['name'], 'reaction': a['reaction']},
        ),
        ..._foodAllergies.map(
          (a) => {'type': 'food', 'name': a['name'], 'reaction': a['reaction']},
        ),
        ..._otherAllergies.map(
          (a) => {
            'type': 'other',
            'name': a['name'],
            'reaction': a['reaction'],
          },
        ),
      ],
    };

    // Build symptoms
    List<Map<String, dynamic>> symptoms = [];
    for (var entry in _symptoms.entries.where((e) => e.value)) {
      symptoms.add({
        'name': entry.key,
        if (_symptomDurations.containsKey(entry.key))
          'duration': _symptomDurations[entry.key],
        if (_symptomSeverities.containsKey(entry.key))
          'severity': _symptomSeverities[entry.key],
      });
    }

    // Build patient condition
    Map<String, dynamic>? patientCondition;
    if (_selectedCondition != null ||
        _selectedAlertness != null ||
        _selectedDistress != null) {
      patientCondition = {
        if (_selectedCondition != null) 'overallCondition': _selectedCondition,
        if (_selectedAlertness != null) 'alertnessLevel': _selectedAlertness,
        if (_selectedDistress != null) 'distressLevel': _selectedDistress,
      };
    }

    // Build appearances
    List<String> appearances =
        _appearance.entries.where((e) => e.value).map((e) => e.key).toList();

    // Build observations (as array for backend validation)
    List<String> observations =
        _observations.entries.where((e) => e.value).map((e) => e.key).toList();

    // Build custom sections
    List<Map<String, dynamic>> customSections =
        _customSections.map((section) {
          final optionsList =
              section.options.map((opt) {
                return {
                  'value': opt,
                  'selected': section.selectedOptions[opt] ?? false,
                };
              }).toList();

          return {
            'title': section.title,
            'icon': section.icon.codePoint.toString(),
            'color':
                '#${section.color.value.toRadixString(16).padLeft(8, '0').substring(2)}',
            'options': optionsList,
            if (section.textController?.text.trim().isNotEmpty ?? false)
              'notes': section.textController!.text.trim(),
          };
        }).toList();

    // Ensure chiefComplaint is built at submission time
    if (chiefComplaint == null) {
      String complaintText;
      if (_selectedChiefComplaint == 'Other') {
        complaintText = _customComplaintController.text.trim();
      } else {
        complaintText = _selectedChiefComplaint ?? '';
      }
      if (complaintText.isNotEmpty) {
        chiefComplaint = {
          'text': complaintText,
          'preset':
              _selectedChiefComplaint != 'Other'
                  ? _selectedChiefComplaint
                  : null,
          'isQuoted': _isQuotedComplaint,
        };
      }
    }

    return {
      'patient_id': patient.id,
      'patient_mrn': patient.mrn,
      'encounter_type': _selectedEncounterType,
      'encounter_datetime': _selectedDateTime.toIso8601String(),
      'chiefComplaint':
          chiefComplaint, // Always include, will be null if not set
      if (painAssessment != null) 'painAssessment': painAssessment,
      'allergies': allergies,
      if (symptoms.isNotEmpty) 'symptoms': symptoms,
      if (patientCondition != null) 'patientCondition': patientCondition,
      if (appearances.isNotEmpty) 'appearances': appearances,
      if (observations.isNotEmpty) 'observations': observations,
      if (_observationsController.text.trim().isNotEmpty)
        'observationsNotes': _observationsController.text.trim(),
      if (_notesForDoctorController.text.trim().isNotEmpty)
        'notesForDoctor': _notesForDoctorController.text.trim(),
      if (_handoffSummaryController.text.trim().isNotEmpty)
        'handoffSummary': _handoffSummaryController.text.trim(),
      'handoffAutoGenerated': !_handoffEdited,
      if (customSections.isNotEmpty) 'customSections': customSections,
      'status': 'draft',
    };
  }

  /// Save encounter note as draft
  Future<void> _saveEncounterNoteDraft() async {
    final patient = _patient;
    if (patient == null) {
      _showErrorSnackBar('No patient selected');
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final noteData = _buildEncounterNoteData();

      ApiResponse response;
      if (_currentNoteId != null) {
        // Update existing draft
        response = await ApiService.updateEncounterNote(
          _currentNoteId!,
          noteData,
        );
      } else {
        // Create new draft
        response = await ApiService.createEncounterNote(noteData);
      }

      if (response.success && response.data != null) {
        final data = response.data;
        setState(() {
          _currentNoteId = data['data']?['id'] ?? data['id'] ?? _currentNoteId;
          _lastSavedAt = DateFormat('MMM d, h:mm a').format(DateTime.now());
        });

        _showSuccessSnackBar('Draft saved successfully');
      } else {
        _showErrorSnackBar(response.error ?? 'Failed to save draft');
      }
    } catch (e) {
      _showErrorSnackBar('Error saving draft: $e');
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  /// Submit encounter note for doctor review
  Future<void> _submitEncounterNoteForReview() async {
    final patient = _patient;
    if (patient == null) {
      _showErrorSnackBar('No patient selected');
      return;
    }

    // Validate required fields
    // Check if chief complaint has valid text
    String? chiefComplaintText;
    if (_selectedChiefComplaint != null) {
      if (_selectedChiefComplaint == 'Other') {
        chiefComplaintText = _customComplaintController.text.trim();
      } else {
        chiefComplaintText = _selectedChiefComplaint;
      }
    }

    if (chiefComplaintText == null || chiefComplaintText.isEmpty) {
      _showErrorSnackBar('Please select or enter a chief complaint');
      return;
    }

    if (_handoffSummaryController.text.trim().isEmpty) {
      _showErrorSnackBar('Handoff summary is required');
      return;
    }

    // Check if at least one symptom or observation is recorded
    final hasSymptoms = _symptoms.values.any((selected) => selected);
    final hasObservations = _observations.values.any((selected) => selected);

    if (!hasSymptoms && !hasObservations) {
      _showErrorSnackBar(
        'At least one symptom or observation must be recorded',
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // First save the draft if not already saved
      if (_currentNoteId == null) {
        final noteData = _buildEncounterNoteData();
        final createResponse = await ApiService.createEncounterNote(noteData);

        if (!createResponse.success || createResponse.data == null) {
          _showErrorSnackBar(
            createResponse.error ?? 'Failed to create encounter note',
          );
          return;
        }

        _currentNoteId =
            createResponse.data['data']?['id'] ?? createResponse.data['id'];
      } else {
        // Update the draft first
        final noteData = _buildEncounterNoteData();
        await ApiService.updateEncounterNote(_currentNoteId!, noteData);
      }

      // Now submit for review
      // Generate a simple signature (in production, use proper digital signature)
      final signature = 'NURSE_SIG_${DateTime.now().millisecondsSinceEpoch}';

      final submitResponse = await ApiService.submitEncounterNote(
        _currentNoteId!,
        nurseSignature: signature,
      );

      if (submitResponse.success) {
        setState(() {
          _noteStatus = 'submitted';
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, color: Colors.white),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text('Encounter note submitted for doctor review'),
                  ),
                ],
              ),
              backgroundColor: AppColors.emerald,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.all(16),
              duration: const Duration(seconds: 4),
            ),
          );
        }

        // Clear form after successful submission
        _clearForm();
      } else {
        _showErrorSnackBar(
          submitResponse.error ?? 'Failed to submit encounter note',
        );
      }
    } catch (e) {
      _showErrorSnackBar('Error submitting: $e');
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  /// Clear all form fields
  void _clearForm() {
    setState(() {
      _selectedChiefComplaint = null;
      _customComplaintController.clear();
      _isQuotedComplaint = false;
      _painScore = 0;
      _selectedPainLocation = null;
      _selectedPainType = null;
      _selectedPainDuration = null;
      _painNotesController.clear();
      _drugAllergies.clear();
      _foodAllergies.clear();
      _otherAllergies.clear();
      _noKnownAllergies = false;
      _symptoms.updateAll((key, value) => false);
      _symptomDurations.clear();
      _symptomSeverities.clear();
      _selectedCondition = null;
      _selectedAlertness = null;
      _selectedDistress = null;
      _appearance.updateAll((key, value) => false);
      _observations.updateAll((key, value) => false);
      _observationsController.clear();
      _notesForDoctorController.clear();
      _handoffSummaryController.clear();
      _handoffEdited = false;
      _customSections.clear();
      _currentNoteId = null;
      _noteStatus = 'draft';
      _lastSavedAt = null;
    });
  }

  void _showSuccessSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.emerald,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_rounded, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.rose,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required Color color,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: AppColors.textMuted),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 16, right: 12),
            child: Icon(icon, color: color, size: 22),
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 0),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildCustomSection(CustomSection section) {
    return _buildCollapsibleSection(
      key: section.id,
      title: section.title,
      icon: section.icon,
      color: section.color,
      isCustom: true,
      onDelete: () {
        setState(() {
          section.textController?.dispose();
          _customSections.remove(section);
        });
        _savePreferences();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (section.options.isNotEmpty)
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children:
                  section.options.map((option) {
                    return _buildToggleChip(
                      option,
                      section.selectedOptions[option] ?? false,
                      section.color,
                      () {
                        setState(() {
                          section.selectedOptions[option] =
                              !(section.selectedOptions[option] ?? false);
                        });
                        _savePreferences();
                      },
                    );
                  }).toList(),
            ),
          if (section.textController != null) ...[
            if (section.options.isNotEmpty) const SizedBox(height: 16),
            _buildModernTextField(
              controller: section.textController!,
              hintText:
                  section.options.isEmpty
                      ? 'Enter notes...'
                      : 'Additional notes...',
              icon: Icons.edit_outlined,
              color: section.color,
              maxLines: 2,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAddCustomSectionButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.textMuted.withOpacity(0.3),
          width: 2,
          style: BorderStyle.solid,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _showAddCustomSectionDialog,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryStart.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.add_rounded,
                    color: AppColors.primaryStart,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Add Custom Section',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCollapsibleSection({
    required String key,
    required String title,
    required IconData icon,
    required Color color,
    required Widget child,
    bool isCustom = false,
    VoidCallback? onDelete,
  }) {
    final isCollapsed = _sectionCollapsed[key] ?? false;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: color.withOpacity(0.15), width: 1.5),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _sectionCollapsed[key] = !isCollapsed;
              });
              _savePreferences();
            },
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color.withOpacity(0.08), color.withOpacity(0.02)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(
                  top: const Radius.circular(20),
                  bottom: isCollapsed ? const Radius.circular(20) : Radius.zero,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [color, color.withOpacity(0.8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(icon, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: color,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                  if (isCustom && onDelete != null)
                    IconButton(
                      icon: Icon(
                        Icons.delete_outline_rounded,
                        color: AppColors.rose,
                      ),
                      onPressed: onDelete,
                    ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      isCollapsed
                          ? Icons.expand_more_rounded
                          : Icons.expand_less_rounded,
                      color: color,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!isCollapsed)
            Container(padding: const EdgeInsets.all(18), child: child),
        ],
      ),
    );
  }

  Widget _buildSubsectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildToggleChip(
    String label,
    bool isSelected,
    Color color,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            gradient:
                isSelected
                    ? LinearGradient(
                      colors: [color, color.withOpacity(0.85)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                    : null,
            color: isSelected ? null : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: isSelected ? color : AppColors.textMuted.withOpacity(0.2),
              width: isSelected ? 2 : 1,
            ),
            boxShadow:
                isSelected
                    ? [
                      BoxShadow(
                        color: color.withOpacity(0.35),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                    : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child:
                    isSelected
                        ? const Icon(
                          Icons.check_circle_rounded,
                          size: 18,
                          color: Colors.white,
                        )
                        : Icon(
                          Icons.circle_outlined,
                          size: 18,
                          color: AppColors.textMuted,
                        ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddCustomSectionDialog() {
    final titleController = TextEditingController();
    final optionsController = TextEditingController();
    Color selectedColor = _availableColors[0];
    IconData selectedIcon = Icons.category_rounded;

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setDialogState) => Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      AppColors.primaryStart,
                                      AppColors.primaryEnd,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.add_rounded,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Add Custom Section',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          _buildModernTextField(
                            controller: titleController,
                            hintText: 'Section Title',
                            icon: Icons.title_rounded,
                            color: selectedColor,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Select Color',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children:
                                _availableColors.map((color) {
                                  final isColorSelected =
                                      selectedColor == color;
                                  return InkWell(
                                    onTap: () {
                                      setDialogState(() {
                                        selectedColor = color;
                                      });
                                    },
                                    borderRadius: BorderRadius.circular(50),
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: color,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color:
                                              isColorSelected
                                                  ? Colors.white
                                                  : Colors.transparent,
                                          width: 3,
                                        ),
                                        boxShadow:
                                            isColorSelected
                                                ? [
                                                  BoxShadow(
                                                    color: color.withOpacity(
                                                      0.5,
                                                    ),
                                                    blurRadius: 12,
                                                    spreadRadius: 2,
                                                  ),
                                                ]
                                                : null,
                                      ),
                                      child:
                                          isColorSelected
                                              ? const Icon(
                                                Icons.check,
                                                color: Colors.white,
                                                size: 22,
                                              )
                                              : null,
                                    ),
                                  );
                                }).toList(),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Select Icon',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children:
                                [
                                  Icons.category_rounded,
                                  Icons.assessment_rounded,
                                  Icons.local_hospital_rounded,
                                  Icons.healing_rounded,
                                  Icons.favorite_rounded,
                                  Icons.psychology_rounded,
                                  Icons.medication_rounded,
                                  Icons.bloodtype_rounded,
                                  Icons.vaccines_rounded,
                                  Icons.accessibility_new_rounded,
                                ].map((icon) {
                                  final isIconSelected = selectedIcon == icon;
                                  return InkWell(
                                    onTap: () {
                                      setDialogState(() {
                                        selectedIcon = icon;
                                      });
                                    },
                                    borderRadius: BorderRadius.circular(12),
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color:
                                            isIconSelected
                                                ? selectedColor.withOpacity(
                                                  0.15,
                                                )
                                                : AppColors.surfaceLight,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color:
                                              isIconSelected
                                                  ? selectedColor
                                                  : Colors.transparent,
                                          width: 2,
                                        ),
                                      ),
                                      child: Icon(
                                        icon,
                                        color:
                                            isIconSelected
                                                ? selectedColor
                                                : AppColors.textMuted,
                                        size: 24,
                                      ),
                                    ),
                                  );
                                }).toList(),
                          ),
                          const SizedBox(height: 20),
                          _buildModernTextField(
                            controller: optionsController,
                            hintText: 'Options (comma-separated)',
                            icon: Icons.list_rounded,
                            color: selectedColor,
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => Navigator.pop(context),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    side: BorderSide(
                                      color: AppColors.textMuted.withOpacity(
                                        0.3,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 2,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (titleController.text
                                        .trim()
                                        .isNotEmpty) {
                                      final options =
                                          optionsController.text
                                              .split(',')
                                              .map((e) => e.trim())
                                              .where((e) => e.isNotEmpty)
                                              .toList();

                                      final newSection = CustomSection(
                                        id:
                                            DateTime.now()
                                                .millisecondsSinceEpoch
                                                .toString(),
                                        title: titleController.text.trim(),
                                        icon: selectedIcon,
                                        color: selectedColor,
                                        options: options,
                                        textController: TextEditingController(),
                                      );

                                      setState(() {
                                        _customSections.add(newSection);
                                      });

                                      _savePreferences();
                                      Navigator.pop(context);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: selectedColor,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 4,
                                    shadowColor: selectedColor.withOpacity(0.5),
                                  ),
                                  child: const Text(
                                    'Add Section',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
          ),
    );
  }

  Widget _buildBottomButtons() {
    final selectedItems = _getSelectedItems();
    final hasSelections = selectedItems.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Status bar
          if (_lastSavedAt != null || _currentNoteId != null)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _noteStatus == 'submitted'
                        ? Icons.send_rounded
                        : Icons.cloud_done_outlined,
                    size: 16,
                    color:
                        _noteStatus == 'submitted'
                            ? AppColors.emerald
                            : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _noteStatus == 'submitted'
                        ? 'Submitted for review'
                        : _lastSavedAt != null
                        ? 'Draft saved at $_lastSavedAt'
                        : 'Draft',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          Row(
            children: [
              // Clear button
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.textMuted.withOpacity(0.2),
                  ),
                ),
                child: IconButton(
                  onPressed: _noteStatus != 'submitted' ? _clearForm : null,
                  icon: Icon(
                    Icons.clear_rounded,
                    color: AppColors.textSecondary,
                  ),
                  tooltip: 'Clear all',
                ),
              ),
              const SizedBox(width: 12),
              // Save Draft button
              Expanded(
                child: ElevatedButton.icon(
                  onPressed:
                      _noteStatus != 'submitted' && !_isSaving
                          ? _saveEncounterNoteDraft
                          : null,
                  icon:
                      _isSaving
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : const Icon(Icons.save_outlined, size: 20),
                  label: Text(_isSaving ? 'Saving...' : 'Save Draft'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.textSecondary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Review & Submit button
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed:
                      hasSelections &&
                              _noteStatus != 'submitted' &&
                              !_isSubmitting
                          ? _showReviewSheet
                          : null,
                  icon:
                      _isSubmitting
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : const Icon(Icons.rate_review_outlined, size: 20),
                  label: Text(
                    _noteStatus == 'submitted'
                        ? 'Submitted'
                        : hasSelections
                        ? 'Review & Submit'
                        : 'Select Items',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _noteStatus == 'submitted'
                            ? AppColors.emerald
                            : hasSelections
                            ? AppColors.primaryStart
                            : AppColors.textMuted,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation:
                        hasSelections && _noteStatus != 'submitted' ? 8 : 0,
                    shadowColor: AppColors.primaryStart.withOpacity(0.4),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showReviewSheet() {
    final selectedItems = _getSelectedItems();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => DraggableScrollableSheet(
            initialChildSize: 0.85,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            builder:
                (context, scrollController) => Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Handle bar
                      Container(
                        margin: const EdgeInsets.only(top: 12),
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.textMuted.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      // Header
                      Container(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    AppColors.primaryStart,
                                    AppColors.primaryEnd,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                Icons.checklist_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Review Encounter Note',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  '${selectedItems.values.fold<int>(0, (sum, list) => sum + list.length)} items selected',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(
                                Icons.close_rounded,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                      // Content
                      Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          padding: const EdgeInsets.all(20),
                          itemCount: selectedItems.length,
                          itemBuilder: (context, index) {
                            final entry = selectedItems.entries.elementAt(
                              index,
                            );
                            final sectionName = entry.key;
                            final items = entry.value;
                            final color =
                                _sectionColors[sectionName] ??
                                _customSections
                                    .firstWhere(
                                      (s) => s.title == sectionName,
                                      orElse:
                                          () => CustomSection(
                                            id: '',
                                            title: '',
                                            icon: Icons.category,
                                            color: AppColors.primaryStart,
                                            options: [],
                                          ),
                                    )
                                    .color;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: color.withOpacity(0.15),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: color,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Icon(
                                          _getSectionIcon(sectionName),
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        sectionName,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: color,
                                        ),
                                      ),
                                      const Spacer(),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: color.withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          '${items.length}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: color,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  // Special handling for Handoff Summary - display as full-width text block
                                  if (sectionName == 'Handoff Summary')
                                    ...items.map((item) {
                                      return Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(14),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: color.withOpacity(0.2),
                                          ),
                                        ),
                                        child: Text(
                                          item,
                                          style: TextStyle(
                                            fontSize: 13,
                                            height: 1.6,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      );
                                    })
                                  else
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children:
                                          items.map((item) {
                                            final isNote = item.startsWith(
                                              'Notes:',
                                            );
                                            if (isNote) {
                                              return Container(
                                                width: double.infinity,
                                                padding: const EdgeInsets.all(
                                                  12,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                    color: color.withOpacity(
                                                      0.2,
                                                    ),
                                                  ),
                                                ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                      Icons.notes_rounded,
                                                      size: 16,
                                                      color: color,
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Expanded(
                                                      child: Text(
                                                        item.replaceFirst(
                                                          'Notes: ',
                                                          '',
                                                        ),
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          color:
                                                              AppColors
                                                                  .textPrimary,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }
                                            return Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 8,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                  color: color.withOpacity(0.3),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.check_circle_rounded,
                                                    size: 16,
                                                    color: color,
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Flexible(
                                                    child: Text(
                                                      item,
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            AppColors
                                                                .textPrimary,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      // Submit button
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, -4),
                            ),
                          ],
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            _submitEncounterNoteForReview();
                          },
                          icon: const Icon(Icons.send_rounded, size: 20),
                          label: const Text('Submit to Doctor'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.emerald,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 56),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 8,
                            shadowColor: AppColors.emerald.withOpacity(0.4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
          ),
    );
  }

  IconData _getSectionIcon(String sectionName) {
    switch (sectionName) {
      case 'Chief Complaint':
        return Icons.record_voice_over_outlined;
      case 'Pain Assessment':
        return Icons.sentiment_dissatisfied_outlined;
      case 'Allergies':
        return Icons.warning_amber_outlined;
      case 'Presenting Symptoms':
        return Icons.healing_outlined;
      case 'Patient Condition':
        return Icons.monitor_heart_outlined;
      case 'Clinical Observations':
        return Icons.assignment_outlined;
      case 'Notes for Doctor':
        return Icons.medical_information_outlined;
      case 'Handoff Summary':
        return Icons.summarize_outlined;
      default:
        return Icons.category_rounded;
    }
  }
}
