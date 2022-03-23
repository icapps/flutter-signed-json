import 'package:signed_json/src/base_signed_json.dart';

class SignedJson {
  final _signedJsonUtil = SignedJsonUtil();

  final String verificationCert;
  final String? decryptionCert;

  SignedJson(
    this.verificationCert, {
    this.decryptionCert,
  });

  Future<Map<String, dynamic>> verify(String encoded) async =>
      _signedJsonUtil.run(parseAndDecode,
          await _signedJsonUtil.internalVerify(verificationCert, encoded));

  Future<List<dynamic>> verifyList(String encoded) async => _signedJsonUtil.run(
      parseAndDecode,
      await _signedJsonUtil.internalVerify(verificationCert, encoded));

  Future<String> decrypt(String encoded) async {
    final decryptionCert = this.decryptionCert;
    if (decryptionCert == null) {
      throw ArgumentError('Decryption key can not be null');
    }
    return _signedJsonUtil.run(parseAndDecode,
        await _signedJsonUtil.internalDecrypt(decryptionCert, encoded));
  }

  Future<Map<String, dynamic>> verifyAndDecrypt(String encoded) async {
    final decryptionCert = this.decryptionCert;
    if (decryptionCert == null) {
      throw ArgumentError('Decryption key can not be null');
    }
    return _signedJsonUtil.verifyAndDecrypt<Map<String, dynamic>>(
        verificationCert, decryptionCert, encoded);
  }

  Future<List<dynamic>> verifyAndDecryptList(String encoded) async {
    final decryptionCert = this.decryptionCert;
    if (decryptionCert == null) {
      throw ArgumentError('Decryption key can not be null');
    }
    return await _signedJsonUtil.verifyAndDecrypt<List<dynamic>>(
        verificationCert, decryptionCert, encoded);
  }
}
