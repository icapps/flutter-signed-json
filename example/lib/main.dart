import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:signed_json/signed_json.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const encoded =
      'eyJhbGciOiJSUzI1NiIsImtpZCI6Imdvb2RoYWJpdHoifQ.eNqr5lJQUCrOz02NL0mtKFGyUlAKBnJKMjLz0hXgLCUdrloAGIYNrw.A57sf7NcJrGhvpRbbRoG8U1qWpHaR85VdxWE8jHRo41ZaKz6pXZR7rKtNpFnCyQbaKYD-LPaG3NF4UwjYr6IKfDZfFSWKb_w_fYu3SIZYBO_nh_ToccqKA9xgxpiRfAjTDwbgYzCSDYFrgMXJVNTbf8vXhsVTgh3CqFabZfkdgasgRL7tHMNH8X6biYT__gjS6qamLw8GoR5iMLozyHJ2QRiY9Mr_4FPOlyVqJdZh_13lwPZUtW4WpXVNAF0gNQxyaUdEYwiW9bE6wwqG2dLY48df23lfV-imo6Y7_yhj2AGiW7XWJWpojNnqJaSxjPmnV8bKkZnSst2fZJcLygcAg';
  final _signedJson = TestSignedJson();

  var _data = '';

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Signed Test App'),
        ),
        body: Center(
          child: Text(
            _data,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Future<void> _getData() async {
    try {
      final data = await _signedJson.verify(encoded);
      _data = jsonEncode(data);
    } catch (e, stack) {
      print(stack);
      _data = e.toString();
    }
    setState(() {});
  }
}

class TestSignedJson extends SignedJson {
  static const verifycationKey = '''{
    "p": "wnDyage4Fa2zqIju792u92Omkg88ZvJNxd9ERwZrgKouU3VYWZ0B5caEBZWtvEKWWPtcRyRrsZfnp7sgftkAujMdwiv7IhP4EHliT2V5zeWhRt4Qj29tad3dulnchw1vyiQDnLc0RZy8SXvormvEy3WYqsw_6SASiTIjJZBo7mM",
    "kty": "RSA",
    "q": "wft-jITdCbloDmxqGf8rpxvFsn4tR_dvZmOQwhe2fXicfzPqp2mSxUB2ma1UYNxhe-doFRw6I6DbuQfNPiVn2jQV3WkQ0im3mgqtCZA1Pl_9liz1DamGuCsBHBsZweEaqiX7FfA5--QJm6PzeV30hsBSAFgBD0wmNyQX27wakjE",
    "d": "RsBXe6U7rTE-SZ_MjACNfCDcYnNuOdYGWHvEhJgoYDvKbkMr8sOg4XC-DBBVWCGFRpSlTkxfI4jAliXLibB_lX5Q749LNXnUn6R40gK1wd9bm_KqUNWPb_x23gk1fhopzkdMCuopvdA2alLtLukvE6acxN6yMVR7plEbxPNYqpXyhNE33hTtPPjn6BvtHpt2Ozx49hBMmX4zb9ErNp2yixPxlw6pf7j4IKF2uPM_nKwd4wOmQnD3EBuQsi9WpHBT8026AN0fYg5NDKZMr_-nganK3-UijkgYJwzFkAw4feSlhiMwylGIxWHd2fk8gftLRWKMRfaLe6BmLS1CjcEjoQ",
    "e": "AQAB",
    "qi": "qrh215WDw9pxTBf1KgbJAzMNhVJlpS84M2s13dDzenKxoeTLcKpyQezf6vwXK-TGBFU8vmzcLKcbKuYaVbX_hxE5_KwZHz68-POO8CpUo9_wWQwBeJOBzTyrmGSo7b1RRbwkNOsVlRu0dbV_gHnKHW3Ge2yt8Vs5wMbT9FcJJMw",
    "dp": "qNoMqacqZSkC60h-ti580rjm3c_9VCj3AO5yDHu2v3UJ5c_xeWCvVSqfW3ov9Vyd04f1CpLGMuMHeNE31u_7gbcCEKzA2UceFLBUfz5QGE1hUHlnSCgri9PvyPRgXad9fLzpph4ydoE1wVqpJU7RBx6IBUp59ai0cA_qFaTieqE",
    "dq": "SF0JWGI4EuiXaMoIyqnmHvC9T1jCi5ZCeG-sELvH2AamWs2DO_CmT-88TxfZ4khUFWS97yIYjjHzxZKjfgt2MnA7t9z56WymkVBqPKcPNbWZY-xhfjc_inSAdXumoCzZRZ_lismS1-S5sNX4fc4O6jXUYUxzGMHPf8J3JAGH6AE",
    "n": "k1Yrne_GO4DFyePjfsS4TNdOsgeSEJSBIXlqR6M-C3iRAWuYrOclc6DjN_n1m6Cs6D0SnHjbf_Zm_WAr21zVNFgyi-5avPjmQAb3hQkVleMBKFdRTMvqzEF9TKKvhSJVuYQALkEY7pVuoAQYhBcu4sEI0lpmHtGiInrldSt97eMm8s3pw6KMEgPEDAA-lil5MMruJO15qcBm1mmnFmFBfM3e4RD3GtK3dBdryDOugfygmTYbX2oISEwJGBz3MbI1PjnGiO1nKo86Bhm4wPFQwjf9u6M_RQw7FPUp6C9imNQ6q7pw3-tKpT68CTKztfjHvCA5HeINiHjEnLP2ZhgW8w"
}''';

  TestSignedJson() : super(verifycationKey);
}
