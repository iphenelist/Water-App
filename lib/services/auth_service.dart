import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../constants.dart';
import '../models/user_model.dart';
import 'supabase_service.dart';

class AuthService extends ChangeNotifier {
  AppUser? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  // Hash password using SHA-256
  String _hashPassword(String password) {
    var bytes = utf8.encode(password); // Convert to UTF-8
    var digest = sha256.convert(bytes); // Hash the password
    return digest.toString();
  }

  // Getters
  AppUser? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Clear error message
  void _clearError() {
    _errorMessage = null;
  }

  // Initialize auth state
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      // We don't need to check for existing sessions anymore
      // since we're not using Supabase Auth
      debugPrint('Auth service initialized');
    } catch (e) {
      debugPrint('Error initializing auth: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Sign up a new user
  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
    required UserType userType,
  }) async {
    _isLoading = true;
    _clearError();
    notifyListeners();

    try {
      // Validate inputs
      if (name.isEmpty || email.isEmpty || password.isEmpty) {
        _errorMessage = 'Please fill in all required fields';
        return false;
      }

      if (password.length < 6) {
        _errorMessage = 'Password must be at least 6 characters';
        return false;
      }

      debugPrint('Attempting to sign up user: $email');
      debugPrint(
        'User type: ${userType == UserType.researcher ? 'researcher' : 'customer'}',
      );

      // Hash the password before storing it
      final hashedPassword = _hashPassword(password);

      // Create a UUID for the user
      final userId = const Uuid().v4();

      // Create user profile directly in Supabase
      try {
        final profileData = {
          'id': userId,
          'full_name': name,
          'email': email,
          'password': hashedPassword, // Store the hashed password
          'user_type':
              userType == UserType.researcher ? 'researcher' : 'customer',
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        };

        // Don't log the full profile data with password
        debugPrint(
          'Creating profile for user: ${profileData['full_name']} (${profileData['email']}) as ${profileData['user_type']}',
        );

        final result =
            await SupabaseService.client
                .from('profiles')
                .insert(profileData)
                .select();

        debugPrint('Profile created: $result');

        _currentUser = AppUser(
          id: userId,
          name: name,
          email: email,
          userType: userType,
        );

        debugPrint('User successfully signed up and profile created');
        return true;
      } catch (profileError) {
        debugPrint('Error creating profile: $profileError');

        // Try to get more detailed error information
        String errorDetails = profileError.toString();
        if (errorDetails.contains('relation "profiles" does not exist')) {
          _errorMessage =
              'The profiles table does not exist in the database. Please run the setup SQL script.';
        } else if (errorDetails.contains('permission denied')) {
          _errorMessage =
              'Permission denied when creating profile. Check RLS policies.';
        } else if (errorDetails.contains(
          'duplicate key value violates unique constraint',
        )) {
          _errorMessage = 'A user with this email already exists.';
        } else {
          _errorMessage = 'Error creating profile: $profileError';
        }

        return false;
      }
    } catch (e) {
      debugPrint('Unexpected error signing up: $e');
      _errorMessage = 'An unexpected error occurred: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Log in an existing user
  Future<bool> login({
    required String fullName,
    required String password,
  }) async {
    _isLoading = true;
    _clearError();
    notifyListeners();

    try {
      debugPrint('Attempting to log in user by full name: $fullName');

      // Query the profiles table to find the user by full name
      final profilesResponse = await SupabaseService.client
          .from('profiles')
          .select('id, full_name, email, password, user_type')
          .eq('full_name', fullName)
          .limit(1);

      if (profilesResponse.isEmpty) {
        debugPrint('No user found with full name: $fullName');
        _errorMessage = 'No user found with this full name';
        return false;
      }

      final userProfile = profilesResponse[0];
      final userId = userProfile['id'];
      final userName = userProfile['full_name'];
      final userEmail = userProfile['email'];
      final storedPassword = userProfile['password'];
      final userType = userProfile['user_type'];

      debugPrint(
        'Found user with full name: $fullName, email: $userEmail, and type: $userType',
      );

      // Check if the provided password matches the stored password
      // First try direct comparison (for legacy plain text passwords)
      if (password == storedPassword) {
        debugPrint('Password matched using plain text comparison (legacy)');

        // Update the password to hashed version for future logins
        try {
          final hashedPassword = _hashPassword(password);
          await SupabaseService.client
              .from('profiles')
              .update({'password': hashedPassword})
              .eq('id', userId);
          debugPrint('Updated password to hashed version');
        } catch (e) {
          debugPrint('Failed to update password to hashed version: $e');
          // Continue with login even if update fails
        }
      } else {
        // Try hashed comparison
        final hashedPassword = _hashPassword(password);
        if (hashedPassword != storedPassword) {
          debugPrint(
            'Password does not match (tried both plain text and hashed)',
          );
          _errorMessage = 'Invalid password';
          return false;
        }
        debugPrint('Password matched using hashed comparison');
      }

      // Set the current user
      _currentUser = AppUser(
        id: userId,
        name: userName,
        email: userEmail,
        userType:
            userType == 'researcher' ? UserType.researcher : UserType.customer,
      );

      debugPrint('User successfully logged in as $userType');
      return true;
    } catch (e) {
      debugPrint('Error logging in: $e');
      _errorMessage = 'An unexpected error occurred: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Log out the current user
  Future<void> signOut() async {
    _isLoading = true;
    _clearError();
    notifyListeners();

    try {
      // Simply clear the current user
      _currentUser = null;
      debugPrint('User successfully logged out');
    } catch (e) {
      debugPrint('Error logging out: $e');
      _errorMessage = 'Failed to log out';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
