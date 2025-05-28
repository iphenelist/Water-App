import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../services/auth_service.dart';
import '../../services/data_service.dart';
import '../customer/customer_dashboard.dart';
import '../researcher/researcher_dashboard.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    // Check if user is logged in and initialize data service
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authService = Provider.of<AuthService>(context, listen: false);
      final dataService = Provider.of<DataService>(context, listen: false);

      if (authService.currentUser != null) {
        dataService.initialize(authService.currentUser!.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser;

    // If user is not logged in, redirect to login screen
    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, loginScreenRoute);
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Cast user to AppUser
    final appUser = user;

    // Determine which dashboard to show based on user type
    Widget dashboard;
    if (appUser.userType == UserType.customer) {
      dashboard = const CustomerDashboard();
    } else {
      dashboard = const ResearcherDashboard();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedIndex == 0 ? "Water Management" : "Profile",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authService.signOut();
              Navigator.pushReplacementNamed(context, loginScreenRoute);
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [dashboard, const ProfileScreen()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
