import 'package:flutter/material.dart';

class MedicalHistoryScreen extends StatefulWidget {
  MedicalHistoryScreen({super.key, required this.goBack});
  Null Function() goBack;
  @override
  State<MedicalHistoryScreen> createState() => _MedicalHistoryScreenState();
}

class _MedicalHistoryScreenState extends State<MedicalHistoryScreen> {
  final _formKey = GlobalKey<FormState>();

  // Family Medical History
  List<FamilyMedicalCondition> familyConditions = [
    FamilyMedicalCondition(
      condition: 'Hypertension',
      relation: 'Father',
      isHighRisk: true,
      icon: Icons.favorite,
      color: Colors.red,
    ),
    FamilyMedicalCondition(
      condition: 'Diabetes Type 2',
      relation: 'Mother',
      isHighRisk: false,
      icon: Icons.water_drop,
      color: Colors.orange,
    ),
    FamilyMedicalCondition(
      condition: 'Breast Cancer',
      relation: 'Maternal Aunt',
      isHighRisk: true,
      icon: Icons.health_and_safety,
      color: Colors.pink,
    ),
  ];

  // Social History Form Fields
  String smokingStatus = 'Current Smoker';
  int packsPerDay = 1;
  DateTime startDate = DateTime(2010, 1, 1);
  String alcoholFrequency = 'Daily';
  int drinksPerSession = 2;
  String physicalActivityLevel = 'Sedentary';
  String dietaryHabits = 'Omnivore';
  String livingSituation = 'With Family';
  String occupation = 'Software Engineer';
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
          ...familyConditions.map(
            (condition) => _buildFamilyConditionTile(condition),
          ),
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
                  Icon(Icons.warning, color: Colors.red[600], size: 20),
                  const SizedBox(width: 8),
                  const Expanded(
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
      ),
    );
  }

  Widget _buildFamilyConditionTile(FamilyMedicalCondition condition) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: condition.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: condition.color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(condition.icon, color: condition.color, size: 20),
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
                        color: condition.color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        condition.relation,
                        style: TextStyle(
                          fontSize: 11,
                          color: condition.color,
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
                (value) => setState(() => smokingStatus = value!),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildNumberField('Packs per Day', packsPerDay, (value) {
                setState(() => packsPerDay = value);
              }),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDateField('Start Date', startDate, (date) {
                setState(() => startDate = date);
              }),
            ),
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
          child: _buildNumberField('Drinks per Session', drinksPerSession, (
            value,
          ) {
            setState(() => drinksPerSession = value);
          }),
        ),
      ],
    );
  }

  Widget _buildOccupationSection() {
    return Row(
      children: [
        Expanded(
          child: _buildTextFormField('Occupation', occupation, (value) {
            setState(() => occupation = value);
          }),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildTextFormField(
            'Work Hazards',
            workHazards,
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

  Widget _buildNumberField(String label, int value, Function(int) onChanged) {
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
          initialValue: value.toString(),
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
            if (intValue != null) onChanged(intValue);
          },
        ),
      ],
    );
  }

  Widget _buildDateField(
    String label,
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
          controller: TextEditingController(
            text:
                '${value.month.toString().padLeft(2, '0')}/${value.day.toString().padLeft(2, '0')}/${value.year}',
          ),
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
            if (date != null) onChanged(date);
          },
        ),
      ],
    );
  }

  Widget _buildTextFormField(
    String label,
    String value,
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
          initialValue: value,
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
          const Expanded(
            child: Text(
              'High Risk: Current smoking habit detected',
              style: TextStyle(
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
    // Implementation for adding family history
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add Family History'),
            content: const Text(
              'Add family history dialog would be implemented here.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Add'),
              ),
            ],
          ),
    );
  }

  void _editFamilyCondition(FamilyMedicalCondition condition) {
    // Implementation for editing family condition
  }

  void _deleteFamilyCondition(FamilyMedicalCondition condition) {
    setState(() {
      familyConditions.remove(condition);
    });
  }

  void _updateMedicalHistory() {
    if (_formKey.currentState!.validate()) {
      // Implementation for updating medical history
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Medical history updated successfully'),
          backgroundColor: Colors.teal,
        ),
      );
    }
  }
}

class FamilyMedicalCondition {
  final String condition;
  final String relation;
  final bool isHighRisk;
  final IconData icon;
  final Color color;

  FamilyMedicalCondition({
    required this.condition,
    required this.relation,
    required this.isHighRisk,
    required this.icon,
    required this.color,
  });
}
