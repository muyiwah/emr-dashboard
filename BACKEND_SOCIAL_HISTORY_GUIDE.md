# Backend API Guide: Patient Social History

## Overview
This guide outlines the backend endpoints required to support the Patient Social History feature as implemented in the `MedicalHistoryScreen`. Social history tracks lifestyle factors, habits, and environmental exposures that may impact a patient's health.

---

## Data Model

### Social History Schema

```json
{
  "id": "string (UUID or ObjectId)",
  "patientId": "string (required)",
  "smokingStatus": "string (required)",
  "packsPerDay": "number (optional, 0 or positive integer)",
  "smokingStartDate": "ISO 8601 datetime (optional)",
  "alcoholFrequency": "string (required)",
  "drinksPerSession": "number (optional, 0 or positive integer)",
  "physicalActivityLevel": "string (required)",
  "dietaryHabits": "string (required)",
  "livingSituation": "string (required)",
  "occupation": "string (optional)",
  "workHazards": "string (optional)",
  "createdAt": "ISO 8601 datetime",
  "updatedAt": "ISO 8601 datetime",
  "createdBy": "string (staff/provider ID)",
  "notes": "string (optional)"
}
```

### Field Descriptions

- **id**: Unique identifier for the social history record
- **patientId**: Reference to the patient this social history belongs to
- **smokingStatus**: Current smoking status (required)
  - Valid values: `"Never Smoker"`, `"Former Smoker"`, `"Current Smoker"`
- **packsPerDay**: Number of packs smoked per day (optional, only relevant if smokingStatus is "Former Smoker" or "Current Smoker")
  - Type: Integer (0 or positive)
  - Default: 0
- **smokingStartDate**: Date when patient started smoking (optional)
  - Type: ISO 8601 datetime
  - Only relevant if smokingStatus is "Former Smoker" or "Current Smoker"
- **alcoholFrequency**: Frequency of alcohol consumption (required)
  - Valid values: `"Never"`, `"Rarely"`, `"Weekly"`, `"Daily"`
- **drinksPerSession**: Average number of drinks per session (optional)
  - Type: Integer (0 or positive)
  - Default: 0
  - Only relevant if alcoholFrequency is not "Never"
- **physicalActivityLevel**: Level of physical activity (required)
  - Valid values: `"Sedentary"`, `"Light"`, `"Moderate"`, `"Heavy"`
- **dietaryHabits**: Dietary pattern/preference (required)
  - Valid values: `"Omnivore"`, `"Vegetarian"`, `"Vegan"`, `"Pescatarian"`, `"Keto"`, `"Mediterranean"`
- **livingSituation**: Current living arrangement (required)
  - Valid values: `"With Family"`, `"Alone"`, `"With Roommates"`, `"Assisted Living"`, `"Nursing Home"`
- **occupation**: Patient's occupation/job title (optional)
  - Type: String (max 200 characters)
- **workHazards**: Occupational hazards or exposures (optional)
  - Type: String (max 500 characters)
  - Examples: "Chemical exposure", "Repetitive motion", "Heavy lifting", "Radiation exposure"
- **createdAt**: Timestamp when the record was created
- **updatedAt**: Timestamp when the record was last updated
- **createdBy**: ID of the staff member/provider who created the record
- **notes**: Optional additional notes about social history

---

## API Endpoints

### Base URL
All endpoints are relative to: `/api/patients/{patientId}/social-history`

---

### 1. Get Social History for a Patient

**Endpoint:** `GET /api/patients/{patientId}/social-history`

**Description:** Retrieves the social history record for a specific patient. Each patient should have one social history record (or none if not yet created).

**URL Parameters:**
- `patientId` (required): The unique identifier of the patient

**Request Example:**
```http
GET /api/patients/507f1f77bcf86cd799439011/social-history
```

