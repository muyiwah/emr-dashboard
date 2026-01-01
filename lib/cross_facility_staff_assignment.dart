import 'package:flutter/material.dart';


class StaffAssignmentScreen extends StatefulWidget {
  const StaffAssignmentScreen({Key? key}) : super(key: key);

  @override
  State<StaffAssignmentScreen> createState() => _StaffAssignmentScreenState();
}

class _StaffAssignmentScreenState extends State<StaffAssignmentScreen> {
  String selectedStaff = 'Dr. Sarah Johnson - Cardiologist';
  bool mainHospitalAssigned = true;
  bool northBranchAssigned = true;
  bool southBranchAssigned = false;

  // Permissions
  Map<String, Map<String, bool>> permissions = {
    'Main Hospital': {
      'Patient Records': true,
      'Prescriptions': true,
      'Scheduling': true,
      'Lab Results': true,
    },
    'North Branch': {
      'Patient Records': true,
      'Prescriptions': true,
      'Scheduling': false,
      'Lab Results': false,
    },
  };

  // Sync settings
  bool autoSync = true;
  bool conflictNotifications = true;
  bool crossFacilityCoverage = false;

  // Access control
  String accessControlMode = 'per-facility';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 200,
            color: Colors.white,
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: Color(0xFF4285F4),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: const Icon(
                          Icons.local_hospital,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'MediCare',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Admin',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                // Menu Items
                _buildMenuItem(Icons.dashboard, 'Dashboard', false),
                _buildMenuItem(Icons.people, 'Staff Management', true),
                _buildMenuItem(Icons.business, 'Facilities', false),
                _buildMenuItem(Icons.schedule, 'Scheduling', false),
                _buildMenuItem(Icons.settings, 'Settings', false),
              ],
            ),
          ),
          // Main Content
          Expanded(
            child: Column(
              children: [
                // Header
                Container(
                  height: 70,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_back, size: 20),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Cross-Facility Staff Assignment',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Manage staff assignments across multiple facilities',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('Add Assignment'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4285F4),
                          foregroundColor: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const CircleAvatar(
                        radius: 16,
                        // backgroundImage: NetworkImage(
                        //   'https://via.placeholder.com/32',
                        // ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Stats Cards
                        Row(
                          children: [
                            _buildStatCard(
                              'Total Multi-Facility Staff',
                              '127',
                              Icons.people,
                              const Color(0xFF4285F4),
                            ),
                            const SizedBox(width: 16),
                            _buildStatCard(
                              'Active Facilities',
                              '8',
                              Icons.business,
                              const Color(0xFF34A853),
                            ),
                            const SizedBox(width: 16),
                            _buildStatCard(
                              'Sync Status',
                              '98%',
                              Icons.sync,
                              const Color(0xFF9C27B0),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left Column
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  // Staff Transfer & Multi-Facility Roles
                                  _buildStaffTransferCard(),
                                  const SizedBox(height: 24),
                                  // Unified Schedule
                                  _buildUnifiedScheduleCard(),
                                  const SizedBox(height: 24),
                                  // Login Restriction Options
                                  _buildLoginRestrictionCard(),
                                ],
                              ),
                            ),
                            const SizedBox(width: 24),
                            // Right Column
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  // Permissions per Location
                                  _buildPermissionsCard(),
                                  const SizedBox(height: 24),
                                  // Sync Settings
                                  _buildSyncSettingsCard(),
                                ],
                              ),
                            ),
                          ],
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

  Widget _buildMenuItem(IconData icon, String title, bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF4285F4) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          size: 20,
          color: isActive ? Colors.white : Colors.grey[600],
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: isActive ? Colors.white : Colors.grey[800],
            fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        dense: true,
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
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
                  title,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 16),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStaffTransferCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.swap_horiz, color: Color(0xFF4285F4), size: 20),
              const SizedBox(width: 8),
              const Text(
                'Staff Transfer & Multi-Facility Roles',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Select Staff Member',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedStaff,
                isExpanded: true,
                items:
                    [
                      'Dr. Sarah Johnson - Cardiologist',
                      'Dr. Michael Chen - Radiologist',
                      'Dr. Emily Davis - Emergency',
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedStaff = newValue!;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Assign to Facilities',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          _buildFacilityCheckbox(
            'Main Hospital',
            'Primary assignment',
            mainHospitalAssigned,
            (value) {
              setState(() {
                mainHospitalAssigned = value!;
              });
            },
          ),
          _buildFacilityCheckbox(
            'North Branch',
            'Secondary assignment',
            northBranchAssigned,
            (value) {
              setState(() {
                northBranchAssigned = value!;
              });
            },
          ),
          _buildFacilityCheckbox(
            'South Branch',
            'Available for assignment',
            southBranchAssigned,
            (value) {
              setState(() {
                southBranchAssigned = value!;
              });
            },
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4285F4),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Update Assignments'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFacilityCheckbox(
    String name,
    String subtitle,
    bool value,
    Function(bool?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF4285F4),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.security, color: Color(0xFF4285F4), size: 20),
              const SizedBox(width: 8),
              const Text(
                'Permissions per Location',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Dr. Sarah Johnson',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          _buildLocationPermissions(
            'Main Hospital',
            'Full Access',
            permissions['Main Hospital']!,
          ),
          const SizedBox(height: 16),
          _buildLocationPermissions(
            'North Branch',
            'Limited',
            permissions['North Branch']!,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF34A853),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Save Permissions'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationPermissions(
    String location,
    String accessLevel,
    Map<String, bool> perms,
  ) {
    Color accessColor =
        accessLevel == 'Full Access' ? const Color(0xFF34A853) : Colors.orange;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                location,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: accessColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  accessLevel,
                  style: TextStyle(
                    fontSize: 12,
                    color: accessColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...perms.entries.map(
            (entry) => _buildPermissionRow(entry.key, entry.value),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionRow(String permission, bool granted) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Checkbox(
            value: granted,
            onChanged: (value) {
              setState(() {
                if (permission == 'Patient Records' ||
                    permission == 'Prescriptions') {
                  permissions['Main Hospital']![permission] = value!;
                } else {
                  permissions['North Branch']![permission] = value!;
                }
              });
            },
            activeColor: const Color(0xFF4285F4),
          ),
          Text(permission, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildUnifiedScheduleCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline,
                color: Color(0xFF4285F4),
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Unified Schedule Across Branches',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Current Week Schedule',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          _buildScheduleItem(
            'Dr. Sarah Johnson',
            'Mon 8:00 AM - 6:00 PM',
            'Main Hospital',
            'On Duty',
          ),
          _buildScheduleItem(
            'Dr. Michael Chen',
            'Mon 2:00 PM - 10:00 PM',
            'North Branch',
            'Radiologist Available',
          ),
          _buildScheduleItem(
            'Dr. Emily Davis',
            'Mon 6:00 PM - 6:00 AM',
            'Emergency',
            'Night Shift',
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleItem(
    String name,
    String time,
    String location,
    String status,
  ) {
    Color statusColor =
        status == 'On Duty'
            ? const Color(0xFF4285F4)
            : status == 'Radiologist Available'
            ? const Color(0xFF34A853)
            : const Color(0xFF9C27B0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                location,
                style: TextStyle(
                  fontSize: 12,
                  color: statusColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                status,
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSyncSettingsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sync Settings',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          _buildSyncOption(
            'Auto-sync schedules',
            'Real-time updates across facilities',
            autoSync,
            (value) => setState(() => autoSync = value),
          ),
          _buildSyncOption(
            'Conflict notifications',
            'Alert on scheduling conflicts',
            conflictNotifications,
            (value) => setState(() => conflictNotifications = value),
          ),
          _buildSyncOption(
            'Cross-facility coverage',
            'Auto-suggest coverage options',
            crossFacilityCoverage,
            (value) => setState(() => crossFacilityCoverage = value),
          ),
        ],
      ),
    );
  }

  Widget _buildSyncOption(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF4285F4),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginRestrictionCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lock, color: Color(0xFF4285F4), size: 20),
              const SizedBox(width: 8),
              const Text(
                'Login Restriction Options',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Access Control Settings',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          RadioListTile<String>(
            title: const Text('Per-facility Access'),
            subtitle: const Text(
              'Staff can only access systems at assigned facilities',
            ),
            value: 'per-facility',
            groupValue: accessControlMode,
            onChanged: (value) {
              setState(() {
                accessControlMode = value!;
              });
            },
            activeColor: const Color(0xFF4285F4),
          ),
          RadioListTile<String>(
            title: const Text('Universal Access'),
            subtitle: const Text(
              'Staff can access any facility with appropriate permissions',
            ),
            value: 'universal',
            groupValue: accessControlMode,
            onChanged: (value) {
              setState(() {
                accessControlMode = value!;
              });
            },
            activeColor: const Color(0xFF4285F4),
          ),
          const SizedBox(height: 16),
          const Text(
            'Current Restrictions',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          _buildRestrictionItem(
            'Dr. Sarah Johnson',
            '2 facilities access',
            'Active',
          ),
          _buildRestrictionItem(
            'Dr. Michael Chen',
            '3 facilities access',
            'Active',
          ),
          _buildRestrictionItem(
            'Dr. Emily Davis',
            'Universal access',
            'Unrestricted',
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4285F4),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Apply Settings'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Reset to Default'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRestrictionItem(String name, String access, String status) {
    Color statusColor =
        status == 'Active' ? const Color(0xFF4285F4) : const Color(0xFF34A853);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  access,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 12,
                color: statusColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
