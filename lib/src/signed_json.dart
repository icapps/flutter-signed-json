import 'dart:convert';

import 'package:signed_json/src/base_signed_json.dart';

class SignedJson {
  final _signedJsonUtil = SignedJsonUtil();

  final String verificationCert;
  final String? decryptionCert;

  SignedJson(
    this.verificationCert, {
    this.decryptionCert,
  });

  /// Verify an jwt encoded string against a public key. (verificationCert)
  /// JsonWebSignatur is used for verification.
  /// On Android we use a native implementation on all other platforms it is done in dart
  /// Json string will be returned.
  Future<T> verify<T>(String encoded) async {
    final result =
        await _signedJsonUtil.internalVerify(verificationCert, encoded);
    final param = utf8.decode(result);
    return _signedJsonUtil.run(parseAndDecode, param);
  }

  /// Decrypt an jwt encoded string against a decryption key. (decryptionCert)
  /// JsonWebEncryption is used for decryption.
  /// On Android we use a native implementation on all other platforms it is done in dart
  /// Json string will be returned.
  Future<T> decrypt<T>(String encoded) async {
    final decryptionCert = this.decryptionCert;
    if (decryptionCert == null) {
      throw ArgumentError('Decryption key can not be null');
    }
    final result =
        await _signedJsonUtil.internalDecrypt(decryptionCert, encoded);
    final param = utf8.decode(result);
    return _signedJsonUtil.run(parseAndDecode, param);
  }

  /// First a jwt is verified using (verify) after that you get another jwt
  /// this new jwt is used to decrypt using (decrypt)
  Future<T> verifyAndDecrypt<T>(String encoded) async {
    final decryptionCert = this.decryptionCert;
    if (decryptionCert == null) {
      throw ArgumentError('Decryption key can not be null');
    }
    return _signedJsonUtil.verifyAndDecrypt<T>(
        verificationCert, decryptionCert, encoded);
  }
}
