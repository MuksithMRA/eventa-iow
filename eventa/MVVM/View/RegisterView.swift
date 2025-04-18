import SwiftUI
import Combine

struct RegisterView: View {
    @StateObject private var viewModel = RegisterViewModel()
    var navigateToLogin: () -> Void
    
    init(navigateToLogin: @escaping () -> Void) {
        self.navigateToLogin = navigateToLogin
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text(viewModel.model.title)
                .font(.system(size: 24, weight: .bold))
                .padding(.top, 40)
            
            Text(viewModel.model.subtitle)
                .font(.system(size: 16))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
                .foregroundColor(.secondary)
                .padding(.bottom, 20)
            
            HStack(spacing: 8) {
                Text(viewModel.model.personalDetailsTitle)
                    .font(.system(size: 18, weight: .medium))
                
                Spacer()
                
                HStack(spacing: 4) {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 10, height: 10)
                    
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 10, height: 10)
                    
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 10, height: 10)
                }
            }
            .padding(.horizontal, 24)
            
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(viewModel.model.firstNameLabel)
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                    
                    TextField("", text: $viewModel.firstName)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(viewModel.model.lastNameLabel)
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                    
                    TextField("", text: $viewModel.lastName)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(viewModel.model.emailLabel)
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                    
                    TextField("", text: $viewModel.email)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(viewModel.model.mobileNumberLabel)
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                    
                    TextField("", text: $viewModel.mobileNumber)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        .keyboardType(.phonePad)
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
            
            Button(action: {
                viewModel.goToNextStep()
            }) {
                Text(viewModel.model.nextButtonText)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 24)
            
            Button(action: {
                navigateToLogin()
            }) {
                Text(viewModel.model.loginButtonText)
                    .font(.system(size: 16))
                    .foregroundColor(.blue)
                    .padding(.vertical, 12)
            }
            .padding(.bottom, 20)
        }
    }
}
