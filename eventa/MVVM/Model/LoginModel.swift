import Foundation

struct LoginModel {
    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var mobile: String = ""
    var isEmailLogin: Bool = true
    var selectedInterests: [String] = []
    
    var isEmailValid: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    var isPasswordValid: Bool {
        return password.count >= 6
    }
    
    var isPasswordsMatch: Bool {
        return password == confirmPassword
    }
    
    var isMobileValid: Bool {
        return mobile.count >= 10
    }
    
    var isFormValid: Bool {
        if isEmailLogin {
            return isEmailValid && isPasswordValid
        } else {
            return true
        }
    }
    
    var isRegistrationFormValid: Bool {
        return isEmailValid && 
               isPasswordValid && 
               isPasswordsMatch && 
               !firstName.isEmpty && 
               !lastName.isEmpty && 
               isMobileValid && 
               !selectedInterests.isEmpty
    }
    
    var availableInterests: [String] {
        return ["Technology", "Business", "Design", "Marketing", "Health", "Education", "Sports", "Music", "Arts", "Food"]
    }
    
    mutating func toggleInterest(_ interest: String) {
        if selectedInterests.contains(interest) {
            selectedInterests.removeAll { $0 == interest }
        } else {
            selectedInterests.append(interest)
        }
    }
}
