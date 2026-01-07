import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:schmgtsystem/providers/staff_provider.dart';
import 'package:schmgtsystem/create_staff_screen.dart';

class StaffListScreen extends StatefulWidget {
  const StaffListScreen({super.key});

  @override
  State<StaffListScreen> createState() => _StaffListScreenState();
}

class _StaffListScreenState extends State<StaffListScreen> {
  List<dynamic> _staff = [];
  List<dynamic> _filteredStaff = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _loadStaff();
    _searchController.addListener(_filterStaff);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadStaff() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final staffProvider = Provider.of<StaffProvider>(context, listen: false);
      final response = await staffProvider.fetchStaff();
      if (response.success && response.data != null) {
        List<dynamic> staff = [];
        if (response.data is Map) {
          final data = response.data as Map<String, dynamic>;
          if (data['data'] != null && data['data'] is Map) {
            final innerData = data['data'] as Map<String, dynamic>;
            if (innerData['staff'] != null && innerData['staff'] is List) {
              staff = innerData['staff'];
            } else if (innerData['data'] != null && innerData['data'] is List) {
              staff = innerData['data'];
            }
          } else if (data['staff'] != null && data['staff'] is List) {
            staff = data['staff'];
          } else if (data['data'] != null && data['data'] is List) {
            staff = data['data'];
          }
        } else if (response.data is List) {
          staff = response.data;
        }

        setState(() {
          _staff = staff;
          _filteredStaff = staff;
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.error ?? 'Failed to load staff'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading staff: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _filterStaff() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredStaff = _staff;
      } else {
        _filteredStaff =
            _staff.where((staff) {
              final firstName =
                  (staff['firstName'] ?? '').toString().toLowerCase();
              final lastName =
                  (staff['lastName'] ?? '').toString().toLowerCase();
              final email = (staff['email'] ?? '').toString().toLowerCase();
              final department =
                  (staff['department'] ?? '').toString().toLowerCase();
              final employeeId =
                  (staff['employeeId'] ?? '').toString().toLowerCase();
              return firstName.contains(query) ||
                  lastName.contains(query) ||
                  email.contains(query) ||
                  department.contains(query) ||
                  employeeId.contains(query);
            }).toList();
      }

      // Apply status filter
      if (_selectedFilter != 'All') {
        final isActive = _selectedFilter == 'Active';
        _filteredStaff =
            _filteredStaff
                .where((staff) => (staff['isActive'] ?? true) == isActive)
                .toList();
      }
    });
  }

  void _onFilterChanged(String? value) {
    setState(() {
      _selectedFilter = value ?? 'All';
      _filterStaff();
    });
  }

  Future<void> _deleteStaff(dynamic staff) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Staff Member'),
            content: Text(
              'Are you sure you want to delete "${staff['firstName']} ${staff['lastName']}"? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      final staffProvider = Provider.of<StaffProvider>(context, listen: false);
      final staffId = (staff['_id'] ?? staff['id']).toString();
      final response = await staffProvider.deleteStaff(staffId);

      if (mounted) {
        if (response.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Staff member deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
          _loadStaff();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.error ?? 'Failed to delete staff member'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _editStaff(dynamic staff) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateStaffScreen(staff: staff)),
    );

    if (result == true) {
      _loadStaff();
    }
  }

  void _createNewStaff() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateStaffScreen()),
    );

    if (result == true) {
      _loadStaff();
    }
  }

  void _viewStaffDetails(dynamic staff) {
    showDialog(
      context: context,
      builder: (context) => StaffDetailsDialog(staff: staff),
    );
  }

  String _getFullName(dynamic staff) {
    final firstName = staff['firstName'] ?? '';
    final lastName = staff['lastName'] ?? '';
    return '$firstName $lastName'.trim();
  }

  String _getRoleName(dynamic staff) {
    final role = staff['role'];
    if (role is Map) {
      return role['name'] ?? 'N/A';
    }
    return 'N/A';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          // Header
          Container(
            height: 80,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                const Text(
                  'Manage Staff',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: _createNewStaff,
                  icon: const Icon(Icons.person_add),
                  label: const Text('Create Staff'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4285F4),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Search and Filters
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText:
                          'Search by name, email, department, or employee ID',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF4285F4)),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF8F9FA),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedFilter,
                      items: const [
                        DropdownMenuItem(value: 'All', child: Text('All')),
                        DropdownMenuItem(
                          value: 'Active',
                          child: Text('Active'),
                        ),
                        DropdownMenuItem(
                          value: 'Inactive',
                          child: Text('Inactive'),
                        ),
                      ],
                      onChanged: _onFilterChanged,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _loadStaff,
                  tooltip: 'Refresh',
                ),
              ],
            ),
          ),

          // Staff List
          Expanded(
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _filteredStaff.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _staff.isEmpty
                                ? 'No staff members found. Create your first staff member!'
                                : 'No staff members match your search',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    )
                    : Container(
                      margin: const EdgeInsets.all(24),
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
                        children: [
                          // Table Header
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8F9FA),
                              border: Border(
                                bottom: BorderSide(color: Colors.grey[200]!),
                              ),
                            ),
                            child: const Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'STAFF MEMBER',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF666666),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'ROLE',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF666666),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'DEPARTMENT',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF666666),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'EMAIL',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF666666),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'STATUS',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF666666),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'ACTIONS',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF666666),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Staff List
                          Expanded(
                            child: ListView.builder(
                              itemCount: _filteredStaff.length,
                              itemBuilder: (context, index) {
                                final staff = _filteredStaff[index];
                                final fullName = _getFullName(staff);
                                final roleName = _getRoleName(staff);
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey[200]!,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 20,
                                              backgroundColor: _getAvatarColor(
                                                index,
                                              ),
                                              child: Text(
                                                fullName.isNotEmpty
                                                    ? fullName[0].toUpperCase()
                                                    : '?',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    fullName,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Color(0xFF1A1A1A),
                                                    ),
                                                  ),
                                                  if (staff['phone'] != null)
                                                    const SizedBox(height: 4),
                                                  if (staff['phone'] != null)
                                                    Text(
                                                      staff['phone'],
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          roleName,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFF666666),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          staff['department'] ?? 'N/A',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFF666666),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          staff['email'] ?? 'N/A',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFF666666),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                (staff['isActive'] ?? true)
                                                    ? Colors.green[50]
                                                    : Colors.red[50],
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Text(
                                            (staff['isActive'] ?? true)
                                                ? 'Active'
                                                : 'Inactive',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  (staff['isActive'] ?? true)
                                                      ? Colors.green[700]
                                                      : Colors.red[700],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                Icons.visibility,
                                                size: 18,
                                              ),
                                              color: Colors.blue,
                                              onPressed:
                                                  () =>
                                                      _viewStaffDetails(staff),
                                              tooltip: 'View Details',
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.edit,
                                                size: 18,
                                              ),
                                              color: const Color(0xFF4285F4),
                                              onPressed:
                                                  () => _editStaff(staff),
                                              tooltip: 'Edit',
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.delete,
                                                size: 18,
                                              ),
                                              color: Colors.red,
                                              onPressed:
                                                  () => _deleteStaff(staff),
                                              tooltip: 'Delete',
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),

                          // Footer with count
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(color: Colors.grey[200]!),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total: ${_filteredStaff.length} staff member(s)',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
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

  Color _getAvatarColor(int index) {
    final colors = [
      const Color(0xFF4285F4),
      const Color(0xFF0F9D58),
      const Color(0xFFEA4335),
      const Color(0xFFFBBC05),
      const Color(0xFF9C27B0),
    ];
    return colors[index % colors.length];
  }
}

