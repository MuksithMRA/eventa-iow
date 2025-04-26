import Foundation
import SwiftUI
import Combine

class RegisterViewModel: ObservableObject {
    @Published var model: RegisterModel
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var mobileNumber: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var currentStep: Int = 0
    @Published var agreeToTerms: Bool = false
    @Published var eventCategories: [EventCategory] = []
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var isRegistered: Bool = false
    

    
    init() {
        self.model = RegisterModel(
            title: "Register",
            subtitle: "Join the community, explore events, and never miss out! 🎉 Register now!",
            personalDetailsTitle: "Personal Details",
            accountDetailsTitle: "Account Details",
            interestsTitle: "Tell us about your interests",
            interestsSubtitle: "Tell us what excites you! 😄🎸 Choose your favorite event categories and explore the best experiences!",
            categoriesMinimumText: "Choose at least 3 Categories",
            firstNameLabel: "First Name",
            lastNameLabel: "Last Name",
            emailLabel: "Email",
            mobileNumberLabel: "Mobile Number",
            passwordLabel: "Password",
            confirmPasswordLabel: "Confirm Password",
            privacyPolicyText: "View privacy policy",
            termsConditionsText: "View Terms & Conditions",
            privacyDisclaimerText: "By clicking on next you will agree with privacy policies, terms and conditions",
            nextButtonText: "Next",
            backButtonText: "Back",
            loginButtonText: "Go to Login",
            finishButtonText: "Finish"
        )
        
        setupEventCategories()
    }
    
    private func setupEventCategories() {
        eventCategories = [
            EventCategory(name: "Technology", icon: "desktopcomputer"),
            EventCategory(name: "Business", icon: "briefcase"),
            EventCategory(name: "Design", icon: "pencil.and.ruler"),
            EventCategory(name: "Marketing", icon: "megaphone"),
            EventCategory(name: "Health", icon: "heart"),
            EventCategory(name: "Education", icon: "book"),
            EventCategory(name: "Sports", icon: "sportscourt"),
            EventCategory(name: "Music", icon: "music.note"),
            EventCategory(name: "Arts", icon: "paintpalette"),
            EventCategory(name: "Food", icon: "fork.knife")
        ]
    }
    
    func toggleCategorySelection(for category: EventCategory) {
        if let index = eventCategories.firstIndex(where: { $0.id == category.id }) {
            eventCategories[index].isSelected.toggle()
        }
    }
    
    func getSelectedCategories() -> [EventCategory] {
        return eventCategories.filter { $0.isSelected }
    }
    
    var hasMinimumCategoriesSelected: Bool {
        return getSelectedCategories().count >= 3
    }
    
    func goToNextStep() {
        if validateCurrentStep() {
            currentStep += 1
            errorMessage = nil
        }
    }
    
    func goToPreviousStep() {
        if currentStep > 0 {
            currentStep -= 1
        }
    }
    
    func completeRegistration() {
        guard validateRegistration() else { return }
        
        let selectedInterests = getSelectedCategories().map { $0.name }
        
        Task {
            do {
                isLoading = true
                errorMessage = nil
                
                let response = try await AuthAPI.shared.register(
                    firstName: firstName,
                    lastName: lastName,
                    email: email,
                    mobile: mobileNumber,
                    password: password,
                    interests: selectedInterests
                )
                
                await MainActor.run {
                    TokenManager.shared.saveToken(response.token)
                    isLoading = false
                    isRegistered = true
                    print("Registration successful - isRegistered set to \(isRegistered)")
                }
            } catch let error as APIError {
                await MainActor.run {
                    isLoading = false
                    errorMessage = error.message
                    print("Registration failed with API error: \(error.message)")
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    errorMessage = "An unexpected error occurred. Please try again."
                    print("Registration failed with unexpected error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func viewPrivacyPolicy() {
        
    }
    
    func viewTermsConditions() {
        
    }
    
    private func validateCurrentStep() -> Bool {
        switch currentStep {
        case 0:
            return validatePersonalDetails()
        case 1:
            return validateAccountDetails()
        case 2:
            return validateInterests()
        default:
            return false
        }
    }
    
    private func validatePersonalDetails() -> Bool {
        if firstName.isEmpty {
            errorMessage = "Please enter your first name"
            return false
        }
        
        if lastName.isEmpty {
            errorMessage = "Please enter your last name"
            return false
        }
        
        if !isValidEmail(email) {
            errorMessage = "Please enter a valid email address"
            return false
        }
        
        if mobileNumber.isEmpty || mobileNumber.count < 10 {
            errorMessage = "Please enter a valid mobile number"
            return false
        }
        
        return true
    }
    
    private func validateAccountDetails() -> Bool {
        if password.isEmpty {
            errorMessage = "Please enter a password"
            return false
        }
        
        if password.count < 6 {
            errorMessage = "Password must be at least 6 characters"
            return false
        }
        
        if confirmPassword.isEmpty {
            errorMessage = "Please confirm your password"
            return false
        }
        
        if password != confirmPassword {
            errorMessage = "Passwords do not match"
            return false
        }
        
        if !agreeToTerms {
            errorMessage = "You must agree to the terms and conditions"
            return false
        }
        
        return true
    }
    
    private func validateInterests() -> Bool {
        if !hasMinimumCategoriesSelected {
            errorMessage = "Please select at least 3 categories"
            return false
        }
        
        return true
    }
    
    private func validateRegistration() -> Bool {
        if !validatePersonalDetails() {
            currentStep = 0
            return false
        }
        
        if !validateAccountDetails() {
            currentStep = 1
            return false
        }
        
        if !validateInterests() {
            currentStep = 2
            return false
        }
        
        return true
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
