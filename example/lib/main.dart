// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_native_battery_level/flutter_native_battery_level.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyWidget());
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final batteryLevel = await FlutterNativeBatteryLevel().getBatteryLevel();
            if (batteryLevel != null) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Battery level: $batteryLevel%')));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to get battery level')));
            }
          },
          child: const Text('Get Battery Level'),
        ),
      ),
    );
  }
}
