import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:schmgtsystem/providers/department_provider.dart';
import 'package:schmgtsystem/create_department_screen.dart';

class DepartmentsListScreen extends StatefulWidget {
  const DepartmentsListScreen({super.key});

  @override
  State<DepartmentsListScreen> createState() => _DepartmentsListScreenState();
}

class _DepartmentsListScreenState extends State<DepartmentsListScreen> {
  List<dynamic> _departments = [];
  List<dynamic> _filteredDepartments = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _loadDepartments();
    _searchController.addListener(_filterDepartments);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadDepartments() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final departmentProvider = Provider.of<DepartmentProvider>(
        context,
        listen: false,
      );
      final response = await departmentProvider.fetchDepartments();
      if (response.success && response.data != null) {
        List<dynamic> departments = [];
        if (response.data is Map) {
          final data = response.data as Map<String, dynamic>;
          if (data['data'] != null && data['data'] is Map) {
            final innerData = data['data'] as Map<String, dynamic>;
            if (innerData['departments'] != null &&
                innerData['departments'] is List) {
              departments = innerData['departments'];
            } else if (innerData['data'] != null && innerData['data'] is List) {
              departments = innerData['data'];
            }
          } else if (data['departments'] != null &&
              data['departments'] is List) {
            departments = data['departments'];
          } else if (data['data'] != null && data['data'] is List) {
            departments = data['data'];
          }
        } else if (response.data is List) {
          departments = response.data;
        }

        setState(() {
          _departments = departments;
          _filteredDepartments = departments;
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.error ?? 'Failed to load departments'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading departments: ${e.toString()}'),
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

  void _filterDepartments() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredDepartments = _departments;
      } else {
        _filteredDepartments =
            _departments.where((dept) {
              final name = (dept['name'] ?? '').toString().toLowerCase();
              final code = (dept['code'] ?? '').toString().toLowerCase();
              final parentName = _getParentDepartmentName(dept).toLowerCase();
              return name.contains(query) ||
                  code.contains(query) ||
                  parentName.contains(query);
            }).toList();
      }

      // Apply status filter
      if (_selectedFilter != 'All') {
        final isActive = _selectedFilter == 'Active';
        _filteredDepartments =
            _filteredDepartments
                .where((dept) => (dept['isActive'] ?? true) == isActive)
                .toList();
      }
    });
  }

  void _onFilterChanged(String? value) {
    setState(() {
      _selectedFilter = value ?? 'All';
      _filterDepartments();
    });
  }

  String _getParentDepartmentName(dynamic department) {
    final parent = department['parentDepartment'];
    if (parent == null) return 'N/A';
    if (parent is Map) {
      return parent['name'] ?? 'N/A';
    }
    return 'N/A';
  }

  Future<void> _deleteDepartment(dynamic department) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Department'),
            content: Text(
              'Are you sure you want to delete "${department['name']}"? This action cannot be undone.',
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
      final departmentProvider = Provider.of<DepartmentProvider>(
        context,
        listen: false,
      );
      final departmentId = (department['_id'] ?? department['id']).toString();
      final response = await departmentProvider.deleteDepartment(departmentId);

      if (mounted) {
        if (response.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Department deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
          _loadDepartments();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.error ?? 'Failed to delete department'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _editDepartment(dynamic department) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateDepartmentScreen(department: department),
      ),
    );

    if (result == true) {
      _loadDepartments();
    }
  }

  void _viewDepartmentDetails(dynamic department) {
    showDialog(
      context: context,
      builder: (context) => DepartmentDetailsDialog(department: department),
    );
  }

  void _createNewDepartment() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateDepartmentScreen()),
    );

    if (result == true) {
      _loadDepartments();
    }
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
                  'Manage Departments',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: _createNewDepartment,
                  icon: const Icon(Icons.add),
                  label: const Text('Create Department'),
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
                      hintText: 'Search by name, code, or parent department',
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
                  onPressed: _loadDepartments,
                  tooltip: 'Refresh',
                ),
              ],
            ),
          ),
          // Departments List
          Expanded(
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _filteredDepartments.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.business_center_outlined,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _departments.isEmpty
                                ? 'No departments found. Create your first department!'
                                : 'No departments match your search',
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
                                    'DEPARTMENT NAME',
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
                                    'CODE',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF666666),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'PARENT DEPARTMENT',
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
                                    'TYPE',
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
                          // Table Rows
                          Expanded(
                            child: ListView.builder(
                              itemCount: _filteredDepartments.length,
                              itemBuilder: (context, index) {
                                final department = _filteredDepartments[index];
                                final isActive = department['isActive'] ?? true;
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey[200]!,
                                        width: 0.5,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: const Color(
                                                  0xFF4285F4,
                                                ).withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Icon(
                                                department['parentDepartment'] !=
                                                        null
                                                    ? Icons
                                                        .subdirectory_arrow_right
                                                    : Icons.business,
                                                color: const Color(0xFF4285F4),
                                                size: 20,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    department['name'] ?? 'N/A',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color(0xFF1A1A1A),
                                                    ),
                                                  ),
                                                  if (department['description'] !=
                                                          null &&
                                                      department['description']
                                                          .toString()
                                                          .isNotEmpty)
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                            top: 4,
                                                          ),
                                                      child: Text(
                                                        department['description']
                                                                    .toString()
                                                                    .length >
                                                                50
                                                            ? '${department['description'].toString().substring(0, 50)}...'
                                                            : department['description']
                                                                .toString(),
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color:
                                                              Colors.grey[600],
                                                        ),
                                                        maxLines: 1,
                                                        overflow:
                                                            TextOverflow
                                                                .ellipsis,
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
                                          department['code'] ?? 'N/A',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Color(0xFF1A1A1A),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          _getParentDepartmentName(department),
                                          style: TextStyle(
                                            fontSize: 13,
                                            color:
                                                department['parentDepartment'] !=
                                                        null
                                                    ? const Color(0xFF1A1A1A)
                                                    : Colors.grey[500],
                                            fontStyle:
                                                department['parentDepartment'] ==
                                                        null
                                                    ? FontStyle.italic
                                                    : FontStyle.normal,
                                          ),
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
                                            color: Colors.blue[50],
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          child: Text(
                                            department['departmentType'] ??
                                                'N/A',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.blue[700],
                                              fontWeight: FontWeight.w500,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
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
                                                isActive
                                                    ? Colors.green[50]
                                                    : Colors.red[50],
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                width: 6,
                                                height: 6,
                                                decoration: BoxDecoration(
                                                  color:
                                                      isActive
                                                          ? Colors.green[700]
                                                          : Colors.red[700],
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                isActive
                                                    ? 'Active'
                                                    : 'Inactive',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color:
                                                      isActive
                                                          ? Colors.green[700]
                                                          : Colors.red[700],
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
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
                                                Icons.visibility_outlined,
                                                size: 20,
                                              ),
                                              onPressed:
                                                  () => _viewDepartmentDetails(
                                                    department,
                                                  ),
                                              tooltip: 'View Details',
                                              color: const Color(0xFF4285F4),
                                              padding: EdgeInsets.zero,
                                              constraints:
                                                  const BoxConstraints(),
                                            ),
                                            const SizedBox(width: 16),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.edit_outlined,
                                                size: 20,
                                              ),
                                              onPressed:
                                                  () => _editDepartment(
                                                    department,
                                                  ),
                                              tooltip: 'Edit',
                                              color: const Color(0xFF4285F4),
                                              padding: EdgeInsets.zero,
                                              constraints:
                                                  const BoxConstraints(),
                                            ),
                                            const SizedBox(width: 16),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.delete_outline,
                                                size: 20,
                                              ),
                                              onPressed:
                                                  () => _deleteDepartment(
                                                    department,
                                                  ),
                                              tooltip: 'Delete',
                                              color: Colors.red[700],
                                              padding: EdgeInsets.zero,
                                              constraints:
                                                  const BoxConstraints(),
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
                        ],
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}

