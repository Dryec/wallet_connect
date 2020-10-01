package com.example.wallet_connect

import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.annotation.NonNull
import com.google.gson.Gson
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
import okhttp3.OkHttpClient
import java.util.concurrent.TimeUnit


/** WalletConnectPlugin */
class WalletConnectPlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var client: WCClient

    private val peerMeta = WCPeerMeta("Vision", "https://vision-crypto.com")

    private val gson = Gson()

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "wallet_connect")
        channel.setMethodCallHandler(this)

        val httpClient = OkHttpClient.Builder()
                //.connectTimeout(10, TimeUnit.SECONDS)
                //.writeTimeout(10, TimeUnit.SECONDS)
                //.readTimeout(30, TimeUnit.SECONDS)
                .build()

        client = WCClient(httpClient = httpClient)
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
      when (call.method) {
          "connectToSessionString" -> {
            val session = call.argument<String>("session")?.let { WCSession.from(it) }

            if (session == null) {
              result.error("missing_session", "No session provided", "null")
              return
            }
            client.connect(session, peerMeta)
          }
          "approveSession" -> {
            val accounts = call.argument<List<String>>("accounts")
            val chainId = call.argument<Int>("chain_id")
            if (accounts == null) {
              result.error("missing_accounts", "No accounts provided", "null")
              return
            }
            if (chainId == null) {
              result.error("missing_chain_id", "No chain_id provided", "null")
              return
            }
            client.approveSession(accounts, chainId)
          }
          else -> {
            result.notImplemented()
          }
      }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun runOnUiThread(task: Runnable) {
        Handler(Looper.getMainLooper()).post(task)
    }

    private fun onFailure(throws: Throwable) {
        Log.d("WalletConnect", "onFailure")
        runOnUiThread(Runnable {
          channel.invokeMethod("onFailure", mapOf("message" to throws.message, "localizedMessage" to throws.localizedMessage))
        })
    }

    private fun onDisconnect(code: Int, reason: String) {
        Log.d("WalletConnect", "onDisconnect")
        runOnUiThread(Runnable {
          channel.invokeMethod("onDisconnect", mapOf("code" to code, "reason" to reason))
        })
    }

    private fun onSessionRequest(id: Long, peer: WCPeerMeta) {
        Log.d("WalletConnect", "onSessionRequest")
        runOnUiThread(Runnable {
          //channel.invokeMethod("onSessionRequest", mapOf("id" to id, "peer" to mapOf("name" to peer.name, "url" to peer.url, "description" to peer.description, "icons" to peer.icons)))
          channel.invokeMethod("onSessionRequest", mapOf("id" to id, "peer" to gson.toJson(peer)))
        })
    }

    private fun onEthSign(id: Long, message: WCEthereumSignMessage) {
        Log.d("WalletConnect", "onEthSign")
        runOnUiThread(Runnable {
          //channel.invokeMethod("onEthSign", mapOf("id" to id, "message" to mapOf("raw" to message.raw,"type" to message.type.ordinal,"data" to message.data)))
          channel.invokeMethod("onEthSign", mapOf("id" to id, "message" to gson.toJson(message)))
        })
    }

    private fun onEthSignTransaction(id: Long, transaction: WCEthereumTransaction) {
        Log.d("WalletConnect", "onEthSignTransaction")
        runOnUiThread(Runnable {
          channel.invokeMethod("onEthSignTransaction", mapOf("id" to id, "transaction" to gson.toJson(transaction)))
        })
    }

    private fun onEthSendTransaction(id: Long, transaction: WCEthereumTransaction) {
        Log.d("WalletConnect", "onEthSendTransaction")
        runOnUiThread(Runnable {
          channel.invokeMethod("onEthSendTransaction", mapOf("id" to id, "transaction" to gson.toJson(transaction)))
        })
    }

    private fun onCustomRequest(id: Long, payload: String) {
        Log.d("WalletConnect", "onCustomRequest")
        runOnUiThread(Runnable {
          channel.invokeMethod("onCustomRequest", mapOf("id" to id, "payload" to payload))
        })
    }

    private fun onBnbTrade(id: Long, order: WCBinanceTradeOrder) {
        Log.d("WalletConnect", "onBnbTrade")
        runOnUiThread(Runnable {
          //channel.invokeMethod("onBnbTrade", mapOf("code" to code, "reason" to reason))
        })
    }

    private fun onBnbCancel(id: Long, order: WCBinanceCancelOrder) {
        Log.d("WalletConnect", "onBnbCancel")
        runOnUiThread(Runnable {
          //channel.invokeMethod("onBnbCancel", mapOf("code" to code, "reason" to reason))
        })
    }

    private fun onBnbTransfer(id: Long, order: WCBinanceTransferOrder) {
        Log.d("WalletConnect", "onBnbTransfer")
        runOnUiThread(Runnable {
          //channel.invokeMethod("onBnbTransfer", mapOf("code" to code, "reason" to reason))
        })
    }

    private fun onBnbTxConfirm(id: Long, order: WCBinanceTxConfirmParam) {
        Log.d("WalletConnect", "onBnbTxConfirm")
        runOnUiThread(Runnable {
          //channel.invokeMethod("onBnbTxConfirm", mapOf("code" to code, "reason" to reason))
        })
    }

    private fun onGetAccounts(id: Long) {
        Log.d("WalletConnect", "onGetAccounts")
        runOnUiThread(Runnable {
          channel.invokeMethod("onGetAccounts", mapOf("id" to id))
        })
    }

    private fun onSignTransaction(id: Long, transaction: WCSignTransaction) {
        Log.d("WalletConnect", "onSignTransaction")
        runOnUiThread(Runnable {
          channel.invokeMethod("onSignTransaction", mapOf("id" to id, "transaction" to gson.toJson(transaction)))
        })
    }

}
