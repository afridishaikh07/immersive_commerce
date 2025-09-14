import 'package:flutter/services.dart';

class NativeService {
  static const MethodChannel _channel = MethodChannel(
    'com.immersivecommerce.app/native',
  );

  // Get device information
  static Future<Map<String, dynamic>> getDeviceInfo() async {
    try {
      final Map<dynamic, dynamic> result = await _channel.invokeMethod(
        'getDeviceInfo',
      );
      return Map<String, dynamic>.from(result);
    } on PlatformException catch (e) {
      throw Exception('Failed to get device info: ${e.message}');
    }
  }

  // Show native alert
  static Future<String> showNativeAlert({
    required String title,
    required String message,
  }) async {
    try {
      final String result = await _channel.invokeMethod('showNativeAlert', {
        'title': title,
        'message': message,
      });
      return result;
    } on PlatformException catch (e) {
      throw Exception('Failed to show alert: ${e.message}');
    }
  }

  // Get battery level
  static Future<double> getBatteryLevel() async {
    try {
      final double result = await _channel.invokeMethod('getBatteryLevel');
      return result;
    } on PlatformException catch (e) {
      throw Exception('Failed to get battery level: ${e.message}');
    }
  }

  // Open native settings
  static Future<bool> openNativeSettings() async {
    try {
      final bool result = await _channel.invokeMethod('openNativeSettings');
      return result;
    } on PlatformException catch (e) {
      throw Exception('Failed to open settings: ${e.message}');
    }
  }

  // Share content
  static Future<String> shareContent(String content) async {
    try {
      final String result = await _channel.invokeMethod('shareContent', {
        'content': content,
      });
      return result;
    } on PlatformException catch (e) {
      throw Exception('Failed to share content: ${e.message}');
    }
  }
}
