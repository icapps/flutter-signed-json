import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

class NativeSignedJson {
  static const MethodChannel _channel = MethodChannel('signed_json');

  static Future<List<int>> verify(String cert, String encoded) async {
    final zipBytes = await _channel.invokeMethod<List<int>>(
          'verify',
          {
            'cert': "{\"keys\": [$cert]}",
            'encoded': encoded,
          },
        ) ??
        [];
    return ZLibCodec().decoder.convert(zipBytes);
  }

  static Future<List<int>> verifyAndDecrypt(
      String certVerify, String certDecrypt, String encoded) async {
    final zipBytes = await _channel.invokeMethod<List<int>>(
          'verifyAndDecrypt',
          {
            'certVerify': "{\"keys\": [$certVerify]}",
            'certDecrypt': certDecrypt,
            'encoded': encoded,
          },
        ) ??
        [];
    return ZLibCodec().decoder.convert(zipBytes);
  }

  static Future<List<int>> decrypt(String cert, String encoded) async {
    final zipBytes = await _channel.invokeMethod<List<int>>(
          'decrypt',
          {
            'cert': cert,
            'encoded': encoded,
          },
        ) ??
        [];
    return ZLibCodec().decoder.convert(zipBytes);
  }
}
