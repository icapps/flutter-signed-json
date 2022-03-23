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
  static const publicKey = '''{
    "kty": "EC",
    "use": "sig",
    "crv": "P-521",
    "kid": "signed_json",
    "x": "AT0MMaUvyZdRZaCIqkLZPks0NE4kPZhgTwIivnr0tDhcl7Ao9SSdiXPuCsZS3HaAuQq5Kk1sSWGwNtteiq5JsiSg",
    "y": "AVKxKaIYJewNWA3DvD5qzpW9vSMt6A1crUqVpQ-MKAOVsCL_RwwvQoedRoMbYpf6T7XLflECaI58pBtv8JfF8zVb",
    "alg": "ES512"
}''';
  static const encoded = 'eyJhbGciOiJFUzUxMiIsImtpZCI6InNpZ25lZF9qc29uIn0.eNqr5lJQUCrOz02NL0mtKFGyUlAKBnJKMjLz0hXgLCWuWgALBg2D.AXMx-2iQVtaDIaV14lXhw7j6hW0D0HKyWYu9kUz1W4W0j8gOlDU2YWipyEDWGAGXKgdmIpWl1SeWrVlXdJeVLYFlAe2pqriYxevIzEErRdP1VwLDP7lCiLERCaiz_usAAY2fiHVNqEqFhPr8bxpnWIxiEcoG2BB5zUEoEH_kZ51I0jgV';
  final _signedJson = SignedJson(publicKey);

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
      print(stack); // ignore: avoid_print
      _data = e.toString();
    }
    setState(() {});
  }
}
