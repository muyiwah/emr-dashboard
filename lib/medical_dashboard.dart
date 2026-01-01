import 'package:flutter/material.dart';



class MedicalDashboard extends StatelessWidget {
  const MedicalDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildMainContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
          const CircleAvatar(
            radius: 30,
            // backgroundImage: NetworkImage('https://via.placeholder.com/60'),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sarah Johnson',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Age: 34 • Female • ID: #PT-4567',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 2),
                Text(
                  'Last Visit: Dec 15, 2024',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.teal[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Primary Provider: Dr. Michael Chen',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add, size: 18),
            label: const Text('New Visit'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.dark_mode_outlined),
            style: IconButton.styleFrom(
              backgroundColor: Colors.grey[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            children: [
              _buildVitalSigns(),
              const SizedBox(height: 24),
              _buildMedications(),
              const SizedBox(height: 24),
              _buildDiagnoses(),
            ],
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          flex: 1,
          child: Column(
            children: [
              _buildAllergies(),
              const SizedBox(height: 24),
              _buildRecentVisits(),
              const SizedBox(height: 24),
              _buildLabResults(),
              const SizedBox(height: 24),
              _buildImmunization(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVitalSigns() {
    return _buildCard(
      title: 'Vital Signs',
      icon: Icons.favorite,
      iconColor: Colors.teal,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildVitalItem('120/80', 'Blood Pressure', Colors.teal),
              ),
              Expanded(
                child: _buildVitalItem('72', 'Heart Rate', Colors.purple),
              ),
              Expanded(
                child: _buildVitalItem('98.6°F', 'Temperature', Colors.teal),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildVitalItem('98%', 'SpO₂', Colors.red)),
              Expanded(child: _buildVitalItem('24.1', 'BMI', Colors.purple)),
              const Expanded(child: SizedBox()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVitalItem(String value, String label, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 4,
          width: 80,
          decoration: BoxDecoration(
            color: color.withOpacity(0.3),
            borderRadius: BorderRadius.circular(2),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: 0.7,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMedications() {
    return _buildCard(
      title: 'Current Medications',
      icon: Icons.medication,
      iconColor: Colors.blue,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildStatusChip('Active', Colors.teal, true),
          const SizedBox(width: 8),
          _buildStatusChip('Inactive', Colors.grey, false),
        ],
      ),
      child: Column(
        children: [
          _buildMedicationItem(
            'Metformin',
            '500mg • Twice daily',
            'Dr. Chen',
            true,
          ),
          const SizedBox(height: 16),
          _buildMedicationItem(
            'Lisinopril',
            '10mg • Once daily',
            'Dr. Chen',
            true,
          ),
        ],
      ),
    );
  }

  Widget _buildMedicationItem(
    String name,
    String dosage,
    String prescriber,
    bool active,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3748),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                dosage,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 2),
              Text(
                'Prescribed by $prescriber',
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
            ],
          ),
        ),
        _buildStatusChip('Active', Colors.teal, true),
      ],
    );
  }

  Widget _buildDiagnoses() {
    return _buildCard(
      title: 'Active Diagnoses',
      icon: Icons.medical_information,
      iconColor: Colors.blue,
      child: Column(
        children: [
          _buildDiagnosisItem(
            'Type 2 Diabetes',
            'ICD-10: E11.9',
            Colors.red,
            true,
          ),
          const SizedBox(height: 16),
          _buildDiagnosisItem('Hypertension', 'ICD-10: I10', Colors.blue, true),
        ],
      ),
    );
  }

  Widget _buildDiagnosisItem(
    String diagnosis,
    String code,
    Color color,
    bool active,
  ) {
    return Row(
      children: [
        Icon(
          diagnosis.contains('Diabetes') ? Icons.favorite : Icons.show_chart,
          color: color,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                diagnosis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3748),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                code,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        _buildStatusChip('Active', Colors.red, true),
      ],
    );
  }

  Widget _buildAllergies() {
    return _buildCard(
      title: 'Allergies & Alerts',
      icon: Icons.warning,
      iconColor: Colors.red,
      child: Column(
        children: [
          _buildAllergyItem('Penicillin', 'Critical', Colors.red),
          const SizedBox(height: 12),
          _buildAllergyItem('Peanuts', 'Moderate', Colors.orange),
        ],
      ),
    );
  }

  Widget _buildAllergyItem(String allergen, String severity, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            allergen.contains('Penicillin')
                ? Icons.medication
                : Icons.restaurant,
            color: color,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              allergen,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              severity,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentVisits() {
    return _buildCard(
      title: 'Recent Visits',
      icon: Icons.history,
      iconColor: Colors.teal,
      child: Column(
        children: [
          _buildVisitItem(
            'Annual Physical',
            'Dec 15, 2024',
            'Routine checkup, vitals stable, discussed medication adherence...',
          ),
          const SizedBox(height: 16),
          _buildVisitItem(
            'Follow-up Visit',
            'Nov 20, 2024',
            'Blood sugar levels reviewed, medication adjusted...',
          ),
        ],
      ),
    );
  }

  Widget _buildVisitItem(String type, String date, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              type,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3748),
              ),
            ),
            Text(date, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.4),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {},
          child: Text(
            'Tap to expand',
            style: TextStyle(
              fontSize: 12,
              color: Colors.teal[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabResults() {
    return _buildCard(
      title: 'Recent Lab Results',
      icon: Icons.science,
      iconColor: Colors.purple,
      child: Column(
        children: [
          _buildLabItem('HbA1c', 'Dec 15, 2024', '6.8%', 'Normal', Colors.teal),
          const SizedBox(height: 16),
          _buildLabItem(
            'Total Cholesterol',
            'Dec 15, 2024',
            '220 mg/dL',
            'High',
            Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildLabItem(
    String test,
    String date,
    String value,
    String status,
    Color statusColor,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                test,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3748),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                date,
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: statusColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              status,
              style: TextStyle(
                fontSize: 12,
                color: statusColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImmunization() {
    return _buildCard(
      title: 'Immunization Status',
      icon: Icons.vaccines,
      iconColor: Colors.green,
      child: Column(
        children: [
          _buildImmunizationItem('COVID-19', 'Up to date', Colors.teal),
          const SizedBox(height: 12),
          _buildImmunizationItem('Flu Shot', 'Current', Colors.teal),
        ],
      ),
    );
  }

  Widget _buildImmunizationItem(String vaccine, String status, Color color) {
    return Row(
      children: [
        Expanded(
          child: Text(
            vaccine,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
        ),
        Container(
          width: 100,
          height: 4,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          status,
          style: TextStyle(
            fontSize: 14,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Widget child,
    Widget? trailing,
  }) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
              if (trailing != null) ...[const Spacer(), trailing],
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label, Color color, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? color : Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: isSelected ? Colors.white : Colors.grey[600],
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
