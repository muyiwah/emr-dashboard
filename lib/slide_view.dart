import 'package:flutter/material.dart';
import 'package:schmgtsystem/add_facility.dart';
import 'package:schmgtsystem/analytics_dashboard.dart';
import 'package:schmgtsystem/appointment_scheduler.dart';
import 'package:schmgtsystem/biling2.dart';
import 'package:schmgtsystem/billing_and_payment.dart';
import 'package:schmgtsystem/billing_medical.dart';
import 'package:schmgtsystem/chief_complaint.dart';
import 'package:schmgtsystem/clinical_notes.dart';
import 'package:schmgtsystem/cross_facility_staff_assignment.dart';
import 'package:schmgtsystem/discharge_summary.dart';
import 'package:schmgtsystem/emergency_triade.dart';
import 'package:schmgtsystem/emrgency.dart';
import 'package:schmgtsystem/facility_management_dashboard.dart';
import 'package:schmgtsystem/financials.dart';
import 'package:schmgtsystem/healthcare_report.dart';
import 'package:schmgtsystem/hr_dashboard.dart';
import 'package:schmgtsystem/imunization_dashboard.dart';
import 'package:schmgtsystem/insurance_and_billling.dart';
import 'package:schmgtsystem/inventory_dashboard.dart';
import 'package:schmgtsystem/ipd_billing.dart';
import 'package:schmgtsystem/ipd_management.dart';
import 'package:schmgtsystem/ipd_managemente.dart';
import 'package:schmgtsystem/ipd_nurse.dart';
import 'package:schmgtsystem/lab_operations.dart';
import 'package:schmgtsystem/lab_results.dart';
import 'package:schmgtsystem/lab_technician.dart';
import 'package:schmgtsystem/laboratory.dart';
import 'package:schmgtsystem/login.dart';
import 'package:schmgtsystem/madication_management.dart';
import 'package:schmgtsystem/medical_dashboard.dart';
import 'package:schmgtsystem/medical_encounter.dart';
import 'package:schmgtsystem/medical_history.dart';
import 'package:schmgtsystem/medical_patience_interface.dart';
import 'package:schmgtsystem/medical_prescription.dart';
import 'package:schmgtsystem/medical_staff_scheduling.dart';
import 'package:schmgtsystem/multi_facilty_resourse.dart';
import 'package:schmgtsystem/notification_and_reminder.dart';
import 'package:schmgtsystem/nursing_care_plan.dart';
import 'package:schmgtsystem/opd_management.dart';
import 'package:schmgtsystem/operational_dashboard.dart';
import 'package:schmgtsystem/pharmacare.dart';
import 'package:schmgtsystem/pharmacy_management.dart';
import 'package:schmgtsystem/pharmacy_management2.dart';
import 'package:schmgtsystem/physical_examination.dart';
import 'package:schmgtsystem/post_medical_history.dart';
import 'package:schmgtsystem/prescription_interface.dart';
import 'package:schmgtsystem/radiology_and_imaging.dart';
import 'package:schmgtsystem/radiology_emr.dart';
import 'package:schmgtsystem/radiology_module.dart';
import 'package:schmgtsystem/refil_management.dart';
import 'package:schmgtsystem/reports&analysis.dart';
import 'package:schmgtsystem/round_tracker.dart';
import 'package:schmgtsystem/staff_management.dart';
import 'package:schmgtsystem/staff_management2.dart';
import 'package:schmgtsystem/surgery_record.dart';
import 'package:schmgtsystem/surgery_schedule.dart';
import 'package:schmgtsystem/vitalsigns_tracking.dart';
import 'package:schmgtsystem/walkin_registration.dart';
import 'package:schmgtsystem/ward_transfer.dart';

class SlideView extends StatelessWidget {
  const SlideView({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(body: PageView(children: [
      OPDManagementScreen(),
// AddFacilityScreen(),
// AnalyticslDashboard(),
// AppointmentSchedulerScreen(),
// BillingPaymentsScreen2(),
// BillingPaymentsScreen(),
EnhancedBillingPaymentsScreen(),
ClinicalNotesScreen(),
// StaffAssignmentScreen(),
DischargeSummaryScreen(),
TriageSystemScreen(),
EmergencyModuleScreen(),
// FacilityManagementScreen(),
// Financials(),
// ReportsAnalyticsPage(),
// HRDashboardScreen(),
ImmunizationsScreen(),
// InsuranceBillingScreen(),
    // InventoryDashboard(),  
    // IPDBillingScreen(),
    IPDManagementScreen(),

// IPDDashboard(),

NurseStationDashboard(),
LabOperationsDashboard(),
LabResultsScreen(),
LabTechnician(),

LabHubHomePage(),
MediCoreLoginScreen(),
MedicationManagementScreen(),
MedicalDashboard(),
MedicalEncounterNote(),
PastMedicalHistoryScreen(),
PatientInterfaceScreen(),
PrescriptionScreen(),
SchedulingScreen(),

MultiFacilityResourceView(),
NotificationsPage(),
NursingCarePlansScreen(),
OperationalDashboard(),
PharmaCareScreenDrugs(),


PharmacyManagementScreen(),
PharmacyDashboard2(),


PhysicalExaminationScreen(),

PastMedicalHistoryScreen(),

RadiologyHomePage(),
RadiologyDashboard(),
RadiologyModuleScreen(),
RadiologyHomePage(),

RefillManagementScreen(),///rpharmacy refill

DoctorRoundsScreen(),///round chsecker

AddStaffProfileScreen(),////addd staff

StaffManagementScreen(), /////staff management

SurgeryRecord(), /////patiernt surger history
OTSchedulerScreen(), ////////surgeryyy
// VitalSignsHomePage(),
// WalkInRegistrationScreen(),

WardTransferManagementScreen()///ward transfer

    ],));
  }
}