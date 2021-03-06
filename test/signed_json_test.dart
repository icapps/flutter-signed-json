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
    "p": "2DXmKMTnT1t8mi7MWuDn9YJ9aymtRO-L-Q2Hj3porAXYyeifD6tWpd3B283SzBNmJMSzb9ahCRrIXJbrh8xPoQWAacY-zEgth_Eujl0r4KyzjzOwFwjhk_9dB2g0PZx1bsZtW5Crq8s_NAyURJP45bzS4yYYpI6PT7e63bfchZ0",
    "kty": "RSA",
    "q": "sag_C3sbeLOdhzDknfs8zMsy6uFfBjmAT2BrE3-K5QHZXOCQ7304VhRIvt3BeDUYDF1Onu4RYB7yRfcYkI1yG5GI-Zx2jTwcGhADIs-ovGsKbY7H5SDLjAGNWOj4NfW2ObuuVB68DCeaatHJ30XXilFw9gRZBLtsgxtK9BPPHnc",
    "d": "hlv6XGfcUNJj5eTKCTDgYZuVrucW9Qd5fMIewRj-BSjuXycyGpqEsLQegv4p3Qan_FwQYHRshh6pDl8f746BsPspsQGvZwyht3y5HZfz_XJ0sY4gWNT5fAg6G3ch9W53PTEb2zX7SLKyWpM1H0Qapdt8r5WqC1oYNpHYc88mImk71pBLd_ywWvYqahq52VOyEiXHslRz4Wb8OFhrlU59aV7EErHMbuB6KdLpfTQBmjSEVEbeHRrzmGpgPfNXKRxBiN50DTfObBt3wDYxyO87F8fJm4pjqwwa034J_WROEa0YUPqjvn2Xj9KRRZhgoKmQUVmApjIr7oqqg84BSONGMQ",
    "e": "AQAB",
    "qi": "EYowTKshuJPVcmzUKuYmBYhAah0_AikBOO6lZLP65SGb3frVWBqAFGeKL-K72c4Cwlt74dZHVbkPVRUpFQuKGXtFI6DJTtorWdfvFUblsB2f-OeEK8QPSz5QGmSywZ8oD11hbpWUdua764ZqXQaEZnHyUUbUGguxEPMA8GHdQhk",
    "dp": "hcv0_k27htRqq09CjwqXAMsbqfFElGBZEmpY9WUe2TVVDr2xkRTKriIpEUixpjBrCV3gXNlJFkVIsGOEpai9rjulV8-ilPAlnPaXhOoLeSHmjDvEQLzyO4_PlgHaMjZcRYztp7hDRDCmkCMorbeUUzcimga9QTgnX4GnVgWtpdE",
    "dq": "dPccauamc5VuBW__VLPwl7TA1TuEYIjDHX-Rf8jdHWFWRnvjcIm06Zd5PZCqrAXoy1szRBfhgLNfNwk0NxepJNVwpUaKFvqYVeBs8CJgKY0f1HnIyeYJnSf4c60Onhgj3Wbfo6qIjEgWtnVgv4swGXT9Njwuj5sGGluBwai5GIk",
    "n": "lgtcwDDTKxWLLnpVTGCad7LWnRPSO3nh0Imd1GT0cxZyIggwYDuaHPN6IQQc6Lv68_giQRZmWSjntQGAfvNdIXY38QstgD11P2ks3LtfQBdkBnfmIudCTRQr4eOHn4t_UErKRJB4LnmLTtlkqgbC0wj4lsSRWld8gj8thbwLoLKry8ouvwV2G_ST7SLecVQsaK5zceIV_AirXHnCgVHLC_RFcyWcYj1PlmwoSzvC4AcLj3GBPbV-ag_khXbaGp_fEt7niFhGtx2QtiWHv3UJuYFJ_mn81QW_NGJwa3qepKvc_F4HnVWCzkcpALJbjUsZKio1ETmvpLqPmJ17AB2B-w"
}''';

  test('verify', () async {
    const encoded =
        'eyJhbGciOiJFUzUxMiIsImtpZCI6InNpZ25lZF9qc29uIn0.eNqr5lJQUCrOz02NL0mtKFGyUlAKBnJKMjLz0hXgLCWuWgALBg2D.AXMx-2iQVtaDIaV14lXhw7j6hW0D0HKyWYu9kUz1W4W0j8gOlDU2YWipyEDWGAGXKgdmIpWl1SeWrVlXdJeVLYFlAe2pqriYxevIzEErRdP1VwLDP7lCiLERCaiz_usAAY2fiHVNqEqFhPr8bxpnWIxiEcoG2BB5zUEoEH_kZ51I0jgV';
    final result = await SignedJson(verifycationCert)
        .verify<Map<String, dynamic>>(encoded);
    expect(jsonEncode(result), '{"some_text":"Something Something"}');
  });

  test('decrypt', () async {
    const encrypted =
        'eyJlbmMiOiJBMTI4Q0JDLUhTMjU2IiwiYWxnIjoiUlNBMV81In0.a5a73YZgaQwTH3V5pqMXUIuAxKUqZdH5rQxN9RBWNiizJK03BamKqOZjbHuWv18qwAkgWxudRXF4io2vVZv5gChmpwQ3KjzS2z4ccMY5GNnf-_5SSX2bzIvoEJvBaFvseA049cBsdvcfTKKZZXJXe_z4k_iB-hyvo5JOQ8ki30sToDeMT9sVkLfh9icMP-DJ73zzqmsK9twpZgjChmEdHqJbx5xmejfSjdW76-RTWm3LEFkTBsg_Ye3Lupj9qmAkIQvC9Xgbvu2tCcmgSLpQz135H33GSP_cYnRfX0ho-nXPOpvba4ASJL68S_BBmrpCTG2U1w95RKufqVhwKKZUQg.tSsXy0GVk6CsJnnkbjO-nQ.KPFLPN8tLK3vqAvLvLO9IO6Q88vPVPNO1YoiP3tsaP_sbNTa92W514eakZ0QiaNU.5TWtnlE_Bbx4xo95mRoITw';
    final result =
        await SignedJson(verifycationCert, decryptionCert: decryptCert)
            .decrypt<Map<String, dynamic>>(encrypted);
    expect(jsonEncode(result), '{"some_text":"Something Something"}');
  });
}
