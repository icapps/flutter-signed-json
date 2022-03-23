import 'package:signed_json/src/base_signed_json.dart';

class SignedJson {
  final _signedJsonUtil = SignedJsonUtil();

  final String verificationKey;

  SignedJson(
    this.verificationKey,
  );

  Future<Map<String, dynamic>> verify(String encoded) async => _signedJsonUtil.run(parseAndDecode, await _signedJsonUtil.internalVerify(verificationKey, encoded));

  Future<List<dynamic>> verifyList(String encoded) async => _signedJsonUtil.run(parseAndDecode, await _signedJsonUtil.internalVerify(verificationKey, encoded));
}
