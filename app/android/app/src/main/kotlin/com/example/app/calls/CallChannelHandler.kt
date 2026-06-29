package com.example.app.calls

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.os.Build
import android.provider.Settings
import android.telephony.TelephonyManager
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale
import java.util.TimeZone
import kotlin.math.max

class CallChannelHandler(
    private val activity: Activity,
    messenger: BinaryMessenger,
) : MethodChannel.MethodCallHandler,
    CallBroadcastReceiver.Listener {
    private val channel = MethodChannel(messenger, CHANNEL_NAME)
    private val telephonyManager =
        activity.getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager

    private var receiver: CallBroadcastReceiver? = null
    private var isListening = false
    private var ringingStartedAtMillis: Long? = null
    private var activeStartedAtMillis: Long? = null
    private var lastPhoneNumber: String? = null

    fun attach() {
        channel.setMethodCallHandler(this)
    }

    fun detach() {
        stopListening()
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            METHOD_START_LISTENING -> startListening(result)
            METHOD_STOP_LISTENING -> {
                stopListening()
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    override fun onCallStateChanged(state: String, phoneNumber: String?) {
        val now = System.currentTimeMillis()
        if (!phoneNumber.isNullOrBlank()) {
            lastPhoneNumber = phoneNumber
        }

        when (state) {
            TelephonyManager.EXTRA_STATE_RINGING -> {
                ringingStartedAtMillis = now
                activeStartedAtMillis = null
                sendCallEvent(
                    status = STATUS_RINGING,
                    calledAtMillis = now,
                    durationSeconds = 0,
                )
            }
            TelephonyManager.EXTRA_STATE_OFFHOOK -> {
                activeStartedAtMillis = activeStartedAtMillis ?: now
                sendCallEvent(
                    status = STATUS_IN_PROGRESS,
                    calledAtMillis = activeStartedAtMillis ?: now,
                    durationSeconds = 0,
                )
            }
            TelephonyManager.EXTRA_STATE_IDLE -> {
                val startedAtMillis = activeStartedAtMillis ?: ringingStartedAtMillis ?: now
                val status = if (activeStartedAtMillis == null && ringingStartedAtMillis != null) {
                    STATUS_MISSED
                } else {
                    STATUS_COMPLETED
                }

                sendCallEvent(
                    status = status,
                    calledAtMillis = startedAtMillis,
                    durationSeconds = durationSeconds(startedAtMillis, now),
                )

                ringingStartedAtMillis = null
                activeStartedAtMillis = null
                lastPhoneNumber = null
            }
        }
    }

    private fun startListening(result: MethodChannel.Result) {
        if (!hasRequiredPermissions()) {
            result.error(
                ERROR_MISSING_PERMISSION,
                "READ_PHONE_STATE and READ_CALL_LOG permissions are required for call events.",
                null,
            )
            return
        }

        if (isListening) {
            result.success(null)
            return
        }

        val callReceiver = CallBroadcastReceiver(this)
        val filter = IntentFilter(TelephonyManager.ACTION_PHONE_STATE_CHANGED)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            activity.registerReceiver(callReceiver, filter, Context.RECEIVER_EXPORTED)
        } else {
            @Suppress("DEPRECATION")
            activity.registerReceiver(callReceiver, filter)
        }

        receiver = callReceiver
        isListening = true

        @Suppress("DEPRECATION")
        when (telephonyManager.callState) {
            TelephonyManager.CALL_STATE_RINGING -> onCallStateChanged(
                TelephonyManager.EXTRA_STATE_RINGING,
                lastPhoneNumber,
            )
            TelephonyManager.CALL_STATE_OFFHOOK -> onCallStateChanged(
                TelephonyManager.EXTRA_STATE_OFFHOOK,
                lastPhoneNumber,
            )
        }

        result.success(null)
    }

    private fun stopListening() {
        val callReceiver = receiver ?: return

        runCatching {
            activity.unregisterReceiver(callReceiver)
        }

        receiver = null
        isListening = false
        ringingStartedAtMillis = null
        activeStartedAtMillis = null
        lastPhoneNumber = null
    }

    private fun sendCallEvent(
        status: String,
        calledAtMillis: Long,
        durationSeconds: Int,
    ) {
        val payload = mapOf(
            "phoneNumber" to lastPhoneNumber.orEmpty(),
            "calledAt" to calledAtMillis.toIso8601String(),
            "status" to status,
            "duration" to durationSeconds,
            "deviceId" to deviceId(),
        )

        activity.runOnUiThread {
            channel.invokeMethod(METHOD_ON_CALL_EVENT, payload)
        }
    }

    private fun hasRequiredPermissions(): Boolean {
        return Build.VERSION.SDK_INT < Build.VERSION_CODES.M ||
            (
                activity.checkSelfPermission(Manifest.permission.READ_PHONE_STATE) ==
                    PackageManager.PERMISSION_GRANTED &&
                    activity.checkSelfPermission(Manifest.permission.READ_CALL_LOG) ==
                    PackageManager.PERMISSION_GRANTED
            )
    }

    private fun durationSeconds(startedAtMillis: Long, finishedAtMillis: Long): Int {
        return max(0, ((finishedAtMillis - startedAtMillis) / 1000).toInt())
    }

    private fun deviceId(): String {
        return Settings.Secure.getString(
            activity.contentResolver,
            Settings.Secure.ANDROID_ID,
        ).orEmpty()
    }

    private fun Long.toIso8601String(): String {
        return checkNotNull(iso8601Formatter.get()).format(Date(this))
    }

    private companion object {
        const val CHANNEL_NAME = "com.example.app/calls"
        const val METHOD_START_LISTENING = "startListening"
        const val METHOD_STOP_LISTENING = "stopListening"
        const val METHOD_ON_CALL_EVENT = "onCallEvent"
        const val ERROR_MISSING_PERMISSION = "missing_permission"

        const val STATUS_RINGING = "Ringing"
        const val STATUS_IN_PROGRESS = "In Progress"
        const val STATUS_COMPLETED = "Completed"
        const val STATUS_MISSED = "Missed"

        val iso8601Formatter: ThreadLocal<SimpleDateFormat> = ThreadLocal.withInitial {
            SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", Locale.US).apply {
                timeZone = TimeZone.getTimeZone("UTC")
            }
        }
    }
}
