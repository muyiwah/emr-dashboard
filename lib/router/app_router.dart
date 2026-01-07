import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart' as provider;
import 'package:schmgtsystem/login.dart';
import 'package:schmgtsystem/providers/patient_proviider.dart';
import 'package:schmgtsystem/models/patient_model.dart';

// Screen imports
import 'package:schmgtsystem/all_patient_record.dart';
import 'package:schmgtsystem/all_patient_record_vitals.dart';
import 'package:schmgtsystem/appointment_scheduler.dart';
import 'package:schmgtsystem/billing_medical.dart' as billing;
import 'package:schmgtsystem/discharge_summary.dart';
import 'package:schmgtsystem/doctor_patient_dash.dart';
import 'package:schmgtsystem/doctor_patient_imaging_result.dart';
import 'package:schmgtsystem/doctor_waitlist.dart';
import 'package:schmgtsystem/emrgency.dart';
import 'package:schmgtsystem/healthcare_report.dart';
import 'package:schmgtsystem/hpi.dart';
import 'package:schmgtsystem/imunization_dashboard.dart';
import 'package:schmgtsystem/la_result_entry_panel.dart';
import 'package:schmgtsystem/lab_operations.dart';
import 'package:schmgtsystem/lab_test_template_picker.dart';
import 'package:schmgtsystem/labtest_request.dart';
import 'package:schmgtsystem/labtest_results.dart';
import 'package:schmgtsystem/medical_history.dart';
import 'package:schmgtsystem/medications.dart';
import 'package:schmgtsystem/next_shift.dart';
import 'package:schmgtsystem/nursing_care_plan.dart';
import 'package:schmgtsystem/opd_management.dart';
import 'package:schmgtsystem/patient_clinical_notes.dart';
import 'package:schmgtsystem/patient_details.dart';
import 'package:schmgtsystem/pharmacy_management.dart';
import 'package:schmgtsystem/pharmacy_management2.dart';
import 'package:schmgtsystem/prescription_interface.dart';
import 'package:schmgtsystem/que_manager.dart';
import 'package:schmgtsystem/radiology_and_imaging.dart';
import 'package:schmgtsystem/radiology_emr.dart';
import 'package:schmgtsystem/refil_management.dart';
import 'package:schmgtsystem/round_tracker.dart';
import 'package:schmgtsystem/shift_management.dart';
import 'package:schmgtsystem/surgery_record.dart';
import 'package:schmgtsystem/surgery_schedule.dart';
import 'package:schmgtsystem/vitals_history.dart';
import 'package:schmgtsystem/vitals_input.dart';
import 'package:schmgtsystem/ward_transfer.dart';
import 'package:schmgtsystem/role_management.dart';
import 'package:schmgtsystem/roles_list_screen.dart';
import 'package:schmgtsystem/create_staff_screen.dart';
import 'package:schmgtsystem/staff_list_screen.dart';
import 'package:schmgtsystem/create_department_screen.dart';
import 'package:schmgtsystem/departments_list_screen.dart';

// Menu Item Model
class MenuItem {
  final String title;
  final IconData icon;
  final String route;
  final List<MenuItem>? subItems;

  MenuItem({
    required this.title,
    required this.icon,
    required this.route,
    this.subItems,
  });
}

// Providers
final sidebarExpandedProvider = StateProvider<bool>((ref) => true);

