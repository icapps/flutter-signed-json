package com.icapps.signedjson

import com.icapps.signedjson.methodcall.VerificationMethodCall
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.lang.Exception

class SignedJsonPlugin : FlutterPlugin, MethodCallHandler {

    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "signed_json")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        try {
            when (call.method) {
                "verify" -> VerificationMethodCall.verify(call, result)
                "verifyAndDecrypt" -> VerificationMethodCall.verifyAndDecrypt(call, result)
                "decrypt" -> VerificationMethodCall.decrypt(call, result)
                else -> result.notImplemented()
            }
        } catch (e: Exception) {
            e.printStackTrace()
            result.error("500", "Failed to handle ${call.method}", e.message)
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
