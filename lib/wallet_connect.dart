
import 'dart:async';

import 'package:flutter/services.dart';

class WalletConnect {
  static const MethodChannel _channel =
      const MethodChannel('wallet_connect');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
