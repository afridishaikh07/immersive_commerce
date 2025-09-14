import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    
    // MethodChannel for native iOS functionality
    let methodChannel = FlutterMethodChannel(
      name: "com.immersivecommerce.app/native",
      binaryMessenger: controller.binaryMessenger
    )
    
    methodChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      
      switch call.method {
      case "getDeviceInfo":
        self.getDeviceInfo(result: result)
      case "showNativeAlert":
        if let args = call.arguments as? [String: Any],
           let title = args["title"] as? String,
           let message = args["message"] as? String {
          self.showNativeAlert(title: title, message: message, result: result)
        } else {
          result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments for showNativeAlert", details: nil))
        }
      case "getBatteryLevel":
        self.getBatteryLevel(result: result)
      case "openNativeSettings":
        self.openNativeSettings(result: result)
      case "shareContent":
        if let args = call.arguments as? [String: Any],
           let content = args["content"] as? String {
          self.shareContent(content: content, result: result)
        } else {
          result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments for shareContent", details: nil))
        }
      default:
        result(FlutterMethodNotImplemented)
      }
    })
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  // MARK: - Method Channel Handlers
  
  private func getDeviceInfo(result: @escaping FlutterResult) {
    let device = UIDevice.current
    let deviceInfo: [String: Any] = [
      "name": device.name,
      "model": device.model,
      "systemName": device.systemName,
      "systemVersion": device.systemVersion,
      "identifierForVendor": device.identifierForVendor?.uuidString ?? "",
      "isPhysicalDevice": !isSimulator(),
      "batteryLevel": device.batteryLevel,
      "batteryState": device.batteryState.rawValue
    ]
    result(deviceInfo)
  }
  
  private func showNativeAlert(title: String, message: String, result: @escaping FlutterResult) {
    DispatchQueue.main.async {
      let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
        result("Alert dismissed")
      })
      
      if let rootViewController = self.window?.rootViewController {
        rootViewController.present(alert, animated: true)
      } else {
        result(FlutterError(code: "NO_ROOT_CONTROLLER", message: "No root view controller found", details: nil))
      }
    }
  }
  
  private func getBatteryLevel(result: @escaping FlutterResult) {
    UIDevice.current.isBatteryMonitoringEnabled = true
    let batteryLevel = UIDevice.current.batteryLevel
    result(batteryLevel)
  }
  
  private func openNativeSettings(result: @escaping FlutterResult) {
    DispatchQueue.main.async {
      if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
        if UIApplication.shared.canOpenURL(settingsUrl) {
          UIApplication.shared.open(settingsUrl) { success in
            result(success)
          }
        } else {
          result(FlutterError(code: "CANNOT_OPEN_SETTINGS", message: "Cannot open settings", details: nil))
        }
      } else {
        result(FlutterError(code: "INVALID_SETTINGS_URL", message: "Invalid settings URL", details: nil))
      }
    }
  }
  
  private func shareContent(content: String, result: @escaping FlutterResult) {
    DispatchQueue.main.async {
      let activityViewController = UIActivityViewController(
        activityItems: [content],
        applicationActivities: nil
      )
      
      // For iPad support
      if let popover = activityViewController.popoverPresentationController {
        popover.sourceView = self.window?.rootViewController?.view
        popover.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
        popover.permittedArrowDirections = []
      }
      
      if let rootViewController = self.window?.rootViewController {
        rootViewController.present(activityViewController, animated: true) {
          result("Share dialog presented")
        }
      } else {
        result(FlutterError(code: "NO_ROOT_CONTROLLER", message: "No root view controller found", details: nil))
      }
    }
  }
  
  // MARK: - Helper Methods
  
  private func isSimulator() -> Bool {
    #if targetEnvironment(simulator)
    return true
    #else
    return false
    #endif
  }
}