import 'package:flutter/material.dart';
import '../models/staff_model.dart';
import '../services/api_service.dart';

class StaffProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  final List<Staff> _staff = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Staff> get staff => List.unmodifiable(_staff);

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? value) {
    _error = value;
    notifyListeners();
  }

  void _setStaff(List<Staff> items) {
    _staff
      ..clear()
      ..addAll(items);
    notifyListeners();
  }

  Future<ApiResponse> fetchStaff({
    int? page,
    int? limit,
    String? search,
  }) async {
    _setLoading(true);
    _setError(null);

    final response = await ApiService.getStaff(
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
          if (data['staff'] is List) {
            jsonList = data['staff'] as List<dynamic>;
          } else if (data['data'] is List) {
            jsonList = data['data'] as List<dynamic>;
          }
        } else if (root is Map<String, dynamic> && root['staff'] is List) {
          jsonList = root['staff'] as List<dynamic>;
        } else if (root is List) {
          jsonList = root;
        }

        if (jsonList != null) {
          final parsed = jsonList
              .whereType<Map<String, dynamic>>()
              .map(Staff.fromApi)
              .toList();
          _setStaff(parsed);
        } else {
          _setStaff([]);
        }
      } catch (e) {
        _setError('Failed to parse staff list: $e');
      }
    } else {
      _setError(response.error ?? 'Failed to load staff');
    }

    return response;
  }

  Future<ApiResponse> createStaff(Map<String, dynamic> staffData) async {
    _setLoading(true);
    _setError(null);

    final response = await ApiService.createStaff(staffData);
    _setLoading(false);

    if (response.success) {
      await fetchStaff();
    } else {
      _setError(response.error ?? 'Failed to create staff member');
    }

    return response;
  }

  Future<ApiResponse> updateStaff(
    String staffId,
    Map<String, dynamic> staffData,
  ) async {
    _setLoading(true);
    _setError(null);

    final response = await ApiService.updateStaff(staffId, staffData);
    _setLoading(false);

    if (response.success) {
      await fetchStaff();
    } else {
      _setError(response.error ?? 'Failed to update staff member');
    }

    return response;
  }

  Future<ApiResponse> deleteStaff(String staffId) async {
    _setLoading(true);
    _setError(null);

    final response = await ApiService.deleteStaff(staffId);
    _setLoading(false);

    if (response.success) {
      await fetchStaff();
    } else {
      _setError(response.error ?? 'Failed to delete staff member');
    }

    return response;
  }

  Future<ApiResponse> restoreStaff(String staffId) async {
    _setLoading(true);
    _setError(null);

    final response = await ApiService.restoreStaff(staffId);
    _setLoading(false);

    if (response.success) {
      await fetchStaff();
    } else {
      _setError(response.error ?? 'Failed to restore staff member');
    }

    return response;
  }
}


