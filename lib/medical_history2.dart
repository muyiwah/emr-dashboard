import 'package:flutter/material.dart';


class MedicalCondition {
  final String name;
  final String icdCode;
  final String diagnosed;
  final String notes;
  final String status;
  final IconData icon;
  final Color iconColor;

  MedicalCondition({
    required this.name,
    required this.icdCode,
    required this.diagnosed,
    required this.notes,
    required this.status,
    required this.icon,
    required this.iconColor,
  });
}

class CommonCondition {
  final String name;
  final IconData icon;
  final Color iconColor;

  CommonCondition({
    required this.name,
    required this.icon,
    required this.iconColor,
  });
}

class PastMedicalHistoryScreen2 extends StatefulWidget {
  const PastMedicalHistoryScreen2({super.key});

  @override
  State<PastMedicalHistoryScreen2> createState() => _PastMedicalHistoryScreen2State();
}

class _PastMedicalHistoryScreen2State extends State<PastMedicalHistoryScreen2> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _customConditionController = TextEditingController();
  bool _noKnownMedicalHistory = false;

  final List<MedicalCondition> _currentConditions = [
    MedicalCondition(
      name: 'Essential Hypertension',
      icdCode: 'I10',
      diagnosed: 'March 2020',
      notes: 'Well controlled with medication.\nRegular monitoring required.',
      status: 'Chronic',
      icon: Icons.favorite,
      iconColor: Colors.red,
    ),
    MedicalCondition(
      name: 'Bronchial Asthma',
      icdCode: 'J45.9',
      diagnosed: 'January 2018',
      notes: 'Childhood asthma, no\nsymptoms in past 2 years.',
      status: 'In Remission',
      icon: Icons.air,
      iconColor: Colors.red,
    ),
    MedicalCondition(
      name: 'Fracture of Left Radius',
      icdCode: 'S52.502A',
      diagnosed: 'June 2019',
      notes: 'Sports injury, healed completely.\nFull range of motion restored.',
      status: 'Resolved',
      icon: Icons.healing,
      iconColor: Colors.grey,
    ),
  ];

  final List<CommonCondition> _commonConditions = [
    CommonCondition(name: 'Hypertension', icon: Icons.favorite, iconColor: Colors.red),
    CommonCondition(name: 'Asthma', icon: Icons.air, iconColor: Colors.red),
    CommonCondition(name: 'Diabetes Type 2', icon: Icons.water_drop, iconColor: Colors.red),
    CommonCondition(name: 'Depression', icon: Icons.psychology, iconColor: Colors.pink),
  ];

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'chronic':
        return Colors.orange;
      case 'in remission':
        return Colors.green;
      case 'resolved':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  void _removeCondition(int index) {
    setState(() {
      _currentConditions.removeAt(index);
    });
  }

  void _addCustomCondition() {
    if (_customConditionController.text.isNotEmpty) {
      setState(() {
        _currentConditions.add(
          MedicalCondition(
            name: _customConditionController.text,
            icdCode: 'TBD',
            diagnosed: 'Today',
            notes: 'Custom condition added',
            status: 'Active',
            icon: Icons.medical_services,
            iconColor: Colors.blue,
          ),
        );
        _customConditionController.clear();
      });
    }
  }

  void _addCommonCondition(CommonCondition condition) {
    setState(() {
      _currentConditions.add(
        MedicalCondition(
          name: condition.name,
          icdCode: 'TBD',
          diagnosed: 'Today',
          notes: 'Added from common conditions',
          status: 'Active',
          icon: condition.icon,
          iconColor: condition.iconColor,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Past Medical History',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Patient: John Smith • DOB: 1985-03-15',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Cancel'),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Save Changes'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Row(
        children: [
          // Left Panel - Add Conditions
          Container(
            width: 400,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add Medical Condition',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  
                  // Search Conditions
                  const Text(
                    'Search Conditions',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Type to search conditions...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Common Conditions
                  const Text(
                    'Common Conditions',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 12),
                  ..._commonConditions.map((condition) => 
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => _addCommonCondition(condition),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(condition.icon, color: condition.iconColor, size: 20),
                                const SizedBox(width: 12),
                                Text(condition.name),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Add Custom Condition
                  const Text(
                    'Add Custom Condition',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _customConditionController,
                    decoration: InputDecoration(
                      hintText: 'Enter condition name...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'ICD-10 suggestions will appear as you type',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _addCustomCondition,
                      icon: const Icon(Icons.add),
                      label: const Text('Add Condition'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blue,
                        side: const BorderSide(color: Colors.blue),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const Spacer(),
                  
                  // No Known Medical History
                  CheckboxListTile(
                    value: _noKnownMedicalHistory,
                    onChanged: (value) {
                      setState(() {
                        _noKnownMedicalHistory = value ?? false;
                      });
                    },
                    title: const Text('No known medical history'),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
          ),
          
          // Right Panel - Current Medical History
          Expanded(
            child: Container(
              color: Colors.grey[50],
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Current Medical History',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${_currentConditions.length} conditions',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    Expanded(
                      child: ListView.builder(
                        itemCount: _currentConditions.length,
                        itemBuilder: (context, index) {
                          final condition = _currentConditions[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(20),
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
                                Row(
                                  children: [
                                    Icon(condition.icon, color: condition.iconColor, size: 24),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                condition.name,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 8, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: _getStatusColor(condition.status),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  condition.status,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'ICD-10: ${condition.icdCode}',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline),
                                      onPressed: () => _removeCondition(index),
                                      color: Colors.grey[600],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Diagnosed: ${condition.diagnosed}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'Notes',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.grey[200]!),
                                  ),
                                  child: Text(
                                    condition.notes,
                                    style: const TextStyle(fontSize: 14, height: 1.5),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _customConditionController.dispose();
    super.dispose();
  }
}