# Backend Lab Test Catalog API Guide

This document provides comprehensive instructions for implementing the Lab Test Catalog API endpoint that will return the list of available lab tests for the EMR system.

## Overview

The Lab Test Catalog API provides a standardized list of laboratory tests that doctors can order for patients. Each test includes metadata such as LOINC codes, categories, descriptions, and other relevant information.

---

## Database Schema

### Table: `lab_test_catalog`

```sql
CREATE TABLE lab_test_catalog (
    -- Primary Identification
    id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    test_code               VARCHAR(50) UNIQUE NOT NULL,  -- Short code: 'FBC', 'LFT', etc.
    test_name               VARCHAR(255) NOT NULL,        -- Full name: 'Full Blood Count'
    
    -- Standardization
    loinc_code              VARCHAR(50) NOT NULL,         -- LOINC code: '57021-8'
    loinc_description       TEXT,                         -- Official LOINC description
    
    -- Categorization
    category                VARCHAR(100) NOT NULL,        -- 'Hematology', 'Biochemistry', etc.
    subcategory             VARCHAR(100),                 -- Optional subcategory
    
    -- Clinical Information
    description             TEXT,                         -- User-friendly description
    clinical_indication     TEXT,                         -- When this test is typically ordered
    specimen_type           VARCHAR(50),                  -- 'Blood', 'Urine', 'CSF', etc.
    sample_volume           VARCHAR(50),                  -- Required sample volume
    
    -- Turnaround & Logistics
    routine_turnaround      INTEGER,                      -- Hours for routine priority
    urgent_turnaround       INTEGER,                      -- Hours for urgent priority
    stat_turnaround         INTEGER,                      -- Hours for STAT priority
    
    -- Cost & Billing
    base_cost               DECIMAL(10, 2),               -- Base cost of the test
    currency                VARCHAR(3) DEFAULT 'USD',     -- Currency code
    
    -- Status & Metadata
    is_active               BOOLEAN DEFAULT TRUE,         -- Whether test is currently available
    requires_fasting        BOOLEAN DEFAULT FALSE,        -- Fasting required
    requires_special_handling BOOLEAN DEFAULT FALSE,      -- Special handling required
    
    -- Audit Fields
    created_at              TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at              TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    created_by              UUID REFERENCES staff(id),
    updated_by              UUID REFERENCES staff(id),
    
    -- Indexes
    CONSTRAINT unique_test_code UNIQUE (test_code),
    CONSTRAINT unique_loinc UNIQUE (loinc_code)
);

-- Indexes for performance
CREATE INDEX idx_lab_test_catalog_category ON lab_test_catalog(category);
CREATE INDEX idx_lab_test_catalog_active ON lab_test_catalog(is_active);
CREATE INDEX idx_lab_test_catalog_loinc ON lab_test_catalog(loinc_code);
CREATE INDEX idx_lab_test_catalog_name ON lab_test_catalog USING gin(to_tsvector('english', test_name));
```

---

## API Endpoints

### 1. Get All Lab Tests (Catalog)

**Endpoint:** `GET /api/lab-tests/catalog`

**Description:** Returns a paginated list of all available lab tests from the catalog.

**Query Parameters:**

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `page` | integer | No | 1 | Page number for pagination |
| `limit` | integer | No | 100 | Number of items per page (max: 500) |
| `category` | string | No | - | Filter by category (e.g., 'Hematology') |
| `search` | string | No | - | Search by test name, code, or LOINC code |
| `is_active` | boolean | No | true | Filter by active status |
| `specimen_type` | string | No | - | Filter by specimen type |

**Response Format:**

