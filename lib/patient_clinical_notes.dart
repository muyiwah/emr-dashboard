import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:schmgtsystem/models/patient_model.dart';
import 'package:schmgtsystem/providers/patient_proviider.dart';
import 'package:schmgtsystem/services/api_service.dart';
import 'package:schmgtsystem/widgets/clinical_note_template_popup.dart';
import 'package:schmgtsystem/widgets/clinical_notes_popup.dart';
import 'package:intl/intl.dart';

class PatientClinicalNotes extends StatefulWidget {
  PatientClinicalNotes({super.key, required this.goBack});
  Null Function() goBack;

  @override
  State<PatientClinicalNotes> createState() => _PatientClinicalNotesState();
}

class _PatientClinicalNotesState extends State<PatientClinicalNotes> {
  Patient? _patient;
  Map<String, dynamic>? _mostRecentNote;
  List<Map<String, dynamic>> _historicalNotes = [];
  List<Map<String, dynamic>> _filteredHistoricalNotes = [];
  List<Map<String, dynamic>> _recentEncounterNotes = [];
  List<Map<String, dynamic>> _previousEncounterNotes = [];
  bool _isLoadingMostRecent = true;
  bool _isLoadingHistorical = true;
  bool _isLoadingRecentNotes = true;
  bool _isLoadingPreviousNotes = false;
  final TextEditingController _searchController = TextEditingController();
  String _selectedNoteType = 'All Note Types';
  String _selectedDoctor = 'All Doctors';
  bool _showPreviousNotes = false;

  @override
  void initState() {
    super.initState();
    _patient =
        Provider.of<PatientProvider>(context, listen: false).currentPatient;
    _loadClinicalNotes();
  }

  Future<void> _loadClinicalNotes() async {
    print('=== LOADING CLINICAL NOTES ===');

    // Re-fetch patient from provider to ensure we have the latest
    final patientProvider = Provider.of<PatientProvider>(
      context,
      listen: false,
    );
    _patient = patientProvider.currentPatient;

    print('Patient from provider: ${_patient?.name}');
    print('Patient ID: ${_patient?.id}');
    print('Patient MRN: ${_patient?.mrn}');

    if (_patient == null) {
      print('ERROR: Patient is null - cannot load notes');
      setState(() {
        _isLoadingMostRecent = false;
        _isLoadingHistorical = false;
        _isLoadingRecentNotes = false;
      });
      return;
    }

    if (_patient!.id!.isEmpty) {
      print('ERROR: Patient ID is empty - cannot load notes');
      print('Patient object: $_patient');
      setState(() {
        _isLoadingMostRecent = false;
        _isLoadingHistorical = false;
        _isLoadingRecentNotes = false;
      });
      return;
    }

    print('Patient validated - proceeding with API calls');

    // Load most recent note
    print('=== CALLING _loadMostRecentNote ===');
    await _loadMostRecentNote();

    // Load historical notes
    print('=== CALLING _loadHistoricalNotes ===');
    await _loadHistoricalNotes();

    // Load recent encounter notes
    print('=== CALLING _loadRecentEncounterNotes ===');
    await _loadRecentEncounterNotes();

    print('=== FINISHED LOADING CLINICAL NOTES ===');
    print(
      'Most Recent Note: ${_mostRecentNote != null ? "Found" : "Not found"}',
    );
    if (_mostRecentNote != null) {
      print('Note ID: ${_mostRecentNote!['id']}');
      print('Note Type: ${_mostRecentNote!['noteType']}');
    }
  }

