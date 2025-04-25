import SwiftUI
import Combine
import Foundation
import os.log


// Local access to SubscriptionAPI
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
    
    private let logger = Logger(subsystem: "com.eventa.app", category: "ProfileViewModel")
    
    init() {
        checkSubscriptionStatus()
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
        print("View event details: \(event.title)")
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
