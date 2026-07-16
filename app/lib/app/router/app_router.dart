import 'package:go_router/go_router.dart';

import '../../features/call_history/presentation/screens/call_history_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import 'app_routes.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: AppRoute.home.name,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/call-history',
      name: AppRoute.callHistory.name,
      builder: (context, state) => const CallHistoryScreen(),
    ),
    GoRoute(
      path: '/settings',
      name: AppRoute.settings.name,
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);
