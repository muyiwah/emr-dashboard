import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:schmgtsystem/models/patient_model.dart';
import 'package:schmgtsystem/providers/patient_proviider.dart';
import 'package:schmgtsystem/services/api_service.dart';
import 'package:schmgtsystem/widgets/clinical_notes_popup.dart';
import 'package:intl/intl.dart';

class AllClinicalNotesScreen extends StatefulWidget {
  const AllClinicalNotesScreen({super.key});

  @override
  State<AllClinicalNotesScreen> createState() => _AllClinicalNotesScreenState();
}

class _AllClinicalNotesScreenState extends State<AllClinicalNotesScreen> {
  Patient? _patient;
  List<Map<String, dynamic>> _allNotes = [];
  List<Map<String, dynamic>> _filteredNotes = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  int _currentPage = 1;
  int _totalPages = 1;
  int _totalNotes = 0;
  final int _itemsPerPage = 20;
  final ScrollController _scrollController = ScrollController();

  // Search and filters
  final TextEditingController _searchController = TextEditingController();
  String _selectedNoteType = 'All Note Types';
  String _selectedStatus = 'All Statuses';
  String _selectedDoctor = 'All Doctors';
  Set<String> _expandedNotes = {};

  // Available filters
  final List<String> _noteTypes = [
    'All Note Types',
    'Progress Note',
    'Consultation Note',
    'Discharge Summary',
    'Procedure Note',
    'Operative Note',
    'Emergency Note',
    'Follow-up Note',
    'Initial Assessment',
    'Nursing Note',
    'Other',
  ];

  final List<String> _statuses = [
    'All Statuses',
    'draft',
    'final',
    'signed',
    'amended',
    'voided',
  ];

