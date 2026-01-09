import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schmgtsystem/all_patient_record.dart';
import 'package:schmgtsystem/all_patient_record_vitals.dart';
import 'package:schmgtsystem/appointment_scheduler.dart';
import 'package:schmgtsystem/billing_medical.dart';
import 'package:schmgtsystem/chief_complaint.dart';
import 'package:schmgtsystem/constants/appcolor.dart';
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
import 'package:schmgtsystem/pharmacare.dart';
import 'package:schmgtsystem/pharmacy_management.dart';
import 'package:schmgtsystem/pharmacy_management2.dart';
import 'package:schmgtsystem/physical_examination.dart';
import 'package:schmgtsystem/prescription_interface.dart';
import 'package:schmgtsystem/providers/patient_proviider.dart';
import 'package:schmgtsystem/que_manager.dart';
import 'package:schmgtsystem/providers/user_provider.dart';
import 'package:collection/collection.dart';
import 'package:schmgtsystem/radiology_and_imaging.dart';
import 'package:schmgtsystem/radiology_emr.dart';
import 'package:schmgtsystem/refil_management.dart';
import 'package:schmgtsystem/round_tracker.dart';
import 'package:schmgtsystem/shift_management.dart';
import 'package:schmgtsystem/slide_view.dart';
import 'package:schmgtsystem/surgery_record.dart';
import 'package:schmgtsystem/surgery_schedule.dart';
import 'package:schmgtsystem/vitals_history.dart';
import 'package:schmgtsystem/vitals_input.dart';
import 'package:schmgtsystem/ward_transfer.dart';
import 'package:schmgtsystem/widgets/header_new.dart';

class MenuItem {
  final String title;
  final IconData icon;
  final List<String> subMenuItems;

  MenuItem(this.title, this.icon, this.subMenuItems);
}

