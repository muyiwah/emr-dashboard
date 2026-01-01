import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schmgtsystem/models/patient_model.dart';
import 'package:schmgtsystem/providers/patient_proviider.dart';

class PatientRecordsScreenVitals extends StatefulWidget {
  PatientRecordsScreenVitals({super.key, required this.onPatientSelected});
  final Function(Patient patient) onPatientSelected;
  @override
  State<PatientRecordsScreenVitals> createState() => _PatientRecordsScreenVitalsState();
}

class _PatientRecordsScreenVitalsState extends State<PatientRecordsScreenVitals> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  double _ageRangeValue = 100;
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
      body: Row(
        children: [
          // Main Content Area
          Expanded(
            flex: 4,
            child: Column(
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
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF666666),
                        ),
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

                // Search and Filter Tags
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(24),
                  child: Column(
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
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFFE0E0E0),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFFE0E0E0),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFF4285F4),
                            ),
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

                      // Active Filter Tags
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
                                  'STATUS',
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
                                    bottom: BorderSide(
                                      color: Colors.grey[200]!,
                                    ),
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
                                            backgroundColor: _getAvatarColor(
                                              index,
                                            ),
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
                                        _formatDateTime(
                                          patient.registrationTime,
                                        ),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF666666),
                                        ),
                                      ),
                                    ),

                                    // Status
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                          horizontal: 3,
                                        ),
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: patient.statusColor,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          patient.status,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Actions
                                    Expanded(
                                      flex: 2,
                                      child: GestureDetector(
                                        onTap: () {
                                          print(patient);
                                          widget.onPatientSelected(patient);
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(left: 8),
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Text(
                                            'Select',
                                            style: const TextStyle(
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
                            border: Border(
                              top: BorderSide(color: Colors.grey[200]!),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Showing ${startIndex + 1} to ${endIndex} of ${filteredPatients.length} results',
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
                                  ...List.generate(totalPages.clamp(0, 5), (
                                    index,
                                  ) {
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
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
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
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 4,
                                      ),
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
          ),

          // Right Sidebar - Filters
          Container(
            width: 300,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Filters Header
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[200]!),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filters',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      TextButton(
                        onPressed: _resetFilters,
                        child: const Text(
                          'Clear All',
                          style: TextStyle(
                            color: Color(0xFF4285F4),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Gender Filter
                        const Text(
                          'Gender',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 12),
                        CheckboxListTile(
                          title: const Text('Male'),
                          value: _maleSelected,
                          onChanged: (value) {
                            setState(() {
                              _maleSelected = value!;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                        ),
                        CheckboxListTile(
                          title: const Text('Female'),
                          value: _femaleSelected,
                          onChanged: (value) {
                            setState(() {
                              _femaleSelected = value!;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                        ),
                        CheckboxListTile(
                          title: const Text('Other'),
                          value: _otherSelected,
                          onChanged: (value) {
                            setState(() {
                              _otherSelected = value!;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                        ),

                        const SizedBox(height: 24),

                        // Age Range Filter
                        const Text(
                          'Age Range',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('0'),
                                Text(_ageRangeValue.round().toString()),
                                const Text('100'),
                              ],
                            ),
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: const Color(0xFF4285F4),
                                inactiveTrackColor: Colors.grey[300],
                                thumbColor: const Color(0xFF4285F4),
                                overlayColor: const Color(
                                  0xFF4285F4,
                                ).withOpacity(0.2),
                              ),
                              child: Slider(
                                value: _ageRangeValue,
                                min: 0,
                                max: 100,
                                onChanged: (value) {
                                  setState(() {
                                    _ageRangeValue = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Department Filter
                        const Text(
                          'Department',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 12),
                        CheckboxListTile(
                          title: const Text('Cardiology'),
                          value: _cardiologySelected,
                          onChanged: (value) {
                            setState(() {
                              _cardiologySelected = value!;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                        ),
                        CheckboxListTile(
                          title: const Text('Pediatrics'),
                          value: _pediatricsSelected,
                          onChanged: (value) {
                            setState(() {
                              _pediatricsSelected = value!;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                        ),
                        CheckboxListTile(
                          title: const Text('Neurology'),
                          value: _neurologySelected,
                          onChanged: (value) {
                            setState(() {
                              _neurologySelected = value!;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                        ),
                        CheckboxListTile(
                          title: const Text('Orthopedics'),
                          value: _orthopedicsSelected,
                          onChanged: (value) {
                            setState(() {
                              _orthopedicsSelected = value!;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                        ),
                        CheckboxListTile(
                          title: const Text('ENT'),
                          value: _entSelected,
                          onChanged: (value) {
                            setState(() {
                              _entSelected = value!;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                        ),
                        CheckboxListTile(
                          title: const Text('General Medicine'),
                          value: _generalMedicineSelected,
                          onChanged: (value) {
                            setState(() {
                              _generalMedicineSelected = value!;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                        ),

                        const SizedBox(height: 24),

                        // Status Filter
                        const Text(
                          'Patient Status',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 12),
                        CheckboxListTile(
                          title: const Text('Waiting'),
                          value: _waitingSelected,
                          onChanged: (value) {
                            setState(() {
                              _waitingSelected = value!;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                        ),
                        CheckboxListTile(
                          title: const Text('In Consultation'),
                          value: _inConsultationSelected,
                          onChanged: (value) {
                            setState(() {
                              _inConsultationSelected = value!;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                        ),
                        CheckboxListTile(
                          title: const Text('Completed'),
                          value: _completedSelected,
                          onChanged: (value) {
                            setState(() {
                              _completedSelected = value!;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                        ),

                        const SizedBox(height: 24),

                        // Visit Date Filter
                        const Text(
                          'Registration Date',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _dateController,
                          decoration: InputDecoration(
                            hintText: 'mm/dd/yyyy',
                            suffixIcon: const Icon(Icons.calendar_today),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFFE0E0E0),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFFE0E0E0),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFF4285F4),
                              ),
                            ),
                          ),
                          onTap: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null) {
                              _dateController.text =
                                  "${picked.month}/${picked.day}/${picked.year}";
                              setState(() {});
                            }
                          },
                          readOnly: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
    if (_ageRangeValue < 100) {
      activeFilters.add(
        _buildFilterChip('Age: 0-${_ageRangeValue.round()}', () {
          setState(() {
            _ageRangeValue = 100;
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

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _dateController.clear();
      _ageRangeValue = 100;
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
    DateTime? selectedDate =
        _dateController.text.isNotEmpty
            ? DateTime.parse(_dateController.text)
            : null;

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
      bool matchesAge = patient.age <= _ageRangeValue;

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
