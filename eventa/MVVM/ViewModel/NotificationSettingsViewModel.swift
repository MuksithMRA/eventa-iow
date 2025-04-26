import SwiftUI
import Combine
import UserNotifications

// Import ProfileEvent type
typealias ProfileEvent = NotificationManager.ProfileEvent

class NotificationSettingsViewModel: ObservableObject {
    @Published var enablePromotionalNotifications: Bool = false
    @Published var enableDailyNotifications: Bool = false
    @Published var enableWeeklyNotifications: Bool = false
    @Published var enableNewEventNotifications: Bool = false
    @Published var maxNotificationsPerWeek: Int = 3
    
    private let userDefaults = UserDefaults.standard
    private let notificationManager = NotificationManager.shared
    
    func loadSettings() {
        enablePromotionalNotifications = userDefaults.bool(forKey: "enablePromotionalNotifications")
        enableDailyNotifications = userDefaults.bool(forKey: "enableDailyNotifications")
        enableWeeklyNotifications = userDefaults.bool(forKey: "enableWeeklyNotifications")
        enableNewEventNotifications = userDefaults.bool(forKey: "enableNewEventNotifications")
        maxNotificationsPerWeek = userDefaults.integer(forKey: "maxNotificationsPerWeek")
        
        if maxNotificationsPerWeek == 0 {
            maxNotificationsPerWeek = 3
        }
    }
    
    func saveSettings() {
        userDefaults.set(enablePromotionalNotifications, forKey: "enablePromotionalNotifications")
        userDefaults.set(enableDailyNotifications, forKey: "enableDailyNotifications")
        userDefaults.set(enableWeeklyNotifications, forKey: "enableWeeklyNotifications")
        userDefaults.set(enableNewEventNotifications, forKey: "enableNewEventNotifications")
        userDefaults.set(maxNotificationsPerWeek, forKey: "maxNotificationsPerWeek")
        
        if enablePromotionalNotifications {
            scheduleNotificationsBasedOnPreferences()
        } else {
            notificationManager.cancelAllNotifications()
        }
    }
    
    func requestNotificationPermission() {
        notificationManager.requestAuthorization { granted in
            if !granted {
                self.enablePromotionalNotifications = false
            }
        }
    }
    
    func scheduleNotificationsBasedOnPreferences() {
        notificationManager.cancelAllNotifications()
        
        if enableDailyNotifications {
            notificationManager.scheduleDailyPromotionalNotification()
        }
        
        if enableWeeklyNotifications {
            notificationManager.scheduleWeeklyPromotionalNotification()
        }
    }
    
    func scheduleEventNotification(for event: ProfileEvent) {
        if enablePromotionalNotifications && enableNewEventNotifications {
            notificationManager.scheduleEventPromotionalNotification(event: event)
        }
    }
    
    func cancelAllNotifications() {
        notificationManager.cancelAllNotifications()
    }
    
    func testNotification() {
        Task { @MainActor in
            let center = UNUserNotificationCenter.current()
            let settings = await center.notificationSettings()
            
            if settings.authorizationStatus != .authorized {
                notificationManager.requestAuthorization { granted in
                    if granted {
                        self.sendTestNotification()
                    } else {
                        print("Notification permission denied")
                    }
                }
            } else {
                sendTestNotification()
            }
        }
    }
    
    private func sendTestNotification() {
        self.notificationManager.schedulePromotionalNotification(
            title: "Test Notification",
            body: "This is a test notification from Eventa app! Sent at \(Date().formatted(.dateTime))",
            timeInterval: 2,
            identifier: "test-notification-\(UUID().uuidString)")
        
        print("Test notification scheduled!")
    }
}
