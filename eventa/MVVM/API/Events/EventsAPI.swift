import Foundation
import SwiftUI
import CoreLocation

struct EventsAPI {
    static let shared = EventsAPI()
    
    private init() {}
    
    func getAllEvents(token: String? = nil, page: Int = 1, limit: Int = 10) async throws -> EventsResponse {
        let endpoint = "/events?page=\(page)&limit=\(limit)"
        return try await APIClient.shared.request(endpoint: endpoint, token: token)
    }
    
    func getFeaturedEvents(token: String? = nil) async throws -> EventsResponse {
        return try await APIClient.shared.request(endpoint: "/events/featured", token: token)
    }
    
    func getEventById(id: String, token: String? = nil) async throws -> EventResponse {
        return try await APIClient.shared.request(endpoint: "/events/\(id)", token: token)
    }
    
    func createEvent(token: String, eventData: [String: Any]) async throws -> EventResponse {
        return try await APIClient.shared.request(
            endpoint: "/events",
            method: .post,
            body: eventData,
            token: token
        )
    }
    
    func updateEvent(token: String, id: String, eventData: [String: Any]) async throws -> EventResponse {
        return try await APIClient.shared.request(
            endpoint: "/events/\(id)",
            method: .patch,
            body: eventData,
            token: token
        )
    }
    
    func deleteEvent(token: String, id: String) async throws -> EmptyResponse {
        return try await APIClient.shared.request(
            endpoint: "/events/\(id)",
            method: .delete,
            token: token
        )
    }
    
    func joinEvent(token: String, id: String) async throws -> EventResponse {
        return try await APIClient.shared.request(
            endpoint: "/events/\(id)/join",
            method: .patch,
            token: token
        )
    }
    
    func leaveEvent(token: String, id: String) async throws -> EventResponse {
        return try await APIClient.shared.request(
            endpoint: "/events/\(id)/leave",
            method: .patch,
            token: token
        )
    }
    
    func likeEvent(token: String, id: String) async throws -> EventResponse {
        return try await APIClient.shared.request(
            endpoint: "/events/\(id)/like",
            method: .patch,
            token: token
        )
    }
        
    func searchEvents(query: String, token: String? = nil) async throws -> EventsResponse {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return try await APIClient.shared.request(endpoint: "/events/search?query=\(encodedQuery)", token: token)
    }
    
    func getEventReviews(token: String, eventId: String, type: String? = nil) async throws -> ReviewsResponse {
        var endpoint = "/events/\(eventId)/reviews"
        if let type = type {
            endpoint += "?type=\(type)"
        }
        return try await APIClient.shared.request(
            endpoint: endpoint,
            token: token
        )
    }
    
    func createReview(token: String, eventId: String, reviewData: [String: Any]) async throws -> ReviewResponse {
        return try await APIClient.shared.request(
            endpoint: "/events/\(eventId)/reviews",
            method: .post,
            body: reviewData,
            token: token
        )
    }
    
    func updateReview(token: String, eventId: String, reviewId: String, reviewData: [String: Any]) async throws -> ReviewResponse {
        return try await APIClient.shared.request(
            endpoint: "/events/\(eventId)/reviews/\(reviewId)",
            method: .patch,
            body: reviewData,
            token: token
        )
    }
    
    func deleteReview(token: String, eventId: String, reviewId: String) async throws -> EmptyResponse {
        return try await APIClient.shared.request(
            endpoint: "/events/\(eventId)/reviews/\(reviewId)",
            method: .delete,
            token: token
        )
    }
}

struct EventsResponse: Decodable {
    let status: String
    let results: Int
    let data: EventsData
}

struct EventResponse: Decodable {
    let status: String
    let data: EventData
}

struct EventsData: Decodable {
    let events: [Event]
}

struct EventData: Decodable {
    let event: Event
}

struct EmptyResponse: Decodable {
    let status: String
    let data: EmptyData?
}

struct EmptyData: Decodable {}

struct ReviewsResponse: Decodable {
    let status: String
    let results: Int
    let data: ReviewsData
}

struct ReviewResponse: Decodable {
    let status: String
    let data: ReviewData
}

struct ReviewsData: Decodable {
    let reviews: [ReviewItem]
}

struct ReviewData: Decodable {
    let review: ReviewItem
}

struct ReviewItem: Decodable, Identifiable {
    let id: String
    let content: String
    let rating: Int
    let type: String
    let event: String
    let user: ReviewUser
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case content, rating, type, event, user, createdAt
    }
}

struct ReviewUser: Decodable, Identifiable {
    let id: String
    let firstName: String
    let lastName: String
    let profileImage: String
    
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case firstName, lastName, profileImage
    }
}

struct Event: Decodable, Identifiable {
    let id: String
    let title: String
    let description: String
    let date: String
    let starttime: String
    let endtime: String
    let location: Location
    let price: Price
    let category: String
    let image: String
    let organizer: EventOrganizer
    let participants: [EventParticipant]?
    let likes: [String]?
    let featured: Bool
    let createdAt: String
    let updatedAt: String
    let participantCount: Int
    let likeCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title, description, date, starttime, endtime, location, price, category, image, organizer, participants, likes, featured, createdAt, updatedAt, participantCount, likeCount
    }
}

struct Location: Decodable {
    let address: String
    let city: String
    let coordinates: Coordinates
}

struct Coordinates: Decodable {
    let latitude: Double
    let longitude: Double
}

struct Price: Decodable {
    let amount: Double
    let currency: String
}

struct EventOrganizer: Decodable, Identifiable {
    let id: String
    let firstName: String
    let lastName: String
    let profileImage: String
    
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case firstName, lastName, profileImage
    }
}

struct EventParticipant: Decodable, Identifiable {
    let id: String
    let firstName: String
    let lastName: String
    let profileImage: String
    
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case firstName, lastName, profileImage
    }
}
