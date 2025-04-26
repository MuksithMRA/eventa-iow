import Foundation
import UserNotifications
import SwiftUI

// Import ProfileEvent model
extension NotificationManager {
    struct ProfileEvent {
        let id: Int
        let title: String
        let date: String
        let location: String
        let eventId: String?
    }
}

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        // Check current authorization status first
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("📱 Current notification settings:")
            print("  - Authorization status: \(settings.authorizationStatus.rawValue)")
            print("  - Alert setting: \(settings.alertSetting.rawValue)")
            print("  - Sound setting: \(settings.soundSetting.rawValue)")
            print("  - Badge setting: \(settings.badgeSetting.rawValue)")
            
            if settings.authorizationStatus == .authorized {
                print("✅ Notifications already authorized")
                DispatchQueue.main.async {
                    completion(true)
                }
                return
            }
            
            // Request authorization if not already authorized
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                print("📱 Authorization request result: \(granted ? "granted" : "denied")")
                if let error = error {
                    print("❌ Authorization error: \(error.localizedDescription)")
                }
                
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        }
    }
    
    func schedulePromotionalNotification(title: String, body: String, timeInterval: TimeInterval = 5, identifier: String? = nil) {
        // Create notification content
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        // Add a category identifier for potential actions
        content.categoryIdentifier = "PROMOTIONAL"
        
        // Create trigger - ensure timeInterval is at least 1 second
        let safeTimeInterval = max(1.0, timeInterval)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: safeTimeInterval, repeats: false)
        
        // Create request with unique identifier
        let notificationId = identifier ?? "promo-\(UUID().uuidString)"
        let request = UNNotificationRequest(identifier: notificationId, content: content, trigger: trigger)
        
        // Print debug info
        print("📱 Scheduling notification: \(title)")
        print("⏰ Will appear in \(safeTimeInterval) seconds")
        print("🆔 Identifier: \(notificationId)")
        
        // Add the notification request to the notification center
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("✅ Notification scheduled successfully!")
                
                // Debug: List pending notifications
                UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
                    print("📋 Pending notifications: \(requests.count)")
                    for request in requests {
                        print("  - \(request.identifier)")
                    }
                }
            }
        }
    }
    
    func scheduleEventPromotionalNotification(event: ProfileEvent, timeInterval: TimeInterval = 5) {
        let title = "New Event: \(event.title)"
        let body = "Don't miss \(event.title) on \(event.date) at \(event.location)"
        
        schedulePromotionalNotification(title: title, body: body, timeInterval: timeInterval, identifier: "event-\(event.id)")
    }
    
    func scheduleDailyPromotionalNotification(timeInterval: TimeInterval = 86400) {
        let title = "Check Out New Events!"
        let body = "Discover exciting events happening near you today"
        
        schedulePromotionalNotification(title: title, body: body, timeInterval: timeInterval, identifier: "daily-promo")
    }
    
    func scheduleWeeklyPromotionalNotification(timeInterval: TimeInterval = 604800) {
        let title = "This Week's Top Events"
        let body = "See what's trending this week in your area"
        
        schedulePromotionalNotification(title: title, body: body, timeInterval: timeInterval, identifier: "weekly-promo")
    }
    
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func cancelNotification(withIdentifier identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
}
