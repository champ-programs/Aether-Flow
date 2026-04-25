import 'dart:io';
import 'dart:typed_data';
import 'aether_crypto.dart';
import 'clipboard_monitor.dart';

/// AetherFlow 網路通訊層 (Flutter/Dart)
/// 負責與已配對設備進行 TCP 連線，並透過 AetherCrypto 加密傳輸 Universal Clipboard 等資料
class AetherNetwork {
  ServerSocket? _serverSocket;
  Socket? _connection;
  
  final AetherCrypto _crypto;
  final ClipboardMonitor _clipboardMonitor;
  
  // 用於 Demo 的固定 Port
  final int port = 8080;

  AetherNetwork(this._crypto, this._clipboardMonitor);

  /// 啟動監聽服務 (作為接收端)
  Future<void> startServer() async {
    try {
      _serverSocket = await ServerSocket.bind(InternetAddress.anyIPv4, port);
      print("🌐 [Network] Server started on port $port");

      _serverSocket?.listen((Socket socket) {
        print("🌐 [Network] Received new connection from ${socket.remoteAddress.address}");
        _connection = socket;
        _startReceiving(socket);
      });
    } catch (e) {
      print("🌐 [Network] Failed to start server: $e");
    }
  }

  /// 建立連線到遠端設備
  Future<void> connectToRemote(String host) async {
    try {
      _connection = await Socket.connect(host, port);
      print("🌐 [Network] Connected to remote $host:$port");
      _startReceiving(_connection!);
    } catch (e) {
      print("🌐 [Network] Failed to connect: $e");
    }
  }

  /// 開始接收遠端傳來的資料
  void _startReceiving(Socket socket) {
    socket.listen(
      (Uint8List data) async {
        await _handleIncomingData(data);
      },
      onError: (error) {
        print("🌐 [Network] Receive error: $error");
        socket.destroy();
      },
      onDone: () {
        print("🌐 [Network] Connection closed");
        socket.destroy();
      },
    );
  }

  /// 處理收到的加密資料
  Future<void> _handleIncomingData(Uint8List data) async {
    try {
      final decryptedBytes = await _crypto.decryptPayload(data);
      final stringPayload = String.fromCharCodes(decryptedBytes);
      
      print("🔒 [Crypto] Decrypted clipboard payload successfully");
      // 同步至本機剪貼簿
      await _clipboardMonitor.syncFromRemote(stringPayload);
    } catch (e) {
      print("🔒 [Crypto] Decryption failed: $e");
    }
  }

  /// 發送本機剪貼簿資料至遠端
  Future<void> sendClipboardData(String text) async {
    if (_connection == null) {
      print("🌐 [Network] No active connection to send data.");
      return;
    }

    try {
      final textBytes = text.codeUnits;
      final encryptedBytes = await _crypto.encryptPayload(textBytes);
      
      _connection?.add(encryptedBytes);
      print("🔒 [Crypto] Encrypted and sent clipboard payload");
    } catch (e) {
      print("🔒 [Crypto] Encryption failed: $e");
    }
  }

  void dispose() {
    _connection?.destroy();
    _serverSocket?.close();
  }
}
