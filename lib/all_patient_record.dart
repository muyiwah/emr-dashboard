import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schmgtsystem/models/patient_model.dart';
import 'package:schmgtsystem/providers/patient_proviider.dart';

class PatientRecordsScreen extends StatefulWidget {
  PatientRecordsScreen({super.key, required this.onPatientSelected});
  final Function(Patient patient) onPatientSelected;
  @override
  State<PatientRecordsScreen> createState() => _PatientRecordsScreenState();
}

class _PatientRecordsScreenState extends State<PatientRecordsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String _ageFilter = 'All ages';
  bool _maleSelected = false;
  bool _femaleSelected = false;
  bool _otherSelected = false;
  bool _cardiologySelected = false;
  bool _pediatricsSelected = false;
  bool _neurologySelected = false;
  bool _orthopedicsSelected = false;
  bool _entSelected = false;
  bool _generalMedicineSelected = false;
  bool _waitingSelected = false;
  bool _inConsultationSelected = false;
  bool _completedSelected = false;
  int _currentPage = 1;
  final int _itemsPerPage = 10;

  @override
  void initState() {
    super.initState();
    // Load patients when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PatientProvider>(context, listen: false).refreshPatients();
    });
  }

  @override
  Widget build(BuildContext context) {
    final patientProvider = Provider.of<PatientProvider>(context);
    List<Patient> filteredPatients = _filterPatients(patientProvider.patients);

    // Pagination logic
    final totalPages = (filteredPatients.length / _itemsPerPage).ceil();
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex =
        startIndex + _itemsPerPage > filteredPatients.length
            ? filteredPatients.length
            : startIndex + _itemsPerPage;
    final paginatedPatients = filteredPatients.sublist(startIndex, endIndex);

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
                  'Patient Records',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  'EMR System',
                  style: TextStyle(fontSize: 16, color: Color(0xFF666666)),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () {},
                ),
                const SizedBox(width: 16),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[300],
                  child: const Icon(Icons.person, color: Colors.grey),
                ),
              ],
            ),
          ),

          // Search + Top Filters
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by Patient Name or MRN',
                    prefixIcon: const Icon(
                      Icons.search,
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
                      borderSide: const BorderSide(color: Color(0xFF4285F4)),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF8F9FA),
                    suffixIcon:
                        _searchController.text.isNotEmpty
                            ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {});
                              },
                            )
                            : null,
                  ),
                  onChanged: (value) => setState(() {}),
                ),
                const SizedBox(height: 16),

                // Filters header row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Filters',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _resetFilters,
                      icon: const Icon(Icons.refresh, size: 16),
                      label: const Text(
                        'Clear all',
                        style: TextStyle(
                          color: Color(0xFF4285F4),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Compact top filter chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // Gender chips
                      _buildToggleChip(
                        label: 'Male',
                        selected: _maleSelected,
                        onSelected: (value) {
                          setState(() {
                            _maleSelected = value;
                          });
                        },
                      ),
                      _buildToggleChip(
                        label: 'Female',
                        selected: _femaleSelected,
                        onSelected: (value) {
                          setState(() {
                            _femaleSelected = value;
                          });
                        },
                      ),
                      _buildToggleChip(
                        label: 'Other',
                        selected: _otherSelected,
                        onSelected: (value) {
                          setState(() {
                            _otherSelected = value;
                          });
                        },
                      ),
                      const SizedBox(width: 12),

                      // Department chips
                      _buildToggleChip(
                        label: 'Cardiology',
                        selected: _cardiologySelected,
                        onSelected: (value) {
                          setState(() {
                            _cardiologySelected = value;
                          });
                        },
                      ),
                      _buildToggleChip(
                        label: 'Pediatrics',
                        selected: _pediatricsSelected,
                        onSelected: (value) {
                          setState(() {
                            _pediatricsSelected = value;
                          });
                        },
                      ),
                      _buildToggleChip(
                        label: 'Neurology',
                        selected: _neurologySelected,
                        onSelected: (value) {
                          setState(() {
                            _neurologySelected = value;
                          });
                        },
                      ),
                      _buildToggleChip(
                        label: 'Orthopedics',
                        selected: _orthopedicsSelected,
                        onSelected: (value) {
                          setState(() {
                            _orthopedicsSelected = value;
                          });
                        },
                      ),
                      _buildToggleChip(
                        label: 'ENT',
                        selected: _entSelected,
                        onSelected: (value) {
                          setState(() {
                            _entSelected = value;
                          });
                        },
                      ),
                      _buildToggleChip(
                        label: 'General Medicine',
                        selected: _generalMedicineSelected,
                        onSelected: (value) {
                          setState(() {
                            _generalMedicineSelected = value;
                          });
                        },
                      ),
                      const SizedBox(width: 12),

                      // Status chips
                      _buildToggleChip(
                        label: 'Waiting',
                        selected: _waitingSelected,
                        onSelected: (value) {
                          setState(() {
                            _waitingSelected = value;
                          });
                        },
                      ),
                      _buildToggleChip(
                        label: 'In Consultation',
                        selected: _inConsultationSelected,
                        onSelected: (value) {
                          setState(() {
                            _inConsultationSelected = value;
                          });
                        },
                      ),
                      _buildToggleChip(
                        label: 'Completed',
                        selected: _completedSelected,
                        onSelected: (value) {
                          setState(() {
                            _completedSelected = value;
                          });
                        },
                      ),
                      const SizedBox(width: 12),

                      // Registration date pill
                      _buildDateChip(context),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Age dropdown
                Row(
                  children: [
                    const Text(
                      'Age',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF555555),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE0E0E0)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _ageFilter,
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            size: 18,
                            color: Color(0xFF555555),
                          ),
                          items:
                              const [
                                'All ages',
                                '0-17',
                                '18-40',
                                '41-65',
                                '65+',
                              ].map((label) {
                                return DropdownMenuItem<String>(
                                  value: label,
                                  child: Text(
                                    label,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF555555),
                                    ),
                                  ),
                                );
                              }).toList(),
                          onChanged: (value) {
                            if (value == null) return;
                            setState(() {
                              _ageFilter = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Active filter tags summary
                _buildActiveFilterTags(),
              ],
            ),
          ),

          // Patient List
          Expanded(
            child: Container(
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
                  // Patient List Header
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Patient List',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        Text(
                          '${filteredPatients.length} patients found',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Table Header
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FA),
                      border: Border(
                        top: BorderSide(color: Colors.grey[200]!),
                        bottom: BorderSide(color: Colors.grey[200]!),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            'PATIENT',
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
                            'MRN',
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
                            'AGE/GENDER',
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
                            'DEPARTMENT',
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
                            'REGISTRATION TIME',
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

                  // Patient Rows
                  Expanded(
                    child: ListView.builder(
                      itemCount: paginatedPatients.length,
                      itemBuilder: (context, index) {
                        final patient = paginatedPatients[index];
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey[200]!),
                            ),
                          ),
                          child: Row(
                            children: [
                              // Patient
                              Expanded(
                                flex: 3,
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundColor: _getAvatarColor(index),
                                      child: Text(
                                        patient.name.substring(0, 1),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      patient.name,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF1A1A1A),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // MRN
                              Expanded(
                                flex: 2,
                                child: Text(
                                  patient.mrn,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF666666),
                                  ),
                                ),
                              ),

                              // Age/Gender
                              Expanded(
                                flex: 2,
                                child: Text(
                                  '${patient.age} / ${patient.gender}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF666666),
                                  ),
                                ),
                              ),

                              // Department
                              Expanded(
                                flex: 2,
                                child: Text(
                                  patient.department,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF666666),
                                  ),
                                ),
                              ),

                              // Registration Time
                              Expanded(
                                flex: 2,
                                child: Text(
                                  _formatDateTime(patient.registrationTime),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF666666),
                                  ),
                                ),
                              ),

                              // Actions
                              Expanded(
                                flex: 2,
                                child: GestureDetector(
                                  onTap: () {
                                    widget.onPatientSelected(patient);
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 8),
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF0F9D58),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text(
                                      'Select',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  // Pagination
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: Colors.grey[200]!)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Showing ${startIndex + 1} to $endIndex of ${filteredPatients.length} results',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF666666),
                          ),
                        ),
                        Row(
                          children: [
                            TextButton(
                              onPressed:
                                  _currentPage > 1
                                      ? () {
                                        setState(() {
                                          _currentPage--;
                                        });
                                      }
                                      : null,
                              child: const Text('Previous'),
                            ),
                            const SizedBox(width: 8),
                            ...List.generate(totalPages.clamp(0, 5), (index) {
                              final pageNumber = index + 1;
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _currentPage = pageNumber;
                                    });
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor:
                                        _currentPage == pageNumber
                                            ? const Color(0xFF4285F4)
                                            : null,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  child: Text(
                                    '$pageNumber',
                                    style: TextStyle(
                                      color:
                                          _currentPage == pageNumber
                                              ? Colors.white
                                              : const Color(0xFF4285F4),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              );
                            }),
                            if (totalPages > 5)
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                child: Text('...'),
                              ),
                            const SizedBox(width: 8),
                            TextButton(
                              onPressed:
                                  _currentPage < totalPages
                                      ? () {
                                        setState(() {
                                          _currentPage++;
                                        });
                                      }
                                      : null,
                              child: const Text('Next'),
                            ),
                          ],
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

  Widget _buildActiveFilterTags() {
    final List<Widget> activeFilters = [];

    // Gender filters
    if (_maleSelected) {
      activeFilters.add(
        _buildFilterChip('Male', () {
          setState(() {
            _maleSelected = false;
          });
        }),
      );
    }
    if (_femaleSelected) {
      activeFilters.add(
        _buildFilterChip('Female', () {
          setState(() {
            _femaleSelected = false;
          });
        }),
      );
    }
    if (_otherSelected) {
      activeFilters.add(
        _buildFilterChip('Other', () {
          setState(() {
            _otherSelected = false;
          });
        }),
      );
    }

    // Age filter
    if (_ageFilter != 'All ages') {
      activeFilters.add(
        _buildFilterChip('Age: $_ageFilter', () {
          setState(() {
            _ageFilter = 'All ages';
          });
        }),
      );
    }

    // Department filters
    if (_cardiologySelected) {
      activeFilters.add(
        _buildFilterChip('Cardiology', () {
          setState(() {
            _cardiologySelected = false;
          });
        }),
      );
    }
    if (_pediatricsSelected) {
      activeFilters.add(
        _buildFilterChip('Pediatrics', () {
          setState(() {
            _pediatricsSelected = false;
          });
        }),
      );
    }
    if (_neurologySelected) {
      activeFilters.add(
        _buildFilterChip('Neurology', () {
          setState(() {
            _neurologySelected = false;
          });
        }),
      );
    }
    if (_orthopedicsSelected) {
      activeFilters.add(
        _buildFilterChip('Orthopedics', () {
          setState(() {
            _orthopedicsSelected = false;
          });
        }),
      );
    }
    if (_entSelected) {
      activeFilters.add(
        _buildFilterChip('ENT', () {
          setState(() {
            _entSelected = false;
          });
        }),
      );
    }
    if (_generalMedicineSelected) {
      activeFilters.add(
        _buildFilterChip('General Medicine', () {
          setState(() {
            _generalMedicineSelected = false;
          });
        }),
      );
    }

    // Status filters
    if (_waitingSelected) {
      activeFilters.add(
        _buildFilterChip('Waiting', () {
          setState(() {
            _waitingSelected = false;
          });
        }),
      );
    }
    if (_inConsultationSelected) {
      activeFilters.add(
        _buildFilterChip('In Consultation', () {
          setState(() {
            _inConsultationSelected = false;
          });
        }),
      );
    }
    if (_completedSelected) {
      activeFilters.add(
        _buildFilterChip('Completed', () {
          setState(() {
            _completedSelected = false;
          });
        }),
      );
    }

    // Date filter
    if (_dateController.text.isNotEmpty) {
      activeFilters.add(
        _buildFilterChip(_dateController.text, () {
          setState(() {
            _dateController.clear();
          });
        }),
      );
    }

    if (activeFilters.isEmpty) {
      return const SizedBox();
    }

    return Wrap(spacing: 8, runSpacing: 8, children: activeFilters);
  }

  Widget _buildFilterChip(String label, VoidCallback onDeleted) {
    return Chip(
      label: Text(label),
      onDeleted: onDeleted,
      backgroundColor: Colors.blue[50],
      labelStyle: const TextStyle(color: Colors.blue),
      deleteIconColor: Colors.blue,
    );
  }

  Widget _buildToggleChip({
    required String label,
    required bool selected,
    required ValueChanged<bool> onSelected,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (value) => onSelected(value),
        selectedColor: const Color(0xFF4285F4).withOpacity(0.15),
        checkmarkColor: const Color(0xFF4285F4),
        labelStyle: TextStyle(
          color: selected ? const Color(0xFF4285F4) : const Color(0xFF555555),
          fontWeight: FontWeight.w500,
        ),
        backgroundColor: const Color(0xFFF3F4F6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  Widget _buildDateChip(BuildContext context) {
    final hasDate = _dateController.text.isNotEmpty;
    return InkWell(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
        );
        if (picked != null) {
          _dateController.text = '${picked.month}/${picked.day}/${picked.year}';
          setState(() {});
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color:
              hasDate
                  ? const Color(0xFF4285F4).withOpacity(0.15)
                  : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: hasDate ? const Color(0xFF4285F4) : const Color(0xFFE0E0E0),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              size: 16,
              color:
                  hasDate ? const Color(0xFF4285F4) : const Color(0xFF666666),
            ),
            const SizedBox(width: 6),
            Text(
              hasDate ? _dateController.text : 'Registration date',
              style: TextStyle(
                fontSize: 12,
                color:
                    hasDate ? const Color(0xFF4285F4) : const Color(0xFF555555),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _dateController.clear();
      _ageFilter = 'All ages';
      _maleSelected = false;
      _femaleSelected = false;
      _otherSelected = false;
      _cardiologySelected = false;
      _pediatricsSelected = false;
      _neurologySelected = false;
      _orthopedicsSelected = false;
      _entSelected = false;
      _generalMedicineSelected = false;
      _waitingSelected = false;
      _inConsultationSelected = false;
      _completedSelected = false;
      _currentPage = 1;
    });
  }

  List<Patient> _filterPatients(List<Patient> patients) {
    String searchTerm = _searchController.text.toLowerCase();
    DateTime? selectedDate;
    if (_dateController.text.isNotEmpty) {
      final parts = _dateController.text.split('/');
      if (parts.length == 3) {
        final month = int.tryParse(parts[0]);
        final day = int.tryParse(parts[1]);
        final year = int.tryParse(parts[2]);
        if (month != null && day != null && year != null) {
          selectedDate = DateTime(year, month, day);
        }
      }
    }

    return patients.where((patient) {
      // Search filter
      bool matchesSearch =
          searchTerm.isEmpty ||
          patient.name.toLowerCase().contains(searchTerm) ||
          patient.mrn.toLowerCase().contains(searchTerm);

      // Gender filter
      bool matchesGender =
          (!_maleSelected && !_femaleSelected && !_otherSelected) ||
          (_maleSelected && patient.gender == 'Male') ||
          (_femaleSelected && patient.gender == 'Female') ||
          (_otherSelected &&
              patient.gender != 'Male' &&
              patient.gender != 'Female');

      // Age filter
      bool matchesAge;
      switch (_ageFilter) {
        case '0-17':
          matchesAge = patient.age <= 17;
          break;
        case '18-40':
          matchesAge = patient.age >= 18 && patient.age <= 40;
          break;
        case '41-65':
          matchesAge = patient.age >= 41 && patient.age <= 65;
          break;
        case '65+':
          matchesAge = patient.age >= 65;
          break;
        default:
          matchesAge = true;
      }

      // Department filter
      bool matchesDepartment =
          (!_cardiologySelected &&
              !_pediatricsSelected &&
              !_neurologySelected &&
              !_orthopedicsSelected &&
              !_entSelected &&
              !_generalMedicineSelected) ||
          (_cardiologySelected && patient.department == 'Cardiology') ||
          (_pediatricsSelected && patient.department == 'Pediatrics') ||
          (_neurologySelected && patient.department == 'Neurology') ||
          (_orthopedicsSelected && patient.department == 'Orthopedics') ||
          (_entSelected && patient.department == 'ENT') ||
          (_generalMedicineSelected &&
              patient.department == 'General Medicine');

      // Status filter
      bool matchesStatus =
          (!_waitingSelected &&
              !_inConsultationSelected &&
              !_completedSelected) ||
          (_waitingSelected && patient.status == 'waiting') ||
          (_inConsultationSelected && patient.status == 'In Consultation') ||
          (_completedSelected && patient.status == 'Completed');

      // Date filter
      bool matchesDate =
          selectedDate == null ||
          (patient.registrationTime.year == selectedDate.year &&
              patient.registrationTime.month == selectedDate.month &&
              patient.registrationTime.day == selectedDate.day);

      return matchesSearch &&
          matchesGender &&
          matchesAge &&
          matchesDepartment &&
          matchesStatus &&
          matchesDate;
    }).toList();
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.month}/${dateTime.day}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
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
