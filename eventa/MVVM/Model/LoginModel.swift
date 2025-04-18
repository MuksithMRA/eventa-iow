import Foundation

struct LoginModel {
    var email: String = ""
    var password: String = ""
    var isEmailLogin: Bool = true
    
    var isEmailValid: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    var isPasswordValid: Bool {
        return password.count >= 6
    }
    
    var isFormValid: Bool {
        if isEmailLogin {
            return isEmailValid && isPasswordValid
        } else {
            return true
        }
    }
}
