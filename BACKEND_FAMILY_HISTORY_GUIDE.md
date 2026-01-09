# Backend API Guide: Patient Family History

## Overview
This guide outlines the backend endpoints required to support the Patient Family History feature as implemented in the `MedicalHistoryScreen`. The family history allows tracking medical conditions in a patient's family members, including the relationship and risk assessment.

---

## Data Model

### Family Medical Condition Schema

```json
{
  "id": "string (UUID or ObjectId)",
  "patientId": "string (required)",
  "condition": "string (required)",
  "relation": "string (required)",
  "isHighRisk": "boolean (required)",
  "createdAt": "ISO 8601 datetime",
  "updatedAt": "ISO 8601 datetime",
  "createdBy": "string (staff/provider ID)",
  "notes": "string (optional)"
}
```

### Field Descriptions

- **id**: Unique identifier for the family history record
- **patientId**: Reference to the patient this family history belongs to
- **condition**: Medical condition name (e.g., "Hypertension", "Diabetes Type 2", "Breast Cancer")
- **relation**: Relationship to patient (e.g., "Father", "Mother", "Maternal Aunt", "Paternal Grandfather", "Sibling", etc.)
- **isHighRisk**: Boolean flag indicating if this condition represents a high-risk factor for the patient
- **createdAt**: Timestamp when the record was created
- **updatedAt**: Timestamp when the record was last updated
- **createdBy**: ID of the staff member/provider who created the record
- **notes**: Optional additional notes about the condition

### Suggested Relation Values
- Father
- Mother
- Paternal Grandfather
- Paternal Grandmother
- Maternal Grandfather
- Maternal Grandmother
- Sibling (Brother/Sister)
- Paternal Uncle
- Paternal Aunt
- Maternal Uncle
- Maternal Aunt
- Son
- Daughter
- Other (with notes)

---

## API Endpoints

### Base URL
All endpoints are relative to: `/api/patients/{patientId}/family-history`

---

### 1. Get All Family History Records for a Patient

**Endpoint:** `GET /api/patients/{patientId}/family-history`

**Description:** Retrieves all family medical history records for a specific patient.

**URL Parameters:**
- `patientId` (required): The unique identifier of the patient

**Query Parameters (optional):**
- `includeDeleted` (boolean, default: false): Include soft-deleted records
- `sortBy` (string, default: "createdAt"): Sort field (options: "createdAt", "condition", "relation")
- `sortOrder` (string, default: "desc"): Sort order ("asc" or "desc")
- `highRiskOnly` (boolean, default: false): Filter to only high-risk conditions

**Request Example:**
```http
GET /api/patients/507f1f77bcf86cd799439011/family-history?highRiskOnly=false
```

**Success Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "patientId": "507f1f77bcf86cd799439011",
    "familyHistory": [
      {
        "id": "507f191e810c19729de860ea",
        "patientId": "507f1f77bcf86cd799439011",
        "condition": "Hypertension",
        "relation": "Father",
        "isHighRisk": true,
        "createdAt": "2024-01-15T10:30:00Z",
        "updatedAt": "2024-01-15T10:30:00Z",
        "createdBy": "507f1f77bcf86cd799439012",
        "notes": null
      },
      {
        "id": "507f191e810c19729de860eb",
        "patientId": "507f1f77bcf86cd799439011",
        "condition": "Diabetes Type 2",
        "relation": "Mother",
        "isHighRisk": false,
        "createdAt": "2024-01-15T10:35:00Z",
        "updatedAt": "2024-01-15T10:35:00Z",
        "createdBy": "507f1f77bcf86cd799439012",
        "notes": null
      },
      {
        "id": "507f191e810c19729de860ec",
        "patientId": "507f1f77bcf86cd799439011",
        "condition": "Breast Cancer",
        "relation": "Maternal Aunt",
        "isHighRisk": true,
        "createdAt": "2024-01-15T10:40:00Z",
        "updatedAt": "2024-01-15T10:40:00Z",
        "createdBy": "507f1f77bcf86cd799439012",
        "notes": "Diagnosed at age 45"
      }
    ],
    "summary": {
      "totalConditions": 3,
      "highRiskCount": 2,
      "hasHighRisk": true
    }
  }
}
```

**Error Responses:**
- `404 Not Found`: Patient not found
```json
{
  "success": false,
  "error": "Patient not found",
  "statusCode": 404
}
```

- `500 Internal Server Error`: Server error
```json
{
  "success": false,
  "error": "Internal server error",
  "statusCode": 500
}
```

---

### 2. Get Single Family History Record

**Endpoint:** `GET /api/patients/{patientId}/family-history/{familyHistoryId}`

**Description:** Retrieves a specific family history record by ID.

**URL Parameters:**
- `patientId` (required): The unique identifier of the patient
- `familyHistoryId` (required): The unique identifier of the family history record

**Request Example:**
```http
GET /api/patients/507f1f77bcf86cd799439011/family-history/507f191e810c19729de860ea
```

**Success Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "id": "507f191e810c19729de860ea",
    "patientId": "507f1f77bcf86cd799439011",
    "condition": "Hypertension",
    "relation": "Father",
    "isHighRisk": true,
    "createdAt": "2024-01-15T10:30:00Z",
    "updatedAt": "2024-01-15T10:30:00Z",
    "createdBy": "507f1f77bcf86cd799439012",
    "notes": null
  }
}
```

