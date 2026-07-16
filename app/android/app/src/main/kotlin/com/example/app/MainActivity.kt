package com.example.app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import com.example.app.calls.CallChannelHandler

class MainActivity : FlutterActivity() {

    private var callHandler: CallChannelHandler? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        callHandler = CallChannelHandler(this, flutterEngine.dartExecutor.binaryMessenger)
        callHandler?.attach()
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        callHandler?.detach()
        callHandler = null
        super.cleanUpFlutterEngine(flutterEngine)
    }
}
