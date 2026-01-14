# Backend API Guide: Nurse Encounter Note System

## Overview

This document provides comprehensive specifications for implementing the backend API to support the Nurse Encounter Note feature. This system allows nurses to create structured assessment notes for patients before doctor review.

---

## ⚠️ LEGAL & COMPLIANCE REQUIREMENTS (CRITICAL)

### Regulatory Compliance
- **HIPAA Compliance**: All encounter note data must be encrypted at rest and in transit
- **Audit Trail**: Every action must be logged with timestamp, user ID, and IP address
- **Data Retention**: Notes must be retained according to local healthcare regulations (typically 7-10 years minimum)

### Document Integrity Rules

| Rule | Description |
|------|-------------|
| **Immutability After Review** | Once a doctor has reviewed/signed the note, the original content CANNOT be modified |
| **Timestamp Required** | All notes must have server-generated timestamps (do not trust client timestamps) |
| **Digital Signature** | Notes must be digitally signed by the creating nurse |
| **Addendum Only** | Corrections after doctor review require creating an ADDENDUM, never overwriting |
| **Version Control** | Maintain complete version history of all changes before doctor review |

### Addendum Requirements
```
- Addendums must reference the original note ID
- Addendums must include reason for correction
- Addendums are timestamped and signed separately
- Original note remains visible with "Amended" flag
```

---

## Database Schema

### 1. Main Encounter Note Table: `encounter_notes`

```sql
CREATE TABLE encounter_notes (
    -- Primary Identification
    id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    encounter_note_number   VARCHAR(50) UNIQUE NOT NULL,  -- Human-readable: EN-2026-000001
    
    -- Patient & Visit References
    patient_id              UUID NOT NULL REFERENCES patients(id),
    patient_mrn             VARCHAR(50) NOT NULL,
    visit_id                UUID REFERENCES visits(id),
    
    -- Creator Information
    created_by_nurse_id     UUID NOT NULL REFERENCES staff(id),
    created_by_nurse_name   VARCHAR(255) NOT NULL,  -- Denormalized for legal record
    created_by_nurse_license VARCHAR(100),          -- Nursing license number
    
    -- Encounter Details
    encounter_type          VARCHAR(50) NOT NULL,   -- 'Routine', 'Follow-up', 'Emergency', 'Consultation', 'Urgent'
    encounter_datetime      TIMESTAMP WITH TIME ZONE NOT NULL,
    
    -- Chief Complaint
    chief_complaint         TEXT,
    chief_complaint_preset  VARCHAR(255),           -- If selected from presets
    is_quoted_complaint     BOOLEAN DEFAULT FALSE,  -- True if patient's exact words
    
    -- Handoff Summary
    handoff_summary         TEXT,
    handoff_auto_generated  BOOLEAN DEFAULT TRUE,   -- False if nurse manually edited
    
    -- Notes for Doctor
    notes_for_doctor        TEXT,
    
    -- Status & Workflow
    status                  VARCHAR(50) NOT NULL DEFAULT 'draft',
    -- Possible values: 'draft', 'submitted', 'under_review', 'reviewed', 'signed', 'amended'
    
    -- Review Information
    reviewed_by_doctor_id   UUID REFERENCES staff(id),
    reviewed_by_doctor_name VARCHAR(255),
    reviewed_at             TIMESTAMP WITH TIME ZONE,
    doctor_comments         TEXT,
    
    -- Digital Signatures
    nurse_signature         TEXT,                   -- Digital signature hash
    nurse_signed_at         TIMESTAMP WITH TIME ZONE,
    doctor_signature        TEXT,
    doctor_signed_at        TIMESTAMP WITH TIME ZONE,
    
    -- Legal & Audit
    is_locked               BOOLEAN DEFAULT FALSE,  -- Locked after doctor signs
    locked_at               TIMESTAMP WITH TIME ZONE,
    locked_reason           VARCHAR(255),
    
    -- Timestamps
    created_at              TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at              TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    submitted_at            TIMESTAMP WITH TIME ZONE,
    
    -- Soft Delete
    is_deleted              BOOLEAN DEFAULT FALSE,
    deleted_at              TIMESTAMP WITH TIME ZONE,
    deleted_by              UUID REFERENCES staff(id),
    deletion_reason         TEXT,
    
    -- Indexes
    CONSTRAINT chk_status CHECK (status IN ('draft', 'submitted', 'under_review', 'reviewed', 'signed', 'amended'))
);

-- Indexes for performance
CREATE INDEX idx_encounter_notes_patient ON encounter_notes(patient_id);
CREATE INDEX idx_encounter_notes_nurse ON encounter_notes(created_by_nurse_id);
CREATE INDEX idx_encounter_notes_status ON encounter_notes(status);
CREATE INDEX idx_encounter_notes_datetime ON encounter_notes(encounter_datetime);
CREATE INDEX idx_encounter_notes_created ON encounter_notes(created_at);
```

