import Flutter
import UIKit

public class FlutterNativeBatteryLevelPlugin: NSObject, FlutterPlugin {

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "samples.flutter.dev/battery",
            binaryMessenger: registrar.messenger()
        )

        let instance = FlutterNativeBatteryLevelPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(
        _ call: FlutterMethodCall,
        result: @escaping FlutterResult
    ) {
        guard call.method == "flutter_native_battery_level" else {
            result(FlutterMethodNotImplemented)
            return
        }

        getBatteryLevel(result: result)
    }

    private func getBatteryLevel(result: FlutterResult) {
        UIDevice.current.isBatteryMonitoringEnabled = true

        let batteryLevel = UIDevice.current.batteryLevel

        if batteryLevel == -1 {
            result(
                FlutterError(
                    code: "UNAVAILABLE",
                    message: "Battery level not available.",
                    details: nil
                )
            )
        } else {
            result(Int(batteryLevel * 100))
        }
    }
}