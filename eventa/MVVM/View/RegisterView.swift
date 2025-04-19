import SwiftUI
import Combine

struct RegisterView: View {
    @StateObject private var viewModel = RegisterViewModel()
    var navigateToLogin: () -> Void
    var onRegistrationComplete: () -> Void
    
    init(navigateToLogin: @escaping () -> Void, onRegistrationComplete: @escaping () -> Void) {
        self.navigateToLogin = navigateToLogin
        self.onRegistrationComplete = onRegistrationComplete
    }
    
    var body: some View {
        VStack(spacing: 20) {
            if viewModel.currentStep < 2 {
                Text(viewModel.model.title)
                    .font(.system(size: 24, weight: .bold))
                    .padding(.top, 40)
                
                Text(viewModel.model.subtitle)
                    .font(.system(size: 16))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 20)
            }
            
            if viewModel.currentStep == 0 {
                personalDetailsView
            } else if viewModel.currentStep == 1 {
                accountDetailsView
            } else {
                interestsView
            }
            
            Spacer()
            
            Button(action: {
                if viewModel.currentStep < 2 {
                    viewModel.goToNextStep()
                } else {
                    // Handle registration completion
                    viewModel.completeRegistration()
                    onRegistrationComplete()
                }
            }) {
                Text(viewModel.currentStep == 2 ? viewModel.model.finishButtonText : viewModel.model.nextButtonText)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 24)
            
            if viewModel.currentStep == 0 {
                Button(action: {
                    navigateToLogin()
                }) {
                    Text(viewModel.model.loginButtonText)
                        .font(.system(size: 16))
                        .foregroundColor(.blue)
                        .padding(.vertical, 12)
                }
                .padding(.bottom, 20)
            } else {
                Button(action: {
                    viewModel.goToPreviousStep()
                }) {
                    Text(viewModel.model.backButtonText)
                        .font(.system(size: 16))
                        .foregroundColor(.blue)
                        .padding(.vertical, 12)
                }
                .padding(.bottom, 20)
            }
        }
    }
    
    private var personalDetailsView: some View {
        VStack {
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
        }
    }
    
    private var accountDetailsView: some View {
        VStack {
            HStack(spacing: 8) {
                Text(viewModel.model.accountDetailsTitle)
                    .font(.system(size: 18, weight: .medium))
                
                Spacer()
                
                HStack(spacing: 4) {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 10, height: 10)
                    
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 10, height: 10)
                    
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 10, height: 10)
                }
            }
            .padding(.horizontal, 24)
            
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(viewModel.model.passwordLabel)
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                    
                    SecureField("", text: $viewModel.password)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(viewModel.model.confirmPasswordLabel)
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                    
                    SecureField("", text: $viewModel.confirmPassword)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                }
                
                VStack(spacing: 16) {
                    Button(action: {
                        viewModel.viewPrivacyPolicy()
                    }) {
                        Text(viewModel.model.privacyPolicyText)
                            .font(.system(size: 14))
                            .foregroundColor(.blue)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Button(action: {
                        viewModel.viewTermsConditions()
                    }) {
                        Text(viewModel.model.termsConditionsText)
                            .font(.system(size: 14))
                            .foregroundColor(.blue)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(viewModel.model.privacyDisclaimerText)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                        .padding(.top, 8)
                }
            }
            .padding(.horizontal, 24)
        }
    }
    
    private var interestsView: some View {
        VStack {
            HStack(spacing: 8) {
                Text(viewModel.model.interestsTitle)
                    .font(.system(size: 24, weight: .bold))
                
                Spacer()
                
                HStack(spacing: 4) {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 10, height: 10)
                    
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 10, height: 10)
                    
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 10, height: 10)
                }
            }
            .padding(.horizontal, 24)
            
            Text(viewModel.model.interestsSubtitle)
                .font(.system(size: 16))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
                .foregroundColor(.secondary)
                .padding(.vertical, 16)
            
            Text(viewModel.model.categoriesMinimumText)
                    .font(.system(size: 16, weight: .medium))
            .padding(.horizontal, 24)
            .padding(.top, 8)
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(0..<viewModel.eventCategories.count, id: \.self) { index in
                        let category = viewModel.eventCategories[index]
                        CategoryItemView(category: category) {
                            viewModel.toggleCategorySelection(for: category)
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
            }
        }
    }
    
    struct CategoryItemView: View {
        let category: EventCategory
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                VStack(spacing: 12) {
                    Image(systemName: category.icon)
                        .font(.system(size: 32))
                        .foregroundColor(category.isSelected ? .white : .black)
                    
                    Text(category.name)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(category.isSelected ? .white : .black)
                }
                .frame(height: 100)
                .frame(maxWidth: .infinity)
                .background(category.isSelected ? Color.blue : Color.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
            }
        }
    }
}