  Future<void> _loadMostRecentNote() async {
    if (_patient?.id == null) return;

    setState(() {
      _isLoadingMostRecent = true;
    });

    try {
      final response = await ApiService.getClinicalNotes(
        _patient!.id,
        limit: 1,
        sortBy: 'createdAt',
        sortOrder: 'desc',
      );

      print('=== MOST RECENT CLINICAL NOTE RESPONSE ===');
      print('Success: ${response.success}');
      print('Status Code: ${response.statusCode}');
      print('Response Data Type: ${response.data.runtimeType}');
      print('Response Data: ${response.data}');
      print('Error: ${response.error}');
      print('==========================================');

      if (mounted) {
        setState(() {
          _isLoadingMostRecent = false;
          if (response.success && response.data != null) {
            print('Parsing response data...');
            final data = response.data as Map<String, dynamic>;
            print('Data keys: ${data.keys.toList()}');
            print('Full data structure: $data');

            // Try different possible response structures
            List<dynamic>? clinicalNotes;

            // Check if data has 'clinicalNotes' key
            if (data.containsKey('clinicalNotes')) {
              clinicalNotes = data['clinicalNotes'] as List<dynamic>?;
              print(
                'Found clinicalNotes in data: ${clinicalNotes?.length ?? 0} items',
              );
            }
            // Check if data itself is a list
            else if (response.data is List) {
              clinicalNotes = response.data as List<dynamic>;
              print('Response data is a list: ${clinicalNotes.length} items');
            }
            // Check if data has 'data' key with clinicalNotes
            else if (data.containsKey('data')) {
              final innerData = data['data'] as Map<String, dynamic>?;
              if (innerData != null && innerData.containsKey('clinicalNotes')) {
                clinicalNotes = innerData['clinicalNotes'] as List<dynamic>?;
                print(
                  'Found clinicalNotes in data.data: ${clinicalNotes?.length ?? 0} items',
                );
              }
            }

            print('Final clinicalNotes: $clinicalNotes');
            print('Clinical Notes length: ${clinicalNotes?.length ?? 0}');

            if (clinicalNotes != null && clinicalNotes.isNotEmpty) {
              print('Setting most recent note...');
              _mostRecentNote = clinicalNotes[0] as Map<String, dynamic>;
              print('Most recent note set successfully');
              print('Note ID: ${_mostRecentNote!['id']}');
              print('Note Type: ${_mostRecentNote!['noteType']}');
              final content = _mostRecentNote!['content'] as String? ?? '';
              print(
                'Note Content preview: ${content.length > 50 ? content.substring(0, 50) : content}',
              );
            } else {
              print('No clinical notes found in response');
              _mostRecentNote = null;
            }
          } else {
            print('Response not successful or data is null');
            _mostRecentNote = null;
          }
        });
      }
    } catch (e) {
      print('=== ERROR LOADING MOST RECENT NOTE ===');
      print('Error: $e');
      print('=====================================');
      if (mounted) {
        setState(() {
          _isLoadingMostRecent = false;
          _mostRecentNote = null;
        });
      }
    }
  }

