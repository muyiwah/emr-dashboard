import 'package:flutter/material.dart';

class LabTestTemplate extends StatefulWidget {
  const LabTestTemplate({Key? key}) : super(key: key);

  @override
  State<LabTestTemplate> createState() => _LabTestTemplateState();
}

class _LabTestTemplateState extends State<LabTestTemplate> {
  String selectedCategory = 'Hematology';
  final TextEditingController searchController = TextEditingController();

  final List<String> categories = [
    'Hematology',
    'Biochemistry', 
    'Urinalysis',
    'Serology',
    'Radiology',
    'Custom'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          // Header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
            child: Row(
              children: [
                // Left side - Title and description
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFF6366F1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.science,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Select Test Result Template',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Choose the appropriate form to enter lab results based on the test type.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Right side - Back button
                TextButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF374151), size: 20),
                  label: const Text(
                    'Back to Dashboard',
                    style: TextStyle(
                      color: Color(0xFF374151),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Search and Categories
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Column(
              children: [
                // Search bar
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search test types (e.g., FBC, Creatinine)',
                    hintStyle: const TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontSize: 14,
                    ),
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF9CA3AF)),
                    filled: true,
                    fillColor: const Color(0xFFF3F4F6),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Category tabs
                Row(
                  children: categories.map((category) {
                    final isSelected = selectedCategory == category;
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCategory = category;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFFEF4444) : const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Text(
                            category,
                            style: TextStyle(
                              color: isSelected ? Colors.white : const Color(0xFF374151),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          // Main content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left sidebar
                  SizedBox(
                    width: 320,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Quick Start
                        const Text(
                          'Quick Start',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        // Recent Templates
                        const Text(
                          'Recent Templates',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        _buildSidebarItem(
                          Icons.water_drop,
                          'Full Blood Count',
                          const Color(0xFFEF4444),
                        ),
                        const SizedBox(height: 12),
                        _buildSidebarItem(
                          Icons.edit,
                          'Urinalysis',
                          const Color(0xFFF59E0B),
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Urgent Test Types
                        const Text(
                          'Urgent Test Types',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF2F2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFFECACA)),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.masks,
                                color: const Color(0xFFEF4444),
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Blood Gas Analysis',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF1F2937),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Create Custom Template
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.add, color: Colors.white, size: 20),
                            label: const Text(
                              'Create Custom Template',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6366F1),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Preview Mode
                        Row(
                          children: [
                            Icon(
                              Icons.visibility_outlined,
                              color: const Color(0xFF6B7280),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Preview Mode',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF6B7280),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(width: 32),
                  
                  // Main grid
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 3,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 0.9,
                      children: [
                        _buildTestCard(
                          Icons.water_drop,
                          'Full Blood Count',
                          'Hematology',
                          'Includes WBC, Hemoglobin, Platelets, Hematocrit',
                          'Basic',
                          const Color(0xFFEF4444),
                        ),
                        _buildTestCard(
                          Icons.edit,
                          'Urinalysis', 
                          'Urinalysis',
                          'Protein, Glucose, Ketones, Blood, Microscopy',
                          'Advanced',
                          const Color(0xFFF59E0B),
                        ),
                        _buildTestCard(
                          Icons.favorite,
                          'Lipid Panel',
                          'Biochemistry',
                          'Total Cholesterol, HDL, LDL, Triglycerides',
                          'Basic',
                          const Color(0xFF10B981),
                        ),
                        _buildTestCard(
                          Icons.science,
                          'Liver Function Test',
                          'Biochemistry',
                          'ALT, AST, Bilirubin, Albumin, ALP',
                          'Advanced',
                          const Color(0xFF10B981),
                        ),
                        _buildTestCard(
                          Icons.psychology,
                          'CSF Analysis',
                          'Serology',
                          'Cell Count, Protein, Glucose, Culture',
                          'Advanced',
                          const Color(0xFF8B5CF6),
                        ),
                        _buildTestCard(
                          Icons.coronavirus,
                          'COVID-19 Rapid Test',
                          'Serology',
                          'Antigen Detection, Result Interpretation',
                          'Basic',
                          const Color(0xFF8B5CF6),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(IconData icon, String title, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF1F2937),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTestCard(
    IconData icon,
    String title,
    String category,
    String description,
    String level,
    Color color,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF6B7280),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              level,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF9CA3AF),
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.open_in_new, color: Colors.white, size: 16),
                label: const Text(
                  'Use Template',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}