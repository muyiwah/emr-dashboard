import 'package:flutter/material.dart';
import 'package:flutter/services.dart';



class RadiologyHomePage extends StatefulWidget {
  const RadiologyHomePage({Key? key}) : super(key: key);

  @override
  State<RadiologyHomePage> createState() => _RadiologyHomePageState();
}

class _RadiologyHomePageState extends State<RadiologyHomePage> {
  int _selectedTabIndex = 0;
  String _selectedPriority = 'Routine';
  String _selectedTest = 'Select imaging test...';
  final TextEditingController _patientController = TextEditingController();
  final TextEditingController _bodyPartController = TextEditingController();
  final TextEditingController _diagnosisController = TextEditingController();
  final TextEditingController _clinicalNotesController =
      TextEditingController();
  bool _showImageViewer = false;

  final List<String> _tabs = [
    'Request Imaging',
    'Pending Requests',
    'Schedule',
    'Upload Images',
    'Patient History',
  ];

  final List<Map<String, dynamic>> _pendingRequests = [
    {
      'patient': 'Sarah Johnson',
      'id': 'P001234',
      'testType': 'Chest X-Ray',
      'doctor': 'Dr. Michael Chen',
      'priority': 'Urgent',
      'date': '2024-01-15 09:30',
      'status': 'Pending Approval',
      'avatar': '👩‍⚕️',
    },
    {
      'patient': 'Robert Martinez',
      'id': 'P001235',
      'testType': 'Brain MRI',
      'doctor': 'Dr. Lisa Wang',
      'priority': 'STAT',
      'date': '2024-01-15 11:45',
      'status': 'Scheduled',
      'avatar': '👨‍⚕️',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Stack(
        children: [
          Column(
            children: [
              _buildHeader(),
              _buildTabBar(),
              Expanded(child: _buildTabContent()),
            ],
          ),
          if (_showImageViewer) _buildImageViewer(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.medical_services,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'Radiology & Imaging',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add, size: 18),
            label: const Text('New Request'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(width: 16),
          CircleAvatar(
            radius: 20,
            backgroundColor: const Color(0xFFE5E7EB),
            child: const Icon(Icons.person, color: Color(0xFF6B7280), size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children:
            _tabs.asMap().entries.map((entry) {
              int index = entry.key;
              String tab = entry.value;
              bool isSelected = _selectedTabIndex == index;

              return GestureDetector(
                onTap: () => setState(() => _selectedTabIndex = index),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color:
                            isSelected
                                ? const Color(0xFF6366F1)
                                : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                  child: Text(
                    tab,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                      color:
                          isSelected
                              ? const Color(0xFF6366F1)
                              : const Color(0xFF6B7280),
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildRequestImagingTab();
      case 1:
        return _buildPendingRequestsTab();
      case 3:
        return _buildUploadImagesTab();
      default:
        return _buildRequestImagingTab();
    }
  }

  Widget _buildRequestImagingTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'New Imaging Request',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPatientSection(),
                    const SizedBox(height: 24),
                    _buildTestTypeSection(),
                    const SizedBox(height: 24),
                    _buildBodyPartSection(),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPrioritySection(),
                    const SizedBox(height: 24),
                    _buildClinicalIndicationSection(),
                    const SizedBox(height: 24),
                    _buildClinicalNotesSection(),
                    const SizedBox(height: 24),
                    _buildActionButtons(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPatientSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Patient',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: TextField(
            controller: _patientController,
            decoration: const InputDecoration(
              hintText: 'Search patient...',
              hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(12),
              suffixIcon: Icon(Icons.search, color: Color(0xFF6B7280)),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFFE5E7EB),
                child: const Text(
                  'SJ',
                  style: TextStyle(color: Color(0xFF6B7280)),
                ),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sarah Johnson',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  Text(
                    'DOB: 1985-03-15 | ID: P001234',
                    style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                  ),
                  Text(
                    'Last Visit: 2024-01-15',
                    style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTestTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Test Type',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedTest,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: Color(0xFF6B7280),
              ),
              items:
                  [
                    'Select imaging test...',
                    'Chest X-Ray',
                    'Brain MRI',
                    'CT Scan',
                    'Ultrasound',
                    'Mammography',
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                          fontSize: 14,
                          color:
                              value == 'Select imaging test...'
                                  ? const Color(0xFF9CA3AF)
                                  : const Color(0xFF1F2937),
                        ),
                      ),
                    );
                  }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedTest = newValue!;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBodyPartSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Body Part/Region',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: TextField(
            controller: _bodyPartController,
            decoration: const InputDecoration(
              hintText: 'e.g., Chest, Abdomen, Head...',
              hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrioritySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Priority',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children:
              ['STAT', 'Urgent', 'Routine'].map((priority) {
                bool isSelected = _selectedPriority == priority;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedPriority = priority),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color:
                              isSelected
                                  ? const Color(0xFF6366F1)
                                  : const Color(0xFFE5E7EB),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color:
                                    isSelected
                                        ? const Color(0xFF6366F1)
                                        : const Color(0xFFD1D5DB),
                                width: 2,
                              ),
                              color:
                                  isSelected
                                      ? const Color(0xFF6366F1)
                                      : Colors.transparent,
                            ),
                            child:
                                isSelected
                                    ? const Icon(
                                      Icons.circle,
                                      size: 8,
                                      color: Colors.white,
                                    )
                                    : null,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            priority,
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  isSelected
                                      ? const Color(0xFF6366F1)
                                      : const Color(0xFF6B7280),
                              fontWeight:
                                  isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildClinicalIndicationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Clinical Indication (ICD-10)',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: TextField(
            controller: _diagnosisController,
            decoration: const InputDecoration(
              hintText: 'Start typing diagnosis...',
              hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildClinicalNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Clinical Notes',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: TextField(
            controller: _clinicalNotesController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText:
                  'Additional clinical information, symptoms, suspected diagnosis...',
              hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.send, size: 16),
            label: const Text('Submit Request'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF6B7280),
              side: const BorderSide(color: Color(0xFFE5E7EB)),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Save Draft'),
          ),
        ),
      ],
    );
  }

  Widget _buildPendingRequestsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Pending Imaging Requests',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.assignment, size: 16),
                    label: const Text('Bulk Assign'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF06B6D4),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.filter_list, size: 16),
                    label: const Text('Filter'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF6B7280),
                      side: const BorderSide(color: Color(0xFFE5E7EB)),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildRequestsTable(),
        ],
      ),
    );
  }

  Widget _buildRequestsTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFFF9FAFB),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: const Row(
              children: [
                SizedBox(width: 40),
                Expanded(
                  flex: 2,
                  child: Text(
                    'PATIENT',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'TEST TYPE',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'REQUESTING DOCTOR',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'PRIORITY',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'REQUEST DATE',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'STATUS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ),
                SizedBox(width: 80),
              ],
            ),
          ),
          ..._pendingRequests
              .map((request) => _buildRequestRow(request))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildRequestRow(Map<String, dynamic> request) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
      ),
      child: Row(
        children: [
          Checkbox(
            value: false,
            onChanged: (value) {},
            activeColor: const Color(0xFF6366F1),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: const Color(0xFFE5E7EB),
                  child: Text(
                    request['avatar'],
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request['patient'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    Text(
                      request['id'],
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color:
                    request['testType'] == 'Chest X-Ray'
                        ? const Color(0xFFEFF6FF)
                        : const Color(0xFFF3E8FF),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    request['testType'] == 'Chest X-Ray'
                        ? Icons.healing
                        : Icons.psychology,
                    size: 12,
                    color:
                        request['testType'] == 'Chest X-Ray'
                            ? const Color(0xFF2563EB)
                            : const Color(0xFF7C3AED),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    request['testType'],
                    style: TextStyle(
                      fontSize: 12,
                      color:
                          request['testType'] == 'Chest X-Ray'
                              ? const Color(0xFF2563EB)
                              : const Color(0xFF7C3AED),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              request['doctor'],
              style: const TextStyle(fontSize: 14, color: Color(0xFF1F2937)),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color:
                    request['priority'] == 'Urgent'
                        ? const Color(0xFFFEF3C7)
                        : const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                request['priority'],
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color:
                      request['priority'] == 'Urgent'
                          ? const Color(0xFFD97706)
                          : const Color(0xFFDC2626),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            child: Text(
              request['date'],
              style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color:
                    request['status'] == 'Pending Approval'
                        ? const Color(0xFFFEF3C7)
                        : const Color(0xFFD1FAE5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                request['status'],
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color:
                      request['status'] == 'Pending Approval'
                          ? const Color(0xFFD97706)
                          : const Color(0xFF059669),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
            width: 80,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.visibility, size: 16),
                  color: const Color(0xFF6B7280),
                  tooltip: 'View',
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.edit, size: 16),
                  color: const Color(0xFF6B7280),
                  tooltip: 'Edit',
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.close, size: 16),
                  color: const Color(0xFFEF4444),
                  tooltip: 'Cancel',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadImagesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Upload Medical Images',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFFE5E7EB),
                style: BorderStyle.solid,
                width: 2,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.cloud_upload,
                  size: 48,
                  color: Color(0xFF9CA3AF),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Drag and drop files here',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'or click to browse files',
                  style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Supports DICOM, JPEG, PNG formats (Max 100MB per file)',
                  style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Select Files'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFDF7),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.description,
                    color: Color(0xFF059669),
                    size: 16,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'chest_xray_001.dcm',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      Text(
                        '2.4 MB • DICOM',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 100,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: 1.0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF059669),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(
                  Icons.check_circle,
                  color: Color(0xFF059669),
                  size: 20,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          GestureDetector(
            onTap: () => setState(() => _showImageViewer = true),
            child: Container(
              width: double.infinity,
              height: 400,
              decoration: BoxDecoration(
                color: const Color(0xFF000000),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFF000000),
                      child: const Center(
                        child: Icon(
                          Icons.medical_services,
                          color: Color(0xFF6366F1),
                          size: 100,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageViewer() {
    return Container(
      color: Colors.black87,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 20),
            decoration: const BoxDecoration(color: Color(0xFF1F2937)),
            child: Row(
              children: [
                const Text(
                  'Medical Image Viewer',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.search, color: Colors.white),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.zoom_in, color: Colors.white),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.info_outline, color: Colors.white),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF06B6D4),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Annotate',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: () => setState(() => _showImageViewer = false),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Container(
                    color: Colors.black,
                    child: Center(
                      child: Image.network(
                        'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: const Color(0xFF000000),
                            child: const Center(
                              child: Icon(
                                Icons.medical_services,
                                color: Color(0xFF6366F1),
                                size: 200,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 300,
                  color: const Color(0xFF1F2937),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        child: const Text(
                          'Annotation Tools',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      _buildAnnotationTool(
                        'Select',
                        Icons.dew_point,
                        true,
                      ),
                      _buildAnnotationTool('Draw', Icons.brush, false),
                      _buildAnnotationTool(
                        'Circle',
                        Icons.radio_button_unchecked,
                        false,
                      ),
                      _buildAnnotationTool('Arrow', Icons.arrow_forward, false),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Text(
                          'Notes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF374151),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const TextField(
                          maxLines: 4,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Add clinical observations...',
                            hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnnotationTool(String label, IconData icon, bool isSelected) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF374151) : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? const Color(0xFF06B6D4) : const Color(0xFF9CA3AF),
          size: 20,
        ),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: isSelected ? Colors.white : const Color(0xFF9CA3AF),
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
          ),
        ),
        dense: true,
        onTap: () {},
      ),
    );
  }
}

// Custom widget for priority selection
class PrioritySelector extends StatelessWidget {
  final String selectedPriority;
  final Function(String) onPriorityChanged;

  const PrioritySelector({
    Key? key,
    required this.selectedPriority,
    required this.onPriorityChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children:
          ['STAT', 'Urgent', 'Routine'].map((priority) {
            bool isSelected = selectedPriority == priority;
            Color priorityColor = _getPriorityColor(priority);

            return Expanded(
              child: GestureDetector(
                onTap: () => onPriorityChanged(priority),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? priorityColor.withOpacity(0.1)
                            : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color:
                          isSelected ? priorityColor : const Color(0xFFE5E7EB),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              isSelected ? priorityColor : Colors.transparent,
                          border: Border.all(
                            color:
                                isSelected
                                    ? priorityColor
                                    : const Color(0xFFD1D5DB),
                            width: 2,
                          ),
                        ),
                        child:
                            isSelected
                                ? const Icon(
                                  Icons.check,
                                  size: 10,
                                  color: Colors.white,
                                )
                                : null,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        priority,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                          color:
                              isSelected
                                  ? priorityColor
                                  : const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'STAT':
        return const Color(0xFFDC2626);
      case 'Urgent':
        return const Color(0xFFD97706);
      case 'Routine':
        return const Color(0xFF059669);
      default:
        return const Color(0xFF6B7280);
    }
  }
}
