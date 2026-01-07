import 'package:flutter/material.dart';
import '../models/role_model.dart';
import '../services/api_service.dart';

class RoleProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  final List<Role> _roles = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Role> get roles => List.unmodifiable(_roles);

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? value) {
    _error = value;
    notifyListeners();
  }

  void _setRoles(List<Role> newRoles) {
    _roles
      ..clear()
      ..addAll(newRoles);
    notifyListeners();
  }

  /// Fetch all roles from the API and update local state.
  Future<ApiResponse> fetchRoles({
    int? page,
    int? limit,
    String? search,
  }) async {
    _setLoading(true);
    _setError(null);

    final response = await ApiService.getRoles(
      page: page,
      limit: limit,
      search: search,
    );

    _setLoading(false);

    if (response.success && response.data != null) {
      try {
        final dynamic root = response.data;
        dynamic data;
        if (root is Map<String, dynamic>) {
          data = root['data'];
        }

        List<dynamic>? rolesJson;
        if (data is Map<String, dynamic>) {
          // Common structure: { data: { roles: [...] } }
          if (data['roles'] is List) {
            rolesJson = data['roles'] as List<dynamic>;
          } else if (data['data'] is List) {
            // Fallback: { data: { data: [...] } }
            rolesJson = data['data'] as List<dynamic>;
          }
        } else if (root is Map<String, dynamic> && root['roles'] is List) {
          rolesJson = root['roles'] as List<dynamic>;
        } else if (root is List) {
          rolesJson = root;
        }

        if (rolesJson != null) {
          final parsed = rolesJson
              .whereType<Map<String, dynamic>>()
              .map(Role.fromApi)
              .toList();
          _setRoles(parsed);
        } else {
          _setRoles([]);
        }
      } catch (e) {
        _setError('Failed to parse roles: $e');
      }
    } else {
      _setError(response.error ?? 'Failed to load roles');
    }

    return response;
  }

  /// Create a new role via API and refresh the list on success.
  Future<ApiResponse> createRole(Map<String, dynamic> roleData) async {
    _setLoading(true);
    _setError(null);

    final response = await ApiService.createRole(roleData);
    _setLoading(false);

    if (response.success) {
      // Refresh roles list so UI stays in sync
      await fetchRoles();
    } else {
      _setError(response.error ?? 'Failed to create role');
    }

    return response;
  }

  /// Update an existing role via API and refresh the list on success.
  Future<ApiResponse> updateRole(
    String roleId,
    Map<String, dynamic> roleData,
  ) async {
    _setLoading(true);
    _setError(null);

    final response = await ApiService.updateRole(roleId, roleData);
    _setLoading(false);

    if (response.success) {
      await fetchRoles();
    } else {
      _setError(response.error ?? 'Failed to update role');
    }

    return response;
  }

  /// Delete a role (soft delete) and refresh the list on success.
  Future<ApiResponse> deleteRole(String roleId) async {
    _setLoading(true);
    _setError(null);

    final response = await ApiService.deleteRole(roleId);
    _setLoading(false);

    if (response.success) {
      await fetchRoles();
    } else {
      _setError(response.error ?? 'Failed to delete role');
    }

    return response;
  }

  /// Restore a deleted role and refresh the list on success.
  Future<ApiResponse> restoreRole(String roleId) async {
    _setLoading(true);
    _setError(null);

    final response = await ApiService.restoreRole(roleId);
    _setLoading(false);

    if (response.success) {
      await fetchRoles();
    } else {
      _setError(response.error ?? 'Failed to restore role');
    }

    return response;
  }
}