**Success Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "id": "507f191e810c19729de860ea",
    "patientId": "507f1f77bcf86cd799439011",
    "smokingStatus": "Current Smoker",
    "packsPerDay": 1,
    "smokingStartDate": "2010-01-01T00:00:00Z",
    "alcoholFrequency": "Daily",
    "drinksPerSession": 2,
    "physicalActivityLevel": "Sedentary",
    "dietaryHabits": "Omnivore",
    "livingSituation": "With Family",
    "occupation": "Software Engineer",
    "workHazards": "Repetitive motion, Prolonged sitting",
    "createdAt": "2024-01-15T10:30:00Z",
    "updatedAt": "2024-01-15T10:30:00Z",
    "createdBy": "507f1f77bcf86cd799439012",
    "notes": null
  }
}
```

**Success Response (200 OK) - No Record Found:**
```json
{
  "success": true,
  "data": null,
  "message": "No social history record found for this patient"
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

### 2. Create Social History Record

**Endpoint:** `POST /api/patients/{patientId}/social-history`

**Description:** Creates a new social history record for a patient. If a record already exists, this should return an error (use PUT to update instead).

**URL Parameters:**
- `patientId` (required): The unique identifier of the patient

**Request Body:**
```json
{
  "smokingStatus": "Current Smoker",
  "packsPerDay": 1,
  "smokingStartDate": "2010-01-01T00:00:00Z",
  "alcoholFrequency": "Daily",
  "drinksPerSession": 2,
  "physicalActivityLevel": "Sedentary",
  "dietaryHabits": "Omnivore",
  "livingSituation": "With Family",
  "occupation": "Software Engineer",
  "workHazards": "Repetitive motion, Prolonged sitting",
  "notes": "Patient reports stress-related smoking"
}
```

**Request Body Validation:**
- `smokingStatus` (required, string): Must be one of: "Never Smoker", "Former Smoker", "Current Smoker"
- `packsPerDay` (optional, integer, min: 0): Required if smokingStatus is "Former Smoker" or "Current Smoker"
- `smokingStartDate` (optional, ISO 8601 datetime): Only relevant if smokingStatus is "Former Smoker" or "Current Smoker"
- `alcoholFrequency` (required, string): Must be one of: "Never", "Rarely", "Weekly", "Daily"
- `drinksPerSession` (optional, integer, min: 0): Only relevant if alcoholFrequency is not "Never"
- `physicalActivityLevel` (required, string): Must be one of: "Sedentary", "Light", "Moderate", "Heavy"
- `dietaryHabits` (required, string): Must be one of: "Omnivore", "Vegetarian", "Vegan", "Pescatarian", "Keto", "Mediterranean"
- `livingSituation` (required, string): Must be one of: "With Family", "Alone", "With Roommates", "Assisted Living", "Nursing Home"
- `occupation` (optional, string, max 200 chars)
- `workHazards` (optional, string, max 500 chars)
- `notes` (optional, string, max 1000 chars)

**Request Example:**
```http
POST /api/patients/507f1f77bcf86cd799439011/social-history
Content-Type: application/json

{
  "smokingStatus": "Current Smoker",
  "packsPerDay": 1,
  "smokingStartDate": "2010-01-01T00:00:00Z",
  "alcoholFrequency": "Daily",
  "drinksPerSession": 2,
  "physicalActivityLevel": "Sedentary",
  "dietaryHabits": "Omnivore",
  "livingSituation": "With Family",
  "occupation": "Software Engineer",
  "workHazards": "Repetitive motion"
}
```

**Success Response (201 Created):**
```json
{
  "success": true,
  "message": "Social history record created successfully",
  "data": {
    "id": "507f191e810c19729de860ea",
    "patientId": "507f1f77bcf86cd799439011",
    "smokingStatus": "Current Smoker",
    "packsPerDay": 1,
    "smokingStartDate": "2010-01-01T00:00:00Z",
    "alcoholFrequency": "Daily",
    "drinksPerSession": 2,
    "physicalActivityLevel": "Sedentary",
    "dietaryHabits": "Omnivore",
    "livingSituation": "With Family",
    "occupation": "Software Engineer",
    "workHazards": "Repetitive motion",
    "createdAt": "2024-01-15T10:30:00Z",
    "updatedAt": "2024-01-15T10:30:00Z",
    "createdBy": "507f1f77bcf86cd799439012",
    "notes": null
  }
}
```

**Error Responses:**
- `400 Bad Request`: Validation error or record already exists
```json
{
  "success": false,
  "error": "Validation failed",
  "errors": {
    "smokingStatus": "Smoking status is required",
    "packsPerDay": "Packs per day is required for current or former smokers"
  },
  "statusCode": 400
}
```

```json
{
  "success": false,
  "error": "Social history record already exists for this patient. Use PUT to update.",
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
  "error": "Failed to create social history record",
  "statusCode": 500
}
```

---

### 3. Update Social History Record

**Endpoint:** `PUT /api/patients/{patientId}/social-history`

**Description:** Updates an existing social history record for a patient. All fields are optional in the request body; only provided fields will be updated. This endpoint can also be used to create a record if it doesn't exist (upsert behavior).

**URL Parameters:**
- `patientId` (required): The unique identifier of the patient

**Request Body (all fields optional):**
```json
{
  "smokingStatus": "Former Smoker",
  "packsPerDay": 0,
  "smokingStartDate": "2010-01-01T00:00:00Z",
  "alcoholFrequency": "Weekly",
  "drinksPerSession": 3,
  "physicalActivityLevel": "Moderate",
  "dietaryHabits": "Mediterranean",
  "livingSituation": "Alone",
  "occupation": "Retired",
  "workHazards": null,
  "notes": "Patient quit smoking 6 months ago"
}
```

**Request Example:**
```http
PUT /api/patients/507f1f77bcf86cd799439011/social-history
Content-Type: application/json

{
  "smokingStatus": "Former Smoker",
  "alcoholFrequency": "Weekly",
  "physicalActivityLevel": "Moderate"
}
```

**Success Response (200 OK):**
```json
{
  "success": true,
  "message": "Social history record updated successfully",
  "data": {
    "id": "507f191e810c19729de860ea",
    "patientId": "507f1f77bcf86cd799439011",
    "smokingStatus": "Former Smoker",
    "packsPerDay": 1,
    "smokingStartDate": "2010-01-01T00:00:00Z",
    "alcoholFrequency": "Weekly",
    "drinksPerSession": 2,
    "physicalActivityLevel": "Moderate",
    "dietaryHabits": "Omnivore",
    "livingSituation": "With Family",
    "occupation": "Software Engineer",
    "workHazards": "Repetitive motion",
    "createdAt": "2024-01-15T10:30:00Z",
    "updatedAt": "2024-01-15T11:45:00Z",
    "createdBy": "507f1f77bcf86cd799439012",
    "notes": "Patient quit smoking 6 months ago"
  }
}
```

**Success Response (201 Created) - Record Created:**
If the record doesn't exist and is created via PUT:
```json
{
  "success": true,
  "message": "Social history record created successfully",
  "data": {
    "id": "507f191e810c19729de860ea",
    "patientId": "507f1f77bcf86cd799439011",
    "smokingStatus": "Former Smoker",
    "packsPerDay": 0,
    "smokingStartDate": null,
    "alcoholFrequency": "Weekly",
    "drinksPerSession": 3,
    "physicalActivityLevel": "Moderate",
    "dietaryHabits": "Mediterranean",
    "livingSituation": "Alone",
    "occupation": "Retired",
    "workHazards": null,
    "createdAt": "2024-01-15T11:45:00Z",
    "updatedAt": "2024-01-15T11:45:00Z",
    "createdBy": "507f1f77bcf86cd799439012",
    "notes": null
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
    "smokingStatus": "Invalid smoking status. Must be one of: Never Smoker, Former Smoker, Current Smoker",
    "packsPerDay": "Packs per day must be 0 or greater"
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
  "error": "Failed to update social history record",
  "statusCode": 500
}
```

---

### 4. Delete Social History Record

**Endpoint:** `DELETE /api/patients/{patientId}/social-history`

**Description:** Deletes a social history record. Recommended to use soft delete (mark as deleted) rather than hard delete for audit purposes.

**URL Parameters:**
- `patientId` (required): The unique identifier of the patient

**Query Parameters (optional):**
- `hardDelete` (boolean, default: false): If true, permanently deletes the record. If false, performs soft delete.

**Request Example:**
```http
DELETE /api/patients/507f1f77bcf86cd799439011/social-history?hardDelete=false
```

**Success Response (200 OK):**
```json
{
  "success": true,
  "message": "Social history record deleted successfully",
  "data": {
    "id": "507f191e810c19729de860ea",
    "deletedAt": "2024-01-15T12:00:00Z"
  }
}
```

**Error Responses:**
- `404 Not Found`: Patient or social history record not found
```json
{
  "success": false,
  "error": "Social history record not found",
  "statusCode": 404
}
```

- `500 Internal Server Error`: Server error
```json
{
  "success": false,
  "error": "Failed to delete social history record",
  "statusCode": 500
}
```

---

## Database Schema Recommendations

### MongoDB Example Schema

```javascript
{
  _id: ObjectId,
  patientId: ObjectId, // Reference to patients collection, unique index
  smokingStatus: String, // Required, enum: ["Never Smoker", "Former Smoker", "Current Smoker"]
  packsPerDay: Number, // Optional, default: 0, min: 0
  smokingStartDate: Date, // Optional
  alcoholFrequency: String, // Required, enum: ["Never", "Rarely", "Weekly", "Daily"]
  drinksPerSession: Number, // Optional, default: 0, min: 0
  physicalActivityLevel: String, // Required, enum: ["Sedentary", "Light", "Moderate", "Heavy"]
  dietaryHabits: String, // Required, enum: ["Omnivore", "Vegetarian", "Vegan", "Pescatarian", "Keto", "Mediterranean"]
  livingSituation: String, // Required, enum: ["With Family", "Alone", "With Roommates", "Assisted Living", "Nursing Home"]
  occupation: String, // Optional, max 200 chars
  workHazards: String, // Optional, max 500 chars
  notes: String, // Optional, max 1000 chars
  createdBy: ObjectId, // Reference to staff/users collection
  createdAt: Date, // Auto-generated
  updatedAt: Date, // Auto-updated
  deletedAt: Date, // For soft delete, null if not deleted
  isDeleted: Boolean // For soft delete, default: false
}

// Indexes
db.socialHistory.createIndex({ patientId: 1, isDeleted: 1 }, { unique: true, partialFilterExpression: { isDeleted: false } });
db.socialHistory.createIndex({ smokingStatus: 1 });
db.socialHistory.createIndex({ alcoholFrequency: 1 });
```

### SQL Example Schema (PostgreSQL/MySQL)

```sql
CREATE TABLE social_history (
  id VARCHAR(36) PRIMARY KEY,
  patient_id VARCHAR(36) NOT NULL UNIQUE,
  smoking_status VARCHAR(20) NOT NULL CHECK (smoking_status IN ('Never Smoker', 'Former Smoker', 'Current Smoker')),
  packs_per_day INT DEFAULT 0 CHECK (packs_per_day >= 0),
  smoking_start_date DATE NULL,
  alcohol_frequency VARCHAR(20) NOT NULL CHECK (alcohol_frequency IN ('Never', 'Rarely', 'Weekly', 'Daily')),
  drinks_per_session INT DEFAULT 0 CHECK (drinks_per_session >= 0),
  physical_activity_level VARCHAR(20) NOT NULL CHECK (physical_activity_level IN ('Sedentary', 'Light', 'Moderate', 'Heavy')),
  dietary_habits VARCHAR(20) NOT NULL CHECK (dietary_habits IN ('Omnivore', 'Vegetarian', 'Vegan', 'Pescatarian', 'Keto', 'Mediterranean')),
  living_situation VARCHAR(30) NOT NULL CHECK (living_situation IN ('With Family', 'Alone', 'With Roommates', 'Assisted Living', 'Nursing Home')),
  occupation VARCHAR(200) NULL,
  work_hazards VARCHAR(500) NULL,
  notes TEXT NULL,
  created_by VARCHAR(36),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP NULL,
  is_deleted BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (patient_id) REFERENCES patients(id),
  FOREIGN KEY (created_by) REFERENCES staff(id),
  UNIQUE KEY unique_patient_active (patient_id, is_deleted)
);

-- Indexes
CREATE INDEX idx_social_history_smoking ON social_history(smoking_status);
CREATE INDEX idx_social_history_alcohol ON social_history(alcohol_frequency);
```

---

## Business Logic & Validation Rules

### Validation Rules

1. **Smoking Status:**
   - Required field
   - Must be one of: "Never Smoker", "Former Smoker", "Current Smoker"
   - If "Never Smoker": `packsPerDay` should be 0 or null, `smokingStartDate` should be null
   - If "Former Smoker" or "Current Smoker": `packsPerDay` is recommended (can be 0)

2. **Packs Per Day:**
   - Optional field
   - Must be 0 or positive integer
   - Only relevant if smokingStatus is "Former Smoker" or "Current Smoker"
   - Default: 0

3. **Smoking Start Date:**
   - Optional field
   - Must be a valid date (ISO 8601 format)
   - Should be in the past (not future dates)
   - Only relevant if smokingStatus is "Former Smoker" or "Current Smoker"

4. **Alcohol Frequency:**
   - Required field
   - Must be one of: "Never", "Rarely", "Weekly", "Daily"
   - If "Never": `drinksPerSession` should be 0 or null

5. **Drinks Per Session:**
   - Optional field
   - Must be 0 or positive integer
   - Only relevant if alcoholFrequency is not "Never"
   - Default: 0

6. **Physical Activity Level:**
   - Required field
   - Must be one of: "Sedentary", "Light", "Moderate", "Heavy"

7. **Dietary Habits:**
   - Required field
   - Must be one of: "Omnivore", "Vegetarian", "Vegan", "Pescatarian", "Keto", "Mediterranean"

8. **Living Situation:**
   - Required field
   - Must be one of: "With Family", "Alone", "With Roommates", "Assisted Living", "Nursing Home"

9. **Occupation:**
   - Optional field
   - Maximum 200 characters
   - Free text field

10. **Work Hazards:**
    - Optional field
    - Maximum 500 characters
    - Free text field
    - Can contain multiple hazards separated by commas

11. **Notes:**
    - Optional field
    - Maximum 1000 characters
    - Free text field for additional information

### Business Rules

1. **One Record Per Patient:**
   - Each patient should have at most one active social history record
   - Use unique constraint on `patientId` with `isDeleted = false`
   - When creating a new record, check if one already exists

2. **Conditional Field Requirements:**
   - If `smokingStatus` is "Never Smoker", automatically set `packsPerDay` to 0 and `smokingStartDate` to null
   - If `alcoholFrequency` is "Never", automatically set `drinksPerSession` to 0

3. **Data Integrity:**
   - When a patient is deleted, decide on cascade behavior:
     - Option A: Delete social history (hard delete)
     - Option B: Archive social history (soft delete)
     - Option C: Keep social history but mark patient as deleted

4. **Audit Trail:**
   - Track who created/updated each record (`createdBy` field)
   - Maintain timestamps for all operations
   - Consider logging all changes for compliance

5. **Risk Assessment:**
   - Consider calculating risk scores based on:
     - Current smoking status
     - Alcohol frequency and quantity
     - Physical activity level
     - Work hazards
   - These can be used for clinical decision support

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
   - Validate enum values strictly

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
static const String socialHistoryEndpoint = '/api/patients';

// Get social history for a patient
static Future<ApiResponse> getSocialHistory(String patientId) async {
  return get('$socialHistoryEndpoint/$patientId/social-history');
}

// Create social history record
static Future<ApiResponse> createSocialHistory(
  String patientId,
  Map<String, dynamic> socialHistoryData,
) async {
  return post(
    '$socialHistoryEndpoint/$patientId/social-history',
    socialHistoryData,
  );
}

// Update social history record
static Future<ApiResponse> updateSocialHistory(
  String patientId,
  Map<String, dynamic> socialHistoryData,
) async {
  return put(
    '$socialHistoryEndpoint/$patientId/social-history',
    socialHistoryData,
  );
}

// Delete social history record
static Future<ApiResponse> deleteSocialHistory(
  String patientId, {
  bool hardDelete = false,
}) async {
  String endpoint = '$socialHistoryEndpoint/$patientId/social-history';
  if (hardDelete) {
    endpoint += '?hardDelete=true';
  }
  return delete(endpoint);
}
```

---

## Testing Recommendations

### Unit Tests
- Test validation rules for each field
- Test conditional field requirements (e.g., packsPerDay when smokingStatus is "Never Smoker")
- Test enum value validation
- Test business logic (one record per patient)

### Integration Tests
- Test full CRUD operations
- Test upsert behavior (PUT creating new record)
- Test conditional field logic
- Test soft delete functionality

### Test Cases

1. **Create:**
   - Valid record creation
   - Missing required fields
   - Invalid enum values
   - Invalid field values (negative numbers, too long strings)
   - Creating duplicate record (should fail)
   - Non-existent patient ID

2. **Read:**
   - Get existing record
   - Get non-existent record (should return null with success)
   - Non-existent patient ID

3. **Update:**
   - Update all fields
   - Partial update (only some fields)
   - Update non-existent record (should create new one - upsert)
   - Validation errors on update
   - Conditional field updates (e.g., setting smokingStatus to "Never Smoker" should clear packsPerDay)

4. **Delete:**
   - Soft delete
   - Hard delete
   - Delete non-existent record
   - Verify soft-deleted records are excluded from GET

---

## Additional Features (Optional Enhancements)

### 1. Social History Summary/Statistics
**Endpoint:** `GET /api/patients/{patientId}/social-history/summary`

Return aggregated statistics and risk assessments:
- Risk score based on smoking, alcohol, activity level
- Recommendations based on lifestyle factors
- Trend analysis if historical data is available

### 2. Export Social History
**Endpoint:** `GET /api/patients/{patientId}/social-history/export?format={pdf|csv|json}`

Export social history in various formats for reports.

### 3. Social History Templates
**Endpoint:** `GET /api/social-history/templates`

Provide predefined templates for common patient profiles (e.g., "Healthy Adult", "Elderly Patient", "Athlete").

### 4. Risk Assessment Calculation
Automatically calculate risk scores based on:
- Smoking status and pack-years
- Alcohol consumption patterns
- Physical activity level
- Work hazards
- Age and other patient factors

---

## Summary

This guide provides a comprehensive blueprint for implementing backend endpoints for patient social history. The endpoints support:

- ✅ Full CRUD operations (Create, Read, Update, Delete)
- ✅ Upsert behavior (PUT can create if record doesn't exist)
- ✅ Conditional field validation
- ✅ One record per patient constraint
- ✅ Comprehensive validation and error handling
- ✅ Security and authorization considerations
- ✅ Soft delete for audit trails

The backend should implement these endpoints following RESTful principles, with proper validation, error handling, and security measures in place. The social history data is critical for clinical decision-making and should be treated with the same level of security and care as other patient health information.

