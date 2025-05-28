import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  await dotenv.load();
  
  // Get Supabase credentials
  final supabaseUrl = dotenv.env['SUPABASE_URL'];
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];
  
  print('Supabase URL: $supabaseUrl');
  print('Supabase Anon Key: ${supabaseAnonKey != null ? 'Found (not showing for security)' : 'Not found'}');
  
  if (supabaseUrl == null || supabaseAnonKey == null) {
    print('Missing Supabase credentials in .env file');
    return;
  }
  
  try {
    // Initialize Supabase
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
    print('Supabase initialized successfully');
    
    // Test connection
    final client = Supabase.instance.client;
    
    // Test authentication
    try {
      final authResponse = await client.auth.signUp(
        email: 'test@example.com',
        password: 'password123',
      );
      print('Auth test: ${authResponse.user != null ? 'Success' : 'Failed'}');
      if (authResponse.user != null) {
        print('User ID: ${authResponse.user!.id}');
      }
    } catch (authError) {
      print('Auth test error: $authError');
    }
    
    // Test database
    try {
      final response = await client.from('profiles').select().limit(1);
      print('Database test: ${response != null ? 'Success' : 'Failed'}');
      print('Response: $response');
    } catch (dbError) {
      print('Database test error: $dbError');
    }
  } catch (e) {
    print('Error initializing Supabase: $e');
  }
}
