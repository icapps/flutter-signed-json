import 'package:signed_json/src/base_signed_json.dart';

class SignedBytes {
  final _signedJsonUtil = SignedJsonUtil();

  final String verificationCert;
  final String? decryptionCert;

  SignedBytes(
    this.verificationCert, {
    this.decryptionCert,
  });

  /// Verify an jwt encoded string against a public key. (verificationCert)
  /// JsonWebSignatur is used for verification.
  /// On Android we use a native implementation on all other platforms it is done in dart
  /// Bytes will be returned.
  Future<List<int>> verify<T>(String encoded) async =>
      _signedJsonUtil.internalVerify(verificationCert, encoded);

  /// Decrypt an jwt encoded string against a decryption key. (decryptionCert)
  /// JsonWebEncryption is used for decryption.
  /// On Android we use a native implementation on all other platforms it is done in dart
  /// Bytes will be returned.
  Future<List<int>> decrypt<T>(String encoded) async {
    final decryptionCert = this.decryptionCert;
    if (decryptionCert == null) {
      throw ArgumentError('Decryption key can not be null');
    }
    return _signedJsonUtil.internalDecrypt(decryptionCert, encoded);
  }
}
