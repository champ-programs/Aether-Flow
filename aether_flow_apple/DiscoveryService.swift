import Foundation
import Network

/// 設備發現服務 (mDNS / Bonjour - Apple 實作)
/// 允許同一個 WiFi 下的設備自動發現彼此
public class DiscoveryService: ObservableObject {
    private var browser: NWBrowser?
    private var service: NWListener?
    
    @Published public var discoveredEndpoints: [NWEndpoint] = []
    
    private let serviceType = "_aetherflow._tcp"
    private let serviceName = "AetherNode-\(Host.current().localizedName ?? "Mac")"
    
    public init() {}
    
    /// 廣播本機服務 (讓別人找到我)
    public func startAdvertising(port: NWEndpoint.Port) {
        do {
            let service = try NWListener(using: .tcp, on: port)
            service.service = NWListener.Service(name: serviceName, type: serviceType)
            
            service.stateUpdateHandler = { state in
                print("📡 [Discovery] Advertising state: \(state)")
            }
            
            service.start(queue: .main)
            self.service = service
        } catch {
            print("📡 [Discovery] Failed to start advertising: \(error)")
        }
    }
    
    /// 瀏覽區域網路中的其他設備
    public func startBrowsing() {
        let descriptor = NWBrowser.Descriptor.bonjour(type: serviceType, domain: nil)
        let parameters = NWParameters.tcp
        
        browser = NWBrowser(for: descriptor, using: parameters)
        
        browser?.stateUpdateHandler = { state in
            print("📡 [Discovery] Browsing state: \(state)")
        }
        
        browser?.browseResultsChangedHandler = { [weak self] results, changes in
            DispatchQueue.main.async {
                self?.discoveredEndpoints = results.map { $0.endpoint }
                print("📡 [Discovery] Found \(results.count) devices on WiFi")
            }
        }
        
        browser?.start(queue: .main)
    }
    
    public func stop() {
        browser?.cancel()
        service?.cancel()
    }
}
