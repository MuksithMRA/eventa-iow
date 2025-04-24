import Foundation

struct AuthAPI {
    static let shared = AuthAPI()
    
    private init() {}
    
    func login(email: String, password: String) async throws -> AuthResponse {
        let body: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        return try await APIClient.shared.request(
            endpoint: "/auth/login",
            method: .post,
            body: body
        )
    }
    
    func register(firstName: String, lastName: String, email: String, mobile: String, password: String, interests: [String]) async throws -> AuthResponse {
        let body: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "mobile": mobile,
            "password": password,
            "interests": interests
        ]
        
        return try await APIClient.shared.request(
            endpoint: "/auth/register",
            method: .post,
            body: body
        )
    }
    
    func getUserProfile(token: String) async throws -> UserResponse {
        return try await APIClient.shared.request(
            endpoint: "/auth/me",
            token: token
        )
    }
    
    func updateProfile(token: String, userData: [String: Any]) async throws -> UserResponse {
        return try await APIClient.shared.request(
            endpoint: "/auth/update-me",
            method: .patch,
            body: userData,
            token: token
        )
    }
    
    func updatePassword(token: String, currentPassword: String, newPassword: String) async throws -> AuthResponse {
        let body: [String: Any] = [
            "currentPassword": currentPassword,
            "newPassword": newPassword
        ]
        
        return try await APIClient.shared.request(
            endpoint: "/auth/update-password",
            method: .patch,
            body: body,
            token: token
        )
    }
}

struct AuthResponse: Decodable {
    let status: String
    let token: String
    let data: UserData?
    let message: String?
}

struct UserResponse: Decodable {
    let status: String
    let data: UserData
}

struct UserData: Decodable {
    let user: User
}

struct User: Decodable, Identifiable {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    let mobile: String
    let interests: [String]
    let profileImage: String
    let role: String
    let createdAt: String
    let updatedAt: String
    
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case firstName, lastName, email, mobile, interests, profileImage, role, createdAt, updatedAt
    }
}
