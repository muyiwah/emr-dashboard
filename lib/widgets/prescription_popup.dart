import 'package:flutter/material.dart';
import 'package:schmgtsystem/models/patient_model.dart';

// class Medication {
//   final String name;
//   final String chemicalComposition;
//   final String description;
//   final List<String> conflictsWith;
//   final String dosage;

//   Medication({
//     required this.name,
//     required this.chemicalComposition,
//     required this.description,
//     required this.conflictsWith,
//     required this.dosage,
//   });
// }

class AddMedicationPopup extends StatefulWidget {
  @override
  _AddMedicationPopupState createState() => _AddMedicationPopupState();
}

class _AddMedicationPopupState extends State<AddMedicationPopup> {
  final TextEditingController _medicationController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController(
    text: '500 mg',
  );
  final TextEditingController _durationController = TextEditingController(
    text: '7 days',
  );
  final TextEditingController _startDateController = TextEditingController(
    text: 'mm/dd/yyyy',
  );

  String _selectedFrequency = 'Once daily';
  bool _showInteraction = false;
  bool _showDrugInfo = false;
  Medication? _selectedMedication;
  final FocusNode _medicationFocusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  bool _isOverlayVisible = false;

  // Sample database of medications
  final List<Medication> _medications = [
    Medication(
      name: 'Amoxicillin',
      chemicalComposition: 'C16H19N3O5S',
      description: 'A penicillin antibiotic that fights bacteria.',
      conflictsWith: ['Warfarin', 'Methotrexate'],
      dosage: '250-500 mg every 8 hours',
    ),
    Medication(
      name: 'Azithromycin',
      chemicalComposition: 'C38H72N2O12',
      description: 'A macrolide antibiotic used to treat bacterial infections.',
      conflictsWith: ['Digoxin', 'Warfarin'],
      dosage: '500 mg once daily',
    ),
    Medication(
      name: 'Cephalexin',
      chemicalComposition: 'C16H17N3O4S',
      description: 'A cephalosporin antibiotic that fights bacteria.',
      conflictsWith: ['Probenecid'],
      dosage: '250-500 mg every 6 hours',
    ),
    Medication(
      name: 'Ibuprofen',
      chemicalComposition: 'C13H18O2',
      description: 'NSAID used for pain, fever, and inflammation.',
      conflictsWith: ['Aspirin', 'Warfarin'],
      dosage: '200-400 mg every 4-6 hours',
    ),
    Medication(
      name: 'Paracetamol',
      chemicalComposition: 'C8H9NO2',
      description: 'Used to treat pain and fever.',
      conflictsWith: ['Alcohol'],
      dosage: '500-1000 mg every 4-6 hours',
    ),
    Medication(
      name: 'Aspirin',
      chemicalComposition: 'C9H8O4',
      description: 'Used for pain relief and blood thinning.',
      conflictsWith: ['Ibuprofen', 'Warfarin'],
      dosage: '75-325 mg daily',
    ),
    Medication(
      name: 'Metformin',
      chemicalComposition: 'C4H11N5',
      description: 'Used to treat type 2 diabetes.',
      conflictsWith: ['Alcohol'],
      dosage: '500-1000 mg twice daily',
    ),
  ];

  List<Medication> _filteredMedications = [];
  void _onSavePressed() {
    if (_selectedMedication != null) {
      final selection = MedicationSelection(
        medication: _selectedMedication!,
        dosage: _dosageController.text,
        frequency: _selectedFrequency,
        duration: _durationController.text,
        startDate: _startDateController.text,
      );
      Navigator.of(context).pop(selection);
    } else {
      // Show error or handle case where no medication is selected
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please select a medication')));
    }
  }

  @override
  void initState() {
    super.initState();
    _medicationController.addListener(_onMedicationChanged);
    _medicationFocusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _medicationController.removeListener(_onMedicationChanged);
    _medicationFocusNode.removeListener(_onFocusChanged);
    _medicationController.dispose();
    _dosageController.dispose();
    _durationController.dispose();
    _startDateController.dispose();
    _medicationFocusNode.dispose();
    _removeAutocompleteOverlay();
    super.dispose();
  }

  void _onFocusChanged() {
    if (_medicationFocusNode.hasFocus) {
      _updateFilteredMedications();
      if (_filteredMedications.isNotEmpty) {
        _showAutocompleteOverlay();
      }
    } else {
      // Delay hiding overlay to allow for tap on suggestions
      Future.delayed(Duration(milliseconds: 150), () {
        _removeAutocompleteOverlay();
      });
    }
  }

  void _onMedicationChanged() {
    _updateFilteredMedications();
    _updateMedicationInfo();

    if (_medicationFocusNode.hasFocus) {
      if (_filteredMedications.isNotEmpty &&
          _medicationController.text.isNotEmpty) {
        _showAutocompleteOverlay();
      } else {
        _removeAutocompleteOverlay();
      }
    }
  }