**Error Responses:**
- `404 Not Found`: Patient or family history record not found
```json
{
  "success": false,
  "error": "Family history record not found",
  "statusCode": 404
}
```

---

### 3. Create Family History Record

**Endpoint:** `POST /api/patients/{patientId}/family-history`

**Description:** Creates a new family medical history record for a patient.

**URL Parameters:**
- `patientId` (required): The unique identifier of the patient

**Request Body:**
```json
{
  "condition": "Hypertension",
  "relation": "Father",
  "isHighRisk": true,
  "notes": "Optional additional notes"
}
```

**Request Body Validation:**
- `condition` (required, string, max 200 chars): Medical condition name
- `relation` (required, string, max 50 chars): Relationship to patient
- `isHighRisk` (required, boolean): High-risk flag
- `notes` (optional, string, max 1000 chars): Additional notes

**Request Example:**
```http
POST /api/patients/507f1f77bcf86cd799439011/family-history
Content-Type: application/json

{
  "condition": "Hypertension",
  "relation": "Father",
  "isHighRisk": true,
  "notes": "Diagnosed at age 55"
}
```

**Success Response (201 Created):**
```json
{
  "success": true,
  "message": "Family history record created successfully",
  "data": {
    "id": "507f191e810c19729de860ea",
    "patientId": "507f1f77bcf86cd799439011",
    "condition": "Hypertension",
    "relation": "Father",
    "isHighRisk": true,
    "createdAt": "2024-01-15T10:30:00Z",
    "updatedAt": "2024-01-15T10:30:00Z",
    "createdBy": "507f1f77bcf86cd799439012",
    "notes": "Diagnosed at age 55"
  }
}
```

**Error Responses:**
- `400 Bad Request`: Validation error
```json
{
  "success": false,
  "error": "Validation failed",
  "errors": {
    "condition": "Condition is required",
    "relation": "Relation is required"
  },
  "statusCode": 400
}
```

- `404 Not Found`: Patient not found
```json
{
  "success": false,
  "error": "Patient not found",
  "statusCode": 404
}
```

- `500 Internal Server Error`: Server error
```json
{
  "success": false,
  "error": "Failed to create family history record",
  "statusCode": 500
}
```

---

### 4. Update Family History Record

**Endpoint:** `PUT /api/patients/{patientId}/family-history/{familyHistoryId}`

**Description:** Updates an existing family history record. All fields are optional in the request body; only provided fields will be updated.

**URL Parameters:**
- `patientId` (required): The unique identifier of the patient
- `familyHistoryId` (required): The unique identifier of the family history record

**Request Body (all fields optional):**
```json
{
  "condition": "Hypertension (Controlled)",
  "relation": "Father",
  "isHighRisk": false,
  "notes": "Updated: Now controlled with medication"
}
```

**Request Example:**
```http
PUT /api/patients/507f1f77bcf86cd799439011/family-history/507f191e810c19729de860ea
Content-Type: application/json

{
  "condition": "Hypertension (Controlled)",
  "isHighRisk": false,
  "notes": "Updated: Now controlled with medication"
}
```

**Success Response (200 OK):**
```json
{
  "success": true,
  "message": "Family history record updated successfully",
  "data": {
    "id": "507f191e810c19729de860ea",
    "patientId": "507f1f77bcf86cd799439011",
    "condition": "Hypertension (Controlled)",
    "relation": "Father",
    "isHighRisk": false,
    "createdAt": "2024-01-15T10:30:00Z",
    "updatedAt": "2024-01-15T11:45:00Z",
    "createdBy": "507f1f77bcf86cd799439012",
    "notes": "Updated: Now controlled with medication"
  }
}
```

