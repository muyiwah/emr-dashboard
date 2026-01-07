import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schmgtsystem/providers/department_provider.dart';

class CreateDepartmentScreen extends StatefulWidget {
  final dynamic department; // For edit mode

  const CreateDepartmentScreen({super.key, this.department});

  @override
  State<CreateDepartmentScreen> createState() => _CreateDepartmentScreenState();
}

class _CreateDepartmentScreenState extends State<CreateDepartmentScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isLoadingDepartments = true;
  List<dynamic> _parentDepartments = [];

  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedParentDepartmentId;
  String? _departmentType;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _loadParentDepartments().then((_) {
      // Populate form after departments are loaded (important for parent dropdown)
      if (widget.department != null) {
        _populateFormFromDepartment(widget.department);
      }
    });
  }

  void _populateFormFromDepartment(dynamic department) {
    if (department == null) return;

    setState(() {
      _nameController.text = (department['name'] ?? '').toString();
      _codeController.text = (department['code'] ?? '').toString();
      _descriptionController.text =
          (department['description'] ?? '').toString();
      _departmentType = department['departmentType'];
      _isActive = department['isActive'] ?? true;

      // Parent Department
      final parent = department['parentDepartment'];
      if (parent != null) {
        String? parentId;
        if (parent is Map) {
          parentId = (parent['_id'] ?? parent['id']).toString();
        } else if (parent is String) {
          parentId = parent;
        }

        if (parentId != null) {
          // Verify the parent exists in the loaded departments list
          bool parentExists = _parentDepartments.any((d) {
            final dId = (d['_id'] ?? d['id']).toString();
            return dId == parentId;
          });

          if (parentExists) {
            _selectedParentDepartmentId = parentId;
          } else {
            // If parent not found in list, still set it (might be valid but not loaded)
            _selectedParentDepartmentId = parentId;
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadParentDepartments() async {
    try {
      final departmentProvider = Provider.of<DepartmentProvider>(
        context,
        listen: false,
      );
      final response = await departmentProvider.fetchRootDepartments();

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
          _parentDepartments = departments;
          _isLoadingDepartments = false;
        });
      } else {
        setState(() {
          _isLoadingDepartments = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoadingDepartments = false;
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final navigator = Navigator.of(
      context,
    ); // Capture navigator before async gap

    final departmentData = <String, dynamic>{
      'name': _nameController.text.trim(),
      'code': _codeController.text.trim().toUpperCase(),
      'description': _descriptionController.text.trim(),
      'departmentType': _departmentType ?? 'clinical',
      'isActive': _isActive,
      if (_selectedParentDepartmentId != null)
        'parentDepartment': _selectedParentDepartmentId,
    };

    final departmentProvider = Provider.of<DepartmentProvider>(
      context,
      listen: false,
    );

    final response =
        widget.department == null
            ? await departmentProvider.createDepartment(departmentData)
            : await departmentProvider.updateDepartment(
              (widget.department['_id'] ?? widget.department['id']).toString(),
              departmentData,
            );

    if (response.success) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        showDialog(
          context: context,
          barrierDismissible: false,
          builder:
              (dialogContext) => AlertDialog(
                title: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 28),
                    SizedBox(width: 12),
                    Text('Success'),
                  ],
                ),
                content: Text(
                  widget.department == null
                      ? 'Department created successfully!'
                      : 'Department updated successfully!',
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop(); // Pop the dialog
                      if (mounted && navigator.canPop()) {
                        navigator.pop(true); // Pop the CreateDepartmentScreen
                      }
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
        );
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.error ?? 'Failed to create department'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon:
            icon != null ? Icon(icon, color: const Color(0xFF4285F4)) : null,
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
      maxLines: maxLines,
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    String? Function(String?)? validator,
    IconData? icon,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon:
            icon != null ? Icon(icon, color: const Color(0xFF4285F4)) : null,
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
      items:
          items.map((item) {
            return DropdownMenuItem<String>(value: item, child: Text(item));
          }).toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }

  Widget _buildParentDepartmentDropdown() {
    if (_isLoadingDepartments) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    return DropdownButtonFormField<String>(
      value: _selectedParentDepartmentId,
      decoration: InputDecoration(
        labelText: 'Parent Department (Optional)',
        hintText: 'Select to create a subdepartment',
        prefixIcon: Icon(Icons.account_tree, color: const Color(0xFF4285F4)),
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
        filled: true,
        fillColor: const Color(0xFFF8F9FA),
      ),
      items: [
        const DropdownMenuItem<String>(
          value: null,
          child: Text('None (Create Main Department)'),
        ),
        ..._parentDepartments.map((dept) {
          final deptId = dept['_id'] ?? dept['id'];
          final deptName = dept['name'] ?? 'Unknown';
          return DropdownMenuItem<String>(
            value: deptId.toString(),
            child: Text(deptName),
          );
        }),
      ],
      onChanged: (value) {
        setState(() {
          _selectedParentDepartmentId = value;
        });
      },
    );
  }

  Widget _buildSectionCard(String title, IconData icon, List<Widget> children) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      color: Colors.white,
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
                Text(
                  widget.department == null
                      ? 'Create Department'
                      : 'Edit Department',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const Spacer(),
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
          // Form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSectionCard(
                      'Department Information',
                      Icons.business,
                      [
                        _buildTextFormField(
                          controller: _nameController,
                          label: 'Department Name *',
                          icon: Icons.business_center,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildTextFormField(
                          controller: _codeController,
                          label: 'Department Code *',
                          icon: Icons.code,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildTextFormField(
                          controller: _descriptionController,
                          label: 'Description',
                          icon: Icons.description,
                          maxLines: 3,
                        ),
                        const SizedBox(height: 16),
                        _buildDropdownField(
                          label: 'Department Type *',
                          value: _departmentType,
                          items: const [
                            'clinical',
                            'administrative',
                            'support',
                            'diagnostic',
                            'emergency',
                            'pharmacy',
                            'nursing',
                            'allied_health',
                            'anesthesia',
                            'clinic',
                            'public_health',
                            'facility',
                            'education',
                          ],
                          icon: Icons.category,
                          onChanged: (value) {
                            setState(() {
                              _departmentType = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildParentDepartmentDropdown(),
                        const SizedBox(height: 24),
                        // Active Status
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F9FA),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[200]!),
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
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  _isActive ? Icons.check_circle : Icons.cancel,
                                  color:
                                      _isActive
                                          ? Colors.green[700]
                                          : Colors.grey[700],
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      'Enable or disable this department',
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
                      ],
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                        backgroundColor: const Color(0xFF4285F4),
                        foregroundColor: Colors.white,
                      ),
                      child:
                          _isLoading
                              ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                              : Text(
                                widget.department == null
                                    ? 'Create Department'
                                    : 'Update Department',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
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
}
