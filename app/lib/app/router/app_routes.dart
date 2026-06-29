enum AppRoute {
  splash('splash', '/'),
  home('home', '/home'),
  callHistory('callHistory', '/call-history'),
  settings('settings', '/settings');

  const AppRoute(this.name, this.path);

  final String name;
  final String path;
}
