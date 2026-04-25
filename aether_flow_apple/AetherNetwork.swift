import Foundation
import Network

/// AetherFlow 網路通訊層 (Swift/Apple)
/// 負責與已配對設備進行 TCP 連線，並透過 AetherCrypto 加密傳輸 Universal Clipboard 等資料
public class AetherNetwork: ObservableObject {
    private var listener: NWListener?
    private var connection: NWConnection?
    
    private let crypto: AetherCrypto
    private let clipboardMonitor: ClipboardMonitor
    
    // 用於 Demo 的固定 Port
    private let port: NWEndpoint.Port = 8080
    
    public init(cryptoKey: [UInt8], clipboardMonitor: ClipboardMonitor) throws {
        self.crypto = try AetherCrypto(keyBytes: cryptoKey)
        self.clipboardMonitor = clipboardMonitor
    }
    
    /// 啟動監聽服務 (作為接收端)
    public func startServer() {
        do {
            listener = try NWListener(using: .tcp, on: port)
            listener?.stateUpdateHandler = { state in
                print("🌐 [Network] Listener state: \(state)")
            }
            
            listener?.newConnectionHandler = { [weak self] newConnection in
                print("🌐 [Network] Received new connection from \(String(describing: newConnection.endpoint))")
                self?.connection = newConnection
                self?.startReceiving(on: newConnection)
                newConnection.start(queue: .main)
            }
            
            listener?.start(queue: .main)
            print("🌐 [Network] Server started on port \(port)")
        } catch {
            print("🌐 [Network] Failed to start server: \(error)")
        }
    }
    
    /// 建立連線到遠端設備 (透過 mDNS 解析出 IP 後呼叫)
    public func connectToRemote(host: String) {
        let endpoint = NWEndpoint.hostPort(host: NWEndpoint.Host(host), port: port)
        connection = NWConnection(to: endpoint, using: .tcp)
        
        connection?.stateUpdateHandler = { state in
            print("🌐 [Network] Connection state: \(state)")
        }
        
        startReceiving(on: connection!)
        connection?.start(queue: .main)
    }
    
    /// 開始接收遠端傳來的資料
    private func startReceiving(on connection: NWConnection) {
        connection.receive(minimumIncompleteLength: 1, maximumLength: 65536) { [weak self] content, context, isComplete, error in
            guard let self = self else { return }
            
            if let data = content {
                self.handleIncomingData(data)
            }
            
            if isComplete {
                print("🌐 [Network] Connection closed")
                return
            }
            
            if let error = error {
                print("🌐 [Network] Receive error: \(error)")
                return
            }
            
            // 繼續監聽
            self.startReceiving(on: connection)
        }
    }
    
    /// 處理收到的加密資料
    private func handleIncomingData(_ data: Data) {
        do {
            let encryptedBytes = Array(data)
            let decryptedBytes = try crypto.decryptPayload(encryptedBytes)
            
            if let stringPayload = String(bytes: decryptedBytes, encoding: .utf8) {
                print("🔒 [Crypto] Decrypted clipboard payload successfully")
                // 同步至本機剪貼簿
                clipboardMonitor.syncFromRemote(text: stringPayload)
            }
        } catch {
            print("🔒 [Crypto] Decryption failed: \(error)")
        }
    }
    
    /// 發送本機剪貼簿資料至遠端
    public func sendClipboardData(_ text: String) {
        guard let connection = connection, connection.state == .ready else {
            print("🌐 [Network] No active connection to send data.")
            return
        }
        
        guard let textBytes = text.data(using: .utf8).map({ Array($0) }) else { return }
        
        do {
            let encryptedBytes = try crypto.encryptPayload(textBytes)
            let data = Data(encryptedBytes)
            
            connection.send(content: data, completion: .contentProcessed { error in
                if let error = error {
                    print("🌐 [Network] Send error: \(error)")
                } else {
                    print("🔒 [Crypto] Encrypted and sent clipboard payload")
                }
            })
        } catch {
            print("🔒 [Crypto] Encryption failed: \(error)")
        }
    }
}