  void _updateFilteredMedications() {
    final text = _medicationController.text.toLowerCase().trim();

    if (text.isEmpty) {
      _filteredMedications = List.from(_medications);
    } else {
      _filteredMedications =
          _medications.where((med) {
            return med.name.toLowerCase().contains(text) ||
                med.description.toLowerCase().contains(text);
          }).toList();

      // Sort by relevance - exact matches first, then starts with, then contains
      _filteredMedications.sort((a, b) {
        final aName = a.name.toLowerCase();
        final bName = b.name.toLowerCase();

        if (aName == text) return -1;
        if (bName == text) return 1;
        if (aName.startsWith(text) && !bName.startsWith(text)) return -1;
        if (bName.startsWith(text) && !aName.startsWith(text)) return 1;

        return aName.compareTo(bName);
      });
    }
  }

  void _updateMedicationInfo() {
    final text = _medicationController.text.toLowerCase().trim();

    // Find exact match
    final exactMatch = _medications.firstWhere(
      (med) => med.name.toLowerCase() == text,
      orElse:
          () => Medication(
            name: '',
            chemicalComposition: '',
            description: '',
            conflictsWith: [],
            dosage: '',
          ),
    );

    setState(() {
      _selectedMedication = exactMatch.name.isNotEmpty ? exactMatch : null;
      _showDrugInfo = _selectedMedication != null;
      // Only show interaction warning for Amoxicillin
      _showInteraction =
          _selectedMedication?.name.toLowerCase() == 'amoxicillin';
    });
  }

