package com.example.app.calls

import android.content.Context
import androidx.work.Worker
import androidx.work.WorkerParameters

/**
 * Native Android Worker stub.
 *
 * The actual sync logic runs inside the Flutter/Dart WorkManager callback
 * (lib/core/services/sync/background_sync_worker.dart).
 *
 * This class exists only to satisfy WorkManager's requirement that the worker
 * class can be found via class-loader at runtime. The Flutter workmanager
 * package registers its own DartWorker that dispatches to Dart code.
 */
class CallSyncWorker(
    context: Context,
    params: WorkerParameters,
) : Worker(context, params) {
    override fun doWork(): Result = Result.success()
}
