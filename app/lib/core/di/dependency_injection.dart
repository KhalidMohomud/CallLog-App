import '../../features/call_history/data/datasources/call_local_datasource.dart';
import '../../features/call_history/data/datasources/call_remote_datasource.dart';
import '../../features/call_history/data/repositories/call_repository_impl.dart';
import '../../features/call_history/domain/repositories/call_repository.dart';
import '../database/app_database.dart';
import '../services/connectivity/connectivity_service.dart';
import '../services/convex/convex_service.dart';
import '../services/native/call_channel_service.dart';
import '../services/sync/sync_service.dart';

/// Lightweight hand-rolled service locator.
/// Initialise once at app start with [DI.init].
class DI {
  DI._();
  static final DI instance = DI._();

  late AppDatabase database;
  late CallLocalDatasource localDatasource;
  late CallRemoteDatasource remoteDatasource;
  late CallRepository callRepository;
  late ConvexService convexService;
  late ConnectivityService connectivityService;
  late SyncService syncService;
  late CallChannelService callChannelService;

  Future<void> init() async {
    database = AppDatabase();
    convexService = ConvexService();
    connectivityService = ConnectivityService();
    callChannelService = CallChannelService();
    localDatasource = CallLocalDatasource(database.callDao);
    remoteDatasource = CallRemoteDatasource(convexService);
    callRepository = CallRepositoryImpl(
      local: localDatasource,
      remote: remoteDatasource,
    );
    syncService = SyncService(
      repository: callRepository,
      connectivity: connectivityService,
    );
  }
}
