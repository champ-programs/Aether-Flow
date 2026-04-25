import SwiftUI

struct ContentView: View {
    @State private var isServiceActive = true
    @State private var breatheAnimation = false
    
    var body: some View {
        ZStack {
            // Background Base
            Color(red: 0.05, green: 0.05, blue: 0.08)
                .ignoresSafeArea()
            
            // Liquid Background Light
            GeometryReader { _ in
                Circle()
                    .fill(RadialGradient(
                        colors: [Color.purple.opacity(0.3), .clear],
                        center: .center, startRadius: 0, endRadius: 300)
                    )
                    .frame(width: 600, height: 600)
                    .offset(x: breatheAnimation ? -100 : -150, y: breatheAnimation ? -50 : -100)
                    .blur(radius: 80)
            }
            
            // Dashboard Content
            VStack(alignment: .leading, spacing: 32) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Aether Flow")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        Text("Liquid Continuity Protocol")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.5))
                    }
                    Spacer()
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.white.opacity(0.7))
                        .padding(10)
                        .background(Circle().stroke(Color.white.opacity(0.1), lineWidth: 1))
                }
                .padding(.horizontal, 24)
                .padding(.top, 60)
                
                // Status Card
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Circle()
                            .fill(Color.cyan)
                            .frame(width: 10, height: 10)
                            .shadow(color: .cyan.opacity(0.5), radius: 5)
                            .scaleEffect(breatheAnimation ? 1.2 : 0.8)
                        
                        VStack(alignment: .leading) {
                            Text("System Active")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("Listening for nearby devices...")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.4))
                        }
                        Spacer()
                        Toggle("", isOn: $isServiceActive)
                            .toggleStyle(SwitchToggleStyle(tint: .cyan))
                            .labelsHidden()
                    }
                }
                .padding(24)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(.white.opacity(0.05))
                        .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color.white.opacity(0.1), lineWidth: 1))
                )
                .padding(.horizontal, 24)
                
                // Modules Grid
                VStack(alignment: .leading, spacing: 16) {
                    Text("CORE MODULES")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white.opacity(0.4))
                        .kerning(2.0)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ModuleCard(title: "Clipboard", icon: "doc.on.clipboard.fill", subtitle: "Universal Sync", color: .purple)
                        ModuleCard(title: "Handoff", icon: "sparkles", subtitle: "Liquid Resume", color: .cyan)
                        ModuleCard(title: "Input", icon: "mouse.fill", subtitle: "Cross-Control", color: .orange)
                        ModuleCard(title: "Display", icon: "display", subtitle: "4K Stream", color: .green)
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer()
            }
            
            // Handoff Preview (Edge Icon)
            ZStack(alignment: .trailing) {
                Color.clear
                LiquidEdgeIconView(payload: HandoffPayload(sourceDeviceName: "iPhone 15 Pro", appIdentifier: "minecraft.script"))
                    .padding(.top, 100)
            }
            .ignoresSafeArea()
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
                breatheAnimation = true
            }
        }
    }
}

struct ModuleCard: View {
    let title: String
    let icon: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(subtitle)
                    .font(.system(size: 11))
                    .foregroundColor(.white.opacity(0.4))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white.opacity(0.03))
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.white.opacity(0.05), lineWidth: 1))
        )
    }
}
