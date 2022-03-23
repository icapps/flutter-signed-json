import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:jose/jose.dart';
import 'package:signed_json/src/bridge/native_signed_json.dart';
import 'package:signed_json/src/model/computer_args.dart';

class SignedJsonUtil {
  late final Future<void> computerStarting;

  bool get useNativeSignedJson => Platform.isAndroid;

  Future<R> run<P, R>(FutureOr<R> Function(P) function, P param) async =>
      compute(function, param);

  Future<List<int>> internalVerify(String cert, String encoded) async {
    if (useNativeSignedJson) return NativeSignedJson.verify(cert, encoded);
    final map = ComputerArgs(cert: cert, encoded: encoded).toJson();
    return run(_verifyOnBackgroundThread, map);
  }

  Future<List<int>> internalDecrypt(String cert, String ciphertext) async {
    if (useNativeSignedJson) return NativeSignedJson.decrypt(cert, ciphertext);
    final map = ComputerArgs(cert: cert, encoded: ciphertext).toJson();
    return run(_decryptOnBackgroundThread, map);
  }

  Future<T> verifyAndDecrypt<T>(
      String certVerify, String certDecrypt, String encoded) async {
    List<int> result;
    if (useNativeSignedJson) {
      result = await NativeSignedJson.verifyAndDecrypt(
          certVerify, certDecrypt, encoded);
    } else {
      final encryptedBytes = await internalVerify(certVerify, encoded);
      final encryptedValue = utf8.decode(encryptedBytes);
      result = await internalDecrypt(certDecrypt, encryptedValue);
    }
    final stringValue = utf8.decode(result);
    return run(parseAndDecode, stringValue);
  }
}

Future<List<int>> _verifyOnBackgroundThread(Map<String, dynamic> data) async {
  final arguments = ComputerArgs.fromJson(data);
  final jws = JsonWebSignature.fromCompactSerialization(arguments.encoded);
  final jwk =
      JsonWebKey.fromJson(jsonDecode(arguments.cert) as Map<String, dynamic>);
  final keyStore = JsonWebKeyStore()..addKey(jwk);
  final payload = await jws.getPayload(keyStore);
  return ZLibCodec().decoder.convert(payload.data);
}

Future<List<int>> _decryptOnBackgroundThread(Map<String, dynamic> data) async {
  final arguments = ComputerArgs.fromJson(data);
  final jwe = JsonWebEncryption.fromCompactSerialization(arguments.encoded);
  final jwk =
      JsonWebKey.fromJson(jsonDecode(arguments.cert) as Map<String, dynamic>);
  final keyStore = JsonWebKeyStore()..addKey(jwk);
  final payload = await jwe.getPayload(keyStore);
  return ZLibCodec().decoder.convert(payload.data);
}

T parseAndDecode<T>(String response) => jsonDecode(response) as T;
