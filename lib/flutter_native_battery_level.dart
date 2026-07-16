import 'package:flutter/services.dart';

class FlutterNativeBatteryLevel {
  static const MethodChannel channel = MethodChannel('samples.flutter.dev/battery');

  Future<int?> getBatteryLevel() async {
    try {
      final int? result = await channel.invokeMethod('flutter_native_battery_level');
      return result;
    } on PlatformException {
      return null;
    }
  }
}
