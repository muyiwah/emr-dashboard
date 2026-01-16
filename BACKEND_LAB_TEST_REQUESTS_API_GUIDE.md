# Backend Lab Test Requests API Guide

This document provides comprehensive instructions for implementing the backend API endpoints to support the Lab Test Requests Inbox screen. This system allows lab staff to view, filter, and manage incoming lab test requests from physicians.

---

## Overview

The Lab Test Requests API provides endpoints for:
1. **Today's Overview Metrics**: Real-time counts of requests by status and priority
2. **Lab Request List**: Paginated list of all lab requests with detailed information
3. **Filtering & Search**: Support for status, priority, department, and text search
4. **Request Details**: Detailed information for individual lab requests

---

## Database Schema

### Table: `lab_test_requests`

```sql
CREATE TABLE lab_test_requests (
    -- Primary Identification
    id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    request_number          VARCHAR(50) UNIQUE NOT NULL,  -- Human-readable: LR-2024-000001
    
    -- Patient Information
    patient_id              UUID NOT NULL REFERENCES patients(id),
    patient_mrn             VARCHAR(50) NOT NULL,
    patient_name            VARCHAR(255) NOT NULL,  -- Denormalized for quick access
    patient_age             INTEGER,
    patient_gender          VARCHAR(10),  -- 'M', 'F', 'Other'
    
    -- Visit & Encounter References
    visit_id                UUID REFERENCES visits(id),
    encounter_id            UUID REFERENCES encounters(id),
    medical_record_id       UUID REFERENCES medical_records(id),
    
    -- Ordering Physician Information
    ordering_doctor_id      UUID NOT NULL REFERENCES staff(id),
    ordering_doctor_name    VARCHAR(255) NOT NULL,  -- Denormalized: "Dr. Smith"
    ordering_doctor_department VARCHAR(100),  -- "Emergency", "Cardiology", "Internal Med"
    
    -- Request Details
    request_date            TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    requested_at            TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    -- Priority & Status
    priority                VARCHAR(50) NOT NULL DEFAULT 'ROUTINE',
    -- Values: 'URGENT', 'ROUTINE', 'DELAYED', 'STAT'
    -- Note: 'STAT' is highest priority, 'URGENT' is high, 'ROUTINE' is normal, 'DELAYED' is low
    
    status                  VARCHAR(50) NOT NULL DEFAULT 'New',
    -- Values: 'New', 'In Progress', 'Completed', 'Cancelled', 'On Hold'
    
    -- Clinical Information
    clinical_indication     TEXT,  -- Reason for ordering tests
    notes                   TEXT,  -- Additional notes from ordering physician
    
    -- Specimen Information
    specimen_collected      BOOLEAN DEFAULT FALSE,
    specimen_collected_at   TIMESTAMP WITH TIME ZONE,
    specimen_collected_by   UUID REFERENCES staff(id),
    
    -- Processing Information
    processing_started_at   TIMESTAMP WITH TIME ZONE,
    processing_started_by   UUID REFERENCES staff(id),
    completed_at            TIMESTAMP WITH TIME ZONE,
    completed_by            UUID REFERENCES staff(id),
    
    -- Timestamps
    created_at              TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at              TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
    -- Soft Delete
    is_deleted              BOOLEAN DEFAULT FALSE,
    deleted_at              TIMESTAMP WITH TIME ZONE,
    deleted_by              UUID REFERENCES staff(id),
    
    -- Constraints
    CONSTRAINT chk_priority CHECK (priority IN ('URGENT', 'ROUTINE', 'DELAYED', 'STAT')),
    CONSTRAINT chk_status CHECK (status IN ('New', 'In Progress', 'Completed', 'Cancelled', 'On Hold'))
);

-- Indexes for performance
CREATE INDEX idx_lab_requests_patient ON lab_test_requests(patient_id);
CREATE INDEX idx_lab_requests_doctor ON lab_test_requests(ordering_doctor_id);
CREATE INDEX idx_lab_requests_status ON lab_test_requests(status);
CREATE INDEX idx_lab_requests_priority ON lab_test_requests(priority);
CREATE INDEX idx_lab_requests_department ON lab_test_requests(ordering_doctor_department);
CREATE INDEX idx_lab_requests_date ON lab_test_requests(request_date);
CREATE INDEX idx_lab_requests_created ON lab_test_requests(created_at);
CREATE INDEX idx_lab_requests_patient_mrn ON lab_test_requests(patient_mrn);
CREATE INDEX idx_lab_requests_number ON lab_test_requests(request_number);
```