  @override
  void initState() {
    super.initState();
    _patient = Provider.of<PatientProvider>(context, listen: false).currentPatient;
    _searchController.addListener(_applyFilters);
    _scrollController.addListener(_onScroll);
    _loadAllNotes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Load more when user is 200px from bottom
      if (!_isLoadingMore && _currentPage < _totalPages) {
        _loadMoreNotes();
      }
    }
  }

  Future<void> _loadMoreNotes() async {
    if (_isLoadingMore || _currentPage >= _totalPages) return;

    setState(() {
      _isLoadingMore = true;
    });

    await _loadAllNotes(page: _currentPage + 1);

    if (mounted) {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  Future<void> _loadAllNotes({int page = 1}) async {
    if (_patient?.id == null) return;

    if (page == 1) {
      setState(() {
        _isLoading = true;
      });
    } else {
      setState(() {
        _isLoadingMore = true;
      });
    }

    try {
      final response = await ApiService.getClinicalNotes(
        _patient!.id!,
        page: page,
        limit: _itemsPerPage,
        sortBy: 'createdAt',
        sortOrder: 'desc',
      );

      if (mounted) {
        setState(() {
          if (page == 1) {
            _isLoading = false;
          } else {
            _isLoadingMore = false;
          }
          if (response.success && response.data != null) {
            // The response structure is: {success: true, data: {patientId: ..., clinicalNotes: [...], pagination: {...}}, message: "..."}
            // So we need to access response.data['data']['clinicalNotes']
            if (response.data is Map<String, dynamic>) {
              final responseData = response.data as Map<String, dynamic>;
              
              // Check if response.data has 'data' key (which contains clinicalNotes)
              if (responseData.containsKey('data')) {
                final innerData = responseData['data'] as Map<String, dynamic>?;
                
                if (innerData != null) {
                  final clinicalNotes = innerData['clinicalNotes'] as List<dynamic>?;
                  final pagination = innerData['pagination'] as Map<String, dynamic>?;

                  if (clinicalNotes != null) {
                    if (page == 1) {
                      _allNotes = clinicalNotes.cast<Map<String, dynamic>>();
                    } else {
                      _allNotes.addAll(clinicalNotes.cast<Map<String, dynamic>>());
                    }
                  } else {
                    if (page == 1) {
                      _allNotes = [];
                    }
                  }

                  if (pagination != null) {
                    _totalNotes = pagination['total'] as int? ?? 0;
                    _totalPages = pagination['pages'] as int? ?? 1;
                    _currentPage = pagination['page'] as int? ?? 1;
                  }
                }
              } else {
                // Fallback: check if clinicalNotes is directly in response.data
                final clinicalNotes = responseData['clinicalNotes'] as List<dynamic>?;
                final pagination = responseData['pagination'] as Map<String, dynamic>?;

                if (clinicalNotes != null) {
                  if (page == 1) {
                    _allNotes = clinicalNotes.cast<Map<String, dynamic>>();
                  } else {
                    _allNotes.addAll(clinicalNotes.cast<Map<String, dynamic>>());
                  }
                } else {
                  if (page == 1) {
                    _allNotes = [];
                  }
                }

                if (pagination != null) {
                  _totalNotes = pagination['total'] as int? ?? 0;
                  _totalPages = pagination['pages'] as int? ?? 1;
                  _currentPage = pagination['page'] as int? ?? 1;
                }
              }
            }

            _applyFilters();
          } else {
            if (page == 1) {
              _allNotes = [];
              _filteredNotes = [];
            }
          }
        });
      }
    } catch (e) {
      print('Error loading all notes: $e');
      if (mounted) {
        setState(() {
          if (page == 1) {
            _isLoading = false;
          } else {
            _isLoadingMore = false;
          }
          if (page == 1) {
            _allNotes = [];
            _filteredNotes = [];
          }
        });
      }
    }
  }

  void _applyFilters() {
    List<Map<String, dynamic>> filtered = List.from(_allNotes);

    // Apply search filter
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered.where((note) {
        final content = (note['content'] as String? ?? '').toLowerCase();
        final noteType = (note['noteType'] as String? ?? '').toLowerCase();
        final title = (note['title'] as String? ?? '').toLowerCase();
        final subjective = (note['subjective'] as String? ?? '').toLowerCase();
        final objective = (note['objective'] as String? ?? '').toLowerCase();
        final assessment = (note['assessment'] as String? ?? '').toLowerCase();
        final plan = (note['plan'] as String? ?? '').toLowerCase();

        return content.contains(query) ||
            noteType.contains(query) ||
            title.contains(query) ||
            subjective.contains(query) ||
            objective.contains(query) ||
            assessment.contains(query) ||
            plan.contains(query);
      }).toList();
    }

    // Apply note type filter
    if (_selectedNoteType != 'All Note Types') {
      filtered = filtered.where((note) {
        return (note['noteType'] as String? ?? '') == _selectedNoteType;
      }).toList();
    }

    // Apply status filter
    if (_selectedStatus != 'All Statuses') {
      filtered = filtered.where((note) {
        return (note['status'] as String? ?? '') == _selectedStatus;
      }).toList();
    }

    // Apply doctor filter
    if (_selectedDoctor != 'All Doctors') {
      filtered = filtered.where((note) {
        final createdBy = note['createdBy'] as Map<String, dynamic>?;
        if (createdBy != null && createdBy['name'] != null) {
          return (createdBy['name'] as String) == _selectedDoctor;
        }
        return false;
      }).toList();
    }

    setState(() {
      _filteredNotes = filtered;
    });
  }

  void _toggleNoteExpansion(String noteId) {
    setState(() {
      if (_expandedNotes.contains(noteId)) {
        _expandedNotes.remove(noteId);
      } else {
        _expandedNotes.add(noteId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF6366F1),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'All Clinical Notes',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ClinicalNotePopup(
                    onNoteCreated: () {
                      _loadAllNotes(page: 1);
                    },
                  );
                },
              );
            },
            tooltip: 'Add New Note',
          ),
        ],
      ),
      body: Column(
        children: [
          // Patient Header
          if (_patient != null)
            Container(
              padding: EdgeInsets.all(16),
              color: Colors.white,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Color(0xFF6366F1).withOpacity(0.1),
                    child: Icon(
                      Icons.person,
                      color: Color(0xFF6366F1),
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _patient?.name ?? 'Unknown Patient',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          'MRN: ${_patient?.mrn ?? 'N/A'}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Color(0xFF6366F1).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_totalNotes} Notes',
                      style: TextStyle(
                        color: Color(0xFF6366F1),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Search and Filters
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                // Search bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search clinical notes...',
                    prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Color(0xFF6366F1), width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                ),
                SizedBox(height: 12),

                // Filter chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip(
                        'Note Type',
                        _selectedNoteType,
                        _noteTypes,
                        (value) {
                          setState(() {
                            _selectedNoteType = value;
                          });
                          _applyFilters();
                        },
                      ),
                      SizedBox(width: 8),
                      _buildFilterChip(
                        'Status',
                        _selectedStatus,
                        _statuses,
                        (value) {
                          setState(() {
                            _selectedStatus = value;
                          });
                          _applyFilters();
                        },
                      ),
                      SizedBox(width: 8),
                      _buildFilterChip(
                        'Doctor',
                        _selectedDoctor,
                        ['All Doctors'], // This would be populated from actual data
                        (value) {
                          setState(() {
                            _selectedDoctor = value;
                          });
                          _applyFilters();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Notes List - Fixed Height Scrollable Container
          Container(
            height: MediaQuery.of(context).size.height * 0.5, // Fixed height: 50% of screen
            padding: EdgeInsets.all(16),
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _filteredNotes.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.note_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No clinical notes found',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Try adjusting your search or filters',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () => _loadAllNotes(page: 1),
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.zero,
                          itemCount: _filteredNotes.length + (_isLoadingMore ? 1 : 0) + (_currentPage < _totalPages ? 1 : 0),
                          itemBuilder: (context, index) {
                            // Loading indicator at bottom
                            if (index == _filteredNotes.length && _isLoadingMore) {
                              return Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            
                            // Load more button (if not loading and more pages available)
                            if (index == _filteredNotes.length && !_isLoadingMore && _currentPage < _totalPages) {
                              return Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _loadMoreNotes();
                                    },
                                    child: Text('Load More'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF6366F1),
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            }

                            final note = _filteredNotes[index];
                            final noteId = note['id'] as String? ?? index.toString();
                            final isExpanded = _expandedNotes.contains(noteId);

                            return Padding(
                              padding: EdgeInsets.only(bottom: 16),
                              child: _buildNoteCard(note, isExpanded, noteId),
                            );
                          },
                        ),
                      ),
          ),

          // Pagination Info
          if (_filteredNotes.isNotEmpty && !_isLoading)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Showing ${_filteredNotes.length} of ${_totalNotes} notes',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.chevron_left),
                        onPressed: _currentPage > 1
                            ? () => _loadAllNotes(page: _currentPage - 1)
                            : null,
                      ),
                      Text(
                        'Page $_currentPage of $_totalPages',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.chevron_right),
                        onPressed: _currentPage < _totalPages
                            ? () => _loadMoreNotes()
                            : null,
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    String selectedValue,
    List<String> options,
    Function(String) onChanged,
  ) {
    return PopupMenuButton<String>(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selectedValue != options[0]
              ? Color(0xFF6366F1).withOpacity(0.1)
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selectedValue != options[0]
                ? Color(0xFF6366F1)
                : Colors.grey[300]!,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selectedValue,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: selectedValue != options[0]
                    ? Color(0xFF6366F1)
                    : Colors.grey[700],
              ),
            ),
            SizedBox(width: 4),
            Icon(
              Icons.arrow_drop_down,
              size: 18,
              color: selectedValue != options[0]
                  ? Color(0xFF6366F1)
                  : Colors.grey[600],
            ),
          ],
        ),
      ),
      itemBuilder: (context) => options.map((option) {
        return PopupMenuItem(
          value: option,
          child: Row(
            children: [
              if (option == selectedValue)
                Icon(Icons.check, size: 18, color: Color(0xFF6366F1))
              else
                SizedBox(width: 18),
              SizedBox(width: 8),
              Text(option),
            ],
          ),
        );
      }).toList(),
      onSelected: onChanged,
    );
  }

  Widget _buildNoteCard(
    Map<String, dynamic> note,
    bool isExpanded,
    String noteId,
  ) {
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
    String statusText = status.toUpperCase();
    if (status == 'signed') {
      statusColor = Colors.green;
    } else if (status == 'final') {
      statusColor = Colors.blue;
    } else if (status == 'draft') {
      statusColor = Colors.orange;
    } else if (status == 'amended') {
      statusColor = Colors.purple;
    } else if (status == 'voided') {
      statusColor = Colors.red;
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

    // Get content
    final content = note['content'] as String? ?? '';
    final hasSubjective =
        note['subjective'] != null && (note['subjective'] as String).isNotEmpty;
    final hasObjective =
        note['objective'] != null && (note['objective'] as String).isNotEmpty;
    final hasAssessment =
        note['assessment'] != null && (note['assessment'] as String).isNotEmpty;
    final hasPlan = note['plan'] != null && (note['plan'] as String).isNotEmpty;
    final isSoapNote = hasSubjective || hasObjective || hasAssessment || hasPlan;

    return Container(
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
        children: [
          // Header
          InkWell(
            onTap: () => _toggleNoteExpansion(noteId),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color(0xFF6366F1).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.note,
                      color: Color(0xFF6366F1),
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                noteType,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                statusText,
                                style: TextStyle(
                                  color: statusColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(
                          dateStr,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'By: $doctorStr',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.grey[600],
                  ),
                ],
              ),
            ),
          ),

          // Expanded content
          if (isExpanded)
            Divider(height: 1),
          if (isExpanded)
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isSoapNote) ...[
                    if (hasSubjective)
                      _buildSOAPSection(
                        'S - Subjective',
                        note['subjective'] as String,
                        Colors.blue,
                      ),
                    if (hasObjective) ...[
                      SizedBox(height: 12),
                      _buildSOAPSection(
                        'O - Objective',
                        note['objective'] as String,
                        Colors.cyan,
                      ),
                    ],
                    if (hasAssessment) ...[
                      SizedBox(height: 12),
                      _buildSOAPSection(
                        'A - Assessment',
                        note['assessment'] as String,
                        Colors.orange,
                      ),
                    ],
                    if (hasPlan) ...[
                      SizedBox(height: 12),
                      _buildSOAPSection(
                        'P - Plan',
                        note['plan'] as String,
                        Colors.green,
                      ),
                    ],
                  ] else if (content.isNotEmpty) ...[
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(color: Colors.blue, width: 4),
                        ),
                        color: Colors.blue.withOpacity(0.05),
                      ),
                      child: Text(
                        content,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[800],
                          height: 1.5,
                        ),
                      ),
                    ),
                  ] else ...[
                    Text(
                      'No content available',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
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
        border: Border(
          left: BorderSide(color: color, width: 4),
        ),
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
