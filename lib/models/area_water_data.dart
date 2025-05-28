class AreaWaterData {
  final String area;
  final double waterQuantity; // amount in liters
  final double ph;
  final double turbidity;
  final double contaminationLevel;
  final DateTime lastUpdated;

  AreaWaterData({
    required this.area,
    required this.waterQuantity,
    required this.ph,
    required this.turbidity,
    required this.contaminationLevel,
    required this.lastUpdated,
  });

  factory AreaWaterData.fromJson(Map<String, dynamic> json) {
    return AreaWaterData(
      area: json['area'] ?? 'Unknown',
      waterQuantity: (json['amount'] as num?)?.toDouble() ?? 0.0,
      ph: (json['ph'] as num?)?.toDouble() ?? 7.0,
      turbidity: (json['turbidity'] as num?)?.toDouble() ?? 1.0,
      contaminationLevel: (json['contamination_level'] as num?)?.toDouble() ?? 0.1,
      lastUpdated: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  // Helper methods for water quality assessment
  String get phStatus {
    if (ph < 6.5) return 'Acidic';
    if (ph > 8.5) return 'Alkaline';
    return 'Normal';
  }

  String get turbidityStatus {
    if (turbidity > 4.0) return 'High';
    if (turbidity > 1.0) return 'Moderate';
    return 'Low';
  }

  String get contaminationStatus {
    if (contaminationLevel > 0.5) return 'High';
    if (contaminationLevel > 0.2) return 'Moderate';
    return 'Low';
  }

  String get overallQualityStatus {
    if (contaminationLevel > 0.5 || turbidity > 4.0 || ph < 6.5 || ph > 8.5) {
      return 'Poor';
    }
    if (contaminationLevel > 0.2 || turbidity > 1.0) {
      return 'Fair';
    }
    return 'Good';
  }
}
