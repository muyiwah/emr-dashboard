import 'package:flutter/material.dart';
import 'dart:async';
import '../services/api_service.dart';
import '../models/lab_test_request_model.dart';
import 'lab_test_result_entry_screen.dart';

class LabTestRequests extends StatefulWidget {
  @override
  _LabTestRequestsState createState() => _LabTestRequestsState();
}

class _LabTestRequestsState extends State<LabTestRequests> {
  String selectedStatus = 'All';
  String selectedPriority = 'All';
  String selectedDepartment = 'All Departments';
  bool isListView = true;

  // Data state
  OverviewMetrics? overviewMetrics;
  List<LabTestRequest> requests = [];
  Pagination? pagination;
  List<Department> departments = [];

  // Loading and error states
  bool isLoadingOverview = false;
  bool isLoadingRequests = false;
  bool isLoadingDepartments = false;
  String? errorMessage;

  // Search
  final TextEditingController searchController = TextEditingController();
  Timer? _searchDebounce;

  // Current page
  int currentPage = 1;
  final int itemsPerPage = 20;

  @override
  void initState() {
    super.initState();
    _loadData();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_searchDebounce?.isActive ?? false) _searchDebounce!.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      _loadRequests();
    });
  }

  Future<void> _loadData() async {
    await Future.wait([_loadOverview(), _loadDepartments(), _loadRequests()]);
  }

  Future<void> _loadOverview() async {
    setState(() {
      isLoadingOverview = true;
      errorMessage = null;
    });

    try {
      final response = await ApiService.getLabTestRequestsOverview();

      if (response.success && response.data != null) {
        final responseData = response.data as Map<String, dynamic>;
        final data = responseData['data'] as Map<String, dynamic>?;

        if (data != null) {
          setState(() {
            overviewMetrics = OverviewMetrics.fromJson(data);
            isLoadingOverview = false;
          });
        } else {
          setState(() {
            isLoadingOverview = false;
            errorMessage = 'Failed to load overview metrics';
          });
        }
      } else {
        setState(() {
          isLoadingOverview = false;
          errorMessage = response.error ?? 'Failed to load overview metrics';
        });
      }
    } catch (e) {
      setState(() {
        isLoadingOverview = false;
        errorMessage = 'Error loading overview: ${e.toString()}';
      });
    }
  }

  Future<void> _loadDepartments() async {
    setState(() {
      isLoadingDepartments = true;
    });

    try {
      final response = await ApiService.getLabTestRequestDepartments();

      if (response.success && response.data != null) {
        final responseData = response.data as Map<String, dynamic>;
        final data = responseData['data'] as Map<String, dynamic>?;

        if (data != null) {
          final departmentsList =
              (data['departments'] as List<dynamic>?)
                  ?.map((dept) => Department.fromJson(dept))
                  .toList() ??
              [];

          setState(() {
            departments = departmentsList;
            isLoadingDepartments = false;
          });
        } else {
          setState(() {
            isLoadingDepartments = false;
          });
        }
      } else {
        setState(() {
          isLoadingDepartments = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoadingDepartments = false;
      });
    }
  }

  Future<void> _loadRequests({bool resetPage = false}) async {
    if (resetPage) {
      currentPage = 1;
    }

    setState(() {
      isLoadingRequests = true;
      errorMessage = null;
    });

    try {
      // Map UI filter values to API values
      String? apiStatus;
      if (selectedStatus != 'All') {
        apiStatus =
            selectedStatus; // 'New', 'In Progress', 'Completed', 'On Hold', 'Cancelled'
      }

      String? apiPriority;
      if (selectedPriority != 'All') {
        apiPriority = selectedPriority; // 'High', 'Medium', 'Low'
      }

      String? apiDepartment;
      if (selectedDepartment != 'All Departments') {
        apiDepartment = selectedDepartment;
      }

      final response = await ApiService.getLabTestRequests(
        page: currentPage,
        limit: itemsPerPage,
        status: apiStatus,
        priority: apiPriority,
        department: apiDepartment,
        search: searchController.text.isNotEmpty ? searchController.text : null,
      );

      if (response.success && response.data != null) {
        final responseData = response.data as Map<String, dynamic>;
        final data = responseData['data'] as Map<String, dynamic>?;

        if (data != null) {
          final requestsList =
              (data['requests'] as List<dynamic>?)
                  ?.map((req) => LabTestRequest.fromJson(req))
                  .toList() ??
              [];

          final paginationData = data['pagination'] as Map<String, dynamic>?;

          setState(() {
            requests = requestsList;
            pagination =
                paginationData != null
                    ? Pagination.fromJson(paginationData)
                    : null;
            isLoadingRequests = false;
          });
        } else {
          setState(() {
            isLoadingRequests = false;
            errorMessage = 'Failed to load requests';
          });
        }
      } else {
        setState(() {
          isLoadingRequests = false;
          errorMessage = response.error ?? 'Failed to load requests';
        });
      }
    } catch (e) {
      setState(() {
        isLoadingRequests = false;
        errorMessage = 'Error loading requests: ${e.toString()}';
      });
    }
  }

  void _onFilterChanged() {
    _loadRequests(resetPage: true);
  }

  Future<void> _exportRequests() async {
    try {
      String? apiStatus;
      if (selectedStatus != 'All') {
        apiStatus = selectedStatus;
      }

      String? apiPriority;
      if (selectedPriority != 'All') {
        apiPriority = selectedPriority;
      }

      String? apiDepartment;
      if (selectedDepartment != 'All Departments') {
        apiDepartment = selectedDepartment;
      }

      final response = await ApiService.exportLabTestRequests(
        format: 'csv',
        status: apiStatus,
        priority: apiPriority,
        department: apiDepartment,
        search: searchController.text.isNotEmpty ? searchController.text : null,
      );

      if (response.success) {
        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Export started. File will download shortly.'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Failed to export: ${response.error ?? "Unknown error"}',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error exporting: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(16),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header Bar
            Container(
              height: 72,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                border: Border(
                  bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
                ),
              ),
              child: Row(
                children: [
                  // Lab icon
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Color(0xFF3B82F6),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(
                      Icons.science_outlined,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  SizedBox(width: 12),
                  // Title
                  Text(
                    'Lab Test Requests Inbox',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF111827),
                      letterSpacing: -0.5,
                    ),
                  ),
                  Spacer(),
                  // Notification badge
                  if (overviewMetrics != null &&
                      overviewMetrics!.metrics.urgent > 0)
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Color(0xFFDC2626),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          overviewMetrics!.metrics.urgent > 99
                              ? '99+'
                              : overviewMetrics!.metrics.urgent.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  SizedBox(width: 16),
                  // User avatar
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Color(0xFF3B82F6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(Icons.person, color: Colors.white, size: 18),
                  ),
                  SizedBox(width: 16),
                  // Close button
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(
                      Icons.close,
                      color: Color(0xFF6B7280),
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            // Subtitle
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Text(
                'View and manage all incoming test requests from physicians',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            // Main content
            Expanded(
              child: Row(
                children: [
                  // Left Sidebar
                  Container(
                    width: 320,
                    decoration: BoxDecoration(
                      color: Color(0xFFF9FAFB),
                      border: Border(
                        right: BorderSide(color: Color(0xFFE5E7EB), width: 1),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Today's Overview
                        Padding(
                          padding: EdgeInsets.fromLTRB(24, 24, 24, 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Today\'s Overview',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF111827),
                                ),
                              ),
                              GestureDetector(
                                onTap: _loadOverview,
                                child: Icon(
                                  Icons.refresh,
                                  size: 18,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Overview cards
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child:
                              isLoadingOverview
                                  ? Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(20),
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                  : overviewMetrics != null
                                  ? Column(
                                    children: [
                                      Row(
                                        children: [
                                          _buildOverviewCard(
                                            overviewMetrics!
                                                .metrics
                                                .totalRequests
                                                .toString(),
                                            'Total Requests',
                                            Color(0xFFDBEAFE),
                                            Color(0xFF3B82F6),
                                          ),
                                          SizedBox(width: 12),
                                          _buildOverviewCard(
                                            overviewMetrics!.metrics.urgent
                                                .toString(),
                                            'Urgent',
                                            Color(0xFFFEE2E2),
                                            Color(0xFFDC2626),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 12),
                                      Row(
                                        children: [
                                          _buildOverviewCard(
                                            overviewMetrics!.metrics.inProgress
                                                .toString(),
                                            'In Progress',
                                            Color(0xFFFED7AA),
                                            Color(0xFFEA580C),
                                          ),
                                          SizedBox(width: 12),
                                          _buildOverviewCard(
                                            overviewMetrics!.metrics.completed
                                                .toString(),
                                            'Completed',
                                            Color(0xFFD1FAE5),
                                            Color(0xFF059669),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                  : Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(20),
                                      child: Text(
                                        'Failed to load overview',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ),
                        ),
                        SizedBox(height: 32),
                        // Filters
                        Padding(
                          padding: EdgeInsets.fromLTRB(24, 0, 24, 16),
                          child: Text(
                            'Filters',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF111827),
                            ),
                          ),
                        ),
                        // Filter dropdowns
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            children: [
                              _buildDropdownFilter(
                                'Status',
                                selectedStatus,
                                [
                                  'All',
                                  'New',
                                  'In Progress',
                                  'Completed',
                                  'On Hold',
                                  'Cancelled',
                                ],
                                (value) {
                                  setState(() {
                                    selectedStatus = value!;
                                  });
                                  _onFilterChanged();
                                },
                              ),
                              SizedBox(height: 16),
                              _buildDropdownFilter(
                                'Priority',
                                selectedPriority,
                                ['All', 'High', 'Medium', 'Low'],
                                (value) {
                                  setState(() {
                                    selectedPriority = value!;
                                  });
                                  _onFilterChanged();
                                },
                              ),
                              SizedBox(height: 16),
                              _buildDropdownFilter(
                                'Department',
                                selectedDepartment,
                                [
                                  'All Departments',
                                  ...departments
                                      .map((d) => d.displayName)
                                      .toList(),
                                ],
                                (value) {
                                  setState(() {
                                    selectedDepartment = value!;
                                  });
                                  _onFilterChanged();
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24),
                        // Search
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Color(0xFFD1D5DB)),
                            ),
                            child: TextField(
                              controller: searchController,
                              decoration: InputDecoration(
                                hintText: 'Search patient, ID, or test...',
                                hintStyle: TextStyle(
                                  color: Color(0xFF9CA3AF),
                                  fontSize: 14,
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Color(0xFF9CA3AF),
                                  size: 18,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                  // Main Content Area
                  Expanded(
                    child: Column(
                      children: [
                        // Content Header
                        Container(
                          height: 72,
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xFFE5E7EB),
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Lab Requests (${pagination?.totalItems ?? requests.length})',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF111827),
                                ),
                              ),
                              Spacer(),
                              // View toggle
                              Container(
                                height: 36,
                                decoration: BoxDecoration(
                                  color: Color(0xFFF3F4F6),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  children: [
                                    _buildViewToggle(
                                      Icons.format_list_bulleted,
                                      isListView,
                                      () {
                                        setState(() {
                                          isListView = true;
                                        });
                                      },
                                    ),
                                    _buildViewToggle(
                                      Icons.grid_view,
                                      !isListView,
                                      () {
                                        setState(() {
                                          isListView = false;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 16),
                              // Export button
                              GestureDetector(
                                onTap: _exportRequests,
                                child: Container(
                                  height: 36,
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Color(0xFFD1D5DB),
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.file_download_outlined,
                                        size: 16,
                                        color: Color(0xFF374151),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Export',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF374151),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Lab Requests List
                        Expanded(
                          child: Container(
                            color: Color(0xFFF9FAFB),
                            child:
                                isLoadingRequests
                                    ? Center(child: CircularProgressIndicator())
                                    : errorMessage != null
                                    ? Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.error_outline,
                                            color: Colors.red,
                                            size: 48,
                                          ),
                                          SizedBox(height: 16),
                                          Text(
                                            errorMessage!,
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 14,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(height: 16),
                                          ElevatedButton(
                                            onPressed: () {
                                              _loadRequests();
                                            },
                                            child: Text('Retry'),
                                          ),
                                        ],
                                      ),
                                    )
                                    : requests.isEmpty
                                    ? Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.inbox_outlined,
                                            color: Color(0xFF9CA3AF),
                                            size: 64,
                                          ),
                                          SizedBox(height: 16),
                                          Text(
                                            'No lab test requests found',
                                            style: TextStyle(
                                              color: Color(0xFF6B7280),
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                    : RefreshIndicator(
                                      onRefresh: () => _loadRequests(),
                                      child: ListView(
                                        padding: EdgeInsets.all(24),
                                        children: [
                                          ...requests.map((request) {
                                            return Column(
                                              children: [
                                                _buildLabRequestItemFromModel(
                                                  request,
                                                ),
                                                SizedBox(height: 16),
                                              ],
                                            );
                                          }).toList(),
                                          // Pagination controls
                                          if (pagination != null &&
                                              pagination!.totalPages > 1)
                                            _buildPaginationControls(),
                                        ],
                                      ),
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
      ),
    );
  }

  Widget _buildOverviewCard(
    String number,
    String label,
    Color bgColor,
    Color textColor,
  ) {
    return Expanded(
      child: Container(
        height: 79,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              number,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: textColor,
                height: 1.0,
              ),
            ),
            SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownFilter(
    String label,
    String value,
    List<String> options,
    Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF111827),
          ),
        ),
        SizedBox(height: 8),
        Container(
          height: 40,
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Color(0xFFD1D5DB)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              onChanged: onChanged,
              isExpanded: true,
              style: TextStyle(fontSize: 14, color: Color(0xFF374151)),
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: Color(0xFF6B7280),
                size: 20,
              ),
              items:
                  options.map((String option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildViewToggle(IconData icon, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isActive ? Color(0xFF3B82F6) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isActive ? Colors.white : Color(0xFF6B7280),
        ),
      ),
    );
  }

  Color _hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  Widget _buildLabRequestItemFromModel(LabTestRequest request) {
    final statusColor = _hexToColor(request.statusColor);
    final priorityColor = _hexToColor(request.priorityColor);

    final testChips =
        request.tests.map((test) {
          return {
            'name': test.testName,
            'color': _hexToColor(test.displayColor),
          };
        }).toList();

    return _buildLabRequestItem(
      request.patient.name,
      request.patient.mrn,
      request.patient.demographics ??
          '${request.patient.gender ?? ""}, ${request.patient.age ?? ""}',
      testChips,
      request.priorityDisplay,
      request.statusDisplay,
      request.orderingDoctor.display,
      request.timeAgo,
      statusColor,
      requestId: request.id,
      priorityColor: priorityColor,
    );
  }

  Widget _buildPaginationControls() {
    if (pagination == null) return SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (pagination!.hasPrevious)
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  currentPage--;
                });
                _loadRequests();
              },
              icon: Icon(Icons.chevron_left, size: 18),
              label: Text('Previous'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Color(0xFF374151),
                side: BorderSide(color: Color(0xFFD1D5DB)),
              ),
            ),
          SizedBox(width: 16),
          Text(
            'Page ${pagination!.currentPage} of ${pagination!.totalPages}',
            style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
          ),
          SizedBox(width: 16),
          if (pagination!.hasNext)
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  currentPage++;
                });
                _loadRequests();
              },
              icon: Icon(Icons.chevron_right, size: 18),
              label: Text('Next'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Color(0xFF374151),
                side: BorderSide(color: Color(0xFFD1D5DB)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLabRequestItem(
    String name,
    String id,
    String demographics,
    List<Map<String, dynamic>> tests,
    String priority,
    String status,
    String doctor,
    String time,
    Color statusColor, {
    String? requestId,
    Color? priorityColor,
  }) {
    final effectivePriorityColor = priorityColor ?? statusColor;

    return GestureDetector(
      onTap:
          requestId != null
              ? () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            LabTestRequestDetailScreen(requestId: requestId),
                  ),
                );
              }
              : null,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Color(0xFFE5E7EB)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status indicator dot
            Container(
              width: 8,
              height: 8,
              margin: EdgeInsets.only(top: 6),
              decoration: BoxDecoration(
                color: statusColor,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 16),
            // Patient info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Patient name and details
                  Row(
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF111827),
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'ID: $id',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        demographics,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  // Test chips
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children:
                        tests.map((test) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: test['color'],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              test['name'],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF374151),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ],
              ),
            ),
            // Status and metadata
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Priority and status badges
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: effectivePriorityColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        priority,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF374151),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                // Doctor info
                Text(
                  doctor,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 4),
                // Time
                Text(
                  time,
                  style: TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Lab Test Request Detail Screen
class LabTestRequestDetailScreen extends StatefulWidget {
  final String requestId;

  const LabTestRequestDetailScreen({Key? key, required this.requestId})
    : super(key: key);

  @override
  _LabTestRequestDetailScreenState createState() =>
      _LabTestRequestDetailScreenState();
}

class _LabTestRequestDetailScreenState
    extends State<LabTestRequestDetailScreen> {
  LabTestRequest? _request;
  bool _isLoading = true;
  String? _errorMessage;
  Map<String, bool> _updatingTestStatus =
      {}; // Track which tests are being updated

  // Valid status values for test items
  final List<String> _testStatuses = [
    'New',
    'Sample Collected',
    'Sample Processed',
    'Result Entered',
    'Result Verified',
    'Cancelled',
    'On Hold',
  ];

  @override
  void initState() {
    super.initState();
    _loadRequestDetails();
  }

  Future<void> _loadRequestDetails({bool silent = false}) async {
    if (!silent) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final response = await ApiService.getLabTestRequestById(widget.requestId);

      if (response.success && response.data != null) {
        final responseData = response.data as Map<String, dynamic>;
        final data = responseData['data'] as Map<String, dynamic>?;

        if (data != null) {
          setState(() {
            _request = LabTestRequest.fromJson(data);
            if (!silent) {
              _isLoading = false;
            }
          });
        } else {
          setState(() {
            if (!silent) {
              _isLoading = false;
            }
            _errorMessage = 'Failed to load request details';
          });
        }
      } else {
        setState(() {
          if (!silent) {
            _isLoading = false;
          }
          _errorMessage = response.error ?? 'Failed to load request details';
        });
      }
    } catch (e) {
      setState(() {
        if (!silent) {
          _isLoading = false;
        }
        _errorMessage = 'Error loading request: ${e.toString()}';
      });
    }
  }

  Color _hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  String _formatDateTime(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.isEmpty) return 'N/A';
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateTimeString;
    }
  }

  // Helper method to update a test item's status in the request
  LabTestRequest? _updateTestItemStatusInRequest(
    LabTestRequest request,
    String testItemId,
    String newStatus,
  ) {
    final updatedTests =
        request.tests.map((test) {
          if (test.id == testItemId) {
            return TestItem(
              id: test.id,
              testCatalogId: test.testCatalogId,
              testCode: test.testCode,
              testName: test.testName,
              specimenType: test.specimenType,
              itemStatus: newStatus,
              displayColor: test.displayColor,
            );
          }
          return test;
        }).toList();

    return LabTestRequest(
      id: request.id,
      requestNumber: request.requestNumber,
      patient: request.patient,
      tests: updatedTests,
      priority: request.priority,
      priorityDisplay: request.priorityDisplay,
      priorityColor: request.priorityColor,
      status: request.status,
      statusDisplay: request.statusDisplay,
      statusColor: request.statusColor,
      orderingDoctor: request.orderingDoctor,
      requestDate: request.requestDate,
      requestedAt: request.requestedAt,
      createdAt: request.createdAt,
      timeAgo: request.timeAgo,
      timeAgoSeconds: request.timeAgoSeconds,
      clinicalIndication: request.clinicalIndication,
      notes: request.notes,
      specimenCollected: request.specimenCollected,
      specimenCollectedAt: request.specimenCollectedAt,
      processingStartedAt: request.processingStartedAt,
      completedAt: request.completedAt,
    );
  }

  Future<void> _updateTestStatus(
    String testItemId,
    String newStatus, {
    String? notes,
  }) async {
    // Store the old status and request in case we need to revert
    String? oldStatus;
    LabTestRequest? oldRequest;
    if (_request != null) {
      oldRequest = _request;
      final testItem = _request!.tests.firstWhere(
        (test) => test.id == testItemId,
        orElse: () => _request!.tests.first,
      );
      oldStatus = testItem.itemStatus;
    }

    setState(() {
      _updatingTestStatus[testItemId] = true;
      // Optimistically update the local state
      if (_request != null) {
        _request = _updateTestItemStatusInRequest(
          _request!,
          testItemId,
          newStatus,
        );
      }
    });

    try {
      final apiStatus = _mapStatusToApiValue(newStatus);
      final isCollected = apiStatus == 'Collected';
      // Update individual test item status
      final response = await ApiService.updateTestItemStatus(
        widget.requestId,
        testItemId,
        itemStatus: apiStatus,
        notes: notes,
        specimenCollected: isCollected ? true : null,
        specimenCollectedAt:
            isCollected ? DateTime.now().toUtc().toIso8601String() : null,
      );

      if (response.success) {
        // Reload request details to get updated status from server
        await _loadRequestDetails(silent: true);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Test status updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        // Revert to old status on error
        if (mounted && oldRequest != null && oldStatus != null) {
          setState(() {
            _request = oldRequest;
          });
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Failed to update status: ${response.error ?? "Unknown error"}',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      // Revert to old status on error
      if (mounted && oldRequest != null) {
        setState(() {
          _request = oldRequest;
        });
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating status: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _updatingTestStatus[testItemId] = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9FAFB),
      appBar: AppBar(
        title: Text('Lab Test Request Details'),
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF111827),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : _errorMessage != null
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 48),
                    SizedBox(height: 16),
                    Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadRequestDetails,
                      child: Text('Retry'),
                    ),
                  ],
                ),
              )
              : _request == null
              ? Center(child: Text('Request not found'))
              : SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Card
                    _buildHeaderCard(),
                    SizedBox(height: 16),

                    // Patient Information
                    _buildSectionCard(
                      'Patient Information',
                      Icons.person,
                      _buildPatientInfo(),
                    ),
                    SizedBox(height: 16),

                    // Request Information
                    _buildSectionCard(
                      'Request Information',
                      Icons.info_outline,
                      _buildRequestInfo(),
                    ),
                    SizedBox(height: 16),

                    // Tests
                    _buildSectionCard(
                      'Requested Tests',
                      Icons.science,
                      _buildTestsList(),
                    ),
                    SizedBox(height: 16),

                    // Ordering Doctor
                    _buildSectionCard(
                      'Ordering Doctor',
                      Icons.local_hospital,
                      _buildDoctorInfo(),
                    ),
                    SizedBox(height: 16),

                    // Clinical Information
                    if (_request!.clinicalIndication != null ||
                        _request!.notes != null)
                      _buildSectionCard(
                        'Clinical Information',
                        Icons.medical_services,
                        _buildClinicalInfo(),
                      ),
                    if (_request!.clinicalIndication != null ||
                        _request!.notes != null)
                      SizedBox(height: 16),

                    // Status Timeline
                    _buildSectionCard(
                      'Status Timeline',
                      Icons.timeline,
                      _buildStatusTimeline(),
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _buildHeaderCard() {
    final statusColor = _hexToColor(_request!.statusColor);
    final priorityColor = _hexToColor(_request!.priorityColor);

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFF3B82F6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.science_outlined,
                  color: Color(0xFF3B82F6),
                  size: 24,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _request!.requestNumber,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Requested ${_request!.timeAgo}',
                      style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              _buildStatusBadge(_request!.priorityDisplay, priorityColor, true),
              SizedBox(width: 8),
              _buildStatusBadge(_request!.statusDisplay, statusColor, false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String label, Color color, bool isPriority) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isPriority ? color : color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isPriority ? Colors.white : color,
        ),
      ),
    );
  }

  Widget _buildSectionCard(String title, IconData icon, Widget content) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Color(0xFF3B82F6), size: 20),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          content,
        ],
      ),
    );
  }

  Widget _buildPatientInfo() {
    return Column(
      children: [
        _buildInfoRow('Name', _request!.patient.name),
        _buildInfoRow('MRN', _request!.patient.mrn),
        _buildInfoRow(
          'Demographics',
          _request!.patient.demographics ??
              '${_request!.patient.gender ?? ""}, ${_request!.patient.age ?? ""}',
        ),
      ],
    );
  }

  Widget _buildRequestInfo() {
    return Column(
      children: [
        _buildInfoRow('Request Date', _formatDateTime(_request!.requestDate)),
        _buildInfoRow('Requested At', _formatDateTime(_request!.requestedAt)),
        _buildInfoRow('Created At', _formatDateTime(_request!.createdAt)),
      ],
    );
  }

  Widget _buildTestsList() {
    if (_request!.tests.isEmpty) {
      return Text('No tests found', style: TextStyle(color: Color(0xFF6B7280)));
    }

    return Column(
      children:
          _request!.tests.map((test) {
            final statusColor = _getStatusColor(test.itemStatus);

            return Container(
              margin: EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: statusColor.withOpacity(0.15),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  // Status indicator bar (subtle)
                  Container(
                    width: 4,
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.6),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Test name
                          Text(
                            test.testName,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF111827),
                            ),
                          ),
                          SizedBox(height: 12),
                          // Test details chips
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: [
                              if (test.testCode.isNotEmpty)
                                _buildEnhancedTestChip(
                                  'Code: ${test.testCode}',
                                  Color(0xFFEEF2FF),
                                  Color(0xFF6366F1),
                                  Icons.tag,
                                ),
                              if (test.specimenType != null)
                                _buildEnhancedTestChip(
                                  'Specimen: ${test.specimenType}',
                                  Color(0xFFF0FDF4),
                                  Color(0xFF059669),
                                  Icons.water_drop,
                                ),
                            ],
                          ),
                          SizedBox(height: 12),
                          // Status section
                          Row(
                            children: [
                              _buildTestStatusChip(test.itemStatus),
                              SizedBox(width: 8),
                              // Status dropdown
                              _buildTestStatusDropdown(test),
                            ],
                          ),
                          SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: OutlinedButton.icon(
                              onPressed: () async {
                                final saved = await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder:
                                        (context) => LabTestResultEntryScreen(
                                          request: _request!,
                                          test: test,
                                        ),
                                  ),
                                );
                                if (saved == true && mounted) {
                                  await _loadRequestDetails(silent: true);
                                }
                              },
                              icon: Icon(Icons.edit_note, size: 18),
                              label: Text('Enter Result'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Color(0xFF2563EB),
                                side: BorderSide(color: Color(0xFFBFDBFE)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }

  Color _getStatusColor(String status) {
    final lowerStatus = status.toLowerCase();
    if (lowerStatus.contains('verified') || lowerStatus == 'completed') {
      return Color(0xFF059669); // Green - Result Verified
    } else if (lowerStatus.contains('entered')) {
      return Color(0xFF10B981); // Light Green - Result Entered
    } else if (lowerStatus.contains('processed')) {
      return Color(0xFF3B82F6); // Blue - Sample Processed
    } else if (lowerStatus.contains('collected')) {
      return Color(0xFF6366F1); // Indigo - Sample Collected
    } else if (lowerStatus.contains('cancelled') ||
        lowerStatus.contains('canceled')) {
      return Color(0xFFDC2626); // Red - Cancelled
    } else if (lowerStatus.contains('hold')) {
      return Color(0xFFF59E0B); // Amber - On Hold
    } else {
      return Color(0xFF6B7280); // Gray - New/Pending
    }
  }

  Widget _buildEnhancedTestChip(
    String label,
    Color bgColor,
    Color textColor,
    IconData icon,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: textColor.withOpacity(0.7)),
          SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: textColor.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestStatusDropdown(TestItem test) {
    final isUpdating = _updatingTestStatus[test.id] ?? false;
    // Map current status to dropdown value (handle case variations)
    String currentStatus = _mapStatusToDropdownValue(test.itemStatus);
    final statusColor = _getStatusColor(test.itemStatus);

    return Container(
      height: 28,
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: statusColor.withOpacity(0.2), width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentStatus,
          isExpanded: false,
          isDense: true,
          icon:
              isUpdating
                  ? SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF3B82F6),
                      ),
                    ),
                  )
                  : Icon(
                    Icons.arrow_drop_down,
                    size: 18,
                    color: Color(0xFF6B7280),
                  ),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
          items:
              _testStatuses.map((status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Text(status, style: TextStyle(fontSize: 11)),
                );
              }).toList(),
          onChanged:
              isUpdating
                  ? null
                  : (String? newStatus) {
                    if (newStatus != null && newStatus != currentStatus) {
                      _showStatusUpdateDialog(test, newStatus);
                    }
                  },
        ),
      ),
    );
  }

  // Map backend status values to dropdown values
  String _mapStatusToDropdownValue(String status) {
    final lowerStatus = status.toLowerCase();
    // Map common variations to dropdown values
    if (lowerStatus.contains('new') || lowerStatus == 'pending') {
      return 'New';
    } else if (lowerStatus.contains('collected')) {
      return 'Sample Collected';
    } else if (lowerStatus.contains('processed')) {
      return 'Sample Processed';
    } else if (lowerStatus.contains('entered')) {
      return 'Result Entered';
    } else if (lowerStatus.contains('verified')) {
      return 'Result Verified';
    } else if (lowerStatus.contains('cancelled') ||
        lowerStatus.contains('canceled')) {
      return 'Cancelled';
    } else if (lowerStatus.contains('hold')) {
      return 'On Hold';
    }
    // If exact match found, return as is
    if (_testStatuses.contains(status)) {
      return status;
    }
    // Default to first status if no match
    return 'New';
  }

  // Map UI status labels to backend-accepted item_status values
  String _mapStatusToApiValue(String status) {
    final lowerStatus = status.toLowerCase();
    if (lowerStatus.contains('new') || lowerStatus == 'pending') {
      return 'Pending';
    } else if (lowerStatus.contains('collected')) {
      return 'Collected';
    } else if (lowerStatus.contains('processed') ||
        lowerStatus.contains('hold') ||
        lowerStatus.contains('progress')) {
      return 'In Progress';
    } else if (lowerStatus.contains('entered')) {
      return 'Result Entered';
    } else if (lowerStatus.contains('verified')) {
      return 'Result Verified';
    } else if (lowerStatus.contains('completed')) {
      return 'Completed';
    } else if (lowerStatus.contains('cancelled') ||
        lowerStatus.contains('canceled')) {
      return 'Cancelled';
    }
    return 'Pending';
  }

  void _showStatusUpdateDialog(TestItem test, String newStatus) {
    final notesController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Update Test Status'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Test: ${test.testName}',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                SizedBox(height: 8),
                Text(
                  'Current Status: ${test.itemStatus}',
                  style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                ),
                Text(
                  'New Status: $newStatus',
                  style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: notesController,
                  decoration: InputDecoration(
                    labelText: 'Notes (Optional)',
                    hintText: 'Add notes about this status change...',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _updateTestStatus(
                    test.id,
                    newStatus,
                    notes:
                        notesController.text.isNotEmpty
                            ? notesController.text.trim()
                            : null,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF3B82F6),
                  foregroundColor: Colors.white,
                ),
                child: Text('Update'),
              ),
            ],
          ),
    );
  }

  Widget _buildTestStatusChip(String status) {
    final statusColor = _getStatusColor(status);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: statusColor.withOpacity(0.9),
        ),
      ),
    );
  }

  Widget _buildDoctorInfo() {
    return Column(
      children: [
        _buildInfoRow('Doctor', _request!.orderingDoctor.name),
        if (_request!.orderingDoctor.department != null)
          _buildInfoRow('Department', _request!.orderingDoctor.department!),
      ],
    );
  }

  Widget _buildClinicalInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_request!.clinicalIndication != null) ...[
          _buildInfoRow('Clinical Indication', _request!.clinicalIndication!),
          SizedBox(height: 12),
        ],
        if (_request!.notes != null) _buildInfoRow('Notes', _request!.notes!),
      ],
    );
  }

  Widget _buildStatusTimeline() {
    return Column(
      children: [
        _buildTimelineItem(
          'Request Created',
          _formatDateTime(_request!.createdAt),
          Icons.add_circle,
          Color(0xFF3B82F6),
          true,
        ),
        if (_request!.specimenCollectedAt != null)
          _buildTimelineItem(
            'Specimen Collected',
            _formatDateTime(_request!.specimenCollectedAt),
            Icons.bloodtype,
            Color(0xFF3B82F6),
            false,
          ),
        if (_request!.processingStartedAt != null)
          _buildTimelineItem(
            'Processing Started',
            _formatDateTime(_request!.processingStartedAt),
            Icons.play_circle,
            Color(0xFFEA580C),
            false,
          ),
        if (_request!.completedAt != null)
          _buildTimelineItem(
            'Completed',
            _formatDateTime(_request!.completedAt),
            Icons.check_circle,
            Color(0xFF059669),
            false,
          ),
        if (!_request!.specimenCollected &&
            _request!.specimenCollectedAt == null &&
            _request!.processingStartedAt == null &&
            _request!.completedAt == null)
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              'Awaiting specimen collection',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF6B7280),
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTimelineItem(
    String label,
    String time,
    IconData icon,
    Color color,
    bool isFirst,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            if (!isFirst)
              Container(width: 2, height: 20, color: Color(0xFFE5E7EB)),
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 16),
            ),
            Container(width: 2, height: 20, color: Color(0xFFE5E7EB)),
          ],
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF111827),
                ),
              ),
              SizedBox(height: 2),
              Text(
                time,
                style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF111827),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Usage example:
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Lab Test App')),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => LabTestRequests(),
              );
            },
            child: Text('Open Lab Test Requests'),
          ),
        ),
      ),
    );
  }
}
