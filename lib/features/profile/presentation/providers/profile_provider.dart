import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:flutter/services.dart';

final _nativeChannel = const MethodChannel("com.immersivecommerce.app/native");

class DeviceInfo {
  final String platform;
  final String model;
  final String osVersion;

  const DeviceInfo({
    required this.platform,
    required this.model,
    required this.osVersion,
  });

  factory DeviceInfo.fromMap(
    Map<String, dynamic> map, {
    required String platform,
  }) {
    return DeviceInfo(
      platform: platform,
      model: map["model"] ?? map["device"] ?? "Unknown",
      osVersion: map["systemVersion"] ?? map["versionRelease"] ?? "Unknown",
    );
  }
}

final deviceInfoProvider = FutureProvider<DeviceInfo>((ref) async {
  try {
    if (Platform.isAndroid) {
      final result = await _nativeChannel.invokeMethod<Map<dynamic, dynamic>>(
        "getDeviceInfo",
      );
      if (result != null) {
        final map = Map<String, dynamic>.from(result);
        return DeviceInfo.fromMap(map, platform: "Android");
      }
      return const DeviceInfo(
        platform: "Android",
        model: "Unknown",
        osVersion: "Unknown",
      );
    } else if (Platform.isIOS) {
      final result = await _nativeChannel.invokeMethod<Map<dynamic, dynamic>>(
        "getDeviceInfo",
      );
      if (result != null) {
        final map = Map<String, dynamic>.from(result);
        return DeviceInfo.fromMap(map, platform: "iOS");
      }
      return const DeviceInfo(
        platform: "iOS",
        model: "Unknown",
        osVersion: "Unknown",
      );
    } else {
      return const DeviceInfo(
        platform: "Unknown",
        model: "Unknown",
        osVersion: "Unknown",
      );
    }
  } on PlatformException catch (e) {
    return DeviceInfo(
      platform: "Error",
      model: e.code,
      osVersion: e.message ?? "Unknown",
    );
  }
});
