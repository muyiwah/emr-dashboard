import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:schmgtsystem/services/api_service.dart';
import 'package:schmgtsystem/models/lab_test_request_model.dart';
import 'package:schmgtsystem/models/lab_result_model.dart';

class MedicalLabResultsScreen extends StatefulWidget {
  MedicalLabResultsScreen({
    super.key,
    required this.goBack,
    this.patientId,
    this.patientName,
    this.patientMrn,
  });
  Null Function() goBack;
  final String? patientId;
  final String? patientName;
  final String? patientMrn;

  @override
  _MedicalLabResultsScreenState createState() =>
      _MedicalLabResultsScreenState();
}

class _MedicalLabResultsScreenState extends State<MedicalLabResultsScreen> {
  String selectedCategory = 'All Categories';
  String selectedTimeframe = 'Last 30 days';
  TextEditingController notesController = TextEditingController();

  // Lab test requests state
  List<LabTestRequest> _labTestRequests = [];
  bool _isLoadingRequests = false;
  String? _requestsError;
  LabTestRequest? _selectedRequest;

  // Lab results state
  List<LabResult> _labResults = [];
  bool _isLoadingResults = false;
  String? _resultsError;

  @override
  void initState() {
    super.initState();
    _loadPatientLabTestRequests();
    _loadPatientLabResults();
  }

