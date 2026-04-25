import Foundation

/// 共享輸入事件 (滑鼠/鍵盤)
public struct SharedInputEvent: Codable {
    public enum EventType: Int, Codable {
        case mouseMove = 0
        case mouseLeftDown = 1
        case mouseLeftUp = 2
        case mouseRightDown = 3
        case mouseRightUp = 4
        case keyDown = 5
        case keyUp = 6
        case scroll = 7
    }
    
    public let type: EventType
    public let x: Double? // 標準化座標 (0.0 - 1.0)
    public let y: Double?
    public let keyCode: Int?
    public let deltaX: Double?
    public let deltaY: Double?
    public let timestamp: TimeInterval
    
    public init(type: EventType, x: Double? = nil, y: Double? = nil, keyCode: Int? = nil, deltaX: Double? = nil, deltaY: Double? = nil) {
        self.type = type
        self.x = x
        self.y = y
        self.keyCode = keyCode
        self.deltaX = deltaX
        self.deltaY = deltaY
        self.timestamp = Date().timeIntervalSince1970
    }
}
