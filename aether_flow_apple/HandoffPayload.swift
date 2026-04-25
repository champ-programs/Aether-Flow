import Foundation

/// Handoff (動態文件接力) 資料模型
public struct HandoffPayload: Codable {
    public let sourceDeviceName: String
    public let appIdentifier: String
    public let documentPath: String?
    public let contextData: String?
    public let timestamp: TimeInterval
    
    public init(sourceDeviceName: String, appIdentifier: String, documentPath: String? = nil, contextData: String? = nil) {
        self.sourceDeviceName = sourceDeviceName
        self.appIdentifier = appIdentifier
        self.documentPath = documentPath
        self.contextData = contextData
        self.timestamp = Date().timeIntervalSince1970
    }
    
    /// 將 Payload 轉換為 JSON Data
    public func encodeToData() throws -> Data {
        let encoder = JSONEncoder()
        return try encoder.encode(self)
    }
    
    /// 從 JSON Data 解析 Payload
    public static func decodeFromData(_ data: Data) throws -> HandoffPayload {
        let decoder = JSONDecoder()
        return try decoder.decode(HandoffPayload.self, from: data)
    }
}
