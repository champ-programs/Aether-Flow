# Aether Flow

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Platform](https://img.shields.io/badge/platform-macOS%20%7C%20Windows%20%7C%20Linux%20%7C%20iOS%20%7C%20Android-lightgrey.svg)

**Aether Flow** is an open-source cross-platform collaboration protocol designed to break ecosystem barriers. It brings a "Continuity"-like experience to non-native ecosystems, such as Windows ↔ Apple or Linux ↔ Android.

---

## ✨ Key Features

### 📋 Universal Clipboard
- **Seamless Sync**: Copy code on your Mac and have it instantly available on your phone or Windows PC with real-time notifications.
- **End-to-End Encryption**: Utilizes the **ChaCha20-Poly1305** encryption mechanism from Aether SOS, ensuring your clipboard data remains absolutely secure over the local network.

### 💧 File Handoff
- **Liquid Glass UI**: As you edit a file on Device A, a "Liquid Glass" styled icon appears on the edge of Device B's screen.
- **Instant Resume**: Click the icon to open the same file or resume the editing context on the other device. Perfect for scripts, document editing, and video previews.

### ⌨️ Shared Input & Virtual Display
- **Cross-Device Control**: Use a single set of keyboard and mouse to control both your desktop and tablet. Control switches automatically as the mouse moves past the screen edge.
- **4K Low-Latency Streaming**: Optimized for high-fidelity video previews with minimal frame drops. iPad can become the perfect secondary display for your workstation.

---

## 🎨 Design Aesthetic: Liquid Glass 2.0
Aether Flow is built with a focus on premium visual excellence:
- **High Dynamic Blur**: Interfaces utilize background blur (frosted glass) and gradient lighting to create a modern, high-tech feel.
- **Fluid Animations**: Device pairing is accompanied by liquid-like convergence animations, turning a mundane process into a stunning visual experience.

---

## 🛠️ Tech Stack

- **Core Engine**: Built with **Rust** for high-performance networking, mDNS discovery, and robust cryptography.
- **Apple Ecosystem**: Implemented with **SwiftUI** for native macOS/iOS integration and system-level performance.
- **Cross-Platform**: Powered by **Flutter** to provide a consistent, premium UI and animation experience on Windows, Linux, and Android.

---

## 📂 Project Structure

- `/aether_flow_apple`: SwiftUI implementation for Apple devices.
- `/aether_flow_flutter`: Flutter implementation for Windows, Linux, and Android.
- `/core_mesh` (Planned): Shared Rust-based core logic.

---

## 🛡️ Security
Security is baked into the protocol. All communications are encrypted using ChaCha20-Poly1305, a military-grade algorithm that offers both extreme performance and high security, ideal for mobile and cross-platform devices.

---

## 📄 License
This project is licensed under the [MIT License](LICENSE).
