import 'dart:convert';

/// 共享輸入事件類型
enum InputEventType {
  mouseMove,
  mouseLeftDown,
  mouseLeftUp,
  mouseRightDown,
  mouseRightUp,
  keyDown,
  keyUp,
  scroll,
}

/// 共享輸入事件 (滑鼠/鍵盤 - Flutter 實作)
class SharedInputEvent {
  final InputEventType type;
  final double? x; // 標準化座標 (0.0 - 1.0)
  final double? y;
  final int? keyCode;
  final double? deltaX;
  final double? deltaY;
  final int timestamp;

  SharedInputEvent({
    required this.type,
    this.x,
    this.y,
    this.keyCode,
    this.deltaX,
    this.deltaY,
    int? timestamp,
  }) : timestamp = timestamp ?? DateTime.now().millisecondsSinceEpoch;

  Map<String, dynamic> toJson() {
    return {
      'type': type.index,
      'x': x,
      'y': y,
      'keyCode': keyCode,
      'deltaX': deltaX,
      'deltaY': deltaY,
      'timestamp': timestamp,
    };
  }

  factory SharedInputEvent.fromJson(Map<String, dynamic> json) {
    return SharedInputEvent(
      type: InputEventType.values[json['type'] as int],
      x: (json['x'] as num?)?.toDouble(),
      y: (json['y'] as num?)?.toDouble(),
      keyCode: json['keyCode'] as int?,
      deltaX: (json['deltaX'] as num?)?.toDouble(),
      deltaY: (json['deltaY'] as num?)?.toDouble(),
      timestamp: json['timestamp'] as int,
    );
  }

  List<int> encodeToBytes() {
    return utf8.encode(jsonEncode(toJson()));
  }
}
