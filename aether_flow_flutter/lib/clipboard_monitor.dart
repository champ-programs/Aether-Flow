import 'dart:async';
import 'package:flutter/services.dart';

/// 剪貼簿監控與操作 (Universal Clipboard 核心 - Flutter 實作)
class ClipboardMonitor {
  String _lastCopiedText = '';
  Timer? _timer;
  
  // Singleton pattern for easy access
  static final ClipboardMonitor _instance = ClipboardMonitor._internal();
  factory ClipboardMonitor() => _instance;
  ClipboardMonitor._internal();

  /// 開始監控剪貼簿
  void startMonitoring() {
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) async {
      await _checkClipboard();
    });
  }

  /// 停止監控
  void stopMonitoring() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _checkClipboard() async {
    try {
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      final text = clipboardData?.text;
      
      if (text != null && text.isNotEmpty && text != _lastCopiedText) {
        _lastCopiedText = text;
        _onClipboardChanged(text);
      }
    } catch (e) {
      // 忽略部分平台讀取權限或錯誤
    }
  }

  /// 當本機剪貼簿改變時觸發
  void _onClipboardChanged(String newText) {
    print("📋 [Clipboard] Detected local copy: $newText");
    // TODO: 整合通訊層 (AetherCrypto 加密 + 網路發送)
  }

  /// 接收到來自其他設備的剪貼簿同步請求時呼叫
  Future<void> syncFromRemote(String text) async {
    _lastCopiedText = text;
    await Clipboard.setData(ClipboardData(text: text));
    print("🔄 [Clipboard] Synced from remote: $text");
    
    // TODO: 觸發本地系統通知 (可結合 flutter_local_notifications)
  }
}
