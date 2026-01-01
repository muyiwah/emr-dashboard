import 'package:flutter/material.dart';

class AddFacilityScreen extends StatefulWidget {
  const AddFacilityScreen({Key? key}) : super(key: key);

  @override
  State<AddFacilityScreen> createState() => _AddFacilityScreenState();
}

class _AddFacilityScreenState extends State<AddFacilityScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _facilityNameController = TextEditingController();
  final _facilityCodeController = TextEditingController();
  final _contactNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _streetAddressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _coordinatesController = TextEditingController();
  final _adminSearchController = TextEditingController();

  // Dropdown values
  String? _selectedFacilityType;
  String? _selectedCountry;

  // Toggle switches
  bool _enableIPD = false;
  bool _enableBilling = true;
  bool _enableImaging = false;
  bool _enablePharmacy = true;

  // Checkboxes for specialties
  bool _cardiologyChecked = true;
  bool _neurologyChecked = true;
  bool _orthopedicsChecked = false;

  // Selected admin
  bool _hasSelectedAdmin = true;

  final List<String> _facilityTypes = [
    'Hospital',
    'Clinic',
    'Laboratory',
    'Pharmacy',
    'Diagnostic Center',
  ];

  final List<String> _countries = [
    'United States',
    'Canada',
    'United Kingdom',
    'Australia',
    'Germany',
    'France',
  ];

  @override
  void dispose() {
    _facilityNameController.dispose();
    _facilityCodeController.dispose();
    _contactNumberController.dispose();
    _emailController.dispose();
    _streetAddressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _coordinatesController.dispose();
    _adminSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.grey),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            TextButton(
              onPressed: () {},
              child: const Text(
                'Dashboard',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey, size: 16),
            TextButton(
              onPressed: () {},
              child: const Text(
                'Facilities',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey, size: 16),
            const Text('Add Facility', style: TextStyle(color: Colors.black)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: _saveFacility,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: const Text('Save Facility'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Facility Information',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                'Configure facility details and settings',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 32),

              _buildGeneralInformationSection(),
              const SizedBox(height: 32),

              _buildLocationDetailsSection(),
              const SizedBox(height: 32),

              _buildAdminAssignmentSection(),
              const SizedBox(height: 32),

              _buildFacilitySettingsSection(),
              const SizedBox(height: 32),

              _buildLinkedDepartmentsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGeneralInformationSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(
                  Icons.info_outline,
                  color: Colors.blue,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'General Information',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  'Facility Name',
                  _facilityNameController,
                  'Enter facility name',
                  isRequired: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  'Facility Code',
                  _facilityCodeController,
                  'e.g. FAC001',
                  isRequired: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildDropdown(
                  'Facility Type',
                  _selectedFacilityType,
                  _facilityTypes,
                  'Select facility type',
                  (value) => setState(() => _selectedFacilityType = value),
                  isRequired: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  'Contact Number',
                  _contactNumberController,
                  '+1 (555) 000-0000',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  'Email Address',
                  _emailController,
                  'facility@example.com',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Facility Logo',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 48,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Icon(
                              Icons.image,
                              size: 16,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 12),
                          TextButton(
                            onPressed: () {},
                            child: const Text('Upload Logo'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'PNG, JPG up to 2MB',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
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

  Widget _buildLocationDetailsSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(
                  Icons.location_on_outlined,
                  color: Colors.blue,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Location Details',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 24),

          _buildTextField(
            'Street Address',
            _streetAddressController,
            'Enter complete address',
            isRequired: true,
            maxLines: 3,
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  'City',
                  _cityController,
                  'Enter city',
                  isRequired: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  'State/Province',
                  _stateController,
                  'Enter state',
                  isRequired: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildDropdown(
                  'Country',
                  _selectedCountry,
                  _countries,
                  'Select country',
                  (value) => setState(() => _selectedCountry = value),
                  isRequired: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  'Coordinates',
                  _coordinatesController,
                  'Lat, Long (optional)',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Location Map',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.map_outlined,
                      size: 48,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Map will appear here',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    TextButton(onPressed: () {}, child: const Text('Load Map')),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdminAssignmentSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(
                  Icons.person_outline,
                  color: Colors.blue,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Admin Assignment',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 24),

          const Text(
            'Assign Facility Managers',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),

          TextFormField(
            controller: _adminSearchController,
            decoration: InputDecoration(
              hintText: 'Search and select administrators...',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
            ),
          ),

          if (_hasSelectedAdmin) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.blue[100],
                    child: const Text('JS', style: TextStyle(fontSize: 12)),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dr. John Smith',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          'Branch Super Admin',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(() => _hasSelectedAdmin = false),
                    icon: const Icon(Icons.close, size: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFacilitySettingsSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(
                  Icons.settings_outlined,
                  color: Colors.blue,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Facility Settings',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: _buildToggleSetting(
                  'Enable IPD',
                  'In-Patient Department services',
                  _enableIPD,
                  (value) => setState(() => _enableIPD = value),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _buildToggleSetting(
                  'Enable Billing',
                  'Billing and invoicing module',
                  _enableBilling,
                  (value) => setState(() => _enableBilling = value),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildToggleSetting(
                  'Enable Imaging',
                  'Radiology and imaging services',
                  _enableImaging,
                  (value) => setState(() => _enableImaging = value),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _buildToggleSetting(
                  'Enable Pharmacy',
                  'Pharmacy and medication management',
                  _enablePharmacy,
                  (value) => setState(() => _enablePharmacy = value),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLinkedDepartmentsSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(
                  Icons.apartment_outlined,
                  color: Colors.blue,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Linked Departments & Services',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 24),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.medical_services_outlined,
                          size: 16,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Specialties',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildCheckboxItem(
                      'Cardiology',
                      _cardiologyChecked,
                      (value) => setState(() => _cardiologyChecked = value!),
                    ),
                    _buildCheckboxItem(
                      'Neurology',
                      _neurologyChecked,
                      (value) => setState(() => _neurologyChecked = value!),
                    ),
                    _buildCheckboxItem(
                      'Orthopedics',
                      _orthopedicsChecked,
                      (value) => setState(() => _orthopedicsChecked = value!),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {},
                      child: const Text('+ Add more'),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.group_outlined,
                          size: 16,
                          color: Colors.orange,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Staff Assignment',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildStaffItem('Doctors', '12 linked'),
                    _buildStaffItem('Nurses', '8 linked'),
                    _buildStaffItem('Technicians', '5 linked'),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Manage staff'),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.inventory_outlined,
                          size: 16,
                          color: Colors.red,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Inventory Access',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildCheckboxItem('...', true, (value) {}),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    String hint, {
    bool isRequired = false,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            if (isRequired)
              const Text(' *', style: TextStyle(color: Colors.red)),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
          validator:
              isRequired
                  ? (value) =>
                      value?.isEmpty == true ? 'This field is required' : null
                  : null,
        ),
      ],
    );
  }

  Widget _buildDropdown(
    String label,
    String? value,
    List<String> items,
    String hint,
    ValueChanged<String?> onChanged, {
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            if (isRequired)
              const Text(' *', style: TextStyle(color: Colors.red)),
          ],
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          hint: Text(hint, style: const TextStyle(color: Colors.grey)),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
          items:
              items
                  .map(
                    (item) => DropdownMenuItem(value: item, child: Text(item)),
                  )
                  .toList(),
          onChanged: onChanged,
          validator:
              isRequired
                  ? (value) => value == null ? 'This field is required' : null
                  : null,
        ),
      ],
    );
  }

  Widget _buildToggleSetting(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        Switch(value: value, onChanged: onChanged, activeColor: Colors.blue),
      ],
    );
  }

  Widget _buildCheckboxItem(
    String label,
    bool value,
    ValueChanged<bool?> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.blue,
          ),
          Text(label),
        ],
      ),
    );
  }

  Widget _buildStaffItem(String role, String count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(role),
          Text(count, style: const TextStyle(color: Colors.blue, fontSize: 12)),
        ],
      ),
    );
  }

  void _saveFacility() {
    if (_formKey.currentState?.validate() == true) {
      // Handle save facility logic
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Facility saved successfully!')),
      );
    }
  }
}
