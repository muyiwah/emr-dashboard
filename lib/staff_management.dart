import 'package:flutter/material.dart';

class AddStaffProfileScreen extends StatefulWidget {
  const AddStaffProfileScreen({Key? key}) : super(key: key);

  @override
  State<AddStaffProfileScreen> createState() => _AddStaffProfileScreenState();
}

class _AddStaffProfileScreenState extends State<AddStaffProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _licenseController = TextEditingController();
  final _specialtyController = TextEditingController();
  final _usernameController = TextEditingController();

  String? _selectedGender;
  String? _selectedRole;
  String? _selectedDepartment;
  DateTime? _dateOfBirth;
  DateTime? _hireDate;
  String _employeeId = 'Auto-generated';
  String _temporaryPassword = 'Auto-generated';
  bool _require2FA = false;
  bool _forcePasswordReset = true;
  String _employmentStatus = 'Active';

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _licenseController.dispose();
    _specialtyController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF4285F4),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.people, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            const Text(
              'Staff Management',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Add Staff Profile',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Create a new staff member profile with complete information',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  TextButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, size: 16),
                    label: const Text('Back to List'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Personal Information Section
              _buildSectionCard(
                icon: Icons.person,
                title: 'Personal Information',
                children: [
                  // Profile Photo
                  Center(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.grey[300],
                              backgroundImage: const AssetImage(
                                'assets/profile_placeholder.png',
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF4285F4),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Click to upload photo',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Name Fields
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextFormField(
                          controller: _firstNameController,
                          label: 'First Name',
                          placeholder: 'Enter first name',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextFormField(
                          controller: _lastNameController,
                          label: 'Last Name',
                          placeholder: 'Enter last name',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Email and Phone
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextFormField(
                          controller: _emailController,
                          label: 'Email Address',
                          placeholder: 'Enter email address',
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextFormField(
                          controller: _phoneController,
                          label: 'Phone Number',
                          placeholder: 'Enter phone number',
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Gender and Date of Birth
                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdownField(
                          label: 'Gender',
                          value: _selectedGender,
                          items: ['Male', 'Female', 'Other'],
                          onChanged:
                              (value) =>
                                  setState(() => _selectedGender = value),
                          placeholder: 'Select gender',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildDateField(
                          label: 'Date of Birth',
                          selectedDate: _dateOfBirth,
                          onTap: () => _selectDate(context, true),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Professional Information Section
              _buildSectionCard(
                icon: Icons.work,
                title: 'Professional Information',
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdownField(
                          label: 'Role',
                          value: _selectedRole,
                          items: [
                            'Doctor',
                            'Nurse',
                            'Administrator',
                            'Technician',
                          ],
                          onChanged:
                              (value) => setState(() => _selectedRole = value),
                          placeholder: 'Select role',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildDropdownField(
                          label: 'Department',
                          value: _selectedDepartment,
                          items: [
                            'Emergency',
                            'Cardiology',
                            'Pediatrics',
                            'Surgery',
                          ],
                          onChanged:
                              (value) =>
                                  setState(() => _selectedDepartment = value),
                          placeholder: 'Select department',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _buildTextFormField(
                          controller: _licenseController,
                          label: 'License Number',
                          placeholder: 'Enter license number',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextFormField(
                          controller: _specialtyController,
                          label: 'Specialty',
                          placeholder: 'Enter specialty',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _buildDateField(
                          label: 'Hire Date',
                          selectedDate: _hireDate,
                          onTap: () => _selectDate(context, false),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildAutoGeneratedField(
                          label: 'Employee ID',
                          value: _employeeId,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Login Credentials Section
              _buildSectionCard(
                icon: Icons.key,
                title: 'Login Credentials',
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextFormField(
                          controller: _usernameController,
                          label: 'Username',
                          placeholder: 'Enter username',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildAutoGeneratedField(
                          label: 'Temporary Password',
                          value: _temporaryPassword,
                          showVisibilityIcon: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 2FA Toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Two-Factor Authentication',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Require 2FA for enhanced security',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      Switch(
                        value: _require2FA,
                        onChanged:
                            (value) => setState(() => _require2FA = value),
                        activeColor: const Color(0xFF4285F4),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Force Password Reset Toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Force Password Reset',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'User must change password on first login',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      Switch(
                        value: _forcePasswordReset,
                        onChanged:
                            (value) =>
                                setState(() => _forcePasswordReset = value),
                        activeColor: const Color(0xFF4285F4),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Employment Status Section
              _buildSectionCard(
                icon: Icons.person_outline,
                title: 'Employment Status',
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatusCard(
                          title: 'Active',
                          subtitle: 'Currently employed',
                          color: Colors.green,
                          icon: Icons.check_circle,
                          isSelected: _employmentStatus == 'Active',
                          onTap:
                              () =>
                                  setState(() => _employmentStatus = 'Active'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatusCard(
                          title: 'On Leave',
                          subtitle: 'Temporarily away',
                          color: Colors.orange,
                          icon: Icons.schedule,
                          isSelected: _employmentStatus == 'On Leave',
                          onTap:
                              () => setState(
                                () => _employmentStatus = 'On Leave',
                              ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatusCard(
                          title: 'Terminated',
                          subtitle: 'No longer employed',
                          color: Colors.red,
                          icon: Icons.cancel,
                          isSelected: _employmentStatus == 'Terminated',
                          onTap:
                              () => setState(
                                () => _employmentStatus = 'Terminated',
                              ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Action Buttons
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
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: _saveProfile,
                    icon: const Icon(Icons.save, size: 18),
                    label: const Text('Save Profile'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4285F4),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
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
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String placeholder,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(color: Colors.grey[400]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF4285F4)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required String placeholder,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(color: Colors.grey[400]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF4285F4)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          items:
              items.map((String item) {
                return DropdownMenuItem<String>(value: item, child: Text(item));
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? selectedDate,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedDate != null
                      ? '${selectedDate!.month.toString().padLeft(2, '0')}/${selectedDate!.day.toString().padLeft(2, '0')}/${selectedDate!.year}'
                      : 'mm/dd/yyyy',
                  style: TextStyle(
                    color:
                        selectedDate != null ? Colors.black : Colors.grey[400],
                  ),
                ),
                Icon(Icons.calendar_today, color: Colors.grey[400], size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAutoGeneratedField({
    required String label,
    required String value,
    bool showVisibilityIcon = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(value, style: TextStyle(color: Colors.grey[600])),
              if (showVisibilityIcon)
                Icon(Icons.visibility_off, color: Colors.grey[400], size: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusCard({
    required String title,
    required String subtitle,
    required Color color,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.grey[50],
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? color : Colors.grey[400], size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? color : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? color : Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isDateOfBirth) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: isDateOfBirth ? DateTime(1900) : DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        if (isDateOfBirth) {
          _dateOfBirth = picked;
        } else {
          _hireDate = picked;
        }
      });
    }
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // Handle save logic here
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Staff profile saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }
}
