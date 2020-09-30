import 'dart:async';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

class WalletConnect {
  static const MethodChannel _channel = const MethodChannel('wallet_connect');

  static Future connect() async {
    var result = await BarcodeScanner.scan();
    await _channel
        .invokeMethod('connectToSessionString', {'session': result.rawContent});
  }
}
