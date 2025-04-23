import SwiftUI
import LocalAuthentication

struct FaceIDLoginView: View {
    @StateObject private var viewModel = FaceIDLoginViewModel()
    @Environment(\.presentationMode) var presentationMode
    var navigateToHome: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 0) {
            Image("login")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 300)
                .clipped()
            
            VStack(alignment: .center, spacing: 24) {
                Spacer()
                
                Image(systemName: viewModel.biometricType == .faceID ? "faceid" : "touchid")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                
                Text("Login with \(viewModel.biometricType.description)")
                    .font(.system(size: 24, weight: .bold))
                
                if let savedEmail = viewModel.savedEmail {
                    Text("Welcome back, \(savedEmail)")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                }
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.system(size: 16))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                
                Button(action: {
                    viewModel.authenticateWithBiometrics { success in
                        if success {
                            navigateToHome?()
                        }
                    }
                }) {
                    Text("Authenticate")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                .padding(.top, 16)
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Use Email Instead")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.blue)
                }
                .padding(.top, 8)
                
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 40)
        }
        .edgesIgnoringSafeArea(.top)
        .background(Color(.systemGray6).edgesIgnoringSafeArea(.all))
        .onAppear {
            viewModel.checkBiometricAvailability()
        }
    }
}

class FaceIDLoginViewModel: ObservableObject {
    @Published var biometricType: BiometricType = .none
    @Published var errorMessage: String?
    @Published var savedEmail: String?
    
    init() {
        biometricType = BiometricAuthManager.shared.getBiometricType()
        savedEmail = BiometricAuthManager.shared.getSavedEmail()
    }
    
    func checkBiometricAvailability() {
        if !BiometricAuthManager.shared.canUseBiometrics() {
            errorMessage = "Biometric authentication is not available on this device."
        } else if savedEmail == nil {
            errorMessage = "No saved credentials found. Please login with email first."
        } else {
            errorMessage = nil
        }
    }
    
    func authenticateWithBiometrics(completion: @escaping (Bool) -> Void) {
        guard let email = savedEmail else {
            errorMessage = "No saved credentials found. Please login with email first."
            completion(false)
            return
        }
        
        BiometricAuthManager.shared.authenticate { [weak self] result in
            switch result {
            case .success:
                if let password = BiometricAuthManager.shared.getPassword(for: email) {
                    self?.validateCredentials(email: email, password: password, completion: completion)
                } else {
                    self?.errorMessage = "Saved password not found. Please login with email."
                    completion(false)
                }
            case .failure(let error):
                self?.errorMessage = error.errorDescription
                completion(false)
            }
        }
    }
    
    private func validateCredentials(email: String, password: String, completion: @escaping (Bool) -> Void) {
        if email == "test@example.com" && password == "password" {
            errorMessage = nil
            completion(true)
        } else {
            errorMessage = "Invalid credentials. Please login with email."
            completion(false)
        }
    }
}
