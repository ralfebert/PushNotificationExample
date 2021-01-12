import os
import SwiftUI

@main
struct ExampleApp: App {

    @UIApplicationDelegateAdaptor private var systemServices: ExampleAppSystemServices

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    self.systemServices.requestAuthorizationForPushNotifications()
                }
                .environmentObject(self.systemServices)

        }
    }

}

class ExampleAppSystemServices: NSObject, ObservableObject, UIApplicationDelegate {

    @Published var pushNotificationDeviceToken: String?

    func requestAuthorizationForPushNotifications() {
        os_log("Requesting authorization for push notifications", type: .info)
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) { granted, error in
            os_log("requestAuthorization granted: %s, error: %s", type: .info, String(describing: granted), String(describing: error))
            if granted {
                UNUserNotificationCenter.current().getNotificationSettings { settings in
                    os_log("getNotificationSettings: %s", type: .info, String(describing: settings))
                    guard settings.authorizationStatus == .authorized else { return }
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
        }
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        os_log("Device Token: %s", type: .info, token)
        self.pushNotificationDeviceToken = token
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        os_log("didFailToRegisterForRemoteNotificationsWithError: %s", type: .error, String(describing: error))
        self.pushNotificationDeviceToken = nil
    }

}
