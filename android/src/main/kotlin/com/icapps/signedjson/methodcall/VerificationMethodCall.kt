package com.icapps.signedjson.methodcall

import android.os.Handler
import android.os.Looper
import com.icapps.signedjson.extension.checkRequiredField
import com.icapps.signedjson.sdk.JoseVerification
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result
import kotlin.concurrent.thread

object VerificationMethodCall {

    internal fun verifyAndDecrypt(call: MethodCall, result: Result) {
        if (!call.checkRequiredField(result, CERT_VERIFY_ARGUMENT, CERT_DECRYPT_ARGUMENT, ENCODED_ARGUMENT))
            return

        val certVerify = call.argument<String>(CERT_VERIFY_ARGUMENT)!!
        val certDecrypt = call.argument<String>(CERT_DECRYPT_ARGUMENT)!!
        val encoded = call.argument<String>(ENCODED_ARGUMENT)!!

        thread {
            try {
                val payload = JoseVerification.verifyAndDecrypt(certVerify, certDecrypt, encoded)
                Handler(Looper.getMainLooper()).post { result.success(payload) }
            } catch (e: Exception) {
                Handler(Looper.getMainLooper()).post { result.error("500", "${e.message}", null) }
            }
        }
    }

    internal fun verify(call: MethodCall, result: Result) {
        if (!call.checkRequiredField(result, CERT_ARGUMENT, ENCODED_ARGUMENT))
            return

        val cert = call.argument<String>(CERT_ARGUMENT)!!
        val encoded = call.argument<String>(ENCODED_ARGUMENT)!!

        thread {
            try {
                val payload = JoseVerification.verify(cert, encoded)
                Handler(Looper.getMainLooper()).post { result.success(payload) }
            } catch (e: Exception) {
                Handler(Looper.getMainLooper()).post { result.error("500", "${e.message}", null) }
            }
        }
    }

    internal fun decrypt(call: MethodCall, result: Result) {
        if (!call.checkRequiredField(result, CERT_ARGUMENT, ENCODED_ARGUMENT))
            return

        val cert = call.argument<String>(CERT_ARGUMENT)!!
        val encoded = call.argument<String>(ENCODED_ARGUMENT)!!

        thread {
            try {
                val payload = JoseVerification.decrypt(cert, encoded)
                Handler(Looper.getMainLooper()).post { result.success(payload) }
            } catch (e: Exception) {
                Handler(Looper.getMainLooper()).post { result.error("500", "${e.message}", null) }
            }
        }
    }

    private const val CERT_ARGUMENT = "cert"
    private const val CERT_VERIFY_ARGUMENT = "certVerify"
    private const val CERT_DECRYPT_ARGUMENT = "certDecrypt"
    private const val ENCODED_ARGUMENT = "encoded"
}