  void _showAutocompleteOverlay() {
    if (_isOverlayVisible) return;

    _removeAutocompleteOverlay();

    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    _overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            width: renderBox.size.width,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0, 60), // Adjust based on your text field height
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  constraints: BoxConstraints(maxHeight: 200, minHeight: 50),
                  child:
                      _filteredMedications.isEmpty
                          ? Padding(
                            padding: EdgeInsets.all(16),
                            child: Text(
                              'No medications found',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          )
                          : ListView.separated(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            shrinkWrap: true,
                            itemCount: _filteredMedications.length,
                            separatorBuilder:
                                (context, index) => Divider(height: 1),
                            itemBuilder: (context, index) {
                              final med = _filteredMedications[index];
                              return ListTile(
                                dense: true,
                                title: Text(
                                  med.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      med.dosage,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      med.description,
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 12,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                trailing:
                                    med.name.toLowerCase() == 'amoxicillin'
                                        ? Icon(
                                          Icons.warning,
                                          color: Colors.red,
                                          size: 20,
                                        )
                                        : med.conflictsWith!.isNotEmpty
                                        ? Icon(
                                          Icons.info_outline,
                                          color: Colors.amber,
                                          size: 20,
                                        )
                                        : Icon(
                                          Icons.check_circle_outline,
                                          color: Colors.green,
                                          size: 20,
                                        ),
                                onTap: () => _selectMedication(med),
                              );
                            },
                          ),
                ),
              ),
            ),
          ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _isOverlayVisible = true;
  }

  void _removeAutocompleteOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
      _isOverlayVisible = false;
    }
  }

  void _selectMedication(Medication medication) {
    _medicationController.text = medication.name;
    _dosageController.text = medication.dosage.split(',')[0].trim();
    _removeAutocompleteOverlay();
    _medicationFocusNode.unfocus();
    _updateMedicationInfo();
  }

  void _clearMedicationField() {
    _medicationController.clear();
    _dosageController.text = '500 mg';
    setState(() {
      _selectedMedication = null;
      _showDrugInfo = false;
      _showInteraction = false;
    });
  }

  Widget _buildDrugInformation() {
    if (_selectedMedication == null) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 24),
        Text(
          'Drug Information',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[50]!, Colors.indigo[50]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header with medication name
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.medical_services,
                          color: Colors.white,
                          size: 24,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _selectedMedication!.name,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _onSavePressed();
                          },

                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 45, 3, 173),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'Add MEDICATION',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Content area
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Chemical composition section
                    _buildInfoCard(
                      icon: Icons.science,
                      title: 'Chemical Composition',
                      content: _selectedMedication!.chemicalComposition.toString(),
                      color: Colors.purple,
                    ),
                    SizedBox(height: 16),

                    // Description section
                    _buildInfoCard(
                      icon: Icons.description,
                      title: 'Description',
                      content: _selectedMedication!.description,
                      color: Colors.teal,
                    ),
                    SizedBox(height: 16),

                    // Dosage section
                    _buildInfoCard(
                      icon: Icons.medication,
                      title: 'Recommended Dosage',
                      content: _selectedMedication!.dosage,
                      color: Colors.orange,
                    ),
                    SizedBox(height: 16),

                    // Safety information
                    _buildSafetyInfo(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String content,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyInfo() {
    final hasConflicts = _selectedMedication!.conflictsWith!.isNotEmpty;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              hasConflicts
                  ? Colors.amber.withOpacity(0.3)
                  : Colors.green.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color:
                      hasConflicts
                          ? Colors.amber.withOpacity(0.1)
                          : Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  hasConflicts ? Icons.warning_amber : Icons.verified_user,
                  color: hasConflicts ? Colors.amber[700] : Colors.green[700],
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Safety Information',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          if (hasConflicts) ...[
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Known Interactions',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.amber[800],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'May interact with: ${_selectedMedication!.conflictsWith!.join(', ')}',
                    style: TextStyle(fontSize: 12, color: Colors.amber[800]),
                  ),
                ],
              ),
            ),
          ] else ...[
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green[700], size: 16),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'No major drug interactions known',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green[800],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$label: ',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(text: value, style: TextStyle(color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildInteractionWarning() {
    if (!_showInteraction || _selectedMedication == null)
      return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 24),
        Text(
          'Drug Interaction Check',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 12),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.red[50],
            border: Border(left: BorderSide(color: Colors.red, width: 4)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.warning, color: Colors.red, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Drug Interaction Detected',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              _buildInfoRow(
                'Conflicting with',
                _selectedMedication!.conflictsWith!.join(', '),
              ),
              SizedBox(height: 8),
              _buildInfoRow('Severity', 'High Risk'),
              SizedBox(height: 8),
              _buildInfoRow(
                'Effect',
                'Increased risk of bleeding when combined with anticoagulants.',
              ),
            ],
          ),
        ),
        SizedBox(height: 24),
        _buildAlternativeMedications(),
      ],
    );
  }

  Widget _buildAlternativeMedications() {
    final alternatives =
        _medications
            .where(
              (med) =>
                  med.name != _selectedMedication?.name &&
                  med.name.toLowerCase() !=
                      'amoxicillin', // Exclude amoxicillin from alternatives
            )
            .take(2)
            .toList();

    if (alternatives.isEmpty) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recommended Alternatives',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 12),
        Row(
          children:
              alternatives
                  .map(
                    (med) => Expanded(
                      child: Container(
                        margin: EdgeInsets.only(
                          right: alternatives.indexOf(med) == 0 ? 16 : 0,
                        ),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue[200]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    med.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => _selectMedication(med),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF6366F1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 14,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          'Add',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(
                              med.dosage.split(',')[0].trim(),
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 16,
                                ),
                                SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    'Safer alternative',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.85,
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFF6366F1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add Medication',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Patient: Sarah Johnson • ID: #12847',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(Icons.close, color: Colors.white, size: 24),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Medication Name
                    Text(
                      'Medication Name',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    CompositedTransformTarget(
                      link: _layerLink,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextField(
                          controller: _medicationController,
                          focusNode: _medicationFocusNode,
                          decoration: InputDecoration(
                            hintText: 'Search by generic or brand name...',
                            hintStyle: TextStyle(color: Colors.grey[500]),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            suffixIcon:
                                _medicationController.text.isNotEmpty
                                    ? IconButton(
                                      icon: Icon(
                                        Icons.clear,
                                        color: Colors.grey[500],
                                      ),
                                      onPressed: _clearMedicationField,
                                    )
                                    : Icon(
                                      Icons.search,
                                      color: Colors.grey[500],
                                    ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 24),

                    // Form Fields Row
                    Row(
                      children: [
                        // Dosage
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Dosage',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: TextField(
                                  controller: _dosageController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(width: 16),

                        // Frequency
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Frequency',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: DropdownButtonFormField<String>(
                                  value: _selectedFrequency,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                  ),
                                  items:
                                      [
                                        'Once daily',
                                        'Twice daily',
                                        'Three times daily',
                                        'Four times daily',
                                      ].map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedFrequency = newValue!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 16),

                    // Duration and Start Date Row
                    Row(
                      children: [
                        // Duration
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Duration',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: TextField(
                                  controller: _durationController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(width: 16),

                        // Start Date
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Start Date',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: TextField(
                                  controller: _startDateController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    suffixIcon: Icon(
                                      Icons.calendar_today,
                                      color: Colors.grey[500],
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Show either drug info or interaction warning
                    if (_showInteraction)
                      _buildInteractionWarning()
                    else if (_showDrugInfo)
                      _buildDrugInformation(),

                    SizedBox(height: 24),

                    // Prescriber Description
                    Text(
                      'Prescriber Description / Risk Review',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
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
}

class MedicationSelection {
  Medication medication;
  String dosage;
  String frequency;
  String duration;
  String startDate;
  MedicationSelection({
    required this.medication,
    required this.dosage,
    required this.frequency,
    required this.duration,
    required this.startDate,
  });
}
