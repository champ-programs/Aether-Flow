import Foundation

#if os(macOS)
import AppKit
#else
import UIKit
#endif

/// 剪貼簿監控與操作 (Universal Clipboard 核心)
public class ClipboardMonitor: ObservableObject {
    @Published public var lastCopiedText: String = ""
    
    private var timer: Timer?
    private var lastChangeCount: Int = 0
    
    public init() {
        startMonitoring()
    }
    
    public func startMonitoring() {
        #if os(macOS)
        lastChangeCount = NSPasteboard.general.changeCount
        #endif
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            self?.checkClipboard()
        }
    }
    
    public func stopMonitoring() {
        timer?.invalidate()
        timer = nil
    }
    
    private func checkClipboard() {
        #if os(macOS)
        let currentCount = NSPasteboard.general.changeCount
        if currentCount != lastChangeCount {
            lastChangeCount = currentCount
            if let text = NSPasteboard.general.string(forType: .string) {
                DispatchQueue.main.async {
                    self.lastCopiedText = text
                    self.onClipboardChanged(text)
                }
            }
        }
        #else
        // iOS implementation using UIPasteboard
        if let text = UIPasteboard.general.string, text != lastCopiedText {
            DispatchQueue.main.async {
                self.lastCopiedText = text
                self.onClipboardChanged(text)
            }
        }
        #endif
    }
    
    /// 當本機剪貼簿改變時觸發，準備將內容透過 AetherCrypto 加密並發送至其他設備
    private func onClipboardChanged(_ newText: String) {
        print("📋 [Clipboard] Detected local copy: \(newText)")
        // TODO: 整合 mDNS 發現的設備，並透過 TCP/UDP 發送加密後的 Payload
    }
    
    /// 接收到來自其他設備的剪貼簿同步請求時呼叫
    public func syncFromRemote(text: String) {
        #if os(macOS)
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(text, forType: .string)
        lastChangeCount = NSPasteboard.general.changeCount
        #else
        UIPasteboard.general.string = text
        #endif
        
        DispatchQueue.main.async {
            self.lastCopiedText = text
            print("🔄 [Clipboard] Synced from remote: \(text)")
            // TODO: 發送本地系統通知 (NotificationCenter)
        }
    }
}
