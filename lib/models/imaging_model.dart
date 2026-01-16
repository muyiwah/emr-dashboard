class ImagingTest {
  final String id;
  final String code;
  final String name;
  final String category;
  final String? subcategory;
  final String? description;
  final String? bodyPart;
  final String? modality;
  final bool requiresContrast;
  final int? estimatedDuration; // in minutes
  final double? baseCost;
  final String? currency;

  ImagingTest({
    required this.id,
    required this.code,
    required this.name,
    required this.category,
    this.subcategory,
    this.description,
    this.bodyPart,
    this.modality,
    this.requiresContrast = false,
    this.estimatedDuration,
    this.baseCost,
    this.currency,
  });

  factory ImagingTest.fromJson(Map<String, dynamic> json) {
    return ImagingTest(
      id: json['id']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      subcategory: json['subcategory']?.toString(),
      description: json['description']?.toString(),
      bodyPart: json['body_part']?.toString(),
      modality: json['modality']?.toString(),
      requiresContrast: json['requires_contrast'] == true,
      estimatedDuration: json['estimated_duration'] as int?,
      baseCost: json['base_cost'] != null
          ? (json['base_cost'] as num).toDouble()
          : null,
      currency: json['currency']?.toString(),
    );
  }
}
