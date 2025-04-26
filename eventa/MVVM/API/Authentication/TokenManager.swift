import Foundation

class TokenManager {
    static let shared = TokenManager()
    
    private let tokenKey = "auth_token"
    private let keychainService = "com.eventa.app"
    private let userIdKey = "id"
    
    private init() {}
    
    func saveToken(_ token: String) {
        let keychainItem = KeychainItem(service: keychainService, account: tokenKey)
        try? keychainItem.savePassword(token)
    }
    
    func getToken() -> String? {
        let keychainItem = KeychainItem(service: keychainService, account: tokenKey)
        return try? keychainItem.readPassword()
    }
    
    func deleteToken() {
        let keychainItem = KeychainItem(service: keychainService, account: tokenKey)
        try? keychainItem.deletePassword()
    }
    
    func isLoggedIn() -> Bool {
        return getToken() != nil
    }
    
    func getUserId() -> String? {
        guard let token = getToken() else { return nil }
        
        let parts = token.components(separatedBy: ".")
        guard parts.count == 3 else { return nil }
        
        let payload = parts[1]
        
        var base64 = payload.replacingOccurrences(of: "-", with: "+")
                           .replacingOccurrences(of: "_", with: "/")
        
        while base64.count % 4 != 0 {
            base64 += "="
        }
        
        guard let data = Data(base64Encoded: base64) else { return nil }
        
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let userId = json[userIdKey] as? String {
                return userId
            } else if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                    let userId = json["sub"] as? String {
                return userId
            } else if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                    let userId = json["id"] as? String {
                return userId
            }
        } catch {
            print("Error decoding JWT token: \(error)")
        }
        
        return nil
    }
}
