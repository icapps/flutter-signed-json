import 'dart:convert';

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
  const verifycationCert = '''{
    "kty": "EC",
    "use": "sig",
    "crv": "P-521",
    "kid": "signed_json",
    "x": "AT0MMaUvyZdRZaCIqkLZPks0NE4kPZhgTwIivnr0tDhcl7Ao9SSdiXPuCsZS3HaAuQq5Kk1sSWGwNtteiq5JsiSg",
    "y": "AVKxKaIYJewNWA3DvD5qzpW9vSMt6A1crUqVpQ-MKAOVsCL_RwwvQoedRoMbYpf6T7XLflECaI58pBtv8JfF8zVb",
    "alg": "ES512"
}''';
  const decryptCert = '''{
    "p": "9MtlbJu1GqQ44CZnauptbxR8LMRqja0gh-2LLajHcGuaayegcTnSyMI33ecZo3k4aaIsbglKOFM93dNDMIkbMjsUAs3aLUMWh5rZblJqoS1eBk02mLe9ybgpO6Vaof9aCIWovR59MotSAFeWsA1QTi_ZgUdHmVpak-hsEkZFo5s",
    "kty": "RSA",
    "q": "7482MJG7HhOYyzh6Z0Ri6993TNUSApjaOHyAAlAreCNpG8_0IOiPzdnHihVtYJBskF5zJw1XWEv-efv-INP1fojkApPtZKwPgxDGwf2Ynie4Hm2kD7iF2ShHAwHcGGQJpEmqcLgqV6wtAJyRwtN_F-IajRfb_wOUHH8laNYpDns",
    "d": "W98NsqYBgYax7OCeYXMfrAH_y7IcGfQf37iodfyVVS7LNMIJxFD_L3Ch4ZurRmp8cY3KQfsUJPFtdwOVWjWR-TqCWptGlRAluzFYu6Dw_C00YEEOPYhwlzf7FEtg1sDTanTHxvqs1B2lNfgXpXgEzwJVFkpUzmxBR96KrQY_L-qFe0ODHdHiZBr1veRTmo4dd_exrrn8tXO8CzIUkMJaofxDnqOQb98MDaAoncjawWlFgFcGLQyC9a0d2xLxVMyQ4cIZS1FTP_i-utOFKBLAM2PmyXmeVyliZn7dqJWa9Jh-6HFXaFWuUrkRglTKz73QvvEVspU_xLpcR9Tz_bufMQ",
    "e": "AQAB",
    "qi": "a2H0BBAKe43HJiHeiv0vQjZxvIlFKqdZhgzjqzE7cqzWyYNTD00s2Zaaqv-upVFZqp3hyNU9EL_SS9oOVccS6IXrmXLAh0PP7UYYRrXa1uwG9dNm-FRXiDUUR9C38i2plhxaLzj9Wfzb74y9gY4oEf3AzYav59i02ujLggjhXXM",
    "dp": "bDSQI578Qcd_oI05P4haUTSD4yH7W57Ad3UoBUnKxsW5n04H3KTLqJQ5L6xcp-cIaaEW9JjEpvscqLYeyBCC5gQ5RzgJDeLOzahEHkDuA0rTegOdc4ocqVLvXv8rfdoqyQOT3-zfOH1fBOmyoSVxbu41vbBtVLscuK6PPtCzLas",
    "dq": "pqK0rBZC1YoGJ54yrrCIKtC3uI8hxwKyEMaxeGpxwlDHZVxC0b1TgnoxbaC4A4qSqd25Nfn2vumlqw6ZWBZ4Vrs793sUj4mMBLxftUMErUatsSTNEU5mdIaq1rGtep3jgw7m6x9__Jo8d4dxcNcTOfbCR1DIa9v-Y9AhoooN5w8",
    "n": "5RLVH2XrHQbGBlYNp-OmEvNMJHv3PB20YQNkJopqODga1qM5XuRpgWGa9kZ8TLpAjjjq186o2Uo9j0M_NYTuGyi_QsqtNx1dBx7a17GU1aJFFrAogPEPdqLLGKVkaxNiP21hPU52MKUfFeheGfGHh3PJipJcQyz-rTXTxvkRPbI7_YFg9bKcHzrCj0Ad1Jn3-m36dfPjwdWtWlMucRaM0DhzAmcsre5zW6Ot79dQzyDRHHH8Xp1bgM820CizG_urQYYia5V0anQ4SYx5qyMUYaHfM42iVF3o7IcxcNHbzC8TUf78sEBc_T8S_GaZfeYxy2CaMUYixM4XFUKCWDsVeQ"
}''';

  test('verify', () async {
    const encoded =
        'eyJhbGciOiJFUzUxMiIsImtpZCI6InNpZ25lZF9qc29uIn0.eNqr5lJQUCrOz02NL0mtKFGyUlAKBnJKMjLz0hXgLCWuWgALBg2D.AXMx-2iQVtaDIaV14lXhw7j6hW0D0HKyWYu9kUz1W4W0j8gOlDU2YWipyEDWGAGXKgdmIpWl1SeWrVlXdJeVLYFlAe2pqriYxevIzEErRdP1VwLDP7lCiLERCaiz_usAAY2fiHVNqEqFhPr8bxpnWIxiEcoG2BB5zUEoEH_kZ51I0jgV';
    final result = await SignedJson(verifycationCert).verify(encoded);
    expect(jsonEncode(result), '{"some_text":"Something Something"}');
  });

  test('verifyAndDecrypt', () async {
    const encrypted =
        'eyJlbmMiOiJBMTI4Q0JDLUhTMjU2IiwiYWxnIjoiUlNBMV81In0.3PmlqZ5BieGsB15CdMOvoj3qyeuZj4gdtEXZyFYA8HwhPThh_xVSie0uX47_ba_WrL5wMAtj_yjhWLCrJLoFPg8si4kjCuvYLMkliCRx-GkZqIZPsNMqJx4ghmUACb0FIChs9knUel1esIDjIy4wLTT-FQQ33qiKDsfo5K9ESCOZToj3elVB9SNr00eCQ47_OFHMkBd3QYX9AaZfuWKHkTzvhZfMpNmrZUFUwWwhCtEdiS3gx4_VO0CjwewhRznDmSqPosvHP-fjizdT9CVNHuGIW4S_jYrvszREvxM4yUHPETD6EJjkjHfd_5cnWLIKZfMnNWupwmaufSO1TeVY5g.zb14qmeetqm1Ov2jv9XqKg.Ic0n3CaPWIFgbUV9XAyojAjI0gOnbjnljVWrOAWkFXj8EKpXiH5CdQBXSyL1Autp.sgbKM0FpS605sH3zJLph6w';
    final result = await SignedJson(verifycationCert, decryptionCert: decryptCert).verifyAndDecrypt(encrypted);
    expect(jsonEncode(result), '{"some_text":"Something Something"}');
  });
}