### 2. Pain Assessment Table: `encounter_pain_assessments`

```sql
CREATE TABLE encounter_pain_assessments (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    encounter_note_id   UUID NOT NULL REFERENCES encounter_notes(id) ON DELETE CASCADE,
    
    pain_score          INTEGER CHECK (pain_score >= 0 AND pain_score <= 10),
    pain_location       VARCHAR(100),
    -- Values: 'Head', 'Neck', 'Chest', 'Upper Back', 'Lower Back', 'Abdomen',
    --         'Left Arm', 'Right Arm', 'Left Leg', 'Right Leg', 'Shoulder',
    --         'Hip', 'Joints', 'Generalized', 'Other'
    
    pain_type           VARCHAR(100),
    -- Values: 'Sharp', 'Dull', 'Throbbing', 'Burning', 'Stabbing',
    --         'Aching', 'Cramping', 'Shooting', 'Tingling', 'Pressure'
    
    pain_duration       VARCHAR(100),
    -- Values: 'Just started', 'Few hours', '1 day', '2-3 days',
    --         '1 week', '2+ weeks', 'Chronic (months)', 'Intermittent'
    
    additional_notes    TEXT,
    
    created_at          TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
```

### 3. Allergies Table: `encounter_allergies`

```sql
CREATE TABLE encounter_allergies (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    encounter_note_id   UUID NOT NULL REFERENCES encounter_notes(id) ON DELETE CASCADE,
    
    allergy_type        VARCHAR(50) NOT NULL,  -- 'drug', 'food', 'other'
    allergen_name       VARCHAR(255) NOT NULL,
    reaction_type       VARCHAR(100) NOT NULL,
    -- Values: 'Rash', 'Hives', 'Itching', 'Swelling', 'Anaphylaxis',
    --         'Breathing difficulty', 'Nausea/Vomiting', 'Diarrhea', 'Other'
    
    severity            VARCHAR(50),           -- 'mild', 'moderate', 'severe', 'life-threatening'
    
    created_at          TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_allergy_type CHECK (allergy_type IN ('drug', 'food', 'other'))
);

-- For patients with no known allergies
ALTER TABLE encounter_notes ADD COLUMN no_known_allergies BOOLEAN DEFAULT FALSE;
```

### 4. Presenting Symptoms Table: `encounter_symptoms`

```sql
CREATE TABLE encounter_symptoms (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    encounter_note_id   UUID NOT NULL REFERENCES encounter_notes(id) ON DELETE CASCADE,
    
    symptom_name        VARCHAR(255) NOT NULL,
    -- Values: 'Fever', 'Cough', 'Shortness of Breath', 'Chest Pain', 'Headache',
    --         'Nausea/Vomiting', 'Abdominal Pain', 'Dizziness', 'Fatigue', 'Pain',
    --         'Bleeding', 'Rash', 'Loss of Appetite', 'Chills', 'Sweating', 'Weakness'
    
    duration            VARCHAR(100),
    -- Values: 'Just started', 'Few hours', '1 day', '2-3 days',
    --         '1 week', '2+ weeks', 'Chronic'
    
    severity_score      INTEGER CHECK (severity_score >= 1 AND severity_score <= 10),
    
    -- Optional: SNOMED CT or ICD-10 coding
    snomed_code         VARCHAR(50),
    icd10_code          VARCHAR(20),
    
    created_at          TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
```

