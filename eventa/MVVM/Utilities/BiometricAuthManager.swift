import Foundation
import LocalAuthentication

enum BiometricType {
    case none
    case faceID
    case touchID
    
    var description: String {
        switch self {
        case .none:
            return "None"
        case .faceID:
            return "Face ID"
        case .touchID:
            return "Touch ID"
        }
    }
}

enum BiometricError: LocalizedError {
    case authenticationFailed
    case userCancel
    case userFallback
    case biometryNotAvailable
    case biometryNotEnrolled
    case biometryLockout
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .authenticationFailed: return "Authentication failed"
        case .userCancel: return "User canceled"
        case .userFallback: return "User chose fallback"
        case .biometryNotAvailable: return "Biometry not available"
        case .biometryNotEnrolled: return "Biometry not enrolled"
        case .biometryLockout: return "Biometry locked out"
        case .unknown: return "Unknown error"
        }
    }
}

class BiometricAuthManager {
    static let shared = BiometricAuthManager()
    
    private let context = LAContext()
    private var error: NSError?
    
    private init() {}
    
    func getBiometricType() -> BiometricType {
        context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        
        switch context.biometryType {
        case .none:
            return .none
        case .faceID:
            return .faceID
        case .touchID:
            return .touchID
        @unknown default:
            return .none
        }
    }
    
    func canUseBiometrics() -> Bool {
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }
    
    func authenticate(completion: @escaping (Result<Bool, BiometricError>) -> Void) {
        guard canUseBiometrics() else {
            if let error = error as? LAError {
                switch error.code {
                case .biometryNotAvailable:
                    completion(.failure(.biometryNotAvailable))
                case .biometryNotEnrolled:
                    completion(.failure(.biometryNotEnrolled))
                case .biometryLockout:
                    completion(.failure(.biometryLockout))
                default:
                    completion(.failure(.unknown))
                }
            } else {
                completion(.failure(.biometryNotAvailable))
            }
            return
        }
        
        let reason = "Log in to your account"
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
            DispatchQueue.main.async {
                if success {
                    completion(.success(true))
                    return
                }
                
                if let error = error as? LAError {
                    switch error.code {
                    case .authenticationFailed:
                        completion(.failure(.authenticationFailed))
                    case .userCancel:
                        completion(.failure(.userCancel))
                    case .userFallback:
                        completion(.failure(.userFallback))
                    case .biometryNotAvailable:
                        completion(.failure(.biometryNotAvailable))
                    case .biometryNotEnrolled:
                        completion(.failure(.biometryNotEnrolled))
                    case .biometryLockout:
                        completion(.failure(.biometryLockout))
                    default:
                        completion(.failure(.unknown))
                    }
                } else {
                    completion(.failure(.unknown))
                }
            }
        }
    }
    
    func saveCredentials(email: String, password: String) {
        UserDefaults.standard.set(email, forKey: "savedEmail")
        
        let keychainItem = KeychainItem(service: "com.eventa.app", account: email)
        try? keychainItem.savePassword(password)
    }
    
    func getSavedEmail() -> String? {
        return UserDefaults.standard.string(forKey: "savedEmail")
    }
    
    func getPassword(for email: String) -> String? {
        let keychainItem = KeychainItem(service: "com.eventa.app", account: email)
        return try? keychainItem.readPassword()
    }
}
