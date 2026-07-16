import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import 'router/app_router.dart';

class BeecbileApp extends StatelessWidget {
  const BeecbileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Beecbile Call Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
    );
  }
}
