import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

class SignedJsonWeb {
  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel(
      'signed_json',
      const StandardMethodCodec(),
      registrar,
    );

    final pluginInstance = SignedJsonWeb();
    channel.setMethodCallHandler(pluginInstance.handleMethodCall);
  }

  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details: 'signed_json for web doesn\'t implement \'${call.method}\'',
        );
    }
  }
}
