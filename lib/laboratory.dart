import 'package:flutter/material.dart';



class LabHubHomePage extends StatefulWidget {
  const LabHubHomePage({super.key});

  @override
  State<LabHubHomePage> createState() => _LabHubHomePageState();
}

class _LabHubHomePageState extends State<LabHubHomePage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedCategoryIndex = 0;
  String _selectedPriority = 'Routine';
  bool _sendAlert = false;

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Hematology', 'icon': Icons.bloodtype, 'color': Colors.red},
    {'name': 'Radiology', 'icon': Icons.medical_services, 'color': Colors.blue},
    {'name': 'Urinalysis', 'icon': Icons.science, 'color': Colors.green},
    {'name': 'Cardiology', 'icon': Icons.favorite, 'color': Colors.purple},
    {'name': 'Genetics', 'icon': Icons.biotech, 'color': Colors.orange},
  ];

  final List<Map<String, dynamic>> _sampleData = [
    {
      'testName': 'Complete Blood Count',
      'barcodeId': 'CBC001234',
      'status': 'In Lab',
      'technician': 'Dr. Smith',
      'statusColor': Colors.orange,
    },
    {
      'testName': 'Chest X-Ray',
      'barcodeId': 'XRY005678',
      'status': 'Processed',
      'technician': 'Tech Johnson',
      'statusColor': Colors.green,
    },
  ];

  final List<Map<String, dynamic>> _alerts = [
    {
      'type': 'Critical glucose level detected',
      'patient': 'John Doe',
      'id': 'CBC001234',
      'isViewed': false,
      'color': Colors.red,
      'icon': Icons.warning,
    },
    {
      'type': 'STAT order pending review',
      'patient': 'Jane Smith',
      'id': 'XRY005678',
      'isViewed': true,
      'color': Colors.orange,
      'icon': Icons.pending_actions,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Row(
              children: [_buildSidebar(), Expanded(child: _buildMainContent())],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 200,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF4ECDC4),
            Color(0xFF44A08D),
            Color(0xFF093637),
            Color(0xFF5B51A3),
            Color(0xFF6B73FF),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Laboratory Hub',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Track, process, and review lab diagnostics effortlessly',
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text('Create New Lab Order'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.teal,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 250,
      color: Colors.grey[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Lab Categories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          ..._categories.asMap().entries.map((entry) {
            int index = entry.key;
            Map<String, dynamic> category = entry.value;
            bool isSelected = index == _selectedCategoryIndex;

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              child: ListTile(
                leading: Icon(
                  category['icon'],
                  color: isSelected ? Colors.white : category['color'],
                ),
                title: Text(
                  category['name'],
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                tileColor: isSelected ? category['color'] : null,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                onTap: () {
                  setState(() {
                    _selectedCategoryIndex = index;
                  });
                },
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildOrderEntry(), _buildResults(), _buildHistory()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TabBar(
        controller: _tabController,
        labelColor: Colors.teal,
        unselectedLabelColor: Colors.grey,
        indicatorColor: Colors.teal,
        tabs: const [
          Tab(text: 'Order Entry'),
          Tab(text: 'Results'),
          Tab(text: 'History'),
        ],
      ),
    );
  }

  Widget _buildOrderEntry() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildNewLabOrderCard(),
          const SizedBox(height: 24),
          _buildSampleTrackingCard(),
          const SizedBox(height: 24),
          _buildResultEntryCard(),
          const SizedBox(height: 24),
          _buildRecentAlertsCard(),
        ],
      ),
    );
  }

  Widget _buildNewLabOrderCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'New Lab Order',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Patient Selection',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Search patient by name or ID',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.search),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'ICD-10 Code',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Enter diagnosis code',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Test Selection',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Search tests...',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.science),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Priority',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedPriority,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        items:
                            ['Routine', 'STAT', 'Urgent'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _selectedPriority = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Create Order'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSampleTrackingCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Sample Tracking',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text('Scan Barcode'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(1),
                3: FlexColumnWidth(2),
                4: FlexColumnWidth(1),
              },
              children: [
                const TableRow(
                  decoration: BoxDecoration(color: Color(0xFFF5F5F5)),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        'TEST NAME',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        'BARCODE ID',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        'STATUS',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        'TECHNICIAN',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        'ACTIONS',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                ..._sampleData.map(
                  (sample) => TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(sample['testName']),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(sample['barcodeId']),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: sample['statusColor'].withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: sample['statusColor']),
                          ),
                          child: Text(
                            sample['status'],
                            style: TextStyle(
                              color: sample['statusColor'],
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(sample['technician']),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.teal),
                              onPressed: () {},
                              iconSize: 20,
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.visibility,
                                color: Colors.blue,
                              ),
                              onPressed: () {},
                              iconSize: 20,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultEntryCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Result Entry',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Manual Result Input',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        maxLines: 4,
                        decoration: const InputDecoration(
                          hintText: 'Enter test results...',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.all(12),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'File Attachments',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 120,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cloud_upload,
                              size: 40,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 8),
                            Text('Drag & drop files or click to upload'),
                            Text(
                              'Support: JPG, PNG, PDF',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
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
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: _sendAlert,
                  onChanged: (bool? value) {
                    setState(() {
                      _sendAlert = value!;
                    });
                  },
                ),
                const Text('Send alert to doctor and patient'),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('Save Draft'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Submit Results'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentAlertsCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Alerts',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ..._alerts
                .map(
                  (alert) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: alert['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: alert['color'].withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(alert['icon'], color: alert['color']),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                alert['type'],
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: alert['color'],
                                ),
                              ),
                              Text(
                                'Patient: ${alert['patient']} • ${alert['id']}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: alert['isViewed'] ? Colors.grey : Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            alert['isViewed'] ? 'Viewed' : 'Unviewed',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildResults() {
    return const Center(
      child: Text(
        'Results View',
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
    );
  }

  Widget _buildHistory() {
    return const Center(
      child: Text(
        'History View',
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
    );
  }
}
