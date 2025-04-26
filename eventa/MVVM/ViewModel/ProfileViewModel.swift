import SwiftUI
import Combine
import Foundation
import os.log



class SubscriptionAPIAccess {
    static let shared = SubscriptionAPIAccess()
    
    private init() {}
    
    func getCurrentSubscription() async throws -> SubscriptionDetailsResponse {
        let baseURL = "http://localhost:5001/api/subscriptions"
        let token = TokenManager.shared.getToken()
        
        let url = URL(string: "\(baseURL)/current")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = token {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "SubscriptionError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
        }
        
        if httpResponse.statusCode == 404 {
            return SubscriptionDetailsResponse(success: false, subscription: nil)
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NSError(domain: "SubscriptionError", code: httpResponse.statusCode, 
                          userInfo: [NSLocalizedDescriptionKey: "Server error: \(httpResponse.statusCode)"])
        }
        
        return try JSONDecoder().decode(SubscriptionDetailsResponse.self, from: data)
    }
    
    func startTrial() async throws -> SubscriptionResponse {
        let baseURL = "http://localhost:5001/api/subscriptions"
        let token = TokenManager.shared.getToken()
        
        let url = URL(string: "\(baseURL)/trial")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = token {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, 
              (200...299).contains(httpResponse.statusCode) else {
            throw NSError(domain: "SubscriptionError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Server error"])
        }
        
        return try JSONDecoder().decode(SubscriptionResponse.self, from: data)
    }
}


class ProfileViewModel: ObservableObject {
    @Published var model = ProfileModel()
    @Published var selectedTab: Int = 3
    @Published var isPremiumUser: Bool = false
    @Published var subscriptionExpiryDate: String? = nil
    @Published var isLoading: Bool = false
    @Published var userEvents: [ProfileEvent] = []
    @Published var userData: User? = nil
    @Published var statsData: [StatItem] = []
    @Published var showNotificationSettings: Bool = false
    
    private let logger = Logger(subsystem: "com.eventa.app", category: "ProfileViewModel")
    
    init() {
        fetchUserProfile()
        fetchUserEvents()
        checkSubscriptionStatus()
    }
    
