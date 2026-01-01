import 'package:flutter/material.dart';

class RadiologyDashboard extends StatefulWidget {
  const RadiologyDashboard({super.key});

  @override
  State<RadiologyDashboard> createState() => _RadiologyDashboardState();
}

class _RadiologyDashboardState extends State<RadiologyDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Column(
          children: [_buildTopBar(), Expanded(child: _buildMainContent())],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 64,
      color: const Color(0xFF1E293B),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(Icons.healing, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 12),
          const Text(
            'RadiologyEMR',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          const CircleAvatar(
            radius: 18,
            backgroundColor: Color(0xFF6366F1),
            child: Text(
              'MS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Flexible(
            child: Text(
              'Dr. Michael Smith',
              style: TextStyle(color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () {
              // Handle logout
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader(),
          _buildWorkspace(),
          _buildComparisonSection(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Column(
        children: [
          const Text(
            'Imaging Review Panel',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Analyze and report diagnostic images efficiently.',
            style: TextStyle(fontSize: 18, color: Color(0xFF94A3B8)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          GestureDetector(
            onTap: () {
              // Handle open next case
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.folder_open, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'Open Next Case',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkspace() {
    return Container(
      constraints: const BoxConstraints(minHeight: 600),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive layout based on screen width
          if (constraints.maxWidth < 1200) {
            return _buildMobileLayout();
          } else {
            return _buildDesktopLayout();
          }
        },
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left panel - Assigned Studies
          SizedBox(width: 320, child: _buildStudiesList()),
          const SizedBox(width: 24),
          // Center panel - Image viewer
          Expanded(flex: 2, child: _buildImageViewer()),
          const SizedBox(width: 24),
          // Right panel - Findings
          SizedBox(width: 340, child: _buildFindingsPanel()),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildStudiesList(),
        const SizedBox(height: 24),
        _buildImageViewer(),
        const SizedBox(height: 24),
        _buildFindingsPanel(),
      ],
    );
  }

  Widget _buildStudiesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.assignment, color: Color(0xFF6366F1), size: 20),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Assigned Studies',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildStudyCard(
          'Sarah Johnson',
          'Chest X-ray',
          'Dr. Williams • 2 hours ago',
          'URGENT',
          const Color(0xFFEF4444),
          true,
        ),
        const SizedBox(height: 16),
        _buildStudyCard(
          'Robert Chen',
          'Brain MRI',
          'Dr. Davis • 4 hours ago',
          'HIGH',
          const Color(0xFFF59E0B),
          false,
        ),
        const SizedBox(height: 16),
        _buildStudyCard(
          'Maria Garcia',
          'Abdominal CT',
          'Dr. Thompson • 6 hours ago',
          'NORMAL',
          const Color(0xFF10B981),
          false,
        ),
      ],
    );
  }

  Widget _buildImageViewer() {
    return Column(
      children: [
        // Image viewer header
        Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Sarah Johnson - Chest X-ray',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildIconButton(Icons.search),
                  _buildIconButton(Icons.zoom_in),
                  _buildIconButton(Icons.refresh),
                  _buildIconButton(Icons.contrast),
                  _buildIconButton(Icons.edit, isActive: true),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Main image viewer
        Container(
          height: 600,
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Patient: Sarah Johnson | Study: CXR-2024-001',
                        style: TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 400,
                        maxHeight: 500,
                      ),
                      child: AspectRatio(
                        aspectRatio: 4 / 5,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=400&h=500&fit=crop',
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.black,
                                child: const Center(
                                  child: Icon(
                                    Icons.medical_information,
                                    color: Colors.white54,
                                    size: 60,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Flexible(
                      child: _buildActionButton(
                        Icons.visibility,
                        'Toggle Annotations',
                        const Color(0xFF6366F1),
                        () {},
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: _buildActionButton(
                        Icons.compare,
                        'Compare Previous',
                        const Color(0xFF374151),
                        () {},
                      ),
                    ),
                    const SizedBox(width: 20),
                    const Text(
                      'Image 1 of 3',
                      style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFindingsPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.lock, color: Color(0xFF6366F1), size: 20),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Findings',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildInputField('Diagnosis (ICD-10)', 'Search diagnosis...', 44),
        const SizedBox(height: 24),
        _buildInputField(
          'Radiologist\'s Notes',
          'Enter detailed findings...',
          120,
        ),
        const SizedBox(height: 24),
        _buildInputField('Impression/Summary', 'Clinical impression...', 120),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                Icons.mic,
                'Voice Note',
                const Color(0xFF374151),
                () {},
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                Icons.check,
                'Finalize',
                const Color(0xFF10B981),
                () {},
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInputField(String label, String placeholder, double height) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: height,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF374151),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Align(
            alignment: height > 50 ? Alignment.topLeft : Alignment.centerLeft,
            child: Text(
              placeholder,
              style: const TextStyle(color: Color(0xFF9CA3AF)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.compare_arrows,
                color: Color(0xFF6366F1),
                size: 20,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Comparison View',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              Wrap(
                spacing: 8,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Current Study',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF374151),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Previous (6 months ago)',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              return constraints.maxWidth < 600
                  ? Column(
                    children: [
                      _buildComparisonImage(true),
                      const SizedBox(height: 16),
                      _buildComparisonImage(false),
                    ],
                  )
                  : Row(
                    children: [
                      Expanded(child: _buildComparisonImage(true)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildComparisonImage(false)),
                    ],
                  );
            },
          ),
          const SizedBox(height: 24),
          _buildExportSection(),
        ],
      ),
    );
  }

  Widget _buildComparisonImage(bool isCurrent) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Container(
          width: 160,
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color:
                isCurrent
                    ? const Color(0xFF6366F1).withOpacity(0.2)
                    : const Color(0xFF374151).withOpacity(0.5),
          ),
          child: Center(
            child: Icon(
              Icons.medical_information,
              color:
                  isCurrent ? const Color(0xFF6366F1) : const Color(0xFF9CA3AF),
              size: 40,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExportSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return constraints.maxWidth < 600
            ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.file_download,
                      color: Color(0xFFEF4444),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Export Report',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Generate signed diagnostic report',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        Icons.visibility,
                        'Preview',
                        const Color(0xFF374151),
                        () {},
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildActionButton(
                        Icons.picture_as_pdf,
                        'Sign & Export PDF',
                        const Color(0xFFEF4444),
                        () {},
                      ),
                    ),
                  ],
                ),
              ],
            )
            : Row(
              children: [
                const Icon(
                  Icons.file_download,
                  color: Color(0xFFEF4444),
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Export Report',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Generate signed diagnostic report',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
                _buildActionButton(
                  Icons.visibility,
                  'Preview',
                  const Color(0xFF374151),
                  () {},
                ),
                const SizedBox(width: 12),
                _buildActionButton(
                  Icons.picture_as_pdf,
                  'Sign & Export PDF',
                  const Color(0xFFEF4444),
                  () {},
                ),
              ],
            );
      },
    );
  }

  Widget _buildStudyCard(
    String name,
    String study,
    String details,
    String priority,
    Color priorityColor,
    bool isSelected,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(8),
        border:
            isSelected
                ? Border.all(color: const Color(0xFFEF4444), width: 3)
                : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: priorityColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  priority,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            study,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            details,
            style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, {bool isActive = false}) {
    return GestureDetector(
      onTap: () {
        // Handle icon button tap
      },
      child: Container(
        margin: const EdgeInsets.only(left: 8),
        padding: const EdgeInsets.all(8),
        child: Icon(
          icon,
          color: isActive ? const Color(0xFF6366F1) : const Color(0xFF94A3B8),
          size: 20,
        ),
      ),
    );
  }
}
