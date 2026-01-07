class Staff {
  final String id;
  final String firstName;
  final String lastName;
  final String? email;
  final String? phone;
  final String? department;
  final dynamic role; // Keep dynamic to match current API (can be map or id)
  final bool isActive;
  final DateTime? dateOfBirth;
  final DateTime? hireDate;

  Staff({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.email,
    this.phone,
    this.department,
    this.role,
    required this.isActive,
    this.dateOfBirth,
    this.hireDate,
  });

  factory Staff.fromApi(Map<String, dynamic> json) {
    String parseId(Map<String, dynamic> map) {
      return map['_id']?.toString() ?? map['id']?.toString() ?? '';
    }

    DateTime? parseDate(dynamic value) {
      if (value == null) return null;
      try {
        return DateTime.parse(value.toString());
      } catch (_) {
        return null;
      }
    }

    return Staff(
      id: parseId(json),
      firstName: json['firstName']?.toString() ?? '',
      lastName: json['lastName']?.toString() ?? '',
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      department: json['department']?.toString(),
      role: json['role'],
      isActive: json['isActive'] as bool? ?? true,
      dateOfBirth: parseDate(json['dateOfBirth']),
      hireDate: parseDate(json['hireDate']),
    );
  }

  Map<String, dynamic> toApiPayload() {
    // Note: the full staff payload is already built in the form screen;
    // this helper is here for future use if needed.
    return {
      'firstName': firstName,
      'lastName': lastName,
      if (dateOfBirth != null) 'dateOfBirth': dateOfBirth!.toIso8601String(),
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (department != null) 'department': department,
      'isActive': isActive,
    };
  }
}
