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
            EventCategory(name: "Development", icon: "curlybraces"),
            EventCategory(name: "Music", icon: "music.note"),
            EventCategory(name: "Sports", icon: "sportscourt"),
            EventCategory(name: "Art", icon: "paintpalette"),
            EventCategory(name: "Food", icon: "fork.knife"),
            EventCategory(name: "Technology", icon: "desktopcomputer"),
            EventCategory(name: "Business", icon: "briefcase"),
            EventCategory(name: "Health", icon: "heart"),
            EventCategory(name: "Education", icon: "book")
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
        currentStep += 1
    }
    
    func goToPreviousStep() {
        if currentStep > 0 {
            currentStep -= 1
        }
    }
    
    func completeRegistration() {
        
    }
    
    func viewPrivacyPolicy() {
        
    }
    
    func viewTermsConditions() {
        
    }
}
