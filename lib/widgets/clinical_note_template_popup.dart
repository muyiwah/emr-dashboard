import 'package:flutter/material.dart';
import 'package:typewritertext/typewritertext.dart';

class NoteTemplatePopup extends StatefulWidget {
  @override
  _NoteTemplatePopupState createState() => _NoteTemplatePopupState();
}

class _NoteTemplatePopupState extends State<NoteTemplatePopup> {
  String selectedCategory = 'All';
  List<String> selectedFormats = [];

  // Template data model
  final List<Template> templates = [
    Template(
      title: 'Follow-Up Visit',
      description:
          'Pre-filled SOAP format with prior visit summary reference and treatment progress tracking.',
      type: 'SOAP',
      category: 'Outpatient',
      color: Colors.blue.shade600,
      icon: Icons.person,
      isAI: false,
      content: '''
**Subjective:**
Patient returns for follow-up of [condition]. Reports:
- Improvement: [details]
- Ongoing symptoms: [details]
- New concerns: [details]

**Objective:**
Vitals: [BP] [HR] [RR] [Temp] [SpO2]
Exam findings: [details]

**Assessment:**
[Condition] - [status]
Differential: [considerations]

**Plan:**
1. Continue [current treatment]
2. Add [new treatment]
3. Follow-up in [timeframe]''',
    ),
    Template(
      title: 'Surgical Note',
      description:
          'Custom layout: Procedure details, findings, complications, and post-operative plan.',
      type: 'Custom',
      category: 'Surgical',
      color: Colors.red.shade600,
      icon: Icons.medical_services,
      isAI: false,
      content: '''
**Procedure:** [Name]
**Surgeon:** [Name]
**Assistants:** [Names]
**Anesthesia:** [Type]
**Indications:** [Details]
**Findings:** [Details]
**Complications:** [None/Details]
**EBL:** [Amount]
**Specimens:** [Details]
**Post-op Plan:**
1. [Instructions]
2. [Medications]
3. Follow-up in [timeframe]''',
    ),
    Template(
      title: 'Counseling Session',
      description:
          'Free-form notes with optional PHQ-9 score input and mental health assessment tools.',
      type: 'Custom',
      category: 'Mental Health',
      color: Colors.teal.shade600,
      icon: Icons.psychology,
      isAI: true,
      content: '''
**Session Type:** [Individual/Couples/Family]
**Duration:** [Minutes]
**PHQ-9 Score:** [Score] ([Interpretation])
**GAD-7 Score:** [Score] ([Interpretation])

**Session Focus:**
[Details of discussion topics]

**Interventions Used:**
1. [CBT/DBT/Other]
2. [Techniques]

**Progress:**
[Assessment of progress toward goals]

**Plan:**
1. [Homework assigned]
2. Next session [date/time]''',
    ),
    Template(
      title: 'Emergency Visit',
      description:
          'Quick-entry triage assessment with disposition plan and emergency protocols.',
      type: 'Custom',
      category: 'Emergency',
      color: Colors.red.shade600,
      icon: Icons.local_hospital,
      isAI: true,
      content: '''
**Chief Complaint:** [CC]
**Triage Level:** [1-5]
**Vitals:** [BP] [HR] [RR] [Temp] [SpO2] [Pain]
**History:** [HPI]
**Allergies:** [List]
**Meds:** [Current medications]

**Assessment:**
[Primary diagnosis]
[Secondary diagnoses]

**Interventions:**
1. [Procedures performed]
2. [Medications administered]

**Disposition:**
[Admit/Discharge/Transfer]
[Follow-up instructions]''',
    ),
    Template(
      title: 'New Patient Intake',
      description:
          'Extended history collection with medications and allergies checklist.',
      type: 'SOAP',
      category: 'Outpatient',
      color: Colors.green.shade600,
      icon: Icons.person_add,
      isAI: false,
      content: '''
**Demographics:**
Name: [Name]
DOB: [Date]
Gender: [Gender]

**History:**
PMH: [Conditions]
PSH: [Surgeries]
FH: [Family history]
SH: [Social history]

**Allergies:**
[List with reactions]

**Medications:**
[List with dosages]

**Review of Systems:**
[Positive and pertinent negatives]

**Assessment/Plan:**
[Initial impressions and next steps]''',
    ),
    Template(
      title: 'Discharge Summary',
      description:
          'Comprehensive discharge documentation with follow-up instructions and care plan.',
      type: 'Custom',
      category: 'Inpatient',
      color: Colors.blue.shade600,
      icon: Icons.exit_to_app,
      isAI: true,
      content: '''
**Admission Date:** [Date]
**Discharge Date:** [Date]
**Attending:** [Name]
**Service:** [Service]

**Admitting Diagnosis:**
1. [Diagnosis]
2. [Diagnosis]

**Hospital Course:**
[Summary of treatment]

**Discharge Diagnoses:**
1. [Diagnosis]
2. [Diagnosis]

**Discharge Medications:**
[List with instructions]

**Follow-up:**
1. [Provider] on [date]
2. [Tests/labs needed]

**Instructions:**
[Activity, diet, warning signs, etc.]''',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Filter templates based on selections
    final filteredTemplates =
        templates.where((template) {
          final categoryMatch =
              selectedCategory == 'All' ||
              template.category == selectedCategory;
          final formatMatch =
              selectedFormats.isEmpty ||
              selectedFormats.contains(template.type);
          return categoryMatch && formatMatch;
        }).toList();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        width: 1000,
        height: 700,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: .1, color: Colors.grey),
              ),
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.pink.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.psychology,
                          color: Colors.pink.shade600,
                          size: 16,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Choose a Note Template',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(Icons.close, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Select a note type to pre-fill the note structure.',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),

            // Main content
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left sidebar
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade500,
                        width: .2,
                      ),
                      color: const Color.fromARGB(255, 253, 250, 250),
                    ),
                    width: 250,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Search bar
                        Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 250, 248, 248),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              hintText: 'Search templates...',
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.grey.shade500,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 24),

                        // Categories
                        Text(
                          'Categories',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 12),
                        ...[
                          'All',
                          'Inpatient',
                          'Outpatient',
                          'Surgical',
                          'Mental Health',
                          'Pediatric',
                          'Emergency',
                        ].map((category) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 4),
                            child: Row(
                              children: [
                                Radio<String>(
                                  value: category,
                                  groupValue: selectedCategory,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedCategory = value!;
                                    });
                                  },
                                  activeColor: Colors.blue.shade600,
                                ),
                                Text(
                                  category,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),

                        SizedBox(height: 14),

                        // Format
                        Text(
                          'Format',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 12),
                        ...['SOAP', 'Custom', 'AI-Assisted'].map((format) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: selectedFormats.contains(format),
                                  onChanged: (value) {
                                    setState(() {
                                      if (value!) {
                                        selectedFormats.add(format);
                                      } else {
                                        selectedFormats.remove(format);
                                      }
                                    });
                                  },
                                  activeColor: Colors.blue.shade600,
                                ),
                                Text(
                                  format,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),

                  SizedBox(width: 32),

                  // Template grid
                  Expanded(
                    child:
                        filteredTemplates.isEmpty
                            ? Center(
                              child: Text(
                                'No templates match your filters',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            )
                            : GridView.count(
                              crossAxisCount: 3,
                              childAspectRatio: 0.9,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              padding: EdgeInsets.all(16),
                              children:
                                  filteredTemplates
                                      .map(
                                        (template) =>
                                            _buildTemplateCard(template),
                                      )
                                      .toList(),
                            ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTemplateCard(Template template) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon and type
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: template.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(template.icon, color: template.color, size: 18),
                ),
                SizedBox(width: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color:
                        template.type == 'SOAP'
                            ? Colors.blue.shade50
                            : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    template.type,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color:
                          template.type == 'SOAP'
                              ? Colors.blue.shade600
                              : Colors.grey.shade600,
                    ),
                  ),
                ),
                if (template.isAI) ...[
                  SizedBox(width: 4),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade50,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'AI',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.purple.shade600,
                      ),
                    ),
                  ),
                ],
                Spacer(),
                Icon(
                  template.title == 'Emergency Visit'
                      ? Icons.star
                      : Icons.star_border,
                  color:
                      template.title == 'Emergency Visit'
                          ? Colors.amber
                          : Colors.grey.shade400,
                  size: 20,
                ),
              ],
            ),
            SizedBox(height: 12),

            // Title
            Text(
              template.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),

            // Description
            Expanded(
              child: Text(
                template.description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
              ),
            ),

            SizedBox(height: 20),

            // Use Template button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close template selection
                  _showTemplateEditor(context, template); // Open editor
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 17, 44, 221),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Use Template',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTemplateEditor(BuildContext context, Template template) {
    showDialog(
      context: context,
      builder: (context) => TemplateEditorDialog(template: template),
    );
  }
}

