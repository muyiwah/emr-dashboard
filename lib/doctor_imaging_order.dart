import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:schmgtsystem/models/patient_model.dart';
import 'package:schmgtsystem/providers/patient_proviider.dart';
import 'package:schmgtsystem/services/api_service.dart';

// Imaging type data structure
class ImagingTypeData {
  final String id;
  final String code;
  final String name;
  final String displayName;
  final IconData icon;
  final Color color;
  final String category;
  final String modality;
  final List<String> commonBodyParts;
  final bool requiresContrast;
  final int? estimatedDuration;

  ImagingTypeData({
    required this.id,
    required this.code,
    required this.name,
    required this.displayName,
    required this.icon,
    required this.color,
    required this.category,
    required this.modality,
    required this.commonBodyParts,
    required this.requiresContrast,
    this.estimatedDuration,
  });

  // Factory method to create from API response
  factory ImagingTypeData.fromApi(Map<String, dynamic> json) {
    return ImagingTypeData(
      id: json['id'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
      displayName: json['display_name'] as String,
      icon: _getIconFromName(json['icon_name'] as String),
      color: _getColorFromHex(json['color_hex'] as String),
      category: json['category'] as String,
      modality: json['modality'] as String,
      commonBodyParts: List<String>.from(json['common_body_parts'] as List),
      requiresContrast: json['requires_contrast'] as bool,
      estimatedDuration: json['estimated_duration'] as int?,
    );
  }

  // Helper method to convert icon name to IconData
  static IconData _getIconFromName(String iconName) {
    const iconMappings = {
      'monitor_heart': Icons.monitor_heart,
      'waves': Icons.waves,
      'psychology': Icons.psychology,
      'accessibility_new': Icons.accessibility_new,
      'favorite': Icons.favorite,
      'personal_injury': Icons.personal_injury,
      'air': Icons.air,
      'directions_run': Icons.directions_run,
    };

    return iconMappings[iconName] ?? Icons.medical_services;
  }

  // Helper method to convert hex color to Color
  static Color _getColorFromHex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }
}

class DoctorImagingOrderScreen extends StatefulWidget {
  const DoctorImagingOrderScreen({super.key});

  @override
  State<DoctorImagingOrderScreen> createState() =>
      _DoctorImagingOrderScreenState();
}

class _DoctorImagingOrderScreenState extends State<DoctorImagingOrderScreen> {
  // Form controllers
  final TextEditingController _clinicalIndicationController =
      TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  // Selected values
  String _selectedPriority = 'Routine'; // Routine, Urgent, STAT
  ImagingTypeData? _selectedImagingType;
  String _selectedBodyPart = '';
  String _selectedLaterality =
      'Not Applicable'; // Left, Right, Bilateral, Not Applicable

  List<String> get _bodyParts {
    if (_selectedImagingType != null) {
      return _selectedImagingType!.commonBodyParts;
    }
    return [];
  }

  // Imaging types loaded from API
  List<ImagingTypeData> _imagingTypes = [];
  bool _isLoadingImagingTypes = false;
  String? _imagingTypesError;

  bool _isSubmitting = false;
  Patient? _patient;

  @override
  void initState() {
    super.initState();
    _loadPatient();
    _loadImagingTypes();
  }