```json
{
  "success": true,
  "message": "Lab tests retrieved successfully",
  "data": {
    "tests": [
      {
        "id": "550e8400-e29b-41d4-a716-446655440000",
        "test_code": "FBC",
        "test_name": "Full Blood Count",
        "loinc_code": "57021-8",
        "loinc_description": "CBC (Complete Blood Count) panel - Blood",
        "category": "Hematology",
        "subcategory": "Complete Blood Count",
        "description": "Complete blood count including WBC, RBC, Hemoglobin, Hematocrit, Platelets",
        "clinical_indication": "Routine screening, infection monitoring, anemia evaluation",
        "specimen_type": "Blood",
        "sample_volume": "2-3 ml",
        "routine_turnaround": 24,
        "urgent_turnaround": 4,
        "stat_turnaround": 1,
        "base_cost": 25.00,
        "currency": "USD",
        "is_active": true,
        "requires_fasting": false,
        "requires_special_handling": false,
        "created_at": "2024-01-15T10:30:00Z",
        "updated_at": "2024-01-15T10:30:00Z"
      },
      {
        "id": "550e8400-e29b-41d4-a716-446655440001",
        "test_code": "LFT",
        "test_name": "Liver Function Test",
        "loinc_code": "24323-8",
        "loinc_description": "Hepatic function panel - Serum or Plasma",
        "category": "Biochemistry",
        "subcategory": "Liver Function",
        "description": "ALT, AST, Bilirubin, Albumin, ALP",
        "clinical_indication": "Liver disease evaluation, medication monitoring",
        "specimen_type": "Blood",
        "sample_volume": "3-5 ml",
        "routine_turnaround": 24,
        "urgent_turnaround": 4,
        "stat_turnaround": 1,
        "base_cost": 45.00,
        "currency": "USD",
        "is_active": true,
        "requires_fasting": true,
        "requires_special_handling": false,
        "created_at": "2024-01-15T10:30:00Z",
        "updated_at": "2024-01-15T10:30:00Z"
      }
    ],
    "pagination": {
      "current_page": 1,
      "total_pages": 5,
      "total_items": 487,
      "items_per_page": 100,
      "has_next": true,
      "has_previous": false
    }
  }
}
```

**Success Status Code:** `200 OK`

**Error Response:**

```json
{
  "success": false,
  "message": "Failed to retrieve lab tests",
  "error": "Database connection error",
  "status_code": 500
}
```

---

### 2. Get Lab Test by ID

**Endpoint:** `GET /api/lab-tests/catalog/:id`

**Description:** Returns detailed information about a specific lab test.

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `id` | UUID | Yes | Lab test catalog ID |

**Response Format:**

```json
{
  "success": true,
  "message": "Lab test retrieved successfully",
  "data": {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "test_code": "FBC",
    "test_name": "Full Blood Count",
    "loinc_code": "57021-8",
    "loinc_description": "CBC (Complete Blood Count) panel - Blood",
    "category": "Hematology",
    "subcategory": "Complete Blood Count",
    "description": "Complete blood count including WBC, RBC, Hemoglobin, Hematocrit, Platelets",
    "clinical_indication": "Routine screening, infection monitoring, anemia evaluation",
    "specimen_type": "Blood",
    "sample_volume": "2-3 ml",
    "routine_turnaround": 24,
    "urgent_turnaround": 4,
    "stat_turnaround": 1,
    "base_cost": 25.00,
    "currency": "USD",
    "is_active": true,
    "requires_fasting": false,
    "requires_special_handling": false,
    "created_at": "2024-01-15T10:30:00Z",
    "updated_at": "2024-01-15T10:30:00Z"
  }
}
```

**Success Status Code:** `200 OK`

**Error Response (404):**

```json
{
  "success": false,
  "message": "Lab test not found",
  "error": "No lab test found with the provided ID",
  "status_code": 404
}
```

---

### 3. Get Categories

**Endpoint:** `GET /api/lab-tests/categories`

**Description:** Returns a list of all available test categories with counts.

**Response Format:**

```json
{
  "success": true,
  "message": "Categories retrieved successfully",
  "data": {
    "categories": [
      {
        "name": "Hematology",
        "count": 45,
        "description": "Blood and blood-forming organs"
      },
      {
        "name": "Biochemistry",
        "count": 78,
        "description": "Chemical analysis of body fluids"
      },
      {
        "name": "Urinalysis",
        "count": 23,
        "description": "Urine analysis"
      },
      {
        "name": "Microbiology",
        "count": 56,
        "description": "Microbial culture and identification"
      },
      {
        "name": "Serology",
        "count": 34,
        "description": "Antibody and antigen detection"
      },
      {
        "name": "Endocrinology",
        "count": 28,
        "description": "Hormone analysis"
      }
    ],
    "total_categories": 6
  }
}
```

**Success Status Code:** `200 OK`

---

## Sample Test Data

Here are the initial test records that should be seeded in the database:

### Hematology Tests