    func fetchUserProfile() {
        guard let token = TokenManager.shared.getToken() else { return }
        isLoading = true
        
        Task {
            do {
                let response = try await AuthAPI.shared.getUserProfile(token: token)
                await MainActor.run {
                    let user = response.data.user
                    
                    // Update the model with real user data
                    model.userName = user.fullName
                    model.userEmail = user.email
                    model.userLocation = "Colombo, Sri Lanka" // Default location if not available in API
                    
                    if !user.profileImage.isEmpty && !user.profileImage.contains("default") {
                        // Handle remote image if needed
                        // For now, we'll keep using the local image
                    }
                    
                    self.isLoading = false
                    logger.info("Successfully fetched user profile")
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    logger.error("Error fetching user profile: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func fetchUserEvents() {
        guard let token = TokenManager.shared.getToken() else { return }
        
        Task {
            do {
                // Fetch user events from the API
                let upcomingEvents = try await UsersAPI.shared.getUserEvents(token: token)
                let pastEvents = try await UsersAPI.shared.getUserPastEvents(token: token)
                let organizedEvents = try await UsersAPI.shared.getOrganizedEvents(token: token)
                let likedEvents = try await UsersAPI.shared.getLikedEvents(token: token)
                
                await MainActor.run {
                    // Update stats with real data
                    model.statsItems = [
                        StatItem(title: "Events", value: "\(upcomingEvents.data.events.count + pastEvents.data.events.count)"),
                        StatItem(title: "Organized", value: "\(organizedEvents.data.events.count)"),
                        StatItem(title: "Liked", value: "\(likedEvents.data.events.count)")
                    ]
                    
                    // Convert API events to ProfileEvents
                    model.upcomingEvents = convertToProfileEvents(events: upcomingEvents.data.events)
                    
                    logger.info("Successfully fetched user events")
                }
            } catch {
                await MainActor.run {
                    logger.error("Error fetching user events: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func convertToProfileEvents(events: [Event]) -> [ProfileEvent] {
        return events.map { event in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let date = dateFormatter.date(from: event.date) ?? Date()
            
            let monthFormatter = DateFormatter()
            monthFormatter.dateFormat = "MMMM d"
            let formattedDate = monthFormatter.string(from: date)
            
            let eventType = determineEventType(from: event.category)
            let eventColor = getColorForEventType(eventType)
            
            return ProfileEvent(
                id: Int(event.id.suffix(4), radix: 16) ?? 0,
                title: event.title,
                date: formattedDate,
                location: event.location.address,
                eventId: event.id
            )
        }
    }
    
    private func determineEventType(from category: String) -> String {
        switch category.lowercased() {
        case "technology", "tech", "coding", "programming", "cybersecurity":
            return "technology"
        case "music", "concert", "festival":
            return "music"
        case "food", "culinary", "cooking", "dining":
            return "food"
        case "art", "exhibition", "gallery", "creative":
            return "art"
        default:
            return "business"
        }
    }
    
    private func getColorForEventType(_ type: String) -> Color {
        switch type {
        case "technology":
            return .blue
        case "music":
            return .purple
        case "food":
            return .orange
        case "art":
            return .pink
        case "business":
            return .green
        default:
            return .blue
        }
    }
    
    func handleMenuItemTap(_ menuItem: MenuItem) {
        switch menuItem.title {
        case "Edit Profile":
            editProfile()
        case "My Events":
            viewMyEvents()
        case "Saved Events":
            viewSavedEvents()
        case "Notifications":
            viewNotifications()
        case "Notification Settings":
            openNotificationSettings()
        case "Payment Methods":
            managePaymentMethods()
        case "Settings":
            openSettings()
        case "Help Center":
            openHelpCenter()
        case "Logout":
            logout()
        default:
            break
        }
    }
    
    func editProfile() {
        print("Edit profile tapped")
    }
    
    func viewMyEvents() {
        print("My events tapped")
    }
    
    func viewSavedEvents() {
        print("Saved events tapped")
    }
    
    func viewNotifications() {
        print("Notifications tapped")
    }
    
    func openNotificationSettings() {
        showNotificationSettings = true
    }
    
    func managePaymentMethods() {
        print("Payment methods tapped")
    }
    
    func openSettings() {
        print("Settings tapped")
    }
    
    func openHelpCenter() {
        print("Help center tapped")
    }
    
    func logout() {
        if let tokenManagerClass = NSClassFromString("TokenManager") as? NSObject.Type,
           let sharedInstance = tokenManagerClass.value(forKey: "shared") as? NSObject {
            let selector = NSSelectorFromString("deleteToken")
            if sharedInstance.responds(to: selector) {
                sharedInstance.perform(selector)
            }
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("UserDidLogout"), object: nil)
    }
    
    func viewEventDetails(_ event: ProfileEvent) {
        if let eventId = event.eventId {
            logger.info("View event details: \(event.title) (ID: \(eventId))")
            // Here you would navigate to the event details view
            // For now, we'll just log the event ID
        } else {
            logger.info("View event details: \(event.title)")
        }
    }
    
    func checkSubscriptionStatus() {
        isLoading = true
        
        Task {
            do {
                let api = SubscriptionAPIAccess.shared
                let response = try await api.getCurrentSubscription()
                
                await MainActor.run {
                    isPremiumUser = response.success && response.subscription?.status == "active"
                    subscriptionExpiryDate = response.subscription?.expiryDate
                    isLoading = false
                    
                    if isPremiumUser {
                        logger.info("User has active subscription expiring on \(self.subscriptionExpiryDate ?? "unknown date")")
                    } else {
                        logger.info("User does not have an active subscription")
                    }
                }
            } catch {
                await MainActor.run {
                    isPremiumUser = false
                    isLoading = false
                    logger.error("Error checking subscription: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func startFreeTrial() {
        isLoading = true
        
        Task {
            do {
                let api = SubscriptionAPIAccess.shared
                let response = try await api.startTrial()
                
                await MainActor.run {
                    isLoading = false
                    
                    if response.success {
                        isPremiumUser = true
                        subscriptionExpiryDate = response.expiryDate
                        
                        if let expiryDate = response.expiryDate {
                            UserDefaults.standard.set(expiryDate, forKey: "trial_expiry_date")
                            UserDefaults.standard.set(true, forKey: "has_active_trial")
                        }
                        
                        logger.info("Trial subscription started successfully")
                    } else {
                        logger.error("Failed to start trial: \(response.message)")
                    }
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    logger.error("Error starting trial: \(error.localizedDescription)")
                }
            }
        }
    }
}
