import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/trips/presentation/active/current_trip_page.dart';
import '../features/trips/presentation/home/home_page.dart';
import '../features/trips/presentation/plan/create_trip_page.dart';
import '../features/trips/presentation/plan/plan_page.dart';
import '../features/trips/presentation/plan/trip_planner_page.dart';
import '../features/trips/presentation/timeline/timeline_page.dart';
import '../features/trips/presentation/archive/my_trips_page.dart';
import '../features/trips/presentation/archive/trip_result_page.dart';

final appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          _RootShell(shell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/plan',
              builder: (context, state) => const PlanPage(),
              routes: [
                GoRoute(
                  path: 'new',
                  builder: (context, state) => const CreateTripPage(),
                ),
                GoRoute(
                  path: ':tripId',
                  builder: (context, state) => TripPlannerPage(
                    tripId: state.pathParameters['tripId']!,
                    initialDayId: state.uri.queryParameters['day'],
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/current',
              builder: (context, state) => const CurrentTripPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/archive',
              builder: (context, state) => Scaffold(
                appBar: AppBar(title: const Text('My Trips')),
                body: const MyTrips(),
              ),
              routes: [
                GoRoute(
                  path: ':tripId',
                  builder: (context, state) =>
                      TripResultPage(tripId: state.pathParameters['tripId']!),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/memories',
              builder: (context, state) => const TimelinePage(),
            ),
          ],
        ),
      ],
    ),
  ],
);

class _RootShell extends StatelessWidget {
  const _RootShell({required this.shell});
  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: (i) => shell.goBranch(i,
            initialLocation: i == shell.currentIndex),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map_rounded),
            label: 'Plan',
          ),
          NavigationDestination(
            icon: Icon(Icons.flight_takeoff_outlined),
            selectedIcon: Icon(Icons.flight_takeoff_rounded),
            label: 'Current',
          ),
          NavigationDestination(
            icon: Icon(Icons.luggage_outlined),
            selectedIcon: Icon(Icons.luggage_rounded),
            label: 'My Trips',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_stories_outlined),
            selectedIcon: Icon(Icons.auto_stories_rounded),
            label: 'Memories',
          ),
        ],
      ),
    );
  }
}
