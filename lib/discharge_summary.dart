import 'package:flutter/material.dart';



class DischargeSummaryScreen extends StatefulWidget {
  const DischargeSummaryScreen({super.key});

  @override
  State<DischargeSummaryScreen> createState() => _DischargeSummaryScreenState();
}

class _DischargeSummaryScreenState extends State<DischargeSummaryScreen> {
  final TextEditingController _physicianNameController = TextEditingController(
    text: 'Dr. Michael Smith',
  );
  final TextEditingController _licenseNumberController = TextEditingController(
    text: 'MD-12345',
  );
  final TextEditingController _dateTimeController = TextEditingController(
    text: 'mm/dd/yyyy, --:-- --',
  );

  bool _isChiefComplaintExpanded = false;
  bool _isHospitalCourseExpanded = false;
  bool _isDiagnosesExpanded = false;
  bool _isMedicationsExpanded = false;
  bool _isFollowUpExpanded = false;

  @override
  void dispose() {
    _physicianNameController.dispose();
    _licenseNumberController.dispose();
    _dateTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Row(
        children: [
          // Main Content Area
          Expanded(
            flex: 4,
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPatientCard(),
                        const SizedBox(height: 24),
                        _buildChiefComplaintSection(),
                        const SizedBox(height: 16),
                        _buildHospitalCourseSection(),
                        const SizedBox(height: 16),
                        _buildDiagnosesSection(),
                        const SizedBox(height: 16),
                        _buildMedicationsSection(),
                        const SizedBox(height: 16),
                        _buildFollowUpSection(),
                        const SizedBox(height: 24),
                        _buildDigitalSignatureSection(),
                        const SizedBox(height: 32),
                        _buildBottomActions(),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Right Sidebar
          _buildRightSidebar(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back, size: 20),
              color: const Color(0xFF475569),
            ),
            const SizedBox(width: 8),
            const Text(
              'Discharge Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F172A),
              ),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.save_outlined, size: 16),
              label: const Text('Save Draft'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F46E5),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientCard() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Patient Avatar
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              color: const Color(0xFFE2E8F0),
            ),
            child: const Icon(Icons.person, size: 28, color: Color(0xFF64748B)),
          ),
          const SizedBox(width: 16),
          // Patient Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Sarah Johnson',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.more_vert, size: 20),
                      color: const Color(0xFF64748B),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Female, 45 years • MRN: #MRN-2024-001',
                  style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildStatusBadge('Discharged', const Color(0xFF10B981)),
                    const SizedBox(width: 8),
                    _buildStatusBadge('Surgical Case', const Color(0xFF4F46E5)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildInfoItem('Ward/Bed', 'ICU-A / 12'),
                    const SizedBox(width: 40),
                    _buildInfoItem('Attending', 'Dr. Smith'),
                    const SizedBox(width: 40),
                    _buildInfoItem('Admission', 'Dec 10, 2024'),
                    const SizedBox(width: 40),
                    _buildInfoItem('Discharge', 'Dec 18, 2024'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }

  Widget _buildChiefComplaintSection() {
    return _buildExpandableCard(
      title: 'Chief Complaint & Admission Reason',
      icon: Icons.assignment_outlined,
      isExpanded: _isChiefComplaintExpanded,
      onToggle:
          () => setState(
            () => _isChiefComplaintExpanded = !_isChiefComplaintExpanded,
          ),
      content: const Text(
        'Patient presented with acute chest pain and shortness of breath. Admitted for evaluation of possible myocardial infarction.',
        style: TextStyle(fontSize: 14, height: 1.5, color: Color(0xFF334155)),
      ),
    );
  }

  Widget _buildHospitalCourseSection() {
    return _buildExpandableCard(
      title: 'Hospital Course Summary',
      icon: Icons.local_hospital_outlined,
      isExpanded: _isHospitalCourseExpanded,
      onToggle:
          () => setState(
            () => _isHospitalCourseExpanded = !_isHospitalCourseExpanded,
          ),
      subtitle: Row(
        children: [
          const Icon(Icons.auto_awesome, size: 12, color: Color(0xFF06B6D4)),
          const SizedBox(width: 4),
          const Text(
            'Auto-generated from encounter notes. ',
            style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
          ),
          GestureDetector(
            onTap: () {},
            child: const Text(
              'Refresh',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF06B6D4),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      content: const Text(
        'Patient underwent cardiac catheterization on day 2 which revealed 90% stenosis of LAD. Successful PCI with drug-eluting stent placement performed. Post-procedure course was uncomplicated. Patient remained stable on telemetry monitoring.',
        style: TextStyle(fontSize: 14, height: 1.5, color: Color(0xFF334155)),
      ),
    );
  }

  Widget _buildDiagnosesSection() {
    return _buildExpandableCard(
      title: 'Discharge Diagnoses',
      icon: Icons.medical_services_outlined,
      isExpanded: _isDiagnosesExpanded,
      onToggle:
          () => setState(() => _isDiagnosesExpanded = !_isDiagnosesExpanded),
      content: Column(
        children: [
          _buildDiagnosisItem(
            type: 'Primary',
            diagnosis: 'Acute ST-elevation myocardial infarction',
            code: 'I21.9',
            isPrimary: true,
          ),
          const SizedBox(height: 12),
          _buildDiagnosisItem(
            type: 'Secondary',
            diagnosis: 'Hypertension, unspecified',
            code: 'I10',
            isPrimary: false,
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {},
            child: const Row(
              children: [
                Icon(Icons.add, size: 16, color: Color(0xFF4F46E5)),
                SizedBox(width: 4),
                Text(
                  'Add Diagnosis',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF4F46E5),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiagnosisItem({
    required String type,
    required String diagnosis,
    required String code,
    required bool isPrimary,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color:
                isPrimary ? const Color(0xFF4F46E5) : const Color(0xFF64748B),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            type,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            diagnosis,
            style: const TextStyle(fontSize: 14, color: Color(0xFF0F172A)),
          ),
        ),
        Text(
          code,
          style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.close, size: 16),
          color: const Color(0xFF64748B),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
        ),
      ],
    );
  }

  Widget _buildMedicationsSection() {
    return _buildExpandableCard(
      title: 'Discharge Medications',
      icon: Icons.medication_outlined,
      isExpanded: _isMedicationsExpanded,
      onToggle:
          () =>
              setState(() => _isMedicationsExpanded = !_isMedicationsExpanded),
      content: Column(
        children: [
          _buildMedicationItem(
            name: 'Aspirin 81mg',
            dosage: 'Once daily, oral',
            duration: 'Duration: Indefinite',
          ),
          const SizedBox(height: 16),
          _buildMedicationItem(
            name: 'Metoprolol 25mg',
            dosage: 'Twice daily, oral',
            duration: 'Duration: 30 days',
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {},
            child: const Row(
              children: [
                Icon(Icons.add, size: 16, color: Color(0xFF4F46E5)),
                SizedBox(width: 4),
                Text(
                  'Add Medication',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF4F46E5),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicationItem({
    required String name,
    required String dosage,
    required String duration,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                dosage,
                style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
              Text(
                duration,
                style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.edit_outlined, size: 16),
          color: const Color(0xFF64748B),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
        ),
      ],
    );
  }

  Widget _buildFollowUpSection() {
    return _buildExpandableCard(
      title: 'Follow-up Instructions',
      icon: Icons.schedule_outlined,
      isExpanded: _isFollowUpExpanded,
      onToggle:
          () => setState(() => _isFollowUpExpanded = !_isFollowUpExpanded),
      content: const Text(
        'Follow up with cardiology in 1 week. Return to ED if experiencing chest pain, shortness of breath, or palpitations. Cardiac rehabilitation referral provided.',
        style: TextStyle(fontSize: 14, height: 1.5, color: Color(0xFF334155)),
      ),
    );
  }

  Widget _buildExpandableCard({
    required String title,
    required IconData icon,
    required bool isExpanded,
    required VoidCallback onToggle,
    Widget? subtitle,
    required Widget content,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Icon(icon, size: 20, color: const Color(0xFF4F46E5)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 4),
                          subtitle,
                        ],
                      ],
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 20,
                    color: const Color(0xFF64748B),
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: content,
            ),
        ],
      ),
    );
  }

  Widget _buildDigitalSignatureSection() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.draw_outlined, size: 20, color: Color(0xFF4F46E5)),
              SizedBox(width: 8),
              Text(
                'Digital Signature',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Signature Area
              Expanded(
                flex: 2,
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(8),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.edit, size: 24, color: Color(0xFFCBD5E1)),
                          SizedBox(height: 8),
                          Text(
                            'Click to add signature',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 24),
              // Form Fields
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFormField(
                      label: 'Physician Name',
                      controller: _physicianNameController,
                    ),
                    const SizedBox(height: 16),
                    _buildFormField(
                      label: 'License Number',
                      controller: _licenseNumberController,
                    ),
                    const SizedBox(height: 16),
                    _buildFormField(
                      label: 'Date & Time',
                      controller: _dateTimeController,
                      suffixIcon: Icons.calendar_today_outlined,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    IconData? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF4F46E5)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            suffixIcon:
                suffixIcon != null
                    ? Icon(suffixIcon, size: 16, color: const Color(0xFF64748B))
                    : null,
          ),
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildBottomActions() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.save_outlined, size: 16),
            label: const Text('Save Draft'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF374151),
              side: const BorderSide(color: Color(0xFFE2E8F0)),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.check, size: 16),
            label: const Text('Finalize Summary'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4F46E5),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRightSidebar() {
    return Container(
      width: 280,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(left: BorderSide(color: Color(0xFFE2E8F0), width: 1)),
      ),
      child: Column(
        children: [
          _buildSummaryTools(),
          const Divider(color: Color(0xFFE2E8F0), height: 1),
          _buildVersionHistory(),
        ],
      ),
    );
  }

  Widget _buildSummaryTools() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Summary Tools',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 16),
          _buildToolButton(
            'Preview',
            Icons.visibility_outlined,
            const Color(0xFF4F46E5),
            isHighlighted: true,
          ),
          const SizedBox(height: 8),
          _buildToolButton(
            'Export PDF',
            Icons.picture_as_pdf_outlined,
            const Color(0xFF06B6D4),
          ),
          const SizedBox(height: 8),
          _buildToolButton(
            'Print',
            Icons.print_outlined,
            const Color(0xFF64748B),
          ),
          const SizedBox(height: 8),
          _buildToolButton(
            'Email Patient',
            Icons.email_outlined,
            const Color(0xFF64748B),
          ),
        ],
      ),
    );
  }

  Widget _buildToolButton(
    String label,
    IconData icon,
    Color color, {
    bool isHighlighted = false,
  }) {
    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
        onPressed: () {},
        icon: Icon(icon, size: 16, color: color),
        label: Text(label),
        style: TextButton.styleFrom(
          foregroundColor: color,
          backgroundColor: isHighlighted ? color.withOpacity(0.1) : null,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          alignment: Alignment.centerLeft,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _buildVersionHistory() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Version History',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 16),
          _buildVersionItem('Draft v1.2', '2 hrs ago'),
          const SizedBox(height: 12),
          _buildVersionItem('Draft v1.1', '1 day ago'),
        ],
      ),
    );
  }

  Widget _buildVersionItem(String version, String time) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: Color(0xFF64748B),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                version,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF0F172A),
                ),
              ),
              Text(
                time,
                style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
