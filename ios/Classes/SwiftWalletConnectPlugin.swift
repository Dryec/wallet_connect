import Flutter
import UIKit
import WC_Swift


public class SwiftWalletConnectPlugin: NSObject, FlutterPlugin {
    
    private let peerMeta = WCPeerMeta(name: "Vision", url: "https://vision-crypto.com")
    private var interactor : WCInteractor?;
    private var channel : FlutterMethodChannel?;
    
    public init(channel: FlutterMethodChannel) {
        self.channel = channel
        super.init()
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "wallet_connect", binaryMessenger: registrar.messenger())
        let instance = SwiftWalletConnectPlugin(channel: channel)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? [String: Any]
        print(call.method)
        if(call.method == "isConnected") {
            let connected = self.interactor?.state != nil && self.interactor?.state == WCInteractorState.connected
            result(connected)
        }
        else if(call.method == "disconnect") {
            self.interactor?.disconnect()
        }
        else if(call.method == "getCurrentSession") {
            result(self.interactor?.session.encodedString)
        }
        else if(call.method == "approveSession") {
            let accounts = args?["accounts"] as! Array<String>
            let chainId = args?["chain_id"] as! Int
            self.interactor?.approveSession(accounts: accounts, chainId: chainId)
        }
        else if(call.method == "rejectRequest") {
            let id = args?["id"] as! Int
            let message = args?["message"] as! String
            self.interactor?.rejectRequest(id: Int64(id), message: message)
        }
        else if(call.method == "approveRequest") {
            let id = args?["id"] as! Int
            let result = args?["result"] as! String
            print(id)
            print(result)
            self.interactor?.approveRequest(id: Int64(id), result: result)
        }
        else if(call.method == "connectToSessionString") {
            let string = args?["session"] as! String
            guard let session = WCSession.from(string: string) else {
                // invalid session
                result(FlutterError(code: "missing_session", message: "No session provided", details: nil))
                return
            }
            interactor = WCInteractor(session: session, meta: peerMeta, uuid: UUID())
            
            interactor!.onError = { [weak self] (error) in
                self?.channel?.invokeMethod("onFailure", arguments: ["message": error.localizedDescription, "localizedMessage": error.localizedDescription])
            }

            interactor!.onDisconnect = { [weak self] (error) in
                self?.channel?.invokeMethod("onDisconnect", arguments: ["code": 0, "reason": error?.localizedDescription ?? "Unknown"])
            }
            
            interactor!.onSessionRequest = { [weak self] (id, peer) in
                self?.channel?.invokeMethod("onSessionRequest", arguments: ["id": id, "peer": peer.peerMeta.encodedString])
            }

            interactor!.eth.onSign = { [weak self] (id, payload) in
                switch payload {
                    case .sign(_, let raw):
                        self?.channel?.invokeMethod("onEthSign", arguments: ["id": id, "message": ["type": "MESSAGE", "raw": raw]])
                        break
                    case .personalSign(_, let raw):
                        self?.channel?.invokeMethod("onEthSign", arguments: ["id": id, "message": ["type": "PERSONAL_MESSAGE", "raw": raw]])
                        break
                    case .signTypeData(_, _, let raw):
                        self?.channel?.invokeMethod("onEthSign", arguments: ["id": id, "message": ["type": "TYPED_MESSAGE", "raw": raw]])
                        break
                }
            }

            interactor!.eth.onTransaction = { [weak self] (id, event, transaction) in
                switch event {
                    case .ethSendTransaction:
                        self?.channel?.invokeMethod("onEthSendTransaction", arguments: ["id": id, "transaction": transaction.encodedString])
                            break
                    case .ethSignTransaction:
                        self?.channel?.invokeMethod("onEthSignTransaction", arguments: ["id": id, "transaction": transaction.encodedString])
                        break
                default:
                    break
                }
            }
            
            
            interactor!.connect()
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
}
