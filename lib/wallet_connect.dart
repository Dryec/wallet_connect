import 'dart:async';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:wallet_connect/enums.dart';

class WalletConnect {
  static MethodChannel _channel = MethodChannel('wallet_connect')
    ..setMethodCallHandler(_handleMethod);

  static ObserverList<Function(WalletConnectEvent event, dynamic arguments)>
      _listeners;

  static Future addListener(
      Function(WalletConnectEvent event, dynamic arguments) listener) async {
    _listeners.add(listener);
  }

  static Future removeListener(
      Function(WalletConnectEvent event, dynamic arguments) listener) async {
    _listeners.remove(listener);
  }

  static Future<dynamic> _handleMethod(MethodCall call) async {
    print(call);
    final eventType = walletConnectEventValues.reverse[call.method];
    /*switch (eventType) {
      case WalletConnectEvent.onFailure:
        break;
      case WalletConnectEvent.onDisconnect:
        break;
      case WalletConnectEvent.onSessionRequest:
        break;
      case WalletConnectEvent.onEthSign:
        break;
      case WalletConnectEvent.onEthSignTransaction:
        break;
      case WalletConnectEvent.onEthSendTransaction:
        break;
      case WalletConnectEvent.onCustomRequest:
        break;
      case WalletConnectEvent.onBnbTrade:
        break;
      case WalletConnectEvent.onBnbCancel:
        break;
      case WalletConnectEvent.onBnbTransfer:
        break;
      case WalletConnectEvent.onBnbTxConfirm:
        break;
      case WalletConnectEvent.onGetAccounts:
        break;
      case WalletConnectEvent.onSignTransaction:
        break;
      default:
        throw UnsupportedError('The method ${call.method} is not supported');
    }*/
    if (eventType != null) {
      _listeners.forEach((v) {
        v(eventType, call.arguments);
      });
    } else {
      throw UnsupportedError('The method ${call.method} is not supported');
    }
  }

  static Future connect() async {
    var result = await BarcodeScanner.scan();
    await _channel
        .invokeMethod('connectToSessionString', {'session': result.rawContent});
  }
}
