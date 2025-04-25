import SwiftUI
import LocalAuthentication

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    var navigateToHome: (() -> Void)?
    var navigateToRegister: (() -> Void)?
    
    @State private var isInitialLoad = true
    
    var body: some View {
        VStack(spacing: 0) {
            Image("login")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 300)
                .clipped()
            
            VStack(alignment: .leading, spacing: 20) {
                if viewModel.canUseBiometrics() {
                    Button(action: {
                        viewModel.showFaceIDLogin()
                    }) {
                        HStack {
                            Image(systemName: viewModel.biometricType == .faceID ? "faceid" : "touchid")
                                .font(.system(size: 20))
                                .foregroundColor(.blue)
                            
                            Text("Login with \(viewModel.biometricType.description)")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.blue)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(12)
                    }
                    .padding(.top, 8)
                }
                
                if viewModel.model.isEmailLogin {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email")
                            .font(.system(size: 16, weight: .medium))
                        
                        TextField("", text: $viewModel.model.email)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Password")
                            .font(.system(size: 16, weight: .medium))
                        
                        SecureField("", text: $viewModel.model.password)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                    }
                    
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.system(size: 14))
                            .padding(.top, 4)
                    }
                    
                    Button(action: {
                        viewModel.login()
                    }) {
                        ZStack {
                            Text("Login")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .opacity(viewModel.isLoading ? 0 : 1)
                            
                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(viewModel.model.isFormValid ? Color.blue : Color.blue.opacity(0.6))
                        .cornerRadius(12)
                    }
                    .disabled(!viewModel.model.isFormValid || viewModel.isLoading)
                    .padding(.top, 10)
                    
                    Button(action: {
                        navigateToRegister?()
                    }) {
                        Text("Register")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.blue, lineWidth: 1)
                            )
                    }
                    .padding(.top, 10)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
            
            Spacer()
            
            Rectangle()
                .frame(width: 80, height: 4)
                .cornerRadius(2)
                .foregroundColor(.gray.opacity(0.3))
                .padding(.bottom, 40)
        }
        .edgesIgnoringSafeArea(.top)
        .background(Color(.systemGray6).edgesIgnoringSafeArea(.all))
        .fullScreenCover(isPresented: $viewModel.showBiometricLogin) {
            FaceIDLoginView(navigateToHome: navigateToHome)
        }
        .onReceive(viewModel.$isAuthenticated) { isAuthenticated in
            if isAuthenticated && !isInitialLoad {
                navigateToHome?()
            }
            
            if isInitialLoad {
                isInitialLoad = false
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("UserDidLogin"))) { _ in
            navigateToHome?()
        }
    }
}
