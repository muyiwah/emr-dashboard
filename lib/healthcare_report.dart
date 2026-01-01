import 'package:flutter/material.dart';


class ReportsAnalyticsPage extends StatefulWidget {
  const ReportsAnalyticsPage({super.key});

  @override
  State<ReportsAnalyticsPage> createState() => _ReportsAnalyticsPageState();
}

class _ReportsAnalyticsPageState extends State<ReportsAnalyticsPage> {
  String selectedDepartment = 'All Departments';
  String selectedDiagnosis = 'All Diagnoses';
  String selectedInsurance = 'All Providers';
  String selectedViewType = 'Table';

  final TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dateController.text = 'mm/dd/yyyy';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 32),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSidebar(),
                  const SizedBox(width: 32),
                  Expanded(child: _buildMainContent()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Text(
              'Reports & Analytics',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Row(
                children: [
                  Icon(Icons.tune, size: 16, color: Color(0xFF6B7280)),
                  SizedBox(width: 4),
                  Text(
                    'Custom Reports & Compliance',
                    style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                  ),
                ],
              ),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add, size: 20),
          label: const Text('New Report'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6366F1),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
          ),
        ),
      ],
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 280,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Report Elements',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 24),
          _buildSidebarSection('Financial', [
            _SidebarItem(
              'Revenue',
              Icons.attach_money,
              const Color(0xFFD1FAE5),
              const Color(0xFF059669),
            ),
            _SidebarItem(
              'Expenditure',
              Icons.remove_circle,
              const Color(0xFFFEE2E2),
              const Color(0xFFDC2626),
            ),
          ]),
          const SizedBox(height: 24),
          _buildSidebarSection('Operational', [
            _SidebarItem(
              'Bed Usage',
              Icons.hotel,
              const Color(0xFFDBEAFE),
              const Color(0xFF2563EB),
            ),
            _SidebarItem(
              'Appointments',
              Icons.event,
              const Color(0xFFF3E8FF),
              const Color(0xFF9333EA),
            ),
          ]),
          const SizedBox(height: 24),
          _buildSidebarSection('Clinical', [
            _SidebarItem(
              'Outcomes',
              Icons.favorite,
              const Color(0xFFCCFBF1),
              const Color(0xFF0D9488),
            ),
            _SidebarItem(
              'Readmissions',
              Icons.person_add,
              const Color(0xFFFED7AA),
              const Color(0xFFEA580C),
            ),
          ]),
          const SizedBox(height: 24),
          _buildSidebarSection('Demographics', [
            _SidebarItem(
              'Patient Data',
              Icons.people,
              const Color(0xFFE0E7FF),
              const Color(0xFF6366F1),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSidebarSection(String title, List<_SidebarItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 12),
        ...items.map((item) => _buildSidebarItemWidget(item)),
      ],
    );
  }

  Widget _buildSidebarItemWidget(_SidebarItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: item.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(item.icon, size: 20, color: item.iconColor),
                const SizedBox(width: 12),
                Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: item.iconColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Column(
      children: [
        _buildTabs(),
        const SizedBox(height: 24),
        _buildFilters(),
        const SizedBox(height: 24),
        Expanded(child: _buildReportCanvas()),
        const SizedBox(height: 24),
        _buildExportOptions(),
      ],
    );
  }

  Widget _buildTabs() {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          _buildTab('Report Builder', true),
          _buildTab('Compliance', false),
          _buildTab('Scheduled Reports', false),
        ],
      ),
    );
  }

  Widget _buildTab(String title, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isActive ? const Color(0xFF6366F1) : Colors.transparent,
            width: 2,
          ),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: isActive ? const Color(0xFF6366F1) : const Color(0xFF6B7280),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Report Filters',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildDateFilter()),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDropdownFilter('Department', selectedDepartment, [
                  'All Departments',
                  'Cardiology',
                  'Emergency',
                  'Surgery',
                ]),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDropdownFilter('Diagnosis', selectedDiagnosis, [
                  'All Diagnoses',
                  'Acute',
                  'Chronic',
                  'Critical',
                ]),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDropdownFilter('Insurance', selectedInsurance, [
                  'All Providers',
                  'Medicare',
                  'Medicaid',
                  'Private',
                ]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Date Range',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: dateController,
          decoration: InputDecoration(
            hintText: 'mm/dd/yyyy',
            suffixIcon: const Icon(Icons.calendar_today, size: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF6366F1)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownFilter(
    String label,
    String value,
    List<String> options,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF6366F1)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
          items:
              options.map((String option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              switch (label) {
                case 'Department':
                  selectedDepartment = newValue!;
                  break;
                case 'Diagnosis':
                  selectedDiagnosis = newValue!;
                  break;
                case 'Insurance':
                  selectedInsurance = newValue!;
                  break;
              }
            });
          },
        ),
      ],
    );
  }

  Widget _buildReportCanvas() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Report Canvas',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                Row(
                  children: [
                    _buildViewToggle(
                      'Table',
                      Icons.table_chart,
                      selectedViewType == 'Table',
                    ),
                    const SizedBox(width: 8),
                    _buildViewToggle(
                      'Chart',
                      Icons.bar_chart,
                      selectedViewType == 'Chart',
                    ),
                    const SizedBox(width: 8),
                    _buildViewToggle(
                      'Cards',
                      Icons.view_module,
                      selectedViewType == 'Cards',
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFAFAFA),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                border: Border.all(
                  color: Colors.grey.shade200,
                  style: BorderStyle.solid,
                  width: 1,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 24,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Drag elements here to build your report',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF9CA3AF),
                        fontWeight: FontWeight.w500,
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

  Widget _buildViewToggle(String label, IconData icon, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF6366F1) : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isSelected ? const Color(0xFF6366F1) : Colors.grey.shade300,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isSelected ? Colors.white : const Color(0xFF6B7280),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExportOptions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Export Options',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildExportButton(
                'PDF',
                Icons.picture_as_pdf,
                const Color(0xFFDC2626),
              ),
              const SizedBox(width: 12),
              _buildExportButton(
                'Excel',
                Icons.table_chart,
                const Color(0xFF059669),
              ),
              const SizedBox(width: 12),
              _buildExportButton('JSON', Icons.code, const Color(0xFF2563EB)),
              const SizedBox(width: 12),
              _buildExportButton(
                'Save Template',
                Icons.bookmark,
                const Color(0xFF7C3AED),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExportButton(String label, IconData icon, Color color) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
      ),
    );
  }

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }
}

class _SidebarItem {
  final String title;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  _SidebarItem(this.title, this.icon, this.backgroundColor, this.iconColor);
}
