import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schmgtsystem/models/family_history_model.dart';
import 'package:schmgtsystem/providers/patient_proviider.dart';
import 'package:schmgtsystem/services/api_service.dart';

class MedicalHistoryScreen extends StatefulWidget {
  const MedicalHistoryScreen({super.key, required this.goBack});
  final Null Function() goBack;
  @override
  State<MedicalHistoryScreen> createState() => _MedicalHistoryScreenState();
}

class _MedicalHistoryScreenState extends State<MedicalHistoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _conditionController = TextEditingController();
  final _relationController = TextEditingController();
  final _notesController = TextEditingController();

  // Social History Controllers
  final _packsPerDayController = TextEditingController();
  final _drinksPerSessionController = TextEditingController();
  final _occupationController = TextEditingController();
  final _workHazardsController = TextEditingController();
  final _startDateController = TextEditingController();

  bool _isHighRisk = false;
  FamilyMedicalCondition? _editingCondition;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with default values
    _packsPerDayController.text = '0';
    _drinksPerSessionController.text = '0';
    _occupationController.text = '';
    _workHazardsController.text = '';
    _startDateController.text = '';
    _loadFamilyHistory();
  }

  @override
  void dispose() {
    _conditionController.dispose();
    _relationController.dispose();
    _notesController.dispose();
    _packsPerDayController.dispose();
    _drinksPerSessionController.dispose();
    _occupationController.dispose();
    _workHazardsController.dispose();
    _startDateController.dispose();
    super.dispose();
  }

  void _loadFamilyHistory() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final patientProvider = Provider.of<PatientProvider>(
        context,
        listen: false,
      );
      var patient = patientProvider.currentPatient;

      if (patient != null) {
        patientProvider.fetchFamilyHistory(patient.id);
        patientProvider.fetchSocialHistory(patient.id).then((_) {
          _loadSocialHistoryData();
        });
      }
    });
  }

  void _loadSocialHistoryData() {
    final patientProvider = Provider.of<PatientProvider>(
      context,
      listen: false,
    );
    final socialHistory = patientProvider.socialHistory;

    if (socialHistory != null) {
      setState(() {
        smokingStatus = socialHistory['smokingStatus'] ?? 'Never Smoker';
        packsPerDay = socialHistory['packsPerDay'] ?? 0;
        _packsPerDayController.text = packsPerDay.toString();

        if (socialHistory['smokingStartDate'] != null) {
          startDate = DateTime.parse(socialHistory['smokingStartDate']);
          _startDateController.text =
              '${startDate.month.toString().padLeft(2, '0')}/${startDate.day.toString().padLeft(2, '0')}/${startDate.year}';
        } else {
          _startDateController.text = '';
        }

        alcoholFrequency = socialHistory['alcoholFrequency'] ?? 'Never';
        drinksPerSession = socialHistory['drinksPerSession'] ?? 0;
        _drinksPerSessionController.text = drinksPerSession.toString();

        physicalActivityLevel =
            socialHistory['physicalActivityLevel'] ?? 'Sedentary';
        dietaryHabits = socialHistory['dietaryHabits'] ?? 'Omnivore';
        livingSituation = socialHistory['livingSituation'] ?? 'With Family';

        occupation = socialHistory['occupation'] ?? '';
        _occupationController.text = occupation;

        workHazards = socialHistory['workHazards'] ?? '';
        _workHazardsController.text = workHazards;
      });
    } else {
      // Reset to defaults if no data
      setState(() {
        _packsPerDayController.text = '0';
        _drinksPerSessionController.text = '0';
        _occupationController.text = '';
        _workHazardsController.text = '';
        _startDateController.text = '';
      });
    }
  }

  // Social History Form Fields
  String smokingStatus = 'Never Smoker';
  int packsPerDay = 0;
  DateTime startDate = DateTime.now();
  String alcoholFrequency = 'Never';
  int drinksPerSession = 0;
  String physicalActivityLevel = 'Sedentary';
  String dietaryHabits = 'Omnivore';
  String livingSituation = 'With Family';
  String occupation = '';
  String workHazards = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Medical History',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => widget.goBack(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFamilyMedicalHistorySection(),
              const SizedBox(height: 24),
              _buildSocialHistorySection(),
              const SizedBox(height: 24),
              _buildHighRiskWarning(),
              const SizedBox(height: 32),
              _buildUpdateButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFamilyMedicalHistorySection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.people, color: Colors.teal[600]),
                    const SizedBox(width: 8),
                    const Text(
                      'Family Medical History',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () => _showAddFamilyHistoryDialog(),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add Family History'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal[600],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Consumer<PatientProvider>(
            builder: (context, patientProvider, _) {
              final familyConditions = patientProvider.familyHistory;
              final summary = patientProvider.familyHistorySummary;

              if (patientProvider.isLoading && familyConditions.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (familyConditions.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Center(
                    child: Text(
                      'No family history records found',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ),
                );
              }

              return Column(
                children: [
                  ...familyConditions.map(
                    (condition) => _buildFamilyConditionTile(condition),
                  ),
                  if (summary != null && summary.hasHighRisk)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red[200]!),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.warning,
                              color: Colors.red[600],
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'High Risk Profile\nFamily history indicates elevated risk for cardiovascular disease and cancer. Regular screening recommended.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black87,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFamilyConditionTile(FamilyMedicalCondition condition) {
    final color = condition.color ?? Colors.blue;
    final icon = condition.icon ?? Icons.medical_services;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      condition.condition,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        condition.relation,
                        style: TextStyle(
                          fontSize: 11,
                          color: color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                if (condition.isHighRisk)
                  const Text(
                    'High Risk Factor',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () => _editFamilyCondition(condition),
                icon: const Icon(Icons.edit, size: 16),
                color: Colors.grey[600],
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
              IconButton(
                onPressed: () => _deleteFamilyCondition(condition),
                icon: const Icon(Icons.delete, size: 16),
                color: Colors.grey[600],
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialHistorySection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.people_outline, color: Colors.teal[600]),
                const SizedBox(width: 8),
                const Text(
                  'Social History',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildSmokingSection(),
            const SizedBox(height: 20),
            _buildAlcoholSection(),
            const SizedBox(height: 20),
            _buildDropdownField(
              'Physical Activity Level',
              physicalActivityLevel,
              ['Sedentary', 'Light', 'Moderate', 'Heavy'],
              (value) => setState(() => physicalActivityLevel = value!),
            ),
            const SizedBox(height: 16),
            _buildDropdownField(
              'Dietary Habits',
              dietaryHabits,
              [
                'Omnivore',
                'Vegetarian',
                'Vegan',
                'Pescatarian',
                'Keto',
                'Mediterranean',
              ],
              (value) => setState(() => dietaryHabits = value!),
            ),
            const SizedBox(height: 16),
            _buildDropdownField(
              'Living Situation',
              livingSituation,
              [
                'With Family',
                'Alone',
                'With Roommates',
                'Assisted Living',
                'Nursing Home',
              ],
              (value) => setState(() => livingSituation = value!),
            ),
            const SizedBox(height: 20),
            _buildOccupationSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildSmokingSection() {
    final showSmokingDetails =
        smokingStatus == 'Former Smoker' || smokingStatus == 'Current Smoker';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _buildDropdownField(
                'Smoking Status',
                smokingStatus,
                ['Never Smoker', 'Former Smoker', 'Current Smoker'],
                (value) {
                  setState(() {
                    smokingStatus = value!;
                    // Reset smoking-related fields if "Never Smoker"
                    if (smokingStatus == 'Never Smoker') {
                      packsPerDay = 0;
                      _packsPerDayController.text = '0';
                      _startDateController.text = '';
                    }
                  });
                },
              ),
            ),
            if (showSmokingDetails) ...[
              const SizedBox(width: 16),
              Expanded(
                child: _buildNumberField(
                  'Packs per Day',
                  _packsPerDayController,
                  (value) {
                    setState(() => packsPerDay = value);
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDateField(
                  'Start Date',
                  _startDateController,
                  startDate,
                  (date) {
                    setState(() {
                      startDate = date;
                      _startDateController.text =
                          '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
                    });
                  },
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildAlcoholSection() {
    return Row(
      children: [
        Expanded(
          child: _buildDropdownField(
            'Alcohol Frequency',
            alcoholFrequency,
            ['Never', 'Rarely', 'Weekly', 'Daily'],
            (value) => setState(() => alcoholFrequency = value!),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildNumberField(
            'Drinks per Session',
            _drinksPerSessionController,
            (value) {
              setState(() => drinksPerSession = value);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildOccupationSection() {
    return Row(
      children: [
        Expanded(
          child: _buildTextFormField('Occupation', _occupationController, (
            value,
          ) {
            setState(() => occupation = value);
          }),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildTextFormField(
            'Work Hazards',
            _workHazardsController,
            (value) {
              setState(() => workHazards = value);
            },
            hintText: 'e.g., Chemical exposure, Repetitive motion',
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(
    String label,
    String value,
    List<String> options,
    Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.teal[600]!),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 16,
            ),
          ),
          items:
              options
                  .map(
                    (option) =>
                        DropdownMenuItem(value: option, child: Text(option)),
                  )
                  .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildNumberField(
    String label,
    TextEditingController controller,
    Function(int) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.teal[600]!),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 16,
            ),
          ),
          onChanged: (val) {
            final intValue = int.tryParse(val);
            if (intValue != null && intValue >= 0) {
              onChanged(intValue);
            }
          },
        ),
      ],
    );
  }

  Widget _buildDateField(
    String label,
    TextEditingController controller,
    DateTime value,
    Function(DateTime) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          readOnly: true,
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.teal[600]!),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 16,
            ),
            suffixIcon: const Icon(Icons.calendar_today, size: 20),
          ),
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: value,
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (date != null) {
              onChanged(date);
            }
          },
        ),
      ],
    );
  }

  Widget _buildTextFormField(
    String label,
    TextEditingController controller,
    Function(String) onChanged, {
    String? hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.teal[600]!),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 16,
            ),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildHighRiskWarning() {
    // Show warning if current smoker or daily alcohol consumption
    final showWarning =
        smokingStatus == 'Current Smoker' ||
        (alcoholFrequency == 'Daily' && drinksPerSession > 0);

    if (!showWarning) {
      return const SizedBox.shrink();
    }

    String warningText = '';
    if (smokingStatus == 'Current Smoker' && alcoholFrequency == 'Daily') {
      warningText =
          'High Risk: Current smoking and daily alcohol consumption detected';
    } else if (smokingStatus == 'Current Smoker') {
      warningText = 'High Risk: Current smoking habit detected';
    } else if (alcoholFrequency == 'Daily') {
      warningText = 'High Risk: Daily alcohol consumption detected';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.warning, color: Colors.red[600], size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              warningText,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _updateMedicalHistory(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal[600],
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: const Text(
          'Update Medical History',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  void _showAddFamilyHistoryDialog() {
    _editingCondition = null;
    _conditionController.clear();
    _relationController.clear();
    _notesController.clear();
    _isHighRisk = false;

    showDialog(
      context: context,
      builder: (context) => _buildFamilyHistoryDialog(),
    );
  }

  void _editFamilyCondition(FamilyMedicalCondition condition) {
    _editingCondition = condition;
    _conditionController.text = condition.condition;
    _relationController.text = condition.relation;
    _notesController.text = condition.notes ?? '';
    _isHighRisk = condition.isHighRisk;

    showDialog(
      context: context,
      builder: (context) => _buildFamilyHistoryDialog(),
    );
  }

  void _deleteFamilyCondition(FamilyMedicalCondition condition) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Family History'),
            content: Text(
              'Are you sure you want to delete "${condition.condition}" for ${condition.relation}?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  final patientProvider = Provider.of<PatientProvider>(
                    context,
                    listen: false,
                  );
                  final patient = patientProvider.currentPatient;
                  if (patient != null) {
                    final response = await patientProvider.deleteFamilyHistory(
                      patient.id,
                      condition.id,
                    );
                    if (response.success) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Family history deleted successfully',
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    } else {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              response.error ??
                                  'Failed to delete family history',
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }

  Widget _buildFamilyHistoryDialog() {
    return AlertDialog(
      title: Text(
        _editingCondition == null
            ? 'Add Family History'
            : 'Edit Family History',
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _conditionController,
              decoration: const InputDecoration(
                labelText: 'Condition *',
                hintText: 'e.g., Hypertension, Diabetes Type 2',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Condition is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value:
                  _relationController.text.isEmpty
                      ? null
                      : _relationController.text,
              decoration: const InputDecoration(
                labelText: 'Relation *',
                border: OutlineInputBorder(),
              ),
              items:
                  const [
                    'Father',
                    'Mother',
                    'Paternal Grandfather',
                    'Paternal Grandmother',
                    'Maternal Grandfather',
                    'Maternal Grandmother',
                    'Sibling',
                    'Paternal Uncle',
                    'Paternal Aunt',
                    'Maternal Uncle',
                    'Maternal Aunt',
                    'Son',
                    'Daughter',
                    'Other',
                  ].map((relation) {
                    return DropdownMenuItem(
                      value: relation,
                      child: Text(relation),
                    );
                  }).toList(),
              onChanged: (value) {
                if (value != null) {
                  _relationController.text = value;
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Relation is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text('High Risk Factor'),
              value: _isHighRisk,
              onChanged: (value) {
                setState(() {
                  _isHighRisk = value ?? false;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (Optional)',
                hintText: 'Additional information about the condition',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            _editingCondition = null;
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_conditionController.text.trim().isEmpty ||
                _relationController.text.trim().isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please fill in all required fields'),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }

            final patientProvider = Provider.of<PatientProvider>(
              context,
              listen: false,
            );
            final patient = patientProvider.currentPatient;

            if (patient == null) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('No patient selected'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
              return;
            }

            final familyHistoryData = {
              'condition': _conditionController.text.trim(),
              'relation': _relationController.text.trim(),
              'isHighRisk': _isHighRisk,
              if (_notesController.text.trim().isNotEmpty)
                'notes': _notesController.text.trim(),
            };

            ApiResponse response;
            if (_editingCondition == null) {
              response = await patientProvider.createFamilyHistory(
                patient.id,
                familyHistoryData,
              );
            } else {
              response = await patientProvider.updateFamilyHistory(
                patient.id,
                _editingCondition!.id,
                familyHistoryData,
              );
            }

            if (mounted) {
              Navigator.pop(context);
              _editingCondition = null;

              if (response.success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      _editingCondition == null
                          ? 'Family history added successfully'
                          : 'Family history updated successfully',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      response.error ??
                          'Failed to ${_editingCondition == null ? "add" : "update"} family history',
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal[600],
            foregroundColor: Colors.white,
          ),
          child: Text(_editingCondition == null ? 'Add' : 'Update'),
        ),
      ],
    );
  }

  void _updateMedicalHistory() async {
    if (_formKey.currentState!.validate()) {
      final patientProvider = Provider.of<PatientProvider>(
        context,
        listen: false,
      );
      final patient = patientProvider.currentPatient;

      if (patient == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No patient selected'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Read values from controllers to ensure we have the latest data
      final packsPerDayValue =
          int.tryParse(_packsPerDayController.text) ?? packsPerDay;
      final drinksPerSessionValue =
          int.tryParse(_drinksPerSessionController.text) ?? drinksPerSession;
      final occupationValue = _occupationController.text.trim();
      final workHazardsValue = _workHazardsController.text.trim();

      // Prepare social history data
      final socialHistoryData = <String, dynamic>{
        'smokingStatus': smokingStatus,
        'alcoholFrequency': alcoholFrequency,
        'physicalActivityLevel': physicalActivityLevel,
        'dietaryHabits': dietaryHabits,
        'livingSituation': livingSituation,
      };

      // Add conditional fields
      if (smokingStatus == 'Former Smoker' ||
          smokingStatus == 'Current Smoker') {
        socialHistoryData['packsPerDay'] = packsPerDayValue;
        if (_startDateController.text.isNotEmpty) {
          socialHistoryData['smokingStartDate'] = startDate.toIso8601String();
        }
      } else {
        socialHistoryData['packsPerDay'] = 0;
        socialHistoryData['smokingStartDate'] = null;
      }

      if (alcoholFrequency != 'Never') {
        socialHistoryData['drinksPerSession'] = drinksPerSessionValue;
      } else {
        socialHistoryData['drinksPerSession'] = 0;
      }

      // Add optional fields (only if not empty)
      if (occupationValue.isNotEmpty) {
        socialHistoryData['occupation'] = occupationValue;
      }
      if (workHazardsValue.isNotEmpty) {
        socialHistoryData['workHazards'] = workHazardsValue;
      }

      // Use upsert (PUT) to create or update
      final response = await patientProvider.updateSocialHistory(
        patient.id,
        socialHistoryData,
      );

      if (mounted) {
        if (response.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Medical history updated successfully'),
              backgroundColor: Colors.teal,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                response.error ?? 'Failed to update medical history',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
