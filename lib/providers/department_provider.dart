import 'package:flutter/material.dart';
import '../models/department_model.dart';
import '../services/api_service.dart';

class DepartmentProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  final List<Department> _departments = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Department> get departments => List.unmodifiable(_departments);

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? value) {
    _error = value;
    notifyListeners();
  }

  void _setDepartments(List<Department> items) {
    _departments
      ..clear()
      ..addAll(items);
    notifyListeners();
  }

  /// Fetch all departments
  Future<ApiResponse> fetchDepartments({
    int? page,
    int? limit,
    String? search,
  }) async {
    _setLoading(true);
    _setError(null);

    final response = await ApiService.getDepartments(
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

        List<dynamic>? jsonList;
        if (data is Map<String, dynamic>) {
          if (data['departments'] is List) {
            jsonList = data['departments'] as List<dynamic>;
          } else if (data['data'] is List) {
            jsonList = data['data'] as List<dynamic>;
          }
        } else if (root is Map<String, dynamic> &&
            root['departments'] is List) {
          jsonList = root['departments'] as List<dynamic>;
        } else if (root is List) {
          jsonList = root;
        }

        if (jsonList != null) {
          final parsed = jsonList
              .whereType<Map<String, dynamic>>()
              .map(Department.fromApi)
              .toList();
          _setDepartments(parsed);
        } else {
          _setDepartments([]);
        }
      } catch (e) {
        _setError('Failed to parse departments: $e');
      }
    } else {
      _setError(response.error ?? 'Failed to load departments');
    }

    return response;
  }

  /// Fetch root departments (no parent). Used for parent dropdowns.
  Future<ApiResponse> fetchRootDepartments() async {
    _setLoading(true);
    _setError(null);

    final response = await ApiService.getRootDepartments();

    _setLoading(false);

    if (!response.success) {
      _setError(response.error ?? 'Failed to load root departments');
    }

    return response;
  }

  Future<ApiResponse> createDepartment(
    Map<String, dynamic> departmentData,
  ) async {
    _setLoading(true);
    _setError(null);

    final response = await ApiService.createDepartment(departmentData);
    _setLoading(false);

    if (response.success) {
      await fetchDepartments();
    } else {
      _setError(response.error ?? 'Failed to create department');
    }

    return response;
  }

  Future<ApiResponse> updateDepartment(
    String departmentId,
    Map<String, dynamic> departmentData,
  ) async {
    _setLoading(true);
    _setError(null);

    final response =
        await ApiService.updateDepartment(departmentId, departmentData);
    _setLoading(false);

    if (response.success) {
      await fetchDepartments();
    } else {
      _setError(response.error ?? 'Failed to update department');
    }

    return response;
  }

  Future<ApiResponse> deleteDepartment(String departmentId) async {
    _setLoading(true);
    _setError(null);

    final response = await ApiService.deleteDepartment(departmentId);
    _setLoading(false);

    if (response.success) {
      await fetchDepartments();
    } else {
      _setError(response.error ?? 'Failed to delete department');
    }

    return response;
  }

  Future<ApiResponse> restoreDepartment(String departmentId) async {
    _setLoading(true);
    _setError(null);

    final response = await ApiService.restoreDepartment(departmentId);
    _setLoading(false);

    if (response.success) {
      await fetchDepartments();
    } else {
      _setError(response.error ?? 'Failed to restore department');
    }

    return response;
  }
}