```json
[
  {
    "test_code": "FBC",
    "test_name": "Full Blood Count",
    "loinc_code": "57021-8",
    "loinc_description": "CBC (Complete Blood Count) panel - Blood",
    "category": "Hematology",
    "subcategory": "Complete Blood Count",
    "description": "Complete blood count including WBC, RBC, Hemoglobin, Hematocrit, Platelets",
    "clinical_indication": "Routine screening, infection monitoring, anemia evaluation",
    "specimen_type": "Blood",
    "sample_volume": "2-3 ml",
    "routine_turnaround": 24,
    "urgent_turnaround": 4,
    "stat_turnaround": 1,
    "base_cost": 25.00,
    "is_active": true,
    "requires_fasting": false
  },
  {
    "test_code": "HbA1c",
    "test_name": "Hemoglobin A1c",
    "loinc_code": "4548-4",
    "loinc_description": "Hemoglobin A1c/Hemoglobin.total in Blood",
    "category": "Hematology",
    "subcategory": "Glycated Hemoglobin",
    "description": "Glycated hemoglobin for diabetes monitoring",
    "clinical_indication": "Diabetes diagnosis and monitoring",
    "specimen_type": "Blood",
    "sample_volume": "2 ml",
    "routine_turnaround": 24,
    "urgent_turnaround": 6,
    "stat_turnaround": 2,
    "base_cost": 35.00,
    "is_active": true,
    "requires_fasting": false
  },
  {
    "test_code": "ESR",
    "test_name": "Erythrocyte Sedimentation Rate",
    "loinc_code": "4537-7",
    "loinc_description": "ESR - Erythrocyte sedimentation rate",
    "category": "Hematology",
    "subcategory": "Inflammation Marker",
    "description": "Inflammation marker",
    "clinical_indication": "Inflammation and infection monitoring",
    "specimen_type": "Blood",
    "sample_volume": "2 ml",
    "routine_turnaround": 24,
    "urgent_turnaround": 6,
    "stat_turnaround": 2,
    "base_cost": 15.00,
    "is_active": true,
    "requires_fasting": false
  }
]
```

### Biochemistry Tests

```json
[
  {
    "test_code": "LFT",
    "test_name": "Liver Function Test",
    "loinc_code": "24323-8",
    "loinc_description": "Hepatic function panel - Serum or Plasma",
    "category": "Biochemistry",
    "subcategory": "Liver Function",
    "description": "ALT, AST, Bilirubin, Albumin, ALP",
    "clinical_indication": "Liver disease evaluation, medication monitoring",
    "specimen_type": "Blood",
    "sample_volume": "3-5 ml",
    "routine_turnaround": 24,
    "urgent_turnaround": 4,
    "stat_turnaround": 1,
    "base_cost": 45.00,
    "is_active": true,
    "requires_fasting": true
  },
  {
    "test_code": "UEC",
    "test_name": "Urea, Electrolytes, Creatinine",
    "loinc_code": "24320-4",
    "loinc_description": "Basic metabolic panel - Serum or Plasma",
    "category": "Biochemistry",
    "subcategory": "Renal Function",
    "description": "Renal function panel",
    "clinical_indication": "Kidney function assessment, electrolyte balance",
    "specimen_type": "Blood",
    "sample_volume": "3-5 ml",
    "routine_turnaround": 24,
    "urgent_turnaround": 4,
    "stat_turnaround": 1,
    "base_cost": 40.00,
    "is_active": true,
    "requires_fasting": false
  },
  {
    "test_code": "LIPID",
    "test_name": "Lipid Panel",
    "loinc_code": "24331-1",
    "loinc_description": "Lipid panel - Serum or Plasma",
    "category": "Biochemistry",
    "subcategory": "Lipid Profile",
    "description": "Total Cholesterol, HDL, LDL, Triglycerides",
    "clinical_indication": "Cardiovascular risk assessment",
    "specimen_type": "Blood",
    "sample_volume": "3-5 ml",
    "routine_turnaround": 24,
    "urgent_turnaround": 6,
    "stat_turnaround": 2,
    "base_cost": 50.00,
    "is_active": true,
    "requires_fasting": true
  },
  {
    "test_code": "GLUCOSE",
    "test_name": "Blood Glucose",
    "loinc_code": "2339-0",
    "loinc_description": "Glucose [Mass/volume] in Blood",
    "category": "Biochemistry",
    "subcategory": "Carbohydrate Metabolism",
    "description": "Fasting or random blood sugar",
    "clinical_indication": "Diabetes screening and monitoring",
    "specimen_type": "Blood",
    "sample_volume": "1-2 ml",
    "routine_turnaround": 24,
    "urgent_turnaround": 2,
    "stat_turnaround": 1,
    "base_cost": 20.00,
    "is_active": true,
    "requires_fasting": true
  },
  {
    "test_code": "TROPONIN",
    "test_name": "Troponin I",
    "loinc_code": "6598-7",
    "loinc_description": "Troponin I.cardiac [Mass/volume] in Serum or Plasma",
    "category": "Biochemistry",
    "subcategory": "Cardiac Markers",
    "description": "Cardiac marker for myocardial injury",
    "clinical_indication": "Acute myocardial infarction diagnosis",
    "specimen_type": "Blood",
    "sample_volume": "2-3 ml",
    "routine_turnaround": 24,
    "urgent_turnaround": 2,
    "stat_turnaround": 1,
    "base_cost": 60.00,
    "is_active": true,
    "requires_fasting": false
  }
]
```

