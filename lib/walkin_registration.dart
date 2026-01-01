import 'package:flutter/material.dart';

class WalkInRegistrationScreen extends StatefulWidget {
  const WalkInRegistrationScreen({Key? key}) : super(key: key);

  @override
  State<WalkInRegistrationScreen> createState() =>
      _WalkInRegistrationScreenState();
}

class _WalkInRegistrationScreenState extends State<WalkInRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneController = TextEditingController();
  final _reasonController = TextEditingController();

  String? _selectedGender;
  String? _selectedDoctor;
  bool _showMedicalHistory = false;
  String _queueManagement = 'automatic';
  bool _printToken = false;

  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _doctors = [
    'Dr. Smith - Cardiology',
    'Dr. Johnson - Internal Medicine',
    'Dr. Williams - Pediatrics',
    'Dr. Brown - Dermatology',
    'Dr. Davis - Orthopedics',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.cyan[400],
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                Icons.person_add,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Walk-in Registration',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black54),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
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
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Patient Information'),
                    const SizedBox(height: 20),

                    // Full Name Field
                    _buildRequiredLabel('Full Name'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _nameController,
                      hintText: 'Enter patient name',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter patient name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Age and Gender Row
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildRequiredLabel('Age'),
                              const SizedBox(height: 8),
                              _buildTextField(
                                controller: _ageController,
                                hintText: 'Age',
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Required';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildRequiredLabel('Gender'),
                              const SizedBox(height: 8),
                              _buildDropdown(
                                value: _selectedGender,
                                items: _genders,
                                hint: 'Select',
                                onChanged: (value) {
                                  setState(() {
                                    _selectedGender = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Phone Number Field
                    _buildRequiredLabel('Phone Number'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _phoneController,
                      hintText: '+1 (555) 123-4567',
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Reason for Visit Field
                    _buildRequiredLabel('Reason for Visit'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _reasonController,
                      hintText:
                          'Brief description of symptoms or reason for visit',
                      maxLines: 4,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter reason for visit';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Medical History Section
                    _buildExpandableSection(
                      'Medical History (Optional)',
                      _showMedicalHistory,
                      () {
                        setState(() {
                          _showMedicalHistory = !_showMedicalHistory;
                        });
                      },
                    ),
                    const SizedBox(height: 24),

                    // Doctor Assignment Section
                    _buildSectionTitle('Doctor Assignment'),
                    const SizedBox(height: 16),
                    _buildRequiredLabel('Assign to Doctor'),
                    const SizedBox(height: 8),
                    _buildDropdown(
                      value: _selectedDoctor,
                      items: _doctors,
                      hint: 'Select Available Doctor',
                      onChanged: (value) {
                        setState(() {
                          _selectedDoctor = value;
                        });
                      },
                    ),
                    const SizedBox(height: 24),

                    // Queue Management Section
                    _buildSectionTitle('Queue Management'),
                    const SizedBox(height: 16),
                    _buildRadioOption(
                      'Add to queue automatically',
                      'automatic',
                      _queueManagement,
                      (value) {
                        setState(() {
                          _queueManagement = value!;
                        });
                      },
                    ),
                    _buildRadioOption(
                      'Add to queue manually',
                      'manual',
                      _queueManagement,
                      (value) {
                        setState(() {
                          _queueManagement = value!;
                        });
                      },
                    ),
                    _buildCheckboxOption('Print queue token', _printToken, (
                      value,
                    ) {
                      setState(() {
                        _printToken = value!;
                      });
                    }),
                    const SizedBox(height: 32),

                    // Action Buttons
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _handleRegisterPatient,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.cyan[400],
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.person_add, size: 20),
                                const SizedBox(width: 8),
                                const Text(
                                  'Register Patient',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.grey[600],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.close, size: 18),
                              const SizedBox(width: 4),
                              const Text('Cancel'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildRequiredLabel(String label) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
        children: [
          TextSpan(text: label),
          const TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
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
          borderSide: BorderSide(color: Colors.cyan[400]!),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required String hint,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      hint: Text(hint, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
      items:
          items.map((item) {
            return DropdownMenuItem(value: item, child: Text(item));
          }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
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
          borderSide: BorderSide(color: Colors.cyan[400]!),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }

  Widget _buildExpandableSection(
    String title,
    bool isExpanded,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const Spacer(),
          Text(
            isExpanded ? 'Hide Details' : 'Show Details',
            style: TextStyle(
              fontSize: 14,
              color: Colors.cyan[400],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            color: Colors.cyan[400],
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildRadioOption(
    String title,
    String value,
    String groupValue,
    void Function(String?) onChanged,
  ) {
    return RadioListTile<String>(
      title: Text(
        title,
        style: const TextStyle(fontSize: 14, color: Colors.black87),
      ),
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      activeColor: Colors.cyan[400],
      contentPadding: EdgeInsets.zero,
      dense: true,
    );
  }

  Widget _buildCheckboxOption(
    String title,
    bool value,
    void Function(bool?) onChanged,
  ) {
    return CheckboxListTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 14, color: Colors.black87),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.cyan[400],
      contentPadding: EdgeInsets.zero,
      dense: true,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  void _handleRegisterPatient() {
    if (_formKey.currentState!.validate()) {
      if (_selectedGender == null) {
        _showSnackBar('Please select gender');
        return;
      }
      if (_selectedDoctor == null) {
        _showSnackBar('Please select a doctor');
        return;
      }

      // Handle registration logic here
      _showSnackBar('Patient registered successfully!');

      // Clear form or navigate back
      _clearForm();
    }
  }

  void _clearForm() {
    _nameController.clear();
    _ageController.clear();
    _phoneController.clear();
    _reasonController.clear();
    setState(() {
      _selectedGender = null;
      _selectedDoctor = null;
      _queueManagement = 'automatic';
      _printToken = false;
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.cyan[400]),
    );
  }
}
