import Foundation
import SwiftUI
import Combine

class LoginViewModel: ObservableObject {
    @Published var model = LoginModel()
    @Published var isLoading = false
    @Published var errorMessage: String?
    
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
}
