import 'package:flutter/material.dart';



class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  int selectedTabIndex = 0;
  bool pushNotifications = true;
  bool smsNotifications = false;
  bool emailSummary = true;
  bool appointmentsCategory = true;
  bool labResultsCategory = true;
  bool medicationsCategory = false;
  String messageRecipient = 'Select Recipient';
  String messageSubject = '';
  String messageContent = '';
  String messagePriority = 'Normal';

  final List<String> tabTitles = [
    'Appointments',
    'Lab Results',
    'Prescriptions',
    'Alerts',
  ];
  final List<IconData> tabIcons = [
    Icons.calendar_today_outlined,
    Icons.science_outlined,
    Icons.medication_outlined,
    Icons.warning_amber_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Panel - Notification Center
              Expanded(flex: 8, child: _buildNotificationCenter()),
              const SizedBox(width: 20),
              // Right Panel - Settings, Analytics, Messaging
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    _buildNotificationSettings(),
                    const SizedBox(height: 20),
                    _buildAnalytics(),
                    const SizedBox(height: 20),
                    _buildInternalMessaging(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCenter() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Color(0xFF6366F1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.notifications,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Notifications & Reminders',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
                const Spacer(),
                Stack(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF3F4F6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 16,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    Positioned(
                      top: 2,
                      right: 2,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFFEF4444),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                const Icon(Icons.settings, size: 20, color: Color(0xFF6B7280)),
                const SizedBox(width: 12),
                const CircleAvatar(
                  radius: 16,
                  backgroundColor: Color(0xFFE5E7EB),
                  child: Icon(Icons.person, size: 16, color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),

          // Sub-header
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Row(
              children: [
                const Text(
                  'Notification Center',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFD1D5DB)),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'All Roles',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF374151),
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: 16,
                        color: Color(0xFF6B7280),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.tune, size: 14, color: Colors.white),
                      SizedBox(width: 4),
                      Text(
                        'Filters',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Tabs
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children:
                  tabTitles.asMap().entries.map((entry) {
                    int index = entry.key;
                    String title = entry.value;
                    IconData icon = tabIcons[index];
                    bool isSelected = selectedTabIndex == index;

                    return GestureDetector(
                      onTap: () => setState(() => selectedTabIndex = index),
                      child: Container(
                        margin: const EdgeInsets.only(right: 40),
                        padding: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color:
                                  isSelected
                                      ? const Color(0xFF6366F1)
                                      : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              icon,
                              size: 16,
                              color:
                                  isSelected
                                      ? const Color(0xFF6366F1)
                                      : const Color(0xFF6B7280),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              title,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight:
                                    isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                color:
                                    isSelected
                                        ? const Color(0xFF6366F1)
                                        : const Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),

          const SizedBox(height: 20),

          // Notification Items
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              children: [
                _buildUpcomingAppointment(),
                const SizedBox(height: 16),
                _buildConfirmedAppointment(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingAppointment() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0FF),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E7FF)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.calendar_today,
              size: 20,
              color: Color(0xFF6366F1),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Upcoming Appointment',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Dr. Smith - Cardiology consultation',
                  style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Tomorrow at 2:00 PM',
                  style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'View Details',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: const Color(0xFFD1D5DB)),
                ),
                child: const Text(
                  'Reschedule',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF374151),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmedAppointment() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFBBF7D0)),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 20, color: Color(0xFF10B981)),
          const SizedBox(width: 12),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.calendar_today,
              size: 20,
              color: Color(0xFF10B981),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Appointment Confirmed',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Dr. Johnson - Follow-up visit',
                  style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Friday at 10:30 AM',
                  style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'View Details',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSettings() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Notification Settings',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Delivery Methods',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 12),
          _buildCheckboxItem(
            'Push Notifications',
            pushNotifications,
            (val) => setState(() => pushNotifications = val!),
          ),
          _buildCheckboxItem(
            'SMS Notifications',
            smsNotifications,
            (val) => setState(() => smsNotifications = val!),
          ),
          _buildCheckboxItem(
            'Email Summary',
            emailSummary,
            (val) => setState(() => emailSummary = val!),
          ),

          const SizedBox(height: 20),

          const Text(
            'Categories',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 12),
          _buildCheckboxItem(
            'Appointments',
            appointmentsCategory,
            (val) => setState(() => appointmentsCategory = val!),
          ),
          _buildCheckboxItem(
            'Lab Results',
            labResultsCategory,
            (val) => setState(() => labResultsCategory = val!),
          ),
          _buildCheckboxItem(
            'Medications',
            medicationsCategory,
            (val) => setState(() => medicationsCategory = val!),
          ),

          const SizedBox(height: 20),

          const Text(
            'Quiet Hours',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildTimeField('10:00 PM')),
              const SizedBox(width: 12),
              Expanded(child: _buildTimeField('07:00 AM')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnalytics() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Analytics',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 20),

          _buildMetricRow('Click-through Rate', '87%', const Color(0xFF8B5CF6)),
          const SizedBox(height: 12),
          _buildMetricRow('Read Rate', '92%', const Color(0xFF06B6D4)),

          const SizedBox(height: 20),

          // Chart
          SizedBox(
            height: 100,
            child: Row(
              children: [
                // Y-axis labels
                SizedBox(
                  width: 20,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        '100',
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      const Text(
                        '80',
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      const Text(
                        '60',
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      const Text(
                        '40',
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      const Text(
                        '20',
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Bars
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildBar(0.85, const Color(0xFF8B5CF6), 'Email'),
                      _buildBar(0.75, const Color(0xFF06B6D4), 'SMS'),
                      _buildBar(0.90, const Color(0xFF10B981), 'Push'),
                      _buildBar(0.95, const Color(0xFFF59E0B), 'In-App'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInternalMessaging() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Internal Messaging',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 20),

          Row(
            children: [
              const Expanded(
                child: Text(
                  'Send Message',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF374151),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              const Expanded(
                child: Text(
                  'Recent Messages',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF374151),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Send Message Form
              Expanded(
                child: Column(
                  children: [
                    _buildDropdownField('Select Recipient'),
                    const SizedBox(height: 12),
                    _buildInputField('Subject'),
                    const SizedBox(height: 12),
                    _buildTextAreaField('Message'),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildDropdownField('Normal')),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6366F1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Send',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),

              // Recent Messages
              Expanded(child: _buildRecentMessage()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxItem(
    String title,
    bool value,
    Function(bool?) onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: const Color(0xFF6366F1),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(fontSize: 14, color: Color(0xFF374151)),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeField(String time) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD1D5DB)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              time,
              style: const TextStyle(fontSize: 14, color: Color(0xFF374151)),
            ),
          ),
          const Icon(Icons.access_time, size: 16, color: Color(0xFF6B7280)),
        ],
      ),
    );
  }

  Widget _buildMetricRow(String label, String value, Color color) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 14, color: Color(0xFF374151)),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildBar(double percentage, Color color, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 20,
          height: 80 * percentage,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(2)),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280)),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD1D5DB)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
            ),
          ),
          const Icon(
            Icons.keyboard_arrow_down,
            size: 16,
            color: Color(0xFF6B7280),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD1D5DB)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        hint,
        style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
      ),
    );
  }

  Widget _buildTextAreaField(String hint) {
    return Container(
      padding: const EdgeInsets.all(12),
      height: 80,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD1D5DB)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          hint,
          style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
        ),
      ),
    );
  }

  Widget _buildRecentMessage() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Dr. Wilson',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
              ),
              const Text(
                '2h ago',
                style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Emergency protocol update',
            style: TextStyle(fontSize: 13, color: Color(0xFF374151)),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFEF4444),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'Urgent',
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
}
