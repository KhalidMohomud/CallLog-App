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

    // State tracking to determine callType on IDLE
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
                // Only incoming calls trigger RINGING
                ringingStartedAtMillis = now
                activeStartedAtMillis = null
            }

            TelephonyManager.EXTRA_STATE_OFFHOOK -> {
                // OFFHOOK after RINGING  → answered incoming
                // OFFHOOK without RINGING → outgoing
                if (activeStartedAtMillis == null) {
                    activeStartedAtMillis = now
                }
            }

            TelephonyManager.EXTRA_STATE_IDLE -> {
                // Determine callType from state machine
                val callType = when {
                    ringingStartedAtMillis != null && activeStartedAtMillis != null -> CALL_TYPE_INCOMING
                    ringingStartedAtMillis == null && activeStartedAtMillis != null -> CALL_TYPE_OUTGOING
                    else -> CALL_TYPE_MISSED   // ringing but never answered
                }

                val startedAtMillis = activeStartedAtMillis ?: ringingStartedAtMillis ?: now
                val duration = if (activeStartedAtMillis != null) {
                    durationSeconds(activeStartedAtMillis!!, now)
                } else {
                    0
                }

                sendCallEvent(
                    callType = callType,
                    startTimeMillis = startedAtMillis,
                    endTimeMillis = now,
                    durationSeconds = duration,
                )

                // Reset state
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
                "READ_PHONE_STATE and READ_CALL_LOG permissions are required.",
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

        result.success(null)
    }

    private fun stopListening() {
        val callReceiver = receiver ?: return
        runCatching { activity.unregisterReceiver(callReceiver) }
        receiver = null
        isListening = false
        ringingStartedAtMillis = null
        activeStartedAtMillis = null
        lastPhoneNumber = null
    }

    private fun sendCallEvent(
        callType: String,
        startTimeMillis: Long,
        endTimeMillis: Long,
        durationSeconds: Int,
    ) {
        val payload = mapOf(
            "phoneNumber" to lastPhoneNumber.orEmpty(),
            "callType" to callType,
            "startTime" to startTimeMillis.toIso8601String(),
            "endTime" to endTimeMillis.toIso8601String(),
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

        const val CALL_TYPE_INCOMING = "INCOMING"
        const val CALL_TYPE_OUTGOING = "OUTGOING"
        const val CALL_TYPE_MISSED = "MISSED"

        val iso8601Formatter: ThreadLocal<SimpleDateFormat> = ThreadLocal.withInitial {
            SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", Locale.US).apply {
                timeZone = TimeZone.getTimeZone("UTC")
            }
        }
    }
}
