import 'package:flutter/material.dart';
import 'dart:async';
import '../services/api_service.dart';
import 'imaging_order_detail.dart';

class ImagingOrdersList extends StatefulWidget {
  const ImagingOrdersList({super.key});

  @override
  State<ImagingOrdersList> createState() => _ImagingOrdersListState();
}

class _ImagingOrdersListState extends State<ImagingOrdersList> {
  String selectedStatus = 'All';
  String selectedPriority = 'All';
  String selectedModality = 'All';
  String selectedSortBy = 'created_at';
  String selectedSortOrder = 'desc';
  DateTime? selectedDate;
  bool isListView = true;

  // Data state
  List<Map<String, dynamic>> orders = [];
  Map<String, dynamic>? pagination;
  int? pendingCount;

  // Loading and error states
  bool isLoadingOrders = false;
  bool isLoadingPending = false;
  String? errorMessage;

  // Search
  final TextEditingController searchController = TextEditingController();
  Timer? _searchDebounce;

  // Current page
  int currentPage = 1;
  final int itemsPerPage = 20;

  final List<String> statusOptions = ['All', 'ORDERED', 'SCHEDULED', 'COMPLETED', 'CANCELLED'];
  final List<String> priorityOptions = ['All', 'ROUTINE', 'URGENT', 'STAT'];
  final List<String> modalityOptions = ['All', 'CT', 'MRI', 'X-ray', 'Ultrasound'];
  final List<String> sortByOptions = ['created_at', 'scheduled_date', 'priority', 'status'];
  final List<String> sortOrderOptions = ['asc', 'desc'];

