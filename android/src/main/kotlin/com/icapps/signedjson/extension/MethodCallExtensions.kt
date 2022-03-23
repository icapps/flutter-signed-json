package com.icapps.signedjson.extension

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

fun MethodCall.checkRequiredField(result: MethodChannel.Result, vararg keys: String): Boolean {
    for (key in keys)
        if (!hasArgument(key) && argument<Any?>(key) != null) {
            result.error("404", "$key is not passed to the android bridge", null)
            return false
        }
    return true
}