// Menu Configuration
final menuItemsProvider = Provider<List<MenuItem>>((ref) {
  final allMenuItems = [
    MenuItem(title: 'Dashboard', icon: Icons.dashboard, route: '/dashboard'),
    MenuItem(
      title: 'Patient Management',
      icon: Icons.person_add,
      route: '/patient-management',
      subItems: [
        MenuItem(
          title: 'Immunization',
          icon: Icons.vaccines,
          route: '/patient-management/immunization',
        ),
        MenuItem(
          title: 'Add New Patient',
          icon: Icons.person_add,
          route: '/patient-management/add-patient',
        ),
        MenuItem(
          title: 'Queue Manager',
          icon: Icons.queue,
          route: '/patient-management/queue-manager',
        ),
        MenuItem(
          title: 'Patient Vitals',
          icon: Icons.favorite,
          route: '/patient-management/patient-vitals',
        ),
        MenuItem(
          title: 'Patient Records',
          icon: Icons.folder,
          route: '/patient-management/patient-records',
        ),
        MenuItem(
          title: 'Appointments',
          icon: Icons.calendar_today,
          route: '/patient-management/appointments',
        ),
      ],
    ),
    MenuItem(
      title: 'Doctors',
      icon: Icons.medical_services,
      route: '/doctors',
      subItems: [
        MenuItem(
          title: 'Waitlist',
          icon: Icons.list,
          route: '/doctors/waitlist',
        ),
        MenuItem(
          title: 'Surgery Management',
          icon: Icons.healing,
          route: '/doctors/surgery-management',
        ),
        MenuItem(
          title: 'Surgery Schedule',
          icon: Icons.schedule,
          route: '/doctors/surgery-schedule',
        ),
      ],
    ),
    MenuItem(
      title: 'Clinical Management',
      icon: Icons.medical_information,
      route: '/clinical-management',
      subItems: [
        MenuItem(
          title: 'Lab',
          icon: Icons.science,
          route: '/clinical-management/lab',
        ),
        MenuItem(
          title: 'Imaging/Radiology',
          icon: Icons.image,
          route: '/clinical-management/imaging/radiology',
        ),
      ],
    ),
    MenuItem(
      title: 'Inpatient Management (IPD)',
      icon: Icons.local_hospital,
      route: '/ipd',
      subItems: [
        MenuItem(
          title: 'Emergency',
          icon: Icons.emergency,
          route: '/ipd/emergency',
        ),
        MenuItem(
          title: 'Bed Management',
          icon: Icons.bed,
          route: '/ipd/bed-management',
        ),
        MenuItem(
          title: 'Ward Rounds',
          icon: Icons.people,
          route: '/ipd/ward-rounds',
        ),
        MenuItem(
          title: 'Discharge',
          icon: Icons.exit_to_app,
          route: '/ipd/discharge',
        ),
      ],
    ),
    MenuItem(
      title: 'Labs',
      icon: Icons.science,
      route: '/labs',
      subItems: [
        MenuItem(
          title: 'Test Request',
          icon: Icons.assignment,
          route: '/labs/test-request',
        ),
        MenuItem(
          title: 'Dashboard',
          icon: Icons.dashboard,
          route: '/labs/dashboard',
        ),
        MenuItem(
          title: 'Lab Result Entry',
          icon: Icons.edit,
          route: '/labs/lab-result-entry',
        ),
      ],
    ),
    MenuItem(
      title: 'Shift',
      icon: Icons.access_time,
      route: '/shift',
      subItems: [
        MenuItem(
          title: 'Management',
          icon: Icons.settings,
          route: '/shift/management',
        ),
      ],
    ),
    MenuItem(
      title: 'Billing & Payments',
      icon: Icons.payment,
      route: '/billing',
      subItems: [
        MenuItem(
          title: 'New Billing Entry',
          icon: Icons.add_card,
          route: '/billing/new-billing-entry',
        ),
      ],
    ),
    MenuItem(
      title: 'Pharmacy',
      icon: Icons.local_pharmacy,
      route: '/pharmacy',
      subItems: [
        MenuItem(
          title: 'Drugs',
          icon: Icons.medication,
          route: '/pharmacy/drugs',
        ),
        MenuItem(
          title: 'Refill',
          icon: Icons.refresh,
          route: '/pharmacy/refill',
        ),
        MenuItem(title: 'Queue', icon: Icons.queue, route: '/pharmacy/queue'),
        MenuItem(
          title: 'Orders',
          icon: Icons.shopping_cart,
          route: '/pharmacy/orders',
        ),
      ],
    ),
    MenuItem(
      title: 'Nursing',
      icon: Icons.night_shelter,
      route: '/nursing',
      subItems: [
        MenuItem(
          title: 'Patient Management',
          icon: Icons.person,
          route: '/nursing/patient-management',
        ),
      ],
    ),
    MenuItem(
      title: 'Manage Staff',
      icon: Icons.people,
      route: '/manage-staff',
      subItems: [
        MenuItem(
          title: 'Create Staff',
          icon: Icons.person_add,
          route: '/manage-staff/create-staff',
        ),
        MenuItem(
          title: 'Manage Staff',
          icon: Icons.people_outline,
          route: '/manage-staff/manage-staff',
        ),
        MenuItem(
          title: 'Create Roles',
          icon: Icons.badge,
          route: '/manage-staff/create-roles',
        ),
        MenuItem(
          title: 'Manage Roles',
          icon: Icons.settings,
          route: '/manage-staff/manage-roles',
        ),
        MenuItem(
          title: 'Add Department',
          icon: Icons.business,
          route: '/manage-staff/add-department',
        ),
        MenuItem(
          title: 'Manage Departments',
          icon: Icons.business_center,
          route: '/manage-staff/manage-departments',
        ),
      ],
    ),
  ];

  return allMenuItems;
});

