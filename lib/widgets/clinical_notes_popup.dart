import 'package:flutter/material.dart';

class ClinicalNotePopup extends StatefulWidget {
  @override
  _ClinicalNotePopupState createState() => _ClinicalNotePopupState();
}

class _ClinicalNotePopupState extends State<ClinicalNotePopup> {
  bool isSoapFormat = true;

  // SOAP controllers
  final TextEditingController subjectiveController = TextEditingController();
  final TextEditingController objectiveController = TextEditingController();
  final TextEditingController assessmentController = TextEditingController();
  final TextEditingController planController = TextEditingController();

  // Free-text controller
  final TextEditingController freeTextController = TextEditingController();

  // Common medical templates for quick insertion
  final List<String> commonTemplates = [
    'Patient presents with...',
    'On examination...',
    'Review of systems reveals...',
    'Vital signs stable',
    'Plan: Continue current medications',
    'Follow up in 2 weeks',
    'Patient counseled on...',
    'No acute distress',
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(20),
      child: Container(
        width: 950,
        height: 740,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [_buildHeader(), _buildContent(), _buildFooter()],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Color(0xFF6366F1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Column(
        children: [
          // Title bar
          Row(
            children: [
              Icon(Icons.note_add, color: Colors.white, size: 24),
              SizedBox(width: 12),
              Text(
                'Add Clinical Note',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(Icons.close, color: Colors.white),
                splashRadius: 20,
              ),
            ],
          ),
          SizedBox(height: 24),
          // Patient info
          _buildPatientInfo(),
        ],
      ),
    );
  }

  Widget _buildPatientInfo() {
    return Row(
      children: [
        _buildInfoItem('Patient:', 'Sarah Johnson'),
        SizedBox(width: 40),
        _buildInfoItem('ID:', 'EMR-2024-0892'),
        SizedBox(width: 40),
        _buildInfoItem('Age/Gender:', '34F'),
        SizedBox(width: 40),
        _buildInfoItem('Visit Type:', 'Follow-up'),
      ],
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            _buildFormatToggle(),
            SizedBox(height: 24),
            Expanded(
              child:
                  isSoapFormat ? _buildSoapContent() : _buildFreeTextContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormatToggle() {
    return Row(
      children: [
        _buildFormatButton(
          'SOAP Note Format',
          Icons.list_alt,
          isSoapFormat,
          () => setState(() => isSoapFormat = true),
        ),
        SizedBox(width: 1),
        _buildFormatButton(
          'Free-Text Note Format',
          Icons.edit,
          !isSoapFormat,
          () => setState(() => isSoapFormat = false),
        ),
      ],
    );
  }

  Widget _buildFormatButton(
    String text,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: isSelected ? Color(0xFF6366F1) : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey.shade600,
                size: 18,
              ),
              SizedBox(width: 8),
              Text(
                text,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey.shade600,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSoapContent() {
    return Row(
      children: [
        // Left column
        Expanded(
          child: Column(
            children: [
              _buildSoapField(
                'Subjective (S)',
                'Patient-reported symptoms, complaints, history...',
                subjectiveController,
                Icons.person,
              ),
              SizedBox(height: 16),
              _buildSoapField(
                'Assessment (A)',
                'Clinical impressions, diagnoses, differential...',
                assessmentController,
                Icons.assessment,
              ),
            ],
          ),
        ),
        SizedBox(width: 16),
        // Right column
        Expanded(
          child: Column(
            children: [
              _buildSoapField(
                'Objective (O)',
                'Vital signs, physical exam findings, lab results...',
                objectiveController,
                Icons.visibility,
              ),
              SizedBox(height: 16),
              _buildSoapField(
                'Plan (P)',
                'Treatment plan, prescriptions, follow-up...',
                planController,
                Icons.calendar_today,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFreeTextContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Quick templates section
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.flash_on, color: Colors.blue.shade600, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Quick Templates',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    commonTemplates.map((template) {
                      return GestureDetector(
                        onTap: () => _insertTemplate(template),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.blue.shade300),
                          ),
                          child: Text(
                            template,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ],
          ),
        ),

        SizedBox(height: 16),

        // Main text area
        Row(
          children: [
            Icon(Icons.edit_note, color: Color(0xFF6366F1), size: 18),
            SizedBox(width: 8),
            Text(
              'Clinical Note',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
          ],
        ),

        SizedBox(height: 8),

        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              children: [
                // Formatting toolbar
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  child: Row(
                    children: [
                      _buildToolbarButton(Icons.format_bold, 'Bold'),
                      _buildToolbarButton(Icons.format_italic, 'Italic'),
                      _buildToolbarButton(Icons.format_underlined, 'Underline'),
                      SizedBox(width: 12),
                      _buildToolbarButton(
                        Icons.format_list_bulleted,
                        'Bullet List',
                      ),
                      _buildToolbarButton(
                        Icons.format_list_numbered,
                        'Numbered List',
                      ),
                      Spacer(),
                      Text(
                        'Tip: Use templates above for quick insertions',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),

                // Text field
                Expanded(
                  child: TextField(
                    controller: freeTextController,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.grey.shade800,
                    ),
                    decoration: InputDecoration(
                      hintText:
                          'Write your clinical note here...\n\nYou can structure it however you prefer - chronologically, by system, or in any format that works best for your documentation needs.',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 14,
                        height: 1.5,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToolbarButton(IconData icon, String tooltip) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: () {
          // Add formatting logic here
        },
        child: Container(
          padding: EdgeInsets.all(6),
          margin: EdgeInsets.only(right: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Icon(icon, size: 16, color: Colors.grey.shade600),
        ),
      ),
    );
  }

  void _insertTemplate(String template) {
    final currentText = freeTextController.text;
    final cursorPosition = freeTextController.selection.start;

    String newText;
    if (cursorPosition == -1) {
      // No cursor position, append to end
      newText = currentText.isEmpty ? template : '$currentText\n$template';
    } else {
      // Insert at cursor position
      newText =
          currentText.substring(0, cursorPosition) +
          template +
          currentText.substring(cursorPosition);
    }

    freeTextController.text = newText;
    freeTextController.selection = TextSelection.fromPosition(
      TextPosition(offset: cursorPosition + template.length),
    );
  }

  Widget _buildSoapField(
    String title,
    String hint,
    TextEditingController controller,
    IconData icon,
  ) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Color(0xFF6366F1), size: 18),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Expanded(
            child: TextField(
              controller: controller,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              style: TextStyle(fontSize: 14, height: 1.5),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Color(0xFF6366F1)),
                ),
                contentPadding: EdgeInsets.all(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          _buildActionButton(
            'Save Note',
            Color(0xFF6366F1),
            Colors.white,
            Icons.check,
            () => _saveNote(),
          ),
          SizedBox(width: 12),
          _buildActionButton(
            'Save & Add Another',
            Color(0xFF06B6D4),
            Colors.white,
            Icons.add,
            () => _saveAndAddAnother(),
          ),
          Spacer(),
          _buildActionButton(
            'Print',
            Colors.grey.shade100,
            Colors.grey.shade700,
            Icons.print,
            () => _printNote(),
          ),
          SizedBox(width: 12),
          _buildActionButton(
            'Cancel',
            Colors.grey.shade100,
            Colors.grey.shade700,
            Icons.close,
            () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String text,
    Color backgroundColor,
    Color textColor,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border:
              backgroundColor == Colors.grey.shade100
                  ? Border.all(color: Colors.grey.shade300)
                  : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: textColor, size: 16),
            SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveNote() {
    // Implement save logic
    print('Saving note...');
    Navigator.of(context).pop();
  }

  void _saveAndAddAnother() {
    // Implement save and add another logic
    print('Saving and adding another...');
    Navigator.of(context).pop();
  }

  void _printNote() {
    // Implement print logic
    print('Printing note...');
  }

  @override
  void dispose() {
    subjectiveController.dispose();
    objectiveController.dispose();
    assessmentController.dispose();
    planController.dispose();
    freeTextController.dispose();
    super.dispose();
  }
}


