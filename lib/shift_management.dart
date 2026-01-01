import 'package:flutter/material.dart';
import 'package:schmgtsystem/widgets/stafff_shift_popup.dart';

class ShiftManagemt extends StatefulWidget {
  @override
  _ShiftManagemtState createState() => _ShiftManagemtState();
}

class _ShiftManagemtState extends State<ShiftManagemt> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Row(
          children: [
            // Left Sidebar
            Container(
              width: 280,
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Container(
                      padding: EdgeInsets.all(20),
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
                                    'Staff Shift Assignment',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today,
                                        size: 14,
                                        color: Colors.grey[600],
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'Week of Jan 15-21, 2024',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              _buildActionButton(
                                'Export',
                                Icons.download,
                                Colors.grey[200]!,
                                Colors.black87,
                              ),
                              SizedBox(width: 8),
                              _buildActionButton(
                                'Add Staff',
                                Icons.add,
                                Colors.blue[600]!,
                                Colors.white,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                
                    // Stats Row
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          _buildStatCard(
                            '127',
                            'Total Shifts Scheduled',
                            Colors.blue[600]!,
                          ),
                          SizedBox(width: 12),
                          _buildStatCard('8', 'Unfilled Slots', Colors.red[600]!),
                        ],
                      ),
                    ),
                    SizedBox(height: 12),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          _buildStatCard(
                            '12',
                            'Staff on Leave',
                            Colors.orange[600]!,
                          ),
                          SizedBox(width: 12),
                          _buildStatCard(
                            '3',
                            'Shift Conflicts',
                            Colors.yellow[700]!,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: _buildStatCard(
                        '0',
                        'Upcoming Holidays',
                        Colors.green[600]!,
                      ),
                    ),
                
                    SizedBox(height: 30),
                
                    // Staff Pool Section
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Staff Pool',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 16),
                
                          // Search bar
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search staff...',
                                prefixIcon: Icon(
                                  Icons.search,
                                  size: 20,
                                  color: Colors.grey[500],
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                                hintStyle: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                
                          SizedBox(height: 16),
                
                          // Filter dropdowns
                          _buildDropdown('All Roles'),
                          SizedBox(height: 8),
                          _buildDropdown('All Departments'),
                          SizedBox(height: 8),
                          _buildDropdown('All Status'),
                
                          SizedBox(height: 20),
                
                          // Staff list
                          _buildStaffCard(
                            'Dr. Sarah Chen',
                            'Doctor • Emergency',
                            'Available',
                            Colors.green[600]!,
                          ),
                          SizedBox(height: 12),
                          _buildStaffCard(
                            'Mark Johnson',
                            'Nurse • Surgery',
                            'Morning Shift',
                            Colors.blue[600]!,
                          ),
                          SizedBox(height: 12),
                          _buildStaffCard(
                            'Dr. Michael Brown',
                            'Doctor • Pediatrics',
                            'Afternoon Shift',
                            Colors.orange[600]!,
                          ),
                          SizedBox(height: 12),
                          _buildStaffCard(
                            'Lisa Wang',
                            'Lab Tech • Lab',
                            'On Leave',
                            Colors.grey[600]!,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Main Content Area
            Expanded(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Schedule Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Weekly Shift Schedule',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.chevron_left),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: Icon(Icons.chevron_right),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 20),

                    // Schedule Grid
                    Expanded(
                      child: Container(
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
                          children: [
                            // Days header
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.grey[200]!),
                                ),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(width: 120),
                                  ..._buildDayHeaders(),
                                ],
                              ),
                            ),

                            // Schedule rows
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    _buildShiftRow(
                                      'Morning',
                                      '6AM-2PM',
                                      Colors.blue[50]!,
                                      _getMorningShifts(),
                                    ),
                                    _buildShiftRow(
                                      'Afternoon',
                                      '2PM-10PM',
                                      Colors.orange[50]!,
                                      _getAfternoonShifts(),
                                    ),
                                    _buildShiftRow(
                                      'Night',
                                      '10PM-6AM',
                                      Colors.purple[50]!,
                                      _getNightShifts(),
                                    ),
                                    _buildShiftRow(
                                      'On-Call',
                                      '24/7',
                                      Colors.green[50]!,
                                      _getOnCallShifts(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String text,
    IconData icon,
    Color bgColor,
    Color textColor,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: textColor),
          SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String number, String label, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              number,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, style: TextStyle(fontSize: 14, color: Colors.black87)),
          Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.grey[600]),
        ],
      ),
    );
  }

  Widget _buildStaffCard(
    String name,
    String role,
    String status,
    Color statusColor,
  ) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: statusColor.withOpacity(0.2),
            child: Icon(Icons.person, size: 16, color: statusColor),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  role,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 10,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDayHeaders() {
    final days = [
      'Mon 15',
      'Tue 16',
      'Wed 17',
      'Thu 18',
      'Fri 19',
      'Sat 20',
      'Sun 21',
    ];
    return days
        .map(
          (day) => Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                day,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        )
        .toList();
  }

  Widget _buildShiftRow(
    String shiftName,
    String timeRange,
    Color bgColor,
    List<List<Widget>> shifts,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          Container(
            width: 120,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: bgColor,
              border: Border(right: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shiftName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  timeRange,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          ...shifts
              .map(
                (dayShifts) => Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Column(children: dayShifts),
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  List<List<Widget>> _getMorningShifts() {
    return [
      [
        _buildAssignedStaff('Dr. Sarah Chen', 'Emergency'),
        _buildAssignButton(),
      ],
      [_buildAssignButton()],
      [_buildAssignedStaff('Mark Johnson', 'Nurse'), _buildAssignButton()],
      [_buildAssignButton()],
      [
        _buildAssignedStaff('Dr. Michael Brown', 'Pediatrics'),
        _buildAssignButton(),
      ],
      [_buildAssignButton()],
      [_buildAssignButton()],
    ];
  }

  List<List<Widget>> _getAfternoonShifts() {
    return [
      [_buildAssignedStaff('James Wilson', 'Nurse')],
      [_buildAssignedStaff('Lisa Wang', 'Lab Tech'), _buildConflictBadge()],
      [_buildAssignButton()],
      [_buildAssignButton()],
      [_buildAssignButton()],
      [_buildAssignButton()],
      [_buildAssignButton()],
    ];
  }

  List<List<Widget>> _getNightShifts() {
    return [
      [
        _buildAssignedStaff('Dr. Emma Davis', 'Emergency'),
        _buildAssignButton(),
      ],
      [_buildAssignButton()],
      [_buildAssignButton()],
      [_buildAssignButton()],
      [_buildAssignButton()],
      [_buildAssignButton()],
      [_buildAssignButton()],
    ];
  }

  List<List<Widget>> _getOnCallShifts() {
    return [
      [_buildAssignedStaff('Dr. Anna Miller', 'Surgery')],
      [Container()],
      [Container()],
      [Container()],
      [Container()],
      [Container()],
      [Container()],
    ];
  }

  Widget _buildAssignedStaff(String name, String department) {
    return Container(
      margin: EdgeInsets.only(bottom: 4),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: Colors.blue[100],
            child: Icon(Icons.person, size: 12, color: Colors.blue[600]),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  department,
                  style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignButton() {
    return GestureDetector(
      onTap: () {
        showDialog(context: context, builder: (context) => AssignStaffPopup());
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 4),
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.blue[600],
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, size: 12, color: Colors.white),
            SizedBox(width: 4),
            Text(
              'Assign Staff',
              style: TextStyle(
                fontSize: 8,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConflictBadge() {
    return Container(
      margin: EdgeInsets.only(top: 4),
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.yellow[600],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.warning, size: 10, color: Colors.white),
          SizedBox(width: 2),
          Text(
            'Conflict',
            style: TextStyle(
              fontSize: 8,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