class DepartmentDetailsDialog extends StatelessWidget {
  final dynamic department;

  const DepartmentDetailsDialog({super.key, required this.department});

  String _getParentDepartmentName() {
    final parent = department['parentDepartment'];
    if (parent == null) return 'None (Main Department)';
    if (parent is Map) {
      return parent['name'] ?? 'N/A';
    }
    return 'N/A';
  }

  @override
  Widget build(BuildContext context) {
    final isActive = department['isActive'] ?? true;

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
                    child: Icon(
                      department['parentDepartment'] != null
                          ? Icons.subdirectory_arrow_right
                          : Icons.business,
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
                          department['name'] ?? 'N/A',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          department['code'] ?? 'N/A',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                            letterSpacing: 1.2,
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

                    // Basic Information Card
                    _buildInfoCard('Basic Information', Icons.info_outline, [
                      _buildModernDetailRow(
                        Icons.label,
                        'Department Type',
                        department['departmentType'] ?? 'N/A',
                      ),
                      const SizedBox(height: 16),
                      _buildModernDetailRow(
                        Icons.account_tree,
                        'Parent Department',
                        _getParentDepartmentName(),
                      ),
                      const SizedBox(height: 16),
                      _buildModernDetailRow(
                        Icons.description,
                        'Description',
                        department['description'] ?? 'No description provided',
                      ),
                    ]),

                    const SizedBox(height: 20),

                    // Timestamps Card
                    _buildInfoCard('Timestamps', Icons.access_time, [
                      _buildModernDetailRow(
                        Icons.calendar_today,
                        'Created At',
                        department['createdAt'] != null
                            ? DateFormat(
                              'MMM dd, yyyy HH:mm',
                            ).format(DateTime.parse(department['createdAt']))
                            : 'N/A',
                      ),
                      const SizedBox(height: 16),
                      _buildModernDetailRow(
                        Icons.update,
                        'Last Updated',
                        department['updatedAt'] != null
                            ? DateFormat(
                              'MMM dd, yyyy HH:mm',
                            ).format(DateTime.parse(department['updatedAt']))
                            : 'N/A',
                      ),
                    ]),
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
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF4285F4).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: const Color(0xFF4285F4), size: 20),
              ),
              const SizedBox(width: 12),
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
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF1A1A1A),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
