import Foundation
import SwiftUI
import Combine
import LocalAuthentication

class LoginViewModel: ObservableObject {
    @Published var model = LoginModel()
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var biometricType: BiometricType = .none
    @Published var showBiometricLogin: Bool = false
    
    init() {
        biometricType = BiometricAuthManager.shared.getBiometricType()
    }
    
    func login() {
        guard model.isFormValid else {
            if !model.isEmailValid {
                errorMessage = "Please enter a valid email address"
            } else if !model.isPasswordValid {
                errorMessage = "Password must be at least 6 characters"
            }
            return
        }
        
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.isLoading = false
            
            if self?.model.email == "test@example.com" && self?.model.password == "password" {
                self?.errorMessage = nil
                if let email = self?.model.email, let password = self?.model.password {
                    BiometricAuthManager.shared.saveCredentials(email: email, password: password)
                }
            } else {
                self?.errorMessage = "Invalid email or password"
            }
        }
    }
    
    func register() {
        
    }
    
    func toggleLoginMethod() {
        model.isEmailLogin.toggle()
    }
    
    func canUseBiometrics() -> Bool {
        return BiometricAuthManager.shared.canUseBiometrics() && BiometricAuthManager.shared.getSavedEmail() != nil
    }
    
    func showFaceIDLogin() {
        showBiometricLogin = true
    }
}
