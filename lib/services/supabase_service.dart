import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static SupabaseClient? _client;

  static Future<void> initialize() async {
    try {
      final supabaseUrl = dotenv.env['SUPABASE_URL'];
      final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

      debugPrint('Supabase URL: $supabaseUrl');
      debugPrint(
        'Supabase Anon Key: ${supabaseAnonKey != null ? 'Found (not showing for security)' : 'Not found'}',
      );

      if (supabaseUrl == null || supabaseAnonKey == null) {
        throw Exception('Missing Supabase credentials in .env file');
      }

      await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
      _client = Supabase.instance.client;
      debugPrint('Supabase initialized successfully');

      // Test connection
      try {
        final response = await _client!
            .from('profiles')
            .select('id, full_name, email, user_type')
            .limit(1);
        debugPrint('Supabase connection test: Success');
        // Only log non-sensitive information
        if (response.isNotEmpty) {
          final user = response[0];
          debugPrint(
            'Found user: ${user['full_name']} (${user['email']}) as ${user['user_type']}',
          );
        } else {
          debugPrint('No users found in profiles table');
        }
      } catch (testError) {
        debugPrint('Supabase connection test error: $testError');
      }
    } catch (e) {
      debugPrint('Error initializing Supabase: $e');
      rethrow;
    }
  }

  static SupabaseClient get client {
    if (_client == null) {
      throw Exception(
        'Supabase client not initialized. Call initialize() first.',
      );
    }
    return _client!;
  }

  // Helper method to get the current user
  static User? get currentUser => _client?.auth.currentUser;

  // Helper method to check if user is logged in
  static bool get isLoggedIn => currentUser != null;
}
