import Foundation

struct UsersAPI {
    static let shared = UsersAPI()
    
    private init() {}
    
    func getUserById(token: String, id: String) async throws -> UserResponse {
        return try await APIClient.shared.request(
            endpoint: "/users/\(id)",
            token: token
        )
    }
    
    func getUserEvents(token: String, userId: String? = nil) async throws -> EventsResponse {
        let endpoint = userId != nil ? "/users/\(userId!)/events" : "/users/my-events"
        return try await APIClient.shared.request(
            endpoint: endpoint,
            token: token
        )
    }
    
    func getUserPastEvents(token: String, userId: String? = nil) async throws -> EventsResponse {
        let endpoint = userId != nil ? "/users/\(userId!)/past-events" : "/users/my-past-events"
        return try await APIClient.shared.request(
            endpoint: endpoint,
            token: token
        )
    }
    
    func getOrganizedEvents(token: String, userId: String? = nil) async throws -> EventsResponse {
        let endpoint = userId != nil ? "/users/\(userId!)/organized-events" : "/users/my-organized-events"
        return try await APIClient.shared.request(
            endpoint: endpoint,
            token: token
        )
    }
    
    func getLikedEvents(token: String) async throws -> EventsResponse {
        return try await APIClient.shared.request(
            endpoint: "/users/my-liked-events",
            token: token
        )
    }
    
    func getAllUsers(token: String) async throws -> UsersResponse {
        return try await APIClient.shared.request(
            endpoint: "/users",
            token: token
        )
    }
}

struct UsersResponse: Decodable {
    let status: String
    let results: Int
    let data: UsersData
}

struct UsersData: Decodable {
    let users: [User]
}
