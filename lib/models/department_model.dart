class DepartmentRef {
  final String id;
  final String name;
  final String? code;

  DepartmentRef({required this.id, required this.name, this.code});

  factory DepartmentRef.fromApi(Map<String, dynamic> json) {
    return DepartmentRef(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      code: json['code']?.toString(),
    );
  }
}

class Department {
  final String id;
  final String name;
  final String code;
  final String? description;
  final String departmentType;
  final bool isActive;
  final bool isDeleted;
  final DepartmentRef? parentDepartment;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Department({
    required this.id,
    required this.name,
    required this.code,
    this.description,
    required this.departmentType,
    required this.isActive,
    required this.isDeleted,
    this.parentDepartment,
    this.createdAt,
    this.updatedAt,
  });

  factory Department.fromApi(Map<String, dynamic> json) {
    String? parseId(Map<String, dynamic> map) {
      return map['_id']?.toString() ?? map['id']?.toString();
    }

    DateTime? parseDate(dynamic value) {
      if (value == null) return null;
      try {
        return DateTime.parse(value.toString());
      } catch (_) {
        return null;
      }
    }

    DepartmentRef? parent;
    final parentJson = json['parentDepartment'];
    if (parentJson is Map<String, dynamic>) {
      parent = DepartmentRef.fromApi(parentJson);
    }

    final id = parseId(json) ?? '';

    return Department(
      id: id,
      name: json['name']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      description: json['description']?.toString(),
      departmentType: json['departmentType']?.toString() ?? '',
      isActive: json['isActive'] as bool? ?? true,
      isDeleted: json['isDeleted'] as bool? ?? false,
      parentDepartment: parent,
      createdAt: parseDate(json['createdAt']),
      updatedAt: parseDate(json['updatedAt']),
    );
  }

  Map<String, dynamic> toApiPayload() {
    return {
      'name': name,
      'code': code,
      if (description != null) 'description': description,
      'departmentType': departmentType,
      'isActive': isActive,
      if (parentDepartment != null) 'parentDepartment': parentDepartment!.id,
    };
  }
}
