class EnumValues<T, T2> {
  Map<T, T2> map;
  Map<T2, T> _reverseMap;

  EnumValues(this.map);

  Map<T2, T> get reverse {
    _reverseMap ??= map.map((k, v) => MapEntry(v, k));
    return _reverseMap;
  }
}

enum WalletConnectEvent {
  onFailure,
  onDisconnect,
  onSessionRequest,
  onEthSign,
  onEthSignTransaction,
  onEthSendTransaction,
  onCustomRequest,
  onBnbTrade,
  onBnbCancel,
  onBnbTransfer,
  onBnbTxConfirm,
  onGetAccounts,
  onSignTransaction,
}

final walletConnectEventValues = EnumValues<WalletConnectEvent, String>({
  WalletConnectEvent.onFailure: 'onFailure',
  WalletConnectEvent.onDisconnect: 'onDisconnect',
  WalletConnectEvent.onSessionRequest: 'onSessionRequest',
  WalletConnectEvent.onEthSign: 'onEthSign',
  WalletConnectEvent.onEthSignTransaction: 'onEthSignTransaction',
  WalletConnectEvent.onEthSendTransaction: 'onEthSendTransaction',
  WalletConnectEvent.onCustomRequest: 'onCustomRequest',
  WalletConnectEvent.onBnbTrade: 'onBnbTrade',
  WalletConnectEvent.onBnbCancel: 'onBnbCancel',
  WalletConnectEvent.onBnbTransfer: 'onBnbTransfer',
  WalletConnectEvent.onBnbTxConfirm: 'onBnbTxConfirm',
  WalletConnectEvent.onGetAccounts: 'onGetAccounts',
  WalletConnectEvent.onSignTransaction: 'onSignTransaction',
});
