class WaterQuality {
  final double ph;
  final double turbidity;
  final double contaminationLevel;

  WaterQuality({
    required this.ph,
    required this.turbidity,
    required this.contaminationLevel,
  });

  // Create a copy with updated values
  WaterQuality copyWith({
    double? ph,
    double? turbidity,
    double? contaminationLevel,
  }) {
    return WaterQuality(
      ph: ph ?? this.ph,
      turbidity: turbidity ?? this.turbidity,
      contaminationLevel: contaminationLevel ?? this.contaminationLevel,
    );
  }
}

class CustomerData {
  final String location;
  final double waterQuantity; // in liters
  final WaterQuality waterQuality;
  final bool waterFlowEnabled;

  CustomerData({
    required this.location,
    required this.waterQuantity,
    required this.waterQuality,
    required this.waterFlowEnabled,
  });

  // Create a copy with updated values
  CustomerData copyWith({
    String? location,
    double? waterQuantity,
    WaterQuality? waterQuality,
    bool? waterFlowEnabled,
  }) {
    return CustomerData(
      location: location ?? this.location,
      waterQuantity: waterQuantity ?? this.waterQuantity,
      waterQuality: waterQuality ?? this.waterQuality,
      waterFlowEnabled: waterFlowEnabled ?? this.waterFlowEnabled,
    );
  }
}
