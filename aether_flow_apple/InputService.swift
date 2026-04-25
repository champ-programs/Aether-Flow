import Foundation
import CoreGraphics

/// 輸入服務 (Shared Input - macOS 實作)
/// 負責將從遠端收到的 SharedInputEvent 注入到本地系統
public class InputService {
    
    public init() {}
    
    /// 注入事件
    public func injectEvent(_ event: SharedInputEvent) {
        switch event.type {
        case .mouseMove:
            if let x = event.x, let y = event.y {
                moveMouse(to: CGPoint(x: x, y: y))
            }
        case .mouseLeftDown:
            postMouseEvent(type: .leftMouseDown)
        case .mouseLeftUp:
            postMouseEvent(type: .leftMouseUp)
        case .mouseRightDown:
            postMouseEvent(type: .rightMouseDown)
        case .mouseRightUp:
            postMouseEvent(type: .rightMouseUp)
        case .keyDown:
            if let keyCode = event.keyCode {
                postKeyEvent(keyCode: CGKeyCode(keyCode), keyDown: true)
            }
        case .keyUp:
            if let keyCode = event.keyCode {
                postKeyEvent(keyCode: CGKeyCode(keyCode), keyDown: false)
            }
        case .scroll:
            if let dx = event.deltaX, let dy = event.deltaY {
                postScrollEvent(dx: Int32(dx), dy: Int32(dy))
            }
        }
    }
    
    private func moveMouse(to point: CGPoint) {
        // 座標轉換邏輯：將 0.0-1.0 轉換為螢幕實際像素
        // 這裡簡化處理，實際需獲取 NSScreen.main?.frame
        let event = CGEvent(mouseEventSource: nil, mouseType: .mouseMoved, mouseCursorPosition: point, mouseButton: .left)
        event?.post(tap: .cghidEventTap)
    }
    
    private func postMouseEvent(type: CGEventType) {
        let mousePos = NSEvent.mouseLocation
        // 座標 y 軸在 CoreGraphics 與 AppKit 之間通常需要翻轉
        let event = CGEvent(mouseEventSource: nil, mouseType: type, mouseCursorPosition: mousePos, mouseButton: .left)
        event?.post(tap: .cghidEventTap)
    }
    
    private func postKeyEvent(keyCode: CGKeyCode, keyDown: bool) {
        let event = CGEvent(keyboardEventSource: nil, virtualKey: keyCode, keyDown: keyDown)
        event?.post(tap: .cghidEventTap)
    }
    
    private func postScrollEvent(dx: Int32, dy: Int32) {
        let event = CGEvent(scrollWheelEventSource: nil, units: .pixel, wheelCount: 2, wheel1: dy, wheel2: dx, wheel3: 0)
        event?.post(tap: .cghidEventTap)
    }
}
