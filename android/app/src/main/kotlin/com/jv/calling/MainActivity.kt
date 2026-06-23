package com.jv.calling

import android.content.Context
import android.media.AudioManager
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.jv.calling/speakerphone"
    private val TAG = "CallingSpeaker"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "enableSpeakerphone" -> {
                    enableSpeakerphone()
                    result.success(true)
                }
                "disableSpeakerphone" -> {
                    disableSpeakerphone()
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun enableSpeakerphone() {
        try {
            val audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager
            audioManager.mode = AudioManager.MODE_IN_CALL
            audioManager.isSpeakerphoneOn = true
            audioManager.isBluetoothScoOn = false
            Log.d(TAG, "Speakerphone ON (mode=${audioManager.mode})")
        } catch (e: Exception) {
            Log.e(TAG, "enableSpeakerphone failed", e)
        }
    }

    private fun disableSpeakerphone() {
        try {
            val audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager
            audioManager.isSpeakerphoneOn = false
            audioManager.mode = AudioManager.MODE_NORMAL
            Log.d(TAG, "Speakerphone OFF")
        } catch (e: Exception) {
            Log.e(TAG, "disableSpeakerphone failed", e)
        }
    }
}