### Urinalysis Tests

```json
[
  {
    "test_code": "UA",
    "test_name": "Urinalysis",
    "loinc_code": "24356-8",
    "loinc_description": "Complete urinalysis panel - Urine",
    "category": "Urinalysis",
    "subcategory": "Complete Urinalysis",
    "description": "Protein, Glucose, Ketones, Blood, Microscopy",
    "clinical_indication": "UTI screening, kidney function, diabetes monitoring",
    "specimen_type": "Urine",
    "sample_volume": "10-20 ml",
    "routine_turnaround": 24,
    "urgent_turnaround": 4,
    "stat_turnaround": 2,
    "base_cost": 20.00,
    "is_active": true,
    "requires_fasting": false
  },
  {
    "test_code": "UCULT",
    "test_name": "Urine Culture",
    "loinc_code": "630-4",
    "loinc_description": "Bacteria identified in Urine by Culture",
    "category": "Urinalysis",
    "subcategory": "Culture",
    "description": "Bacterial culture and sensitivity",
    "clinical_indication": "UTI diagnosis and antibiotic selection",
    "specimen_type": "Urine",
    "sample_volume": "5-10 ml",
    "routine_turnaround": 72,
    "urgent_turnaround": 48,
    "stat_turnaround": 24,
    "base_cost": 35.00,
    "is_active": true,
    "requires_fasting": false
  }
]
```

### Microbiology Tests

```json
[
  {
    "test_code": "BLOOD_CULTURE",
    "test_name": "Blood Culture",
    "loinc_code": "600-7",
    "loinc_description": "Bacteria identified in Blood by Culture",
    "category": "Microbiology",
    "subcategory": "Culture",
    "description": "Bacterial culture from blood",
    "clinical_indication": "Sepsis diagnosis, bacteremia detection",
    "specimen_type": "Blood",
    "sample_volume": "10-20 ml",
    "routine_turnaround": 120,
    "urgent_turnaround": 72,
    "stat_turnaround": 48,
    "base_cost": 75.00,
    "is_active": true,
    "requires_fasting": false
  },
  {
    "test_code": "CSF",
    "test_name": "CSF Analysis",
    "loinc_code": "2956-1",
    "loinc_description": "Cerebrospinal fluid (CSF) panel",
    "category": "Microbiology",
    "subcategory": "CSF Analysis",
    "description": "Cerebrospinal fluid analysis",
    "clinical_indication": "Meningitis diagnosis, CNS infection",
    "specimen_type": "CSF",
    "sample_volume": "2-5 ml",
    "routine_turnaround": 48,
    "urgent_turnaround": 24,
    "stat_turnaround": 4,
    "base_cost": 90.00,
    "is_active": true,
    "requires_fasting": false,
    "requires_special_handling": true
  },
  {
    "test_code": "MALARIA",
    "test_name": "Malaria Parasite",
    "loinc_code": "51758-3",
    "loinc_description": "Plasmodium sp identified in Blood by Light microscopy",
    "category": "Microbiology",
    "subcategory": "Parasitology",
    "description": "Malaria parasite detection",
    "clinical_indication": "Malaria diagnosis",
    "specimen_type": "Blood",
    "sample_volume": "2-3 ml",
    "routine_turnaround": 24,
    "urgent_turnaround": 4,
    "stat_turnaround": 2,
    "base_cost": 30.00,
    "is_active": true,
    "requires_fasting": false
  }
]
```

### Serology Tests

