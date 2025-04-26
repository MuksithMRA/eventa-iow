import Foundation
import SwiftUI
import Combine
import os.log



class TrialSubscriptionViewModel: ObservableObject {
    @Published var model: TrialSubscriptionModel
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    private let logger = Logger(subsystem: "com.eventa.app", category: "TrialSubscriptionViewModel")
    
    init() {
        self.model = TrialSubscriptionModel(
            title: "Enjoy your 14 days free trial",
            subtitle: "No payment now - Cancel anytime",
            features: [
                "20 events per month",
                "Online Payment handeling",
                "Monthly / Weekly reports",
                "Advanced analytics",
                "Ticket Templates",
                "Promote event twice per month"
            ],
            startButtonText: "Start free 14 days trial",
            subscriptionInfoText: "Your subscription starts after the trial, When you'll be charged LKR 3000 Per month",
            monthlyPrice: "3000"
        )
    }
    
    func startFreeTrial() {
        isLoading = true
        errorMessage = nil
        
        Task<Void, Never> {
            do {
                let token = UserDefaults.standard.string(forKey: "auth_token")
                
                let url = URL(string: "http://localhost:5001/api/subscriptions/trial")!
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                
                if let token = token {
                    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                } else {
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.isLoading = false
                        self.errorMessage = "You need to be logged in to start a trial"
                    }
                    return
                }
                
                let (data, response) = try await URLSession.shared.data(for: request)
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NSError(domain: "SubscriptionError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
                }
                
                if (200...299).contains(httpResponse.statusCode) {
                    let decoder = JSONDecoder()
                    let subscriptionResponse = try decoder.decode(SubscriptionResponse.self, from: data)
                    
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.isLoading = false
                        
                        if subscriptionResponse.success {
                            if let expiryDate = subscriptionResponse.expiryDate {
                                UserDefaults.standard.set(expiryDate, forKey: "trial_expiry_date")
                                UserDefaults.standard.set(true, forKey: "has_active_trial")
                            }
                            self.logger.info("Trial subscription started successfully")
                        } else {
                            self.errorMessage = subscriptionResponse.message
                            self.logger.error("Failed to start trial: \(subscriptionResponse.message)")
                        }
                    }
                } else {
                    throw NSError(domain: "SubscriptionError", code: httpResponse.statusCode, 
                                  userInfo: [NSLocalizedDescriptionKey: "Server error: \(httpResponse.statusCode)"])
                }
            } catch {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.isLoading = false
                    self.errorMessage = error.localizedDescription
                    self.logger.error("Error starting trial: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func dismissSubscription() {
        
    }
}
