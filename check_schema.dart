import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  await dotenv.load(fileName: ".env");
  
  final supabaseUrl = dotenv.env['SUPABASE_URL'];
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];
  
  if (supabaseUrl == null || supabaseAnonKey == null) {
    print('Missing Supabase credentials in .env file');
    return;
  }
  
  // Initialize Supabase
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  final client = Supabase.instance.client;
  
  // Check if tables exist
  try {
    print('Checking database schema...');
    
    // Check profiles table
    try {
      final profilesResponse = await client.rpc('check_table_exists', params: {'table_name': 'profiles'});
      print('profiles table exists: $profilesResponse');
      
      if (profilesResponse) {
        final profilesColumns = await client.rpc('get_table_columns', params: {'table_name': 'profiles'});
        print('profiles columns: $profilesColumns');
      }
    } catch (e) {
      print('Error checking profiles table: $e');
    }
    
    // Check customer_data table
    try {
      final customerDataResponse = await client.rpc('check_table_exists', params: {'table_name': 'customer_data'});
      print('customer_data table exists: $customerDataResponse');
      
      if (customerDataResponse) {
        final customerDataColumns = await client.rpc('get_table_columns', params: {'table_name': 'customer_data'});
        print('customer_data columns: $customerDataColumns');
      }
    } catch (e) {
      print('Error checking customer_data table: $e');
    }
    
    // Check water_quality table
    try {
      final waterQualityResponse = await client.rpc('check_table_exists', params: {'table_name': 'water_quality'});
      print('water_quality table exists: $waterQualityResponse');
      
      if (waterQualityResponse) {
        final waterQualityColumns = await client.rpc('get_table_columns', params: {'table_name': 'water_quality'});
        print('water_quality columns: $waterQualityColumns');
      }
    } catch (e) {
      print('Error checking water_quality table: $e');
    }
    
    // Check researcher_data table
    try {
      final researcherDataResponse = await client.rpc('check_table_exists', params: {'table_name': 'researcher_data'});
      print('researcher_data table exists: $researcherDataResponse');
      
      if (researcherDataResponse) {
        final researcherDataColumns = await client.rpc('get_table_columns', params: {'table_name': 'researcher_data'});
        print('researcher_data columns: $researcherDataColumns');
      }
    } catch (e) {
      print('Error checking researcher_data table: $e');
    }
    
    // Check rainfall_data table
    try {
      final rainfallDataResponse = await client.rpc('check_table_exists', params: {'table_name': 'rainfall_data'});
      print('rainfall_data table exists: $rainfallDataResponse');
      
      if (rainfallDataResponse) {
        final rainfallDataColumns = await client.rpc('get_table_columns', params: {'table_name': 'rainfall_data'});
        print('rainfall_data columns: $rainfallDataColumns');
      }
    } catch (e) {
      print('Error checking rainfall_data table: $e');
    }
  } catch (e) {
    print('Error checking database schema: $e');
  }
}
