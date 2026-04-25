import Foundation
import AVFoundation

/// 畫面串流服務 (Virtual Display - macOS 實作)
/// 負責捕捉螢幕畫面並編碼後發送
public class DisplayStreamService: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    private var captureSession: AVCaptureSession?
    private var screenInput: AVCaptureScreenInput?
    private var videoOutput: AVCaptureVideoDataOutput?
    
    private let network: AetherNetwork
    
    public init(network: AetherNetwork) {
        self.network = network
    }
    
    public func startStreaming() {
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = .hd1920x1080 // 或 .high 視效能調整
        
        // 獲取主螢幕
        let displayId = CGMainDisplayID()
        screenInput = AVCaptureScreenInput(displayID: displayId)
        
        if let input = screenInput, captureSession?.canAddInput(input) == true {
            captureSession?.addInput(input)
        }
        
        videoOutput = AVCaptureVideoDataOutput()
        videoOutput?.setSampleBufferDelegate(self, queue: DispatchQueue(label: "display.stream.queue"))
        
        if let output = videoOutput, captureSession?.canAddOutput(output) == true {
            captureSession?.addOutput(output)
        }
        
        captureSession?.startRunning()
        print("🖥️ [DisplayStream] Started capturing screen")
    }
    
    public func stopStreaming() {
        captureSession?.stopRunning()
        captureSession = nil
    }
    
    // AVCaptureVideoDataOutput 監聽器
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // 1. 從 SampleBuffer 提取圖像資料 (JPEG 或 H.264 編碼)
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        // 這裡簡化為 JPEG 壓縮以供演示，實際應使用 VideoToolbox 進行 H.264/HEVC 硬體編碼
        let ciImage = CIImage(cvImageBuffer: imageBuffer)
        let context = CIContext()
        if let jpegData = context.jpegRepresentation(of: ciImage, colorSpace: CGColorSpaceCreateDeviceRGB(), options: [:]) {
            // 2. 透過網路發送加密後的圖像資料
            // 由於圖像較大，實務上會切片並使用 UDP/QUIC
            // network.sendVideoFrame(jpegData) 
            print("🖥️ [DisplayStream] Captured frame, size: \(jpegData.count) bytes")
        }
    }
}
