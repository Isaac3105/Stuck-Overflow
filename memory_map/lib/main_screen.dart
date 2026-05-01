import 'package:flutter/material.dart';
import 'current_trip_page.dart';
import 'my_trips_page.dart';
import 'profile_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // We use a Navigator for the MyTrips tab to allow pushing details while keeping the BottomNavBar
  final GlobalKey<NavigatorState> _myTripsNavigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          const PlanPage(),
          const CurrentTrip(),
          // Nested Navigator for My Trips tab
          Navigator(
            key: _myTripsNavigatorKey,
            onGenerateRoute: (settings) => MaterialPageRoute(
              builder: (context) => const MyTrips(),
            ),
          ),
          const PlanPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          // If tapping the same tab that has the nested navigator, pop to root
          if (index == 1 && _currentIndex == 1) {
            _myTripsNavigatorKey.currentState?.popUntil((route) => route.isFirst);
          }
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Current'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Travels'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Plan'),
        ],
      ),
    );
  }
}

class PlanPage extends StatelessWidget {
  const PlanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Planning Feature Coming Soon!',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
