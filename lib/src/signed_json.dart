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
  Future<T> verify<T>(String encoded) async => _signedJsonUtil.run(
      parseAndDecode,
      await _signedJsonUtil.internalVerify(verificationCert, encoded));

  /// Decrypt an jwt encoded string against a decryption key. (decryptionCert)
  /// JsonWebEncryption is used for decryption.
  /// On Android we use a native implementation on all other platforms it is done in dart
  Future<T> decrypt<T>(String encoded) async {
    final decryptionCert = this.decryptionCert;
    if (decryptionCert == null) {
      throw ArgumentError('Decryption key can not be null');
    }
    return _signedJsonUtil.run(parseAndDecode,
        await _signedJsonUtil.internalDecrypt(decryptionCert, encoded));
  }

  /// First a jwt is verified using (verify) after that you get another jwt
  /// this new jwt is used to decrypt using (dycrypt)
  Future<T> verifyAndDecrypt<T>(String encoded) async {
    final decryptionCert = this.decryptionCert;
    if (decryptionCert == null) {
      throw ArgumentError('Decryption key can not be null');
    }
    return _signedJsonUtil.verifyAndDecrypt<T>(
        verificationCert, decryptionCert, encoded);
  }
}