// Template data model
class Template {
  final String title;
  final String description;
  final String type;
  final String category;
  final Color color;
  final IconData icon;
  final bool isAI;
  final String content;

  Template({
    required this.title,
    required this.description,
    required this.type,
    required this.category,
    required this.color,
    required this.icon,
    required this.isAI,
    required this.content,
  });
}

// Template Editor Dialog
class TemplateEditorDialog extends StatefulWidget {
  final Template template;

  const TemplateEditorDialog({required this.template});

  @override
  _TemplateEditorDialogState createState() => _TemplateEditorDialogState();
}

class _TemplateEditorDialogState extends State<TemplateEditorDialog> {
  // late TextEditingController _editorController;
late TextEditingController _editorController;
  bool _animationComplete = false;
  final Duration _typewriterDuration = const Duration(milliseconds: 30);

  @override
  void initState() {
    super.initState();
    _editorController = TextEditingController();
    // Start with empty text and fill it gradually
    _editorController.text = '';
    _animateText();
  }

  void _animateText() async {
    final fullText = widget.template.content;
    for (int i = 0; i <= fullText.length; i++) {
      await Future.delayed(_typewriterDuration);
      if (!mounted) return;
      setState(() {
        _editorController.text = fullText.substring(0, i);
      });
    }
    setState(() {
      _animationComplete = true;
    });
  }