// Staff Details Dialog
class StaffDetailsDialog extends StatelessWidget {
  final dynamic staff;

  const StaffDetailsDialog({super.key, required this.staff});

  String _getFullName() {
    final firstName = staff['firstName'] ?? '';
    final lastName = staff['lastName'] ?? '';
    return '$firstName $lastName'.trim();
  }

  String _getRoleName() {
    final role = staff['role'];
    if (role is Map) {
      return role['name'] ?? 'N/A';
    }
    return 'N/A';
  }

  @override
  Widget build(BuildContext context) {
    final isActive = staff['isActive'] ?? true;
    final address = staff['address'] as Map<String, dynamic>?;
    final emergencyContact = staff['emergencyContact'] as Map<String, dynamic>?;
    final qualifications = staff['qualifications'] as List<dynamic>? ?? [];

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 700, maxHeight: 800),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with gradient
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF4285F4),
                    const Color(0xFF4285F4).withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getFullName(),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          staff['email'] ?? 'N/A',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.2),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isActive ? Colors.green[50] : Colors.red[50],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color:
                              isActive ? Colors.green[300]! : Colors.red[300]!,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isActive ? Icons.check_circle : Icons.cancel,
                            size: 16,
                            color:
                                isActive ? Colors.green[700] : Colors.red[700],
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isActive ? 'Active' : 'Inactive',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color:
                                  isActive
                                      ? Colors.green[700]
                                      : Colors.red[700],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Personal Information
                    _buildInfoCard(
                      'Personal Information',
                      Icons.person_outline,
                      [
                        _buildModernDetailRow(
                          Icons.badge,
                          'Role',
                          _getRoleName(),
                        ),
                        const SizedBox(height: 16),
                        _buildModernDetailRow(
                          Icons.business,
                          'Department',
                          staff['department'] ?? 'N/A',
                        ),
                        if (staff['phone'] != null) ...[
                          const SizedBox(height: 16),
                          _buildModernDetailRow(
                            Icons.phone,
                            'Phone',
                            staff['phone'],
                          ),
                        ],
                        if (staff['dateOfBirth'] != null) ...[
                          const SizedBox(height: 16),
                          _buildModernDetailRow(
                            Icons.cake,
                            'Date of Birth',
                            _formatDate(staff['dateOfBirth']),
                          ),
                        ],
                        if (staff['gender'] != null) ...[
                          const SizedBox(height: 16),
                          _buildModernDetailRow(
                            Icons.wc,
                            'Gender',
                            (staff['gender'] as String).toUpperCase(),
                          ),
                        ],
                      ],
                    ),

                    if (address != null) ...[
                      const SizedBox(height: 20),
                      _buildInfoCard('Address', Icons.location_on, [
                        if (address['street'] != null)
                          _buildModernDetailRow(
                            Icons.home,
                            'Street',
                            address['street'],
                          ),
                        if (address['city'] != null) ...[
                          const SizedBox(height: 16),
                          _buildModernDetailRow(
                            Icons.location_city,
                            'City',
                            address['city'],
                          ),
                        ],
                        if (address['state'] != null) ...[
                          const SizedBox(height: 16),
                          _buildModernDetailRow(
                            Icons.map,
                            'State',
                            address['state'],
                          ),
                        ],
                        if (address['zipCode'] != null) ...[
                          const SizedBox(height: 16),
                          _buildModernDetailRow(
                            Icons.pin,
                            'Zip Code',
                            address['zipCode'],
                          ),
                        ],
                      ]),
                    ],

                    if (staff['specialty'] != null ||
                        staff['licenseNumber'] != null) ...[
                      const SizedBox(height: 20),
                      _buildInfoCard('Professional Information', Icons.work, [
                        if (staff['specialty'] != null)
                          _buildModernDetailRow(
                            Icons.medical_services,
                            'Specialty',
                            staff['specialty'],
                          ),
                        if (staff['licenseNumber'] != null) ...[
                          const SizedBox(height: 16),
                          _buildModernDetailRow(
                            Icons.badge,
                            'License Number',
                            staff['licenseNumber'],
                          ),
                        ],
                        if (staff['licenseExpiry'] != null) ...[
                          const SizedBox(height: 16),
                          _buildModernDetailRow(
                            Icons.calendar_today,
                            'License Expiry',
                            _formatDate(staff['licenseExpiry']),
                          ),
                        ],
                      ]),
                    ],

                    if (staff['hireDate'] != null ||
                        staff['employmentType'] != null ||
                        staff['shift'] != null) ...[
                      const SizedBox(height: 20),
                      _buildInfoCard(
                        'Employment Information',
                        Icons.business_center,
                        [
                          if (staff['hireDate'] != null)
                            _buildModernDetailRow(
                              Icons.calendar_today,
                              'Hire Date',
                              _formatDate(staff['hireDate']),
                            ),
                          if (staff['employmentType'] != null) ...[
                            const SizedBox(height: 16),
                            _buildModernDetailRow(
                              Icons.work_outline,
                              'Employment Type',
                              (staff['employmentType'] as String)
                                  .toUpperCase()
                                  .replaceAll('-', ' '),
                            ),
                          ],
                          if (staff['shift'] != null) ...[
                            const SizedBox(height: 16),
                            _buildModernDetailRow(
                              Icons.access_time,
                              'Shift',
                              (staff['shift'] as String).toUpperCase(),
                            ),
                          ],
                          if (staff['salary'] != null) ...[
                            const SizedBox(height: 16),
                            _buildModernDetailRow(
                              Icons.attach_money,
                              'Salary',
                              '\$${staff['salary']}',
                            ),
                          ],
                        ],
                      ),
                    ],

                    if (qualifications.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4285F4).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.school,
                              color: Color(0xFF4285F4),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Qualifications',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ...qualifications.map((qual) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF4285F4).withOpacity(0.05),
                                const Color(0xFF4285F4).withOpacity(0.02),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF4285F4).withOpacity(0.2),
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                qual['degree'] ?? 'N/A',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Color(0xFF1A1A1A),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${qual['institution'] ?? 'N/A'}${qual['year'] != null ? ' (${qual['year']})' : ''}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],

                    if (emergencyContact != null) ...[
                      const SizedBox(height: 20),
                      _buildInfoCard('Emergency Contact', Icons.emergency, [
                        _buildModernDetailRow(
                          Icons.person,
                          'Name',
                          emergencyContact['name'] ?? 'N/A',
                        ),
                        if (emergencyContact['relationship'] != null) ...[
                          const SizedBox(height: 16),
                          _buildModernDetailRow(
                            Icons.family_restroom,
                            'Relationship',
                            emergencyContact['relationship'],
                          ),
                        ],
                        if (emergencyContact['phone'] != null) ...[
                          const SizedBox(height: 16),
                          _buildModernDetailRow(
                            Icons.phone,
                            'Phone',
                            emergencyContact['phone'],
                          ),
                        ],
                        if (emergencyContact['email'] != null) ...[
                          const SizedBox(height: 16),
                          _buildModernDetailRow(
                            Icons.email,
                            'Email',
                            emergencyContact['email'],
                          ),
                        ],
                      ]),
                    ],

                    if (staff['notes'] != null) ...[
                      const SizedBox(height: 20),
                      _buildInfoCard('Notes', Icons.note, [
                        Text(
                          staff['notes'],
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                      ]),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, IconData icon, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF4285F4), size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildModernDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF4285F4).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: const Color(0xFF4285F4)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(dynamic date) {
    if (date == null) return 'N/A';
    try {
      if (date is String) {
        final parsed = DateTime.parse(date);
        return DateFormat('yyyy-MM-dd').format(parsed);
      } else if (date is DateTime) {
        return DateFormat('yyyy-MM-dd').format(date);
      }
      return date.toString();
    } catch (e) {
      return date.toString();
    }
  }
}
