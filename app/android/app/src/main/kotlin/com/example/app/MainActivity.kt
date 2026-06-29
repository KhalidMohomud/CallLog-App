package com.example.app

import com.example.app.calls.CallChannelHandler
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    private var callChannelHandler: CallChannelHandler? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        callChannelHandler = CallChannelHandler(
            activity = this,
            messenger = flutterEngine.dartExecutor.binaryMessenger,
        ).also { handler ->
            handler.attach()
        }
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        callChannelHandler?.detach()
        callChannelHandler = null

        super.cleanUpFlutterEngine(flutterEngine)
    }
}