### Table: `lab_test_request_items`

```sql
CREATE TABLE lab_test_request_items (
    -- Primary Identification
    id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    request_id              UUID NOT NULL REFERENCES lab_test_requests(id) ON DELETE CASCADE,
    
    -- Test Catalog Reference
    test_catalog_id         UUID NOT NULL REFERENCES lab_test_catalog(id),
    test_code               VARCHAR(50) NOT NULL,  -- Denormalized: 'FBC', 'LFT', etc.
    test_name               VARCHAR(255) NOT NULL,  -- Denormalized: 'Full Blood Count'
    
    -- Test Status (per item)
    item_status             VARCHAR(50) NOT NULL DEFAULT 'Pending',
    -- Values: 'Pending', 'Collected', 'In Progress', 'Completed', 'Cancelled'
    
    -- Specimen Information
    specimen_type           VARCHAR(50),  -- 'Blood', 'Urine', 'CSF', etc.
    specimen_collected      BOOLEAN DEFAULT FALSE,
    specimen_collected_at   TIMESTAMP WITH TIME ZONE,
    
    -- Results
    result_available        BOOLEAN DEFAULT FALSE,
    result_available_at      TIMESTAMP WITH TIME ZONE,
    
    -- Timestamps
    created_at              TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at              TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_item_status CHECK (item_status IN ('Pending', 'Collected', 'In Progress', 'Completed', 'Cancelled'))
);

-- Indexes
CREATE INDEX idx_request_items_request ON lab_test_request_items(request_id);
CREATE INDEX idx_request_items_test ON lab_test_request_items(test_catalog_id);
CREATE INDEX idx_request_items_status ON lab_test_request_items(item_status);
```

### Table: `lab_test_request_audit_log`

```sql
CREATE TABLE lab_test_request_audit_log (
    id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    request_id              UUID NOT NULL REFERENCES lab_test_requests(id),
    
    action                  VARCHAR(100) NOT NULL,
    -- Actions: 'created', 'status_changed', 'priority_changed', 'specimen_collected',
    --          'processing_started', 'completed', 'cancelled', 'viewed', 'exported'
    
    action_details          JSONB,  -- Detailed change information
    previous_values         JSONB,  -- For updates, store previous values
    new_values              JSONB,  -- For updates, store new values
    
    performed_by_id         UUID NOT NULL REFERENCES staff(id),
    performed_by_name       VARCHAR(255) NOT NULL,
    performed_by_role       VARCHAR(100) NOT NULL,  -- 'doctor', 'lab_technician', 'lab_manager'
    
    ip_address              INET,
    user_agent              TEXT,
    
    created_at              TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX idx_audit_log_request ON lab_test_request_audit_log(request_id);
CREATE INDEX idx_audit_log_action ON lab_test_request_audit_log(action);
CREATE INDEX idx_audit_log_user ON lab_test_request_audit_log(performed_by_id);
CREATE INDEX idx_audit_log_timestamp ON lab_test_request_audit_log(created_at);
```

---

## API Endpoints

### Base URL
```
/api/v1/lab-test-requests
```

---

### 1. Get Today's Overview Metrics

**Endpoint:** `GET /api/v1/lab-test-requests/overview/today`

**Description:** Returns real-time metrics for today's lab test requests. This endpoint should be optimized for quick response times as it's displayed prominently in the UI.

**Query Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `date` | string (ISO 8601) | No | Date to get metrics for (default: today) |

**Response Format:**

