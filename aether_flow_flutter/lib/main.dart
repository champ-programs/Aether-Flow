import 'dart:ui';
import 'package:flutter/material.dart';
import 'liquid_edge_icon.dart';
import 'handoff_payload.dart';

void main() {
  runApp(const AetherFlowApp());
}

class AetherFlowApp extends StatelessWidget {
  const AetherFlowApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aether Flow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D0E15),
        fontFamily: 'Inter',
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  bool _isServiceActive = true;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Liquid Light
          _buildBackgroundLight(),

          // Main Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  _buildHeader(),
                  const SizedBox(height: 40),
                  _buildStatusCard(),
                  const SizedBox(height: 24),
                  const Text(
                    "CORE MODULES",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white38,
                      letterSpacing: 2.0,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      children: [
                        _buildModuleCard("Clipboard", Icons.copy_all, "Universal Sync", Colors.purpleAccent),
                        _buildModuleCard("Handoff", Icons.auto_awesome, "Liquid Resume", Colors.cyanAccent),
                        _buildModuleCard("Input", Icons.mouse, "Cross-Control", Colors.orangeAccent),
                        _buildModuleCard("Display", Icons.monitor, "4K Stream", Colors.greenAccent),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // File Handoff Floating Icon (Preview)
          Positioned(
            right: 0,
            top: 200,
            child: LiquidEdgeIcon(
              payload: HandoffPayload(
                sourceDeviceName: "iPhone 15 Pro",
                appIdentifier: "minecraft.script",
                documentPath: "scripts/main.mc",
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundLight() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Stack(
          children: [
            Positioned(
              top: -50,
              left: -50,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF5E29FF).withOpacity(0.3 * _pulseController.value + 0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                child: Container(color: Colors.transparent),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Aether Flow",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: -0.5),
            ),
            Text(
              "Liquid Continuity Protocol",
              style: TextStyle(fontSize: 14, color: Colors.white54),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white10),
          ),
          child: const Icon(Icons.settings, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildStatusCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.05),
            Colors.white.withOpacity(0.01),
          ],
        ),
      ),
      child: Row(
        children: [
          _buildPulseIndicator(),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("System Active", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text("Listening for nearby devices...", style: TextStyle(color: Colors.white38, fontSize: 12)),
              ],
            ),
          ),
          Switch(
            value: _isServiceActive,
            onChanged: (v) => setState(() => _isServiceActive = v),
            activeColor: Colors.cyanAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildPulseIndicator() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.cyanAccent,
            boxShadow: [
              BoxShadow(
                color: Colors.cyanAccent.withOpacity(0.5),
                blurRadius: 10 * _pulseController.value + 5,
                spreadRadius: 2 * _pulseController.value,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModuleCard(String title, IconData icon, String subtitle, Color color) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
            color: Colors.white.withOpacity(0.03),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 28),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: Colors.white38, fontSize: 11)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