### 5. Patient Condition Table: `encounter_patient_conditions`

```sql
CREATE TABLE encounter_patient_conditions (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    encounter_note_id   UUID NOT NULL REFERENCES encounter_notes(id) ON DELETE CASCADE,
    
    -- Overall Condition
    overall_condition   VARCHAR(100),
    -- Values: 'Stable', 'Stable but requires monitoring',
    --         'Unstable - requires immediate attention', 'Critical'
    
    -- Alertness/Orientation
    alertness_level     VARCHAR(100),
    -- Values: 'Alert and oriented x4', 'Alert and oriented x3',
    --         'Alert and oriented x2', 'Alert and oriented x1',
    --         'Confused', 'Lethargic', 'Unresponsive'
    
    -- Distress Level
    distress_level      VARCHAR(100),
    -- Values: 'No distress', 'Mild distress', 'Moderate distress', 'Severe distress'
    
    created_at          TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
```

### 6. Physical Appearance Table: `encounter_appearances`

```sql
CREATE TABLE encounter_appearances (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    encounter_note_id   UUID NOT NULL REFERENCES encounter_notes(id) ON DELETE CASCADE,
    
    appearance          VARCHAR(100) NOT NULL,
    -- Values: 'Well-appearing', 'Mildly distressed', 'Moderately distressed',
    --         'Severely distressed', 'Pale', 'Diaphoretic', 'Cyanotic'
    
    created_at          TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
```

### 7. Clinical Observations Table: `encounter_observations`

```sql
CREATE TABLE encounter_observations (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    encounter_note_id   UUID NOT NULL REFERENCES encounter_notes(id) ON DELETE CASCADE,
    
    observation         VARCHAR(255) NOT NULL,
    -- Values: 'Alert and oriented', 'Follows commands', 'Normal speech',
    --         'No acute distress', 'Moving all extremities'
    
    created_at          TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Additional observations notes
ALTER TABLE encounter_notes ADD COLUMN observations_notes TEXT;
```

### 8. Custom Sections Table: `encounter_custom_sections`

```sql
CREATE TABLE encounter_custom_sections (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    encounter_note_id   UUID NOT NULL REFERENCES encounter_notes(id) ON DELETE CASCADE,
    
    section_title       VARCHAR(255) NOT NULL,
    section_icon        VARCHAR(100),          -- Icon identifier
    section_color       VARCHAR(20),           -- Hex color code
    
    created_at          TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE encounter_custom_section_items (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    custom_section_id   UUID NOT NULL REFERENCES encounter_custom_sections(id) ON DELETE CASCADE,
    
    item_type           VARCHAR(50) NOT NULL,  -- 'option' or 'note'
    item_value          TEXT NOT NULL,
    is_selected         BOOLEAN DEFAULT FALSE, -- For options
    
    created_at          TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
```

### 9. Addendums Table: `encounter_note_addendums`

```sql
CREATE TABLE encounter_note_addendums (
    id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    encounter_note_id       UUID NOT NULL REFERENCES encounter_notes(id),
    
    -- Addendum Content
    addendum_text           TEXT NOT NULL,
    reason_for_addendum     TEXT NOT NULL,
    
    -- Creator Information
    created_by_id           UUID NOT NULL REFERENCES staff(id),
    created_by_name         VARCHAR(255) NOT NULL,
    created_by_role         VARCHAR(100) NOT NULL,  -- 'nurse' or 'doctor'
    
    -- Digital Signature
    signature               TEXT NOT NULL,
    signed_at               TIMESTAMP WITH TIME ZONE NOT NULL,
    
    -- Timestamps
    created_at              TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
    -- Cannot be deleted
    is_permanent            BOOLEAN DEFAULT TRUE
);
```

### 10. Audit Log Table: `encounter_note_audit_log`

