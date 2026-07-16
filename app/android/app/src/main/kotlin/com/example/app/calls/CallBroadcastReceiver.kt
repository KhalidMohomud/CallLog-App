package com.example.app.calls

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.telephony.TelephonyManager

/**
 * Receives ACTION_PHONE_STATE_CHANGED broadcasts and delegates
 * to [Listener] for state-machine processing.
 */
class CallBroadcastReceiver(
    private val listener: Listener,
) : BroadcastReceiver() {

    interface Listener {
        fun onCallStateChanged(state: String, phoneNumber: String?)
    }

    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action != TelephonyManager.ACTION_PHONE_STATE_CHANGED) return

        val state = intent.getStringExtra(TelephonyManager.EXTRA_STATE) ?: return
        val phoneNumber = intent.getStringExtra(TelephonyManager.EXTRA_INCOMING_NUMBER)
        listener.onCallStateChanged(state, phoneNumber)
    }
}
