import 'package:flutter/services.dart';
import 'shared_input_event.dart';

/// 輸入服務 (Shared Input - Flutter/Desktop 實作)
/// 透過 MethodChannel 呼叫原生端 (Windows/Linux) 執行輸入模擬
class InputService {
  static const MethodChannel _channel = MethodChannel('com.aether.flow/input');

  /// 注入從遠端收到的事件
  Future<void> injectEvent(SharedInputEvent event) async {
    try {
      await _channel.invokeMethod('inject', event.toJson());
    } on PlatformException catch (e) {
      print("❌ [InputService] Failed to inject event: ${e.message}");
    }
  }

  /// 偵測滑鼠是否移出邊緣 (用於觸發轉發)
  /// 此邏輯通常需要在原生端建立一個全局 Hook
  void startEdgeDetection() {
    // TODO: 呼叫原生端開啟 Mouse Hook
  }
}