```json
[
  {
    "test_code": "HIV",
    "test_name": "HIV Test",
    "loinc_code": "11041-1",
    "loinc_description": "HIV 1+2 Ab [Presence] in Serum or Plasma by Immunoassay",
    "category": "Serology",
    "subcategory": "Infectious Disease",
    "description": "HIV antibody/antigen test",
    "clinical_indication": "HIV screening and diagnosis",
    "specimen_type": "Blood",
    "sample_volume": "3-5 ml",
    "routine_turnaround": 48,
    "urgent_turnaround": 24,
    "stat_turnaround": 12,
    "base_cost": 40.00,
    "is_active": true,
    "requires_fasting": false
  },
  {
    "test_code": "HBsAg",
    "test_name": "Hepatitis B Surface Antigen",
    "loinc_code": "5195-3",
    "loinc_description": "HBsAg [Presence] in Serum or Plasma",
    "category": "Serology",
    "subcategory": "Hepatitis",
    "description": "Hepatitis B screening",
    "clinical_indication": "Hepatitis B screening and diagnosis",
    "specimen_type": "Blood",
    "sample_volume": "3-5 ml",
    "routine_turnaround": 48,
    "urgent_turnaround": 24,
    "stat_turnaround": 12,
    "base_cost": 35.00,
    "is_active": true,
    "requires_fasting": false
  },
  {
    "test_code": "COVID",
    "test_name": "COVID-19 PCR",
    "loinc_code": "94500-6",
    "loinc_description": "SARS-CoV-2 (COVID-19) RNA [Presence] in Respiratory specimen by NAA with probe detection",
    "category": "Serology",
    "subcategory": "Viral Detection",
    "description": "SARS-CoV-2 RNA detection",
    "clinical_indication": "COVID-19 diagnosis",
    "specimen_type": "Nasopharyngeal Swab",
    "sample_volume": "Swab",
    "routine_turnaround": 24,
    "urgent_turnaround": 6,
    "stat_turnaround": 2,
    "base_cost": 50.00,
    "is_active": true,
    "requires_fasting": false
  }
]
```

### Endocrinology Tests

```json
[
  {
    "test_code": "TSH",
    "test_name": "Thyroid Stimulating Hormone",
    "loinc_code": "3016-3",
    "loinc_description": "TSH [Units/volume] in Serum or Plasma",
    "category": "Endocrinology",
    "subcategory": "Thyroid Function",
    "description": "TSH level for thyroid function",
    "clinical_indication": "Thyroid dysfunction screening",
    "specimen_type": "Blood",
    "sample_volume": "2-3 ml",
    "routine_turnaround": 24,
    "urgent_turnaround": 6,
    "stat_turnaround": 2,
    "base_cost": 30.00,
    "is_active": true,
    "requires_fasting": false
  },
  {
    "test_code": "T4",
    "test_name": "Free T4",
    "loinc_code": "3024-7",
    "loinc_description": "T4 free [Mass/volume] in Serum or Plasma",
    "category": "Endocrinology",
    "subcategory": "Thyroid Function",
    "description": "Free thyroxine level",
    "clinical_indication": "Thyroid function assessment",
    "specimen_type": "Blood",
    "sample_volume": "2-3 ml",
    "routine_turnaround": 24,
    "urgent_turnaround": 6,
    "stat_turnaround": 2,
    "base_cost": 35.00,
    "is_active": true,
    "requires_fasting": false
  }
]
```

---

## Implementation Requirements

### 1. Search Functionality

The search should support:
- **Test name**: Full-text search on `test_name`
- **Test code**: Exact match or partial match on `test_code`
- **LOINC code**: Exact match on `loinc_code`
- **Category**: Filter by category name

**Example Search Query:**
```sql
SELECT * FROM lab_test_catalog
WHERE is_active = true
  AND (
    test_name ILIKE '%blood%'
    OR test_code ILIKE '%fbc%'
    OR loinc_code = '57021-8'
  )
ORDER BY test_name
LIMIT 100 OFFSET 0;
```

### 2. Pagination

Implement standard pagination:
- Calculate `total_pages = CEIL(total_items / items_per_page)`
- Include `has_next` and `has_previous` flags
- Default page size: 100
- Maximum page size: 500

### 3. Filtering

Support multiple filters:
- `category`: Filter by test category
- `is_active`: Show only active tests (default: true)
- `specimen_type`: Filter by required specimen type
- Filters should be combinable

### 4. Sorting

Default sorting: `test_name ASC`

Optional sorting fields:
- `test_name`
- `category`
- `test_code`
- `base_cost`