  Future<void> _loadHistoricalNotes() async {
    if (_patient?.id == null) return;

    setState(() {
      _isLoadingHistorical = true;
    });

    try {
      final response = await ApiService.getClinicalNotes(
        _patient!.id,
        page: 1,
        limit: 20,
        sortBy: 'createdAt',
        sortOrder: 'desc',
      );

      print('=== HISTORICAL CLINICAL NOTES RESPONSE ===');
      print('Success: ${response.success}');
      print('Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');
      print('Error: ${response.error}');
      print('===========================================');

      if (mounted) {
        setState(() {
          _isLoadingHistorical = false;
          if (response.success && response.data != null) {
            print('=== PARSING HISTORICAL NOTES ===');
            print('Response data type: ${response.data.runtimeType}');

            // The response structure is: {success: true, data: {patientId: ..., clinicalNotes: [...], pagination: {...}}, message: "..."}
            List<dynamic>? clinicalNotes;

            if (response.data is Map<String, dynamic>) {
              final responseData = response.data as Map<String, dynamic>;
              print('=== HISTORICAL NOTES PARSING ===');
              print('Response data keys: ${responseData.keys.toList()}');

              // The API returns: {success: true, data: {clinicalNotes: [...], ...}, message: "..."}
              // So we need to access response.data['data']['clinicalNotes']
              if (responseData.containsKey('data')) {
                final innerData = responseData['data'];
                print('Found data key, type: ${innerData.runtimeType}');

                if (innerData is Map<String, dynamic>) {
                  print('Inner data keys: ${innerData.keys.toList()}');

                  if (innerData.containsKey('clinicalNotes')) {
                    final notes = innerData['clinicalNotes'];
                    print(
                      'Found clinicalNotes in nested data, type: ${notes.runtimeType}',
                    );

                    if (notes is List) {
                      clinicalNotes = notes;
                      print(
                        'Historical clinicalNotes loaded: ${clinicalNotes.length} items',
                      );
                    } else {
                      print('clinicalNotes is not a List');
                    }
                  } else {
                    print('clinicalNotes key not found in inner data');
                  }
                } else {
                  print('Inner data is not a Map<String, dynamic>');
                }
              } else {
                // Fallback: check if clinicalNotes is directly in response.data
                print('data key not found, checking for direct clinicalNotes');
                if (responseData.containsKey('clinicalNotes')) {
                  final notes = responseData['clinicalNotes'];
                  if (notes is List) {
                    clinicalNotes = notes;
                    print(
                      'Found clinicalNotes directly in response.data: ${clinicalNotes.length} items',
                    );
                  }
                } else {
                  print('No clinicalNotes found anywhere in response');
                }
              }
            } else {
              print('Response data is not a Map<String, dynamic>');
              print('Response data type: ${response.data.runtimeType}');
            }

            print('Final clinicalNotes: $clinicalNotes');
            print('Clinical Notes length: ${clinicalNotes?.length ?? 0}');
            print('Is empty check: ${clinicalNotes?.isEmpty ?? true}');

            // TEMPORARY: Add test data if no notes found
            if ((clinicalNotes == null || clinicalNotes.isEmpty) &&
                kDebugMode) {
              clinicalNotes = [
                {
                  'id': 'test-hist-1',
                  'noteType': 'Progress Note',
                  'content': 'Test historical clinical note content',
                  'createdAt':
                      DateTime.now()
                          .subtract(Duration(days: 1))
                          .toIso8601String(),
                  'status': 'draft',
                  'createdBy': {'name': 'Test Doctor'},
                },
                {
                  'id': 'test-hist-2',
                  'noteType': 'Progress Note',
                  'content': 'Another test historical clinical note',
                  'createdAt':
                      DateTime.now()
                          .subtract(Duration(days: 2))
                          .toIso8601String(),
                  'status': 'draft',
                  'createdBy': {'name': 'Test Doctor'},
                },
              ];
              print('Added test historical clinical notes data for debugging');
            }

            if (clinicalNotes != null && clinicalNotes.isNotEmpty) {
              print('=== HISTORICAL NOTES LOADED ===');
              print('Total notes: ${clinicalNotes.length}');
              try {
                _historicalNotes =
                    clinicalNotes
                        .map((note) => note as Map<String, dynamic>)
                        .skip(1) // Skip the first one as it's the most recent
                        .toList();
                print(
                  'Historical notes (after skip): ${_historicalNotes.length}',
                );
                // Initialize filtered notes with all historical notes
                _filteredHistoricalNotes = List.from(_historicalNotes);
                print(
                  'Filtered notes initialized: ${_filteredHistoricalNotes.length}',
                );
              } catch (e) {
                print('Error casting notes: $e');
                _historicalNotes = [];
                _filteredHistoricalNotes = [];
              }
            } else {
              _historicalNotes = [];
              _filteredHistoricalNotes = [];
              print('No clinical notes found in response');
              print('clinicalNotes is null: ${clinicalNotes == null}');
              if (clinicalNotes != null) {
                print('clinicalNotes is empty: ${clinicalNotes.isEmpty}');
              }
            }
          } else {
            _historicalNotes = [];
            _filteredHistoricalNotes = [];
            print('Response not successful or data is null');
            print('Response success: ${response.success}');
            print('Response data is null: ${response.data == null}');
          }
        });
        // Apply filters after setState to avoid nested setState calls
        // Use a small delay to ensure setState has completed
        Future.microtask(() {
          _applyFilters();
          print('=== AFTER APPLYING FILTERS ===');
          print('Historical notes count: ${_historicalNotes.length}');
          print('Filtered notes count: ${_filteredHistoricalNotes.length}');
        });
      }
    } catch (e) {
      print('=== ERROR LOADING HISTORICAL NOTES ===');
      print('Error: $e');
      print('======================================');
      if (mounted) {
        setState(() {
          _isLoadingHistorical = false;
          _historicalNotes = [];
          _filteredHistoricalNotes = [];
        });
      }
    }
  }