```json
{
  "success": true,
  "message": "Today's overview metrics retrieved successfully",
  "data": {
    "date": "2024-01-15",
    "metrics": {
      "total_requests": 24,
      "urgent": 5,
      "in_progress": 12,
      "completed": 18,
      "new": 7,
      "on_hold": 0,
      "cancelled": 1
    },
    "priority_breakdown": {
      "stat": 2,
      "urgent": 5,
      "routine": 15,
      "delayed": 2
    },
    "status_breakdown": {
      "new": 7,
      "in_progress": 12,
      "completed": 18,
      "on_hold": 0,
      "cancelled": 1
    }
  }
}
```

**Success Status Code:** `200 OK`

**Business Rules:**
- Count requests where `request_date` is on the specified date (or today if not specified)
- Exclude soft-deleted requests (`is_deleted = false`)
- `urgent` count includes both 'URGENT' and 'STAT' priority requests
- `in_progress` includes requests with status 'In Progress'
- `completed` includes requests with status 'Completed'
- `total_requests` is the total count of all non-deleted requests for the day

**Performance Requirements:**
- Response time should be < 100ms
- Consider caching for 30-60 seconds during peak hours
- Use database materialized views or aggregated tables for better performance

---

### 2. Get Lab Test Requests List

**Endpoint:** `GET /api/v1/lab-test-requests`

**Description:** Returns a paginated list of lab test requests with all details needed for the UI display.

**Query Parameters:**

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `page` | integer | No | 1 | Page number for pagination |
| `limit` | integer | No | 20 | Number of items per page (max: 100) |
| `status` | string | No | - | Filter by status: 'All', 'New', 'In Progress', 'Completed', 'On Hold', 'Cancelled' |
| `priority` | string | No | - | Filter by priority: 'All', 'High', 'Medium', 'Low' (maps to STAT/URGENT, ROUTINE, DELAYED) |
| `department` | string | No | - | Filter by department: 'All Departments', 'Emergency', 'Cardiology', 'Internal Med', etc. |
| `search` | string | No | - | Search by patient name, patient ID (MRN), request number, or test name |
| `date_from` | string (ISO 8601) | No | - | Filter requests from this date |
| `date_to` | string (ISO 8601) | No | - | Filter requests to this date |
| `sort_by` | string | No | `created_at` | Sort field: `created_at`, `request_date`, `priority`, `status`, `patient_name` |
| `sort_order` | string | No | `desc` | Sort order: `asc` or `desc` |

**Priority Mapping:**
- `High` → `STAT`, `URGENT`
- `Medium` → `ROUTINE`
- `Low` → `DELAYED`

**Response Format:**

