import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../models/researcher_data.dart';
import '../../services/data_service.dart';
import 'components/weather_data_card.dart';
import 'components/weather_summary_chart.dart';

class ResearcherDashboard extends StatefulWidget {
  const ResearcherDashboard({super.key});

  @override
  State<ResearcherDashboard> createState() => _ResearcherDashboardState();
}

class _ResearcherDashboardState extends State<ResearcherDashboard> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  Timer? _refreshTimer;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    // Start auto-refresh timer (refresh every 30 seconds)
    _startAutoRefresh();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _startAutoRefresh() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _refreshData();
    });
  }

  Future<void> _refreshData() async {
    if (_isRefreshing) return; // Prevent multiple simultaneous refreshes

    setState(() {
      _isRefreshing = true;
    });

    try {
      final dataService = Provider.of<DataService>(context, listen: false);
      await dataService.loadData();
      debugPrint('🔄 AUTO-REFRESH: Weather data refreshed successfully');
    } catch (e) {
      debugPrint('❌ AUTO-REFRESH ERROR: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isRefreshing = false;
        });
      }
    }
  }

  Future<void> _manualRefresh() async {
    await _refreshData();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Weather data refreshed'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataService>(
      builder: (context, dataService, child) {
        final researcherData = dataService.researcherData;

        // Debug logging for UI
        debugPrint(
          '🎨 UI BUILD: Total weather data: ${researcherData.weatherData.length}',
        );
        debugPrint('🎨 UI BUILD: Search query: "$_searchQuery"');

        // Filter weather data based on search query
        final filteredWeatherData =
            researcherData.weatherData.where((data) {
              return data.area.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              );
            }).toList();

        debugPrint(
          '🎨 UI BUILD: Filtered weather data: ${filteredWeatherData.length}',
        );
        for (int i = 0; i < filteredWeatherData.length; i++) {
          final data = filteredWeatherData[i];
          debugPrint(
            '🎨 UI BUILD: Entry $i - ID: ${data.id}, Area: ${data.area}, Rainfall: ${data.rainfall}',
          );
        }

        return Scaffold(
          body: RefreshIndicator(
            onRefresh: _manualRefresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  Container(
                    padding: const EdgeInsets.all(defaultPadding),
                    decoration: const BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Weather Research Dashboard",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Record and monitor weather data",
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                        const SizedBox(height: 20),
                        _buildSearchCard(),
                      ],
                    ),
                  ),
                  const SizedBox(height: defaultPadding),

                  // Weather Data List Section
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: defaultPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Weather Data Records",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                if (_isRefreshing)
                                  const Padding(
                                    padding: EdgeInsets.only(right: 8.0),
                                    child: SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              primaryColor,
                                            ),
                                      ),
                                    ),
                                  ),
                                Text(
                                  "${filteredWeatherData.length} of ${researcherData.weatherData.length} entries",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: defaultPadding),

                        // Weather Data Cards
                        if (filteredWeatherData.isEmpty)
                          _searchQuery.isEmpty
                              ? _buildEmptyState()
                              : _buildNoSearchResults()
                        else
                          ...filteredWeatherData.map(
                            (weatherData) =>
                                WeatherDataCard(weatherData: weatherData),
                          ),

                        const SizedBox(height: defaultPadding),

                        // Weather Summary Chart
                        WeatherSummaryChart(weatherData: filteredWeatherData),

                        const SizedBox(height: defaultPadding * 2),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddWeatherDataDialog(context, dataService),
            backgroundColor: primaryColor,
            tooltip: "Add weather data",
            child: const Icon(Icons.add, color: Colors.white),
          ),
        );
      },
    );
  }

  Widget _buildSearchCard() {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(defaultBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.search, color: primaryColor, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: const InputDecoration(
                hintText: 'Search areas...',
                border: InputBorder.none,
                hintStyle: TextStyle(color: lightTextColor),
              ),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          if (_searchQuery.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear, color: lightTextColor),
              onPressed: () {
                setState(() {
                  _searchController.clear();
                  _searchQuery = '';
                });
              },
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Card(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(defaultPadding * 2),
        child: Column(
          children: [
            Icon(Icons.cloud_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No Weather Data Yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start recording weather data by tapping the + button',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoSearchResults() {
    return Card(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(defaultPadding * 2),
        child: Column(
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No Areas Found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'No weather data found for "$_searchQuery"',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                setState(() {
                  _searchController.clear();
                  _searchQuery = '';
                });
              },
              child: const Text('Clear Search'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddWeatherDataDialog(
    BuildContext context,
    DataService dataService,
  ) {
    final TextEditingController areaController = TextEditingController();
    final TextEditingController rainfallController = TextEditingController();
    final TextEditingController temperatureController = TextEditingController();
    final TextEditingController notesController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    // Pre-fill area with current research area if available
    final currentArea = dataService.researcherData.area;
    if (currentArea.isNotEmpty && !currentArea.startsWith('Not set')) {
      areaController.text = currentArea;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add Weather Data'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: Text(
                        'Date: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime.now().subtract(
                            const Duration(days: 365),
                          ),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null && picked != selectedDate) {
                          setState(() {
                            selectedDate = picked;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: areaController,
                      decoration: const InputDecoration(
                        labelText: 'Research Area',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.location_on),
                        hintText: 'e.g., Downtown District, Rural Valley',
                      ),
                      textCapitalization: TextCapitalization.words,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: rainfallController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Rainfall (mm)',
                        border: OutlineInputBorder(),
                        suffixText: 'mm',
                        hintText: 'Optional',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: temperatureController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Temperature (°C)',
                        border: OutlineInputBorder(),
                        suffixText: '°C',
                        hintText: 'Optional',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: notesController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Notes',
                        border: OutlineInputBorder(),
                        hintText: 'Optional observations...',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final area = areaController.text.trim();
                    final rainfall = double.tryParse(rainfallController.text);
                    final temperature = double.tryParse(
                      temperatureController.text,
                    );
                    final notes = notesController.text.trim();

                    if (area.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter a research area'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    if (rainfall == null && temperature == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please enter at least rainfall or temperature data',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    final weatherData = WeatherData(
                      date: selectedDate,
                      area: area,
                      rainfall: rainfall,
                      temperature: temperature,
                      notes: notes.isEmpty ? null : notes,
                    );

                    dataService.addWeatherData(weatherData);
                    Navigator.of(context).pop();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Weather data added successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