class SchoolAdminDashboard3 extends StatelessWidget {
  const SchoolAdminDashboard3({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'School Admin Dashboard',
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.indigoAccent,
        scaffoldBackgroundColor: const Color(0xFFF5F6FA),
        textTheme: ThemeData.light().textTheme.apply(bodyColor: Colors.black),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      home: const DashboardScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

String roleRoute = '';

class _DashboardScreenState extends State<DashboardScreen> {
  late final Map<String, Widget> internalRoutes = _createRoutes();
  String currentRoute = 'home';
  List<String> breadcrumbs = ['home'];
  PageController _pageController = PageController();
  @override
  void initState() {
    super.initState();
    applyRole();

    // for (int i = 0; i < menuItems.length; i++) {
    //   _controllers[i] = ExpansionTileController();
    // }
  }

  applyRole() {
    Provider.of<UserProvider>(context, listen: false).userRole == 'Teacher'
        ? currentRoute = 'teacherhome'
        : Provider.of<UserProvider>(context, listen: false).userRole == 'Admin'
        ? currentRoute = 'home'
        : currentRoute = 'accounthome';
    roleRoute = currentRoute;
    setState(() {});
  }

  Set<int> _builtTiles = {};
  Map<String, Widget> _createRoutes() {
    return {
      'home': ReportsAnalyticsPage(),

      'patient management/addnewpatient': OPDManagementScreen(),
      'doctors/surgerymanagement': SurgeryRecord(),
      'doctors/surgeryschedule': OTSchedulerScreen(),
      'inpatient management (ipd)/emergency': EmergencyModuleScreen(),
      'inpatient management (ipd)/discharge': DischargeSummaryScreen(),



      'billing & payments/newbillingentry': EnhancedBillingPaymentsScreen(),


      'pharmacy/refil': RefillManagementScreen(),
      'labs/dashboard': LabOperationsDashboard(),
      'patient management/immunization': ImmunizationsScreen(),
      'pharmacy/drugs': PharmacyManagementSystem(),
      'pharmacy/que': PharmacyDashboard2(),
      'pharmacy/orders': PharmacyManagementScreen(),

'inpatient management (ipd)/bedmanagement':WardTransferManagementScreen(),
'inpatient management (ipd)/wardrounds':DoctorRoundsScreen(),
      
      'patient management/queuemanager': QueueManagementScreen(),
      'nursing/patientmanagement': NursingCarePlansScreen(),
      'patient management/patientrecords': PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: [
          PatientRecordsScreen(
            onPatientSelected: (patient) {
              final provider = Provider.of<PatientProvider>(
                context,
                listen: false,
              );
              provider.setCurrentPatient(patient);

              _pageController.nextPage(
                duration: Duration(milliseconds: 200),
                curve: Curves.linear,
              );
              // Optional: automatically navigate to next page
              // _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
            },
          ),
          ChiefComplaintPage(
            onComplaintSubmitted: (complaint) {
              final provider = Provider.of<PatientProvider>(
                context,
                listen: false,
              );

              _pageController.nextPage(
                duration: Duration(milliseconds: 200),
                curve: Curves.linear,
              );
              provider.setChiefComplaint(complaint);
              // Optional: automatically navigate to next page
              // _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
            },

            goBack: () {
              _pageController.previousPage(
                duration: Duration(milliseconds: 200),
                curve: Curves.linear,
              );
            },
          ),
          HpiScreen(
            goBack: () {
              print('never tuned back');
              _pageController.previousPage(
                duration: Duration(milliseconds: 200),
                curve: Curves.linear,
              );
            },
            patientId:
                Provider.of<PatientProvider>(context).currentPatient?.id ?? '',
            patientMrn:
                Provider.of<PatientProvider>(context).currentPatient?.mrn ?? '',
            patientName:
                Provider.of<PatientProvider>(context).currentPatient?.name ??
                '',
          ),
        ],
      ),
      'patient management/patientvitals': PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: [
          PatientRecordsScreenVitals(
            onPatientSelected: (patient) {
              final provider = Provider.of<PatientProvider>(
                context,
                listen: false,
              );
              provider.setCurrentPatient(patient);

              _pageController.nextPage(
                duration: Duration(milliseconds: 200),
                curve: Curves.linear,
              );
              // Optional: automatically navigate to next page
              // _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
            },
          ),
          
          HpiScreen(
            goBack: () {
              print('never tuned back');
              _pageController.previousPage(
                duration: Duration(milliseconds: 200),
                curve: Curves.linear,
              );
            },
            patientId:
                Provider.of<PatientProvider>(context).currentPatient?.id ?? '',
            patientMrn:
                Provider.of<PatientProvider>(context).currentPatient?.mrn ?? '',
            patientName:
                Provider.of<PatientProvider>(context).currentPatient?.name ??
                '',
          ),
        ],
      ),

      //   /////doctors
      //   ///DoctorPatinetDashboard
      'doctors/waitlist': PageView(
        // physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: [
          DoctorWaitListScreen(
            onPatientSelected: (patient) {
              final provider = Provider.of<PatientProvider>(
                context,
                listen: false,
              );
              provider.setCurrentPatient(patient);

              _pageController.nextPage(
                duration: Duration(milliseconds: 200),
                curve: Curves.linear,
              );
            },
          ),
          DoctorPatinetDashboard(
            onMedicalhisorySelected: (patient) {
              _pageController.nextPage(
                duration: Duration(milliseconds: 200),
                curve: Curves.linear,
              );
            },
            onMedicationsSelected: (patient) {
              _pageController.jumpToPage(3);
            },
            onVitalHistorySelected: (patient) {
              _pageController.jumpToPage(4);
            },
            onLabResultSelected: (patient) {
              _pageController.jumpToPage(5);
            },
            onClinicalNotesSelected: (patient) {
              _pageController.jumpToPage(6);
            },
            onImagingSelected: (patient) {
              _pageController.jumpToPage(7);
            },
          ),

          MedicalHistoryScreen(
            goBack: () {
              _pageController.previousPage(
                duration: Duration(milliseconds: 200),
                curve: Curves.linear,
              );
            },
          ),

          MedicationScreen(
            goBack: () {
              _pageController.jumpToPage(1);
            },
          ),
          VitalsHistory(
            goBack: () {
              _pageController.jumpToPage(1);
            },
          ),
          MedicalLabResultsScreen(
            goBack: () {
              _pageController.jumpToPage(1);
            },
          ),
          PatientClinicalNotes(
            goBack: () {
              _pageController.jumpToPage(1);
            },
          ),
          MedicalImagingScreen(
            goBack: () {
              _pageController.jumpToPage(1);
            },
          ),
        ],
      ),

      'patient management/appointments': AppointmentSchedulerScreen(), //NextShift
      'clinical management/imaging/radiology': RadiologyHomePage(), //NextShift
      'clinical management/lab': RadiologyDashboard(), //NextShift
      'shift/management': ShiftManagemt(), //NextShift
      'labs/testrequest': LabTestRequests(),
      'labs/labresultentry': PageView(
        // physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: [
          LabTestTemplate(),

          LabResultEntryPanel(
            goBack: () {
              _pageController.previousPage(
                duration: Duration(milliseconds: 200),
                curve: Curves.linear,
              );
            },
          ),
        ],
      ),
      'shift/management': PageView(
        // physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: [
          ShiftManagemt(),

          NextShift(
            // goBack: () {
            //   _pageController.previousPage(
            //     duration: Duration(milliseconds: 200),
            //     curve: Curves.linear,
            //   );
            // },
          ),
        ],
      ),
      //   'student/examschedule': ExamTimeTable(),
      //   'student/registration': StudentRegistrationPage(
      //     navigateTo: () {
      //       navigateTo('student/allstudents');
      //     },
      //   ),
      //   'student/parents': AllParents(
      //     navigateTo: () {
      //       navigateTo('student/single_parent');
      //     },
      //   ),
      //   'student/parent_all_transactions': PaymentSummaryScreen(
      //     navigateTo: () {
      //       navigateTo('student/single_parent');
      //     },
      //   ),
      //   'student/allstudents': AllStudentsScreen(
      //     navigateTo: () {
      //       navigateTo('student/singlestudent');
      //     },
      //     navigateTo2: () {
      //       navigateTo('student/registration');
      //     },
      //   ),
      //   'staff/allstaff': AllStaff(
      //     navigateTo: () {
      //       navigateTo('student/single_parent');
      //     },
      //   ),
      //   'student/single_parent': SingleParent(
      //     navigateTo: () {
      //       navigateTo('student/parents');
      //     },
      //     navigateTo2: () {
      //       navigateTo('student/parent_all_transactions');
      //     },
      //   ),
      //   'home/dashboard_details': DashboardDetails(
      //     navigateBack: () {
      //       navigateTo('home');
      //     },
      //   ),

