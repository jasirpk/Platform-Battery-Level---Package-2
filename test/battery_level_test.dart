import 'package:flutter_test/flutter_test.dart';
import 'package:battery_level/battery_level.dart';
import 'package:battery_level/battery_level_platform_interface.dart';
import 'package:battery_level/battery_level_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockBatteryLevelPlatform
    with MockPlatformInterfaceMixin
    implements BatteryLevelPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final BatteryLevelPlatform initialPlatform = BatteryLevelPlatform.instance;

  test('$MethodChannelBatteryLevel is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelBatteryLevel>());
  });

  test('getPlatformVersion', () async {
    BatteryLevel batteryLevelPlugin = BatteryLevel();
    MockBatteryLevelPlatform fakePlatform = MockBatteryLevelPlatform();
    BatteryLevelPlatform.instance = fakePlatform;

    expect(await batteryLevelPlugin.getPlatformVersion(), '42');
  });
}
