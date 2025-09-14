package com.example.immersive_commerce

import android.content.Intent
import android.os.BatteryManager
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import android.widget.Toast
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.immersivecommerce.app/native"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "getDeviceInfo" -> {
                    val deviceInfo = mapOf(
                        "brand" to Build.BRAND,
                        "model" to Build.MODEL,
                        "device" to Build.DEVICE,
                        "manufacturer" to Build.MANUFACTURER,
                        "versionRelease" to Build.VERSION.RELEASE,
                        "sdkInt" to Build.VERSION.SDK_INT,
                        "isPhysicalDevice" to !isEmulator()
                    )
                    result.success(deviceInfo)
                }
                "showNativeAlert" -> {
                    val args = call.arguments as? Map<*, *>
                    val title = args?.get("title") as? String ?: "Alert"
                    val message = args?.get("message") as? String ?: ""
                    showNativeAlert(title, message)
                    result.success("Alert shown")
                }
                "getBatteryLevel" -> {
                    val batteryLevel = getBatteryLevel()
                    if (batteryLevel != -1) {
                        result.success(batteryLevel)
                    } else {
                        result.error("UNAVAILABLE", "Battery level not available", null)
                    }
                }
                "openNativeSettings" -> {
                    openNativeSettings()
                    result.success("Opened settings")
                }
                "shareContent" -> {
                    val args = call.arguments as? Map<*, *>
                    val content = args?.get("content") as? String ?: ""
                    shareContent(content)
                    result.success("Share sheet opened")
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun showNativeAlert(title: String, message: String) {
        Toast.makeText(this, "$title: $message", Toast.LENGTH_LONG).show()
    }

    private fun getBatteryLevel(): Int {
        val batteryManager = getSystemService(BATTERY_SERVICE) as BatteryManager
        return batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
    }

    private fun openNativeSettings() {
        val intent = Intent(Settings.ACTION_SETTINGS)
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        ContextCompat.startActivity(this, intent, null)
    }

    private fun shareContent(content: String) {
        val intent = Intent(Intent.ACTION_SEND).apply {
            type = "text/plain"
            putExtra(Intent.EXTRA_TEXT, content)
        }
        val chooser = Intent.createChooser(intent, "Share via")
        startActivity(chooser)
    }

    private fun isEmulator(): Boolean {
        return (Build.FINGERPRINT.startsWith("generic")
                || Build.FINGERPRINT.startsWith("unknown")
                || Build.MODEL.contains("google_sdk")
                || Build.MODEL.contains("Emulator")
                || Build.MODEL.contains("Android SDK built for x86"))
    }
}
