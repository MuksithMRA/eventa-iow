import Foundation

class TokenManager {
    static let shared = TokenManager()
    
    private let tokenKey = "auth_token"
    private let keychainService = "com.eventa.app"
    
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
}