// Router Configuration with Persistent Shell
final router = GoRouter(
  initialLocation: '/dashboard',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const MediCoreLoginScreen(),
    ),

    ShellRoute(
      builder: (context, state, child) {
        return DashboardShell(child: child);
      },
      routes: [
        // Dashboard
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardHomeScreen(),
        ),

        // Patient Management Routes
        GoRoute(
          path: '/patient-management',
          redirect: (context, state) => '/patient-management/immunization',
        ),
        GoRoute(
          path: '/patient-management/immunization',
          builder: (context, state) => ImmunizationsScreen(),
        ),
        GoRoute(
          path: '/patient-management/add-patient',
          builder: (context, state) => OPDManagementScreen(),
        ),
        GoRoute(
          path: '/patient-management/queue-manager',
          builder: (context, state) => QueueManagementScreen(),
        ),
        GoRoute(
          path: '/patient-management/patient-vitals',
          builder: (context, state) => const PatientVitalsScreen(),
        ),
        GoRoute(
          path: '/patient-management/patient-records',
          builder: (context, state) => const PatientRecordsScreenWrapper(),
        ),
        GoRoute(
          path: '/patient-management/patient-details',
          builder: (context, state) {
            final extra = state.extra;
            if (extra is! Patient) {
              return const Scaffold(
                body: Center(
                  child: Text('No patient selected'),
                ),
              );
            }
            return PatientDetailsScreen(patient: extra);
          },
        ),
        GoRoute(
          path: '/patient-management/appointments',
          builder: (context, state) => AppointmentSchedulerScreen(),
        ),

        // Doctors Routes
        GoRoute(
          path: '/doctors',
          redirect: (context, state) => '/doctors/waitlist',
        ),
        GoRoute(
          path: '/doctors/waitlist',
          builder: (context, state) => const DoctorWaitListScreenWrapper(),
        ),
        GoRoute(
          path: '/doctors/surgery-management',
          builder: (context, state) => SurgeryRecord(),
        ),
        GoRoute(
          path: '/doctors/surgery-schedule',
          builder: (context, state) => OTSchedulerScreen(),
        ),

        // Clinical Management Routes
        GoRoute(
          path: '/clinical-management',
          redirect: (context, state) => '/clinical-management/lab',
        ),
        GoRoute(
          path: '/clinical-management/lab',
          builder: (context, state) => RadiologyDashboard(),
        ),
        GoRoute(
          path: '/clinical-management/imaging/radiology',
          builder: (context, state) => RadiologyHomePage(),
        ),

        // IPD Routes
        GoRoute(path: '/ipd', redirect: (context, state) => '/ipd/emergency'),
        GoRoute(
          path: '/ipd/emergency',
          builder: (context, state) => EmergencyModuleScreen(),
        ),
        GoRoute(
          path: '/ipd/bed-management',
          builder: (context, state) => WardTransferManagementScreen(),
        ),
        GoRoute(
          path: '/ipd/ward-rounds',
          builder: (context, state) => DoctorRoundsScreen(),
        ),
        GoRoute(
          path: '/ipd/discharge',
          builder: (context, state) => DischargeSummaryScreen(),
        ),

        // Labs Routes
        GoRoute(path: '/labs', redirect: (context, state) => '/labs/dashboard'),
        GoRoute(
          path: '/labs/test-request',
          builder: (context, state) => LabTestRequests(),
        ),
        GoRoute(
          path: '/labs/dashboard',
          builder: (context, state) => LabOperationsDashboard(),
        ),
        GoRoute(
          path: '/labs/lab-result-entry',
          builder: (context, state) => const LabResultEntryScreenWrapper(),
        ),

        // Shift Routes
        GoRoute(
          path: '/shift',
          redirect: (context, state) => '/shift/management',
        ),
        GoRoute(
          path: '/shift/management',
          builder: (context, state) => const ShiftManagementScreenWrapper(),
        ),

        // Billing Routes
        GoRoute(
          path: '/billing',
          redirect: (context, state) => '/billing/new-billing-entry',
        ),
        GoRoute(
          path: '/billing/new-billing-entry',
          builder: (context, state) => billing.EnhancedBillingPaymentsScreen(),
        ),

        // Pharmacy Routes
        GoRoute(
          path: '/pharmacy',
          redirect: (context, state) => '/pharmacy/drugs',
        ),
        GoRoute(
          path: '/pharmacy/drugs',
          builder: (context, state) => PharmacyManagementSystem(),
        ),
        GoRoute(
          path: '/pharmacy/refill',
          builder: (context, state) => RefillManagementScreen(),
        ),
        GoRoute(
          path: '/pharmacy/queue',
          builder: (context, state) => PharmacyDashboard2(),
        ),
        GoRoute(
          path: '/pharmacy/orders',
          builder: (context, state) => PharmacyManagementScreen(),
        ),

        // Nursing Routes
        GoRoute(
          path: '/nursing',
          redirect: (context, state) => '/nursing/patient-management',
        ),
        GoRoute(
          path: '/nursing/patient-management',
          builder: (context, state) => NursingCarePlansScreen(),
        ),

        // Manage Staff Routes
        GoRoute(
          path: '/manage-staff',
          redirect: (context, state) => '/manage-staff/manage-staff',
        ),
        GoRoute(
          path: '/manage-staff/create-staff',
          builder: (context, state) => const CreateStaffScreen(),
        ),
        GoRoute(
          path: '/manage-staff/manage-staff',
          builder: (context, state) => const StaffListScreen(),
        ),
        GoRoute(
          path: '/manage-staff/create-roles',
          builder: (context, state) => const RoleManagementScreen(),
        ),
        GoRoute(
          path: '/manage-staff/manage-roles',
          builder: (context, state) => const RolesListScreen(),
        ),
        GoRoute(
          path: '/manage-staff/add-department',
          builder: (context, state) => const CreateDepartmentScreen(),
        ),
        GoRoute(
          path: '/manage-staff/manage-departments',
          builder: (context, state) => const DepartmentsListScreen(),
        ),
      ],
    ),
  ],
);