  Future<void> _loadRecentEncounterNotes() async {
    if (_patient?.id == null) return;

    setState(() {
      _isLoadingRecentNotes = true;
    });

    try {
      print('=== LOADING TODAY\'S ENCOUNTER NOTES ===');
      print('Patient ID: ${_patient!.id}');

      // Get recent encounter notes (last 30 days)
      final now = DateTime.now();
      final thirtyDaysAgo = now.subtract(Duration(days: 30));

      print(
        'Fetching encounter notes from ${thirtyDaysAgo.toIso8601String()} to ${now.toIso8601String()}',
      );

      final response = await ApiService.getEncounterNotes(
        patientId: _patient!.id,
        dateFrom: thirtyDaysAgo.toIso8601String(),
        dateTo: now.toIso8601String(),
        sortBy: 'encounterDatetime',
        sortOrder: 'desc',
      );

      print('=== TODAY\'S ENCOUNTER NOTES RESPONSE ===');
      print('Success: ${response.success}');
      print('Response Data: ${response.data}');

      if (mounted) {
        setState(() {
          _isLoadingRecentNotes = false;
          if (response.success && response.data != null) {
            print('=== ENCOUNTER NOTES RESPONSE SUCCESS ===');
            print('Response data type: ${response.data.runtimeType}');
            print('Response data: ${response.data}');

            // Handle multiple response structures:
            // 1. Direct array: [...]
            // 2. {data: {items: [...]}} - standard API response
            // 3. {items: [...]} - direct items object
            List<dynamic> items = [];

            if (response.data is List) {
              // Direct array response
              items = response.data as List<dynamic>;
              print('Using direct array response');
            } else {
              final responseData = response.data as Map<String, dynamic>;
              print('Response data keys: ${responseData.keys.toList()}');

              if (responseData.containsKey('data')) {
                final innerData = responseData['data'];
                print(
                  'Found data key, inner data type: ${innerData.runtimeType}',
                );
                if (innerData is Map<String, dynamic> &&
                    innerData.containsKey('items')) {
                  items = innerData['items'] as List<dynamic>;
                  print('Found items in nested data');
                }
              } else if (responseData.containsKey('items')) {
                // Direct items array
                items = responseData['items'] as List<dynamic>;
                print('Found items directly in response');
              }
            }

            print('Final items count: ${items.length}');
            if (items.isNotEmpty) {
              _recentEncounterNotes =
                  items.map((item) => item as Map<String, dynamic>).toList();
              print(
                'Loaded ${_recentEncounterNotes.length} today\'s encounter notes',
              );
            } else {
              _recentEncounterNotes = [];
              print('No encounter notes found');
            }
          } else {
            _recentEncounterNotes = [];
            print(
              'Failed to load today\'s encounter notes - response not successful',
            );
            print('Response success: ${response.success}');
            print('Response status code: ${response.statusCode}');
            print('Response data is null: ${response.data == null}');
            if (response.error != null) {
              print('Response error: ${response.error}');
            }

            // TEMPORARY: Add test data to verify UI works
            if (kDebugMode) {
              _recentEncounterNotes = [
                {
                  'id': 'test-1',
                  'chiefComplaint': 'Test encounter note',
                  'status': 'draft',
                  'encounterDatetime': DateTime.now().toIso8601String(),
                  'createdBy': {'name': 'Test Nurse'},
                  'encounterType': 'Routine',
                },
              ];
              print('Added test encounter note data for debugging');
            }
          }
        });
      }
    } catch (e) {
      print('=== ERROR LOADING TODAY\'S ENCOUNTER NOTES ===');
      print('Error: $e');
      if (mounted) {
        setState(() {
          _isLoadingRecentNotes = false;
          _recentEncounterNotes = [];
        });
      }
    }
  }

  Future<void> _loadPreviousEncounterNotes() async {
    if (_patient?.id == null) return;

    setState(() {
      _isLoadingPreviousNotes = true;
    });

    try {
      print('=== LOADING PREVIOUS ENCOUNTER NOTES ===');
      print('Patient ID: ${_patient!.id}');

      // Get notes from before today (last 30 days to avoid too many results)
      final now = DateTime.now();
      final thirtyDaysAgo = now.subtract(const Duration(days: 30));
      final yesterdayEnd = DateTime(
        now.year,
        now.month,
        now.day - 1,
        23,
        59,
        59,
      );

      final response = await ApiService.getEncounterNotes(
        patientId: _patient!.id,
        dateFrom: thirtyDaysAgo.toIso8601String(),
        dateTo: yesterdayEnd.toIso8601String(),
        sortBy: 'encounterDatetime',
        sortOrder: 'desc',
        limit: 10, // Limit to prevent too many results
      );

      print('=== PREVIOUS ENCOUNTER NOTES RESPONSE ===');
      print('Success: ${response.success}');
      print('Response Data: ${response.data}');

      if (mounted) {
        setState(() {
          _isLoadingPreviousNotes = false;
          if (response.success && response.data != null) {
            // Handle multiple response structures:
            // 1. Direct array: [...]
            // 2. {data: {items: [...]}} - standard API response
            // 3. {items: [...]} - direct items object
            List<dynamic> items = [];

            if (response.data is List) {
              // Direct array response
              items = response.data as List<dynamic>;
            } else {
              final responseData = response.data as Map<String, dynamic>;

              if (responseData.containsKey('data')) {
                final innerData = responseData['data'];
                if (innerData is Map<String, dynamic> &&
                    innerData.containsKey('items')) {
                  items = innerData['items'] as List<dynamic>;
                }
              } else if (responseData.containsKey('items')) {
                // Direct items array
                items = responseData['items'] as List<dynamic>;
              }
            }

            if (items.isNotEmpty) {
              _previousEncounterNotes =
                  items.map((item) => item as Map<String, dynamic>).toList();
              print(
                'Loaded ${_previousEncounterNotes.length} previous encounter notes',
              );
            } else {
              _previousEncounterNotes = [];
            }
          } else {
            _previousEncounterNotes = [];
            print('Failed to load previous encounter notes');
          }
        });
      }
    } catch (e) {
      print('=== ERROR LOADING PREVIOUS ENCOUNTER NOTES ===');
      print('Error: $e');
      if (mounted) {
        setState(() {
          _isLoadingPreviousNotes = false;
          _previousEncounterNotes = [];
        });
      }
    }
  }

