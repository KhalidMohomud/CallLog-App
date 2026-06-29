import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'app_routes.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoute.splash.path,
  routes: <RouteBase>[
    GoRoute(
      name: AppRoute.splash.name,
      path: AppRoute.splash.path,
      builder: (_, _) => const _RoutePlaceholder(),
    ),
    GoRoute(
      name: AppRoute.home.name,
      path: AppRoute.home.path,
      builder: (_, _) => const _RoutePlaceholder(),
    ),
    GoRoute(
      name: AppRoute.callHistory.name,
      path: AppRoute.callHistory.path,
      builder: (_, _) => const _RoutePlaceholder(),
    ),
    GoRoute(
      name: AppRoute.settings.name,
      path: AppRoute.settings.path,
      builder: (_, _) => const _RoutePlaceholder(),
    ),
  ],
);

class _RoutePlaceholder extends StatelessWidget {
  const _RoutePlaceholder();

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