      //   ///classssess
      //   'class/timetable': const TimeTableApp(),
      //   'class/assignstudent': const AssignStudentsScreen(),
      //   'class/allclasses': SchoolClasses(
      //     navigateTo: () {
      //       navigateTo('class/alltables');
      //     },
      //     navigateTo2: () {
      //       navigateTo2('class/singleclass');
      //     },
      //     navigateTo3: () {
      //       navigateTo('class/assignstudent');
      //     },
      //   ),
      //   'class/singleclass': ClassDetailsScreen(
      //     navigateTo: () {
      //       navigateTo('class/allclasses');
      //     },
      //   ),
      //   'class/alltables': AllTables(
      //     navigateBack: () {
      //       navigateTo('class/allclasses');
      //     },
      //   ),

      //   'staff/addstaff': const AddStaff(),
      //   'student/attendance': const ExamSetupScreen(),
      //   'staff/createtimetable': const Edit5(),

      //   ///examssss
      //   'exams/allexams': ExaminationOverviewScreenTwo(
      //     navigateTo: () {
      //       navigateTo('exams/addexam');
      //     },
      //   ),
      //   // 'exams/overview': const ExaminationOverviewPage(),
      //   'exams/examschedule': const ExamSchedule(),
      //   'exams/records': const ExamRecordsScreen(),
      //   'exams/addexam': CreateNewExamScreen(
      //     navigateBack: () {
      //       navigateTo('exams/allexams');
      //     },
      //   ),