  Future<void> _loadPatientLabTestRequests() async {
    if (widget.patientId == null || widget.patientId!.isEmpty) {
      return;
    }

    setState(() {
      _isLoadingRequests = true;
      _requestsError = null;
    });

    try {
      final response = await ApiService.getLabTestRequests(
        page: 1,
        limit: 100,
        search: widget.patientMrn ?? widget.patientId,
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

          setState(() {
            _labTestRequests = requestsList;
            _isLoadingRequests = false;
            if (requestsList.isNotEmpty) {
              _selectedRequest = requestsList.first;
            }
          });
        } else {
          setState(() {
            _isLoadingRequests = false;
            _requestsError = 'No data returned';
          });
        }
      } else {
        setState(() {
          _isLoadingRequests = false;
          _requestsError = response.error ?? 'Failed to load requests';
        });
      }
    } catch (e) {
      setState(() {
        _isLoadingRequests = false;
        _requestsError = 'Error: ${e.toString()}';
      });
    }
  }

  Future<void> _loadPatientLabResults() async {
    if (widget.patientId == null || widget.patientId!.isEmpty) {
      return;
    }

    setState(() {
      _isLoadingResults = true;
      _resultsError = null;
    });

    try {
      final response = await ApiService.getPatientLabResults(
        widget.patientId!,
        page: 1,
        limit: 100,
      );

      if (response.success && response.data != null) {
        final responseData = response.data as Map<String, dynamic>;
        final data = responseData['data'] as Map<String, dynamic>?;

        if (data != null) {
          final patientResults = PatientLabResultsResponse.fromJson(data);
          setState(() {
            _labResults = patientResults.results;
            _isLoadingResults = false;
          });
        } else {
          setState(() {
            _isLoadingResults = false;
            _resultsError = 'No results data returned';
          });
        }
      } else {
        setState(() {
          _isLoadingResults = false;
          _resultsError = response.error ?? 'Failed to load results';
        });
      }
    } catch (e) {
      setState(() {
        _isLoadingResults = false;
        _resultsError = 'Error: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            widget.goBack();
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.grey[800]),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('assets/profile_image.jpg'),
              backgroundColor: Colors.grey[300],
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.patientName ?? 'Patient',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'MRN: ${widget.patientMrn ?? 'N/A'}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 8),
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.add, size: 18),
              label: Text('Order Tests'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6366F1),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.print, color: Colors.grey[600]),
          ),
        ],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left sidebar - Lab Test Requests list
          Container(
            width: 320,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(right: BorderSide(color: Colors.grey[200]!)),
            ),
            child: _buildLabTestRequestsList(),
          ),
          // Main content area
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search and filters
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search tests...',
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.grey[400],
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        _buildDropdown(selectedCategory, [
                          'All Categories',
                          'Blood Tests',
                          'Urine Tests',
                        ]),
                        SizedBox(width: 12),
                        _buildDropdown(selectedTimeframe, [
                          'Last 30 days',
                          'Last 60 days',
                          'Last 90 days',
                        ]),
                        SizedBox(width: 12),
                        _buildFilterButton('Abnormal Only', Colors.orange),
                        SizedBox(width: 8),
                        _buildFilterButton('AI Assist', Colors.cyan),
                      ],
                    ),
                    SizedBox(height: 24),

                    // Selected request details and tests
                    if (_selectedRequest != null) ...[
                      _buildSelectedRequestHeader(),
                      SizedBox(height: 16),
                      _buildSelectedRequestTests(),
                      SizedBox(height: 24),
                    ],

                    // Detailed results and chart section
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildDetailedResults(),
                              SizedBox(height: 32),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(child: _buildGlucoseChart()),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _buildLabNotes(),
                                        _buildDoctorNotes(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
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
        ],
      ),
    );
  }

  Widget _buildLabTestRequestsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Lab Test Requests',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              IconButton(
                onPressed: _loadPatientLabTestRequests,
                icon: Icon(Icons.refresh, size: 20, color: Colors.grey[600]),
                tooltip: 'Refresh',
              ),
            ],
          ),
        ),
        // Content
        Expanded(
          child:
              _isLoadingRequests
                  ? Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xFF6366F1),
                    ),
                  )
                  : _requestsError != null
                  ? Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 12),
                          Text(
                            _requestsError!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 12),
                          TextButton(
                            onPressed: _loadPatientLabTestRequests,
                            child: Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  )
                  : _labTestRequests.isEmpty
                  ? Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.science_outlined,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 12),
                          Text(
                            'No lab test requests found',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  : ListView.builder(
                    itemCount: _labTestRequests.length,
                    itemBuilder: (context, index) {
                      final request = _labTestRequests[index];
                      final isSelected = _selectedRequest?.id == request.id;
                      return _buildRequestListItem(request, isSelected);
                    },
                  ),
        ),
      ],
    );
  }

  Widget _buildRequestListItem(LabTestRequest request, bool isSelected) {
    final statusColor = _getStatusColor(request.status);

    return InkWell(
      onTap: () {
        setState(() {
          _selectedRequest = request;
        });
      },
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color:
              isSelected ? Color(0xFF6366F1).withOpacity(0.08) : Colors.white,
          border: Border(
            bottom: BorderSide(color: Colors.grey[100]!),
            left: BorderSide(
              color: isSelected ? Color(0xFF6366F1) : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  request.requestNumber,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    request.statusDisplay,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 6),
            Text(
              '${request.tests.length} test${request.tests.length > 1 ? 's' : ''}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 12, color: Colors.grey[500]),
                SizedBox(width: 4),
                Text(
                  _formatDate(request.requestDate),
                  style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getPriorityColor(
                      request.priority,
                    ).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    request.priorityDisplay,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: _getPriorityColor(request.priority),
                    ),
                  ),
                ),
              ],
            ),
            if (request.tests.isNotEmpty) ...[
              SizedBox(height: 8),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children:
                    request.tests.take(3).map((test) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          test.testName,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[700],
                          ),
                        ),
                      );
                    }).toList(),
              ),
              if (request.tests.length > 3)
                Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text(
                    '+${request.tests.length - 3} more',
                    style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedRequestHeader() {
    if (_selectedRequest == null) return SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Request: ${_selectedRequest!.requestNumber}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF111827),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Ordered by: ${_selectedRequest!.orderingDoctor.name}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getStatusColor(
                        _selectedRequest!.status,
                      ).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _selectedRequest!.statusDisplay,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _getStatusColor(_selectedRequest!.status),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getPriorityColor(
                        _selectedRequest!.priority,
                      ).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _selectedRequest!.priorityDisplay,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _getPriorityColor(_selectedRequest!.priority),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 14, color: Colors.grey[500]),
              SizedBox(width: 6),
              Text(
                'Requested: ${_formatDate(_selectedRequest!.requestDate)}',
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
              SizedBox(width: 24),
              if (_selectedRequest!.clinicalIndication != null) ...[
                Icon(
                  Icons.medical_information,
                  size: 14,
                  color: Colors.grey[500],
                ),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Indication: ${_selectedRequest!.clinicalIndication}',
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedRequestTests() {
    if (_selectedRequest == null) return SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ordered Tests (${_selectedRequest!.tests.length})',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
            ),
          ),
          SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _selectedRequest!.tests.length,
            separatorBuilder: (context, index) => SizedBox(height: 8),
            itemBuilder: (context, index) {
              final test = _selectedRequest!.tests[index];
              final itemStatusColor = _getItemStatusColor(test.itemStatus);
              final hasResult =
                  test.itemStatus.toLowerCase().contains('entered') ||
                  test.itemStatus.toLowerCase().contains('verified') ||
                  test.itemStatus.toLowerCase().contains('completed');

              return Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            test.testName,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF111827),
                            ),
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                test.testCode,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[500],
                                ),
                              ),
                              if (test.specimenType != null) ...[
                                SizedBox(width: 8),
                                Container(
                                  width: 4,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[400],
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  test.specimenType!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: itemStatusColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        test.itemStatus,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: itemStatusColor,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () => _showTestResultDialog(test),
                      icon: Icon(
                        hasResult ? Icons.visibility : Icons.pending,
                        size: 16,
                      ),
                      label: Text(hasResult ? 'View Details' : 'Pending'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            hasResult ? Color(0xFF6366F1) : Colors.grey[300],
                        foregroundColor:
                            hasResult ? Colors.white : Colors.grey[600],
                        elevation: 0,
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showTestResultDialog(TestItem test) async {
    if (_selectedRequest == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => Center(
            child: CircularProgressIndicator(color: Color(0xFF6366F1)),
          ),
    );

    try {
      final response = await ApiService.getLabResultForItem(
        _selectedRequest!.id,
        test.id,
      );

      Navigator.of(context).pop(); // Close loading dialog

      if (response.success && response.data != null) {
        final responseData = response.data as Map<String, dynamic>;
        final data = responseData['data'] as Map<String, dynamic>?;

        if (data != null) {
          final itemResponse = LabResultItemResponse.fromJson(data);
          _showResultDetailDialog(test, itemResponse);
        } else {
          _showNoResultDialog(test);
        }
      } else {
        _showNoResultDialog(test);
      }
    } catch (e) {
      Navigator.of(context).pop(); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading result: ${e.toString()}'),
          backgroundColor: Color(0xFFDC2626),
        ),
      );
    }
  }

  void _showNoResultDialog(TestItem test) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(test.testName),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.hourglass_empty, size: 48, color: Colors.grey[400]),
                SizedBox(height: 16),
                Text(
                  'No results available yet',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                SizedBox(height: 8),
                Text(
                  'Status: ${test.itemStatus}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Close'),
              ),
            ],
          ),
    );
  }

  void _showResultDetailDialog(
    TestItem test,
    LabResultItemResponse itemResponse,
  ) {
    final result = itemResponse.result;

    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.6,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFF6366F1),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.science, color: Colors.white),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                test.testName,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Code: ${test.testCode}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (result != null)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  result.isVerified
                                      ? Color(0xFF059669)
                                      : Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              result.resultStatus,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        SizedBox(width: 8),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(Icons.close, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  // Content
                  Flexible(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(16),
                      child:
                          result == null
                              ? _buildNoResultContent()
                              : _buildResultContent(result),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildNoResultContent() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.hourglass_empty, size: 64, color: Colors.grey[300]),
          SizedBox(height: 16),
          Text(
            'Results not yet available',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildResultContent(LabResult result) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Result text
        if (result.resultText != null && result.resultText!.isNotEmpty) ...[
          Text(
            'Summary',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Text(
              result.resultText!,
              style: TextStyle(fontSize: 14, color: Color(0xFF111827)),
            ),
          ),
          SizedBox(height: 16),
        ],

        // Result entries table
        if (result.resultEntries.isNotEmpty) ...[
          Text(
            'Test Results',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[200]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                // Table header
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(7),
                      topRight: Radius.circular(7),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Analyte',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Result',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Unit',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Reference',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Flag',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Table rows
                ...result.resultEntries.map((entry) {
                  final flagColor = _getFlagColor(entry.flag ?? 'Normal');
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: Colors.grey[200]!)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            entry.analyteName ?? entry.analyteCode ?? '-',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF111827),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            entry.value ?? '-',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: flagColor,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            entry.unit ?? '-',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            entry.referenceRange ?? '-',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: flagColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              entry.flag ?? 'Normal',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: flagColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          SizedBox(height: 16),
        ],

        // Notes
        if (result.notes != null && result.notes!.isNotEmpty) ...[
          Text(
            'Notes',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.amber[200]!),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.note, size: 16, color: Colors.amber[700]),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    result.notes!,
                    style: TextStyle(fontSize: 13, color: Color(0xFF111827)),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
        ],

        // Metadata
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              if (result.enteredAt != null)
                _buildMetaRow('Entered', _formatDateTime(result.enteredAt)),
              if (result.verifiedAt != null)
                _buildMetaRow('Verified', _formatDateTime(result.verifiedAt)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetaRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          Text(value, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    final lowerStatus = status.toLowerCase();
    if (lowerStatus.contains('completed') || lowerStatus.contains('verified')) {
      return Color(0xFF059669);
    } else if (lowerStatus.contains('progress') ||
        lowerStatus.contains('processing')) {
      return Color(0xFF3B82F6);
    } else if (lowerStatus.contains('cancelled')) {
      return Color(0xFFDC2626);
    } else if (lowerStatus.contains('hold')) {
      return Color(0xFFF59E0B);
    }
    return Color(0xFF6B7280);
  }

  Color _getItemStatusColor(String status) {
    final lowerStatus = status.toLowerCase();
    if (lowerStatus.contains('verified')) {
      return Color(0xFF059669);
    } else if (lowerStatus.contains('entered') ||
        lowerStatus.contains('completed')) {
      return Color(0xFF10B981);
    } else if (lowerStatus.contains('progress') ||
        lowerStatus.contains('processed')) {
      return Color(0xFF3B82F6);
    } else if (lowerStatus.contains('collected')) {
      return Color(0xFF6366F1);
    } else if (lowerStatus.contains('cancelled')) {
      return Color(0xFFDC2626);
    }
    return Color(0xFF6B7280);
  }

  Color _getPriorityColor(String priority) {
    final lowerPriority = priority.toLowerCase();
    if (lowerPriority == 'stat' ||
        lowerPriority == 'urgent' ||
        lowerPriority == 'high') {
      return Color(0xFFDC2626);
    } else if (lowerPriority == 'medium') {
      return Color(0xFFF59E0B);
    }
    return Color(0xFF6B7280);
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateStr;
    }
  }

  Widget _buildDropdown(String value, List<String> options) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButton<String>(
        value: value,
        items:
            options
                .map(
                  (option) => DropdownMenuItem(
                    value: option,
                    child: Text(option, style: TextStyle(fontSize: 14)),
                  ),
                )
                .toList(),
        onChanged: (newValue) {
          setState(() {
            if (options.contains('All Categories')) {
              selectedCategory = newValue!;
            } else {
              selectedTimeframe = newValue!;
            }
          });
        },
        underline: Container(),
        icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
      ),
    );
  }

  Widget _buildFilterButton(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildDetailedResults() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Detailed Lab Results',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              if (_isLoadingResults)
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(0xFF6366F1),
                  ),
                )
              else
                IconButton(
                  onPressed: _loadPatientLabResults,
                  icon: Icon(Icons.refresh, size: 20, color: Colors.grey[600]),
                  tooltip: 'Refresh results',
                ),
            ],
          ),
          SizedBox(height: 16),
          _buildDetailedResultsTable(),
        ],
      ),
    );
  }

  Widget _buildDetailedResultsTable() {
    // Flatten all result entries from all lab results
    final allEntries = <_FlattenedResultEntry>[];
    for (final result in _labResults) {
      for (final entry in result.resultEntries) {
        allEntries.add(
          _FlattenedResultEntry(
            analyteName: entry.analyteName ?? entry.analyteCode ?? 'Unknown',
            value: entry.value ?? '-',
            unit: entry.unit ?? '',
            referenceRange: entry.referenceRange ?? '-',
            flag: entry.flag ?? 'Normal',
            enteredAt: result.enteredAt,
            resultStatus: result.resultStatus,
          ),
        );
      }
    }

    if (allEntries.isEmpty && !_isLoadingResults) {
      return Container(
        padding: EdgeInsets.all(24),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.science_outlined, size: 48, color: Colors.grey[400]),
              SizedBox(height: 12),
              Text(
                _resultsError ?? 'No lab results available',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    return Table(
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(1.2),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1.5),
        4: FlexColumnWidth(1.2),
        5: FlexColumnWidth(1.5),
        6: FlexColumnWidth(0.8),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey[50]),
          children: [
            _buildTableHeader('TEST NAME'),
            _buildTableHeader('RESULT'),
            _buildTableHeader('UNIT'),
            _buildTableHeader('REFERENCE RANGE'),
            _buildTableHeader('FLAG'),
            _buildTableHeader('DATE/TIME'),
            _buildTableHeader('STATUS'),
          ],
        ),
        ...allEntries.map((entry) => _buildTableRowFromEntry(entry)).toList(),
      ],
    );
  }

  TableRow _buildTableRowFromEntry(_FlattenedResultEntry entry) {
    final flagColor = _getFlagColor(entry.flag);
    return TableRow(
      children: [
        Padding(
          padding: EdgeInsets.all(12),
          child: Text(entry.analyteName, style: TextStyle(fontSize: 14)),
        ),
        Padding(
          padding: EdgeInsets.all(12),
          child: Text(
            entry.value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: flagColor,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(12),
          child: Text(entry.unit, style: TextStyle(fontSize: 14)),
        ),
        Padding(
          padding: EdgeInsets.all(12),
          child: Text(entry.referenceRange, style: TextStyle(fontSize: 14)),
        ),
        Padding(
          padding: EdgeInsets.all(12),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: flagColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              entry.flag,
              style: TextStyle(
                fontSize: 12,
                color: flagColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(12),
          child: Text(
            _formatDateTime(entry.enteredAt),
            style: TextStyle(fontSize: 13),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(12),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color:
                  entry.resultStatus.toLowerCase() == 'verified'
                      ? Color(0xFF059669).withOpacity(0.12)
                      : Color(0xFF3B82F6).withOpacity(0.12),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              entry.resultStatus,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color:
                    entry.resultStatus.toLowerCase() == 'verified'
                        ? Color(0xFF059669)
                        : Color(0xFF3B82F6),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getFlagColor(String flag) {
    final lowerFlag = flag.toLowerCase();
    if (lowerFlag.contains('critical') ||
        lowerFlag.contains('low') && lowerFlag.contains('critical')) {
      return Color(0xFFDC2626);
    } else if (lowerFlag.contains('high') || lowerFlag.contains('low')) {
      return Color(0xFFF59E0B);
    } else if (lowerFlag.contains('normal')) {
      return Color(0xFF059669);
    }
    return Color(0xFF6B7280);
  }

  String _formatDateTime(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateStr);
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${months[date.month - 1]} ${date.day}, ${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateStr;
    }
  }

  Widget _buildTableHeader(String text) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildGlucoseChart() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Glucose Trend',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 26),
          Container(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true, drawVerticalLine: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const titles = ['Jan 1', 'Jan 8', 'Jan 15'];
                        return Text(titles[value.toInt() % titles.length]);
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: [FlSpot(0, 145), FlSpot(1, 158), FlSpot(2, 165)],
                    isCurved: true,
                    color: Colors.orange,
                    barWidth: 3,
                    dotData: FlDotData(show: true),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabNotes() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lab Notes & Interpretations',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.warning, color: Colors.orange, size: 16),
                    SizedBox(width: 8),
                    Text(
                      'Lab Technician Note',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange[800],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'Hemoglobin levels critically low. Recommend immediate consultation with hematologist.',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 8),
                Text(
                  'Dr. Martinez - Jan 15, 2024',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorNotes() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Doctor\'s Notes',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 16),
          TextField(
            controller: notesController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Add your notes here...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Color(0xFF6366F1)),
              ),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            child: Text('Save Note'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF6366F1),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Helper class for flattened result entry display
class _FlattenedResultEntry {
  final String analyteName;
  final String value;
  final String unit;
  final String referenceRange;
  final String flag;
  final String? enteredAt;
  final String resultStatus;

  _FlattenedResultEntry({
    required this.analyteName,
    required this.value,
    required this.unit,
    required this.referenceRange,
    required this.flag,
    this.enteredAt,
    required this.resultStatus,
  });
}
