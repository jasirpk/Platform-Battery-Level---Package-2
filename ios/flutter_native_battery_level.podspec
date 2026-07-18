#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint battery_level.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_native_battery_level'
  s.version          = '0.1.1'
  s.summary          = 'Flutter plugin for retrieving native device battery level.'
  s.description      = <<-DESC
Flutter plugin for retrieving native device battery level on Android and iOS using Method Channels.
                       DESC
  s.homepage         = 'https://github.com/jasirpk/Platform-Battery-Level---Package-2'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'jasir pk' => 'jasir.techofficial@gamil.com' }
  s.source           = { :path => '.' }
  s.source_files = 'flutter_native_battery_level/Sources/flutter_native_battery_level/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # s.resource_bundles = {'battery_level_privacy' => ['battery_level/Sources/battery_level/PrivacyInfo.xcprivacy']}
end