```json
{
  "success": true,
  "message": "Lab test requests retrieved successfully",
  "data": {
    "requests": [
      {
        "id": "550e8400-e29b-41d4-a716-446655440000",
        "request_number": "LR-2024-000001",
        
        "patient": {
          "id": "660e8400-e29b-41d4-a716-446655440000",
          "mrn": "P-2024-001",
          "name": "Sarah Johnson",
          "age": 34,
          "gender": "F",
          "demographics": "F, 34"  -- Formatted for UI display
        },
        
        "tests": [
          {
            "id": "770e8400-e29b-41d4-a716-446655440000",
            "test_catalog_id": "880e8400-e29b-41d4-a716-446655440000",
            "test_code": "FBC",
            "test_name": "Full Blood Count",
            "specimen_type": "Blood",
            "item_status": "Pending",
            "display_color": "#FEE2E2"  -- Color code for UI chip display
          },
          {
            "id": "770e8400-e29b-41d4-a716-446655440001",
            "test_catalog_id": "880e8400-e29b-41d4-a716-446655440002",
            "test_code": "UA",
            "test_name": "Urinalysis",
            "specimen_type": "Urine",
            "item_status": "Pending",
            "display_color": "#DBEAFE"
          },
          {
            "id": "770e8400-e29b-41d4-a716-446655440003",
            "test_catalog_id": "880e8400-e29b-41d4-a716-446655440003",
            "test_code": "BLOOD",
            "test_name": "Blood",
            "specimen_type": "Blood",
            "item_status": "Pending",
            "display_color": "#D1FAE5"
          }
        ],
        
        "priority": "URGENT",
        "priority_display": "URGENT",  -- For UI badge display
        "priority_color": "#DC2626",  -- Color for priority badge
        
        "status": "New",
        "status_display": "New",  -- For UI badge display
        "status_color": "#DC2626",  -- Color for status indicator dot
        
        "ordering_doctor": {
          "id": "990e8400-e29b-41d4-a716-446655440000",
          "name": "Dr. Smith",
          "department": "Emergency",
          "display": "Dr. Smith - Emergency"  -- Formatted for UI display
        },
        
        "request_date": "2024-01-15T10:30:00Z",
        "requested_at": "2024-01-15T10:30:00Z",
        "created_at": "2024-01-15T10:30:00Z",
        
        "time_ago": "2 hours ago",  -- Human-readable relative time
        "time_ago_seconds": 7200,  -- For sorting/filtering
        
        "clinical_indication": "Patient presenting with fever and headache",
        "notes": "Please prioritize - patient in emergency department",
        
        "specimen_collected": false,
        "specimen_collected_at": null,
        
        "processing_started_at": null,
        "completed_at": null
      },
      {
        "id": "550e8400-e29b-41d4-a716-446655440001",
        "request_number": "LR-2024-000002",
        
        "patient": {
          "id": "660e8400-e29b-41d4-a716-446655440001",
          "mrn": "P-2024-002",
          "name": "Michael Chen",
          "age": 45,
          "gender": "M",
          "demographics": "M, 45"
        },
        
        "tests": [
          {
            "id": "770e8400-e29b-41d4-a716-446655440004",
            "test_catalog_id": "880e8400-e29b-41d4-a716-446655440004",
            "test_code": "LIPID",
            "test_name": "Lipid Panel",
            "specimen_type": "Blood",
            "item_status": "In Progress",
            "display_color": "#E9D5FF"
          },
          {
            "id": "770e8400-e29b-41d4-a716-446655440005",
            "test_catalog_id": "880e8400-e29b-41d4-a716-446655440005",
            "test_code": "BLOOD",
            "test_name": "Blood",
            "specimen_type": "Blood",
            "item_status": "In Progress",
            "display_color": "#D1FAE5"
          }
        ],
        
        "priority": "ROUTINE",
        "priority_display": "ROUTINE",
        "priority_color": "#059669",
        
        "status": "In Progress",
        "status_display": "In Progress",
        "status_color": "#059669",
        
        "ordering_doctor": {
          "id": "990e8400-e29b-41d4-a716-446655440001",
          "name": "Dr. Wilson",
          "department": "Cardiology",
          "display": "Dr. Wilson - Cardiology"
        },
        
        "request_date": "2024-01-15T08:30:00Z",
        "requested_at": "2024-01-15T08:30:00Z",
        "created_at": "2024-01-15T08:30:00Z",
        
        "time_ago": "4 hours ago",
        "time_ago_seconds": 14400,
        
        "clinical_indication": "Routine lipid screening",
        "notes": null,
        
        "specimen_collected": true,
        "specimen_collected_at": "2024-01-15T09:00:00Z",
        
        "processing_started_at": "2024-01-15T09:15:00Z",
        "completed_at": null
      }
    ],
    "pagination": {
      "current_page": 1,
      "total_pages": 3,
      "total_items": 24,
      "items_per_page": 20,
      "has_next": true,
      "has_previous": false
    },
    "filters_applied": {
      "status": "All",
      "priority": "All",
      "department": "All Departments",
      "search": null
    }
  }
}
```

**Success Status Code:** `200 OK`

**Error Response:**

```json
{
  "success": false,
  "message": "Failed to retrieve lab test requests",
  "error": "Invalid filter parameter",
  "status_code": 400,
  "errors": [
    {
      "field": "priority",
      "message": "Invalid priority value. Must be one of: All, High, Medium, Low"
    }
  ]
}
```

---

### 3. Get Lab Test Request by ID

**Endpoint:** `GET /api/v1/lab-test-requests/:id`