**Error Responses:**
- `400 Bad Request`: Validation error
```json
{
  "success": false,
  "error": "Validation failed",
  "errors": {
    "condition": "Condition cannot exceed 200 characters"
  },
  "statusCode": 400
}
```

- `404 Not Found`: Patient or family history record not found
```json
{
  "success": false,
  "error": "Family history record not found",
  "statusCode": 404
}
```

- `500 Internal Server Error`: Server error
```json
{
  "success": false,
  "error": "Failed to update family history record",
  "statusCode": 500
}
```

---

### 5. Delete Family History Record

**Endpoint:** `DELETE /api/patients/{patientId}/family-history/{familyHistoryId}`

**Description:** Deletes a family history record. Recommended to use soft delete (mark as deleted) rather than hard delete for audit purposes.

**URL Parameters:**
- `patientId` (required): The unique identifier of the patient
- `familyHistoryId` (required): The unique identifier of the family history record

**Query Parameters (optional):**
- `hardDelete` (boolean, default: false): If true, permanently deletes the record. If false, performs soft delete.

**Request Example:**
```http
DELETE /api/patients/507f1f77bcf86cd799439011/family-history/507f191e810c19729de860ea?hardDelete=false
```

**Success Response (200 OK):**
```json
{
  "success": true,
  "message": "Family history record deleted successfully",
  "data": {
    "id": "507f191e810c19729de860ea",
    "deletedAt": "2024-01-15T12:00:00Z"
  }
}
```

**Error Responses:**
- `404 Not Found`: Patient or family history record not found
```json
{
  "success": false,
  "error": "Family history record not found",
  "statusCode": 404
}
```

- `500 Internal Server Error`: Server error
```json
{
  "success": false,
  "error": "Failed to delete family history record",
  "statusCode": 500
}
```

---

### 6. Bulk Create Family History Records (Optional)

**Endpoint:** `POST /api/patients/{patientId}/family-history/bulk`

**Description:** Creates multiple family history records in a single request. Useful for initial data entry or importing from external sources.

**URL Parameters:**
- `patientId` (required): The unique identifier of the patient

**Request Body:**
```json
{
  "records": [
    {
      "condition": "Hypertension",
      "relation": "Father",
      "isHighRisk": true,
      "notes": null
    },
    {
      "condition": "Diabetes Type 2",
      "relation": "Mother",
      "isHighRisk": false,
      "notes": null
    },
    {
      "condition": "Breast Cancer",
      "relation": "Maternal Aunt",
      "isHighRisk": true,
      "notes": "Diagnosed at age 45"
    }
  ]
}
```

**Request Example:**
```http
POST /api/patients/507f1f77bcf86cd799439011/family-history/bulk
Content-Type: application/json

{
  "records": [
    {
      "condition": "Hypertension",
      "relation": "Father",
      "isHighRisk": true
    },
    {
      "condition": "Diabetes Type 2",
      "relation": "Mother",
      "isHighRisk": false
    }
  ]
}
```

**Success Response (201 Created):**
```json
{
  "success": true,
  "message": "2 family history records created successfully",
  "data": {
    "created": 2,
    "failed": 0,
    "records": [
      {
        "id": "507f191e810c19729de860ea",
        "patientId": "507f1f77bcf86cd799439011",
        "condition": "Hypertension",
        "relation": "Father",
        "isHighRisk": true,
        "createdAt": "2024-01-15T10:30:00Z",
        "updatedAt": "2024-01-15T10:30:00Z",
        "createdBy": "507f1f77bcf86cd799439012",
        "notes": null
      },
      {
        "id": "507f191e810c19729de860eb",
        "patientId": "507f1f77bcf86cd799439011",
        "condition": "Diabetes Type 2",
        "relation": "Mother",
        "isHighRisk": false,
        "createdAt": "2024-01-15T10:30:00Z",
        "updatedAt": "2024-01-15T10:30:00Z",
        "createdBy": "507f1f77bcf86cd799439012",
        "notes": null
      }
    ]
  }
}
```

