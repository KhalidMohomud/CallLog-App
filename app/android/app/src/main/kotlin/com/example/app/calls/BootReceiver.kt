package com.example.app.calls

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import androidx.work.BackoffPolicy
import androidx.work.Constraints
import androidx.work.NetworkType
import androidx.work.PeriodicWorkRequestBuilder
import androidx.work.WorkManager
import java.util.concurrent.TimeUnit

/**
 * Triggered when the device boots. Re-schedules the periodic background sync
 * WorkManager task so call records are uploaded even after a reboot.
 */
class BootReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action
        if (action != Intent.ACTION_BOOT_COMPLETED &&
            action != Intent.ACTION_LOCKED_BOOT_COMPLETED
        ) return

        scheduleSync(context)
    }

    private fun scheduleSync(context: Context) {
        val constraints = Constraints.Builder()
            .setRequiredNetworkType(NetworkType.CONNECTED)
            .build()

        val workRequest = PeriodicWorkRequestBuilder<CallSyncWorker>(
            repeatInterval = 15,
            repeatIntervalTimeUnit = TimeUnit.MINUTES,
        )
            .setConstraints(constraints)
            .setBackoffCriteria(BackoffPolicy.EXPONENTIAL, 1, TimeUnit.MINUTES)
            .addTag(SYNC_TASK_TAG)
            .build()

        WorkManager.getInstance(context).enqueueUniquePeriodicWork(
            SYNC_TASK_NAME,
            androidx.work.ExistingPeriodicWorkPolicy.KEEP,
            workRequest,
        )
    }

    companion object {
        const val SYNC_TASK_NAME = "beecbile_call_sync"
        const val SYNC_TASK_TAG = "beecbile_sync"
    }
}