**Description:** Returns detailed information about a specific lab test request.

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `id` | UUID | Yes | Lab test request ID |

**Response Format:**

```json
{
  "success": true,
  "message": "Lab test request retrieved successfully",
  "data": {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "request_number": "LR-2024-000001",
    
    "patient": {
      "id": "660e8400-e29b-41d4-a716-446655440000",
      "mrn": "P-2024-001",
      "name": "Sarah Johnson",
      "age": 34,
      "gender": "F",
      "date_of_birth": "1990-05-15",
      "phone": "+1234567890",
      "email": "sarah.johnson@example.com"
    },
    
    "visit": {
      "id": "aa0e8400-e29b-41d4-a716-446655440000",
      "visit_number": "V-2024-000001",
      "visit_type": "Emergency",
      "visit_date": "2024-01-15T10:00:00Z"
    },
    
    "tests": [
      {
        "id": "770e8400-e29b-41d4-a716-446655440000",
        "test_catalog_id": "880e8400-e29b-41d4-a716-446655440000",
        "test_code": "FBC",
        "test_name": "Full Blood Count",
        "loinc_code": "57021-8",
        "category": "Hematology",
        "specimen_type": "Blood",
        "sample_volume": "2-3 ml",
        "item_status": "Pending",
        "specimen_collected": false,
        "specimen_collected_at": null,
        "result_available": false,
        "result_available_at": null,
        "display_color": "#FEE2E2"
      }
    ],
    
    "priority": "URGENT",
    "status": "New",
    
    "ordering_doctor": {
      "id": "990e8400-e29b-41d4-a716-446655440000",
      "name": "Dr. Smith",
      "department": "Emergency",
      "license_number": "MD-12345",
      "phone": "+1234567891",
      "email": "dr.smith@hospital.com"
    },
    
    "request_date": "2024-01-15T10:30:00Z",
    "requested_at": "2024-01-15T10:30:00Z",
    
    "clinical_indication": "Patient presenting with fever and headache",
    "notes": "Please prioritize - patient in emergency department",
    
    "specimen_collected": false,
    "specimen_collected_at": null,
    "specimen_collected_by": null,
    
    "processing_started_at": null,
    "processing_started_by": null,
    "completed_at": null,
    "completed_by": null,
    
    "created_at": "2024-01-15T10:30:00Z",
    "updated_at": "2024-01-15T10:30:00Z",
    
    "audit_trail": [
      {
        "action": "created",
        "performed_by": "Dr. Smith",
        "timestamp": "2024-01-15T10:30:00Z"
      }
    ]
  }
}
```

**Success Status Code:** `200 OK`

**Error Response (404):**

```json
{
  "success": false,
  "message": "Lab test request not found",
  "error": "No lab test request found with the provided ID",
  "status_code": 404
}
```

---

### 4. Update Request Status

**Endpoint:** `PATCH /api/v1/lab-test-requests/:id/status`

**Description:** Updates the status of a lab test request. Used when lab staff change the status (e.g., from "New" to "In Progress" to "Completed").

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `id` | UUID | Yes | Lab test request ID |

**Request Body:**

```json
{
  "status": "In Progress",
  "notes": "Specimen collected, starting processing",
  "specimen_collected": true,
  "specimen_collected_at": "2024-01-15T11:00:00Z"
}
```

**Response Format:**

```json
{
  "success": true,
  "message": "Request status updated successfully",
  "data": {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "status": "In Progress",
    "updated_at": "2024-01-15T11:00:00Z"
  }
}
```

**Success Status Code:** `200 OK`

**Business Rules:**
- Only lab staff can update request status
- Status transitions must be valid (e.g., cannot go from "Completed" back to "New")
- When status changes to "In Progress", set `processing_started_at` if not already set
- When status changes to "Completed", set `completed_at` and `completed_by`

---

### 5. Get Available Departments

**Endpoint:** `GET /api/v1/lab-test-requests/departments`

**Description:** Returns a list of all departments that have submitted lab test requests. Used to populate the department filter dropdown.

**Response Format:**