**Partial Success Response (207 Multi-Status):**
If some records fail validation:
```json
{
  "success": true,
  "message": "1 of 2 family history records created successfully",
  "data": {
    "created": 1,
    "failed": 1,
    "records": [
      {
        "id": "507f191e810c19729de860ea",
        "patientId": "507f1f77bcf86cd799439011",
        "condition": "Hypertension",
        "relation": "Father",
        "isHighRisk": true,
        "createdAt": "2024-01-15T10:30:00Z",
        "updatedAt": "2024-01-15T10:30:00Z",
        "createdBy": "507f1f77bcf86cd799439012",
        "notes": null
      }
    ],
    "errors": [
      {
        "index": 1,
        "error": "Validation failed",
        "errors": {
          "condition": "Condition is required"
        }
      }
    ]
  }
}
```

---

## Database Schema Recommendations

### MongoDB Example Schema

```javascript
{
  _id: ObjectId,
  patientId: ObjectId, // Reference to patients collection
  condition: String, // Required, max 200 chars
  relation: String, // Required, max 50 chars
  isHighRisk: Boolean, // Required, default: false
  notes: String, // Optional, max 1000 chars
  createdBy: ObjectId, // Reference to staff/users collection
  createdAt: Date, // Auto-generated
  updatedAt: Date, // Auto-updated
  deletedAt: Date, // For soft delete, null if not deleted
  isDeleted: Boolean // For soft delete, default: false
}

// Indexes
db.familyHistory.createIndex({ patientId: 1, isDeleted: 1 });
db.familyHistory.createIndex({ patientId: 1, isHighRisk: 1 });
db.familyHistory.createIndex({ condition: 1 });
```

### SQL Example Schema (PostgreSQL/MySQL)

```sql
CREATE TABLE family_history (
  id VARCHAR(36) PRIMARY KEY,
  patient_id VARCHAR(36) NOT NULL,
  condition VARCHAR(200) NOT NULL,
  relation VARCHAR(50) NOT NULL,
  is_high_risk BOOLEAN NOT NULL DEFAULT FALSE,
  notes TEXT,
  created_by VARCHAR(36),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP NULL,
  is_deleted BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (patient_id) REFERENCES patients(id),
  FOREIGN KEY (created_by) REFERENCES staff(id)
);

-- Indexes
CREATE INDEX idx_family_history_patient ON family_history(patient_id, is_deleted);
CREATE INDEX idx_family_history_high_risk ON family_history(patient_id, is_high_risk);
CREATE INDEX idx_family_history_condition ON family_history(condition);
```

---

## Business Logic & Validation Rules

### Validation Rules

1. **Condition Field:**
   - Required
   - Maximum 200 characters
   - Should not be empty or only whitespace
   - Consider normalizing common condition names (e.g., "HTN" vs "Hypertension")

2. **Relation Field:**
   - Required
   - Maximum 50 characters
   - Should be from a predefined list of valid relations (see suggested values above)
   - Case-insensitive matching recommended

3. **isHighRisk Field:**
   - Required
   - Must be a boolean value
   - Default: false

4. **Notes Field:**
   - Optional
   - Maximum 1000 characters
   - Can contain additional clinical context

5. **Patient Validation:**
   - Patient must exist before creating family history
   - Patient must be active (not deleted/archived)

### Business Rules

1. **Duplicate Prevention:**
   - Consider preventing duplicate entries (same condition + relation for a patient)
   - Or allow duplicates but track them separately with different notes/dates

2. **Audit Trail:**
   - Track who created/updated each record (`createdBy` field)
   - Maintain timestamps for all operations
   - Consider logging all changes for compliance

3. **Soft Delete:**
   - Prefer soft delete over hard delete for audit and recovery purposes
   - Filter out soft-deleted records by default in GET requests

4. **High-Risk Assessment:**
   - The `isHighRisk` flag can be used to trigger alerts or recommendations
   - Consider auto-calculating based on condition type (e.g., certain cancers, cardiovascular diseases)

5. **Data Integrity:**
   - When a patient is deleted, decide on cascade behavior:
     - Option A: Delete all family history (hard delete)
     - Option B: Archive family history (soft delete)
     - Option C: Keep family history but mark patient as deleted

---

## Error Handling

### Standard Error Response Format

All error responses should follow this format:

```json
{
  "success": false,
  "error": "Human-readable error message",
  "statusCode": 400,
  "errors": {
    "fieldName": "Field-specific error message"
  }
}
```

### HTTP Status Codes

- `200 OK`: Successful GET, PUT, DELETE operations
- `201 Created`: Successful POST operations
- `400 Bad Request`: Validation errors, malformed requests
- `401 Unauthorized`: Authentication required
- `403 Forbidden`: Insufficient permissions
- `404 Not Found`: Resource not found
- `409 Conflict`: Duplicate entry or conflict
- `500 Internal Server Error`: Server-side errors
- `503 Service Unavailable`: Service temporarily unavailable

