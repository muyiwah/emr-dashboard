import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;

/// Centralized API service for all API endpoints
/// All API calls should go through this service
class ApiService {
  // Base URL configuration
  // For different platforms:
  // - macOS/iOS: Use 'localhost' or your machine's IP (e.g., '192.168.1.172')
  // - Android Emulator: Use '10.0.2.2' instead of 'localhost'
  // - Physical Device: Use your machine's IP address on the same network
  static String get baseUrl {
    // You can override this based on your environment
    if (kDebugMode) {
      // Web: do NOT use dart:io Platform.*
      if (kIsWeb) {
        // Adjust this to your backend host/port when running Flutter Web
        return 'http://192.168.1.172:3000';
      }
      // For Android emulator, use 10.0.2.2
      if (Platform.isAndroid) {
        return 'http://10.0.2.2:3000';
      }
      // For iOS Simulator or macOS, localhost should work
      // But if it doesn't, use your machine's IP address
      return 'http://192.168.1.172:3000';
      // Alternative: return 'http://192.168.1.172:3000';
    }
    // Production URL
    return 'http://192.168.1.198:3000';
  }

  // API Endpoints
  static const String patientsEndpoint = '/api/patients';
  static const String rolesEndpoint = '/api/roles';
  static const String staffEndpoint = '/api/staff';

