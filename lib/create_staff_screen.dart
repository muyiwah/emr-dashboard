import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:schmgtsystem/providers/role_provider.dart';
import 'package:schmgtsystem/providers/staff_provider.dart';
import 'package:schmgtsystem/providers/department_provider.dart';

class CreateStaffScreen extends StatefulWidget {
  final dynamic staff; // For edit mode

  const CreateStaffScreen({super.key, this.staff});

  @override
  State<CreateStaffScreen> createState() => _CreateStaffScreenState();
}

class _CreateStaffScreenState extends State<CreateStaffScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isLoadingRoles = true;
  bool _isLoadingDepartments = true;
  List<dynamic> _roles = [];
  String? _selectedRoleId;
  List<dynamic> _departments = [];
  String? _selectedDepartmentId;

  // Personal Information
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  DateTime? _dateOfBirth;
  String? _gender;
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  // Address
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _countryController = TextEditingController();

  // Professional Information
  final _specialtyController = TextEditingController();
  final _licenseNumberController = TextEditingController();
  DateTime? _licenseExpiry;

  // Employment Information
  DateTime? _hireDate;
  String? _employmentType;
  final _salaryController = TextEditingController();
  String? _shift;
  bool _isActive = true;

  // Emergency Contact
  final _emergencyNameController = TextEditingController();
  final _emergencyRelationshipController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();
  final _emergencyEmailController = TextEditingController();

  // Qualifications
  final List<Map<String, dynamic>> _qualifications = [];

  // Notes
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _countryController.text = 'USA'; // Default country
    _loadRoles();
    _loadDepartments();
  }

  void _populateFormFromStaff(dynamic staff) {
    if (staff == null) return;

    setState(() {
      _firstNameController.text = (staff['firstName'] ?? '').toString();
      _lastNameController.text = (staff['lastName'] ?? '').toString();
      _phoneController.text = (staff['phone'] ?? '').toString();
      _emailController.text = (staff['email'] ?? '').toString();

      // Gender - capitalize first letter to match dropdown
      if (staff['gender'] != null) {
        final genderStr = staff['gender'].toString();
        if (genderStr.isNotEmpty) {
          _gender =
              genderStr[0].toUpperCase() + genderStr.substring(1).toLowerCase();
        }
      }

      // Date of Birth
      if (staff['dateOfBirth'] != null) {
        try {
          if (staff['dateOfBirth'] is String) {
            _dateOfBirth = DateTime.parse(staff['dateOfBirth']);
          } else if (staff['dateOfBirth'] is DateTime) {
            _dateOfBirth = staff['dateOfBirth'];
          }
        } catch (e) {
          // Ignore parsing errors
        }
      }

      // Address
      final address = staff['address'];
      if (address != null && address is Map) {
        final addrMap = address as Map<String, dynamic>;
        _streetController.text = (addrMap['street'] ?? '').toString();
        _cityController.text = (addrMap['city'] ?? '').toString();
        _stateController.text = (addrMap['state'] ?? '').toString();
        _zipCodeController.text = (addrMap['zipCode'] ?? '').toString();
        if (addrMap['country'] != null) {
          _countryController.text = addrMap['country'].toString();
        }
      }

      // Professional
      // Department - need to find matching department ID from loaded departments
      final department = staff['department'];
      if (department != null) {
        String? departmentId;
        if (department is Map) {
          departmentId =
              department['_id']?.toString() ?? department['id']?.toString();
        } else if (department is String) {
          // If department is just an ID string, use it directly
          departmentId = department;
        }

        if (departmentId != null) {
          // Verify the department exists in the loaded departments list
          bool departmentExists = _departments.any((d) {
            final dId = (d['_id'] ?? d['id']).toString();
            return dId == departmentId;
          });

          if (departmentExists) {
            _selectedDepartmentId = departmentId;
          } else {
            // If department not found in list, still set it (might be valid but not loaded)
            _selectedDepartmentId = departmentId;
          }
        }
      }
      _specialtyController.text = (staff['specialty'] ?? '').toString();
      _licenseNumberController.text = (staff['licenseNumber'] ?? '').toString();

      // License Expiry
      if (staff['licenseExpiry'] != null) {
        try {
          if (staff['licenseExpiry'] is String) {
            _licenseExpiry = DateTime.parse(staff['licenseExpiry']);
          } else if (staff['licenseExpiry'] is DateTime) {
            _licenseExpiry = staff['licenseExpiry'];
          }
        } catch (e) {
          // Ignore parsing errors
        }
      }

      // Role - need to find matching role ID from loaded roles
      final role = staff['role'];
      if (role != null) {
        String? roleId;
        if (role is Map) {
          roleId = role['_id']?.toString() ?? role['id']?.toString();
        } else if (role is String) {
          // If role is just an ID string, use it directly
          roleId = role;
        }

        if (roleId != null) {
          // Verify the role exists in the loaded roles list
          bool roleExists = _roles.any((r) {
            final rId = (r['_id'] ?? r['id']).toString();
            return rId == roleId;
          });

          if (roleExists) {
            _selectedRoleId = roleId;
          } else {
            // If role not found in list, still set it (might be valid but not loaded)
            _selectedRoleId = roleId;
          }
        }
      }

      // Employment
      if (staff['hireDate'] != null) {
        try {
          if (staff['hireDate'] is String) {
            _hireDate = DateTime.parse(staff['hireDate']);
          } else if (staff['hireDate'] is DateTime) {
            _hireDate = staff['hireDate'];
          }
        } catch (e) {
          // Ignore parsing errors
        }
      }
      _employmentType = staff['employmentType'];
      _shift = staff['shift'];
      if (staff['salary'] != null) {
        _salaryController.text = staff['salary'].toString();
      }
      _isActive = staff['isActive'] ?? true;

      // Emergency Contact
      final emergencyContact = staff['emergencyContact'];
      if (emergencyContact != null && emergencyContact is Map) {
        final ecMap = emergencyContact as Map<String, dynamic>;
        _emergencyNameController.text = (ecMap['name'] ?? '').toString();
        _emergencyRelationshipController.text =
            (ecMap['relationship'] ?? '').toString();
        _emergencyPhoneController.text = (ecMap['phone'] ?? '').toString();
        _emergencyEmailController.text = (ecMap['email'] ?? '').toString();
      }

      // Qualifications
      final qualifications = staff['qualifications'];
      _qualifications.clear();
      if (qualifications != null && qualifications is List) {
        _qualifications.addAll(
          qualifications.map((q) {
            if (q is Map) {
              return {
                'degree': (q['degree'] ?? '').toString(),
                'institution': (q['institution'] ?? '').toString(),
                'year': q['year'],
                if (q['certificate'] != null) 'certificate': q['certificate'],
              };
            }
            return {'degree': '', 'institution': '', 'year': null};
          }),
        );
      }

      // Notes
      _notesController.text = (staff['notes'] ?? '').toString();
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    _countryController.dispose();
    _specialtyController.dispose();
    _licenseNumberController.dispose();
    _salaryController.dispose();
    _emergencyNameController.dispose();
    _emergencyRelationshipController.dispose();
    _emergencyPhoneController.dispose();
    _emergencyEmailController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadRoles() async {
    try {
      final roleProvider = Provider.of<RoleProvider>(context, listen: false);
      final response = await roleProvider.fetchRoles();
      if (response.success && response.data != null) {
        List<dynamic> roles = [];
        if (response.data is Map) {
          final data = response.data as Map<String, dynamic>;
          if (data['data'] != null && data['data'] is Map) {
            final innerData = data['data'] as Map<String, dynamic>;
            if (innerData['roles'] != null && innerData['roles'] is List) {
              roles = innerData['roles'];
            }
          } else if (data['roles'] != null && data['roles'] is List) {
            roles = data['roles'];
          }
        }

        setState(() {
          _roles = roles;
          _isLoadingRoles = false;
        });

        // After roles are loaded, populate form if editing and departments are also loaded
        if (widget.staff != null && !_isLoadingDepartments) {
          _populateFormFromStaff(widget.staff);
        }
      } else {
        setState(() {
          _isLoadingRoles = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoadingRoles = false;
      });
    }
  }

  Future<void> _loadDepartments() async {
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
          }
        }

        setState(() {
          _departments = departments;
          _isLoadingDepartments = false;
        });

        // After departments are loaded, populate form if editing and roles are also loaded
        if (widget.staff != null && !_isLoadingRoles) {
          _populateFormFromStaff(widget.staff);
        }
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

  Future<void> _selectDate(
    BuildContext context,
    Function(DateTime) onDateSelected,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      onDateSelected(picked);
    }
  }

  void _addQualification() {
    showDialog(
      context: context,
      builder:
          (context) => _QualificationDialog(
            onSave: (qualification) {
              setState(() {
                _qualifications.add(qualification);
              });
            },
          ),
    );
  }

  void _removeQualification(int index) {
    setState(() {
      _qualifications.removeAt(index);
    });
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedRoleId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a role'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final staffData = <String, dynamic>{
      'firstName': _firstNameController.text.trim(),
      'lastName': _lastNameController.text.trim(),
      if (_dateOfBirth != null)
        'dateOfBirth': DateFormat('yyyy-MM-dd').format(_dateOfBirth!),
      if (_gender != null) 'gender': _gender!.toLowerCase(),
      'phone': _phoneController.text.trim(),
      'email': _emailController.text.trim(),
      'role': _selectedRoleId,
      'department': _selectedDepartmentId,
      if (_hireDate != null)
        'hireDate': DateFormat('yyyy-MM-dd').format(_hireDate!),
      if (_employmentType != null) 'employmentType': _employmentType,
      if (_shift != null) 'shift': _shift,
      'isActive': _isActive,
    };

    // Address (if any field is filled)
    if (_streetController.text.isNotEmpty ||
        _cityController.text.isNotEmpty ||
        _stateController.text.isNotEmpty ||
        _zipCodeController.text.isNotEmpty) {
      staffData['address'] = {
        if (_streetController.text.isNotEmpty)
          'street': _streetController.text.trim(),
        if (_cityController.text.isNotEmpty)
          'city': _cityController.text.trim(),
        if (_stateController.text.isNotEmpty)
          'state': _stateController.text.trim(),
        if (_zipCodeController.text.isNotEmpty)
          'zipCode': _zipCodeController.text.trim(),
        if (_countryController.text.isNotEmpty)
          'country': _countryController.text.trim(),
      };
    }

    // Professional fields
    if (_specialtyController.text.isNotEmpty) {
      staffData['specialty'] = _specialtyController.text.trim();
    }
    if (_licenseNumberController.text.isNotEmpty) {
      staffData['licenseNumber'] = _licenseNumberController.text.trim();
    }
    if (_licenseExpiry != null) {
      staffData['licenseExpiry'] = DateFormat(
        'yyyy-MM-dd',
      ).format(_licenseExpiry!);
    }

    // Salary
    if (_salaryController.text.isNotEmpty) {
      final salary = double.tryParse(_salaryController.text.trim());
      if (salary != null) {
        staffData['salary'] = salary;
      }
    }

    // Qualifications
    if (_qualifications.isNotEmpty) {
      staffData['qualifications'] = _qualifications;
    }

    // Emergency Contact
    if (_emergencyNameController.text.isNotEmpty) {
      staffData['emergencyContact'] = {
        'name': _emergencyNameController.text.trim(),
        if (_emergencyRelationshipController.text.isNotEmpty)
          'relationship': _emergencyRelationshipController.text.trim(),
        if (_emergencyPhoneController.text.isNotEmpty)
          'phone': _emergencyPhoneController.text.trim(),
        if (_emergencyEmailController.text.isNotEmpty)
          'email': _emergencyEmailController.text.trim(),
      };
    }

    // Notes
    if (_notesController.text.isNotEmpty) {
      staffData['notes'] = _notesController.text.trim();
    }

    setState(() {
      _isLoading = true;
    });

    final staffProvider = Provider.of<StaffProvider>(context, listen: false);

    final response =
        widget.staff == null
            ? await staffProvider.createStaff(staffData)
            : await staffProvider.updateStaff(
              (widget.staff['_id'] ?? widget.staff['id']).toString(),
              staffData,
            );

    if (response.success) {
      if (mounted) {
        // Reset loading state
        setState(() {
          _isLoading = false;
        });

        // Show success dialog instead of auto-navigating
        if (mounted) {
          final navigator = Navigator.of(context);
          await showDialog(
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
                    widget.staff == null
                        ? 'Staff member created successfully!'
                        : 'Staff member updated successfully!',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop(); // Close dialog
                        if (mounted && navigator.canPop()) {
                          navigator.pop(true); // Return to previous screen
                        }
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
          );
        }
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.error ?? 'Failed to create staff member'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body:
          (_isLoadingRoles || _isLoadingDepartments)
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  // Header
                  Container(
                    height: 80,
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            final router = GoRouter.of(context);
                            if (router.canPop()) {
                              router.pop();
                            } else {
                              // Fallback to manage staff list
                              context.go('/manage-staff/manage-staff');
                            }
                          },
                          color: const Color(0xFF1A1A1A),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.staff == null
                              ? 'Create Staff Member'
                              : 'Edit Staff Member',
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
                  // Form Content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Personal Information
                            _buildSectionCard(
                              'Personal Information',
                              Icons.person,
                              [
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildTextFormField(
                                        controller: _firstNameController,
                                        label: 'First Name *',
                                        icon: Icons.person_outline,
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return 'Required';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _buildTextFormField(
                                        controller: _lastNameController,
                                        label: 'Last Name *',
                                        icon: Icons.person_outline,
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return 'Required';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildDateField(
                                        label: 'Date of Birth',
                                        value: _dateOfBirth,
                                        onTap:
                                            () => _selectDate(
                                              context,
                                              (date) => setState(
                                                () => _dateOfBirth = date,
                                              ),
                                            ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _buildDropdownField(
                                        label: 'Gender',
                                        value: _gender,
                                        items: const [
                                          'Male',
                                          'Female',
                                          'Other',
                                        ],
                                        onChanged:
                                            (value) =>
                                                setState(() => _gender = value),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildTextFormField(
                                        controller: _phoneController,
                                        label: 'Phone *',
                                        icon: Icons.phone,
                                        keyboardType: TextInputType.phone,
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return 'Required';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _buildTextFormField(
                                        controller: _emailController,
                                        label: 'Email *',
                                        icon: Icons.email,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return 'Required';
                                          }
                                          if (!value.contains('@')) {
                                            return 'Invalid email';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // Address
                            _buildSectionCard('Address', Icons.location_on, [
                              _buildTextFormField(
                                controller: _streetController,
                                label: 'Street',
                                icon: Icons.home,
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: _buildTextFormField(
                                      controller: _cityController,
                                      label: 'City',
                                      icon: Icons.location_city,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildTextFormField(
                                      controller: _stateController,
                                      label: 'State',
                                      icon: Icons.map,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildTextFormField(
                                      controller: _zipCodeController,
                                      label: 'Zip Code',
                                      icon: Icons.pin,
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildTextFormField(
                                      controller: _countryController,
                                      label: 'Country',
                                      icon: Icons.public,
                                    ),
                                  ),
                                ],
                              ),
                            ]),

                            const SizedBox(height: 24),

                            // Professional Information
                            _buildSectionCard(
                              'Professional Information',
                              Icons.work,
                              [
                                _buildDropdownField(
                                  label: 'Role *',
                                  value: _selectedRoleId,
                                  items:
                                      _roles.map((role) {
                                        return DropdownMenuItem(
                                          value: role['_id'] ?? role['id'],
                                          child: Text(role['name'] ?? 'N/A'),
                                        );
                                      }).toList(),
                                  onChanged:
                                      (value) => setState(
                                        () => _selectedRoleId = value,
                                      ),
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Please select a role';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                _buildSearchableDepartmentField(),
                                const SizedBox(height: 16),
                                _buildTextFormField(
                                  controller: _specialtyController,
                                  label: 'Specialty (e.g., Cardiologist)',
                                  icon: Icons.medical_services,
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildTextFormField(
                                        controller: _licenseNumberController,
                                        label: 'License Number',
                                        icon: Icons.badge,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _buildDateField(
                                        label: 'License Expiry',
                                        value: _licenseExpiry,
                                        onTap:
                                            () => _selectDate(
                                              context,
                                              (date) => setState(
                                                () => _licenseExpiry = date,
                                              ),
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // Qualifications
                            _buildSectionCard('Qualifications', Icons.school, [
                              if (_qualifications.isEmpty)
                                const Text(
                                  'No qualifications added',
                                  style: TextStyle(color: Colors.grey),
                                )
                              else
                                ..._qualifications.asMap().entries.map((entry) {
                                  final qual = entry.value;
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[50],
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.grey[300]!,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                qual['degree'] ?? 'N/A',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                '${qual['institution'] ?? 'N/A'} (${qual['year'] ?? 'N/A'})',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            size: 20,
                                          ),
                                          color: Colors.red,
                                          onPressed:
                                              () => _removeQualification(
                                                entry.key,
                                              ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              const SizedBox(height: 8),
                              OutlinedButton.icon(
                                onPressed: _addQualification,
                                icon: const Icon(Icons.add),
                                label: const Text('Add Qualification'),
                              ),
                            ]),

                            const SizedBox(height: 24),

                            // Employment Information
                            _buildSectionCard(
                              'Employment Information',
                              Icons.business_center,
                              [
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildDateField(
                                        label: 'Hire Date *',
                                        value: _hireDate,
                                        onTap:
                                            () => _selectDate(
                                              context,
                                              (date) => setState(
                                                () => _hireDate = date,
                                              ),
                                            ),
                                        validator: (date) {
                                          if (date == null) {
                                            return 'Required';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _buildDropdownField(
                                        label: 'Employment Type',
                                        value: _employmentType,
                                        items: const [
                                          'full-time',
                                          'part-time',
                                          'contract',
                                          'temporary',
                                        ],
                                        onChanged:
                                            (value) => setState(
                                              () => _employmentType = value,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildTextFormField(
                                        controller: _salaryController,
                                        label: 'Salary',
                                        icon: Icons.attach_money,
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _buildDropdownField(
                                        label: 'Shift',
                                        value: _shift,
                                        items: const [
                                          'day',
                                          'night',
                                          'rotating',
                                          'flexible',
                                        ],
                                        onChanged:
                                            (value) =>
                                                setState(() => _shift = value),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8F9FA),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(0xFFE0E0E0),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.toggle_on,
                                        color: Color(0xFF4285F4),
                                        size: 24,
                                      ),
                                      const SizedBox(width: 12),
                                      const Text(
                                        'Active Status',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF1A1A1A),
                                        ),
                                      ),
                                      const Spacer(),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              _isActive
                                                  ? Colors.green[50]
                                                  : Colors.red[50],
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          border: Border.all(
                                            color:
                                                _isActive
                                                    ? Colors.green[300]!
                                                    : Colors.red[300]!,
                                          ),
                                        ),
                                        child: Text(
                                          _isActive ? 'Active' : 'Inactive',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color:
                                                _isActive
                                                    ? Colors.green[700]
                                                    : Colors.red[700],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Switch(
                                        value: _isActive,
                                        onChanged:
                                            (value) => setState(
                                              () => _isActive = value,
                                            ),
                                        activeColor: const Color(0xFF4285F4),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // Emergency Contact
                            _buildSectionCard(
                              'Emergency Contact',
                              Icons.emergency,
                              [
                                _buildTextFormField(
                                  controller: _emergencyNameController,
                                  label: 'Contact Name',
                                  icon: Icons.person,
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildTextFormField(
                                        controller:
                                            _emergencyRelationshipController,
                                        label: 'Relationship',
                                        icon: Icons.family_restroom,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _buildTextFormField(
                                        controller: _emergencyPhoneController,
                                        label: 'Phone',
                                        icon: Icons.phone,
                                        keyboardType: TextInputType.phone,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                _buildTextFormField(
                                  controller: _emergencyEmailController,
                                  label: 'Email',
                                  icon: Icons.email,
                                  keyboardType: TextInputType.emailAddress,
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // Notes
                            _buildSectionCard('Additional Notes', Icons.note, [
                              _buildTextFormField(
                                controller: _notesController,
                                label: 'Notes',
                                icon: Icons.description,
                                maxLines: 4,
                              ),
                            ]),

                            const SizedBox(height: 32),

                            // Submit Button
                            Container(
                              margin: const EdgeInsets.only(bottom: 24),
                              width: double.infinity,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF4285F4,
                                    ).withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
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
                                child:
                                    _isLoading
                                        ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.white,
                                                ),
                                          ),
                                        )
                                        : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              widget.staff == null
                                                  ? Icons.person_add
                                                  : Icons.save,
                                              size: 20,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              widget.staff == null
                                                  ? 'Create Staff Member'
                                                  : 'Update Staff Member',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
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

  Widget _buildSectionCard(String title, IconData icon, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
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
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF4285F4).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: const Color(0xFF4285F4), size: 20),
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
            ),
            const SizedBox(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }

  String _getDepartmentNameById(String? id) {
    if (id == null) return '';
    try {
      final dept = _departments.firstWhere(
        (d) => (d['_id'] ?? d['id']).toString() == id,
        orElse: () => null,
      );
      if (dept == null) return '';
      return (dept['name'] ?? '').toString();
    } catch (_) {
      return '';
    }
  }

  Future<String?> _showDepartmentPickerDialog() async {
    if (_departments.isEmpty) return null;

    return showDialog<String>(
      context: context,
      builder: (dialogContext) {
        String query = '';
        return StatefulBuilder(
          builder: (context, setState) {
            final lowerQuery = query.toLowerCase();
            final filtered =
                _departments.where((dept) {
                  final name = (dept['name'] ?? '').toString().toLowerCase();
                  final code = (dept['code'] ?? '').toString().toLowerCase();
                  return name.contains(lowerQuery) || code.contains(lowerQuery);
                }).toList();

            return AlertDialog(
              title: const Text('Select Department'),
              content: SizedBox(
                width: 500,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        hintText: 'Search by name or code',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        setState(() {
                          query = value;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child:
                          filtered.isEmpty
                              ? const Center(
                                child: Text(
                                  'No departments match your search',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              )
                              : ListView.builder(
                                itemCount: filtered.length,
                                itemBuilder: (context, index) {
                                  final dept = filtered[index];
                                  final name =
                                      (dept['name'] ?? 'N/A').toString();
                                  final code = (dept['code'] ?? '').toString();
                                  final id =
                                      (dept['_id'] ?? dept['id']).toString();
                                  final isSelected =
                                      id == _selectedDepartmentId;
                                  return ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: const Color(
                                        0xFF4285F4,
                                      ).withOpacity(0.1),
                                      child: const Icon(
                                        Icons.business,
                                        color: Color(0xFF4285F4),
                                        size: 18,
                                      ),
                                    ),
                                    title: Text(name),
                                    subtitle:
                                        code.isNotEmpty
                                            ? Text(
                                              code,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF666666),
                                              ),
                                            )
                                            : null,
                                    trailing:
                                        isSelected
                                            ? const Icon(
                                              Icons.check_circle,
                                              color: Color(0xFF4285F4),
                                            )
                                            : null,
                                    onTap: () {
                                      Navigator.of(dialogContext).pop(id);
                                    },
                                  );
                                },
                              ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildSearchableDepartmentField() {
    return FormField<String>(
      initialValue: _selectedDepartmentId,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a department';
        }
        return null;
      },
      builder: (field) {
        final selectedName = _getDepartmentNameById(field.value);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () async {
                final selectedId = await _showDepartmentPickerDialog();
                if (selectedId != null) {
                  setState(() {
                    _selectedDepartmentId = selectedId;
                  });
                  field.didChange(selectedId);
                }
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Department *',
                  prefixIcon: const Icon(
                    Icons.business,
                    color: Color(0xFF4285F4),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color:
                          field.hasError ? Colors.red : const Color(0xFFE0E0E0),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color:
                          field.hasError ? Colors.red : const Color(0xFF4285F4),
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF8F9FA),
                  errorText: field.errorText,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        selectedName.isNotEmpty
                            ? selectedName
                            : 'Select department',
                        style: TextStyle(
                          color:
                              selectedName.isNotEmpty
                                  ? const Color(0xFF1A1A1A)
                                  : const Color(0xFF999999),
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      color: Color(0xFF666666),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Enter ${label.toLowerCase().replaceAll('*', '').trim()}',
        prefixIcon: Icon(icon, color: const Color(0xFF666666)),
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
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        labelStyle: const TextStyle(color: Color(0xFF666666), fontSize: 14),
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? value,
    required VoidCallback onTap,
    String? Function(DateTime?)? validator,
  }) {
    String? errorText;
    if (validator != null) {
      errorText = validator(value);
    }

    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          hintText: 'Select ${label.toLowerCase().replaceAll('*', '').trim()}',
          prefixIcon: const Icon(
            Icons.calendar_today,
            color: Color(0xFF666666),
          ),
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
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          errorText: errorText,
          labelStyle: const TextStyle(color: Color(0xFF666666), fontSize: 14),
        ),
        child: Text(
          value != null
              ? DateFormat('yyyy-MM-dd').format(value)
              : 'Select date',
          style: TextStyle(
            color:
                value != null
                    ? const Color(0xFF1A1A1A)
                    : const Color(0xFF999999),
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required dynamic value,
    required List<dynamic> items,
    required Function(dynamic) onChanged,
    String? Function(dynamic)? validator,
  }) {
    return DropdownButtonFormField<dynamic>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Select ${label.toLowerCase().replaceAll('*', '').trim()}',
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
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        labelStyle: const TextStyle(color: Color(0xFF666666), fontSize: 14),
      ),
      items:
          items.map((item) {
            if (item is DropdownMenuItem) {
              return item;
            }
            final displayValue =
                item is String
                    ? item
                    : (item is Map
                        ? item['name'] ?? item.toString()
                        : item.toString());
            final itemValue =
                item is Map ? (item['_id'] ?? item['id'] ?? item) : item;
            return DropdownMenuItem(
              value: itemValue,
              child: Text(
                displayValue.toString(),
                style: const TextStyle(color: Color(0xFF1A1A1A), fontSize: 16),
              ),
            );
          }).toList(),
      onChanged: onChanged,
      validator: validator,
      style: const TextStyle(color: Color(0xFF1A1A1A), fontSize: 16),
      icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF666666)),
    );
  }
}

// Qualification Dialog
class _QualificationDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;

  const _QualificationDialog({required this.onSave});

  @override
  State<_QualificationDialog> createState() => _QualificationDialogState();
}

class _QualificationDialogState extends State<_QualificationDialog> {
  final _formKey = GlobalKey<FormState>();
  final _degreeController = TextEditingController();
  final _institutionController = TextEditingController();
  final _yearController = TextEditingController();
  final _certificateController = TextEditingController();

  @override
  void dispose() {
    _degreeController.dispose();
    _institutionController.dispose();
    _yearController.dispose();
    _certificateController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final qualification = <String, dynamic>{
        'degree': _degreeController.text.trim(),
        'institution': _institutionController.text.trim(),
        if (_yearController.text.isNotEmpty)
          'year': int.tryParse(_yearController.text.trim()) ?? 0,
        if (_certificateController.text.isNotEmpty)
          'certificate': _certificateController.text.trim(),
      };
      widget.onSave(qualification);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        width: 500,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                    child: const Icon(
                      Icons.school,
                      color: Color(0xFF4285F4),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Add Qualification',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _degreeController,
                decoration: InputDecoration(
                  labelText: 'Degree *',
                  hintText: 'e.g., Doctor of Medicine (MD)',
                  prefixIcon: const Icon(
                    Icons.school,
                    color: Color(0xFF666666),
                  ),
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
                    borderSide: const BorderSide(
                      color: Color(0xFF4285F4),
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF8F9FA),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _institutionController,
                decoration: InputDecoration(
                  labelText: 'Institution *',
                  hintText: 'e.g., Harvard Medical School',
                  prefixIcon: const Icon(
                    Icons.business,
                    color: Color(0xFF666666),
                  ),
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
                    borderSide: const BorderSide(
                      color: Color(0xFF4285F4),
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF8F9FA),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _yearController,
                decoration: InputDecoration(
                  labelText: 'Year',
                  hintText: 'e.g., 2005',
                  prefixIcon: const Icon(
                    Icons.calendar_today,
                    color: Color(0xFF666666),
                  ),
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
                    borderSide: const BorderSide(
                      color: Color(0xFF4285F4),
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF8F9FA),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _certificateController,
                decoration: InputDecoration(
                  labelText: 'Certificate URL (Optional)',
                  hintText: 'https://example.com/certificate.pdf',
                  prefixIcon: const Icon(Icons.link, color: Color(0xFF666666)),
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
                    borderSide: const BorderSide(
                      color: Color(0xFF4285F4),
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF8F9FA),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4285F4),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, size: 18),
                        SizedBox(width: 4),
                        Text('Add'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