```sql
CREATE TABLE encounter_note_audit_log (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    encounter_note_id   UUID NOT NULL REFERENCES encounter_notes(id),
    
    action              VARCHAR(100) NOT NULL,
    -- Actions: 'created', 'updated', 'submitted', 'reviewed', 'signed',
    --          'locked', 'addendum_added', 'viewed', 'printed', 'exported'
    
    action_details      JSONB,                 -- Detailed change information
    previous_values     JSONB,                 -- For updates, store previous values
    new_values          JSONB,                 -- For updates, store new values
    
    performed_by_id     UUID NOT NULL REFERENCES staff(id),
    performed_by_name   VARCHAR(255) NOT NULL,
    performed_by_role   VARCHAR(100) NOT NULL,
    
    ip_address          INET,
    user_agent          TEXT,
    
    created_at          TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Index for quick lookups
CREATE INDEX idx_audit_log_encounter ON encounter_note_audit_log(encounter_note_id);
CREATE INDEX idx_audit_log_action ON encounter_note_audit_log(action);
CREATE INDEX idx_audit_log_user ON encounter_note_audit_log(performed_by_id);
CREATE INDEX idx_audit_log_timestamp ON encounter_note_audit_log(created_at);
```

---

## API Endpoints

### Base URL
```
/api/v1/encounter-notes
```

### 1. Create Encounter Note (Draft)

```http
POST /api/v1/encounter-notes
```

**Request Body:**
```json
{
  "patient_id": "uuid",
  "visit_id": "uuid (optional)",
  "encounter_type": "Routine | Follow-up | Emergency | Consultation | Urgent",
  "encounter_datetime": "2026-01-11T14:30:00Z",
  
  "chief_complaint": {
    "text": "Headache and fever for 3 days",
    "preset": "Acute illness",
    "is_quoted": true
  },
  
  "pain_assessment": {
    "score": 7,
    "location": "Head",
    "type": "Throbbing",
    "duration": "2-3 days",
    "notes": "Worse in the morning"
  },
  
  "allergies": {
    "no_known_allergies": false,
    "items": [
      {
        "type": "drug",
        "name": "Penicillin",
        "reaction": "Rash",
        "severity": "moderate"
      },
      {
        "type": "food",
        "name": "Peanuts",
        "reaction": "Anaphylaxis",
        "severity": "life-threatening"
      }
    ]
  },
  
  "symptoms": [
    {
      "name": "Fever",
      "duration": "2-3 days",
      "severity": 7
    },
    {
      "name": "Headache",
      "duration": "2-3 days",
      "severity": 8
    }
  ],
  
  "patient_condition": {
    "overall_condition": "Stable but requires monitoring",
    "alertness_level": "Alert and oriented x4",
    "distress_level": "Mild distress"
  },
  
  "appearances": [
    "Mildly distressed",
    "Diaphoretic"
  ],
  
  "observations": {
    "items": [
      "Alert and oriented",
      "Follows commands",
      "Normal speech"
    ],
    "additional_notes": "Patient appears fatigued but cooperative"
  },
  
  "notes_for_doctor": "Patient has history of migraines. Current presentation seems more severe than usual episodes.",
  
  "handoff_summary": "42y male presenting with \"headache and fever for 3 days\".\nSymptoms: Fever (2-3 days), Headache (2-3 days).\nPain 7/10 head, throbbing.\nPatient stable but requires monitoring, mild distress.\nAllergies: Penicillin, Peanuts.\nAwaiting medical review.",
  "handoff_auto_generated": false,
  
  "custom_sections": [
    {
      "title": "Social History",
      "icon": "psychology_rounded",
      "color": "#8B5CF6",
      "options": [
        { "value": "Smokes", "selected": false },
        { "value": "Drinks alcohol", "selected": true }
      ],
      "notes": "Social drinker, weekends only"
    }
  ],
  
  "status": "draft"
}
```

