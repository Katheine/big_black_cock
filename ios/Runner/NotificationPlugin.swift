import Foundation
import UserNotifications

@objc public class NotificationPlugin: NSObject, FlutterPlugin {
    
    @objc public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "notification_plugin", binaryMessenger: registrar.messenger())
        let instance = NotificationPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "set_notification":
            let args = call.arguments as! [String: Any]
            let time = args["time"] as! NSNumber
            let name = args["name"] as! String
            let notifCenter = UNUserNotificationCenter.current()
            notifCenter.getNotificationSettings { settings in
                if settings.authorizationStatus == .authorized {
                    print("Authorized")
                    self.setNotification(name, time)
                    result(nil)
                } else {
                    print("Requested auth")
                    notifCenter.requestAuthorization(options: [.alert, .sound]) { permitted, _ in
                        if !permitted {
                            result("Permission denied")
                        } else {
                            print("Permission granted")
                            self.setNotification(name, time)
                            result(nil)
                        }
                    }
                }
            }
        case "cancel_notification":
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func setNotification(_ name: String, _ time: NSNumber) {
        let date = Date(timeIntervalSince1970: time.doubleValue / 1000)
        let cont = UNMutableNotificationContent()
        cont.title = "ПОЛИЙ КВІТОЧКУ"
        cont.body = "КВІТОЧКУ ПОЛИЙ \(name)"
        cont.sound = UNNotificationSound.default()
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: date.timeIntervalSinceNow, repeats: false)
        let notificationReq = UNNotificationRequest(identifier: "id", content: cont, trigger: trigger)
        print("Attempt to set local notification for \(date.timeIntervalSinceNow)")
        UNUserNotificationCenter.current().add(notificationReq, withCompletionHandler: { error in
            if let error = error {
                print(error)
            } else {
                print("Set successfully")
            }
        })
    }
    
}