  @override
  void dispose() {
    _editorController.dispose();
    super.dispose();
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _editorController = TextEditingController(text: widget.template.content);
  // }

  // @override
  // void dispose() {
  //   _editorController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 900,
        height: 700,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade200, width: 1),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: widget.template.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      widget.template.icon,
                      color: widget.template.color,
                      size: 18,
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    widget.template.title,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Editor toolbar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade200, width: 1),
                ),
              ),
              child: Row(
                children: [
                  // Formatting buttons
                  _buildFormatButton(Icons.format_bold, 'Bold'),
                  _buildFormatButton(Icons.format_italic, 'Italic'),
                  _buildFormatButton(Icons.format_underline, 'Underline'),
                  _buildFormatButton(Icons.format_list_bulleted, 'Bullet List'),
                  _buildFormatButton(
                    Icons.format_list_numbered,
                    'Numbered List',
                  ),
                  _buildFormatButton(Icons.link, 'Insert Link'),
                  _buildFormatButton(Icons.image, 'Insert Image'),

                  Spacer(),

                  // AI suggestions button
                  if (widget.template.isAI) ...[
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.auto_awesome, size: 18),
                      label: Text('AI Suggestions'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple.shade50,
                        foregroundColor: Colors.purple.shade600,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                  ],

                  // Save button
                  ElevatedButton(
                    onPressed: () {
                      // Save the note
                      Navigator.of(context).pop(_editorController.text);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Save Note'),
                  ),
                ],
              ),
            ),

            // Main editor
            // Expanded(
            //   child: Padding(
            //     padding: EdgeInsets.all(16),
            //     child: TextField(
            //       controller: _editorController,
            //       maxLines: null,
            //       expands: true,
            //       decoration: InputDecoration(
            //         border: InputBorder.none,
            //         hintText: 'Start typing your note...',
            //       ),
            //       style: TextStyle(fontSize: 16),
            //     ),
            //   ),
            // ),

              // Typewriter effect for each line
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children:
            //        widget.template.content.map((line) {
            //         return Padding(
            //           padding: const EdgeInsets.only(bottom: 8.0),
            //           child: TypeWriterText(
            //             text: Text(
            //               widget.template.content,
            //               style: TextStyle(
            //                 fontSize: 16,
            //                 height: 1.5,
            //                 color:
            //                     line.startsWith('**')
            //                         ? Colors.red.shade700
            //                         : Colors.black87,
            //               ),
            //             ),
            //             duration: const Duration(milliseconds: 30),
            //             // curve: Curves.easeOut,
            //           ),
            //         );
            //       }).toList(),
            // ),
        
        // Expanded(
        //   child: Padding(
        //                 padding: const EdgeInsets.only(bottom: 8.0,left: 20),
        //                 child: TypeWriterText(
        //                   text: Text(
        //                     widget.template.content,
        //                     style: TextStyle(
        //                       fontSize: 16,
        //                       height: 1.5,
        //                       color: Colors.black87,
        //                             // widget.template.content.startsWith('**')
        //                             //   ? Colors.red.shade700
        //                             //   : Colors.black87,
        //                     ),
        //                   ),
        //                   duration: const Duration(milliseconds: 30),
        //                   // curve: Curves.easeOut,
        //                 ),
        //               ),
        // ) 
        
        // Main editor
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _editorController,
                  maxLines: null,
                  expands: true,
                  readOnly:
                      !_animationComplete, // Only allow editing after animation
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText:
                        _animationComplete
                            ? 'Edit your note...'
                            : 'Generating template...',
                  ),
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ), 
         ],
        ),
      ),
    );
  }

  Widget _buildFormatButton(IconData icon, String tooltip) {
    return IconButton(
      icon: Icon(icon, size: 20),
      onPressed: () {
        // Handle formatting
      },
      tooltip: tooltip,
      splashRadius: 20,
    );
  }
}