```json
{
  "success": true,
  "message": "Departments retrieved successfully",
  "data": {
    "departments": [
      {
        "name": "Emergency",
        "count": 45,
        "display_name": "Emergency"
      },
      {
        "name": "Cardiology",
        "count": 32,
        "display_name": "Cardiology"
      },
      {
        "name": "Internal Med",
        "count": 28,
        "display_name": "Internal Med"
      },
      {
        "name": "Pediatrics",
        "count": 15,
        "display_name": "Pediatrics"
      },
      {
        "name": "Surgery",
        "count": 12,
        "display_name": "Surgery"
      }
    ],
    "total_departments": 5
  }
}
```

**Success Status Code:** `200 OK`

---

### 6. Export Lab Test Requests

**Endpoint:** `GET /api/v1/lab-test-requests/export`

**Description:** Exports lab test requests to CSV or Excel format. Supports the same filters as the list endpoint.

**Query Parameters:**

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `format` | string | No | `csv` | Export format: `csv` or `xlsx` |
| `status` | string | No | - | Filter by status (same as list endpoint) |
| `priority` | string | No | - | Filter by priority (same as list endpoint) |
| `department` | string | No | - | Filter by department (same as list endpoint) |
| `search` | string | No | - | Search query (same as list endpoint) |
| `date_from` | string (ISO 8601) | No | - | Filter from date |
| `date_to` | string (ISO 8601) | No | - | Filter to date |

**Response:**

- **Content-Type:** `text/csv` for CSV, `application/vnd.openxmlformats-officedocument.spreadsheetml.sheet` for Excel
- **Content-Disposition:** `attachment; filename="lab_test_requests_2024-01-15.csv"`

**CSV Format:**
```csv
Request Number,Patient Name,Patient ID,Age,Gender,Priority,Status,Ordering Doctor,Department,Tests,Request Date,Time Ago
LR-2024-000001,Sarah Johnson,P-2024-001,34,F,URGENT,New,Dr. Smith,Emergency,"FBC, UA, Blood",2024-01-15 10:30:00,2 hours ago
LR-2024-000002,Michael Chen,P-2024-002,45,M,ROUTINE,In Progress,Dr. Wilson,Cardiology,"Lipid Panel, Blood",2024-01-15 08:30:00,4 hours ago
```

**Success Status Code:** `200 OK`

---

## Implementation Requirements

### 1. Search Functionality

The search parameter should support searching across:
- **Patient Name**: Full-text search on `patient_name`
- **Patient ID/MRN**: Exact or partial match on `patient_mrn`
- **Request Number**: Exact or partial match on `request_number`
- **Test Name**: Search in `lab_test_request_items.test_name`
- **Test Code**: Search in `lab_test_request_items.test_code`

**Example SQL Query:**
```sql
SELECT DISTINCT ltr.*
FROM lab_test_requests ltr
LEFT JOIN lab_test_request_items ltri ON ltr.id = ltri.request_id
WHERE ltr.is_deleted = false
  AND (
    ltr.patient_name ILIKE '%sarah%'
    OR ltr.patient_mrn ILIKE '%P-2024-001%'
    OR ltr.request_number ILIKE '%LR-2024-000001%'
    OR ltri.test_name ILIKE '%blood%'
    OR ltri.test_code ILIKE '%FBC%'
  )
ORDER BY ltr.created_at DESC
LIMIT 20 OFFSET 0;
```

### 2. Filtering Logic

**Status Filter:**
- `All` → No filter applied
- `New` → `status = 'New'`
- `In Progress` → `status = 'In Progress'`
- `Completed` → `status = 'Completed'`
- `On Hold` → `status = 'On Hold'`
- `Cancelled` → `status = 'Cancelled'`

**Priority Filter:**
- `All` → No filter applied
- `High` → `priority IN ('STAT', 'URGENT')`
- `Medium` → `priority = 'ROUTINE'`
- `Low` → `priority = 'DELAYED'`

**Department Filter:**
- `All Departments` → No filter applied
- Specific department → `ordering_doctor_department = 'Emergency'` (exact match)

### 3. Time Ago Calculation

