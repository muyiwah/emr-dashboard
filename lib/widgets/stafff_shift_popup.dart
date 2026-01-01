import 'package:flutter/material.dart';

class AssignStaffPopup extends StatefulWidget {
  @override
  _AssignStaffPopupState createState() => _AssignStaffPopupState();
}

class _AssignStaffPopupState extends State<AssignStaffPopup> {
  List<Doctor> doctors = [
    Doctor(
      name: "Dr. Michael Smith",
      specialty: "Cardiologist",
      department: "Emergency Department",
      isAvailable: true,
      isSelected: true,
      avatar: "assets/doctor1.jpg",
    ),
    Doctor(
      name: "Dr. Sarah Johnson",
      specialty: "Neurologist",
      department: "ICU",
      isAvailable: true,
      isSelected: true,
      avatar: "assets/doctor2.jpg",
    ),
    Doctor(
      name: "Dr. James Wilson",
      specialty: "Orthopedic",
      department: "Surgery",
      isAvailable: false,
      isSelected: false,
      avatar: "assets/doctor3.jpg",
    ),
  ];

  String selectedShiftType = "Morning (7:00 AM - 3:00 PM)";
  String selectedDepartment = "Emergency Department";
  String selectedDate = "01/15/2024";
  String startTime = "07:00 AM";
  String endTime = "03:00 PM";
  String notes = "";

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 1000,
        height: 700,
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Assign Staff to Shift",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Group-select and assign multiple staff to a specific shift",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: Row(
                children: [
                  // Left Panel - Staff Selection
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Alert Banner
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Color(0xFFE3F2FD),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.info, color: Colors.blue, size: 20),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "3 nurses available for Emergency Department today",
                                        style: TextStyle(
                                          color: Colors.blue[700],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        "Avoid assigning John – back-to-back shift detected",
                                        style: TextStyle(
                                          color: Colors.blue[700],
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          SizedBox(height: 24),
                          
                          // Selected Staff Tags
                          Row(
                            children: [
                              Text(
                                "Selected Staff:",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 16),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.blue[600],
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  "2 Doctors",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.green[600],
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  "3 Nurses",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.orange[600],
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  "1 Lab Tech",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          
                          SizedBox(height: 24),
                          
                          // Doctors Section
                          Row(
                            children: [
                              Icon(Icons.medical_services, color: Colors.blue[600], size: 20),
                              SizedBox(width: 8),
                              Text(
                                "Doctors",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                "(8 available)",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Spacer(),
                              Row(
                                children: [
                                  Checkbox(
                                    value: false,
                                    onChanged: (value) {},
                                  ),
                                  Text("Select All"),
                                  SizedBox(width: 8),
                                  Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
                                ],
                              ),
                            ],
                          ),
                          
                          SizedBox(height: 16),
                          
                          // Doctor List
                          ...doctors.map((doctor) => DoctorCard(doctor: doctor)),
                          
                          SizedBox(height: 24),
                          
                          // Nurses Section
                          Row(
                            children: [
                              Icon(Icons.local_hospital, color: Colors.green[600], size: 20),
                              SizedBox(width: 8),
                              Text(
                                "Nurses",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                "(12 available)",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Spacer(),
                              Row(
                                children: [
                                  Checkbox(
                                    value: false,
                                    onChanged: (value) {},
                                  ),
                                  Text("Select All"),
                                  SizedBox(width: 8),
                                  Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Right Panel - Shift Details
                  Container(
                    width: 350,
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Shift Details",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          
                          SizedBox(height: 24),
                          
                          // Shift Type
                          Text(
                            "Shift Type",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: selectedShiftType,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                            items: ["Morning (7:00 AM - 3:00 PM)", "Evening (3:00 PM - 11:00 PM)", "Night (11:00 PM - 7:00 AM)"]
                                .map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                selectedShiftType = newValue!;
                              });
                            },
                          ),
                          
                          SizedBox(height: 20),
                          
                          // Department
                          Text(
                            "Department",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: selectedDepartment,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                            items: ["Emergency Department", "ICU", "Surgery", "Pediatrics"]
                                .map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                selectedDepartment = newValue!;
                              });
                            },
                          ),
                          
                          SizedBox(height: 20),
                          
                          // Date
                          Text(
                            "Date",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            initialValue: selectedDate,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              suffixIcon: Icon(Icons.calendar_today, size: 18),
                            ),
                          ),
                          
                          SizedBox(height: 20),
                          
                          // Time Row
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Start Time",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    TextFormField(
                                      initialValue: startTime,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                        suffixIcon: Icon(Icons.access_time, size: 18),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "End Time",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    TextFormField(
                                      initialValue: endTime,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                        suffixIcon: Icon(Icons.access_time, size: 18),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          
                          SizedBox(height: 20),
                          
                          // Notes
                          Text(
                            "Notes (Optional)",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            maxLines: 3,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: EdgeInsets.all(12),
                              hintText: "Add any special instructions or notes...",
                              hintStyle: TextStyle(color: Colors.grey[500]),
                            ),
                          ),
                          
                          Spacer(),
                          
                          // Action Buttons
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => Navigator.pop(context),
                                  style: OutlinedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text("Cancel"),
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Handle assign shift logic
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue[600],
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    "Assign Shift",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
}

class DoctorCard extends StatelessWidget {
  final Doctor doctor;

  const DoctorCard({Key? key, required this.doctor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Checkbox(
            value: doctor.isSelected,
            onChanged: doctor.isAvailable ? (value) {} : null,
          ),
          SizedBox(width: 12),
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.blue[100],
            child: Text(
              doctor.name.split(' ').map((n) => n[0]).join(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  "${doctor.specialty} • ${doctor.department}",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: doctor.isAvailable ? Colors.green[100] : Colors.red[100],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              doctor.isAvailable ? "Available" : "Already Assigned",
              style: TextStyle(
                color: doctor.isAvailable ? Colors.green[700] : Colors.red[700],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Doctor {
  final String name;
  final String specialty;
  final String department;
  final bool isAvailable;
  final bool isSelected;
  final String avatar;

  Doctor({
    required this.name,
    required this.specialty,
    required this.department,
    required this.isAvailable,
    required this.isSelected,
    required this.avatar,
  });
}