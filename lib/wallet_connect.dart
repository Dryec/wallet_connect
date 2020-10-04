import 'dart:async';
import 'dart:convert';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:wallet_connect/enums.dart';
import 'package:wallet_connect/models/peer_meta.dart';

class WalletConnect {
  static MethodChannel _channel = MethodChannel('wallet_connect')
    ..setMethodCallHandler(_handleMethod);

  static bool isConnected = false;
  static Map<String, dynamic> currentSession;
  static PeerMeta latestPeerInfo;

  static ObserverList<Function(WalletConnectEvent event, dynamic arguments)>
      _listeners =
      ObserverList<Function(WalletConnectEvent event, dynamic arguments)>();

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
    switch (eventType) {
      case WalletConnectEvent.onFailure:
        break;
      case WalletConnectEvent.onDisconnect:
        break;
      case WalletConnectEvent.onSessionRequest:
        latestPeerInfo =
            call.arguments != null && call.arguments['peer'] != null
                ? PeerMeta.fromJson(call.arguments['peer'])
                : null;
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
    }
    await _updateIsConnected();
    await _updateCurrentSession();
    if (eventType != null) {
      _listeners.forEach((v) {
        v(eventType, call.arguments);
      });
    } else {
      throw UnsupportedError('The method ${call.method} is not supported');
    }
  }

  static Future _updateIsConnected() async {
    isConnected = await _channel.invokeMethod('isConnected') ?? false;
  }

  static Future _updateCurrentSession() async {
    final data = await _channel.invokeMethod('getCurrentSession');
    currentSession = data != null ? json.decode(data) : null;
  }

  static Future connect(String session) async {
    await _channel.invokeMethod('connectToSessionString', {'session': session});
  }

  static Future<bool> disconnect() async {
    return await _channel.invokeMethod('disconnect') ?? false;
  }

  static Future approveSession(
      {@required List<String> accounts, @required int chainId}) async {
    await _channel.invokeMethod(
        'approveSession', {'accounts': accounts, 'chain_id': chainId});
  }
}
