package com.example.jsonplaceholder_app

import android.content.Context
import android.content.BroadcastReceiver
import android.content.Intent
import android.content.IntentFilter
// import android.device.ScanDevice
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.Log
import java.util.concurrent.atomic.AtomicBoolean

class MainActivity : FlutterActivity() {
    private val EVENT_CHANNEL = "com.example.jsonplaceholder_app/scanner"
    private var eventSink: EventChannel.EventSink? = null
    private val handler = Handler(Looper.getMainLooper())
    
    // Sử dụng BroadcastReceiver trực tiếp trong MainActivity
    private val scannerReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            Log.d("MainActivity", "Direct BroadcastReceiver triggered in MainActivity")
            if (intent == null) return
            
            // Log tất cả extras
            intent.extras?.keySet()?.forEach { key ->
                Log.d("MainActivity", "Key in MainActivity receiver: $key = ${intent.getStringExtra(key)}")
            }
            
            val scanData = intent.getStringExtra("scan_data")
            if (scanData != null) {
                Log.d("MainActivity", "📱 Direct receiver got scan data: $scanData")
                sendScanDataToFlutter(scanData)
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // Đăng ký receiver trực tiếp
        val intentFilter = IntentFilter()
        intentFilter.addAction("android.intent.action.DECODE_DATA")
        intentFilter.addAction("scanner.action")
        intentFilter.addAction("android.intent.ACTION_DECODE_DATA")
        intentFilter.addAction("com.android.server.scannerservice.broadcast")
        intentFilter.addAction("urovo.rcv.message.ACTION")
        registerReceiver(scannerReceiver, intentFilter)
        
        Log.d("MainActivity", "🚀 MainActivity created and receiver registered")
    }
    
    override fun onDestroy() {
        super.onDestroy()
        try {
            unregisterReceiver(scannerReceiver)
        } catch (e: Exception) {
            Log.e("MainActivity", "Error unregistering receiver: ${e.message}")
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL)
            .setStreamHandler(object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    eventSink = events
                    Log.d("MainActivity", "📡 EventChannel Listener Started")
                    
                    // Test EventChannel ngay lập tức
                    handler.postDelayed({
                        sendScanDataToFlutter("TEST_CHANNEL_DATA")
                    }, 3000)
                }

                override fun onCancel(arguments: Any?) {
                    eventSink = null
                    Log.d("MainActivity", "📡 EventChannel Listener Stopped")
                }
            })
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        Log.d("MainActivity", "🔄 onNewIntent Called with action: ${intent.action}")
        
        // Log tất cả extras
        if (intent.extras != null) {
            intent.extras?.keySet()?.forEach { key ->
                Log.d("MainActivity", "👉 Extra in onNewIntent: $key = ${intent.getStringExtra(key)}")
            }
        } else {
            Log.d("MainActivity", "No extras in onNewIntent")
        }
        
        val scanData = intent.getStringExtra("scan_data")
        if (scanData != null) {
            Log.d("MainActivity", "📥 Received scan_data: $scanData")
            sendScanDataToFlutter(scanData)
        } else {
            Log.e("MainActivity", "❌ No scan_data in Intent from onNewIntent")
        }
    }

    fun sendScanDataToFlutter(scanData: String) {
        if (eventSink == null) {
            Log.e("MainActivity", "❌ EventSink is NULL, cannot send data!")
            return
        }

        handler.post {
            try {
                Log.d("MainActivity", "⏳ Attempting to send data: $scanData")
                eventSink?.success(scanData)
                Log.d("MainActivity", "✅ Data successfully sent to Flutter: $scanData")
            } catch (e: Exception) {
                Log.e("MainActivity", "❌ Error sending data to Flutter: ${e.message}")
                e.printStackTrace()
            }
        }
    }
}