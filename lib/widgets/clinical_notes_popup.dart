import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schmgtsystem/providers/patient_proviider.dart';
import 'package:schmgtsystem/services/api_service.dart';

class ClinicalNotePopup extends StatefulWidget {
  final VoidCallback? onNoteCreated;

  ClinicalNotePopup({this.onNoteCreated});

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
    final patientProvider = Provider.of<PatientProvider>(context, listen: false);
    final patient = patientProvider.currentPatient;

    // Get patient name
    final patientName = patient?.name ?? 'N/A';
    
    // Get patient ID (MRN)
    final patientId = patient?.mrn ?? 'N/A';
    
    // Get age and gender
    String ageGender = 'N/A';
    if (patient != null) {
      final age = patient.age;
      final gender = patient.gender;
      if (age > 0 && gender.isNotEmpty) {
        ageGender = '$age$gender';
      } else if (age > 0) {
        ageGender = '$age';
      } else if (gender.isNotEmpty) {
        ageGender = gender;
      }
    }
    
    // Visit type - could be dynamic in the future, for now using a default
    final visitType = 'Follow-up'; // This could be made dynamic based on encounter type

    return Row(
      children: [
        _buildInfoItem('Patient:', patientName),
        SizedBox(width: 40),
        _buildInfoItem('ID:', patientId),
        SizedBox(width: 40),
        _buildInfoItem('Age/Gender:', ageGender),
        SizedBox(width: 40),
        _buildInfoItem('Visit Type:', visitType),
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

  Future<void> _saveNote() async {
    // Get patient from provider
    final patientProvider = Provider.of<PatientProvider>(
      context,
      listen: false,
    );
    final patient = patientProvider.currentPatient;

    if (patient == null || patient.id == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No patient selected'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    // Validate that we have content
    final hasSoapContent = subjectiveController.text.trim().isNotEmpty ||
        objectiveController.text.trim().isNotEmpty ||
        assessmentController.text.trim().isNotEmpty ||
        planController.text.trim().isNotEmpty;
    final hasFreeTextContent = freeTextController.text.trim().isNotEmpty;

    if (!hasSoapContent && !hasFreeTextContent) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter note content'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    // Build request body
    final Map<String, dynamic> noteData = {
      'noteType': 'Progress Note', // Default, can be made configurable
      'status': 'draft',
    };

    if (isSoapFormat && hasSoapContent) {
      // SOAP format
      if (subjectiveController.text.trim().isNotEmpty) {
        noteData['subjective'] = subjectiveController.text.trim();
      }
      if (objectiveController.text.trim().isNotEmpty) {
        noteData['objective'] = objectiveController.text.trim();
      }
      if (assessmentController.text.trim().isNotEmpty) {
        noteData['assessment'] = assessmentController.text.trim();
      }
      if (planController.text.trim().isNotEmpty) {
        noteData['plan'] = planController.text.trim();
      }
      // For SOAP, generate content from SOAP fields since backend requires content
      final List<String> contentParts = [];
      if (subjectiveController.text.trim().isNotEmpty) {
        contentParts.add('Subjective: ${subjectiveController.text.trim()}');
      }
      if (objectiveController.text.trim().isNotEmpty) {
        contentParts.add('Objective: ${objectiveController.text.trim()}');
      }
      if (assessmentController.text.trim().isNotEmpty) {
        contentParts.add('Assessment: ${assessmentController.text.trim()}');
      }
      if (planController.text.trim().isNotEmpty) {
        contentParts.add('Plan: ${planController.text.trim()}');
      }
      noteData['content'] = contentParts.join('\n\n');
    } else if (!isSoapFormat && hasFreeTextContent) {
      // Free-text format
      noteData['content'] = freeTextController.text.trim();
    }

    print('=== CLINICAL NOTE CREATION REQUEST ===');
    print('Patient ID: ${patient.id}');
    print('Request Body: ${noteData.toString()}');
    print('======================================');

    try {
      final patientId = patient.id;
      if (patientId == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Patient ID is missing'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      final response = await ApiService.createClinicalNote(
        patientId,
        noteData,
      );

      print('=== CLINICAL NOTE CREATION RESPONSE ===');
      print('Success: ${response.success}');
      print('Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');
      print('Error: ${response.error}');
      print('Full Response: ${response.toString()}');
      print('=======================================');

      if (mounted) {
        if (response.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Clinical note saved successfully'),
              backgroundColor: Colors.green,
            ),
          );
          // Notify parent that note was created
          print('=== CALLING onNoteCreated CALLBACK ===');
          if (widget.onNoteCreated != null) {
            widget.onNoteCreated!();
            print('Callback executed successfully');
          } else {
            print('Callback is null - not set');
          }
          Navigator.of(context).pop(true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Failed to save note: ${response.error ?? 'Unknown error'}',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print('=== CLINICAL NOTE CREATION EXCEPTION ===');
      print('Error: $e');
      print('========================================');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving note: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _saveAndAddAnother() async {
    // Get patient from provider
    final patientProvider = Provider.of<PatientProvider>(
      context,
      listen: false,
    );
    final patient = patientProvider.currentPatient;

    if (patient == null || patient.id == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No patient selected'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    // Validate that we have content
    final hasSoapContent = subjectiveController.text.trim().isNotEmpty ||
        objectiveController.text.trim().isNotEmpty ||
        assessmentController.text.trim().isNotEmpty ||
        planController.text.trim().isNotEmpty;
    final hasFreeTextContent = freeTextController.text.trim().isNotEmpty;

    if (!hasSoapContent && !hasFreeTextContent) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter note content'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    // Build request body
    final Map<String, dynamic> noteData = {
      'noteType': 'Progress Note',
      'status': 'draft',
    };

    if (isSoapFormat && hasSoapContent) {
      if (subjectiveController.text.trim().isNotEmpty) {
        noteData['subjective'] = subjectiveController.text.trim();
      }
      if (objectiveController.text.trim().isNotEmpty) {
        noteData['objective'] = objectiveController.text.trim();
      }
      if (assessmentController.text.trim().isNotEmpty) {
        noteData['assessment'] = assessmentController.text.trim();
      }
      if (planController.text.trim().isNotEmpty) {
        noteData['plan'] = planController.text.trim();
      }
      noteData['content'] = '';
    } else if (!isSoapFormat && hasFreeTextContent) {
      noteData['content'] = freeTextController.text.trim();
    }

    print('=== CLINICAL NOTE CREATION REQUEST (Save & Add Another) ===');
    print('Patient ID: ${patient.id}');
    print('Request Body: ${noteData.toString()}');
    print('============================================================');

    try {
      final patientId = patient.id;
      if (patientId == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Patient ID is missing'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      final response = await ApiService.createClinicalNote(
        patientId,
        noteData,
      );

      print('=== CLINICAL NOTE CREATION RESPONSE (Save & Add Another) ===');
      print('Success: ${response.success}');
      print('Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');
      print('Error: ${response.error}');
      print('Full Response: ${response.toString()}');
      print('=============================================================');

      if (mounted) {
        if (response.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Clinical note saved successfully'),
              backgroundColor: Colors.green,
            ),
          );
          // Notify parent that note was created
          print('=== CALLING onNoteCreated CALLBACK (Save & Add Another) ===');
          if (widget.onNoteCreated != null) {
            widget.onNoteCreated!();
            print('Callback executed successfully');
          } else {
            print('Callback is null - not set');
          }
          // Clear form for next note
          subjectiveController.clear();
          objectiveController.clear();
          assessmentController.clear();
          planController.clear();
          freeTextController.clear();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Failed to save note: ${response.error ?? 'Unknown error'}',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print('=== CLINICAL NOTE CREATION EXCEPTION (Save & Add Another) ===');
      print('Error: $e');
      print('=============================================================');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving note: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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


