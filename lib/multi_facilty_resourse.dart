import 'package:flutter/material.dart';



class MultiFacilityResourceView extends StatefulWidget {
  const MultiFacilityResourceView({super.key});

  @override
  State<MultiFacilityResourceView> createState() =>
      _MultiFacilityResourceViewState();
}

class _MultiFacilityResourceViewState extends State<MultiFacilityResourceView> {
  int _selectedTabIndex = 0;

  final List<TabData> _tabs = [
    TabData(icon: Icons.bed, label: 'Bed Occupancy', isSelected: true),
    TabData(icon: Icons.attach_money, label: 'Revenue', isSelected: false),
    TabData(
      icon: Icons.calendar_today,
      label: 'Open Appointments',
      isSelected: false,
    ),
    TabData(icon: Icons.inventory, label: 'Inventory', isSelected: false),
  ];

  final List<FacilityData> _facilityData = [
    FacilityData(
      name: 'Downtown Medical',
      totalBeds: 120,
      occupied: 98,
      available: 22,
      occupancyRate: 0.82,
      status: FacilityStatus.high,
      statusColor: Colors.orange,
      indicatorColor: Colors.green,
    ),
    FacilityData(
      name: 'Suburban Care',
      totalBeds: 85,
      occupied: 62,
      available: 23,
      occupancyRate: 0.73,
      status: FacilityStatus.normal,
      statusColor: Colors.green,
      indicatorColor: Colors.green,
    ),
    FacilityData(
      name: 'East Side Clinic',
      totalBeds: 60,
      occupied: 58,
      available: 2,
      occupancyRate: 0.97,
      status: FacilityStatus.critical,
      statusColor: Colors.red,
      indicatorColor: Colors.red,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 32),
              _buildTabs(),
              const SizedBox(height: 32),
              _buildDataTable(),
              const SizedBox(height: 32),
              _buildQuickActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Multi-Facility Resource View',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  'Last updated: 2 minutes ago',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: () {
                // Refresh data logic
              },
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Refresh Data'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(width: 12),
            OutlinedButton.icon(
              onPressed: () {
                // Export logic
              },
              icon: const Icon(Icons.download, size: 18),
              label: const Text('Export'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return Row(
      children:
          _tabs.asMap().entries.map((entry) {
            int index = entry.key;
            TabData tab = entry.value;
            bool isSelected = index == _selectedTabIndex;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTabIndex = index;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(right: 32),
                padding: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color:
                          isSelected ? Colors.blue[600]! : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      tab.icon,
                      size: 20,
                      color: isSelected ? Colors.blue[600] : Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      tab.label,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected ? Colors.blue[600] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildDataTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildTableHeader(),
          ..._facilityData.map((facility) => _buildTableRow(facility)),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          const Expanded(
            flex: 2,
            child: Text(
              'Branch',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          const Expanded(
            flex: 1,
            child: Text(
              'Total Beds',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          const Expanded(
            flex: 1,
            child: Text(
              'Occupied',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          const Expanded(
            flex: 1,
            child: Text(
              'Available',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          const Expanded(
            flex: 2,
            child: Text(
              'Occupancy Rate',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          const Expanded(
            flex: 1,
            child: Text(
              'Status',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(FacilityData facility) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: facility.indicatorColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  facility.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              facility.totalBeds.toString(),
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              facility.occupied.toString(),
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              facility.available.toString(),
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: facility.occupancyRate,
                      child: Container(
                        decoration: BoxDecoration(
                          color: facility.statusColor,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${(facility.occupancyRate * 100).round()}%',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: facility.statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                facility.status.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: facility.statusColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                icon: Icons.local_shipping,
                title: 'Transfer Stock',
                color: Colors.blue[50]!,
                iconColor: Colors.blue[600]!,
                onTap: () {
                  // Transfer stock logic
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildActionCard(
                icon: Icons.person_add,
                title: 'Refer Patient to Another Branch',
                color: Colors.green[50]!,
                iconColor: Colors.green[600]!,
                onTap: () {
                  // Refer patient logic
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildActionCard(
                icon: Icons.support_agent,
                title: 'Request Staff Assistance',
                color: Colors.purple[50]!,
                iconColor: Colors.purple[600]!,
                onTap: () {
                  // Request staff assistance logic
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: iconColor.withOpacity(0.2), width: 1),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: iconColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TabData {
  final IconData icon;
  final String label;
  final bool isSelected;

  TabData({required this.icon, required this.label, required this.isSelected});
}

class FacilityData {
  final String name;
  final int totalBeds;
  final int occupied;
  final int available;
  final double occupancyRate;
  final FacilityStatus status;
  final Color statusColor;
  final Color indicatorColor;

  FacilityData({
    required this.name,
    required this.totalBeds,
    required this.occupied,
    required this.available,
    required this.occupancyRate,
    required this.status,
    required this.statusColor,
    required this.indicatorColor,
  });
}

enum FacilityStatus {
  high('High'),
  normal('Normal'),
  critical('Critical');

  const FacilityStatus(this.name);
  final String name;
}