**Response (201 Created):**
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "encounter_note_number": "EN-2026-000001",
    "status": "draft",
    "created_at": "2026-01-11T14:35:00Z",
    "created_by": {
      "id": "uuid",
      "name": "Nurse Jane Smith",
      "license_number": "RN-12345"
    }
  },
  "message": "Encounter note draft created successfully"
}
```

### 2. Update Encounter Note (Draft Only)

```http
PUT /api/v1/encounter-notes/{id}
```

**Note:** Only allowed when `status = 'draft'` and `is_locked = false`

**Request Body:** Same as create, with partial updates allowed

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "encounter_note_number": "EN-2026-000001",
    "status": "draft",
    "updated_at": "2026-01-11T14:40:00Z",
    "version": 2
  },
  "message": "Encounter note updated successfully"
}
```

**Error Response (403 Forbidden):**
```json
{
  "success": false,
  "error": {
    "code": "NOTE_LOCKED",
    "message": "This encounter note has been reviewed and cannot be modified. Please create an addendum instead."
  }
}
```

### 3. Submit Encounter Note for Doctor Review

```http
POST /api/v1/encounter-notes/{id}/submit
```

**Request Body:**
```json
{
  "nurse_signature": "digital_signature_hash",
  "confirmation": true
}
```

**Business Rules:**
- Chief complaint is required
- At least one symptom or observation must be recorded
- Handoff summary must not be empty

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "encounter_note_number": "EN-2026-000001",
    "status": "submitted",
    "submitted_at": "2026-01-11T14:45:00Z",
    "nurse_signed_at": "2026-01-11T14:45:00Z"
  },
  "message": "Encounter note submitted for doctor review"
}
```

### 4. Get Encounter Note by ID

```http
GET /api/v1/encounter-notes/{id}
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "encounter_note_number": "EN-2026-000001",
    "patient": {
      "id": "uuid",
      "mrn": "MRN-001234",
      "name": "John Doe",
      "age": 42,
      "gender": "Male"
    },
    "encounter_type": "Emergency",
    "encounter_datetime": "2026-01-11T14:30:00Z",
    "chief_complaint": {
      "text": "Headache and fever for 3 days",
      "is_quoted": true
    },
    "pain_assessment": { ... },
    "allergies": { ... },
    "symptoms": [ ... ],
    "patient_condition": { ... },
    "appearances": [ ... ],
    "observations": { ... },
    "notes_for_doctor": "...",
    "handoff_summary": "...",
    "custom_sections": [ ... ],
    "status": "submitted",
    "created_by": {
      "id": "uuid",
      "name": "Nurse Jane Smith",
      "license_number": "RN-12345"
    },
    "created_at": "2026-01-11T14:35:00Z",
    "submitted_at": "2026-01-11T14:45:00Z",
    "nurse_signed_at": "2026-01-11T14:45:00Z",
    "is_locked": false,
    "addendums": [],
    "audit_trail": [
      {
        "action": "created",
        "performed_by": "Nurse Jane Smith",
        "timestamp": "2026-01-11T14:35:00Z"
      },
      {
        "action": "submitted",
        "performed_by": "Nurse Jane Smith",
        "timestamp": "2026-01-11T14:45:00Z"
      }
    ]
  }
}
```

### 5. List Encounter Notes

```http
GET /api/v1/encounter-notes
```

**Query Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| `patient_id` | UUID | Filter by patient |
| `nurse_id` | UUID | Filter by creating nurse |
| `doctor_id` | UUID | Filter by reviewing doctor |
| `status` | String | Filter by status |
| `encounter_type` | String | Filter by encounter type |
| `date_from` | DateTime | Filter from date |
| `date_to` | DateTime | Filter to date |
| `page` | Integer | Page number (default: 1) |
| `limit` | Integer | Items per page (default: 20, max: 100) |
| `sort_by` | String | Sort field (default: created_at) |
| `sort_order` | String | 'asc' or 'desc' (default: desc) |

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "items": [ ... ],
    "pagination": {
      "total": 150,
      "page": 1,
      "limit": 20,
      "total_pages": 8
    }
  }
}
```

### 6. Doctor Review & Sign

```http
POST /api/v1/encounter-notes/{id}/review
```

