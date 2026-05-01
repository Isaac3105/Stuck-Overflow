import 'package:flutter/material.dart';

import 'current_trip_page.dart';
import '../features/trips/presentation/archive/my_trips_page.dart';

/// Legacy prototype screen (not used by current app router).
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Nested navigator to keep BottomNavBar
  final GlobalKey<NavigatorState> _myTripsNavigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          const _LegacyPlanPage(),
          const CurrentTrip(),
          Navigator(
            key: _myTripsNavigatorKey,
            onGenerateRoute: (settings) => MaterialPageRoute(
              builder: (context) => const MyTrips(),
            ),
          ),
          const _LegacyPlanPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 1 && _currentIndex == 1) {
            _myTripsNavigatorKey.currentState
                ?.popUntil((route) => route.isFirst);
          }
          setState(() => _currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Current'),
          BottomNavigationBarItem(
              icon: Icon(Icons.airplanemode_active), label: 'Travels'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Plan'),
        ],
      ),
    );
  }
}

class _LegacyPlanPage extends StatelessWidget {
  const _LegacyPlanPage();

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

