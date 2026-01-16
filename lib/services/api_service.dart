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
      // return 'http://192.168.1.198:3000';
      return 'http://192.168.1.124:3000';
      // Alternative: return 'http://192.168.1.172:3000';
    }
    // Production URL
    return 'http://192.168.1.124:3000';
  }

  // API Endpoints
  static const String patientsEndpoint = '/api/patients';
  static const String rolesEndpoint = '/api/roles';
  static const String staffEndpoint = '/api/staff';
  static const String encounterNotesEndpoint = '/api/encounter-notes';
  static const String labTestRequestsEndpoint = '/api/v1/lab-test-requests';

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

  /// Generic PATCH request
  static Future<ApiResponse> patch(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      if (kDebugMode) {
        print('API Request: PATCH $url');
        print('Request Body: ${jsonEncode(body)}');
      }

      final response = await http
          .patch(url, headers: _headers, body: jsonEncode(body))
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
  /// [includeVitals] if true, includes vitals history in the response
  static Future<ApiResponse> getPatient(
    String patientId, {
    bool includeVitals = false,
  }) async {
    String endpoint = '$patientsEndpoint/$patientId';
    if (includeVitals) {
      endpoint += '?includeVitals=true';
    }
    return get(endpoint);
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

  /// Get patient vitals history
  /// [page] - Page number (default: 1)
  /// [limit] - Number of records per page (default: 20)
  /// [startDate] - Optional start date filter (ISO format)
  /// [endDate] - Optional end date filter (ISO format)
  static Future<ApiResponse> getPatientVitalsHistory(
    String patientId, {
    int page = 1,
    int limit = 20,
    String? startDate,
    String? endDate,
  }) async {
    String endpoint = '$patientsEndpoint/$patientId/vitals/history';
    final queryParams = <String>[];
    queryParams.add('page=$page');
    queryParams.add('limit=$limit');
    if (startDate != null) queryParams.add('startDate=$startDate');
    if (endDate != null) queryParams.add('endDate=$endDate');

    if (queryParams.isNotEmpty) {
      endpoint += '?${queryParams.join('&')}';
    }

    return get(endpoint);
  }

  /// Create a clinical note for a patient
  static Future<ApiResponse> createClinicalNote(
    String patientId,
    Map<String, dynamic> noteData,
  ) async {
    return post('$patientsEndpoint/$patientId/clinical-notes', noteData);
  }

  /// Get all clinical notes for a patient
  static Future<ApiResponse> getClinicalNotes(
    String patientId, {
    int page = 1,
    int limit = 20,
    String? noteType,
    String? status,
    String? sortBy,
    String? sortOrder,
  }) async {
    String endpoint = '$patientsEndpoint/$patientId/clinical-notes';
    final queryParams = <String>[];
    queryParams.add('page=$page');
    queryParams.add('limit=$limit');
    if (noteType != null) queryParams.add('noteType=$noteType');
    if (status != null) queryParams.add('status=$status');
    if (sortBy != null) queryParams.add('sortBy=$sortBy');
    if (sortOrder != null) queryParams.add('sortOrder=$sortOrder');

    if (queryParams.isNotEmpty) {
      endpoint += '?${queryParams.join('&')}';
    }

    return get(endpoint);
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

  // ========== Family History API Methods ==========

  /// Get all family history records for a patient
  /// [patientId] - The patient ID
  /// [highRiskOnly] - Filter to only high-risk conditions (default: false)
  /// [sortBy] - Sort field: "createdAt", "condition", "relation" (default: "createdAt")
  /// [sortOrder] - Sort order: "asc" or "desc" (default: "desc")
  static Future<ApiResponse> getFamilyHistory(
    String patientId, {
    bool highRiskOnly = false,
    String sortBy = 'createdAt',
    String sortOrder = 'desc',
  }) async {
    String endpoint = '$patientsEndpoint/$patientId/family-history';
    final queryParams = <String>[];
    if (highRiskOnly) queryParams.add('highRiskOnly=true');
    queryParams.add('sortBy=$sortBy');
    queryParams.add('sortOrder=$sortOrder');

    if (queryParams.isNotEmpty) {
      endpoint += '?${queryParams.join('&')}';
    }

    return get(endpoint);
  }

  /// Get a single family history record
  static Future<ApiResponse> getFamilyHistoryRecord(
    String patientId,
    String familyHistoryId,
  ) async {
    return get('$patientsEndpoint/$patientId/family-history/$familyHistoryId');
  }

  /// Create a new family history record
  static Future<ApiResponse> createFamilyHistory(
    String patientId,
    Map<String, dynamic> familyHistoryData,
  ) async {
    return post(
      '$patientsEndpoint/$patientId/family-history',
      familyHistoryData,
    );
  }

  /// Update a family history record
  static Future<ApiResponse> updateFamilyHistory(
    String patientId,
    String familyHistoryId,
    Map<String, dynamic> familyHistoryData,
  ) async {
    return put(
      '$patientsEndpoint/$patientId/family-history/$familyHistoryId',
      familyHistoryData,
    );
  }

  /// Delete a family history record
  /// [hardDelete] - If true, permanently deletes. If false, soft delete (default: false)
  static Future<ApiResponse> deleteFamilyHistory(
    String patientId,
    String familyHistoryId, {
    bool hardDelete = false,
  }) async {
    String endpoint =
        '$patientsEndpoint/$patientId/family-history/$familyHistoryId';
    if (hardDelete) {
      endpoint += '?hardDelete=true';
    }
    return delete(endpoint);
  }

  /// Bulk create family history records
  static Future<ApiResponse> bulkCreateFamilyHistory(
    String patientId,
    List<Map<String, dynamic>> records,
  ) async {
    return post('$patientsEndpoint/$patientId/family-history/bulk', {
      'records': records,
    });
  }

  // ========== Social History API Methods ==========

  /// Get social history for a patient
  static Future<ApiResponse> getSocialHistory(String patientId) async {
    return get('$patientsEndpoint/$patientId/social-history');
  }

  /// Create social history record
  static Future<ApiResponse> createSocialHistory(
    String patientId,
    Map<String, dynamic> socialHistoryData,
  ) async {
    return post(
      '$patientsEndpoint/$patientId/social-history',
      socialHistoryData,
    );
  }

  /// Update social history record (upsert - creates if doesn't exist)
  static Future<ApiResponse> updateSocialHistory(
    String patientId,
    Map<String, dynamic> socialHistoryData,
  ) async {
    return put(
      '$patientsEndpoint/$patientId/social-history',
      socialHistoryData,
    );
  }

  /// Delete social history record
  /// [hardDelete] - If true, permanently deletes. If false, soft delete (default: false)
  static Future<ApiResponse> deleteSocialHistory(
    String patientId, {
    bool hardDelete = false,
  }) async {
    String endpoint = '$patientsEndpoint/$patientId/social-history';
    if (hardDelete) {
      endpoint += '?hardDelete=true';
    }
    return delete(endpoint);
  }

  // ============================================================
  // ENCOUNTER NOTES API
  // ============================================================

  /// Create a new encounter note (draft)
  static Future<ApiResponse> createEncounterNote(
    Map<String, dynamic> noteData,
  ) async {
    return post(encounterNotesEndpoint, noteData);
  }

  /// Update an existing encounter note (draft only)
  static Future<ApiResponse> updateEncounterNote(
    String noteId,
    Map<String, dynamic> noteData,
  ) async {
    return put('$encounterNotesEndpoint/$noteId', noteData);
  }

  /// Get a single encounter note by ID
  static Future<ApiResponse> getEncounterNote(String noteId) async {
    return get('$encounterNotesEndpoint/$noteId');
  }

  /// Get all encounter notes with optional filters
  static Future<ApiResponse> getEncounterNotes({
    String? patientId,
    String? nurseId,
    String? doctorId,
    String? status,
    String? encounterType,
    String? dateFrom,
    String? dateTo,
    int page = 1,
    int limit = 20,
    String sortBy = 'created_at',
    String sortOrder = 'desc',
  }) async {
    final queryParams = <String, String>{};
    if (patientId != null) queryParams['patient_id'] = patientId;
    if (nurseId != null) queryParams['nurse_id'] = nurseId;
    if (doctorId != null) queryParams['doctor_id'] = doctorId;
    if (status != null) queryParams['status'] = status;
    if (encounterType != null) queryParams['encounter_type'] = encounterType;
    if (dateFrom != null) queryParams['date_from'] = dateFrom;
    if (dateTo != null) queryParams['date_to'] = dateTo;
    queryParams['page'] = page.toString();
    queryParams['limit'] = limit.toString();
    queryParams['sort_by'] = sortBy;
    queryParams['sort_order'] = sortOrder;

    final queryString = queryParams.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');

    return get('$encounterNotesEndpoint?$queryString');
  }

  /// Get encounter notes for a specific patient
  static Future<ApiResponse> getEncounterNotesByPatient(
    String patientId, {
    int page = 1,
    int limit = 20,
  }) async {
    return get(
      '$encounterNotesEndpoint/patient/$patientId?page=$page&limit=$limit',
    );
  }

  /// Get pending review notes for doctors
  static Future<ApiResponse> getPendingReviewNotes({
    int page = 1,
    int limit = 20,
  }) async {
    return get(
      '$encounterNotesEndpoint/pending-review?page=$page&limit=$limit',
    );
  }

  /// Submit encounter note for doctor review
  static Future<ApiResponse> submitEncounterNote(
    String noteId, {
    required String nurseSignature,
    bool confirmation = true,
  }) async {
    return post('$encounterNotesEndpoint/$noteId/submit', {
      'nurseSignature': nurseSignature,
      'confirmation': confirmation,
    });
  }

  /// Doctor review/sign encounter note
  static Future<ApiResponse> reviewEncounterNote(
    String noteId, {
    required String action, // 'sign', 'return_for_edits', 'reject'
    String? doctorComments,
    String? doctorSignature,
  }) async {
    final body = <String, dynamic>{'action': action};
    if (doctorComments != null) body['doctorComments'] = doctorComments;
    if (doctorSignature != null) body['doctorSignature'] = doctorSignature;

    return post('$encounterNotesEndpoint/$noteId/review', body);
  }

  /// Create addendum for a locked/signed encounter note
  static Future<ApiResponse> createEncounterNoteAddendum(
    String noteId, {
    required String addendumText,
    required String reasonForAddendum,
    required String signature,
  }) async {
    return post('$encounterNotesEndpoint/$noteId/addendums', {
      'addendumText': addendumText,
      'reasonForAddendum': reasonForAddendum,
      'signature': signature,
    });
  }

  /// Get audit trail for an encounter note
  static Future<ApiResponse> getEncounterNoteAuditTrail(String noteId) async {
    return get('$encounterNotesEndpoint/$noteId/audit-trail');
  }

  /// Delete an encounter note (draft only)
  static Future<ApiResponse> deleteEncounterNote(
    String noteId, {
    String? reason,
  }) async {
    if (reason != null) {
      // Send reason in request body for soft delete
      return post('$encounterNotesEndpoint/$noteId/delete', {'reason': reason});
    }
    return delete('$encounterNotesEndpoint/$noteId');
  }

  /// Save encounter note as draft (alias for create/update)
  static Future<ApiResponse> saveEncounterNoteDraft(
    Map<String, dynamic> noteData, {
    String? existingNoteId,
  }) async {
    if (existingNoteId != null) {
      return updateEncounterNote(existingNoteId, noteData);
    }
    return createEncounterNote(noteData);
  }

  // ==================== Lab Test Requests API ====================

  /// Get today's overview metrics
  static Future<ApiResponse> getLabTestRequestsOverview({String? date}) async {
    final queryParams = date != null ? '?date=$date' : '';
    return get('$labTestRequestsEndpoint/overview/today$queryParams');
  }

  /// Get paginated list of lab test requests
  static Future<ApiResponse> getLabTestRequests({
    int page = 1,
    int limit = 20,
    String? status,
    String? priority,
    String? department,
    String? search,
    String? dateFrom,
    String? dateTo,
    String sortBy = 'created_at',
    String sortOrder = 'desc',
  }) async {
    final queryParams = <String>[];
    queryParams.add('page=$page');
    queryParams.add('limit=$limit');
    if (status != null && status != 'All') {
      queryParams.add('status=$status');
    }
    if (priority != null && priority != 'All') {
      queryParams.add('priority=$priority');
    }
    if (department != null && department != 'All Departments') {
      queryParams.add('department=$department');
    }
    if (search != null && search.isNotEmpty) {
      queryParams.add('search=${Uri.encodeComponent(search)}');
    }
    if (dateFrom != null) {
      queryParams.add('date_from=$dateFrom');
    }
    if (dateTo != null) {
      queryParams.add('date_to=$dateTo');
    }
    queryParams.add('sort_by=$sortBy');
    queryParams.add('sort_order=$sortOrder');

    final queryString =
        queryParams.isNotEmpty ? '?${queryParams.join('&')}' : '';
    return get('$labTestRequestsEndpoint$queryString');
  }

  /// Get lab test request by ID
  static Future<ApiResponse> getLabTestRequestById(String id) async {
    return get('$labTestRequestsEndpoint/$id');
  }

  /// Update lab test request status
  static Future<ApiResponse> updateLabTestRequestStatus(
    String id, {
    required String status,
    String? notes,
    bool? specimenCollected,
    String? specimenCollectedAt,
  }) async {
    final body = <String, dynamic>{'status': status};
    if (notes != null) body['notes'] = notes;
    if (specimenCollected != null)
      body['specimen_collected'] = specimenCollected;
    if (specimenCollectedAt != null)
      body['specimen_collected_at'] = specimenCollectedAt;

    return patch('$labTestRequestsEndpoint/$id/status', body);
  }

  /// Update individual test item status
  /// Endpoint: PATCH /api/v1/lab-test-requests/:requestId/items/:itemId/status
  static Future<ApiResponse> updateTestItemStatus(
    String requestId,
    String testItemId, {
    required String itemStatus,
    String? notes,
    bool? specimenCollected,
    String? specimenCollectedAt,
  }) async {
    final body = <String, dynamic>{'item_status': itemStatus};
    if (notes != null) body['notes'] = notes;
    if (specimenCollected != null)
      body['specimen_collected'] = specimenCollected;
    if (specimenCollectedAt != null)
      body['specimen_collected_at'] = specimenCollectedAt;

    return patch(
      '$labTestRequestsEndpoint/$requestId/items/$testItemId/status',
      body,
    );
  }

  /// Save lab result for a specific test item
  /// Endpoint: POST /api/v1/lab-test-requests/:requestId/items/:itemId/results
  static Future<ApiResponse> saveLabTestResult(
    String requestId,
    String itemId, {
    required String resultStatus,
    required String enteredAt,
    String? enteredBy,
    String? verifiedBy,
    String? verifiedAt,
    String? resultText,
    List<Map<String, dynamic>>? resultEntries,
    String? notes,
    List<Map<String, dynamic>>? attachments,
    String? patientId,
  }) async {
    final body = <String, dynamic>{
      'result_status': resultStatus,
      'entered_at': enteredAt,
    };
    if (enteredBy != null) body['entered_by'] = enteredBy;
    if (verifiedBy != null) body['verified_by'] = verifiedBy;
    if (verifiedAt != null) body['verified_at'] = verifiedAt;
    if (resultText != null) body['result_text'] = resultText;
    if (resultEntries != null && resultEntries.isNotEmpty)
      body['result_entries'] = resultEntries;
    if (notes != null) body['notes'] = notes;
    if (attachments != null && attachments.isNotEmpty)
      body['attachments'] = attachments;
    if (patientId != null) body['patient_id'] = patientId;

    return post(
      '$labTestRequestsEndpoint/$requestId/items/$itemId/results',
      body,
    );
  }

  /// Get count of new/pending lab test requests
  /// Endpoint: GET /api/v1/lab-test-requests/count/pending
  static Future<ApiResponse> getNewLabTestRequestsCount() async {
    return get('$labTestRequestsEndpoint/count/pending');
  }

  /// Get lab test request metrics
  /// Endpoint: GET /api/v1/lab-test-requests/metrics
  /// Query Parameters: period (optional): 'today', 'week', 'month', 'quarter', or 'all'
  static Future<ApiResponse> getLabTestRequestMetrics({
    String period = 'all',
  }) async {
    final queryParams = <String>[];
    queryParams.add('period=$period');
    final queryString =
        queryParams.isNotEmpty ? '?${queryParams.join('&')}' : '';
    return get('$labTestRequestsEndpoint/metrics$queryString');
  }

  /// Get lab result for a specific test item
  /// Endpoint: GET /api/v1/lab-test-requests/:id/items/:itemId/results
  static Future<ApiResponse> getLabResultForItem(
    String requestId,
    String itemId,
  ) async {
    return get('$labTestRequestsEndpoint/$requestId/items/$itemId/results');
  }

  /// Get all lab results for a patient
  /// Endpoint: GET /api/patients/:patientId/lab-results
  static Future<ApiResponse> getPatientLabResults(
    String patientId, {
    int page = 1,
    int limit = 20,
    String? status,
    String? requestId,
    String? itemId,
  }) async {
    final queryParams = <String>[];
    queryParams.add('page=$page');
    queryParams.add('limit=$limit');
    if (status != null && status.isNotEmpty) {
      queryParams.add('status=$status');
    }
    if (requestId != null && requestId.isNotEmpty) {
      queryParams.add('request_id=$requestId');
    }
    if (itemId != null && itemId.isNotEmpty) {
      queryParams.add('item_id=$itemId');
    }

    final queryString =
        queryParams.isNotEmpty ? '?${queryParams.join('&')}' : '';
    return get('$patientsEndpoint/$patientId/lab-results$queryString');
  }

  /// Get available departments
  static Future<ApiResponse> getLabTestRequestDepartments() async {
    return get('$labTestRequestsEndpoint/departments');
  }

  /// Export lab test requests
  static Future<ApiResponse> exportLabTestRequests({
    String format = 'csv',
    String? status,
    String? priority,
    String? department,
    String? search,
    String? dateFrom,
    String? dateTo,
  }) async {
    final queryParams = <String>[];
    queryParams.add('format=$format');
    if (status != null && status != 'All') {
      queryParams.add('status=$status');
    }
    if (priority != null && priority != 'All') {
      queryParams.add('priority=$priority');
    }
    if (department != null && department != 'All Departments') {
      queryParams.add('department=$department');
    }
    if (search != null && search.isNotEmpty) {
      queryParams.add('search=${Uri.encodeComponent(search)}');
    }
    if (dateFrom != null) {
      queryParams.add('date_from=$dateFrom');
    }
    if (dateTo != null) {
      queryParams.add('date_to=$dateTo');
    }

    final queryString =
        queryParams.isNotEmpty ? '?${queryParams.join('&')}' : '';
    return get('$labTestRequestsEndpoint/export$queryString');
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
