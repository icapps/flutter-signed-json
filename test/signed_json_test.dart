import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:signed_json/signed_json.dart';

void main() {
  const MethodChannel channel = MethodChannel('signed_json');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      throw UnimplementedError();
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });
  const verifycationKey = '''{
    "kty": "EC",
    "use": "sig",
    "crv": "P-521",
    "kid": "signed_json",
    "x": "AT0MMaUvyZdRZaCIqkLZPks0NE4kPZhgTwIivnr0tDhcl7Ao9SSdiXPuCsZS3HaAuQq5Kk1sSWGwNtteiq5JsiSg",
    "y": "AVKxKaIYJewNWA3DvD5qzpW9vSMt6A1crUqVpQ-MKAOVsCL_RwwvQoedRoMbYpf6T7XLflECaI58pBtv8JfF8zVb",
    "alg": "ES512"
}''';

  test('verify', () async {
    const encoded =
        'eyJhbGciOiJFUzUxMiIsImtpZCI6InNpZ25lZF9qc29uIn0.eNqr5lJQUCrOz02NL0mtKFGyUlAKBnJKMjLz0hXgLCWuWgALBg2D.AXMx-2iQVtaDIaV14lXhw7j6hW0D0HKyWYu9kUz1W4W0j8gOlDU2YWipyEDWGAGXKgdmIpWl1SeWrVlXdJeVLYFlAe2pqriYxevIzEErRdP1VwLDP7lCiLERCaiz_usAAY2fiHVNqEqFhPr8bxpnWIxiEcoG2BB5zUEoEH_kZ51I0jgV';
    final result = await SignedJson(verifycationKey).verify(encoded);
    expect(result, '''{'some_text': 'Something Something'}''');
  });

  test('verifyAndDecrypt', () async {
    const encoded =
        'eyJhbGciOiJFUzUxMiIsImtpZCI6InNpZ25lZF9qc29uIn0.eNqr5lJQUCrOz02NL0mtKFGyUlAKBnJKMjLz0hXgLCWuWgALBg2D.AXMx-2iQVtaDIaV14lXhw7j6hW0D0HKyWYu9kUz1W4W0j8gOlDU2YWipyEDWGAGXKgdmIpWl1SeWrVlXdJeVLYFlAe2pqriYxevIzEErRdP1VwLDP7lCiLERCaiz_usAAY2fiHVNqEqFhPr8bxpnWIxiEcoG2BB5zUEoEH_kZ51I0jgV';
    final result = await SignedJson(verifycationKey).verify(encoded);
    expect(result, '''{'some_text': 'Something Something'}''');
  });
}