**Request Body:**
```json
{
  "action": "sign",
  "doctor_comments": "Reviewed. Patient requires blood work and CT scan.",
  "doctor_signature": "digital_signature_hash"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "status": "signed",
    "is_locked": true,
    "locked_at": "2026-01-11T15:00:00Z",
    "reviewed_by": {
      "id": "uuid",
      "name": "Dr. Michael Brown"
    },
    "reviewed_at": "2026-01-11T15:00:00Z",
    "doctor_signed_at": "2026-01-11T15:00:00Z"
  },
  "message": "Encounter note reviewed and signed. Note is now locked."
}
```

### 7. Create Addendum (Post-Sign Corrections)

```http
POST /api/v1/encounter-notes/{id}/addendums
```

**Note:** Only allowed when `is_locked = true`

**Request Body:**
```json
{
  "addendum_text": "Correction: Patient's pain score was incorrectly recorded as 7. The correct score is 9.",
  "reason_for_addendum": "Data entry error during initial assessment",
  "signature": "digital_signature_hash"
}
```

**Response (201 Created):**
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "encounter_note_id": "uuid",
    "addendum_text": "...",
    "reason_for_addendum": "...",
    "created_by": {
      "id": "uuid",
      "name": "Nurse Jane Smith",
      "role": "nurse"
    },
    "created_at": "2026-01-11T16:00:00Z",
    "signed_at": "2026-01-11T16:00:00Z"
  },
  "message": "Addendum added successfully. Original note remains unchanged."
}
```

### 8. Get Audit Trail

```http
GET /api/v1/encounter-notes/{id}/audit-trail
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": [
    {
      "id": "uuid",
      "action": "created",
      "action_details": {
        "description": "Encounter note created as draft"
      },
      "performed_by": {
        "id": "uuid",
        "name": "Nurse Jane Smith",
        "role": "nurse"
      },
      "ip_address": "192.168.1.100",
      "created_at": "2026-01-11T14:35:00Z"
    },
    {
      "id": "uuid",
      "action": "updated",
      "action_details": {
        "description": "Pain assessment updated",
        "fields_changed": ["pain_score", "pain_notes"]
      },
      "previous_values": {
        "pain_score": 5,
        "pain_notes": null
      },
      "new_values": {
        "pain_score": 7,
        "pain_notes": "Worse in the morning"
      },
      "performed_by": {
        "id": "uuid",
        "name": "Nurse Jane Smith",
        "role": "nurse"
      },
      "created_at": "2026-01-11T14:40:00Z"
    }
  ]
}
```

### 9. Delete Encounter Note (Draft Only)

```http
DELETE /api/v1/encounter-notes/{id}
```

**Note:** Only allowed when `status = 'draft'`

**Request Body:**
```json
{
  "reason": "Created in error - duplicate entry"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Encounter note deleted successfully"
}
```

**Error Response (403 Forbidden):**
```json
{
  "success": false,
  "error": {
    "code": "CANNOT_DELETE",
    "message": "Submitted or signed encounter notes cannot be deleted. They are legal medical records."
  }
}
```

---

## Workflow State Machine

```
                                    ┌─────────────────┐
                                    │                 │
                                    ▼                 │
┌─────────┐     ┌───────────┐     ┌──────────────┐   │   ┌──────────┐
│  draft  │────▶│ submitted │────▶│ under_review │───┼──▶│  signed  │
└─────────┘     └───────────┘     └──────────────┘   │   └──────────┘
     │                                               │         │
     │                                               │         │
     ▼                                               │         ▼
┌─────────┐                                          │   ┌──────────┐
│ deleted │                                          └──▶│ amended  │
└─────────┘                                              └──────────┘
                                                               │
                                                               │
                                                         (addendum added)