  void _applyFilters() {
    if (!mounted) return;

    print('=== APPLYING FILTERS ===');
    print('Historical notes count: ${_historicalNotes.length}');
    print('Search query: "${_searchController.text}"');
    print('Selected note type: $_selectedNoteType');
    print('Selected doctor: $_selectedDoctor');

    List<Map<String, dynamic>> filtered = List.from(_historicalNotes);
    print('Starting with ${filtered.length} notes');

    // Apply search filter
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered =
          filtered.where((note) {
            final content = (note['content'] as String? ?? '').toLowerCase();
            final noteType = (note['noteType'] as String? ?? '').toLowerCase();
            final title = (note['title'] as String? ?? '').toLowerCase();
            final subjective =
                (note['subjective'] as String? ?? '').toLowerCase();
            final objective =
                (note['objective'] as String? ?? '').toLowerCase();
            final assessment =
                (note['assessment'] as String? ?? '').toLowerCase();
            final plan = (note['plan'] as String? ?? '').toLowerCase();

            return content.contains(query) ||
                noteType.contains(query) ||
                title.contains(query) ||
                subjective.contains(query) ||
                objective.contains(query) ||
                assessment.contains(query) ||
                plan.contains(query);
          }).toList();
      print('After search filter: ${filtered.length} notes');
    }

    // Apply note type filter
    if (_selectedNoteType != 'All Note Types') {
      filtered =
          filtered.where((note) {
            return (note['noteType'] as String? ?? '') == _selectedNoteType;
          }).toList();
      print('After note type filter: ${filtered.length} notes');
    }

    // Apply doctor filter
    if (_selectedDoctor != 'All Doctors') {
      filtered =
          filtered.where((note) {
            final createdBy = note['createdBy'] as Map<String, dynamic>?;
            if (createdBy != null && createdBy['name'] != null) {
              return (createdBy['name'] as String) == _selectedDoctor;
            }
            return false;
          }).toList();
      print('After doctor filter: ${filtered.length} notes');
    }

