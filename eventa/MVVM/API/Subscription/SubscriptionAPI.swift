import Foundation
import SwiftUI
import Combine

struct SubscriptionResponse: Decodable {
    let success: Bool
    let message: String
    let subscriptionId: String?
    let expiryDate: String?
}

struct SubscriptionFeatures: Decodable {
    let eventsPerMonth: Int
    let onlinePayment: Bool
    let reports: Bool
    let analytics: Bool
    let ticketTemplates: Bool
    let promotionsPerMonth: Int
}

struct SubscriptionDetails: Decodable {
    let id: String
    let user: String
    let type: String
    let status: String
    let startDate: String
    let expiryDate: String
    let price: Int
    let features: SubscriptionFeatures
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case user, type, status, startDate, expiryDate, price, features
    }
}

struct SubscriptionDetailsResponse: Decodable {
    let success: Bool
    let subscription: SubscriptionDetails?
}

struct SubscriptionAPI {
    static let shared = SubscriptionAPI()
    
    private let baseURL = "http://localhost:5001/api/subscriptions"
    
    private init() {}
    
    func startTrial() async throws -> SubscriptionResponse {
        let token = UserDefaults.standard.string(forKey: "auth_token")
        
        let url = URL(string: "\(baseURL)/trial")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = token {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, 
                  (200...299).contains(httpResponse.statusCode) else {
                throw NSError(domain: "SubscriptionError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Server error"])
            }
            
            return try JSONDecoder().decode(SubscriptionResponse.self, from: data)
        } catch {
            throw error
        }
    }
    
    func getCurrentSubscription() async throws -> SubscriptionDetailsResponse {
        let token = UserDefaults.standard.string(forKey: "auth_token")
        
        let url = URL(string: "\(baseURL)/current")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = token {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NSError(domain: "SubscriptionError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Server error"])
            }
            
            if httpResponse.statusCode == 404 {
                return SubscriptionDetailsResponse(success: false, subscription: nil)
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw NSError(domain: "SubscriptionError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server error"])
            }
            
            return try JSONDecoder().decode(SubscriptionDetailsResponse.self, from: data)
        } catch {
            throw error
        }
    }
    
    func cancelSubscription() async throws -> SubscriptionResponse {
        let token = UserDefaults.standard.string(forKey: "auth_token")
        
        let url = URL(string: "\(baseURL)/cancel")!
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = token {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, 
                  (200...299).contains(httpResponse.statusCode) else {
                throw NSError(domain: "SubscriptionError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Server error"])
            }
            
            return try JSONDecoder().decode(SubscriptionResponse.self, from: data)
        } catch {
            throw error
        }
    }
    
    func hasActiveSubscription() async -> Bool {
        do {
            let response = try await getCurrentSubscription()
            return response.success && response.subscription?.status == "active"
        } catch {
            return false
        }
    }
}
