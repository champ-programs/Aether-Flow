import 'dart:typed_data';
import 'package:flutter/material.dart';

/// 畫面串流顯示組件 (Virtual Display - Flutter 實作)
/// 負責將從遠端接收到的加密視訊幀解密並顯示
class DisplayStreamView extends StatefulWidget {
  final Stream<Uint8List> frameStream; // 傳入解密後的圖像幀流

  const DisplayStreamView({Key? key, required this.frameStream}) : super(key: key);

  @override
  State<DisplayStreamView> createState() => _DisplayStreamViewState();
}

class _DisplayStreamViewState extends State<DisplayStreamView> {
  Uint8List? _currentFrame;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Uint8List>(
      stream: widget.frameStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _currentFrame = snapshot.data;
        }

        return Container(
          color: Colors.black,
          child: _currentFrame == null
              ? const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: Colors.blueAccent),
                      SizedBox(height: 16),
                      Text("等待遠端畫面傳輸...", style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                )
              : Image.memory(
                  _currentFrame!,
                  gaplessPlayback: true, // 確保動畫流暢
                  fit: BoxFit.contain,
                ),
        );
      },
    );
  }
}