    print('Final filtered count: ${filtered.length}');
    if (mounted) {
      setState(() {
        _filteredHistoricalNotes = filtered;
        print(
          'Set state: _filteredHistoricalNotes = ${_filteredHistoricalNotes.length}',
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Patient Header
                _buildPatientHeader(),
                SizedBox(height: 24),

                // Main Content Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Column - Clinical Notes
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          _buildMostRecentNote(),
                          SizedBox(height: 24),
                          _buildHistoricalNotes(),
                        ],
                      ),
                    ),
                    SizedBox(width: 24),

                    // Right Column - Actions & Highlights
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          _buildQuickActions(),
                          SizedBox(height: 24),
                          _buildEncounterNotes(),
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
    );
  }

  Widget _buildPatientHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Patient Avatar
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage(
              'assets/patient_avatar.jpg',
            ), // You'd need to add this asset
            backgroundColor: Colors.grey[300],
          ),
          SizedBox(width: 16),

          // Patient Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _patient?.name ?? '',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Patient ID: ${_patient?.mrn}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '${_patient?.gender} • ${_patient?.age} years • O+',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    SizedBox(width: 12),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Outpatient',
                        style: TextStyle(
                          color: Colors.green[700],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Allergies & Diagnoses
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Known Allergies:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  _buildAllergyCip('Penicillin', Colors.red),
                  SizedBox(width: 8),
                  _buildAllergyCip('Latex', Colors.red),
                ],
              ),
              SizedBox(height: 12),
              Text(
                'Current Diagnoses:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  _buildAllergyCip('Type 2 Diabetes', Colors.blue),
                  SizedBox(width: 8),
                  _buildAllergyCip('Hypertension', Colors.blue),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAllergyCip(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildMostRecentNote() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  widget.goBack();
                },
                icon: Icon(Icons.arrow_back_ios),
              ),
              SizedBox(width: 8),
              Text(
                'Most Recent Clinical Note',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Spacer(),
              if (_mostRecentNote != null)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _mostRecentNote!['noteType'] ?? 'Clinical Note',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 12),
          if (_isLoadingMostRecent)
            Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(),
              ),
            )
          else if (_mostRecentNote == null)
            Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'No clinical notes found',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            )
          else ...[
            _buildNoteMetadata(_mostRecentNote!),
            SizedBox(height: 16),
            _buildNoteContent(_mostRecentNote!),
          ],

          SizedBox(height: 16),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.edit, size: 16),
                label: Text('Edit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
              SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.fullscreen, size: 16),
                label: Text('View Full'),
                style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
              ),
              SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ClinicalNotePopup(
                        onNoteCreated: () {
                          print(
                            '=== CALLBACK TRIGGERED: Note Created (Add Note Button) ===',
                          );
                          // Re-fetch patient from provider before reloading
                          final patientProvider = Provider.of<PatientProvider>(
                            context,
                            listen: false,
                          );
                          setState(() {
                            _patient = patientProvider.currentPatient;
                          });
                          print('Patient after callback: ${_patient?.id}');

                          // Add a small delay to ensure backend has processed the note
                          Future.delayed(Duration(milliseconds: 500), () {
                            print('Reloading clinical notes after creation...');
                            _loadClinicalNotes();
                          });
                        },
                      );
                    },
                  );
                },
                icon: Icon(Icons.add, size: 16),
                label: Text('Add Note'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSOAPSection(String title, String content, Color color) {
    if (content.isEmpty) return SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: color, width: 4)),
        color: color.withOpacity(0.05),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 4),
          Text(
            content,
            style: TextStyle(fontSize: 14, color: Colors.grey[800]),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteMetadata(Map<String, dynamic> note) {
    String dateStr = 'Date not available';
    String doctorStr = '';

    try {
      if (note['createdAt'] != null) {
        final date = DateTime.parse(note['createdAt']);
        dateStr = DateFormat('MMMM d, yyyy • h:mm a').format(date);
      }
    } catch (e) {
      print('Error parsing date: $e');
    }

    try {
      if (note['createdBy'] != null) {
        final createdBy = note['createdBy'] as Map<String, dynamic>?;
        if (createdBy != null && createdBy['name'] != null) {
          doctorStr = createdBy['name'] as String;
        }
      }
    } catch (e) {
      print('Error parsing createdBy: $e');
    }

    return Text(
      '$dateStr${doctorStr.isNotEmpty ? '    $doctorStr' : ''}',
      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
    );
  }

  Widget _buildNoteContent(Map<String, dynamic> note) {
    // Check if it's a SOAP note (has SOAP fields)
    final hasSubjective =
        note['subjective'] != null && (note['subjective'] as String).isNotEmpty;
    final hasObjective =
        note['objective'] != null && (note['objective'] as String).isNotEmpty;
    final hasAssessment =
        note['assessment'] != null && (note['assessment'] as String).isNotEmpty;
    final hasPlan = note['plan'] != null && (note['plan'] as String).isNotEmpty;

    final isSoapNote =
        hasSubjective || hasObjective || hasAssessment || hasPlan;

    if (isSoapNote) {
      // Display SOAP format
      return Column(
        children: [
          if (hasSubjective) ...[
            _buildSOAPSection(
              'S - Subjective',
              note['subjective'] as String,
              Colors.blue,
            ),
            SizedBox(height: 12),
          ],
          if (hasObjective) ...[
            _buildSOAPSection(
              'O - Objective',
              note['objective'] as String,
              Colors.cyan,
            ),
            SizedBox(height: 12),
          ],
          if (hasAssessment) ...[
            _buildSOAPSection(
              'A - Assessment',
              note['assessment'] as String,
              Colors.orange,
            ),
            SizedBox(height: 12),
          ],
          if (hasPlan)
            _buildSOAPSection('P - Plan', note['plan'] as String, Colors.green),
        ],
      );
    } else {
      // Display free-text format
      final content = note['content'] as String? ?? '';
      if (content.isEmpty) {
        return Text(
          'No content available',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
        );
      }
      return Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: Colors.blue, width: 4)),
          color: Colors.blue.withOpacity(0.05),
        ),
        child: Text(
          content,
          style: TextStyle(fontSize: 14, color: Colors.grey[800]),
        ),
      );
    }
  }

  Widget _buildHistoricalNotes() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Historical Clinical Notes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Spacer(),
              OutlinedButton(
                onPressed: () {
                  // Navigate to all clinical notes screen
                  if (_patient != null) {
                    context.push(
                      '/doctors/clinical-notes/all',
                      extra: _patient,
                    );
                  }
                },
                child: Text('Show All'),
                style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
              ),
            ],
          ),
          SizedBox(height: 16),

          // Search and filters
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search clinical notes...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Text('All Note Types'),
                    Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
              SizedBox(width: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [Text('All Doctors'), Icon(Icons.arrow_drop_down)],
                ),
              ),
              SizedBox(width: 8),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.filter_list, color: Colors.grey[600]),
              ),
            ],
          ),
          SizedBox(height: 16),

          // Historical notes list
          _isLoadingHistorical
              ? Center(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: CircularProgressIndicator(),
                ),
              )
              : _filteredHistoricalNotes.isEmpty
              ? Center(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: Text(
                    'No clinical notes found',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ),
              )
              : Column(
                children:
                    _filteredHistoricalNotes
                        .take(2) // Show maximum of 2 notes
                        .toList()
                        .asMap()
                        .entries
                        .map((entry) {
                          final index = entry.key;
                          final note = entry.value;
                          return Padding(
                            padding: EdgeInsets.only(bottom: 12),
                            child: _buildHistoricalNoteItemFromData(
                              note: note,
                              index: index + 1,
                            ),
                          );
                        })
                        .toList(),
              ),
        ],
      ),
    );
  }

  Widget _buildHistoricalNoteItemFromData({
    required Map<String, dynamic> note,
    required int index,
  }) {
    // Parse date
    String dateStr = 'N/A';
    try {
      final createdAt = note['createdAt'] as String?;
      if (createdAt != null) {
        final date = DateTime.parse(createdAt);
        dateStr = DateFormat('MMMM d, yyyy • h:mm a').format(date);
      }
    } catch (e) {
      print('Error parsing date: $e');
    }

    // Get note type
    final noteType = note['noteType'] as String? ?? 'Unknown';

    // Get status
    final status = note['status'] as String? ?? 'draft';
    Color statusColor = Colors.grey;
    if (status == 'signed') {
      statusColor = Colors.green;
    } else if (status == 'final') {
      statusColor = Colors.blue;
    } else if (status == 'draft') {
      statusColor = Colors.orange;
    }

    // Get content preview
    String contentPreview = '';
    final content = note['content'] as String? ?? '';
    if (content.isNotEmpty) {
      contentPreview =
          content.length > 150 ? '${content.substring(0, 150)}...' : content;
    } else {
      // Try to get from SOAP fields
      final subjective = note['subjective'] as String? ?? '';
      final objective = note['objective'] as String? ?? '';
      final assessment = note['assessment'] as String? ?? '';
      final plan = note['plan'] as String? ?? '';
      final combined = [
        subjective,
        objective,
        assessment,
        plan,
      ].where((s) => s.isNotEmpty).join(' ');
      contentPreview =
          combined.length > 150 ? '${combined.substring(0, 150)}...' : combined;
    }

    // Get doctor name
    String doctorStr = 'Unknown';
    try {
      if (note['createdBy'] != null) {
        final createdBy = note['createdBy'] as Map<String, dynamic>?;
        if (createdBy != null && createdBy['name'] != null) {
          doctorStr = createdBy['name'] as String;
        }
      }
    } catch (e) {
      print('Error parsing createdBy: $e');
    }

    return _buildHistoricalNoteItem(
      number: index.toString(),
      date: dateStr,
      noteType: noteType,
      status: status.toUpperCase(),
      statusColor: statusColor,
      content: contentPreview.isEmpty ? 'No content available' : contentPreview,
      doctor: doctorStr,
    );
  }

  Widget _buildHistoricalNoteItem({
    required String number,
    required String date,
    required String noteType,
    required String status,
    required Color statusColor,
    required String content,
    required String doctor,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      date,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: 12),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        noteType,
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.expand_more, color: Colors.grey[600]),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  content,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
                SizedBox(height: 4),
                Text(
                  doctor,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          _buildActionButton(
            icon: Icons.add,
            text: 'Add New Clinical Note',
            color: Colors.blue,
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ClinicalNotePopup(
                    onNoteCreated: () {
                      print(
                        '=== CALLBACK TRIGGERED: Note Created (Quick Actions) ===',
                      );
                      // Re-fetch patient from provider before reloading
                      final patientProvider = Provider.of<PatientProvider>(
                        context,
                        listen: false,
                      );
                      setState(() {
                        _patient = patientProvider.currentPatient;
                      });
                      print('Patient after callback: ${_patient?.id}');

                      // Add a small delay to ensure backend has processed the note
                      Future.delayed(Duration(milliseconds: 500), () {
                        print('Reloading clinical notes after creation...');
                        _loadClinicalNotes();
                      });
                    },
                  );
                },
              );
            },
          ),
          SizedBox(height: 12),
          _buildActionButton(
            icon: Icons.print,
            text: 'Print/Export Notes',
            color: Colors.grey[600]!,
            onTap: () {},
          ),
          SizedBox(height: 12),
          _buildActionButton(
            icon: Icons.attach_file,
            text: 'Attach to Visit Summary',
            color: Colors.grey[600]!,
            onTap: () {},
          ),
          SizedBox(height: 12),
          _buildActionButton(
            icon: Icons.compare_arrows,
            text: 'Notes Templates',
            color: Colors.deepPurple,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => NoteTemplatePopup(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color == Colors.blue ? Colors.blue : Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color == Colors.blue ? Colors.blue : Colors.grey[200]!,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: color == Colors.blue ? Colors.white : color,
              size: 20,
            ),
            SizedBox(width: 12),
            Text(
              text,
              style: TextStyle(
                color: color == Colors.blue ? Colors.white : color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEncounterNotes() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.medical_services, color: Colors.blue, size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Encounter Notes',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    if (_recentEncounterNotes.isNotEmpty ||
                        _previousEncounterNotes.isNotEmpty)
                      Text(
                        _showPreviousNotes
                            ? 'Recent & Previous Encounters'
                            : 'Recent Encounters',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          // Loading state
          if (_isLoadingRecentNotes ||
              (_showPreviousNotes && _isLoadingPreviousNotes))
            Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(),
              ),
            )
          // No encounter notes at all
          else if (_recentEncounterNotes.isEmpty &&
              (!_showPreviousNotes || _previousEncounterNotes.isEmpty))
            Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(Icons.note_alt_outlined, color: Colors.grey, size: 48),
                    SizedBox(height: 12),
                    Text(
                      _showPreviousNotes
                          ? 'No encounter notes found'
                          : 'No recent encounters',
                      style: TextStyle(
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    if (!_showPreviousNotes && _recentEncounterNotes.isEmpty)
                      Column(
                        children: [
                          SizedBox(height: 8),
                          TextButton(
                            onPressed: () async {
                              setState(() {
                                _showPreviousNotes = true;
                              });
                              await _loadPreviousEncounterNotes();
                            },
                            child: Text('View Previous Notes'),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            )
          // Display encounter notes
          else
            Column(
              children: [
                // Recent notes section (if showing both)
                if (_showPreviousNotes && _recentEncounterNotes.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          'Recent',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      ..._recentEncounterNotes.map(
                        (note) => _buildEncounterNoteItem(note),
                      ),
                      SizedBox(height: 16),
                    ],
                  ),

                // Previous notes section
                if (_showPreviousNotes && _previousEncounterNotes.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          'Previous Encounters',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        height: 300, // Fixed height for scrollable area
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.2),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children:
                                _previousEncounterNotes
                                    .map(
                                      (note) => _buildEncounterNoteItem(note),
                                    )
                                    .toList(),
                          ),
                        ),
                      ),
                    ],
                  ),

                // Just today's notes
                if (!_showPreviousNotes)
                  ..._recentEncounterNotes.map(
                    (note) => _buildEncounterNoteItem(note),
                  ),

                // Show previous notes button (only if we have today's notes and haven't loaded previous yet)
                if (!_showPreviousNotes && _recentEncounterNotes.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Center(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          setState(() {
                            _showPreviousNotes = true;
                          });
                          await _loadPreviousEncounterNotes();
                        },
                        icon: Icon(Icons.history, size: 16),
                        label: Text('View Previous Notes'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.blue,
                          side: BorderSide(color: Colors.blue.withOpacity(0.3)),
                        ),
                      ),
                    ),
                  ),

                // Hide previous notes button (only if showing previous notes)
                if (_showPreviousNotes)
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Center(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _showPreviousNotes = false;
                            _previousEncounterNotes.clear();
                          });
                        },
                        child: Text('Show Recent Only'),
                      ),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildEncounterNoteItem(Map<String, dynamic> note) {
    final encounterType = note['encounterType'] ?? 'Unknown';
    final chiefComplaint = note['chiefComplaint'] ?? 'No complaint recorded';
    final status = note['status'] ?? 'Unknown';
    final createdAt =
        note['createdAt'] != null
            ? DateTime.parse(note['createdAt'])
            : DateTime.now();
    final createdBy = note['createdBy'] as Map<String, dynamic>?;
    final nurseName = createdBy?['name'] ?? 'Unknown Nurse';

    Color statusColor;
    switch (status) {
      case 'submitted':
        statusColor = Colors.orange;
        break;
      case 'signed':
        statusColor = Colors.green;
        break;
      case 'draft':
      default:
        statusColor = Colors.grey;
        break;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: statusColor, width: 4)),
        color: statusColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with type and status
          Row(
            children: [
              Expanded(
                child: Text(
                  encounterType,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),

          // Chief complaint
          Text(
            'Chief Complaint:',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 4),
          Text(
            chiefComplaint.toString(),
            style: TextStyle(fontSize: 13, color: Colors.black87),
          ),
          SizedBox(height: 8),

          // Nurse and timestamp
          Row(
            children: [
              Icon(Icons.person, size: 14, color: Colors.grey),
              SizedBox(width: 4),
              Expanded(
                child: Text(
                  nurseName,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ),
              Icon(Icons.access_time, size: 14, color: Colors.grey),
              SizedBox(width: 4),
              Text(
                DateFormat('MMM d, h:mm a').format(createdAt),
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
