package com.example.wallet_connect

import androidx.annotation.NonNull
import com.trustwallet.walletconnect.WCClient
import com.trustwallet.walletconnect.models.WCPeerMeta
import com.trustwallet.walletconnect.models.WCSignTransaction
import com.trustwallet.walletconnect.models.binance.WCBinanceCancelOrder
import com.trustwallet.walletconnect.models.binance.WCBinanceTradeOrder
import com.trustwallet.walletconnect.models.binance.WCBinanceTransferOrder
import com.trustwallet.walletconnect.models.binance.WCBinanceTxConfirmParam
import com.trustwallet.walletconnect.models.ethereum.WCEthereumSignMessage
import com.trustwallet.walletconnect.models.ethereum.WCEthereumTransaction
import com.trustwallet.walletconnect.models.session.WCSession

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import okhttp3.*

/** WalletConnectPlugin */
class WalletConnectPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var client : WCClient

  private var peerMeta = WCPeerMeta("Vision", "https://vision-crypto.com")

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "wallet_connect")
    channel.setMethodCallHandler(this)

    client = WCClient(httpClient = OkHttpClient())
    client.onFailure = ::onFailure
    client.onDisconnect = ::onDisconnect
    client.onSessionRequest = ::onSessionRequest
    client.onEthSign = ::onEthSign
    client.onEthSignTransaction = ::onEthSignTransaction
    client.onEthSendTransaction = ::onEthSendTransaction
    client.onCustomRequest = ::onCustomRequest
    client.onBnbTrade = ::onBnbTrade
    client.onBnbCancel = ::onBnbCancel
    client.onBnbTransfer = ::onBnbTransfer
    client.onBnbTxConfirm = ::onBnbTxConfirm
    client.onGetAccounts = ::onGetAccounts
    client.onSignTransaction = ::onSignTransaction
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "connectToSessionString") {
      var session = call.argument<String>("session")?.let { WCSession.from(it) }

      if(session == null) {
        result.error("missing_session", "No session provided", "null")
        return
      }

      client.connect(session, peerMeta)
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  private fun onFailure(throws: Throwable) {
  }

  private fun onDisconnect(code: Int, reason: String) {
  }

  private fun onSessionRequest(id: Long, peer: WCPeerMeta) {
  }

  private fun onEthSign(id: Long, message: WCEthereumSignMessage) {
  }

  private fun onEthSignTransaction(id: Long, transaction: WCEthereumTransaction) {
  }

  private fun onEthSendTransaction(id: Long, transaction: WCEthereumTransaction) {
  }

  private fun onCustomRequest(id: Long, payload: String) {
  }

  private fun onBnbTrade(id: Long, order: WCBinanceTradeOrder) {
  }

  private fun onBnbCancel(id: Long, order: WCBinanceCancelOrder) {
  }

  private fun onBnbTransfer(id: Long, order: WCBinanceTransferOrder) {
  }

  private fun onBnbTxConfirm(id: Long, order: WCBinanceTxConfirmParam) {
  }

  private fun onGetAccounts(id: Long) {
  }

  private fun onSignTransaction(id: Long, transaction: WCSignTransaction) {
  }

}
