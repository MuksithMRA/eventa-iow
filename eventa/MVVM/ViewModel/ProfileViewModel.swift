import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var model = ProfileModel()
    @Published var selectedTab: Int = 3
    @Published var isPremiumUser: Bool = true
    
    func handleMenuItemTap(_ menuItem: MenuItem) {
        switch menuItem.title {
        case "Edit Profile":
            editProfile()
        case "My Events":
            viewMyEvents()
        case "Saved Events":
            viewSavedEvents()
        case "Notifications":
            viewNotifications()
        case "Payment Methods":
            managePaymentMethods()
        case "Settings":
            openSettings()
        case "Help Center":
            openHelpCenter()
        case "Logout":
            logout()
        default:
            break
        }
    }
    
    func editProfile() {
        print("Edit profile tapped")
    }
    
    func viewMyEvents() {
        print("My events tapped")
    }
    
    func viewSavedEvents() {
        print("Saved events tapped")
    }
    
    func viewNotifications() {
        print("Notifications tapped")
    }
    
    func managePaymentMethods() {
        print("Payment methods tapped")
    }
    
    func openSettings() {
        print("Settings tapped")
    }
    
    func openHelpCenter() {
        print("Help center tapped")
    }
    
    func logout() {
        print("Logout tapped")
    }
    
    func viewEventDetails(_ event: ProfileEvent) {
        print("View event details: \(event.title)")
    }
}