      //   ////admissions
      //   'admissions/alladmissions': const AdmissionsOverviewPage(),

      //   ///staff
      //   'staff/assignteacher': const AssignTeacher(),

      //   ////promotions
      //   'promotions/managepromotion': StudentPromotionManager(),

      //   ////accounts
      //   'accounts/income': const FinancialOverviewScreen(),
      //   'accounts/expenditure': ExpenditureScreen(),
      //   'accounts/expendituremanager': ExpenditureManger(),

      //   'accounts': Container(
      //     color: Colors.red,
      //     child: const Center(child: Text('Account')),
      //   ),
      //   'student/addstudent/innerroute': InnerRoute(
      //     navigateTo: () {
      //       navigateTo('student/allstudents');
      //     },
      //     onNavigateToInnerRoute:
      //         () => navigateTo('student/addstudent/innerroute/inner'),
      //   ),
      //   'student/addstudent/innerroute/inner': Scaffold(
      //     appBar: AppBar(
      //       backgroundColor: Colors.amber,
      //       title: ElevatedButton(
      //         onPressed: () {
      //           navigateTo('student/addstudent/innerroute');
      //         },
      //         child: Text('back'),
      //       ),
      //     ),
      //     body: Container(
      //       color: Colors.pink,
      //       child: const Center(child: Text('inner inner routeee')),
      //     ),
      //   ),
    };
  }

  int selectedIndex = 0;
  final Map<int, ExpansionTileController> _controllers = {};
  final ExpansionTileController _controller = ExpansionTileController();
  // UniqueKey _tileKey = UniqueKey();
  final List<MenuItem> menuItems = [
    MenuItem('home', Icons.person_add, []),
    MenuItem('Patient Management', Icons.person_add, [
      'Immunization',
      'Add New Patient',
      'Queue Manager',
      'Patient Vitals',
      'Patient Records',
      'Appointments',
    ]),
    MenuItem('Doctors', Icons.attach_money, ['waitlist', 'Surgery Management','Surgery Schedule']),

    MenuItem('Clinical Management', Icons.person_add, [
   
      'Consultations',
      'Prescriptions',
      'Lab',
      'Imaging/Radiology',
    ]),
    MenuItem('Inpatient Management (IPD)', Icons.calendar_today, [
      'Emergency',
      // 'Add Student',
      // 'Single Student',
      // 'Attendance',
      // 'Time Table',
      'Bed Management',
      'Ward Rounds',
      'Discharge',

      // 'Create Time Table',
    ]),
    MenuItem('Labs', Icons.attach_money, ['Test Request', 'dashboard','Lab Result Entry']),
    MenuItem('Shift', Icons.attach_money, ['management']),
    MenuItem('Billing & Payments', Icons.attach_money, [
      'New Billing Entry',
      'Payment Historye',
      'Insurance Claims',
      // 'Overview',
    ]),
    MenuItem('Pharmacy', Icons.attach_money, ['Drugs', 'Refil','que','orders']),

    MenuItem('Reporting & Analytics', Icons.attach_money, [
      'Visit Reports',
      'Revenue Reports',
      'Medicine Usage',
      'Staff Performance',
    ]),
    // MenuItem('Inventory', Icons.attach_money, ['All Inventory', 'Add New']),
    // MenuItem('Library', Icons.attach_money, ['All Books', 'Add Libarian']),
    // MenuItem('Chats', Icons.attach_money, []),
    MenuItem('Nursing', Icons.attach_money, [
      'patient management',
      'Lab & Prescription Notifications',
    ]),
    MenuItem('Staff Management', Icons.attach_money, ['dd/Edit Staff']),
    MenuItem('Settings', Icons.attach_money, ['Manage Promotion']),
    MenuItem('Notifications', Icons.attach_money, ['Manage Promotion']),
    MenuItem('Appointments', Icons.attach_money, [
      'Income',
      'Expenditure',
      'Expenditure Manager',
    ]),
  ];
  bool _isExpanded = false;
  String? selectedSubMenu;
  int tabSelected = -1;
  int subSelected = -1;
  void navigateTo(String route) {
    print(route);
    setState(() {
      currentRoute = route;
      if (!breadcrumbs.contains(route)) {
        breadcrumbs.add(route);
      }
    });
  }

  void navigateTo2(String route) {
    print(route);
    setState(() {
      currentRoute = route;
      if (!breadcrumbs.contains(route)) {
        breadcrumbs.add(route);
      }
    });
  }

  void navigateBack() {
    if (breadcrumbs.length > 1) {
      setState(() {
        breadcrumbs.removeLast();
        currentRoute = breadcrumbs.last;
      });
    }
  }

  Widget _buildDashboardContent() {
    return internalRoutes[currentRoute] ??
        const Center(child: Text('Page not found'));
  }

  Widget _buildBreadcrumbs() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children:
              breadcrumbs.map((route) {
                final label = route.split('/').last;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Chip(
                    label: Text(label),
                    onDeleted:
                        route != currentRoute
                            ? () {
                              setState(() {
                                final index = breadcrumbs.indexOf(route);
                                breadcrumbs = breadcrumbs.sublist(0, index + 1);
                                currentRoute = route;
                              });
                            }
                            : null,
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text(roleRoute)),
      // backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white.withOpacity(.1),
              // const Color.fromARGB(255, 221, 250, 247),
              Colors.white,
            ],
          ),
        ),
        child: Row(
          children: [
            Container(
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
                border: Border.all(
                  width: .2,
                  color: Colors.black.withOpacity(.5),
                ),
                // border: Border(right: BorderSide(width: .2)),
                color: AppColors.secondary,
              ),
              width: 220,
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
                    child: ListView(
                      children:
                          menuItems.mapIndexed((index, menu) {
                            if (menu.subMenuItems.isEmpty) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    tabSelected = -1;
                                  });
                                  print(menu.title);
                                  navigateTo(menu.title);
                                  // navigateTo(roleRoute);
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                    left: 10,
                                    right: 20,
                                    bottom: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color:
                                        tabSelected == -1
                                            ? Color.fromARGB(
                                              115,
                                              226,
                                              239,
                                              248,
                                            ).withOpacity(.4)
                                            : Colors.transparent,
                                  ),
                                  padding: const EdgeInsets.only(
                                    left: 6.0,
                                    top: 8,
                                    bottom: 8,
                                    right: 16,
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        menu.icon,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                      SizedBox(width: 20),
                                      Text(
                                        menu.title,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                            return ExpansionTile(
                              iconColor: Colors.blue,
                              collapsedIconColor: Colors.white,
                              title: Text(
                                menu.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              leading: Icon(
                                menu.icon,
                                color: Colors.white,
                                size: 14,
                              ),
                              children:
                                  menu.subMenuItems.isNotEmpty
                                      ? menu.subMenuItems.mapIndexed((
                                        index,
                                        subItem,
                                      ) {
                                        return InkWell(
                                          onTap: () {
                                            print('hi');

                                            setState(() {
                                              selectedIndex = index;
                                              tabSelected = index;
                                              selectedSubMenu = subItem;
                                            });
                                            navigateTo(
                                              '${menu.title.toLowerCase()}/${subItem.toLowerCase().replaceAll(" ", "")}',
                                            );
                                          },
                                          child: Container(
                                            // padding: const EdgeInsets.symmetric(
                                            //   horizontal: 5,
                                            // ),
                                            alignment: Alignment.centerLeft,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color:
                                                  (tabSelected == index &&
                                                          selectedSubMenu ==
                                                              subItem)
                                                      ? const Color.fromARGB(
                                                        115,
                                                        226,
                                                        239,
                                                        248,
                                                      ).withOpacity(.4)
                                                      : Colors.transparent,
                                            ),
                                            margin: const EdgeInsets.symmetric(
                                              vertical: 5,
                                              horizontal: 20,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                left: 30.0,
                                              ),
                                              child: Text(
                                                subItem,
                                                style: const TextStyle(
                                                  color: Color.fromARGB(
                                                    255,
                                                    255,
                                                    243,
                                                    243,
                                                  ),
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList()
                                      : [
                                        ListTile(
                                          title: const Padding(
                                            padding: EdgeInsets.only(
                                              left: 42.0,
                                            ),
                                            child: Text(
                                              'View',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                            navigateTo(
                                              menu.title.toLowerCase(),
                                            );
                                          },
                                        ),
                                      ],
                            );
                          }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Scaffold(
                appBar: buildAppBar(context),
                body: Column(
                  children: [
                    // Container(
                    //   height: 40,
                    //   color: Colors.transparent,
                    //   padding: const EdgeInsets.only(top: 14.0, bottom: 2),
                    //   alignment: Alignment.centerLeft,
                    //   child: const Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Text(
                    //         'School Admin Dashboard',
                    //         style: TextStyle(
                    //           fontSize: 18,
                    //           fontWeight: FontWeight.bold,
                    //           color: Colors.indigo,
                    //         ),
                    //       ),
                    //       CircleAvatar(
                    //         backgroundColor: Colors.indigoAccent,
                    //         child: Icon(Icons.person, color: Colors.white),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(
                          right: 10,
                          top: 10,
                          bottom: 20,
                        ),
                        color: Colors.transparent,
                        child: _buildDashboardContent(),
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

  Widget _buildCustomScreen(String title, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
      ),
    );
  }
}

// class MenuItem {
//   final String title;
//   final IconData icon;
//   final List<String> subMenu;

//   MenuItem(this.title, this.icon, this.subMenu);
// }

class FeesScreen extends StatelessWidget {
  const FeesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Fees Screen',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}

class Account extends StatelessWidget {
  Account({super.key, this.onNavigate});

  final void Function(String destination)? onNavigate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () => onNavigate?.call('Subaccount'),

            child: const Text('ho to subaccount'),
          ),
          ElevatedButton(
            onPressed: () => onNavigate?.call('AccountSettings'),
            child: const Text('Go to Settings'),
          ),
        ],
      ),
    );
  }
}

class subaccount extends StatelessWidget {
  const subaccount({super.key, this.onBack});

  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Center(
        child: ElevatedButton.icon(
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back),
          label: const Text('Back to Account'),
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, this.onBack});

  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Center(
        child: ElevatedButton.icon(
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back),
          label: const Text('Back to Account'),
        ),
      ),
    );
  }
}

class InnerRoute extends StatelessWidget {
  final VoidCallback? onNavigateToInnerRoute;
  final VoidCallback? navigateTo;
  InnerRoute({super.key, this.onNavigateToInnerRoute, this.navigateTo});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            navigateTo!();
          },
          child: Text('back'),
        ),
        ElevatedButton(
          onPressed: () {
            onNavigateToInnerRoute!();
          },
          child: Text('go inner'),
        ),
        Text('Inner Route Screen', style: TextStyle(fontSize: 24)),
      ],
    );
  }
}
