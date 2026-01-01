import 'package:flutter/material.dart';


class PhysicalExaminationScreen extends StatefulWidget {
  const PhysicalExaminationScreen({super.key});

  @override
  State<PhysicalExaminationScreen> createState() =>
      _PhysicalExaminationScreenState();
}

class _PhysicalExaminationScreenState extends State<PhysicalExaminationScreen> {
  String _overallAppearance = 'Normal';
  String _mentalStatus = 'Alert & Oriented';
  final TextEditingController _notesController = TextEditingController();

  // Expansion panel states
  bool _generalAppearanceExpanded = true;
  bool _heentExpanded = false;
  bool _chestLungsExpanded = false;
  bool _cardiovascularExpanded = false;
  bool _abdomenExpanded = false;
  bool _musculoskeletalExpanded = false;
  bool _neurologicalExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            // Patient Info
            _buildPatientInfo(),
            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: _buildExaminationSections(),
              ),
            ),
            // Bottom Buttons
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.description, color: Colors.blue, size: 24),
          const SizedBox(width: 8),
          const Text(
            'Physical Examination Record',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const Spacer(),
          _buildHeaderButton('Load Previous', Colors.white, Colors.blue),
          const SizedBox(width: 8),
          _buildHeaderButton('Copy Normal', Colors.green, Colors.white),
          const SizedBox(width: 8),
          _buildHeaderButton('Save Record', Colors.blue, Colors.white),
        ],
      ),
    );
  }

  Widget _buildHeaderButton(
    String text,
    Color backgroundColor,
    Color textColor,
  ) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side:
              backgroundColor == Colors.white
                  ? const BorderSide(color: Colors.blue)
                  : BorderSide.none,
        ),
        elevation: 1,
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildPatientInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          _buildInfoItem('Patient:', 'John Smith'),
          const SizedBox(width: 32),
          _buildInfoItem('DOB:', '01/15/1985'),
          const SizedBox(width: 32),
          _buildInfoItem('MRN:', '12345678'),
          const Spacer(),
          _buildInfoItem('Date:', '12/18/2024'),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 14, color: Colors.black87),
        children: [
          TextSpan(
            text: '$label ',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }

  Widget _buildExaminationSections() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            switch (index) {
              case 0:
                _generalAppearanceExpanded = !isExpanded;
                break;
              case 1:
                _heentExpanded = !isExpanded;
                break;
              case 2:
                _chestLungsExpanded = !isExpanded;
                break;
              case 3:
                _cardiovascularExpanded = !isExpanded;
                break;
              case 4:
                _abdomenExpanded = !isExpanded;
                break;
              case 5:
                _musculoskeletalExpanded = !isExpanded;
                break;
              case 6:
                _neurologicalExpanded = !isExpanded;
                break;
            }
          });
        },
        children: [
          _buildGeneralAppearancePanel(),
          _buildExaminationPanel(
            'HEENT (Head, Eyes, Ears, Nose, Throat)',
            Icons.visibility,
            Colors.purple,
            _heentExpanded,
            1,
          ),
          _buildExaminationPanel(
            'Chest/Lungs',
            Icons.air,
            Colors.green,
            _chestLungsExpanded,
            2,
          ),
          _buildExaminationPanel(
            'Cardiovascular',
            Icons.favorite,
            Colors.red,
            _cardiovascularExpanded,
            3,
          ),
          _buildExaminationPanel(
            'Abdomen',
            Icons.circle,
            Colors.orange,
            _abdomenExpanded,
            4,
          ),
          _buildExaminationPanel(
            'Musculoskeletal',
            Icons.accessibility,
            Colors.blue,
            _musculoskeletalExpanded,
            5,
          ),
          _buildExaminationPanel(
            'Neurological',
            Icons.psychology,
            Colors.pink,
            _neurologicalExpanded,
            6,
          ),
        ],
      ),
    );
  }

  ExpansionPanel _buildGeneralAppearancePanel() {
    return ExpansionPanel(
      headerBuilder: (BuildContext context, bool isExpanded) {
        return ListTile(
          leading: const Icon(Icons.person, color: Colors.blue),
          title: const Text(
            'General Appearance',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        );
      },
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Overall Appearance',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _overallAppearance,
                            isDense: true,
                            onChanged: (String? newValue) {
                              setState(() {
                                _overallAppearance = newValue!;
                              });
                            },
                            items:
                                <String>[
                                  'Normal',
                                  'Abnormal',
                                  'Unable to assess',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
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
                        'Mental Status',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _mentalStatus,
                            isDense: true,
                            onChanged: (String? newValue) {
                              setState(() {
                                _mentalStatus = newValue!;
                              });
                            },
                            items:
                                <String>[
                                  'Alert & Oriented',
                                  'Confused',
                                  'Lethargic',
                                  'Unresponsive',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Notes',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _notesController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Additional observations...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
          ],
        ),
      ),
      isExpanded: _generalAppearanceExpanded,
    );
  }

  ExpansionPanel _buildExaminationPanel(
    String title,
    IconData icon,
    Color iconColor,
    bool isExpanded,
    int index,
  ) {
    return ExpansionPanel(
      headerBuilder: (BuildContext context, bool isExpanded) {
        return ListTile(
          leading: Icon(icon, color: iconColor),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        );
      },
      body: Container(
        padding: const EdgeInsets.all(16),
        child: const Text(
          'Examination details will be added here...',
          style: TextStyle(color: Colors.grey),
        ),
      ),
      isExpanded: isExpanded,
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: const Text(
              'Save & Continue',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }
}