```

### State Transitions:

| From | To | Trigger | Allowed By |
|------|------|---------|------------|
| `draft` | `submitted` | Nurse submits | Nurse (creator) |
| `draft` | `deleted` | Nurse deletes | Nurse (creator) |
| `submitted` | `under_review` | Doctor opens | Doctor |
| `under_review` | `signed` | Doctor signs | Doctor |
| `under_review` | `submitted` | Doctor returns for edits | Doctor |
| `signed` | `amended` | Addendum added | Nurse or Doctor |

---

## Validation Rules

### Chief Complaint
- Required for submission
- Max length: 1000 characters
- If `is_quoted = true`, store exactly as entered

### Pain Assessment
- `pain_score`: Integer 0-10
- `pain_location`: Must be from allowed values
- `pain_type`: Must be from allowed values

### Allergies
- If `no_known_allergies = true`, `items` must be empty
- Each allergy requires `type`, `name`, and `reaction`

### Symptoms
- `severity`: Integer 1-10
- `duration`: Must be from allowed values

### Handoff Summary
- Required for submission
- Max length: 5000 characters

---

## Error Codes

| Code | HTTP Status | Description |
|------|-------------|-------------|
| `NOTE_NOT_FOUND` | 404 | Encounter note not found |
| `NOTE_LOCKED` | 403 | Note is locked and cannot be modified |
| `CANNOT_DELETE` | 403 | Cannot delete submitted/signed notes |
| `INVALID_STATUS_TRANSITION` | 400 | Invalid workflow state change |
| `VALIDATION_ERROR` | 400 | Request validation failed |
| `UNAUTHORIZED` | 401 | Authentication required |
| `FORBIDDEN` | 403 | User lacks permission |
| `SIGNATURE_REQUIRED` | 400 | Digital signature is required |
| `DUPLICATE_SUBMISSION` | 409 | Note already submitted |

---

## Security Requirements

### Authentication
- All endpoints require valid JWT token
- Token must include user role (nurse/doctor)

### Authorization
- Nurses can only edit their own draft notes
- Doctors can review any submitted note
- Only admins can view deleted notes
- Audit trails are read-only

### Data Protection
- All PII must be encrypted at rest (AES-256)
- TLS 1.3 required for all API calls
- API rate limiting: 100 requests/minute
- Session timeout: 30 minutes

---

## Notification Events

Publish events for real-time updates:

| Event | Trigger | Notify |
|-------|---------|--------|
| `encounter_note.created` | New note created | Assigned doctor |
| `encounter_note.submitted` | Note submitted for review | Doctor on duty |
| `encounter_note.reviewed` | Doctor completed review | Creating nurse |
| `encounter_note.signed` | Doctor signed note | Creating nurse, Patient portal |
| `encounter_note.addendum_added` | Addendum created | All parties |

---

## Integration Points

### 1. Patient Service
- Validate patient exists
- Fetch patient demographics
- Update patient's encounter history

### 2. Staff Service
- Validate nurse/doctor credentials
- Fetch license numbers
- Verify signing authority

### 3. Vitals Service
- Link to vitals recorded during same visit
- Auto-populate recent vitals in summary

### 4. Document Service
- Generate PDF for printing
- Store signed documents

### 5. Notification Service
- Send real-time notifications
- Email summaries to doctors

---

## Performance Requirements

| Metric | Target |
|--------|--------|
| API Response Time (P95) | < 200ms |
| API Response Time (P99) | < 500ms |
| Database Query Time | < 50ms |
| Concurrent Users | 500+ |
| Uptime | 99.9% |

---

## Appendix: SNOMED CT / ICD-10 Codes (Optional Enhancement)

For enhanced interoperability, consider mapping symptoms to standard codes:

| Symptom | SNOMED CT | ICD-10 |
|---------|-----------|--------|
| Fever | 386661006 | R50.9 |
| Headache | 25064002 | R51 |
| Cough | 49727002 | R05 |
| Chest Pain | 29857009 | R07.9 |
| Shortness of Breath | 267036007 | R06.0 |
| Nausea | 422587007 | R11.0 |
| Abdominal Pain | 21522001 | R10.9 |
| Dizziness | 404640003 | R42 |
| Fatigue | 84229001 | R53.83 |

---

## Version History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0.0 | 2026-01-11 | Development Team | Initial specification |

---

**END OF DOCUMENT**

