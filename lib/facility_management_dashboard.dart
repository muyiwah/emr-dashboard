import 'package:flutter/material.dart';


class FacilityManagementScreen extends StatefulWidget {
  const FacilityManagementScreen({super.key});

  @override
  State<FacilityManagementScreen> createState() =>
      _FacilityManagementScreenState();
}

class _FacilityManagementScreenState extends State<FacilityManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedType = 'All Types';
  String _selectedRegion = 'All Regions';
  String _selectedStatus = 'All Status';
  bool _isGridView = true;

  final List<String> _types = ['All Types', 'Hospital', 'Clinic', 'Laboratory'];
  final List<String> _regions = [
    'All Regions',
    'New York',
    'Manhattan',
    'Brooklyn',
    'Queens',
  ];
  final List<String> _statuses = [
    'All Status',
    'Active',
    'Inactive',
    'Maintenance',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 32),
            _buildStatsCards(),
            const SizedBox(height: 32),
            _buildFiltersAndSearch(),
            const SizedBox(height: 24),
            Expanded(child: _buildFacilitiesList()),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF3B82F6),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.medical_services,
          color: Colors.white,
          size: 20,
        ),
      ),
      title: const Text(
        'EMR Multi-Branch Management',
        style: TextStyle(
          color: Color(0xFF1F2937),
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          child: Stack(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: Color(0xFF6B7280),
                ),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 16),
          child: const CircleAvatar(
            radius: 20,
            // backgroundImage: NetworkImage('https://via.placeholder.com/40'),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Facility Management',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Manage all healthcare facilities across your network',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        Row(
          children: [
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.download, size: 18),
              label: const Text('Export'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF374151),
                side: const BorderSide(color: Color(0xFFD1D5DB)),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Facility'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsCards() {
    return Row(
      children: [
        Expanded(
          child: _buildStatsCard(
            'Total Facilities',
            '24',
            Icons.business,
            const Color(0xFF3B82F6),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatsCard(
            'Active Today',
            '22',
            Icons.check_circle,
            const Color(0xFF10B981),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatsCard(
            'Total Staff',
            '1,847',
            Icons.group,
            const Color(0xFF3B82F6),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatsCard(
            'Patients Today',
            '3,264',
            Icons.person,
            const Color(0xFFF59E0B),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersAndSearch() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFD1D5DB)),
            ),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search facilities...',
                prefixIcon: Icon(Icons.search, color: Color(0xFF9CA3AF)),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        _buildDropdown(_selectedType, _types, (value) {
          setState(() {
            _selectedType = value!;
          });
        }),
        const SizedBox(width: 12),
        _buildDropdown(_selectedRegion, _regions, (value) {
          setState(() {
            _selectedRegion = value!;
          });
        }),
        const SizedBox(width: 12),
        _buildDropdown(_selectedStatus, _statuses, (value) {
          setState(() {
            _selectedStatus = value!;
          });
        }),
        const SizedBox(width: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFD1D5DB)),
          ),
          child: Row(
            children: [
              _buildViewToggle(Icons.grid_view, true),
              _buildViewToggle(Icons.list, false),
              _buildViewToggle(Icons.view_column, false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(
    String value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFD1D5DB)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          items:
              items.map((String item) {
                return DropdownMenuItem<String>(value: item, child: Text(item));
              }).toList(),
          onChanged: onChanged,
          style: const TextStyle(color: Color(0xFF374151), fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildViewToggle(IconData icon, bool isSelected) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF3B82F6) : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(
        icon,
        color: isSelected ? Colors.white : const Color(0xFF6B7280),
        size: 18,
      ),
    );
  }

  Widget _buildFacilitiesList() {
    return Column(
      children: [
        Expanded(
          child: GridView.count(
            crossAxisCount: 4,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
            children: [
              _buildFacilityCard(
                'Central Hospital',
                'Hospital',
                'New York, NY',
                '+1 (555) 123-4567',
                const Color(0xFF10B981),
                Icons.local_hospital,
                '147',
                '250',
                '89',
                'Staff',
                'Beds',
                'Patients',
              ),
              _buildFacilityCard(
                'Downtown Clinic',
                'Clinic',
                'Manhattan, NY',
                '+1 (555) 234-5678',
                const Color(0xFF10B981),
                Icons.home,
                '23',
                '15',
                '42',
                'Staff',
                'Beds',
                'Patients',
              ),
              _buildFacilityCard(
                'Medical Lab Center',
                'Laboratory',
                'Brooklyn, NY',
                '+1 (555) 345-6789',
                const Color(0xFFF59E0B),
                Icons.science,
                '18',
                '5',
                '156',
                'Staff',
                'Beds',
                'Tests',
              ),
              _buildFacilityCard(
                'Emergency Center',
                'Hospital',
                'Queens, NY',
                '+1 (555) 456-7890',
                const Color(0xFFEF4444),
                Icons.emergency,
                '89',
                '120',
                '67',
                'Staff',
                'Beds',
                'Patients',
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF374151),
            side: const BorderSide(color: Color(0xFFD1D5DB)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text('Load More Facilities'),
        ),
      ],
    );
  }

  Widget _buildFacilityCard(
    String name,
    String type,
    String location,
    String phone,
    Color statusColor,
    IconData icon,
    String stat1,
    String stat2,
    String stat3,
    String label1,
    String label2,
    String label3,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: const Color(0xFF3B82F6), size: 20),
              ),
              const Spacer(),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 4),
          Text(type, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.location_on, size: 14, color: Color(0xFF6B7280)),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  location,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.phone, size: 14, color: Color(0xFF6B7280)),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  phone,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatColumn(stat1, label1),
              _buildStatColumn(stat2, label2),
              _buildStatColumn(stat3, label3),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              TextButton(
                onPressed: () {},
                child: const Text(
                  'View Details',
                  style: TextStyle(
                    color: Color(0xFF3B82F6),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.launch,
                  size: 16,
                  color: Color(0xFF6B7280),
                ),
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.power_settings_new,
                  size: 16,
                  color: Color(0xFF6B7280),
                ),
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
