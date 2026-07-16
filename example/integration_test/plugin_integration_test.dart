// This is a basic Flutter integration test.
//
// Since integration tests run in a full Flutter application, they can interact
// with the host side of a plugin implementation, unlike Dart unit tests.
//
// For more information about Flutter integration tests, please see
// https://flutter.dev/to/integration-testing

import 'package:flutter_native_battery_level/flutter_native_battery_level.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('getBatteryLevel test', (WidgetTester tester) async {
    final FlutterNativeBatteryLevel battery = FlutterNativeBatteryLevel();
    final int? level = await battery.getBatteryLevel();
    // The battery level depends on the host platform running the test, so
    // just assert that some non-empty integer is returned.
    expect(level, isNotNull);
  });
}