// Main Dashboard Shell - This stays persistent
class DashboardShell extends ConsumerStatefulWidget {
  final Widget child;

  const DashboardShell({Key? key, required this.child}) : super(key: key);

  @override
  ConsumerState<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends ConsumerState<DashboardShell> {
  @override
  Widget build(BuildContext context) {
    final sidebarExpanded = ref.watch(sidebarExpandedProvider);

    return Scaffold(
      body: Row(
        children: [
          // Persistent Sidebar
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: sidebarExpanded ? 220 : 70,
            child: PersistentSidebar(),
          ),
          // Main Content Area
          Expanded(
            child: Column(
              children: [
                // Persistent Header
                PersistentHeader(),
                // Dynamic Content
                Expanded(
                  child: Container(color: Colors.grey[50], child: widget.child),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Persistent Sidebar Component
class PersistentSidebar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allMenuItems = ref.watch(menuItemsProvider);
    final sidebarExpanded = ref.watch(sidebarExpandedProvider);
    final currentLocation =
        GoRouter.of(context).routeInformationProvider.value.location;

    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.7),
            spreadRadius: 1,
            offset: const Offset(-1, 1),
            blurRadius: 1,
          ),
        ],
        borderRadius: BorderRadius.circular(24),
        border: Border.all(width: .2, color: Colors.black.withOpacity(.5)),
        color: const Color(0xFF000080), // AppColors.secondary
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.home, color: Colors.white),
          ),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                Text(
                  'Admin Dashboard',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Expanded(
            child: ListView.builder(
              itemCount: allMenuItems.length,
              itemBuilder: (context, index) {
                final item = allMenuItems[index];
                final isActive = _isRouteActive(currentLocation, item.route);
                final hasSubItems =
                    item.subItems != null && item.subItems!.isNotEmpty;

                if (hasSubItems && sidebarExpanded) {
                  return _buildExpandableMenuItem(
                    context,
                    ref,
                    item,
                    currentLocation,
                  );
                } else {
                  return _buildMenuItem(context, ref, item, isActive);
                }
              },
            ),
          ),
          const SizedBox(height: 20),
          // Sidebar Toggle
          IconButton(
            onPressed: () {
              ref.read(sidebarExpandedProvider.notifier).state =
                  !sidebarExpanded;
            },
            icon: Icon(
              sidebarExpanded ? Icons.chevron_left : Icons.chevron_right,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    WidgetRef ref,
    MenuItem item,
    bool isActive,
  ) {
    final sidebarExpanded = ref.watch(sidebarExpandedProvider);

    return GestureDetector(
      onTap: () => context.go(item.route),
      child: Container(
        margin: const EdgeInsets.only(left: 10, right: 20, bottom: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color:
              isActive
                  ? const Color.fromARGB(115, 226, 239, 248).withOpacity(.4)
                  : Colors.transparent,
        ),
        padding: const EdgeInsets.only(left: 6.0, top: 8, bottom: 8, right: 16),
        child: Row(
          children: [
            Icon(item.icon, color: Colors.white, size: 14),
            if (sidebarExpanded) ...[
              const SizedBox(width: 20),
              Text(
                item.title,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableMenuItem(
    BuildContext context,
    WidgetRef ref,
    MenuItem item,
    String currentLocation,
  ) {
    final isParentActive = _isRouteActive(currentLocation, item.route);

    return ExpansionTile(
      iconColor: Colors.blue,
      collapsedIconColor: Colors.white,
      title: Text(
        item.title,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      leading: Icon(item.icon, color: Colors.white, size: 14),
      backgroundColor:
          isParentActive
              ? const Color.fromARGB(115, 226, 239, 248).withOpacity(.4)
              : null,
      children:
          item.subItems!.map((subItem) {
            final isSubActive = _isRouteActive(currentLocation, subItem.route);
            return InkWell(
              onTap: () => context.go(subItem.route),
              child: Container(
                alignment: Alignment.centerLeft,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color:
                      isSubActive
                          ? const Color.fromARGB(
                            115,
                            226,
                            239,
                            248,
                          ).withOpacity(.4)
                          : Colors.transparent,
                ),
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: Text(
                    subItem.title,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 255, 243, 243),
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }

  bool _isRouteActive(String currentLocation, String itemRoute) {
    if (itemRoute == '/dashboard') {
      return currentLocation == '/dashboard';
    }
    return currentLocation.startsWith(itemRoute);
  }
}

// Persistent Header Component
class PersistentHeader extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocation =
        GoRouter.of(context).routeInformationProvider.value.location;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(child: _buildBreadcrumbs(currentLocation)),
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.indigo,
                child: const Icon(Icons.person, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.red),
                onPressed: () => _showLogoutDialog(context),
                tooltip: 'Logout',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBreadcrumbs(String currentLocation) {
    final segments =
        currentLocation
            .split('/')
            .where((s) => s.isNotEmpty)
            .map((s) => s.replaceAll('-', ' ').toUpperCase())
            .toList();

    if (segments.isEmpty) return const SizedBox.shrink();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (int i = 0; i < segments.length; i++) ...[
            if (i > 0)
              const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
            Chip(
              label: Text(segments[i]),
              onDeleted:
                  i == segments.length - 1
                      ? null
                      : () {
                        // Navigate back
                      },
            ),
          ],
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.go('/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}

// Screen Wrapper Components
class DashboardHomeScreen extends StatelessWidget {
  const DashboardHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReportsAnalyticsPage();
  }
}

class PatientVitalsScreen extends StatelessWidget {
  const PatientVitalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return provider.ChangeNotifierProvider(
      create: (context) => PatientProvider(),
      child: PageView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          PatientRecordsScreenVitals(
            onPatientSelected: (patient) {
              final providerInstance = provider.Provider.of<PatientProvider>(
                context,
                listen: false,
              );
              providerInstance.setCurrentPatient(patient);
            },
          ),
          VitalSignsScreen(),
          provider.Consumer<PatientProvider>(
            builder: (context, patientProvider, _) {
              return HpiScreen(
                goBack: () {},
                patientId: patientProvider.currentPatient?.id ?? '',
                patientMrn: patientProvider.currentPatient?.mrn ?? '',
                patientName: patientProvider.currentPatient?.name ?? '',
              );
            },
          ),
        ],
      ),
    );
  }
}

class PatientRecordsScreenWrapper extends StatelessWidget {
  const PatientRecordsScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return provider.ChangeNotifierProvider(
      create: (context) => PatientProvider(),
      child: Builder(
        builder: (context) {
          return PatientRecordsScreen(
            onPatientSelected: (patient) {
              GoRouter.of(context).go(
                '/patient-management/patient-details',
                extra: patient,
              );
            },
          );
        },
      ),
    );
  }
}

class DoctorWaitListScreenWrapper extends StatelessWidget {
  const DoctorWaitListScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return provider.ChangeNotifierProvider(
      create: (context) => PatientProvider(),
      child: PageView(
        children: [
          DoctorWaitListScreen(
            onPatientSelected: (patient) {
              final providerInstance = provider.Provider.of<PatientProvider>(
                context,
                listen: false,
              );
              providerInstance.setCurrentPatient(patient);
            },
          ),
          provider.Consumer<PatientProvider>(
            builder: (context, patientProvider, _) {
              return DoctorPatinetDashboard(
                onMedicalhisorySelected: (patient) {},
                onMedicationsSelected: (patient) {},
                onVitalHistorySelected: (patient) {},
                onLabResultSelected: (patient) {},
                onClinicalNotesSelected: (patient) {},
                onImagingSelected: (patient) {},
              );
            },
          ),
          MedicalHistoryScreen(goBack: () {}),
          MedicationScreen(goBack: () {}),
          VitalsHistory(goBack: () {}),
          MedicalLabResultsScreen(goBack: () {}),
          PatientClinicalNotes(goBack: () {}),
          MedicalImagingScreen(goBack: () {}),
        ],
      ),
    );
  }
}

class LabResultEntryScreenWrapper extends StatelessWidget {
  const LabResultEntryScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return PageView(
      children: [LabTestTemplate(), LabResultEntryPanel(goBack: () {})],
    );
  }
}

class ShiftManagementScreenWrapper extends StatelessWidget {
  const ShiftManagementScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return PageView(children: [ShiftManagemt(), NextShift()]);
  }
}
