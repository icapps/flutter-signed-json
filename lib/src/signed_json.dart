import 'package:signed_json/src/base_signed_json.dart';

class SignedJson {
  final _signedJsonUtil = SignedJsonUtil();

  final String verificationCert;
  final String? decryptionCert;

  SignedJson(
    this.verificationCert, {
    this.decryptionCert,
  });

  Future<T> verify<T>(String encoded) async =>
      _signedJsonUtil.run(parseAndDecode,
          await _signedJsonUtil.internalVerify(verificationCert, encoded));

  Future<T> decrypt<T>(String encoded) async {
    final decryptionCert = this.decryptionCert;
    if (decryptionCert == null) {
      throw ArgumentError('Decryption key can not be null');
    }
    return _signedJsonUtil.run(parseAndDecode,
        await _signedJsonUtil.internalDecrypt(decryptionCert, encoded));
  }

  Future<T> verifyAndDecrypt<T>(String encoded) async {
    final decryptionCert = this.decryptionCert;
    if (decryptionCert == null) {
      throw ArgumentError('Decryption key can not be null');
    }
    return _signedJsonUtil.verifyAndDecrypt<T>(
        verificationCert, decryptionCert, encoded);
  }
}
