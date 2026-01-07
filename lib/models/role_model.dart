class RolePermission {
  final String resource;
  final List<String> actions;

  RolePermission({
    required this.resource,
    required this.actions,
  });

  factory RolePermission.fromApi(Map<String, dynamic> json) {
    return RolePermission(
      resource: json['resource']?.toString() ?? '',
      actions: (json['actions'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toApi() {
    return {
      'resource': resource,
      'actions': actions,
    };
  }
}

class Role {
  final String id;
  final String name;
  final String code;
  final String? description;
  final String? department;
  final bool isActive;
  final List<RolePermission> permissions;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Role({
    required this.id,
    required this.name,
    required this.code,
    this.description,
    this.department,
    required this.isActive,
    required this.permissions,
    this.createdAt,
    this.updatedAt,
  });

  factory Role.fromApi(Map<String, dynamic> json) {
    final id = json['_id']?.toString() ?? json['id']?.toString() ?? '';

    // Department may be a string or an object with name/code
    String? department;
    final dep = json['department'];
    if (dep is String) {
      department = dep;
    } else if (dep is Map) {
      department = dep['name']?.toString() ?? dep['code']?.toString();
    }

    DateTime? parseDate(dynamic value) {
      if (value == null) return null;
      try {
        return DateTime.parse(value.toString());
      } catch (_) {
        return null;
      }
    }

    return Role(
      id: id,
      name: json['name']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      description: json['description']?.toString(),
      department: department,
      isActive: json['isActive'] as bool? ?? true,
      permissions: (json['permissions'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(RolePermission.fromApi)
          .toList(),
      createdAt: parseDate(json['createdAt']),
      updatedAt: parseDate(json['updatedAt']),
    );
  }

  Map<String, dynamic> toApiPayload() {
    return {
      'name': name,
      'code': code,
      if (description != null) 'description': description,
      if (department != null) 'department': department,
      'isActive': isActive,
      'permissions': permissions.map((p) => p.toApi()).toList(),
    };
  }
}


