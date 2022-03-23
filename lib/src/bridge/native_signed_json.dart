import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';

class NativeSignedJson {
  static const MethodChannel _channel = MethodChannel('jose');

  static Future<String> verify(String cert, String encoded) async {
    final zipBytes = await _channel.invokeMethod<List<int>>(
          'verify',
          {
            'cert': "{\"keys\": [$cert]}",
            'encoded': encoded,
          },
        ) ??
        [];
    final unzipped = ZLibCodec().decoder.convert(zipBytes);
    return utf8.decode(unzipped);
  }

  static Future<String> verifyAndDecrypt(
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
    final unzipped = ZLibCodec().decoder.convert(zipBytes);
    return utf8.decode(unzipped);
  }

  static Future<String> decrypt(String cert, String encoded) async {
    final zipBytes = await _channel.invokeMethod<List<int>>(
          'decrypt',
          {
            'cert': cert,
            'encoded': encoded,
          },
        ) ??
        [];
    final unzipped = ZLibCodec().decoder.convert(zipBytes);
    return utf8.decode(unzipped);
  }
}