  void _loadPatient() {
    final patientProvider = Provider.of<PatientProvider>(
      context,
      listen: false,
    );
    _patient = patientProvider.currentPatient;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _loadImagingTypes() async {
    setState(() {
      _isLoadingImagingTypes = true;
      _imagingTypesError = null;
    });

    try {
      final response = await ApiService.get('/api/imaging/catalog');

      if (response.success && response.data != null) {
        final responseData = response.data as Map<String, dynamic>;
        final data = responseData['data'] as Map<String, dynamic>?;
        final testsData = data?['tests'] as List<dynamic>?;

        if (testsData != null && mounted) {
          setState(() {
            _imagingTypes =
                testsData.map((test) => ImagingTypeData.fromApi(test)).toList();
            _isLoadingImagingTypes = false;
          });
        } else {
          setState(() {
            _isLoadingImagingTypes = false;
            _imagingTypesError = 'No imaging data found in response';
          });
        }
      } else {
        setState(() {
          _isLoadingImagingTypes = false;
          _imagingTypesError = response.error ?? 'Failed to load imaging types';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingImagingTypes = false;
          _imagingTypesError = 'Error loading imaging types: ${e.toString()}';
        });
      }
    }
  }

  @override
  void dispose() {
    _clinicalIndicationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Widget _buildPriorityChip(String priority, Color color) {
    final isSelected = _selectedPriority == priority;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedPriority = priority;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.1) : Colors.grey[50],
            border: Border.all(color: isSelected ? color : Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            priority,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isSelected ? color : const Color(0xFF6B7280),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitOrder() async {
    if (_selectedImagingType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an imaging type')),
      );
      return;
    }

    // Get patient from provider at submission time
    final patientProvider = Provider.of<PatientProvider>(
      context,
      listen: false,
    );
    final currentPatient = patientProvider.currentPatient ?? _patient;

    if (currentPatient == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Patient information not available. Please select a patient first.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Map priority to uppercase format expected by backend
      String priorityValue;
      switch (_selectedPriority.toLowerCase()) {
        case 'routine':
          priorityValue = 'ROUTINE';
          break;
        case 'urgent':
          priorityValue = 'URGENT';
          break;
        case 'stat':
          priorityValue = 'STAT';
          break;
        default:
          priorityValue = 'ROUTINE';
      }

      // Map laterality
      String? lateralityValue;
      if (_selectedLaterality != 'Not Applicable') {
        lateralityValue = _selectedLaterality.toUpperCase();
      }

      // Build request payload
      final requestData = {
        'patient_id': currentPatient.id,
        'imaging_type': _selectedImagingType!.name,
        'priority': priorityValue,
        'body_part': _selectedBodyPart.isNotEmpty ? _selectedBodyPart : null,
        'laterality': lateralityValue,
        if (_clinicalIndicationController.text.isNotEmpty)
          'clinical_indication': _clinicalIndicationController.text.trim(),
        if (_notesController.text.isNotEmpty)
          'notes': _notesController.text.trim(),
      };

      // Submit via API endpoint
      final response = await ApiService.post(
        '/api/v1/imaging-orders',
        requestData,
      );

      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });

        if (response.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Imaging order submitted successfully'),
              backgroundColor: Colors.green,
            ),
          );

          // Navigate back after a short delay
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              context.pop();
            }
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Failed to submit order: ${response.error ?? "Unknown error"}',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildPatientInfoCard() {
    final currentPatient =
        Provider.of<PatientProvider>(context, listen: false).currentPatient ??
        _patient;

