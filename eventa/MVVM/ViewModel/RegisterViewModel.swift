import Foundation
import SwiftUI

class RegisterViewModel: ObservableObject {
    @Published var model: RegisterModel
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var mobileNumber: String = ""
    @Published var currentStep: Int = 0
    
    init() {
        self.model = RegisterModel(
            title: "Register",
            subtitle: "Join the community, explore events, and never miss out! 🎉 Register now!",
            personalDetailsTitle: "Personal Details",
            firstNameLabel: "First Name",
            lastNameLabel: "Last Name",
            emailLabel: "Email",
            mobileNumberLabel: "Mobile Number",
            nextButtonText: "Next",
            loginButtonText: "Go to Login"
        )
    }
    
    func goToNextStep() {
        currentStep += 1
    }
}
