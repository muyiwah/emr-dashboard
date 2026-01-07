import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schmgtsystem/providers/role_provider.dart';

class RoleManagementScreen extends StatefulWidget {
  const RoleManagementScreen({super.key});

  @override
  State<RoleManagementScreen> createState() => _RoleManagementScreenState();
}

class _RoleManagementScreenState extends State<RoleManagementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _departmentController = TextEditingController();
  bool _isActive = true;
  bool _isLoading = false;

  // Available resources and actions
  final List<String> _resources = [
    'patients',
    'encounters',
    'appointments',
    'medications',
    'lab_orders',
    'scans',
    'pharmacy',
    'users',
    'staff',
    'roles',
    'invoices',
    'audit',
  ];

  final List<String> _actions = ['read', 'write', 'update', 'delete'];

  // Map to store permissions: resource -> list of selected actions
  final Map<String, List<String>> _permissions = {};

  @override
  void initState() {
    super.initState();
    // Initialize permissions map
    for (var resource in _resources) {
      _permissions[resource] = [];
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _descriptionController.dispose();
    _departmentController.dispose();
    super.dispose();
  }

  void _togglePermission(String resource, String action) {
    setState(() {
      if (_permissions[resource]!.contains(action)) {
        _permissions[resource]!.remove(action);
      } else {
        _permissions[resource]!.add(action);
      }
    });
  }

  bool _hasPermission(String resource, String action) {
    return _permissions[resource]?.contains(action) ?? false;
  }

  void _selectAllActions(String resource) {
    setState(() {
      _permissions[resource] = List.from(_actions);
    });
  }

  void _clearAllActions(String resource) {
    setState(() {
      _permissions[resource] = [];
    });
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Build permissions array
    final permissionsList = _permissions.entries
        .where((entry) => entry.value.isNotEmpty)
        .map((entry) => {
              'resource': entry.key,
              'actions': entry.value,
            })
        .toList();

    if (permissionsList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one permission'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final roleData = {
      'name': _nameController.text.trim(),
      'code': _codeController.text.trim().toUpperCase(),
      'description': _descriptionController.text.trim(),
      'department': _departmentController.text.trim(),
      'permissions': permissionsList,
      'isActive': _isActive,
    };

    setState(() {
      _isLoading = true;
    });

    final roleProvider = Provider.of<RoleProvider>(context, listen: false);
    final response = await roleProvider.createRole(roleData);

    if (mounted) {
      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Role created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        _resetForm();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.error ?? 'Failed to create role'),
            backgroundColor: Colors.red,
          ),
        );
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _codeController.clear();
    _descriptionController.clear();
    _departmentController.clear();
    _isActive = true;
    for (var resource in _resources) {
      _permissions[resource] = [];
    }
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    String? hint,
    IconData? icon,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: icon != null ? Icon(icon, color: const Color(0xFF4285F4)) : null,
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
          borderSide: const BorderSide(color: Color(0xFF4285F4), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        filled: true,
        fillColor: const Color(0xFFF8F9FA),
      ),
      validator: validator,
    );
  }

  Widget _buildSectionCard(String title, IconData icon, List<Widget> children) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
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
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ...children,
          ],
        ),
      ),
    );
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
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                  color: const Color(0xFF1A1A1A),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Create Role',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: _resetForm,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset Form'),
                ),
                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Basic Information
                    _buildSectionCard(
                      'Basic Information',
                      Icons.info_outline,
                      [
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextFormField(
                                controller: _nameController,
                                label: 'Role Name *',
                                hint: 'e.g., Doctor, Nurse',
                                icon: Icons.badge,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter role name';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildTextFormField(
                                controller: _codeController,
                                label: 'Role Code *',
                                hint: 'e.g., DOCTOR, NURSE',
                                icon: Icons.code,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter role code';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildTextFormField(
                          controller: _descriptionController,
                          label: 'Description *',
                          hint: 'Brief description of the role',
                          icon: Icons.description,
                          maxLines: 3,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter description';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextFormField(
                                controller: _departmentController,
                                label: 'Department *',
                                hint: 'e.g., General Medicine, Nursing',
                                icon: Icons.business,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter department';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8F9FA),
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(color: Colors.grey[200]!),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: (_isActive
                                                ? Colors.green
                                                : Colors.grey)
                                            .withOpacity(0.1),
                                        borderRadius:
                                            BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        _isActive
                                            ? Icons.check_circle
                                            : Icons.cancel,
                                        color: _isActive
                                            ? Colors.green[700]
                                            : Colors.grey[700],
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    const Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Active Status',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF1A1A1A),
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            'Enable or disable this role',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF666666),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Switch(
                                      value: _isActive,
                                      onChanged: (value) {
                                        setState(() {
                                          _isActive = value;
                                        });
                                      },
                                      activeColor: const Color(0xFF4285F4),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Permissions
                    _buildSectionCard(
                      'Permissions',
                      Icons.security,
                      [
                        const Text(
                          'Select the resources and actions this role can perform',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF666666),
                          ),
                        ),
                        const SizedBox(height: 24),
                        ..._resources.map(
                          (resource) => _buildResourcePermissions(resource),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4285F4),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text(
                                'Create Role',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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

  Widget _buildResourcePermissions(String resource) {
    final hasAnyPermission = _permissions[resource]!.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: hasAnyPermission
            ? const Color(0xFF4285F4).withOpacity(0.05)
            : Colors.grey[50],
        border: Border.all(
          color: hasAnyPermission
              ? const Color(0xFF4285F4)
              : Colors.grey[300]!,
          width: hasAnyPermission ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  resource.toUpperCase().replaceAll('_', ' '),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: hasAnyPermission
                        ? const Color(0xFF4285F4)
                        : const Color(0xFF1A1A1A),
                  ),
                ),
              ),
              TextButton(
                onPressed: () => _selectAllActions(resource),
                child: const Text('Select All'),
              ),
              TextButton(
                onPressed: () => _clearAllActions(resource),
                child: const Text('Clear'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _actions.map((action) {
              final isSelected = _hasPermission(resource, action);
              return FilterChip(
                label: Text(action.toUpperCase()),
                selected: isSelected,
                onSelected: (selected) => _togglePermission(resource, action),
                selectedColor: const Color(0xFF4285F4).withOpacity(0.2),
                checkmarkColor: const Color(0xFF4285F4),
                labelStyle: TextStyle(
                  color: isSelected
                      ? const Color(0xFF4285F4)
                      : const Color(0xFF666666),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                backgroundColor: Colors.white,
                side: BorderSide(
                  color: isSelected
                      ? const Color(0xFF4285F4)
                      : Colors.grey[300]!,
                  width: isSelected ? 2 : 1,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