  @override
  void initState() {
    super.initState();
    _loadData();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      _loadOrders();
    });
  }

  Future<void> _loadData() async {
    await Future.wait([
      _loadPendingCount(),
      _loadOrders(),
    ]);
  }

  Future<void> _loadPendingCount() async {
    setState(() => isLoadingPending = true);

    try {
      final response = await ApiService.get('/api/v1/imaging-orders/count/pending');

      if (response.success && response.data != null) {
        final data = response.data['data'] as Map<String, dynamic>;
        setState(() {
          pendingCount = data['count'] as int?;
          isLoadingPending = false;
        });
      } else {
        setState(() => isLoadingPending = false);
      }
    } catch (e) {
      setState(() => isLoadingPending = false);
    }
  }

  Future<void> _loadOrders() async {
    setState(() => isLoadingOrders = true);

    try {
      // Build query parameters
      final queryParams = <String, String>{
        'page': currentPage.toString(),
        'limit': itemsPerPage.toString(),
        'sort_by': selectedSortBy,
        'sort_order': selectedSortOrder,
      };

      if (selectedStatus != 'All') queryParams['status'] = selectedStatus;
      if (selectedPriority != 'All') queryParams['priority'] = selectedPriority;
      if (selectedModality != 'All') queryParams['modality'] = selectedModality;
      if (searchController.text.isNotEmpty) queryParams['search'] = searchController.text;
      if (selectedDate != null) {
        queryParams['date_from'] = selectedDate!.toIso8601String().split('T')[0];
        queryParams['date_to'] = selectedDate!.toIso8601String().split('T')[0];
      }

      final queryString = queryParams.entries.map((e) => '${e.key}=${e.value}').join('&');
      final response = await ApiService.get('/api/v1/imaging-orders?$queryString');

      if (response.success && response.data != null) {
        final data = response.data['data'] as Map<String, dynamic>;
        setState(() {
          orders = List<Map<String, dynamic>>.from(data['orders'] ?? []);
          pagination = data;
          isLoadingOrders = false;
          errorMessage = null;
        });
      } else {
        setState(() {
          errorMessage = response.error ?? 'Failed to load orders';
          isLoadingOrders = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: ${e.toString()}';
        isLoadingOrders = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Imaging Orders',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(isListView ? Icons.grid_view : Icons.list),
            onPressed: () => setState(() => isListView = !isListView),
          ),
        ],
      ),
      body: Column(
        children: [
          // Pending Count Banner
          if (pendingCount != null && pendingCount! > 0)
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFF59E0B), Color(0xFFFCD34D)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber, color: Colors.white),
                  const SizedBox(width: 12),
                  Text(
                    '$pendingCount pending orders require attention',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

          // Filters
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                // Search
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search orders, patients, or imaging types...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                  ),
                ),
                const SizedBox(height: 16),

                // Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('Status', selectedStatus, statusOptions),
                      const SizedBox(width: 8),
                      _buildFilterChip('Priority', selectedPriority, priorityOptions),
                      const SizedBox(width: 8),
                      _buildFilterChip('Modality', selectedModality, modalityOptions),
                      const SizedBox(width: 8),
                      _buildSortByChip(),
                      const SizedBox(width: 8),
                      _buildSortOrderChip(),
                      const SizedBox(width: 8),
                      _buildDateFilterChip(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Orders List
          Expanded(
            child: isLoadingOrders
                ? const Center(child: CircularProgressIndicator())
                : errorMessage != null
                ? _buildErrorState()
                : orders.isEmpty
                ? _buildEmptyState()
                : _buildOrdersList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String selectedValue, List<String> options) {
    return PopupMenuButton<String>(
      child: Chip(
        label: Text('$label: $selectedValue'),
        backgroundColor: const Color(0xFFF1F5F9),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      onSelected: (value) {
        setState(() {
          if (label == 'Status') selectedStatus = value;
          if (label == 'Priority') selectedPriority = value;
          if (label == 'Modality') selectedModality = value;
        });
        _loadOrders();
      },
      itemBuilder: (context) => options.map((option) {
        return PopupMenuItem(
          value: option,
          child: Text(option),
        );
      }).toList(),
    );
  }

  Widget _buildSortByChip() {
    return PopupMenuButton<String>(
      child: Chip(
        label: Text('Sort: ${_formatSortByLabel(selectedSortBy)}'),
        backgroundColor: const Color(0xFFF1F5F9),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      onSelected: (value) {
        setState(() => selectedSortBy = value);
        _loadOrders();
      },
      itemBuilder: (context) => sortByOptions.map((option) {
        return PopupMenuItem(
          value: option,
          child: Text(_formatSortByLabel(option)),
        );
      }).toList(),
    );
  }

  Widget _buildSortOrderChip() {
    return PopupMenuButton<String>(
      child: Chip(
        label: Text(selectedSortOrder == 'desc' ? '↓ Desc' : '↑ Asc'),
        backgroundColor: const Color(0xFFF1F5F9),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      onSelected: (value) {
        setState(() => selectedSortOrder = value);
        _loadOrders();
      },
      itemBuilder: (context) => sortOrderOptions.map((option) {
        return PopupMenuItem(
          value: option,
          child: Text(option == 'desc' ? 'Descending ↓' : 'Ascending ↑'),
        );
      }).toList(),
    );
  }

  Widget _buildDateFilterChip() {
    return ActionChip(
      label: Text(selectedDate == null
          ? 'Select Date'
          : '${selectedDate!.month}/${selectedDate!.day}/${selectedDate!.year}'),
      backgroundColor: const Color(0xFFF1F5F9),
      side: const BorderSide(color: Color(0xFFE2E8F0)),
      onPressed: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime.now().add(const Duration(days: 30)),
        );
        if (date != null) {
          setState(() => selectedDate = date);
          _loadOrders();
        }
      },
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            errorMessage!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadOrders,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.medical_services, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No imaging orders found',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderCard(order);
      },
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    final patient = order['patient'] as Map<String, dynamic>?;
    final priority = order['priority'] as String? ?? 'ROUTINE';
    final status = order['status'] as String? ?? 'ORDERED';
    final orderId = order['id'] as String?;

    return GestureDetector(
      onTap: orderId != null
          ? () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ImagingOrderDetailScreen(orderId: orderId),
                ),
              );
              // Refresh data when returning from detail screen
              _loadData();
            }
          : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order['order_number'] as String? ?? 'Unknown',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                ),
              ),
              _buildPriorityBadge(priority),
            ],
          ),
          const SizedBox(height: 8),

          // Patient Info
          if (patient != null) ...[
            Text(
              '${patient['name']} (${patient['mrn']})',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 8),
          ],

          // Imaging Details
          Row(
            children: [
              const Icon(Icons.medical_services, size: 16, color: Color(0xFF64748B)),
              const SizedBox(width: 8),
              Text(
                '${order['imaging_type']} (${order['modality']})',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),

          if (order['body_part'] != null) ...[
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Color(0xFF64748B)),
                const SizedBox(width: 8),
                Text(
                  'Body Part: ${order['body_part']}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],

          // Status and Dates
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatusBadge(status),
              Row(
                children: [
                  Text(
                    'Ordered: ${_formatDate(order['ordered_at'])}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.chevron_right,
                    size: 16,
                    color: Color(0xFFCBD5E1),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }

  String _formatSortByLabel(String sortBy) {
    const labels = {
      'created_at': 'Created Date',
      'scheduled_date': 'Scheduled Date',
      'priority': 'Priority',
      'status': 'Status',
    };
    return labels[sortBy] ?? sortBy;
  }

  Widget _buildPriorityBadge(String priority) {
    final colors = {
      'STAT': const Color(0xFFEF4444),
      'URGENT': const Color(0xFFF59E0B),
      'ROUTINE': const Color(0xFF10B981),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (colors[priority] ?? colors['ROUTINE'])!.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (colors[priority] ?? colors['ROUTINE'])!.withOpacity(0.2),
        ),
      ),
      child: Text(
        priority,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: colors[priority] ?? colors['ROUTINE'],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final colors = {
      'COMPLETED': const Color(0xFF10B981),
      'SCHEDULED': const Color(0xFF3B82F6),
      'ORDERED': const Color(0xFF8B5CF6),
      'CANCELLED': const Color(0xFFEF4444),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (colors[status] ?? Colors.grey).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: colors[status] ?? Colors.grey,
        ),
      ),
    );
  }

  String _formatDate(dynamic dateString) {
    if (dateString == null) return 'Unknown';
    try {
      final date = DateTime.parse(dateString.toString());
      return '${date.month}/${date.day}/${date.year}';
    } catch (e) {
      return dateString.toString();
    }
  }
}
