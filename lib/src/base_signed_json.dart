import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:computer/computer.dart';
import 'package:flutter/foundation.dart';
import 'package:jose/jose.dart';
import 'package:signed_json/src/bridge/native_signed_json.dart';
import 'package:signed_json/src/model/computer_args.dart';

class SignedJsonUtil {
  late final Computer computer;
  late final Future<void> computerStarting;

  bool get useNativeSignedJson => Platform.isAndroid;

  SignedJsonUtil() {
    if (!Platform.isIOS) _startComputer();
  }

  Future<void> _startComputer() async {
    final completer = Completer<void>();
    computerStarting = completer.future;
    computer = Computer.shared();
    await computer.turnOn();
    completer.complete();
  }

  Future<R> run<P, R>(FutureOr<R> Function(P) function, P param) async {
    if (Platform.isIOS) return compute(function, param);
    await computerStarting;
    return computer.compute(function, param: param);
  }

  Future<String> internalVerify(String cert, String encoded) async {
    if (useNativeSignedJson) return NativeSignedJson.verify(cert, encoded);
    final map = ComputerArgs(cert: cert, encoded: encoded).toJson();
    return run(_verifyOnBackgroundThread, map);
  }

  Future<String> internalDecrypt(String cert, String ciphertext) async {
    if (useNativeSignedJson) return NativeSignedJson.decrypt(cert, ciphertext);
    final map = ComputerArgs(cert: cert, encoded: ciphertext).toJson();
    return run(_decryptOnBackgroundThread, map);
  }

  Future<T> verifyAndDecrypt<T>(
      String certVerify, String certDecrypt, String encoded) async {
    String result;
    if (useNativeSignedJson) {
      result = await NativeSignedJson.verifyAndDecrypt(
          certVerify, certDecrypt, encoded);
    } else {
      result = await internalDecrypt(
          certDecrypt, await internalVerify(certVerify, encoded));
    }
    return run(parseAndDecode, result);
  }
}

Future<String> _verifyOnBackgroundThread(Map<String, dynamic> data) async {
  final arguments = ComputerArgs.fromJson(data);
  final jws = JsonWebSignature.fromCompactSerialization(arguments.encoded);
  final jwk =
      JsonWebKey.fromJson(jsonDecode(arguments.cert) as Map<String, dynamic>);
  final keyStore = JsonWebKeyStore()..addKey(jwk);
  final payload = await jws.getPayload(keyStore);
  final unzipped = ZLibCodec().decoder.convert(payload.data);
  return utf8.decode(unzipped);
}

Future<String> _decryptOnBackgroundThread(Map<String, dynamic> data) async {
  final arguments = ComputerArgs.fromJson(data);
  final jwe = JsonWebEncryption.fromCompactSerialization(arguments.encoded);
  final jwk =
      JsonWebKey.fromJson(jsonDecode(arguments.cert) as Map<String, dynamic>);
  final keyStore = JsonWebKeyStore()..addKey(jwk);
  final payload = await jwe.getPayload(keyStore);
  final unzipped = ZLibCodec().decoder.convert(payload.data);
  return utf8.decode(unzipped);
}

T parseAndDecode<T>(String response) => jsonDecode(response) as T;
