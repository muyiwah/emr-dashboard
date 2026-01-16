import 'package:flutter/material.dart';
import 'package:schmgtsystem/services/api_service.dart';
import 'package:schmgtsystem/models/lab_metrics_model.dart';

class LabOperationsDashboard extends StatefulWidget {
  const LabOperationsDashboard({Key? key}) : super(key: key);

  @override
  State<LabOperationsDashboard> createState() => _LabOperationsDashboardState();
}

class _LabOperationsDashboardState extends State<LabOperationsDashboard> {
  LabMetricsData? _metricsData;
  bool _isLoading = true;
  String _selectedPeriod = 'all';
  String _errorMessage = '';

  final List<String> _periods = ['today', 'week', 'month', 'quarter', 'all'];

  @override
  void initState() {
    super.initState();
    _loadMetrics();
  }

  Future<void> _loadMetrics() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await ApiService.getLabTestRequestMetrics(
        period: _selectedPeriod,
      );

      if (response.success && response.data != null) {
        final responseData = response.data as Map<String, dynamic>;
        final metricsResponse = LabMetricsResponse.fromJson(responseData);

        setState(() {
          _metricsData = metricsResponse.data;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = response.error ?? 'Failed to load metrics';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading metrics: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  void _onPeriodChanged(String? period) {
    if (period != null && period != _selectedPeriod) {
      setState(() {
        _selectedPeriod = period;
      });
      _loadMetrics();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage.isNotEmpty
              ? _buildErrorState()
              : _buildMetricsDashboard(),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
          const SizedBox(height: 16),
          Text(
            'Failed to load metrics',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _errorMessage,
            style: TextStyle(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _loadMetrics,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsDashboard() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildPeriodSelector(),
          if (_metricsData != null) ...[
            _buildSummaryCards(),
            _buildChartsSection(),
            _buildDepartmentPerformance(),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.science_outlined,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lab Operations Dashboard',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Monitor lab performance and efficiency',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (_metricsData != null) ...[
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: Color(0xFF6B7280),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Period: ${_metricsData!.dateRange}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF374151),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${_metricsData!.summary.totalRequests} Total Requests',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF059669),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          const Text(
            'Time Period:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(width: 16),
          ..._periods.map(
            (period) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(
                  period == 'all' ? 'All Time' : period.capitalize(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color:
                        _selectedPeriod == period
                            ? Colors.white
                            : const Color(0xFF6B7280),
                  ),
                ),
                selected: _selectedPeriod == period,
                onSelected: (selected) {
                  if (selected) _onPeriodChanged(period);
                },
                backgroundColor: Colors.white,
                selectedColor: const Color(0xFF6366F1),
                checkmarkColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color:
                        _selectedPeriod == period
                            ? const Color(0xFF6366F1)
                            : const Color(0xFFD1D5DB),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    final summary = _metricsData!.summary;
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Key Metrics',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildMetricCard(
                'Total Requests',
                summary.totalRequests.toString(),
                Icons.assignment_outlined,
                const Color(0xFF6366F1),
                '${summary.completionRate} completion rate',
              ),
              _buildMetricCard(
                'Completed',
                summary.completedThisPeriod.toString(),
                Icons.check_circle_outline,
                const Color(0xFF10B981),
                'This period',
              ),
              _buildMetricCard(
                'Urgent Requests',
                summary.urgentRequests.toString(),
                Icons.warning_outlined,
                const Color(0xFFF59E0B),
                summary.urgentRate,
              ),
              _buildMetricCard(
                'Avg Turnaround',
                '${summary.avgTurnaroundHours.toStringAsFixed(1)}h',
                Icons.timer_outlined,
                const Color(0xFF8B5CF6),
                'Hours',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    IconData icon,
    Color color,
    String subtitle,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: color.withOpacity(0.8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartsSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Status Distribution',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildStatusChart(),
                const SizedBox(height: 24),
                _buildPriorityChart(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChart() {
    final statusData = _metricsData!.statusBreakdown.entries.toList();
    final total = statusData.fold<int>(0, (sum, item) => sum + item.value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Request Status',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 16),
        ...statusData.map((entry) {
          final percentage =
              total > 0 ? (entry.value / total * 100).round() : 0;
          final color = _getStatusColor(entry.key.toLowerCase());
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _formatStatusLabel(entry.key),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF374151),
                    ),
                  ),
                ),
                Text(
                  '${entry.value} ($percentage%)',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildPriorityChart() {
    final priorityData = _metricsData!.priorityBreakdown.entries.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text(
          'Priority Distribution',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children:
              priorityData.map((entry) {
                final color = _getPriorityColor(entry.key.toLowerCase());
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: color.withOpacity(0.2)),
                    ),
                    child: Column(
                      children: [
                        Text(
                          entry.value.toString(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatPriorityLabel(entry.key),
                          style: TextStyle(
                            fontSize: 12,
                            color: color.withOpacity(0.8),
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildDepartmentPerformance() {
    final departments = _metricsData!.departmentPerformance;

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Department Performance',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: departments.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final dept = departments[index];
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dept.department,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1F2937),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${dept.completed}/${dept.total} completed',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${dept.completionRate.toStringAsFixed(1)}%',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color:
                                    dept.completionRate >= 80
                                        ? const Color(0xFF10B981)
                                        : dept.completionRate >= 60
                                        ? const Color(0xFFF59E0B)
                                        : const Color(0xFFEF4444),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${dept.pending} pending, ${dept.urgent} urgent',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xFF6B7280),
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
      case 'result_verified':
        return const Color(0xFF10B981); // Green
      case 'result_entered':
        return const Color(0xFF059669); // Dark Green
      case 'sample_processed':
        return const Color(0xFF3B82F6); // Blue
      case 'sample_collected':
        return const Color(0xFF6366F1); // Indigo
      case 'new':
        return const Color(0xFF8B5CF6); // Purple
      case 'in_progress':
        return const Color(0xFFF59E0B); // Amber
      case 'on_hold':
        return const Color(0xFFF97316); // Orange
      case 'cancelled':
        return const Color(0xFFEF4444); // Red
      default:
        return const Color(0xFF6B7280); // Gray
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'stat':
        return const Color(0xFFEF4444); // Red
      case 'urgent':
        return const Color(0xFFF59E0B); // Amber
      case 'routine':
        return const Color(0xFF3B82F6); // Blue
      case 'delayed':
        return const Color(0xFF6B7280); // Gray
      default:
        return const Color(0xFF6B7280);
    }
  }

  String _formatStatusLabel(String status) {
    return status
        .split('_')
        .map(
          (word) =>
              word.isNotEmpty
                  ? word[0].toUpperCase() + word.substring(1)
                  : word,
        )
        .join(' ');
  }

  String _formatPriorityLabel(String priority) {
    return priority.isNotEmpty
        ? priority[0].toUpperCase() + priority.substring(1)
        : priority;
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
