import 'package:flutter/material.dart';



class Surgery {
  final String procedure;
  final String date;
  final String hospital;
  final String surgeon;

  Surgery({
    required this.procedure,
    required this.date,
    required this.hospital,
    required this.surgeon,
  });
}

class Allergy {
  final String name;
  final String reaction;
  final AllergySeverity severity;
  final AllergyType type;

  Allergy({
    required this.name,
    required this.reaction,
    required this.severity,
    required this.type,
  });
}

enum AllergySeverity { severe, moderate, mild }

enum AllergyType { medication, food, environmental }

class SurgeryRecord extends StatefulWidget {
  const SurgeryRecord({Key? key}) : super(key: key);

  @override
  State<SurgeryRecord> createState() => _SurgeryRecordState();
}

class _SurgeryRecordState extends State<SurgeryRecord> {
  bool hasNoSurgeries = false;
  bool hasNoAllergies = false;

  List<Surgery> surgeries = [
    Surgery(
      procedure: 'Appendectomy',
      date: '12/15/2019',
      hospital: 'St. Mary\'s Hospital',
      surgeon: 'Dr. Smith',
    ),
    Surgery(
      procedure: 'Gallbladder Removal',
      date: '06/22/2021',
      hospital: 'General Hospital',
      surgeon: 'Dr. Wilson',
    ),
  ];

  List<Allergy> allergies = [
    Allergy(
      name: 'Penicillin',
      reaction: 'Anaphylaxis',
      severity: AllergySeverity.severe,
      type: AllergyType.medication,
    ),
    Allergy(
      name: 'Shellfish',
      reaction: 'Hives, swelling',
      severity: AllergySeverity.moderate,
      type: AllergyType.food,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPatientHeader(),
              const SizedBox(height: 30),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildSurgicalHistorySection()),
                  const SizedBox(width: 20),
                  Expanded(child: _buildAllergiesSection()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPatientHeader() {
    return Container(
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
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(
              'https://images.unsplash.com/photo-1494790108755-2616b612b4c0?w=150&h=150&fit=crop&crop=face',
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sarah Johnson',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'DOB: 03/15/1985 • MRN: 123456789',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSurgicalHistorySection() {
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
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Past Surgical History',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Record of previous surgeries and procedures',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Checkbox(
                      value: hasNoSurgeries,
                      onChanged: (value) {
                        setState(() {
                          hasNoSurgeries = value ?? false;
                        });
                      },
                      activeColor: const Color(0xFF5B57F7),
                    ),
                    const Text(
                      'No previous surgeries',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (!hasNoSurgeries) ...[
            _buildSurgeryTable(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _addSurgery,
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text(
                    'Add Surgery',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5B57F7),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSurgeryTable() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: const BoxDecoration(
            color: Color(0xFFF8F9FA),
            border: Border(
              top: BorderSide(color: Color(0xFFE5E7EB)),
              bottom: BorderSide(color: Color(0xFFE5E7EB)),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  'PROCEDURE',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'DATE',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'HOSPITAL/SURGEON',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(width: 60),
            ],
          ),
        ),
        ...surgeries.map((surgery) => _buildSurgeryRow(surgery)).toList(),
      ],
    );
  }

  Widget _buildSurgeryRow(Surgery surgery) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              surgery.procedure,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ),
          Expanded(
            child: Text(
              surgery.date,
              style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A1A)),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  surgery.hospital,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                Text(
                  surgery.surgeon,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.open_in_new,
              size: 18,
              color: Color(0xFF5B57F7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllergiesSection() {
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
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Allergies',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Track medication, food, and environmental allergies',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Checkbox(
                      value: hasNoAllergies,
                      onChanged: (value) {
                        setState(() {
                          hasNoAllergies = value ?? false;
                        });
                      },
                      activeColor: const Color(0xFF5B57F7),
                    ),
                    const Text(
                      'No Known Allergies',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                if (!hasNoAllergies) ...[
                  const SizedBox(height: 16),
                  _buildAllergyTypeFilters(),
                ],
              ],
            ),
          ),
          if (!hasNoAllergies) ...[
            ...allergies.map((allergy) => _buildAllergyCard(allergy)).toList(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _addAllergy,
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text(
                    'Add Allergy',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5B57F7),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAllergyTypeFilters() {
    return Row(
      children: [
        _buildFilterChip('💊 Medication', true),
        const SizedBox(width: 8),
        _buildFilterChip('🍊 Food', false),
        const SizedBox(width: 8),
        _buildFilterChip('🌲 Environmental', false),
      ],
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF5B57F7) : Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: isSelected ? Colors.white : Colors.grey[700],
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildAllergyCard(Allergy allergy) {
    Color backgroundColor;
    Color borderColor;

    switch (allergy.severity) {
      case AllergySeverity.severe:
        backgroundColor = const Color(0xFFFEF2F2);
        borderColor = const Color(0xFFFECACA);
        break;
      case AllergySeverity.moderate:
        backgroundColor = const Color(0xFFFEF3C7);
        borderColor = const Color(0xFFFCD34D);
        break;
      case AllergySeverity.mild:
        backgroundColor = const Color(0xFFECFDF5);
        borderColor = const Color(0xFFA7F3D0);
        break;
    }

    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning,
            color:
                allergy.severity == AllergySeverity.severe
                    ? Colors.red[600]
                    : allergy.severity == AllergySeverity.moderate
                    ? Colors.orange[600]
                    : Colors.green[600],
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  allergy.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Reaction: ${allergy.reaction}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color:
                        allergy.severity == AllergySeverity.severe
                            ? Colors.red[600]
                            : allergy.severity == AllergySeverity.moderate
                            ? Colors.orange[600]
                            : Colors.green[600],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    allergy.severity.name.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.open_in_new,
              size: 18,
              color: Color(0xFF5B57F7),
            ),
          ),
        ],
      ),
    );
  }

  void _addSurgery() {
    // In a real app, this would open a form dialog
    setState(() {
      surgeries.add(
        Surgery(
          procedure: 'New Procedure',
          date:
              '${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}',
          hospital: 'Hospital Name',
          surgeon: 'Dr. Name',
        ),
      );
    });
  }

  void _addAllergy() {
    // In a real app, this would open a form dialog
    setState(() {
      allergies.add(
        Allergy(
          name: 'New Allergy',
          reaction: 'Reaction description',
          severity: AllergySeverity.mild,
          type: AllergyType.medication,
        ),
      );
    });
  }
}
