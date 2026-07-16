import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  ConnectivityService() : _connectivity = Connectivity();

  final Connectivity _connectivity;

  /// Returns true when any non-none connectivity is available.
  Future<bool> isConnected() async {
    final result = await _connectivity.checkConnectivity();
    return result.any((r) => r != ConnectivityResult.none);
  }

  /// Emits true/false whenever the network state changes.
  Stream<bool> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged.map(
        (results) => results.any((r) => r != ConnectivityResult.none),
      );
}
