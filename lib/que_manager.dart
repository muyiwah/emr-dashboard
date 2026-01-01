import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schmgtsystem/models/patient_model.dart';
import 'package:schmgtsystem/providers/patient_proviider.dart';


class QueueManagementScreen extends StatefulWidget {
  const QueueManagementScreen({super.key});

  @override
  State<QueueManagementScreen> createState() => _QueueManagementScreenState();
}

class _QueueManagementScreenState extends State<QueueManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedDepartment = 'All Departments';
  late List<String> _departments;

  @override
  void initState() {
    super.initState();
    _departments = [
      'All Departments',
      'General Medicine',
      'Pediatrics',
      'ENT',
      'Cardiology',
      'Orthopedics',
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Consumer<PatientProvider>(
        builder: (context, provider, child) {
          final patients = _filterPatients(provider.patients);
          final waitingPatients =
              patients.where((p) => p.status == 'waiting').toList();
          final consultingPatients =
              patients.where((p) => p.status == 'In Consultation').toList();
          final completedPatients =
              patients.where((p) => p.status == 'Completed').toList();

          return Column(
            children: [
              _buildSearchAndFilterBar(),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPatientColumn(
                      context,
                      'Waiting (${waitingPatients.length})',
                      waitingPatients,
                      Colors.white,
                      'waiting',
                    ),
                    const SizedBox(width: 12),
                    _buildPatientColumn(
                      context,
                      'Consulting (${consultingPatients.length})',
                      consultingPatients,
                      Colors.white,
                      'In Consultation',
                    ),
                    const SizedBox(width: 12),
                    _buildPatientColumn(
                      context,
                      'Completed (${completedPatients.length})',
                      completedPatients,
                      Colors.white,
                      'Completed',
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddPatientDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Patient Queue Management'),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed:
              () =>
                  Provider.of<PatientProvider>(
                    context,
                    listen: false,
                  ).refreshPatients(),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilterBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search patients...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  setState(() => _searchQuery = '');
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: (value) => setState(() => _searchQuery = value),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  _departments.map((dept) {
                    final isSelected = dept == _selectedDepartment;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(dept),
                        selected: isSelected,
                        onSelected:
                            (_) => setState(() => _selectedDepartment = dept),
                        selectedColor: Colors.blue,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientColumn(
    BuildContext context,
    String title,
    List<Patient> patients,
    Color color,
    String status,
  ) {
    return Expanded(
      child: Card(
        color: color.withOpacity(0.05),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Expanded(
              child:
                  patients.isEmpty
                      ? Center(
                        child: Text(
                          'No patients',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                      : ReorderableListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        itemCount: patients.length,
                        itemBuilder:
                            (context, index) =>
                                _buildPatientCard(context, patients[index]),
                        onReorder: (oldIndex, newIndex) {
                          if (oldIndex < newIndex) newIndex -= 1;
                          final patient = patients[oldIndex];
                          Provider.of<PatientProvider>(
                            context,
                            listen: false,
                          ).reorderPatient(
                            patient.department,
                            oldIndex,
                            newIndex,
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientCard(BuildContext context, Patient patient) {
    return Card(
      key: Key(patient.id),
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showPatientActions(context, patient),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: patient.statusColor.withOpacity(0.2),
                    child: Text(
                      patient.name.split(' ').map((n) => n[0]).join(),
                      style: TextStyle(color: patient.statusColor),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          patient.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'MRN: ${patient.mrn}',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: patient.statusColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      patient.status,
                      style: TextStyle(
                        color: patient.statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.access_time, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    _formatWaitTime(patient),
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const Spacer(),
                  Text(
                    patient.doctor,
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(width: 4),
                  if (patient.isEmergency)
                    const Icon(Icons.warning, size: 14, color: Colors.red),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                patient.department,
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatWaitTime(Patient patient) {
    if (patient.status == 'Completed') {
      return 'Completed';
    }
    final duration = DateTime.now().difference(patient.registrationTime);
    final minutes = duration.inMinutes;
    return 'Waiting: ${minutes} min';
  }

  List<Patient> _filterPatients(List<Patient> patients) {
    var filtered = patients;

    // Filter by department
    if (_selectedDepartment != 'All Departments') {
      filtered =
          filtered.where((p) => p.department == _selectedDepartment).toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered =
          filtered
              .where(
                (p) =>
                    p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                    p.mrn.toLowerCase().contains(_searchQuery.toLowerCase()),
              )
              .toList();
    }

    return filtered;
  }

  void _showAddPatientDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final mrnController = TextEditingController();
    String department = 'General Medicine';
    String doctor = 'Dr. Smith';
    bool isEmergency = false;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add New Patient'),
            content: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Full Name'),
                      validator:
                          (value) =>
                              value?.isEmpty ?? true ? 'Required field' : null,
                    ),
                    TextFormField(
                      controller: mrnController,
                      decoration: const InputDecoration(labelText: 'MRN'),
                      validator:
                          (value) =>
                              value?.isEmpty ?? true ? 'Required field' : null,
                    ),
                    DropdownButtonFormField<String>(
                      value: department,
                      items:
                          _departments
                              .where((d) => d != 'All Departments')
                              .map(
                                (dept) => DropdownMenuItem(
                                  value: dept,
                                  child: Text(dept),
                                ),
                              )
                              .toList(),
                      onChanged: (value) => department = value!,
                      decoration: const InputDecoration(
                        labelText: 'Department',
                      ),
                    ),
                    DropdownButtonFormField<String>(
                      value: doctor,
                      items:
                          ['Dr. Smith', 'Dr. Johnson', 'Dr. Williams']
                              .map(
                                (doc) => DropdownMenuItem(
                                  value: doc,
                                  child: Text(doc),
                                ),
                              )
                              .toList(),
                      onChanged: (value) => doctor = value!,
                      decoration: const InputDecoration(labelText: 'Doctor'),
                    ),
                    CheckboxListTile(
                      title: const Text('Emergency Case'),
                      value: isEmergency,
                      onChanged: (value) => isEmergency = value ?? false,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    final newPatient = Patient(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: nameController.text,
                      mrn: mrnController.text,
                      age: 0, // Default value
                      gender: 'Unknown', // Default value
                      contact: '', // Default value
                      department: department,
                      doctor: doctor,
                      isEmergency: isEmergency,
                      registrationTime: DateTime.now(),
                    );
                    Provider.of<PatientProvider>(
                      context,
                      listen: false,
                    ).addPatient(newPatient);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add Patient'),
              ),
            ],
          ),
    );
  }

  void _showPatientActions(BuildContext context, Patient patient) {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit Patient'),
                onTap: () {
                  Navigator.pop(context);
                  _showEditPatientDialog(context, patient);
                },
              ),
              ListTile(
                leading: const Icon(Icons.medical_services),
                title: const Text('Change Status'),
                onTap: () {
                  Navigator.pop(context);
                  _showStatusDialog(context, patient);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text(
                  'Remove Patient',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _confirmRemovePatient(context, patient);
                },
              ),
            ],
          ),
    );
  }

  void _showEditPatientDialog(BuildContext context, Patient patient) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: patient.name);
    final mrnController = TextEditingController(text: patient.mrn);
    String department = patient.department;
    String doctor = patient.doctor;
    bool isEmergency = patient.isEmergency;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Edit Patient'),
            content: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Full Name'),
                      validator:
                          (value) =>
                              value?.isEmpty ?? true ? 'Required field' : null,
                    ),
                    TextFormField(
                      controller: mrnController,
                      decoration: const InputDecoration(labelText: 'MRN'),
                      validator:
                          (value) =>
                              value?.isEmpty ?? true ? 'Required field' : null,
                    ),
                    DropdownButtonFormField<String>(
                      value: department,
                      items:
                          _departments
                              .where((d) => d != 'All Departments')
                              .map(
                                (dept) => DropdownMenuItem(
                                  value: dept,
                                  child: Text(dept),
                                ),
                              )
                              .toList(),
                      onChanged: (value) => department = value!,
                      decoration: const InputDecoration(
                        labelText: 'Department',
                      ),
                    ),
                    DropdownButtonFormField<String>(
                      value: doctor,
                      items:
                          ['Dr. Smith', 'Dr. Johnson', 'Dr. Williams']
                              .map(
                                (doc) => DropdownMenuItem(
                                  value: doc,
                                  child: Text(doc),
                                ),
                              )
                              .toList(),
                      onChanged: (value) => doctor = value!,
                      decoration: const InputDecoration(labelText: 'Doctor'),
                    ),
                    CheckboxListTile(
                      title: const Text('Emergency Case'),
                      value: isEmergency,
                      onChanged: (value) => isEmergency = value ?? false,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    final updatedPatient = patient.copyWith(
                      name: nameController.text,
                      mrn: mrnController.text,
                      department: department,
                      doctor: doctor,
                      isEmergency: isEmergency,
                    );
                    // You'll need to add an updatePatient method to your provider
                    // Provider.of<PatientProvider>(context, listen: false)
                    //     .updatePatient(updatedPatient);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save Changes'),
              ),
            ],
          ),
    );
  }

  void _showStatusDialog(BuildContext context, Patient patient) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Change Patient Status'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('Waiting'),
                  onTap: () {
                    Provider.of<PatientProvider>(
                      context,
                      listen: false,
                    ).updatePatientStatus(patient.id, 'waiting');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('In Consultation'),
                  onTap: () {
                    Provider.of<PatientProvider>(
                      context,
                      listen: false,
                    ).updatePatientStatus(patient.id, 'In Consultation');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('Completed'),
                  onTap: () {
                    Provider.of<PatientProvider>(
                      context,
                      listen: false,
                    ).updatePatientStatus(patient.id, 'Completed');
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
    );
  }

  void _confirmRemovePatient(BuildContext context, Patient patient) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirm Removal'),
            content: Text('Remove ${patient.name} from the queue?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Provider.of<PatientProvider>(
                    context,
                    listen: false,
                  ).removeFromQueue(patient.id);
                  Navigator.pop(context);
                },
                child: const Text(
                  'Remove',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }
}
