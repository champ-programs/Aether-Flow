import Foundation
import CryptoKit

/// Aether 加密模組 (Swift/Apple 實作)
/// 使用 ChaCha20-Poly1305 確保端到端加密與完整性，並與 Aether SOS 的 Rust 核心相容
public struct AetherCrypto {
    private let key: SymmetricKey

    /// 初始化加密模組 (必須為 32 bytes)
    public init(keyBytes: [UInt8]) throws {
        guard keyBytes.count == 32 else {
            throw AetherCryptoError.invalidKeyLength
        }
        self.key = SymmetricKey(data: keyBytes)
    }

    /// 產生隨機金鑰 (用於測試或首次初始化)
    public static func generateKey() -> [UInt8] {
        let key = SymmetricKey(size: .bits256)
        return key.withUnsafeBytes { Array($0) }
    }

    /// 加密 Payload，並回傳 [Nonce (12 bytes) + Ciphertext + Tag (16 bytes)]
    public func encryptPayload(_ plaintext: [UInt8]) throws -> [UInt8] {
        let data = Data(plaintext)
        
        // CryptoKit 自動產生 12 bytes 的 Nonce，並附帶在 SealedBox 中
        let sealedBox = try ChaChaPoly.seal(data, using: key)
        
        // Rust ChaCha20Poly1305 產生的格式為: Nonce + Ciphertext (含 MAC)
        // sealedBox.combined 會回傳: Nonce (12 bytes) + Ciphertext + Tag (16 bytes)
        // 這與 Rust 中的處理方式與預設佈局完全一致
        guard let combined = sealedBox.combined else {
            throw AetherCryptoError.encryptionFailed
        }
        
        return Array(combined)
    }

    /// 解密 Payload，輸入必須是 [Nonce (12 bytes) + Ciphertext + Tag (16 bytes)]
    public func decryptPayload(_ encryptedData: [UInt8]) throws -> [UInt8] {
        guard encryptedData.count >= 28 else { // 12(Nonce) + 16(Tag)
            throw AetherCryptoError.invalidPayloadSize
        }
        
        let data = Data(encryptedData)
        
        // CryptoKit 可以直接透過 combined Data 解析 Nonce, Ciphertext, Tag
        let sealedBox = try ChaChaPoly.SealedBox(combined: data)
        let decryptedData = try ChaChaPoly.open(sealedBox, using: key)
        
        return Array(decryptedData)
    }
}

public enum AetherCryptoError: Error {
    case invalidKeyLength
    case encryptionFailed
    case invalidPayloadSize
    case decryptionFailed
}
