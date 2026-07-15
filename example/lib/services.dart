import 'package:flutter/services.dart';
class BatteryLevel {
  static const MethodChannel _channel =
      MethodChannel('samples.flutter.dev/battery');

  Future<int?> getBatteryLevel() async {
    return await _channel.invokeMethod<int>('battery_level');
  }
}