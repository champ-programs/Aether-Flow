import 'dart:ui';
import 'package:flutter/material.dart';
import 'handoff_payload.dart';

/// 液態玻璃邊緣圖示 (File Handoff - Flutter 實作)
class LiquidEdgeIcon extends StatefulWidget {
  final HandoffPayload payload;

  const LiquidEdgeIcon({Key? key, required this.payload}) : super(key: key);

  @override
  State<LiquidEdgeIcon> createState() => _LiquidEdgeIconState();
}

class _LiquidEdgeIconState extends State<LiquidEdgeIcon> {
  bool _isHovering = false;
  double _offset = 40.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() => _offset = 20.0); // 露出半個提示
      }
    });
  }

  IconData _getIcon(String appId) {
    if (appId.contains('minecraft')) return Icons.view_in_ar;
    if (appId.contains('browser')) return Icons.language;
    return Icons.description;
  }

  void _openHandoff() {
    print("🚀 Opening handoff from ${widget.payload.sourceDeviceName}: ${widget.payload.documentPath}");
    // TODO: 使用 url_launcher 或系統指令開啟
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutBack,
      transform: Matrix4.translationValues(_offset, 0, 0),
      child: MouseRegion(
        onEnter: (_) => setState(() {
          _isHovering = true;
          _offset = 0.0;
        }),
        onExit: (_) => setState(() {
          _isHovering = false;
          _offset = 20.0;
        }),
        child: GestureDetector(
          onTap: _openHandoff,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              bottomLeft: Radius.circular(30),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                  ),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 圖示
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                      ),
                      child: Icon(
                        _getIcon(widget.payload.appIdentifier),
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    // 文字展開
                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      child: _isHovering
                          ? Padding(
                              padding: const EdgeInsets.only(left: 12, right: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    widget.payload.sourceDeviceName,
                                    style: const TextStyle(
                                      color: Colors.white60,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text(
                                    "繼續編輯檔案",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
