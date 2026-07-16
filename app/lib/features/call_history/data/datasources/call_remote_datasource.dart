import '../../../../core/services/convex/convex_service.dart';
import '../../../../shared/models/call_record.dart';

class CallRemoteDatasource {
  const CallRemoteDatasource(this._convex);

  final ConvexService _convex;

  Future<void> saveCall(CallRecord record) async {
    await _convex.saveCall(record.toConvexJson());
  }
}