---

## Security Considerations

1. **Authentication:**
   - All endpoints should require authentication
   - Use JWT tokens or session-based authentication
   - Include `Authorization` header in requests

2. **Authorization:**
   - Verify user has permission to access/modify patient data
   - Role-based access control (RBAC):
     - Doctors, Nurses: Full access (CRUD)
     - Receptionists: Read-only access
     - Patients: Read-only access to their own data

3. **Input Validation:**
   - Sanitize all input to prevent injection attacks
   - Validate data types and ranges
   - Enforce maximum field lengths

4. **Rate Limiting:**
   - Implement rate limiting to prevent abuse
   - Consider different limits for different operations

5. **Data Privacy:**
   - Ensure compliance with HIPAA, GDPR, or relevant regulations
   - Log access to sensitive data
   - Encrypt sensitive data at rest and in transit

---

## Integration with Frontend

### Flutter/Dart Integration Example

The frontend should integrate with these endpoints using the existing `ApiService` pattern:

```dart
// Add to ApiService class
static const String familyHistoryEndpoint = '/api/patients';

// Get all family history for a patient
static Future<ApiResponse> getFamilyHistory(String patientId) async {
  return get('$familyHistoryEndpoint/$patientId/family-history');
}

// Create family history record
static Future<ApiResponse> createFamilyHistory(
  String patientId,
  Map<String, dynamic> familyHistoryData,
) async {
  return post(
    '$familyHistoryEndpoint/$patientId/family-history',
    familyHistoryData,
  );
}

// Update family history record
static Future<ApiResponse> updateFamilyHistory(
  String patientId,
  String familyHistoryId,
  Map<String, dynamic> familyHistoryData,
) async {
  return put(
    '$familyHistoryEndpoint/$patientId/family-history/$familyHistoryId',
    familyHistoryData,
  );
}

// Delete family history record
static Future<ApiResponse> deleteFamilyHistory(
  String patientId,
  String familyHistoryId,
) async {
  return delete(
    '$familyHistoryEndpoint/$patientId/family-history/$familyHistoryId',
  );
}
```

---

## Testing Recommendations

### Unit Tests
- Test validation rules for each field
- Test business logic (duplicate prevention, high-risk assessment)
- Test error handling

### Integration Tests
- Test full CRUD operations
- Test bulk operations
- Test filtering and sorting
- Test soft delete functionality

### Test Cases

1. **Create:**
   - Valid record creation
   - Missing required fields
   - Invalid field values (too long, invalid types)
   - Non-existent patient ID

2. **Read:**
   - Get all records for a patient
   - Get single record
   - Filter by high-risk
   - Sort by different fields
   - Non-existent patient/record

3. **Update:**
   - Update all fields
   - Partial update (only some fields)
   - Update non-existent record
   - Validation errors on update

4. **Delete:**
   - Soft delete
   - Hard delete
   - Delete non-existent record
   - Verify soft-deleted records are excluded from GET

---

## Additional Features (Optional Enhancements)

### 1. Condition Suggestions
**Endpoint:** `GET /api/patients/family-history/condition-suggestions?query={searchTerm}`

Provide autocomplete suggestions for common medical conditions.

### 2. Family History Summary/Statistics
**Endpoint:** `GET /api/patients/{patientId}/family-history/summary`

Return aggregated statistics:
- Total conditions
- High-risk count
- Most common conditions
- Risk assessment score

### 3. Export Family History
**Endpoint:** `GET /api/patients/{patientId}/family-history/export?format={pdf|csv|json}`

Export family history in various formats for reports.

### 4. Family History Timeline
**Endpoint:** `GET /api/patients/{patientId}/family-history/timeline`

Return family history ordered by creation date for timeline visualization.

---

## Summary

This guide provides a comprehensive blueprint for implementing backend endpoints for patient family history. The endpoints support:

- ✅ Full CRUD operations (Create, Read, Update, Delete)
- ✅ Bulk operations for efficient data entry
- ✅ Filtering and sorting capabilities
- ✅ Soft delete for audit trails
- ✅ High-risk flagging for clinical decision support
- ✅ Comprehensive validation and error handling
- ✅ Security and authorization considerations

The backend should implement these endpoints following RESTful principles, with proper validation, error handling, and security measures in place.

