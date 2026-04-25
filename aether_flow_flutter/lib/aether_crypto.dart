import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';

/// Aether 加密模組 (Dart/Flutter 實作)
/// 使用 ChaCha20-Poly1305 確保端到端加密與完整性，並與 Aether SOS 的 Rust 核心相容
class AetherCrypto {
  final SecretKey _secretKey;
  final Chacha20.poly1305Aead _cipher = Chacha20.poly1305Aead();

  AetherCrypto(List<int> keyBytes) : _secretKey = SecretKey(keyBytes) {
    if (keyBytes.length != 32) {
      throw ArgumentError('Key must be exactly 32 bytes.');
    }
  }

  /// 產生隨機金鑰 (用於測試或首次初始化)
  static Future<List<int>> generateKey() async {
    final cipher = Chacha20.poly1305Aead();
    final secretKey = await cipher.newSecretKey();
    return await secretKey.extractBytes();
  }

  /// 加密 Payload，並回傳 [Nonce (12 bytes) + Ciphertext (含 MAC 標籤)]
  Future<Uint8List> encryptPayload(List<int> plaintext) async {
    // 加密時 cipher.encrypt 會自動產生 nonce 並附在結果中
    // 但為確保與 Rust 邏輯一致 [Nonce(12) + Ciphertext]，我們手動擷取並組合
    final secretBox = await _cipher.encrypt(
      plaintext,
      secretKey: _secretKey,
    );

    final nonce = secretBox.nonce;
    final ciphertext = secretBox.cipherText;
    final mac = secretBox.mac.bytes;

    // 將 Nonce, CipherText 和 MAC (Tag) 組合
    // Rust 的 ChaCha20Poly1305 預設會將 MAC 附加在密文最後
    final builder = BytesBuilder();
    builder.add(nonce);
    builder.add(ciphertext);
    builder.add(mac);

    return builder.toBytes();
  }

  /// 解密 Payload，輸入必須是 [Nonce (12 bytes) + Ciphertext (含 MAC 標籤)]
  Future<List<int>> decryptPayload(List<int> encryptedData) async {
    if (encryptedData.length < 12 + 16) { // 至少要有 Nonce(12) + Tag(16)
      throw Exception('Invalid payload size, missing Nonce or Tag');
    }

    final nonce = encryptedData.sublist(0, 12);
    final ciphertextWithTag = encryptedData.sublist(12);
    final ciphertext = ciphertextWithTag.sublist(0, ciphertextWithTag.length - 16);
    final macBytes = ciphertextWithTag.sublist(ciphertextWithTag.length - 16);

    final secretBox = SecretBox(
      ciphertext,
      nonce: nonce,
      mac: Mac(macBytes),
    );

    try {
      final decrypted = await _cipher.decrypt(
        secretBox,
        secretKey: _secretKey,
      );
      return decrypted;
    } catch (e) {
      throw Exception('Decryption failed or payload tampered');
    }
  }
}