Calculate human-readable relative time:
- Less than 1 minute: "Just now"
- Less than 1 hour: "X minutes ago"
- Less than 24 hours: "X hours ago"
- Less than 7 days: "X days ago"
- Otherwise: Show actual date

**Example Implementation:**
```javascript
function calculateTimeAgo(timestamp) {
  const now = new Date();
  const then = new Date(timestamp);
  const diffSeconds = Math.floor((now - then) / 1000);
  
  if (diffSeconds < 60) return "Just now";
  if (diffSeconds < 3600) return `${Math.floor(diffSeconds / 60)} minutes ago`;
  if (diffSeconds < 86400) return `${Math.floor(diffSeconds / 3600)} hours ago`;
  if (diffSeconds < 604800) return `${Math.floor(diffSeconds / 86400)} days ago`;
  return then.toLocaleDateString();
}
```

### 4. Test Display Colors

Assign colors to tests based on category or use a consistent color scheme:

**Suggested Color Mapping:**
- Hematology tests: `#FEE2E2` (light red)
- Biochemistry tests: `#DBEAFE` (light blue)
- Urinalysis tests: `#D1FAE5` (light green)
- Microbiology tests: `#E9D5FF` (light purple)
- Serology tests: `#FED7AA` (light orange)
- Endocrinology tests: `#FCE7F3` (light pink)

Or use a hash-based color assignment for consistency:
```javascript
function getTestColor(testCode) {
  const colors = ['#FEE2E2', '#DBEAFE', '#D1FAE5', '#E9D5FF', '#FED7AA', '#FCE7F3'];
  const hash = testCode.split('').reduce((acc, char) => acc + char.charCodeAt(0), 0);
  return colors[hash % colors.length];
}
```

### 5. Status and Priority Colors

**Status Colors:**
- `New`: `#DC2626` (red)
- `In Progress`: `#059669` (green)
- `Completed`: `#059669` (green)
- `On Hold`: `#EA580C` (orange)
- `Cancelled`: `#6B7280` (gray)

**Priority Colors:**
- `STAT`: `#DC2626` (red)
- `URGENT`: `#DC2626` (red)
- `ROUTINE`: `#059669` (green)
- `DELAYED`: `#EA580C` (orange)

### 6. Pagination

Implement standard pagination:
- Calculate `total_pages = CEIL(total_items / items_per_page)`
- Include `has_next` and `has_previous` flags
- Default page size: 20
- Maximum page size: 100
- Use efficient COUNT queries or materialized views for total count

### 7. Sorting

Default sorting: `created_at DESC` (newest first)

Supported sort fields:
- `created_at`: Request creation timestamp
- `request_date`: Request date
- `priority`: Priority level (STAT > URGENT > ROUTINE > DELAYED)
- `status`: Status (New > In Progress > Completed > On Hold > Cancelled)
- `patient_name`: Patient name alphabetically

---

## Performance Requirements

### Response Time Targets

| Endpoint | Target Response Time (P95) |
|----------|---------------------------|
| Today's Overview | < 100ms |
| List Requests | < 300ms |
| Get Request by ID | < 200ms |
| Get Departments | < 150ms |
| Export | < 2s (for up to 1000 records) |

### Optimization Strategies

1. **Database Indexes**: Ensure all filter and sort fields are indexed
2. **Query Optimization**: Use JOINs efficiently, avoid N+1 queries
3. **Caching**: Cache today's overview metrics for 30-60 seconds
4. **Materialized Views**: Consider materialized views for aggregated metrics
5. **Connection Pooling**: Use connection pooling for database connections
6. **Pagination**: Always use LIMIT/OFFSET or cursor-based pagination

---

## Error Handling

### Standard Error Response Format

```json
{
  "success": false,
  "message": "Human-readable error message",
  "error": "Technical error details",
  "status_code": 400,
  "errors": [
    {
      "field": "status",
      "message": "Invalid status value. Must be one of: New, In Progress, Completed, On Hold, Cancelled"
    }
  ]
}
```

### HTTP Status Codes