  // Headers
  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    // TODO: Add authentication token if needed
    // 'Authorization': 'Bearer $token',
  };

  /// Generic GET request
  static Future<ApiResponse> get(String endpoint) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      if (kDebugMode) {
        print('API Request: GET $url');
      }

      final response = await http
          .get(url, headers: _headers)
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw Exception(
                'Request timeout: Server did not respond in time',
              );
            },
          );

      if (kDebugMode) {
        print('API Response: ${response.statusCode}');
      }

      return ApiResponse(
        success: response.statusCode >= 200 && response.statusCode < 300,
        statusCode: response.statusCode,
        data: response.body.isNotEmpty ? jsonDecode(response.body) : null,
        error: response.statusCode >= 400 ? response.body : null,
      );
    } on SocketException catch (e) {
      final errorMessage = _getErrorMessage(e);
      if (kDebugMode) {
        print('SocketException: $e');
      }
      return ApiResponse(success: false, statusCode: 0, error: errorMessage);
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      return ApiResponse(
        success: false,
        statusCode: 0,
        error: 'Network error: ${e.toString()}',
      );
    }
  }

  /// Generic POST request
  static Future<ApiResponse> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      if (kDebugMode) {
        print('API Request: POST $url');
        print('Request Body: ${jsonEncode(body)}');
      }

      final response = await http
          .post(url, headers: _headers, body: jsonEncode(body))
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw Exception(
                'Request timeout: Server did not respond in time',
              );
            },
          );

      if (kDebugMode) {
        print('API Response: ${response.statusCode}');
        print('Response Body: ${response.body}');
      }

      return ApiResponse(
        success: response.statusCode >= 200 && response.statusCode < 300,
        statusCode: response.statusCode,
        data: response.body.isNotEmpty ? jsonDecode(response.body) : null,
        error: response.statusCode >= 400 ? response.body : null,
      );
    } on SocketException catch (e) {
      final errorMessage = _getErrorMessage(e);
      if (kDebugMode) {
        print('SocketException: $e');
        print('Error Message: $errorMessage');
      }
      return ApiResponse(success: false, statusCode: 0, error: errorMessage);
    } on HttpException catch (e) {
      if (kDebugMode) {
        print('HttpException: $e');
      }
      return ApiResponse(
        success: false,
        statusCode: 0,
        error: 'HTTP error: ${e.message}',
      );
    } on FormatException catch (e) {
      if (kDebugMode) {
        print('FormatException: $e');
      }
      return ApiResponse(
        success: false,
        statusCode: 0,
        error: 'Invalid response format: ${e.message}',
      );
    } catch (e) {
      if (kDebugMode) {
        print('Unexpected error: $e');
      }
      return ApiResponse(
        success: false,
        statusCode: 0,
        error: 'Network error: ${e.toString()}',
      );
    }
  }

  /// Get user-friendly error message from SocketException
  static String _getErrorMessage(SocketException e) {
    final message = e.message.toLowerCase();
    final osError = e.osError;

    if (osError != null) {
      // Check for specific error codes
      if (osError.errorCode == 1) {
        // Operation not permitted - usually network permissions on macOS
        return 'Network permission denied (Error Code: 1). Please try:\n\n'
            '1. **Rebuild the app completely:**\n'
            '   flutter clean\n'
            '   flutter pub get\n'
            '   flutter run\n\n'
            '2. **Check macOS Firewall:**\n'
            '   System Settings > Network > Firewall\n'
            '   Make sure it\'s not blocking the app\n\n'
            '3. **Grant network permissions:**\n'
            '   System Settings > Privacy & Security > Network Access\n'
            '   Look for your app and ensure it has network access\n\n'
            '4. **Verify server is running:**\n'
            '   Test with: curl $baseUrl/api/patients\n\n'
            '5. **If still failing, temporarily disable sandbox for testing:**\n'
            '   In DebugProfile.entitlements, set:\n'
            '   com.apple.security.app-sandbox to false\n'
            '   (Only for development/testing)';
      } else if (osError.errorCode == 61) {
        // Connection refused - server not running
        return 'Connection refused. Please ensure:\n'
            '1. The backend server is running on port 3000\n'
            '2. The server is accessible at $baseUrl';
      } else if (osError.errorCode == 64) {
        // Host is down
        return 'Host is down. Please check if the server is running.';
      }
    }

    if (message.contains('operation not permitted')) {
      return 'Network permission denied. Please check system network permissions.';
    } else if (message.contains('connection refused')) {
      return 'Connection refused. Is the backend server running on port 3000?';
    } else if (message.contains('connection timed out')) {
      return 'Connection timed out. Please check your network connection.';
    } else if (message.contains('no route to host')) {
      return 'No route to host. Please check the server address: $baseUrl';
    }

    return 'Network error: ${e.message}\n'
        'Please ensure:\n'
        '1. The backend server is running\n'
        '2. The server URL is correct: $baseUrl\n'
        '3. Network permissions are granted';
  }

  /// Generic PUT request
  static Future<ApiResponse> put(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final response = await http
          .put(url, headers: _headers, body: jsonEncode(body))
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw Exception(
                'Request timeout: Server did not respond in time',
              );
            },
          );

      return ApiResponse(
        success: response.statusCode >= 200 && response.statusCode < 300,
        statusCode: response.statusCode,
        data: response.body.isNotEmpty ? jsonDecode(response.body) : null,
        error: response.statusCode >= 400 ? response.body : null,
      );
    } on SocketException catch (e) {
      return ApiResponse(
        success: false,
        statusCode: 0,
        error: _getErrorMessage(e),
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        statusCode: 0,
        error: 'Network error: ${e.toString()}',
      );
    }
  }

  /// Generic DELETE request
  static Future<ApiResponse> delete(String endpoint) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final response = await http
          .delete(url, headers: _headers)
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw Exception(
                'Request timeout: Server did not respond in time',
              );
            },
          );

      return ApiResponse(
        success: response.statusCode >= 200 && response.statusCode < 300,
        statusCode: response.statusCode,
        data: response.body.isNotEmpty ? jsonDecode(response.body) : null,
        error: response.statusCode >= 400 ? response.body : null,
      );
    } on SocketException catch (e) {
      return ApiResponse(
        success: false,
        statusCode: 0,
        error: _getErrorMessage(e),
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        statusCode: 0,
        error: 'Network error: ${e.toString()}',
      );
    }
  }

  // ========== Patient API Methods ==========

  /// Register/Create a new patient
  static Future<ApiResponse> createPatient(
    Map<String, dynamic> patientData,
  ) async {
    return post(patientsEndpoint, patientData);
  }

  /// Get all patients
  static Future<ApiResponse> getPatients() async {
    return get(patientsEndpoint);
  }

  /// Get a specific patient by ID
  static Future<ApiResponse> getPatient(String patientId) async {
    return get('$patientsEndpoint/$patientId');
  }

  /// Update a patient
  static Future<ApiResponse> updatePatient(
    String patientId,
    Map<String, dynamic> patientData,
  ) async {
    return put('$patientsEndpoint/$patientId', patientData);
  }

  /// Delete a patient
  static Future<ApiResponse> deletePatient(String patientId) async {
    return delete('$patientsEndpoint/$patientId');
  }

  // ========== Role API Methods ==========

  /// Create a new role
  static Future<ApiResponse> createRole(Map<String, dynamic> roleData) async {
    return post(rolesEndpoint, roleData);
  }

  /// Get all roles
  static Future<ApiResponse> getRoles({
    int? page,
    int? limit,
    String? search,
  }) async {
    String endpoint = rolesEndpoint;
    final queryParams = <String>[];
    if (page != null) queryParams.add('page=$page');
    if (limit != null) queryParams.add('limit=$limit');
    if (search != null && search.isNotEmpty) {
      queryParams.add('search=$search');
    }
    if (queryParams.isNotEmpty) {
      endpoint += '?${queryParams.join('&')}';
    }
    return get(endpoint);
  }

  /// Get role by ID
  static Future<ApiResponse> getRole(String roleId) async {
    return get('$rolesEndpoint/$roleId');
  }

  /// Get role by code
  static Future<ApiResponse> getRoleByCode(String code) async {
    return get('$rolesEndpoint/code/$code');
  }

  /// Search roles
  static Future<ApiResponse> searchRoles(String query) async {
    return get('$rolesEndpoint/search?q=$query');
  }

  /// Update a role
  static Future<ApiResponse> updateRole(
    String roleId,
    Map<String, dynamic> roleData,
  ) async {
    return put('$rolesEndpoint/$roleId', roleData);
  }

  /// Delete a role (soft delete)
  static Future<ApiResponse> deleteRole(String roleId) async {
    return delete('$rolesEndpoint/$roleId');
  }

  /// Restore a deleted role
  static Future<ApiResponse> restoreRole(String roleId) async {
    return post('$rolesEndpoint/$roleId/restore', {});
  }

  // ========== Staff API Methods ==========

  /// Create a new staff member
  static Future<ApiResponse> createStaff(Map<String, dynamic> staffData) async {
    return post(staffEndpoint, staffData);
  }

  /// Get all staff members
  static Future<ApiResponse> getStaff({
    int? page,
    int? limit,
    String? search,
  }) async {
    String endpoint = staffEndpoint;
    final queryParams = <String>[];
    if (page != null) queryParams.add('page=$page');
    if (limit != null) queryParams.add('limit=$limit');
    if (search != null && search.isNotEmpty) {
      queryParams.add('search=$search');
    }
    if (queryParams.isNotEmpty) {
      endpoint += '?${queryParams.join('&')}';
    }
    return get(endpoint);
  }

  /// Get staff member by ID
  static Future<ApiResponse> getStaffMember(String staffId) async {
    return get('$staffEndpoint/$staffId');
  }

  /// Get staff by employee ID
  static Future<ApiResponse> getStaffByEmployeeId(String employeeId) async {
    return get('$staffEndpoint/employee/$employeeId');
  }

  /// Search staff
  static Future<ApiResponse> searchStaff(String query) async {
    return get('$staffEndpoint/search?q=$query');
  }

  /// Get staff statistics
  static Future<ApiResponse> getStaffStatistics() async {
    return get('$staffEndpoint/statistics');
  }

  /// Update a staff member
  static Future<ApiResponse> updateStaff(
    String staffId,
    Map<String, dynamic> staffData,
  ) async {
    return put('$staffEndpoint/$staffId', staffData);
  }

  /// Delete a staff member (soft delete)
  static Future<ApiResponse> deleteStaff(String staffId) async {
    return delete('$staffEndpoint/$staffId');
  }

  /// Restore a deleted staff member
  static Future<ApiResponse> restoreStaff(String staffId) async {
    return post('$staffEndpoint/$staffId/restore', {});
  }

  // ========== Department API Methods ==========
  static const String departmentEndpoint = '/api/departments';

  /// Get all departments
  static Future<ApiResponse> getDepartments({
    int? page,
    int? limit,
    String? search,
  }) async {
    String endpoint = departmentEndpoint;
    final queryParams = <String>[];
    if (page != null) queryParams.add('page=$page');
    if (limit != null) queryParams.add('limit=$limit');
    if (search != null && search.isNotEmpty) {
      queryParams.add('search=$search');
    }
    if (queryParams.isNotEmpty) {
      endpoint += '?${queryParams.join('&')}';
    }
    return get(endpoint);
  }

  /// Get root departments (departments with no parent)
  static Future<ApiResponse> getRootDepartments() async {
    return get('$departmentEndpoint/root');
  }

  /// Search departments
  static Future<ApiResponse> searchDepartments(String query) async {
    return get('$departmentEndpoint/search?q=$query');
  }

  /// Get department by ID
  static Future<ApiResponse> getDepartment(String departmentId) async {
    return get('$departmentEndpoint/$departmentId');
  }

  /// Get subdepartments of a department
  static Future<ApiResponse> getSubdepartments(String departmentId) async {
    return get('$departmentEndpoint/$departmentId/subdepartments');
  }

  /// Create a new department
  static Future<ApiResponse> createDepartment(
    Map<String, dynamic> departmentData,
  ) async {
    return post(departmentEndpoint, departmentData);
  }

  /// Update a department
  static Future<ApiResponse> updateDepartment(
    String departmentId,
    Map<String, dynamic> departmentData,
  ) async {
    return put('$departmentEndpoint/$departmentId', departmentData);
  }

  /// Delete a department (soft delete)
  static Future<ApiResponse> deleteDepartment(String departmentId) async {
    return delete('$departmentEndpoint/$departmentId');
  }

  /// Restore a deleted department
  static Future<ApiResponse> restoreDepartment(String departmentId) async {
    return post('$departmentEndpoint/$departmentId/restore', {});
  }
}

/// Standardized API response model
class ApiResponse {
  final bool success;
  final int statusCode;
  final dynamic data;
  final String? error;

  ApiResponse({
    required this.success,
    required this.statusCode,
    this.data,
    this.error,
  });

  @override
  String toString() {
    return 'ApiResponse(success: $success, statusCode: $statusCode, data: $data, error: $error)';
  }
}