### 5. Response Performance

- Implement database indexes on frequently queried fields
- Use connection pooling
- Cache frequently accessed data (e.g., categories)
- Consider implementing Redis cache for catalog data (TTL: 1 hour)

---

## Frontend Integration

### Updated Frontend Code

Once the backend endpoint is ready, update the frontend to fetch from API instead of hardcoded data:

**Location:** `lib/doctor_lab_test_order.dart`

**Replace hardcoded catalog with API call:**

```dart
// Replace the hardcoded _testCatalog list with:
List<LabTest> _testCatalog = [];
bool _isLoadingCatalog = false;

@override
void initState() {
  super.initState();
  _loadPatient();
  _loadTestCatalog(); // Add this
  _searchController.addListener(() {
    setState(() {});
  });
}

Future<void> _loadTestCatalog() async {
  setState(() {
    _isLoadingCatalog = true;
  });

  try {
    final response = await ApiService.get('/api/lab-tests/catalog?limit=500&is_active=true');
    
    if (response.success && response.data != null) {
      final responseData = response.data as Map<String, dynamic>;
      final testsData = responseData['data'] as Map<String, dynamic>?;
      final testsList = testsData?['tests'] as List<dynamic>?;
      
      if (testsList != null) {
        setState(() {
          _testCatalog = testsList.map((test) {
            return LabTest(
              id: test['id'] ?? '',
              name: test['test_name'] ?? '',
              category: test['category'] ?? '',
              loincCode: test['loinc_code'] ?? '',
              description: test['description'] ?? '',
              testCode: test['test_code'] ?? '',
              specimenType: test['specimen_type'],
              requiresFasting: test['requires_fasting'] ?? false,
            );
          }).toList();
        });
      }
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load test catalog: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  } finally {
    if (mounted) {
      setState(() {
        _isLoadingCatalog = false;
      });
    }
  }
}
```

---

## Error Handling

### Standard Error Responses

All endpoints should return consistent error formats:

```json
{
  "success": false,
  "message": "Human-readable error message",
  "error": "Technical error details",
  "status_code": 400,
  "errors": [
    {
      "field": "category",
      "message": "Invalid category value"
    }
  ]
}
```

### HTTP Status Codes

- `200 OK`: Successful request
- `400 Bad Request`: Invalid query parameters
- `404 Not Found`: Resource not found
- `500 Internal Server Error`: Server error
- `503 Service Unavailable`: Service temporarily unavailable

---

## Testing Requirements

### Unit Tests

Test the following scenarios:
1. Retrieve all tests with default pagination
2. Filter by category
3. Search by test name
4. Search by LOINC code
5. Filter by active status
6. Retrieve test by ID (exists)
7. Retrieve test by ID (does not exist)
8. Invalid pagination parameters
9. Large result sets (performance)

### Integration Tests

1. Database connectivity
2. Query performance with indexes
3. Pagination accuracy
4. Search accuracy

---

## Security Considerations

1. **Authentication**: All endpoints should require valid authentication token
2. **Authorization**: Verify user has permission to view lab test catalog
3. **Rate Limiting**: Implement rate limiting to prevent abuse
4. **Input Validation**: Validate and sanitize all query parameters
5. **SQL Injection Prevention**: Use parameterized queries

---

## Maintenance & Updates

### Adding New Tests

1. Insert new record into `lab_test_catalog` table
2. Ensure LOINC code is valid and unique
3. Set appropriate category and subcategory
4. Verify `is_active` flag is set correctly

### Updating Existing Tests

1. Update relevant fields in `lab_test_catalog`
2. Update `updated_at` timestamp
3. Update `updated_by` field with staff ID

### Deactivating Tests

1. Set `is_active = false` instead of deleting
2. Maintain historical data for existing orders

---

## Additional Notes

1. **LOINC Codes**: Ensure all LOINC codes are valid and from the official LOINC database
2. **Cost Updates**: Test costs should be regularly updated based on pricing
3. **Category Management**: Consider creating a separate `lab_test_categories` table if categories need more metadata
4. **Audit Trail**: Consider adding audit logging for catalog changes
5. **Versioning**: Consider API versioning if the catalog structure needs to change significantly

---

## Contact & Support

For questions or issues with this API:
- Backend Team Lead: [Contact Info]
- Database Administrator: [Contact Info]
- API Documentation: [Link to API Docs]

---

**Last Updated:** January 2024  
**Version:** 1.0.0

