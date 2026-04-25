import SwiftUI

/// 液態玻璃邊緣圖示 (File Handoff)
struct LiquidEdgeIconView: View {
    let payload: HandoffPayload
    @State private var isHovering = false
    @State private var offset: CGFloat = 40 // 初始隱藏在邊緣外
    
    var body: some View {
        HStack(spacing: 0) {
            // 液體流動感的圖示容器
            ZStack {
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 60, height: 60)
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                    .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0, y: 5)
                
                Image(systemName: iconName(for: payload.appIdentifier))
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))
            }
            .onHover { hovering in
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isHovering = hovering
                    offset = hovering ? 0 : 20
                }
            }
            .onTapGesture {
                openHandoff()
            }
            
            // 懸停時展開的描述文字
            if isHovering {
                VStack(alignment: .leading, spacing: 2) {
                    Text(payload.sourceDeviceName)
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white.opacity(0.6))
                    Text("繼續編輯腳本")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white)
                }
                .padding(.leading, 12)
                .transition(.asymmetric(insertion: .move(edge: .leading).combined(with: .opacity), removal: .opacity))
            }
        }
        .padding(8)
        .background(
            Capsule()
                .fill(.ultraThinMaterial)
                .opacity(isHovering ? 1 : 0)
        )
        .offset(x: offset)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                offset = 20 // 露出半個圖示作為提示
            }
        }
    }
    
    private func iconName(for appId: String) -> String {
        // 根據 App ID 返回對應圖示
        if appId.contains("minecraft") { return "cube.fill" }
        if appId.contains("safari") || appId.contains("browser") { return "safari.fill" }
        return "doc.text.fill"
    }
    
    private func openHandoff() {
        print("🚀 Opening handoff from \(payload.sourceDeviceName): \(payload.documentPath ?? "no path")")
        // TODO: 執行系統指令開啟檔案或 URL
    }
}

struct LiquidEdgeIconView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack(alignment: .trailing) {
            Color.black.ignoresSafeArea()
            LiquidEdgeIconView(payload: HandoffPayload(sourceDeviceName: "iPhone 15 Pro", appIdentifier: "minecraft.script", documentPath: "/Users/aether/scripts/minecraft.txt"))
        }
        .frame(width: 300, height: 200)
    }
}
