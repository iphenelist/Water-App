class RainfallData {
  final DateTime date;
  final double amount; // in millimeters

  RainfallData({required this.date, required this.amount});
}

class TemperatureData {
  final DateTime date;
  final double temperature; // in Celsius

  TemperatureData({required this.date, required this.temperature});
}

class WeatherData {
  final String? id; // Changed to String to match Supabase UUID
  final DateTime date;
  final String area; // Research area where data was collected
  final double? rainfall; // in millimeters
  final double? temperature; // in Celsius (Note: not stored in Supabase yet)
  final String? notes;

  WeatherData({
    this.id,
    required this.date,
    required this.area,
    this.rainfall,
    this.temperature,
    this.notes,
  });

  WeatherData copyWith({
    String? id, // Changed to String
    DateTime? date,
    String? area,
    double? rainfall,
    double? temperature,
    String? notes,
  }) {
    return WeatherData(
      id: id ?? this.id,
      date: date ?? this.date,
      area: area ?? this.area,
      rainfall: rainfall ?? this.rainfall,
      temperature: temperature ?? this.temperature,
      notes: notes ?? this.notes,
    );
  }
}

class ResearcherData {
  final String area;
  final List<RainfallData> rainfallHistory;
  final List<WeatherData> weatherData;
  final double currentRainfall; // Current or forecasted rainfall in mm

  ResearcherData({
    required this.area,
    required this.rainfallHistory,
    required this.weatherData,
    required this.currentRainfall,
  });

  // Create a copy with updated values
  ResearcherData copyWith({
    String? area,
    List<RainfallData>? rainfallHistory,
    List<WeatherData>? weatherData,
    double? currentRainfall,
  }) {
    return ResearcherData(
      area: area ?? this.area,
      rainfallHistory: rainfallHistory ?? this.rainfallHistory,
      weatherData: weatherData ?? this.weatherData,
      currentRainfall: currentRainfall ?? this.currentRainfall,
    );
  }
}
