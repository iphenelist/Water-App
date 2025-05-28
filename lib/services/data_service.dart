import 'package:flutter/material.dart';
import '../models/customer_data.dart';
import '../models/researcher_data.dart';
import '../models/area_water_data.dart';
import 'supabase_service.dart';

class DataService extends ChangeNotifier {
  CustomerData? _customerData;
  ResearcherData? _researcherData;
  List<AreaWaterData> _areaWaterData = [];
  bool _isLoading = false;
  String? _errorMessage;
  String? _userId;

  // Getters
  CustomerData get customerData => _customerData ?? _getDefaultCustomerData();
  ResearcherData get researcherData =>
      _researcherData ?? _getDefaultResearcherData();
  List<AreaWaterData> get areaWaterData => _areaWaterData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Initialize with user ID
  void initialize(String? userId) {
    _userId = userId;
    if (userId != null) {
      loadData();
    }
  }

  // Load data from Supabase
  Future<void> loadData() async {
    if (_userId == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      // Try to load customer data
      try {
        // First, check if the customer_data table has a user_id column
        bool hasUserIdColumn = false;
        try {
          // Try to query with user_id
          await SupabaseService.client
              .from('customer_data')
              .select('id')
              .eq('user_id', _userId!)
              .limit(1);
          hasUserIdColumn = true;
        } catch (e) {
          debugPrint('customer_data table might not have user_id column: $e');
          hasUserIdColumn = false;
        }

        final customerResponse =
            hasUserIdColumn
                ? await SupabaseService.client
                    .from('customer_data')
                    .select()
                    .eq('user_id', _userId!)
                    .maybeSingle()
                : null; // Use default data if user_id column doesn't exist

        if (customerResponse != null) {
          WaterQuality waterQuality;

          try {
            final qualityResponse =
                await SupabaseService.client
                    .from('water_quality')
                    .select()
                    .eq('customer_id', customerResponse['id'])
                    .maybeSingle();

            waterQuality =
                qualityResponse != null
                    ? WaterQuality(
                      ph: qualityResponse['ph'] ?? 7.0,
                      turbidity: qualityResponse['turbidity'] ?? 1.0,
                      contaminationLevel:
                          qualityResponse['contamination_level'] ?? 0.1,
                    )
                    : WaterQuality(
                      ph: 7.0,
                      turbidity: 1.0,
                      contaminationLevel: 0.1,
                    );
          } catch (e) {
            debugPrint('Error loading water quality: $e');
            waterQuality = WaterQuality(
              ph: 7.0,
              turbidity: 1.0,
              contaminationLevel: 0.1,
            );
          }

          _customerData = CustomerData(
            location: customerResponse['location'] ?? 'Unknown',
            waterQuantity: customerResponse['water_quantity'] ?? 500.0,
            waterQuality: waterQuality,
            waterFlowEnabled: customerResponse['water_flow_enabled'] ?? false,
          );
        } else {
          // No customer data found, use default
          _customerData = _getDefaultCustomerData();
        }
      } catch (e) {
        debugPrint('Error loading customer data: $e');
        // If table doesn't exist or other error, use default data
        _customerData = _getDefaultCustomerData();
      }

      // Try to load researcher data
      try {
        // First, check if the researcher_data table has a user_id column
        bool hasUserIdColumn = false;
        try {
          // Try to query with user_id
          await SupabaseService.client
              .from('researcher_data')
              .select('id')
              .eq('user_id', _userId!)
              .limit(1);
          hasUserIdColumn = true;
        } catch (e) {
          debugPrint('researcher_data table might not have user_id column: $e');
          hasUserIdColumn = false;
        }

        // Load weather data from Supabase (ALL researchers' data)
        final weatherData = await _loadWeatherDataFromSupabase();

        // Load area water data for customer dashboard
        await _loadAreaWaterData();

        // For researcher data, we'll use a simplified approach
        // Get the current user's area info if available, otherwise use default
        String userArea = 'Research Area';
        double userRainfall = 0.0;

        if (hasUserIdColumn) {
          try {
            final userResponse = await SupabaseService.client
                .from('researcher_data')
                .select()
                .eq('user_id', _userId!)
                .limit(1);

            if (userResponse.isNotEmpty) {
              final userEntry = userResponse[0];
              userArea = userEntry['area']?.toString() ?? 'Research Area';
              userRainfall =
                  (userEntry['current_rainfall'] as num?)?.toDouble() ?? 0.0;
            }
          } catch (e) {
            debugPrint('Error loading user-specific researcher data: $e');
          }
        }

        List<RainfallData> rainfallHistory = [];
        try {
          // Try to load rainfall history if the table exists
          final rainfallResponse = await SupabaseService.client
              .from('rainfall_data')
              .select()
              .order('date', ascending: false)
              .limit(30);

          rainfallHistory = List<RainfallData>.from(
            rainfallResponse.map(
              (item) => RainfallData(
                date: DateTime.parse(item['date']),
                amount: item['amount'] ?? 0.0,
              ),
            ),
          );
        } catch (e) {
          debugPrint('Error loading rainfall data: $e');
          rainfallHistory = []; // Empty list instead of mock data
        }

        _researcherData = ResearcherData(
          area: userArea,
          rainfallHistory: rainfallHistory,
          weatherData: weatherData, // This now contains ALL researchers' data
          currentRainfall: userRainfall,
        );
      } catch (e) {
        debugPrint('Error loading researcher data: $e');
        // If table doesn't exist or other error, use default data
        _researcherData = _getDefaultResearcherData();
      }
    } catch (e) {
      debugPrint('Error loading data: $e');
      _errorMessage = 'Failed to load data';

      // Use default data if all else fails
      _customerData = _getDefaultCustomerData();
      _researcherData = _getDefaultResearcherData();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Default data
  CustomerData _getDefaultCustomerData() {
    return CustomerData(
      location: 'Not set - Please update your location',
      waterQuantity: 0.0,
      waterQuality: WaterQuality(
        ph: 7.0,
        turbidity: 0.0,
        contaminationLevel: 0.0,
      ),
      waterFlowEnabled: false,
    );
  }

  ResearcherData _getDefaultResearcherData() {
    return ResearcherData(
      area: 'Not set - Please update your research area',
      rainfallHistory: [], // Empty list instead of mock data
      weatherData: [], // Empty list instead of mock data
      currentRainfall: 0.0,
    );
  }

  // Load weather data from Supabase researcher_data table
  // Loads ALL weather data from ALL researchers for collaborative viewing
  Future<List<WeatherData>> _loadWeatherDataFromSupabase() async {
    try {
      // Get ALL weather data entries from ALL users (no user_id filter)
      // Include the id field for proper updates and temperature field
      final response = await SupabaseService.client
          .from('researcher_data')
          .select('id, area, current_rainfall, temperature, created_at')
          .order(
            'area',
            ascending: true,
          ); // Order by area for better organization

      final List<WeatherData> weatherDataList = [];

      for (final item in response) {
        // Create WeatherData object from Supabase data
        final weatherData = WeatherData(
          id:
              item['id']
                  ?.toString(), // Convert to String since Supabase might return int or String
          date: DateTime.tryParse(item['created_at'] ?? '') ?? DateTime.now(),
          area: item['area'] ?? 'Unknown',
          rainfall: item['current_rainfall']?.toDouble(),
          temperature:
              item['temperature']
                  ?.toDouble(), // Now reading temperature from database
          notes: 'Research data', // Generic note for collaborative data
        );

        weatherDataList.add(weatherData);
      }

      debugPrint(
        'Loaded ${weatherDataList.length} weather data entries from ALL researchers',
      );
      return weatherDataList;
    } catch (e) {
      debugPrint('Error loading weather data from Supabase: $e');
      return [];
    }
  }

  // Load area water data from Supabase water_quality table
  Future<void> _loadAreaWaterData() async {
    try {
      debugPrint(
        '🔄 LOADING: Attempting to load area water data from water_quality table...',
      );

      // Get water quality data grouped by area
      // Only select columns that exist: area, amount, ph, turbidity, contamination_level
      final response = await SupabaseService.client
          .from('water_quality')
          .select('area, amount, ph, turbidity, contamination_level')
          .order('area', ascending: true);

      debugPrint(
        '🔄 LOADING: Received ${response.length} records from water_quality table',
      );

      final List<AreaWaterData> areaDataList = [];

      for (final item in response) {
        final areaData = AreaWaterData(
          area: item['area'] ?? 'Unknown',
          waterQuantity: (item['amount'] as num?)?.toDouble() ?? 0.0,
          ph: (item['ph'] as num?)?.toDouble() ?? 7.0,
          turbidity: (item['turbidity'] as num?)?.toDouble() ?? 1.0,
          contaminationLevel:
              (item['contamination_level'] as num?)?.toDouble() ?? 0.1,
          lastUpdated:
              DateTime.now(), // Use current time since updated_at doesn't exist
        );

        areaDataList.add(areaData);
        debugPrint(
          '🔄 LOADING: Added area: ${areaData.area}, Amount: ${areaData.waterQuantity}L, pH: ${areaData.ph}',
        );
      }

      _areaWaterData = areaDataList;
      debugPrint(
        '✅ SUCCESS: Loaded ${areaDataList.length} area water data entries',
      );
    } catch (e) {
      debugPrint('❌ ERROR: Error loading area water data from Supabase: $e');
      _areaWaterData = [];
    }
  }

  // Update customer data
  Future<void> updateCustomerLocation(String location) async {
    if (_userId == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      // Check if the customer_data table has a user_id column
      bool hasUserIdColumn = false;
      try {
        // Try to query with user_id
        await SupabaseService.client
            .from('customer_data')
            .select('id')
            .eq('user_id', _userId!)
            .limit(1);
        hasUserIdColumn = true;
      } catch (e) {
        debugPrint('customer_data table might not have user_id column: $e');
        hasUserIdColumn = false;
      }

      if (hasUserIdColumn) {
        // Update in Supabase
        if (_customerData != null) {
          await SupabaseService.client
              .from('customer_data')
              .update({'location': location})
              .eq('user_id', _userId!);
        } else {
          await SupabaseService.client.from('customer_data').insert({
            'user_id': _userId,
            'location': location,
            'water_quantity': 500.0,
            'water_flow_enabled': true,
          });
        }
      } else {
        // Just update local data since we can't update in Supabase
        debugPrint(
          'Skipping Supabase update since customer_data table might not exist or have user_id column',
        );
      }

      // Update local data
      _customerData = (_customerData ?? _getDefaultCustomerData()).copyWith(
        location: location,
      );
    } catch (e) {
      debugPrint('Error updating location: $e');
      _errorMessage = 'Failed to update location';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateWaterQuantity(double quantity) async {
    if (_userId == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      // Check if the customer_data table has a user_id column
      bool hasUserIdColumn = false;
      try {
        // Try to query with user_id
        await SupabaseService.client
            .from('customer_data')
            .select('id')
            .eq('user_id', _userId!)
            .limit(1);
        hasUserIdColumn = true;
      } catch (e) {
        debugPrint('customer_data table might not have user_id column: $e');
        hasUserIdColumn = false;
      }

      if (hasUserIdColumn) {
        // Update in Supabase
        await SupabaseService.client
            .from('customer_data')
            .update({'water_quantity': quantity})
            .eq('user_id', _userId!);
      } else {
        // Just update local data since we can't update in Supabase
        debugPrint(
          'Skipping Supabase update since customer_data table might not exist or have user_id column',
        );
      }

      // Update local data
      _customerData = (_customerData ?? _getDefaultCustomerData()).copyWith(
        waterQuantity: quantity,
      );
    } catch (e) {
      debugPrint('Error updating water quantity: $e');
      _errorMessage = 'Failed to update water quantity';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateWaterQuality({
    double? ph,
    double? turbidity,
    double? contaminationLevel,
  }) async {
    if (_userId == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      // Check if the customer_data table has a user_id column
      bool hasUserIdColumn = false;
      try {
        // Try to query with user_id
        await SupabaseService.client
            .from('customer_data')
            .select('id')
            .eq('user_id', _userId!)
            .limit(1);
        hasUserIdColumn = true;
      } catch (e) {
        debugPrint('customer_data table might not have user_id column: $e');
        hasUserIdColumn = false;
      }

      if (hasUserIdColumn) {
        try {
          // Get customer ID
          final customerResponse =
              await SupabaseService.client
                  .from('customer_data')
                  .select('id')
                  .eq('user_id', _userId!)
                  .single();

          final customerId = customerResponse['id'];

          // Update in Supabase
          final updateData = {};
          if (ph != null) {
            updateData['ph'] = ph;
          }
          if (turbidity != null) {
            updateData['turbidity'] = turbidity;
          }
          if (contaminationLevel != null) {
            updateData['contamination_level'] = contaminationLevel;
          }

          final qualityResponse =
              await SupabaseService.client
                  .from('water_quality')
                  .select()
                  .eq('customer_id', customerId)
                  .maybeSingle();

          if (qualityResponse != null) {
            await SupabaseService.client
                .from('water_quality')
                .update(updateData)
                .eq('customer_id', customerId);
          } else {
            await SupabaseService.client.from('water_quality').insert({
              'customer_id': customerId,
              'ph': ph ?? 7.0,
              'turbidity': turbidity ?? 1.0,
              'contamination_level': contaminationLevel ?? 0.1,
            });
          }
        } catch (e) {
          debugPrint('Error updating water quality in Supabase: $e');
          // Continue with local update
        }
      } else {
        // Just update local data since we can't update in Supabase
        debugPrint(
          'Skipping Supabase update since customer_data table might not exist or have user_id column',
        );
      }

      // Update local data
      final currentData = _customerData ?? _getDefaultCustomerData();
      final updatedQuality = currentData.waterQuality.copyWith(
        ph: ph,
        turbidity: turbidity,
        contaminationLevel: contaminationLevel,
      );
      _customerData = currentData.copyWith(waterQuality: updatedQuality);
    } catch (e) {
      debugPrint('Error updating water quality: $e');
      _errorMessage = 'Failed to update water quality';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleWaterFlow() async {
    if (_userId == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final currentData = _customerData ?? _getDefaultCustomerData();
      final newFlowState = !currentData.waterFlowEnabled;

      // Check if the customer_data table has a user_id column
      bool hasUserIdColumn = false;
      try {
        // Try to query with user_id
        await SupabaseService.client
            .from('customer_data')
            .select('id')
            .eq('user_id', _userId!)
            .limit(1);
        hasUserIdColumn = true;
      } catch (e) {
        debugPrint('customer_data table might not have user_id column: $e');
        hasUserIdColumn = false;
      }

      if (hasUserIdColumn) {
        // Update in Supabase
        await SupabaseService.client
            .from('customer_data')
            .update({'water_flow_enabled': newFlowState})
            .eq('user_id', _userId!);
      } else {
        // Just update local data since we can't update in Supabase
        debugPrint(
          'Skipping Supabase update since customer_data table might not exist or have user_id column',
        );
      }

      // Update local data
      _customerData = currentData.copyWith(waterFlowEnabled: newFlowState);
    } catch (e) {
      debugPrint('Error toggling water flow: $e');
      _errorMessage = 'Failed to toggle water flow';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update researcher data
  Future<void> updateResearchArea(String area) async {
    if (_userId == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      // Check if the researcher_data table has a user_id column
      bool hasUserIdColumn = false;
      try {
        // Try to query with user_id
        await SupabaseService.client
            .from('researcher_data')
            .select('id')
            .eq('user_id', _userId!)
            .limit(1);
        hasUserIdColumn = true;
      } catch (e) {
        debugPrint('researcher_data table might not have user_id column: $e');
        hasUserIdColumn = false;
      }

      if (hasUserIdColumn) {
        // Update in Supabase
        if (_researcherData != null) {
          await SupabaseService.client
              .from('researcher_data')
              .update({'area': area})
              .eq('user_id', _userId!);
        } else {
          await SupabaseService.client.from('researcher_data').insert({
            'user_id': _userId,
            'area': area,
            'current_rainfall': 0.0,
            'temperature': 0.0,
          });
        }
      } else {
        // Just update local data since we can't update in Supabase
        debugPrint(
          'Skipping Supabase update since researcher_data table might not exist or have user_id column',
        );
      }

      // Update local data
      _researcherData = (_researcherData ?? _getDefaultResearcherData())
          .copyWith(area: area);
    } catch (e) {
      debugPrint('Error updating research area: $e');
      _errorMessage = 'Failed to update research area';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateCurrentRainfall(double rainfall) async {
    if (_userId == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      // Check if the researcher_data table has a user_id column
      bool hasUserIdColumn = false;
      try {
        // Try to query with user_id
        await SupabaseService.client
            .from('researcher_data')
            .select('id')
            .eq('user_id', _userId!)
            .limit(1);
        hasUserIdColumn = true;
      } catch (e) {
        debugPrint('researcher_data table might not have user_id column: $e');
        hasUserIdColumn = false;
      }

      if (hasUserIdColumn) {
        // Update in Supabase
        await SupabaseService.client
            .from('researcher_data')
            .update({'current_rainfall': rainfall})
            .eq('user_id', _userId!);
      } else {
        // Just update local data since we can't update in Supabase
        debugPrint(
          'Skipping Supabase update since researcher_data table might not exist or have user_id column',
        );
      }

      // Update local data
      _researcherData = (_researcherData ?? _getDefaultResearcherData())
          .copyWith(currentRainfall: rainfall);
    } catch (e) {
      debugPrint('Error updating current rainfall: $e');
      _errorMessage = 'Failed to update current rainfall';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addRainfallData(RainfallData data) async {
    if (_userId == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      // Check if the researcher_data table has a user_id column
      bool hasUserIdColumn = false;
      try {
        // Try to query with user_id
        await SupabaseService.client
            .from('researcher_data')
            .select('id')
            .eq('user_id', _userId!)
            .limit(1);
        hasUserIdColumn = true;
      } catch (e) {
        debugPrint('researcher_data table might not have user_id column: $e');
        hasUserIdColumn = false;
      }

      if (hasUserIdColumn) {
        try {
          // Get researcher area ID
          final researcherResponse =
              await SupabaseService.client
                  .from('researcher_data')
                  .select('id')
                  .eq('user_id', _userId!)
                  .single();

          final areaId = researcherResponse['id'];

          // Add to Supabase
          await SupabaseService.client.from('rainfall_data').insert({
            'area_id': areaId,
            'date': data.date.toIso8601String(),
            'amount': data.amount,
          });
        } catch (e) {
          debugPrint('Error adding rainfall data to Supabase: $e');
          // Continue with local update
        }
      } else {
        // Just update local data since we can't update in Supabase
        debugPrint(
          'Skipping Supabase update since researcher_data table might not exist or have user_id column',
        );
      }

      // Update local data
      final currentData = _researcherData ?? _getDefaultResearcherData();
      final updatedHistory = List<RainfallData>.from(
        currentData.rainfallHistory,
      )..add(data);
      _researcherData = currentData.copyWith(rainfallHistory: updatedHistory);
    } catch (e) {
      debugPrint('Error adding rainfall data: $e');
      _errorMessage = 'Failed to add rainfall data';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add weather data
  Future<void> addWeatherData(WeatherData weatherData) async {
    _isLoading = true;
    notifyListeners();

    try {
      bool hasUserIdColumn = true;

      // Check if researcher_data table has user_id column
      try {
        await SupabaseService.client
            .from('researcher_data')
            .select('id')
            .eq('user_id', _userId!)
            .limit(1);
        hasUserIdColumn = true;
      } catch (e) {
        debugPrint('researcher_data table might not have user_id column: $e');
        hasUserIdColumn = false;
      }

      if (hasUserIdColumn) {
        try {
          // Add to Supabase - include temperature field
          await SupabaseService.client.from('researcher_data').insert({
            'area': weatherData.area,
            'current_rainfall': weatherData.rainfall ?? 0.0,
            'temperature': weatherData.temperature, // Include temperature
            'user_id': _userId,
          });

          debugPrint('Successfully added weather data to Supabase');

          // Reload weather data from Supabase to get the latest data
          final updatedWeatherData = await _loadWeatherDataFromSupabase();

          // Update local data
          final currentData = _researcherData ?? _getDefaultResearcherData();
          _researcherData = currentData.copyWith(
            weatherData: updatedWeatherData,
          );
        } catch (e) {
          debugPrint('Error adding weather data to Supabase: $e');
          // Continue with local update
          final newWeatherData = WeatherData(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            date: weatherData.date,
            area: weatherData.area,
            rainfall: weatherData.rainfall,
            temperature: weatherData.temperature,
            notes: weatherData.notes,
          );

          final currentData = _researcherData ?? _getDefaultResearcherData();
          final updatedWeatherData =
              List<WeatherData>.from(currentData.weatherData)
                ..add(newWeatherData)
                ..sort((a, b) => b.date.compareTo(a.date));

          _researcherData = currentData.copyWith(
            weatherData: updatedWeatherData,
          );
        }
      } else {
        // Just update local data
        final newWeatherData = WeatherData(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          date: weatherData.date,
          area: weatherData.area,
          rainfall: weatherData.rainfall,
          temperature: weatherData.temperature,
          notes: weatherData.notes,
        );

        final currentData = _researcherData ?? _getDefaultResearcherData();
        final updatedWeatherData =
            List<WeatherData>.from(currentData.weatherData)
              ..add(newWeatherData)
              ..sort((a, b) => b.date.compareTo(a.date));

        _researcherData = currentData.copyWith(weatherData: updatedWeatherData);
      }
    } catch (e) {
      debugPrint('Error adding weather data: $e');
      _errorMessage = 'Failed to add weather data';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update weather data
  Future<void> updateWeatherData(WeatherData weatherData) async {
    debugPrint(
      '🔄 UPDATE ATTEMPT: Starting update for weather data with ID: ${weatherData.id}',
    );
    debugPrint(
      '🔄 UPDATE DATA: Area: ${weatherData.area}, Rainfall: ${weatherData.rainfall}',
    );

    if (weatherData.id == null) {
      debugPrint('❌ UPDATE FAILED: Cannot update weather data - ID is null');
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      debugPrint('🔄 UPDATE: Sending update request to Supabase...');

      // Update in Supabase using the specific record ID
      // Include temperature field in updates
      await SupabaseService.client
          .from('researcher_data')
          .update({
            'area': weatherData.area,
            'current_rainfall': weatherData.rainfall ?? 0.0,
            'temperature': weatherData.temperature, // Include temperature
          })
          .eq('id', weatherData.id!);

      debugPrint(
        '✅ UPDATE SUCCESS: Successfully updated weather data with ID: ${weatherData.id}',
      );

      // Reload weather data from Supabase to get the latest data
      debugPrint('🔄 UPDATE: Reloading data from Supabase...');
      final updatedWeatherData = await _loadWeatherDataFromSupabase();

      // Update local data
      final currentData = _researcherData ?? _getDefaultResearcherData();
      _researcherData = currentData.copyWith(weatherData: updatedWeatherData);

      debugPrint('✅ UPDATE COMPLETE: Local data updated successfully');
    } catch (e) {
      debugPrint('❌ UPDATE ERROR: Failed to update weather data: $e');
      _errorMessage = 'Failed to update weather data';

      // Still update local data as fallback
      debugPrint('🔄 UPDATE FALLBACK: Updating local data only...');
      final currentData = _researcherData ?? _getDefaultResearcherData();
      final updatedWeatherData =
          currentData.weatherData.map((data) {
            return data.id == weatherData.id ? weatherData : data;
          }).toList();

      _researcherData = currentData.copyWith(weatherData: updatedWeatherData);
      debugPrint('✅ UPDATE FALLBACK COMPLETE: Local data updated');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Delete weather data
  Future<void> deleteWeatherData(String weatherDataId) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Delete from Supabase using the specific record ID
      await SupabaseService.client
          .from('researcher_data')
          .delete()
          .eq('id', weatherDataId);

      debugPrint('Successfully deleted weather data with ID: $weatherDataId');

      // Reload weather data from Supabase to get the latest data
      final updatedWeatherData = await _loadWeatherDataFromSupabase();

      // Update local data
      final currentData = _researcherData ?? _getDefaultResearcherData();
      _researcherData = currentData.copyWith(weatherData: updatedWeatherData);
    } catch (e) {
      debugPrint('Error deleting weather data: $e');
      _errorMessage = 'Failed to delete weather data';

      // Still update local data as fallback
      final currentData = _researcherData ?? _getDefaultResearcherData();
      final updatedWeatherData =
          currentData.weatherData
              .where((data) => data.id != weatherDataId)
              .toList();

      _researcherData = currentData.copyWith(weatherData: updatedWeatherData);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Simulate water flow effect (decrease water quantity over time when flow is enabled)
  void simulateWaterFlow() {
    if (_customerData?.waterFlowEnabled == true &&
        (_customerData?.waterQuantity ?? 0) > 0) {
      final newQuantity =
          (_customerData?.waterQuantity ?? 0) - 5.0; // Decrease by 5 liters
      updateWaterQuantity(newQuantity > 0 ? newQuantity : 0);
    }
  }
}
