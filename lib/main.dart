import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:async';
import 'constants.dart';
import 'services/auth_service.dart';
import 'services/data_service.dart';
import 'services/supabase_service.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/splash/splash_screen.dart';
import 'theme/theme_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize Supabase
  await SupabaseService.initialize();

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final DataService _dataService = DataService();
  final AuthService _authService = AuthService();
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    // Initialize auth service
    _authService.initialize().then((_) {
      // Initialize data service with user ID
      if (_authService.currentUser != null) {
        _dataService.initialize(_authService.currentUser!.id);
      }
    });

    // Set up a timer to simulate water flow every 5 seconds
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _dataService.simulateWaterFlow();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _dataService),
        ChangeNotifierProvider.value(value: _authService),
      ],
      child: MaterialApp(
        title: 'Water Management App',
        debugShowCheckedModeBanner: false,
        theme: lightThemeData(context),
        darkTheme: darkThemeData(context),
        themeMode: ThemeMode.light, // You can change this to system or dark
        initialRoute: splashScreenRoute,
        routes: {
          splashScreenRoute: (context) => const SplashScreen(),
          loginScreenRoute: (context) => const LoginScreen(),
          signupScreenRoute: (context) => const SignupScreen(),
          homeScreenRoute: (context) => const HomeScreen(),
        },
      ),
    );
  }
}
