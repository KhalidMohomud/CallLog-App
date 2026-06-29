import 'package:go_router/go_router.dart';

import '../../features/call_history/presentation/screens/call_history_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import 'app_routes.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoute.splash.path,
  routes: <RouteBase>[
    GoRoute(
      name: AppRoute.splash.name,
      path: AppRoute.splash.path,
      builder: (_, _) => const SplashScreen(),
    ),
    GoRoute(
      name: AppRoute.home.name,
      path: AppRoute.home.path,
      builder: (_, _) => const HomeScreen(),
    ),
    GoRoute(
      name: AppRoute.callHistory.name,
      path: AppRoute.callHistory.path,
      builder: (_, _) => const CallHistoryScreen(),
    ),
    GoRoute(
      name: AppRoute.settings.name,
      path: AppRoute.settings.path,
      builder: (_, _) => const SettingsScreen(),
    ),
  ],
);
