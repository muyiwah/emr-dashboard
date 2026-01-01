import 'package:flutter/material.dart';



class ImmunizationsScreen extends StatefulWidget {
  const ImmunizationsScreen({super.key});

  @override
  State<ImmunizationsScreen> createState() => _ImmunizationsScreenState();
}

class _ImmunizationsScreenState extends State<ImmunizationsScreen> {
  String selectedStatus = 'All Status';
  String selectedVaccineType = 'All Vaccines';
  final TextEditingController searchController = TextEditingController();

  final List<ImmunizationRecord> immunizations = [
    ImmunizationRecord(
      name: 'COVID-19 Vaccine (Pfizer)',
      type: 'mRNA vaccine',
      icon: Icons.shield,
      iconColor: Colors.blue,
      status: ImmunizationStatus.completed,
      dateGiven: 'March 15, 2024',
      provider: 'Dr. Sarah Johnson',
      lotNumber: 'PF123456',
      nextDue: 'Sept 15, 2024',
      notes: 'Second dose completed. No adverse reactions reported.',
    ),
    ImmunizationRecord(
      name: 'Influenza Vaccine',
      type: 'Seasonal flu vaccine',
      icon: Icons.vaccines,
      iconColor: Colors.green,
      status: ImmunizationStatus.due,
      lastGiven: 'Oct 12, 2023',
      provider: 'Dr. Michael Chen',
      dueDate: 'Oct 12, 2024',
      statusText: 'Overdue by 2 days',
    ),
    ImmunizationRecord(
      name: 'Hepatitis B',
      type: 'Hepatitis B vaccine',
      icon: Icons.medical_services,
      iconColor: Colors.purple,
      status: ImmunizationStatus.completed,
      dateGiven: 'Jan 20, 2024',
      provider: 'Dr. Emily Davis',
      series: '3 of 3',
      nextDue: 'Jan 20, 2034',
    ),
    ImmunizationRecord(
      name: 'MMR (Measles, Mumps, Rubella)',
      type: 'Combined vaccine',
      icon: Icons.coronavirus,
      iconColor: Colors.red,
      status: ImmunizationStatus.scheduled,
      scheduledDate: 'Nov 20, 2024',
      provider: 'Dr. Sarah Johnson',
      location: 'Main Clinic',
      time: '10:30 AM',
      notes: 'Booster dose scheduled. Patient reminded via SMS.',
    ),
    ImmunizationRecord(
      name: 'Tetanus, Diphtheria, Pertussis (Tdap)',
      type: 'Combined vaccine',
      icon: Icons.health_and_safety,
      iconColor: Colors.orange,
      status: ImmunizationStatus.completed,
      dateGiven: 'Aug 10, 2022',
      provider: 'Dr. Michael Chen',
      lotNumber: 'TD789012',
      nextDue: 'Aug 10, 2032',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Immunizations',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            Text(
              'Patient: John Smith • DOB: 03/15/1985',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.download, color: Colors.grey),
            label: const Text(
              'Export PDF',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text('Add Immunization'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00BCD4),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          // Stats Cards
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildStatCard(
                  '12',
                  'Completed',
                  Colors.green,
                  Icons.check_circle,
                ),
                const SizedBox(width: 16),
                _buildStatCard('3', 'Due', Colors.orange, Icons.warning),
                const SizedBox(width: 16),
                _buildStatCard('2', 'Scheduled', Colors.blue, Icons.schedule),
              ],
            ),
          ),

          // Filters
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                const Text(
                  'Filter by Status:',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 8),
                _buildDropdown(
                  selectedStatus,
                  ['All Status', 'Completed', 'Due', 'Scheduled'],
                  (value) {
                    setState(() => selectedStatus = value!);
                  },
                ),
                const SizedBox(width: 24),
                const Text(
                  'Vaccine Type:',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 8),
                _buildDropdown(
                  selectedVaccineType,
                  ['All Vaccines', 'mRNA vaccine', 'Combined vaccine'],
                  (value) {
                    setState(() => selectedVaccineType = value!);
                  },
                ),
                const SizedBox(width: 16),
                IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search vaccines...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Immunization List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: immunizations.length,
              itemBuilder: (context, index) {
                return _buildImmunizationCard(immunizations[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String number,
    String label,
    Color color,
    IconData icon,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  number,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          items:
              items
                  .map(
                    (item) => DropdownMenuItem(value: item, child: Text(item)),
                  )
                  .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildImmunizationCard(ImmunizationRecord record) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: record.iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(record.icon, color: record.iconColor, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        record.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        record.type,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(record.status),
              ],
            ),
            const SizedBox(height: 16),
            _buildRecordDetails(record),
            if (record.notes != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Notes',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
                    Text(record.notes!),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(ImmunizationStatus status) {
    Color color;
    String text;
    switch (status) {
      case ImmunizationStatus.completed:
        color = Colors.green;
        text = 'Completed';
        break;
      case ImmunizationStatus.due:
        color = Colors.orange;
        text = 'Due';
        break;
      case ImmunizationStatus.scheduled:
        color = Colors.blue;
        text = 'Scheduled';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            status == ImmunizationStatus.completed
                ? Icons.check
                : status == ImmunizationStatus.due
                ? Icons.warning
                : Icons.schedule,
            color: color,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordDetails(ImmunizationRecord record) {
    List<Widget> details = [];

    if (record.status == ImmunizationStatus.scheduled) {
      details.addAll([
        _buildDetailRow('Scheduled Date', record.scheduledDate!),
        _buildDetailRow('Provider', record.provider),
        _buildDetailRow('Location', record.location!),
        _buildDetailRow('Time', record.time!),
      ]);
    } else if (record.status == ImmunizationStatus.due) {
      details.addAll([
        _buildDetailRow('Last Given', record.lastGiven!),
        _buildDetailRow('Provider', record.provider),
        _buildDetailRow('Due Date', record.dueDate!),
        _buildDetailRow(
          'Status',
          record.statusText!,
          isColored: true,
          color: Colors.orange,
        ),
      ]);
    } else {
      details.addAll([
        _buildDetailRow('Date Given', record.dateGiven!),
        _buildDetailRow('Provider', record.provider),
        if (record.lotNumber != null)
          _buildDetailRow('Lot Number', record.lotNumber!),
        if (record.series != null) _buildDetailRow('Series', record.series!),
        _buildDetailRow('Next Due', record.nextDue!),
      ]);
    }

    return Column(children: details);
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    bool isColored = false,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: isColored ? color : Colors.black,
                fontWeight: isColored ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum ImmunizationStatus { completed, due, scheduled }

class ImmunizationRecord {
  final String name;
  final String type;
  final IconData icon;
  final Color iconColor;
  final ImmunizationStatus status;
  final String provider;

  // For completed vaccines
  final String? dateGiven;
  final String? lotNumber;
  final String? series;
  final String? nextDue;

  // For due vaccines
  final String? lastGiven;
  final String? dueDate;
  final String? statusText;

  // For scheduled vaccines
  final String? scheduledDate;
  final String? location;
  final String? time;

  final String? notes;

  ImmunizationRecord({
    required this.name,
    required this.type,
    required this.icon,
    required this.iconColor,
    required this.status,
    required this.provider,
    this.dateGiven,
    this.lotNumber,
    this.series,
    this.nextDue,
    this.lastGiven,
    this.dueDate,
    this.statusText,
    this.scheduledDate,
    this.location,
    this.time,
    this.notes,
  });
}