    if (currentPatient == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6366F1).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              currentPatient.name.isNotEmpty
                  ? currentPatient.name[0].toUpperCase()
                  : '?',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentPatient.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'ID: ${currentPatient.id} • Age: ${currentPatient.age ?? 'N/A'}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.check_circle,
              color: Color(0xFF10B981),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Color(0xFF64748B),
              size: 20,
            ),
            onPressed: () => context.pop(),
          ),
        ),
        title: const Text(
          'Order Imaging',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(Icons.medical_services, color: Colors.white, size: 16),
                SizedBox(width: 4),
                Text(
                  'Order',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.grey[100]!,
                  Colors.transparent,
                ],
              ),
            ),
            height: 1,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patient Info Card
            Consumer<PatientProvider>(
              builder: (context, patientProvider, child) {
                final currentPatient =
                    patientProvider.currentPatient ?? _patient;
                if (currentPatient != null) {
                  return _buildPatientInfoCard();
                }
                return Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning, color: Colors.orange[700]),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'No patient selected. Please select a patient first.',
                          style: const TextStyle(color: Color(0xFFE65100)),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            // Imaging Type Selection Section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
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
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.medical_services,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Imaging Order Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child:
                        _isLoadingImagingTypes
                            ? Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text('Loading imaging types...'),
                                ],
                              ),
                            )
                            : _imagingTypesError != null
                            ? Container(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _imagingTypesError!,
                                    style: const TextStyle(color: Colors.red),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 8),
                                  TextButton(
                                    onPressed: _loadImagingTypes,
                                    child: const Text('Retry'),
                                  ),
                                ],
                              ),
                            )
                            : DropdownButtonFormField<ImagingTypeData>(
                              value: _selectedImagingType,
                              decoration: InputDecoration(
                                labelText: 'Select Imaging Type',
                                labelStyle: const TextStyle(
                                  color: Color(0xFF64748B),
                                  fontWeight: FontWeight.w500,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                suffixIcon: Icon(
                                  Icons.keyboard_arrow_down,
                                  color:
                                      _selectedImagingType != null
                                          ? _selectedImagingType!.color
                                          : const Color(0xFF64748B),
                                ),
                              ),
                              style: const TextStyle(
                                color: Color(0xFF1E293B),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              dropdownColor: Colors.white,
                              items:
                                  _imagingTypes.map((imagingType) {
                                    return DropdownMenuItem<ImagingTypeData>(
                                      value: imagingType,
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: imagingType.color
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Icon(
                                              imagingType.icon,
                                              color: imagingType.color,
                                              size: 20,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            imagingType.displayName,
                                            style: TextStyle(
                                              color: imagingType.color,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                              onChanged: (ImagingTypeData? value) {
                                setState(() {
                                  _selectedImagingType = value;
                                  // Auto-select first body part
                                  if (value != null &&
                                      value.commonBodyParts.isNotEmpty) {
                                    _selectedBodyPart =
                                        value.commonBodyParts.first;
                                  }
                                });
                              },
                            ),
                  ),
                ],
              ),
            ),

            // Additional Details Section
            if (_selectedImagingType != null) ...[
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
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
                            color: _selectedImagingType!.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            _selectedImagingType!.icon,
                            color: _selectedImagingType!.color,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Imaging Details',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: _selectedImagingType!.color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Body Part Selection
                    const Text(
                      'Body Part',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value:
                              _selectedBodyPart.isNotEmpty
                                  ? _selectedBodyPart
                                  : null,
                          hint: const Text('Select body part'),
                          isExpanded: true,
                          items:
                              _bodyParts.map((part) {
                                return DropdownMenuItem(
                                  value: part,
                                  child: Text(part),
                                );
                              }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedBodyPart = value ?? '';
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Laterality Selection
                    const Text(
                      'Laterality',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children:
                          ['Not Applicable', 'Left', 'Right', 'Bilateral'].map((
                            laterality,
                          ) {
                            final isSelected =
                                _selectedLaterality == laterality;
                            return Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedLaterality = laterality;
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        isSelected
                                            ? _selectedImagingType!.color
                                                .withOpacity(0.1)
                                            : Colors.grey[50],
                                    border: Border.all(
                                      color:
                                          isSelected
                                              ? _selectedImagingType!.color
                                              : Colors.grey[300]!,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    laterality,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          isSelected
                                              ? _selectedImagingType!.color
                                              : const Color(0xFF6B7280),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                    const SizedBox(height: 16),

                    // Priority Selection
                    const Text(
                      'Priority',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildPriorityChip('Routine', const Color(0xFF10B981)),
                        const SizedBox(width: 8),
                        _buildPriorityChip('Urgent', const Color(0xFFF59E0B)),
                        const SizedBox(width: 8),
                        _buildPriorityChip('STAT', const Color(0xFFEF4444)),
                      ],
                    ),
                  ],
                ),
              ),
            ],

            // Clinical Information Section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
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
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.description,
                          color: Color(0xFF64748B),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Clinical Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: TextFormField(
                      controller: _clinicalIndicationController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Clinical Indication',
                        hintText:
                            'Reason for imaging (e.g., chest pain, follow-up)',
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(16),
                        labelStyle: const TextStyle(
                          color: Color(0xFF64748B),
                          fontWeight: FontWeight.w500,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                      ),
                      style: const TextStyle(
                        color: Color(0xFF1E293B),
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: TextFormField(
                      controller: _notesController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: 'Additional Notes',
                        hintText: 'Any special instructions or notes',
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(16),
                        labelStyle: const TextStyle(
                          color: Color(0xFF64748B),
                          fontWeight: FontWeight.w500,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                      ),
                      style: const TextStyle(
                        color: Color(0xFF1E293B),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Submit Button
            Container(
              margin: const EdgeInsets.all(16),
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6366F1).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child:
                    _isSubmitting
                        ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                        : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Submit Imaging Order',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ],
                        ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
