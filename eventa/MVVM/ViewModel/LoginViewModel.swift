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
    @Published var isAuthenticated = false
    
    init() {
        biometricType = BiometricAuthManager.shared.getBiometricType()
        isAuthenticated = TokenManager.shared.isLoggedIn()
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
        
        Task {
            do {
                let response = try await AuthAPI.shared.login(email: model.email, password: model.password)
                
                await MainActor.run {
                    self.isLoading = false
                    self.errorMessage = nil
                    
                    TokenManager.shared.saveToken(response.token)
                    BiometricAuthManager.shared.saveCredentials(email: model.email, password: model.password)
                    
                    self.isAuthenticated = true
                    NotificationCenter.default.post(name: NSNotification.Name("UserDidLogin"), object: nil)
                }
            } catch let error as APIError {
                await MainActor.run {
                    self.isLoading = false
                    self.errorMessage = error.message
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    self.errorMessage = "Login failed: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func register() {
        guard model.isRegistrationFormValid else {
            errorMessage = "Please fill all required fields correctly"
            return
        }
        
        isLoading = true
        
        Task {
            do {
                let response = try await AuthAPI.shared.register(
                    firstName: model.firstName,
                    lastName: model.lastName,
                    email: model.email,
                    mobile: model.mobile,
                    password: model.password,
                    interests: model.selectedInterests
                )
                
                await MainActor.run {
                    self.isLoading = false
                    self.errorMessage = nil
                    
                    TokenManager.shared.saveToken(response.token)
                    BiometricAuthManager.shared.saveCredentials(email: model.email, password: model.password)
                    
                    self.isAuthenticated = true
                    NotificationCenter.default.post(name: NSNotification.Name("UserDidLogin"), object: nil)
                }
            } catch let error as APIError {
                await MainActor.run {
                    self.isLoading = false
                    self.errorMessage = error.message
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    self.errorMessage = "Registration failed: \(error.localizedDescription)"
                }
            }
        }
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
    
    func biometricLogin() {
        guard let email = BiometricAuthManager.shared.getSavedEmail(),
              let password = BiometricAuthManager.shared.getPassword(for: email) else {
            errorMessage = "No saved credentials found"
            return
        }
        
        BiometricAuthManager.shared.authenticate { [weak self] result in
            switch result {
            case .success:
                self?.model.email = email
                self?.model.password = password
                self?.login()
            case .failure(let error):
                self?.errorMessage = error.errorDescription
            }
        }
    }
    
    func logout() {
        TokenManager.shared.deleteToken()
        isAuthenticated = false
    }
}
