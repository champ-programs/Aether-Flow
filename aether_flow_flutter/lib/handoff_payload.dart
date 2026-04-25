import 'dart:convert';

/// Handoff (動態文件接力) 資料模型 (Flutter/Dart)
class HandoffPayload {
  final String sourceDeviceName;
  final String appIdentifier;
  final String? documentPath;
  final String? contextData;
  final int timestamp;

  HandoffPayload({
    required this.sourceDeviceName,
    required this.appIdentifier,
    this.documentPath,
    this.contextData,
    int? timestamp,
  }) : timestamp = timestamp ?? DateTime.now().millisecondsSinceEpoch;

  /// 將 JSON Map 轉為 HandoffPayload
  factory HandoffPayload.fromJson(Map<String, dynamic> json) {
    return HandoffPayload(
      sourceDeviceName: json['sourceDeviceName'] as String,
      appIdentifier: json['appIdentifier'] as String,
      documentPath: json['documentPath'] as String?,
      contextData: json['contextData'] as String?,
      timestamp: json['timestamp'] as int,
    );
  }

  /// 轉為 JSON Map
  Map<String, dynamic> toJson() {
    return {
      'sourceDeviceName': sourceDeviceName,
      'appIdentifier': appIdentifier,
      'documentPath': documentPath,
      'contextData': contextData,
      'timestamp': timestamp,
    };
  }

  /// 編碼為 UTF-8 Bytes 以便傳輸
  List<int> encodeToBytes() {
    final jsonString = jsonEncode(toJson());
    return utf8.encode(jsonString);
  }

  /// 從 UTF-8 Bytes 解碼
  factory HandoffPayload.decodeFromBytes(List<int> bytes) {
    final jsonString = utf8.decode(bytes);
    final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
    return HandoffPayload.fromJson(jsonMap);
  }
}