- `200 OK`: Successful request
- `400 Bad Request`: Invalid query parameters or request body
- `401 Unauthorized`: Authentication required
- `403 Forbidden`: User lacks permission
- `404 Not Found`: Resource not found
- `500 Internal Server Error`: Server error
- `503 Service Unavailable`: Service temporarily unavailable

### Error Codes

| Code | HTTP Status | Description |
|------|-------------|-------------|
| `REQUEST_NOT_FOUND` | 404 | Lab test request not found |
| `INVALID_STATUS` | 400 | Invalid status value |
| `INVALID_PRIORITY` | 400 | Invalid priority value |
| `INVALID_STATUS_TRANSITION` | 400 | Invalid status transition |
| `UNAUTHORIZED` | 401 | Authentication required |
| `FORBIDDEN` | 403 | User lacks permission to perform action |
| `VALIDATION_ERROR` | 400 | Request validation failed |

---

## Security Requirements

### Authentication
- All endpoints require valid JWT token
- Token must include user role (lab_technician, lab_manager, doctor, etc.)

### Authorization
- Lab staff can view all requests
- Lab staff can update status of requests
- Only ordering doctors can view their own requests (if needed)
- Export functionality may require additional permissions

### Data Protection
- All PII must be encrypted at rest (AES-256)
- TLS 1.3 required for all API calls
- API rate limiting: 100 requests/minute per user
- Session timeout: 30 minutes

### Audit Trail
- Log all status changes
- Log all exports
- Log all views (optional, for analytics)
- Include IP address and user agent in audit logs

---

## Frontend Integration Notes

### Today's Overview Section

The frontend expects the following structure:
```dart
{
  "total_requests": 24,  // Displayed in first card
  "urgent": 5,           // Displayed in second card (red)
  "in_progress": 12,     // Displayed in third card (orange)
  "completed": 18        // Displayed in fourth card (green)
}
```

### Request List Items

Each request item should include:
- Patient name, ID, and demographics (formatted as "F, 34" or "M, 45")
- Array of tests with names and colors for chip display
- Priority badge text and color
- Status badge text and color
- Doctor info formatted as "Dr. Smith - Emergency"
- Time ago string (e.g., "2 hours ago")
- Status indicator color (for the dot)

### Filter Integration

The frontend sends filter values as:
- `status`: "All", "Urgent", "In Progress", "Completed"
- `priority`: "All", "High", "Medium", "Low"
- `department`: "All Departments", "Emergency", "Cardiology", "Internal Med"

Map these to database values accordingly.

---

## Testing Requirements

### Unit Tests

Test the following scenarios:
1. Retrieve today's overview metrics
2. List requests with default pagination
3. Filter by status
4. Filter by priority
5. Filter by department
6. Search by patient name
7. Search by patient ID
8. Search by test name
9. Sort by different fields
10. Get request by ID (exists)
11. Get request by ID (does not exist)
12. Update request status
13. Invalid filter parameters
14. Invalid status transitions
15. Export functionality

### Integration Tests

1. Database connectivity
2. Query performance with indexes
3. Pagination accuracy
4. Search accuracy across multiple fields
5. Filter combinations
6. Concurrent requests handling

### Performance Tests

1. Response time under load (100+ concurrent users)
2. Large dataset pagination (10,000+ requests)
3. Search performance with large datasets
4. Export performance with large datasets

---

## Additional Notes

1. **Request Number Generation**: Generate unique request numbers in format `LR-YYYY-NNNNNN` where YYYY is the year and NNNNNN is a 6-digit sequential number
2. **Soft Deletes**: Never hard delete requests. Use soft delete with `is_deleted` flag
3. **Audit Trail**: Maintain complete audit trail for compliance
4. **Real-time Updates**: Consider WebSocket or Server-Sent Events for real-time updates
5. **Notifications**: Send notifications when:
   - New urgent request is created
   - Request status changes
   - Request is completed
6. **Data Retention**: Maintain requests according to healthcare data retention policies (typically 7-10 years minimum)

---

## Version History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0.0 | 2024-01-15 | Development Team | Initial specification |

---

**END OF DOCUMENT**

