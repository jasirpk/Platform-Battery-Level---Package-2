// ignore_for_file: use_build_context_synchronously

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_native_battery_level/flutter_native_battery_level.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
      home: const MyWidget(),
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> with SingleTickerProviderStateMixin {
  int? _batteryLevel;
  bool _loading = false;
  String? _error;
  late final AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _animation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _fetchBatteryLevel();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _fetchBatteryLevel() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final level = await FlutterNativeBatteryLevel().getBatteryLevel();
      if (level != null) {
        final oldValue = _animation.value;
        _animation = Tween<double>(begin: oldValue, end: level.toDouble()).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
        );
        _controller.forward(from: 0);
        setState(() {
          _batteryLevel = level;
          _loading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to get battery level';
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Something went wrong';
        _loading = false;
      });
    }
  }

  Color _colorForLevel(double level) {
    if (level <= 15) return const Color(0xFFFF5A5A);
    if (level <= 40) return const Color(0xFFFFB84D);
    return const Color(0xFF4DE1A8);
  }

  IconData _iconForLevel(double level) {
    if (level <= 5) return Icons.battery_alert_rounded;
    if (level <= 25) return Icons.battery_2_bar_rounded;
    if (level <= 50) return Icons.battery_4_bar_rounded;
    if (level <= 75) return Icons.battery_5_bar_rounded;
    return Icons.battery_full_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F1220), Color(0xFF1B1E33)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Battery Status',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 40),
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      final value = _animation.value;
                      final color = _colorForLevel(value);
                      return SizedBox(
                        width: 240,
                        height: 240,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CustomPaint(
                              size: const Size(240, 240),
                              painter: _RingPainter(
                                progress: value / 100,
                                color: color,
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _batteryLevel == null
                                      ? Icons.battery_unknown_rounded
                                      : _iconForLevel(value),
                                  color: color,
                                  size: 36,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _batteryLevel == null ? '--' : '${value.round()}%',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 44,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        color: color.withOpacity(0.5),
                                        blurRadius: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 36),
                  if (_error != null)
                    Text(
                      _error!,
                      style: const TextStyle(color: Colors.redAccent, fontSize: 14),
                    ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _loading ? null : _fetchBatteryLevel,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.08),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      icon: _loading
                          ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white70,
                        ),
                      )
                          : const Icon(Icons.refresh_rounded),
                      label: Text(_loading ? 'Checking...' : 'Refresh'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress; // 0.0 - 1.0
  final Color color;

  _RingPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - 12;

    final trackPaint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..shader = SweepGradient(
        startAngle: -math.pi / 2,
        endAngle: 3 * math.pi / 2,
        colors: [color.withOpacity(0.4), color],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}